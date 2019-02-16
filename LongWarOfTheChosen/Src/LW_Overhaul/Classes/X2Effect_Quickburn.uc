//--------------------------------------------------------------------------------------
//  FILE:    X2Effect_Quickburn.uc
//  AUTHOR:  Aminer (Pavonis Interactive)
//  PURPOSE: Grants an 1 turn effect that the next use of FT is a free action
//--------------------------------------------------------------------------------------- 

class X2Effect_Quickburn extends X2Effect_Persistent;

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local name						AbilityName;
	local XComGameState_Ability		AbilityState;
	local bool						bFreeActivation;
	
	if(kAbility == none)
		return false;
	AbilityName = kAbility.GetMyTemplateName();
	switch (AbilityName)
	{
		case 'LWFlamethrower':
		case 'Roust':
		case 'Firestorm':
			bFreeActivation = true;
			break;
		default:
			bFreeActivation = false;
			break;
	}
	if (bFreeActivation)
	{
		if (SourceUnit.ActionPoints.Length != PreCostActionPoints.Length)
		{
			AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
			if (AbilityState != none)
			{
				SourceUnit.ActionPoints = PreCostActionPoints;
				EffectState.RemoveEffect(NewGameState, NewGameState);
				`XEVENTMGR.TriggerEvent('Quickburn', AbilityState, SourceUnit, NewGameState);
				return true;
			}
		}
	}
	return false;
}