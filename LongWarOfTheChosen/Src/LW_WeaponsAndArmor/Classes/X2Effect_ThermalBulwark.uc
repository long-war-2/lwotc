class X2Effect_ThermalBulwark extends X2Effect_Persistent;

var int Chance;

function bool ChangeHitResultForTarget(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit TargetUnit, XComGameState_Ability AbilityState, bool bIsPrimaryTarget, const EAbilityHitResult CurrentResult, out EAbilityHitResult NewHitResult)
{
	local int RandRoll;

	//	don't change a natural miss
	if (!class'XComGameStateContext_Ability'.static.IsHitResultHit(CurrentResult))
		return false;

	//Chance = default.DeflectBaseChance + ((FocusLevel - 1) * default.DeflectPerFocusChance);
	RandRoll = `SYNC_RAND(100);
	if (RandRoll <= Chance)
	{
		//`log("Deflect chance was" @ Chance @ "rolled" @ RandRoll @ "- success!", , 'XCom_HitRolls');
		NewHitResult = eHit_Deflect;
		return true;
	}
}