//--------------------------------------------------------------------------------------- 
//  FILE:    X2Condition_CoverStatus.uc
//  AUTHOR:  JL (Pavonis Interactive)
//  PURPOSE: Checks cover relationship between source and target
//---------------------------------------------------------------------------------------
class X2Condition_CoverStatus extends X2Condition;

var bool HighCover, LowCover, NoCover;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{ 
	local XComGameState_Unit SourceUnit, TargetUnit;
	local GameRulesCache_VisibilityInfo			MyVisInfo;

	SourceUnit = XComGameState_Unit(kSource);
	TargetUnit = XComGameState_Unit(kTarget);

	if (SourceUnit == none || TargetUnit == none)
		return 'AA_NotAUnit';

	if(X2TacticalGameRuleset(XComGameInfo(class'Engine'.static.GetCurrentWorldInfo().Game).GameRuleset).VisibilityMgr.GetVisibilityInfo(SourceUnit.ObjectID, TargetUnit.ObjectID, MyVisInfo))
	{
		if (HighCover && MyVisInfo.TargetCover == CT_Standing)	
			return 'AA_Success';
		if (LowCover && MyVisInfo.TargetCover == CT_Midlevel)	
			return 'AA_Success';
		if (NoCover && MyVisInfo.TargetCover == CT_None) 
			return 'AA_Success';
	}
	return 'AA_WrongCoverStatus';
}