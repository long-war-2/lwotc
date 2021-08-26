class X2Condition_OverwatchMark extends X2Condition;

`include(LW_PerkPack_Integrated\LW_PerkPack.uci)// This is an Unreal Script

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
	local XComGameState_Unit AttackingUnit, TargetUnit;
	local name TestValueName;
	local UnitValue OWMarkValue;

	AttackingUnit = XComGameState_Unit(`XCOMHistory.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));
	TargetUnit = XComGameState_Unit(kTarget);

	if (AttackingUnit == none)
	{
		`LOG (" X2Condition_OverwatchMark: No Attacking Unit Found");
	}

	if (TargetUnit == none)
	{
		`LOG (" X2Condition_OverwatchMark: No Target Unit Found");
	}
	TestValueName = name("OverwatchMark" $ AttackingUnit.ObjectID);
	TargetUnit.GetUnitValue(TestValueName, OWMarkValue);
	//`LOG (AttackingUnit.GetLastName() @ TestValueName @ "Checked. Value:" @ OWShotValue.fValue);
	if (OWMarkValue.fValue <= 0)
	{
		//`LOG (AttackingUnit.GetLastName() @ TestValueName @ "Shot Cancelled.");
		return 'AA_ValueCheckFailed';
	}
	return 'AA_Success';
}
