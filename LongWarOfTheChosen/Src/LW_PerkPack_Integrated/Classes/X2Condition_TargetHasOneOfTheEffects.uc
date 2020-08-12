//---------------------------------------------------------------------------------------
//  FILE:   X2Condition_TargetHasOneOfTheEffects.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: Condition that checks if the target has ONE of the required effects, basically being an OR
//---------------------------------------------------------------------------------------
class X2Condition_TargetHasOneOfTheEffects extends X2Condition;

var array<name> EffectNames;

event name CallMeetsCondition(XComGameState_BaseObject kTarget) 
{
	local XComGameState_Unit TargetUnit;
	local name				 EffectName;
	
	TargetUnit = XComGameState_Unit(kTarget);
	
	if (TargetUnit != none)
	{
		foreach EffectNames(EffectName)
		{
			if (TargetUnit.IsUnitAffectedByEffectName(EffectName))
			{
				return 'AA_Success'; 
			}
		}
		return 'AA_MissingRequiredEffect';
	}
	else return 'AA_NotAUnit';	
}
