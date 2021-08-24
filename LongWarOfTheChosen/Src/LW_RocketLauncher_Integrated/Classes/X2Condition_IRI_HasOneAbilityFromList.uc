class X2Condition_IRI_HasOneAbilityFromList extends X2Condition;

var array<name> AbilityNames;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	local XComGameState_Unit	UnitState;
	local name					AbilityName;

	UnitState = XComGameState_Unit(kTarget);

	if (UnitState != none)
	{
		foreach AbilityNames(AbilityName)
		{
			if (UnitState.HasSoldierAbility(AbilityName, true)) return 'AA_Success';
		}
	}
	else return 'AA_NotAUnit';
	
	return 'AA_AbilityUnavailable';
}