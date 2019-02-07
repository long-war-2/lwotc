class X2Condition_OverwatchLimit extends X2Condition;

`include(..\..\XComGame\Mods\LongWaroftheChosen\Src\LW_PerkPack_Integrated\LW_PerkPack.uci)// This is an Unreal Script

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
	local XComGameState_Unit AttackingUnit, TargetUnit;
	local name TestValueName;
	local UnitValue OWShotValue;

	AttackingUnit = XComGameState_Unit(`XCOMHistory.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));
	TargetUnit = XComGameState_Unit(kTarget);

	if (AttackingUnit == none)
	{
		`LOG (" X2Condition_OverwatchLimit: No Attacking Unit Found");
	}

	if (TargetUnit == none)
	{
		`LOG (" X2Condition_OverwatchLimit: No Target Unit Found");
	}
	TestValueName = name("OverwatchShot" $ TargetUnit.ObjectID);
	AttackingUnit.GetUnitValue(TestValueName, OWShotValue);
	//`LOG (AttackingUnit.GetLastName() @ TestValueName @ "Checked. Value:" @ OWShotValue.fValue);
	if (OWShotValue.fValue > 0.0)
	{
		//`LOG (AttackingUnit.GetLastName() @ TestValueName @ "Shot Cancelled.");
		return 'AA_ValueCheckFailed';
	}
	return 'AA_Success';
}
