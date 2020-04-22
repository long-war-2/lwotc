//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_CritRemoval
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Downgrades crits to normal hits when using a given ability.
//--------------------------------------------------------------------------------------- 

class X2Effect_CritRemoval extends X2Effect_Persistent;

var const name CritRemovedValueName;
var name AbilityToActOn;

function bool ChangeHitResultForAttacker(XComGameState_Unit Attacker, XComGameState_Unit TargetUnit, XComGameState_Ability AbilityState, const EAbilityHitResult CurrentResult, out EAbilityHitResult NewHitResult)
{
	if (CurrentResult == eHit_Crit && AbilityState.GetMyTemplateName() == AbilityToActOn)
	{
		TargetUnit.SetUnitFloatValue(default.CritRemovedValueName, 1.0, eCleanup_BeginTurn);
		NewHitResult = eHit_Success;
		return true;
	}

	return false;
}

defaultproperties
{
	CritRemovedValueName=CritRemovedFromShot
}
