//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_Paramedic.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: Makes each medikit use free this turn
//--------------------------------------------------------------------------------------- 

class X2Effect_Paramedic extends X2Effect_Persistent config (LW_SoldierSkills);

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local XComGameState_Item	SourceWeapon;
	local int iUsesThisTurn;
	local UnitValue PMUsesThisTurn;

	if (kAbility == none)
	{
		return false;
	}

	SourceWeapon = kAbility.GetSourceWeapon();


	SourceUnit.GetUnitValue('ParamedicUses', PMUsesThisTurn);
	iUsesThisTurn = int(PMUsesThisTurn.fValue);

	if (iUsesThisTurn > 0)
	{
		return false;
	}

	if (SourceWeapon.GetWeaponCategory() == class'X2Item_DefaultUtilityItems'.default.MedikitCat)
	{
		if (SourceUnit.ActionPoints.Length != PreCostActionPoints.Length)
		{
			SourceUnit.SetUnitFloatValue('ParamedicUses', 1.0, eCleanup_BeginTurn);
			SourceUnit.ActionPoints = PreCostActionPoints;

			return true;
		}
	}
	return false;
}
