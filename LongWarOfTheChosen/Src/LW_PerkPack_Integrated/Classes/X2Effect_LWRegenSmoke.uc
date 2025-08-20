class X2Effect_LWRegenSmoke extends X2Effect_LWAdditionalSmokeEffect;

var config int HealAmount;
var config int MaxHealAmount;
var config bool bApplyToBleedingOutUnits;
var name HealthRegeneratedName;
var name EventToTriggerOnHeal;

function bool RegenerationTicked(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication)
{
    local XComGameState_Unit OldTargetState, NewTargetState;
    local UnitValue HealthRegenerated;
    local int AmountToHeal, Healed;
    
    OldTargetState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    if (OldTargetState != none && OldTargetState.IsInWorldEffectTile(default.WorldEffectClass.Name))
    {
        if (!bApplyToBleedingOutUnits && OldTargetState.IsBleedingOut() || OldTargetState.IsDead())
            return false;

        if (HealthRegeneratedName != '' && MaxHealAmount > 0)
        {
            OldTargetState.GetUnitValue(HealthRegeneratedName, HealthRegenerated);

            // If the unit has already been healed the maximum number of times, do not regen
            if (HealthRegenerated.fValue >= MaxHealAmount)
            {
                return false;
            }
            else
            {
                // Ensure the unit is not healed for more than the maximum allowed amount
                AmountToHeal = min(HealAmount, (MaxHealAmount - HealthRegenerated.fValue));
            }
        }
        else
        {
            // If no value tracking for health regenerated is set, heal for the default amount
            AmountToHeal = HealAmount;
        }

        // Perform the heal
        NewTargetState = XComGameState_Unit(NewGameState.ModifyStateObject(OldTargetState.Class, OldTargetState.ObjectID));
        NewTargetState.ModifyCurrentStat(estat_HP, AmountToHeal);

        if (EventToTriggerOnHeal != '')
        {
            `XEVENTMGR.TriggerEvent(EventToTriggerOnHeal, NewTargetState, NewTargetState, NewGameState);
        }

        // If this health regen is being tracked, save how much the unit was healed
        if (HealthRegeneratedName != '')
        {
            Healed = NewTargetState.GetCurrentStat(eStat_HP) - OldTargetState.GetCurrentStat(eStat_HP);
            if (Healed > 0)
            {
                NewTargetState.SetUnitFloatValue(HealthRegeneratedName, HealthRegenerated.fValue + Healed, eCleanup_BeginTactical);
                
            }
        }
    }

    return false;
}

simulated function AddX2ActionsForVisualization_Tick(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const int TickIndex, XComGameState_Effect EffectState)
{
    local XComGameState_Unit OldUnit, NewUnit;
    local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
    local int Healed;
    local string Msg;

    OldUnit = XComGameState_Unit(ActionMetadata.StateObject_OldState);
    NewUnit = XComGameState_Unit(ActionMetadata.StateObject_NewState);

    Healed = NewUnit.GetCurrentStat(eStat_HP) - OldUnit.GetCurrentStat(eStat_HP);
    
    if (Healed > 0)
    {
        SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
        Msg = Repl(class'X2Effect_Regeneration'.default.HealedMessage, "<Heal/>", Healed);
        SoundAndFlyOver.SetSoundAndFlyOverParameters(none, Msg, '', eColor_Good);
    }
}

static function X2Effect RegenSmokeEffect(optional bool bSkipAbilityCheck)
{
    local X2Effect_LWRegenSmoke         Effect;
    local X2Condition_AbilityProperty   AbilityCondition;
    local X2Condition_UnitProperty      UnitPropertyCondition;
    local X2Condition_UnitStatCheck     UnitStatCheckCondition;

    Effect = new class'X2Effect_LWRegenSmoke';
    Effect.BuildPersistentEffect(class'X2Effect_ApplySmokeGrenadeToWorld'.default.Duration + 1, false, false, false, eGameRule_PlayerTurnBegin);
    Effect.SetDisplayInfo(ePerkBuff_Bonus,
        default.strEffectBonusName,
        default.strEffectBonusDesc,
        "img:///UILibrary_XPerkIconPack.UIPerk_smoke_medkit",
        true,,'eAbilitySource_Perk');

    UnitPropertyCondition = new class'X2Condition_UnitProperty';
    UnitPropertyCondition.ExcludeDead = false;
    UnitPropertyCondition.ExcludeHostileToSource = false;
    UnitPropertyCondition.ExcludeFriendlyToSource = false;
    UnitPropertyCondition.ExcludeRobotic = true;
    UnitPropertyCondition.ExcludeTurret = true;
    UnitPropertyCondition.FailOnNonUnits = true;
    Effect.TargetConditions.AddItem(UnitPropertyCondition);

    UnitStatCheckCondition = new class'X2Condition_UnitStatCheck';
    UnitStatCheckCondition.AddCheckStat(eStat_HP, 0, eCheck_GreaterThan);
    Effect.TargetConditions.AddItem(UnitStatCheckCondition);

    if (!bSkipAbilityCheck)
    {
        AbilityCondition = new class'X2Condition_AbilityProperty';
        AbilityCondition.OwnerHasSoldierAbilities.AddItem(class'X2Effect_LWApplyRegenSmokeToWorld'.default.RelevantAbilityName);
        Effect.TargetConditions.AddItem(AbilityCondition);
    }

    return Effect;
}

defaultproperties
{
    HealthRegeneratedName = RegenSmoke_LW_HealthRegenerated
    EffectTickedFn = RegenerationTicked

    EffectName = RegenSmoke_LW
    WorldEffectClass = class'X2Effect_LWApplyRegenSmokeToWorld'
}