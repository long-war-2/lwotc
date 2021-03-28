//--------------------------------------------------------------------------------------- 
//  FILE:    X2Condition_Phosphorus.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Custom condition that allows damage units with fire immunity
//---------------------------------------------------------------------------------------
class X2Condition_Phosphorus extends X2Condition;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{ 
	local XComGameState_Unit SourceUnit, TargetUnit;

	SourceUnit = XComGameState_Unit(kSource);
	TargetUnit = XComGameState_Unit(kTarget);

	if (SourceUnit == none || TargetUnit == none)
		return 'AA_AbilityUnavailable';

	if (SourceUnit.FindAbility('PhosphorusPassive').ObjectID == 0)
	{
		if (TargetUnit.IsImmuneToDamage('Fire'))
			return 'AA_UnitIsImmune';
	}

	return 'AA_Success';
}
