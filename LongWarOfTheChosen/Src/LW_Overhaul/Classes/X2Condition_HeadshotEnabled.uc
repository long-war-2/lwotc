//---------------------------------------------------------------------------------------
//  FILE:    X2Condition_HeadshotEnabled.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Conditions to include/exclude soldier type characters
//---------------------------------------------------------------------------------------
class X2Condition_HeadshotEnabled extends X2Condition;

var array<bool> EnabledForDifficulty;

event name CallMeetsCondition(XComGameState_BaseObject kTarget) 
{
	if (EnabledForDifficulty[`TACTICALDIFFICULTYSETTING])
	{
		return 'AA_Success';
	}
	else
	{
		return 'AA_HeadshotDisabled';
	}
}