//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_ShadowRising_LW
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Reduces the cooldown of Shadow by 1.
//---------------------------------------------------------------------------------------

class X2Effect_ShadowRising_LW extends X2Effect_Persistent;

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	if (kAbility.GetMyTemplateName() != 'Shadow')
		return false;

	kAbility.iCooldown -= 1;
	return false;
}
