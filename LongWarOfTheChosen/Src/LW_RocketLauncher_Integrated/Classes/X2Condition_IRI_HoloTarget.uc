class X2Condition_IRI_HoloTarget extends X2Condition config(Rockets);

var config array<name> LOCKON_EFFECTS;

event name CallMeetsCondition(XComGameState_BaseObject kTarget) 
{ 
	local XComGameState_Unit TargetUnit;
	local name EffectName;

	TargetUnit = XComGameState_Unit(kTarget);

	foreach default.LOCKON_EFFECTS(EffectName)
	{
		if (TargetUnit.IsUnitAffectedByEffectName(EffectName)) return 'AA_Success';
	}
	return 'AA_MissingRequiredEffect';
}