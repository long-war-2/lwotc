//---------------------------------------------------------------------------------------
//  FILE:    LWUtilities_Ranks.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Provides enhanced capabilities for configuring rank details -- icon, name, short name
//---------------------------------------------------------------------------------------

class LWUtilities_Ranks extends Object;

static function string GetRankName(const int Rank, name ClassName, XComGameState_Unit Unit)
{
	local XComLWTuple OverrideTuple;

	class'X2ExperienceConfig'.static.CheckRank(Rank);

	//`LOG("Starting GetRankName replacement.");

	//set up a Tuple for return value - true means don't award this hack reward (can also be used to avoid negative effects)
	OverrideTuple = new class'XComLWTuple';
	OverrideTuple.Id = 'OverrideGetRankName';
	OverrideTuple.Data.Add(2);
	OverrideTuple.Data[0].kind = XComLWTVBool;
	OverrideTuple.Data[0].b = false;  // whether override is active
	OverrideTuple.Data[1].kind = XComLWTVString;
	OverrideTuple.Data[1].s = "";  // string to return

	`XEVENTMGR.TriggerEvent('GetRankName', OverrideTuple, Unit);

	if(OverrideTuple.Data[0].b)
		return OverrideTuple.Data[1].s;

	return class'X2ExperienceConfig'.static.GetRankName(Rank, ClassName);
}

static function string GetShortRankName(const int Rank, name ClassName, XComGameState_Unit Unit)
{
	local XComLWTuple OverrideTuple;

	class'X2ExperienceConfig'.static.CheckRank(Rank);

	//set up a Tuple for return value - true means don't award this hack reward (can also be used to avoid negative effects)
	OverrideTuple = new class'XComLWTuple';
	OverrideTuple.Id = 'OverrideGetShortRankName';
	OverrideTuple.Data.Add(2);
	OverrideTuple.Data[0].kind = XComLWTVBool;
	OverrideTuple.Data[0].b = false;  // whether override is active
	OverrideTuple.Data[1].kind = XComLWTVString;
	OverrideTuple.Data[1].s = "";  // string to return

	`XEVENTMGR.TriggerEvent('GetShortRankName', OverrideTuple, Unit);

	if(OverrideTuple.Data[0].b)
		return OverrideTuple.Data[1].s;

	return class'X2ExperienceConfig'.static.GetShortRankName(Rank, ClassName);
}

static function string GetRankIcon(int iRank, name ClassName, XComGameState_Unit Unit)
{
	local XComLWTuple OverrideTuple;

	//set up a Tuple for return value - true means don't award this hack reward (can also be used to avoid negative effects)
	OverrideTuple = new class'XComLWTuple';
	OverrideTuple.Id = 'OverrideGetRankIcon';
	OverrideTuple.Data.Add(2);
	OverrideTuple.Data[0].kind = XComLWTVBool;
	OverrideTuple.Data[0].b = false;  // whether override is active
	OverrideTuple.Data[1].kind = XComLWTVString;
	OverrideTuple.Data[1].s = "";  // string to return

	`XEVENTMGR.TriggerEvent('GetRankIcon', OverrideTuple, Unit);

	if(OverrideTuple.Data[0].b)
		return OverrideTuple.Data[1].s;

	return class'UIUtilities_Image'.static.GetRankIcon(iRank, ClassName);
}