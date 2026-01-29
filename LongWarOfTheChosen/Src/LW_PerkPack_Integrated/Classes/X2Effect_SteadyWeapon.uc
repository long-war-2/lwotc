class X2Effect_SteadyWeapon extends X2Effect_Persistent;

var int Aim_Bonus;
var int Crit_Bonus;
var int Upgrade_Empower_Bonus;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager        EventMgr;
    local XComGameState_Unit    UnitState;
    local Object                EffectObj;

    EventMgr = `XEVENTMGR;

    EffectObj = EffectGameState;
    UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', SteadyWeaponListener, ELD_OnStateSubmitted, 50, UnitState,, EffectObj);
    EventMgr.RegisterForEvent(EffectObj, 'UnitTakeEffectDamage', SteadyWeaponListener, ELD_OnStateSubmitted, 51, UnitState,, EffectObj);
    EventMgr.RegisterForEvent(EffectObj, 'ImpairingEffect', SteadyWeaponListener, ELD_OnStateSubmitted, 52, UnitState,, EffectObj);
}

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Unit    UnitState;
    local UnitValue             AttacksThisTurn;

    // This will stop Deep Cover from triggering when after using Steady Weapon
    // Otherwise the effect will be removed by Hunker Down
    UnitState = XComGameState_Unit(kNewTargetState);
    UnitState.GetUnitValue('AttacksThisTurn', AttacksThisTurn);
    UnitState.SetUnitFloatValue('AttacksThisTurn', AttacksThisTurn.fValue + 1.0, eCleanup_BeginTurn);

    super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

function bool IsThisEffectBetterThanExistingEffect(const out XComGameState_Effect ExistingEffect)
{
    return true;
}

static function EventListenerReturn SteadyWeaponListener(Object EventData, Object EventSource, XComGameState GameState, name EventID, Object CallbackData)
{
    local XComGameStateContext_Ability          AbilityContext;
    local XComGameState_Effect                  EffectState;
    local XComGameState_Ability                 AbilityState;
    local X2AbilityTemplate                     AbilityTemplate;
    local XComGameStateContext_EffectRemoved    RemoveContext;
    local XComGameState                         NewGameState;
    local X2AbilityCost                         Cost;
    local bool                                  bShouldRemove;

    EffectState = XComGameState_Effect(CallbackData);
    if (EffectState != none && !EffectState.bRemoved)
    {
        AbilityState = XComGameState_Ability(EventData);
        if (AbilityState != none)
        {
            if (AbilityState.ObjectID != EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID)
            {
                AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
                if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
                {
                    AbilityTemplate = AbilityState.GetMyTemplate();
                    if (AbilityTemplate.Hostility == eHostility_Offensive)
                    {
                        bShouldRemove = true;
                    }
                    else
                    {
                        foreach AbilityTemplate.AbilityCosts(Cost)
                        {
                            if (!Cost.bFreeCost)
                            {
                                if (X2AbilityCost_ActionPoints(Cost) != none || X2AbilityCost_ReserveActionPoints(Cost) != none)
                                {
                                    bShouldRemove = true;
                                    break;
                                }
                            }
                        }
                    }
                }
            }
        }
        else
        {
            bShouldRemove = true;
        }
        if (bShouldRemove)
        {
            RemoveContext = class'XComGameStateContext_EffectRemoved'.static.CreateEffectRemovedContext(EffectState);
            NewGameState = `XCOMHISTORY.CreateNewGameState(true, RemoveContext);
            EffectState.RemoveEffect(NewGameState, GameState);
            `TACTICALRULES.SubmitGameState(NewGameState);
            return ELR_NoInterrupt;
        }
    }
}

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo ShotInfo;
    local XComGameState_HeadquartersXCom XComHQ;

    if (!bMelee && AbilityState.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef)
    {
        XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

        ShotInfo.ModType = eHit_Success;
        ShotInfo.Reason = FriendlyName;
        ShotInfo.Value = Aim_Bonus;
        ShotInfo.Value += (XComHQ.bEmpoweredUpgrades ? Upgrade_Empower_Bonus : 0);
        ShotModifiers.AddItem(ShotInfo);

        ShotInfo.ModType = eHit_Crit;
        ShotInfo.Reason = FriendlyName;
        ShotInfo.Value = Crit_Bonus;
        ShotInfo.Value += (XComHQ.bEmpoweredUpgrades ? Upgrade_Empower_Bonus : 0);
        ShotModifiers.AddItem(ShotInfo);
    }

}

defaultproperties
{
    EffectName="SteadyWeapon"
}
