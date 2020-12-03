//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_ShadowGrenadier
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: An effect that allows the affected unit to throw or launch grenades
//           without breaking Shadow.
//---------------------------------------------------------------------------------------

class X2Effect_ShadowGrenadier extends X2Effect_Persistent;

function bool AdjustSuperConcealModifier(XComGameState_Unit UnitState, XComGameState_Effect EffectState, XComGameState_Ability AbilityState, XComGameState RespondToGameState, const int BaseModifier, out int Modifier)
{
	local XComGameState SuperConcealedState;

	if (RespondToGameState == none)
		return false;	// nothing special is previewed for this effect

	if (AbilityState.GetMyTemplateName() == 'ThrowGrenade' || AbilityState.GetMyTemplateName() == 'LaunchGrenade')
	{
		Modifier = 0;

		if (UnitState.SuperConcealmentLoss > 0)
		{
			// Reset the super concealment loss to 0
			SuperConcealedState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Shadow Grenadier super concealment reset");
			UnitState = XComGameState_Unit(SuperConcealedState.ModifyStateObject(UnitState.Class, UnitState.ObjectID));
			UnitState.SuperConcealmentLoss = 0;
			`TACTICALRULES.SubmitGameState(SuperConcealedState);
		}
		return true;
	}

	return false;
}
