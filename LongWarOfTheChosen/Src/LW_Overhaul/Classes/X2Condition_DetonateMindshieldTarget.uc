class X2Condition_DetonateMindshieldTarget extends X2Condition config(GameData_SoldierSkills);

var config array<name> DetonateMindshieldAbilities;

static function bool GetAvailableDetonateMindshield(XComGameState_Unit TargetUnit, optional out StateObjectReference DetonateMindshieldTargetAbility)
{
	local StateObjectReference AbilityRef;
	local name AbilityName;
	local array<StateObjectReference> ExcludeWeapons;
	local XComGameState_Ability AbilityState;
	local XComGameStateHistory History;

	if (TargetUnit == none)
		return false;

	History = `XCOMHISTORY;

	foreach default.DetonateMindshieldAbilities(AbilityName)
	{
		ExcludeWeapons.Length = 0;
		AbilityRef = TargetUnit.FindAbility(AbilityName);
		while (AbilityRef.ObjectID != 0)
		{
			AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityRef.ObjectID));
			if (AbilityState.CanActivateAbility(TargetUnit) == 'AA_Success')
			{
				DetonateMindshieldTargetAbility = AbilityRef;
				return true;
			}
			ExcludeWeapons.AddItem(AbilityState.SourceWeapon);
			AbilityRef = TargetUnit.FindAbility(AbilityName, , ExcludeWeapons);
		}
	}

	return false; 
}

event name CallMeetsCondition(XComGameState_BaseObject kTarget) 
{ 
	local XComGameState_Unit TargetUnit;

	TargetUnit = XComGameState_Unit(kTarget);
	if (TargetUnit == none)
		return 'AA_NotAUnit';

	if (TargetUnit.IsDeadFromSpecialDeath())
		return 'AA_TargetHasNoLoot';

	if (GetAvailableDetonateMindshield(TargetUnit))
		return 'AA_Success';

	return 'AA_TargetHasNoLoot';
}

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource) 
{ 
	local XComGameState_Unit TargetUnit, SourceUnit;

	TargetUnit = XComGameState_Unit(kTarget);
	SourceUnit = XComGameState_Unit(kSource);
	if (TargetUnit == none || SourceUnit == none)
		return 'AA_NotAUnit';

	if (SourceUnit.IsFriendlyUnit(TargetUnit))
		return 'AA_UnitIsFriendly';

	return 'AA_Success'; 
}
