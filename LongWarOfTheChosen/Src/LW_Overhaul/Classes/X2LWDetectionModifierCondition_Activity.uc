//---------------------------------------------------------------------------------------
//  FILE:    X2LWDetectionModifierCondition_Activity.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Condition that checks whether a given activity matches a configured
//           array of activity names.
//---------------------------------------------------------------------------------------

class X2LWDetectionModifierCondition_Activity extends X2Condition;

var array<name> ActivityNames;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	local XComGameState_LWAlienActivity ActivityState;

	ActivityState = XComGameState_LWAlienActivity(kTarget);
	if (ActivityState != none && ActivityNames.Find(ActivityState.GetMyTemplateName()) != INDEX_NONE)
	{
		return 'AA_Success';
	}
	else
	{
		return 'AA_UnknownError';
	}
}

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{
	local XComGameState_LWAlienActivity ActivityState;

	ActivityState = XComGameState_LWAlienActivity(kTarget);
	if (ActivityState != none && ActivityNames.Find(ActivityState.GetMyTemplateName()) != INDEX_NONE)
	{
		return 'AA_Success';
	}
	else
	{
		return 'AA_UnknownError';
	}
}
