//---------------------------------------------------------------------------------------
//  FILE:    X2LWActivityCooldown.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Cooldown mechanics for creation of alien activities
//---------------------------------------------------------------------------------------
class X2LWActivityCooldown extends Object;



struct ActivityCooldownTimer
{
	var name ActivityName;
	var TDateTime CooldownDateTime;
};

struct AdditionalActivityCooldownInfo
{
	var name ActivityName;
	var name ActivityCategory;
	var float Cooldown_Hours;
};

var float Cooldown_Hours;
var float RandCooldown_Hours;
var array<AdditionalActivityCooldownInfo> AdditionalActivityCooldowns; // unimplemented, but kept for save-game backward compatibility

simulated function ApplyCooldown(XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;
	local ActivityCooldownTimer Cooldown;

	//add a cooldown to the affected region

	History = `XCOMHISTORY;
	RegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
	if(RegionState == none)
		RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));

	RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState, NewGameState, true);

	Cooldown.ActivityName = ActivityState.GetMyTemplateName();
	Cooldown.CooldownDateTime = GetCooldownDateTime();

	RegionalAI.RegionalCooldowns.AddItem(Cooldown);
}

function TDateTime GetCooldownDateTime()
{
	local TDateTime DateTime;

	DateTime = class'XComGameState_GeoscapeEntity'.static.GetCurrentTime();
	class'X2StrategyGameRulesetDataStructures'.static.AddTime(DateTime, int(3600.0 * GetCooldownHours()));
	return DateTime;
}

function float GetCooldownHours()
{
	return Cooldown_Hours + `SYNC_FRAND() * RandCooldown_Hours;
}