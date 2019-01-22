class X2Effect_DeathFromAbove_LW extends X2Effect_DeathFromAbove config (LW_SoldierSkills);

var config bool ALLOW_DFA_DT_COMBO;

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
    local XComGameStateHistory History;
    local XComGameState_Unit TargetUnit, PrevTargetUnit;
    local X2EventManager EventMgr;
    local XComGameState_Ability AbilityState;

    if(SourceUnit.IsUnitAffectedByEffectName(class'X2Effect_Serial'.default.EffectName))
    {
        return false;
    }

	if(kAbility.GetMyTemplateName() == 'DoubleTap2' && !default.ALLOW_DFA_DT_COMBO)
	{
		return false;
	}

    if(kAbility.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef)
    {
        History = class'XComGameStateHistory'.static.GetGameStateHistory();
        TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
        if(TargetUnit != none)
        {
            PrevTargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(TargetUnit.ObjectID));
            if((TargetUnit.IsDead() && PrevTargetUnit != none) && SourceUnit.HasHeightAdvantageOver(PrevTargetUnit, true))
            {
                if(SourceUnit.NumActionPoints() == 0 && PreCostActionPoints.Length > 0)
                {
                    AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
                    if(AbilityState != none)
                    {
                        SourceUnit.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
                        EventMgr = class'X2EventManager'.static.GetEventManager();
                        EventMgr.TriggerEvent('DeathFromAbove', AbilityState, SourceUnit, NewGameState);
                    }
                }
            }
        }
    }
    return false;
}