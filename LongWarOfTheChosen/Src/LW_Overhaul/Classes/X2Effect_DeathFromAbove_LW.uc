class X2Effect_DeathFromAbove_LW extends X2Effect_DeathFromAbove config (LW_SoldierSkills);

var config bool ALLOW_DFA_DT_COMBO;
var config int DFA_USES_PER_TURN;

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
    local XComGameStateHistory History;
    local XComGameState_Unit TargetUnit, PrevTargetUnit;
    local X2EventManager EventMgr;
    local XComGameState_Ability AbilityState;
	local UnitValue DFAUsesThisTurn;
	local int iUsesThisTurn;

    if(SourceUnit.IsUnitAffectedByEffectName(class'X2Effect_Serial'.default.EffectName))
    {
        return false;
    }

	// Don't proc on a Skirmisher interrupt turn (for example with Battle Lord)
	if (class'Helpers_LW'.static.IsUnitInterruptingEnemyTurn(SourceUnit))
		return false;

	// Block repeated uses of DFA by default.
	// CREDIT TO: Favid ([WOTC] LW2 Classes and Perks)
	SourceUnit.GetUnitValue('LW_DeathFromAboveUses', DFAUsesThisTurn);
	iUsesThisTurn = int(DFAUsesThisTurn.fValue);
	if (iUsesThisTurn >= default.DFA_USES_PER_TURN)
	{
		return false;
	}

	if(kAbility.GetMyTemplateName() == 'DoubleTap2')
	{
        if (!default.ALLOW_DFA_DT_COMBO)
        {
            return false;
        }
        else
        {
            // Treat this as a free DfA usage so that the second
            // shot can also proc DfA.
            iUsesThisTurn--;
        }
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
						SourceUnit.SetUnitFloatValue('LW_DeathFromAboveUses', iUsesThisTurn + 1.0, eCleanup_BeginTurn);
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
