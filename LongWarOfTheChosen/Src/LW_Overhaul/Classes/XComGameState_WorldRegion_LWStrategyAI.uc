//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_WorldRegion_LWStrategyAI.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: This stores regional Alien AI-related information, such as local ForceLevel, AlertnLevel, and VigilanceLevel
//			 This is designed as a component to be attached to each world region, and is generally updated via the Activity Manager or individual Activities
//---------------------------------------------------------------------------------------
class XComGameState_WorldRegion_LWStrategyAI extends XComGameState_BaseObject
	dependson(XComGameState_LWAlienActivityManager)
	config(LW_Activities);



var array<ActivityCooldownTimer> RegionalCooldowns;
var array<name> PendingTriggeredActivities;

var bool LiberateStage1Complete;
var bool LiberateStage2Complete;

var bool bLiberated; // adding an explicit bool to represent when a region is liberated, instead of trying to define in implicitly
var int NumTimesLiberated; // total number of times this region has been liberated
var TDateTime LastLiberationTime; // set when the region status switches from not-liberated to liberated

var bool bHasResearchFacility;  //adding an explicit bool to represent when a region has a research facility, instead of trying to define in implicitly

var int LocalForceLevel;  // ForceLevel determines the types of aliens that can appear on missions, so it sort of "technology"
var int LocalAlertLevel;  // AlertLevel determines the MissionSchedule, so sets the number and types of pods, so is the "difficulty"
var int LocalVigilanceLevel;  // VigilanceLevel represents how "on guard" the aliens are, how much they view XCOM (or others?) as a "threat"

var int GeneralOpsCount; // Tally of Number of General Ops category missions (essentially security holes) in this region. Divided by month count elsewhere to conditionally cap number.

var TDateTime LastVigilanceUpdateTime;  // the last time the vigilance level was updated (either increase or decrease)
var TDateTime NextVigilanceDecayTime, OldNextVigilanceDecayTime;

var config array<int> START_REGION_FORCE_LEVEL;
var config array<int> START_REGION_ALERT_LEVEL;
var config array<int> TOTAL_STARTING_FORCE_LEVEL;
var config array<int> TOTAL_STARTING_ALERT_LEVEL;

var config float LOCAL_VIGILANCE_DECAY_RATE_HOURS;
var config int BASELINE_OUTPOST_WORKERS_FOR_STD_VIG_DECAY;
var config int MAX_VIG_DECAY_CHANGE_HOURS;
var config bool BUSY_HAVENS_SLOW_VIGILANCE_DECAY;

var config int STARTING_LOCAL_MIN_FORCE_LEVEL;
var config int STARTING_LOCAL_MIN_ALERT_LEVEL;
var config int STARTING_LOCAL_MIN_VIGILANCE_LEVEL;

var config int STARTING_LOCAL_MAX_FORCE_LEVEL;
var config int STARTING_LOCAL_MAX_ALERT_LEVEL;
var config int STARTING_LOCAL_MAX_VIGILANCE_LEVEL;

static function InitializeRegionalAIs(optional XComGameState StartState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local bool bNeedsGameState;
	local XComGameState NewGameState;
	local array<XComGameState_WorldRegion> RegionStates;
	local XComGameState_WorldRegion RegionState, UpdatedRegionState;
	local array<XComGameState_WorldRegion_LWStrategyAI> NewRegionalAIs;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAIState;
	local int TotalRegions, TotalNewRegions, RegionCount;
	local int TotalForceLevelToAdd, TotalAlertLevelToAdd, NumVigilanceToDeviate;
	local int ForceLevelToAdd, AlertLevelToAdd;
	local int MinVigilanceToDeviate, MaxVigilanceToDeviate, VigilanceLevelToAdd, NumVigilanceUp, NumVigilanceDown;
	local int idx, idx2, iterations;
	local bool bFoundAppropriateRegion;

	History = `XCOMHISTORY;
	bNeedsGameState = StartState == none;
	if(bNeedsGameState)
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Creating Regional AI components");
	else
		NewGameState = StartState;

	// collect all of the RegionStates
	if(bNeedsGameState)
	{
		foreach History.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
		{
			RegionStates.AddItem(RegionState);
		}
	}
	else
	{
		foreach NewGameState.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
		{
			RegionStates.AddItem(RegionState);
		}
	}

	foreach RegionStates(RegionState)
	{
		//double check it doesn't already exist
		RegionalAIState = GetRegionalAI(RegionState, NewGameState);
		if(RegionalAIState == none)
		{
			RegionalAIState = XComGameState_WorldRegion_LWStrategyAI(NewGameState.CreateStateObject(class'XComGameState_WorldRegion_LWStrategyAI'));
			NewGameState.AddStateObject(RegionalAIState);
			if(bNeedsGameState)
			{
				UpdatedRegionState = XComGameState_WorldRegion(NewGameState.CreateStateObject(class'XComGameState_WorldRegion', RegionState.ObjectID));
				NewGameState.AddStateObject(UpdatedRegionState);
			}
			else
			{
				UpdatedRegionState = RegionState;
			}
			UpdatedRegionState.AddComponentObject(RegionalAIState);
			NewRegionalAIs.AddItem(RegionalAIState);
		}
	}

	TotalForceLevelToAdd = default.TOTAL_STARTING_FORCE_LEVEL[`STRATEGYDIFFICULTYSETTING];
	TotalAlertLevelToAdd = default.TOTAL_STARTING_ALERT_LEVEL[`STRATEGYDIFFICULTYSETTING];

	//adjustments in case for some reason only some of the components are initialized
	TotalRegions = RegionStates.Length;
	TotalNewRegions = NewRegionalAIs.Length;
	if(TotalNewRegions < TotalRegions)
	{
		TotalForceLevelToAdd *= TotalNewRegions;
		TotalForceLevelToAdd /= TotalRegions;
		TotalAlertLevelToAdd *= TotalNewRegions;
		TotalAlertLevelToAdd /= TotalRegions;
	}

	//randomize the order to avoid applying patters
	NewRegionalAIs = RandomizeOrder(NewRegionalAIs);

	MinVigilanceToDeviate = (TotalNewRegions * 1) / 8;
	MaxVigilanceToDeviate = (TotalNewRegions * 3) / 8;
	NumVigilanceToDeviate = MinVigilanceToDeviate + `SYNC_RAND_STATIC(MaxVigilanceToDeviate - MinVigilanceToDeviate + 1);

	if(NewGameState != none)
	{
		foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersXCom', XComHQ)
		{
			break;
		}
	}
	if(XComHQ == none)
	{
		XComHQ = `XCOMHQ;
	}

	//Starting region is treated separately to remove randomness from it.
	foreach NewRegionalAIs(RegionalAIState, RegionCount)
	{
		if(RegionalAIState.OwningObjectId == XComHQ.StartingRegion.ObjectID)
		{
			ForceLevelToAdd = default.START_REGION_FORCE_LEVEL[`STRATEGYDIFFICULTYSETTING];
			AlertLevelToAdd = default.START_REGION_ALERT_LEVEL[`STRATEGYDIFFICULTYSETTING];
			VigilanceLevelToAdd = Clamp (AlertLevelToAdd, 1, default.STARTING_LOCAL_MAX_VIGILANCE_LEVEL);

			TotalForceLevelToAdd -= ForceLevelToAdd;
			TotalAlertLevelToAdd -= AlertLevelToAdd;

			RegionalAIState.LocalForceLevel = ForceLevelToAdd;
			RegionalAIState.LocalAlertLevel = AlertLevelToAdd;
			RegionalAIState.LocalVigilanceLevel = VigilanceLevelToAdd;
			RegionalAIState.LastVigilanceUpdateTime = class'XComGameState_GeoscapeEntity'.static.GetCurrentTime();			

			NewRegionalAIs.Remove(RegionCount, 1);
			break;
		}
	}

	//Start with assigning the minimum to each region
	foreach NewRegionalAIs(RegionalAIState, RegionCount)
	{
		AlertLevelToAdd = Clamp(1, default.STARTING_LOCAL_MIN_ALERT_LEVEL, default.STARTING_LOCAL_MAX_ALERT_LEVEL);
		TotalAlertLevelToAdd -= AlertLevelToAdd;
		RegionalAIState.LocalAlertLevel = AlertLevelToAdd;

		ForceLevelToAdd = Clamp(1, default.STARTING_LOCAL_MIN_FORCE_LEVEL, default.STARTING_LOCAL_MAX_FORCE_LEVEL);
		TotalForceLevelToAdd -= ForceLevelToAdd;
		RegionalAIState.LocalForceLevel = ForceLevelToAdd;
	}

	//Remaining alert points are to be distributed randomly
	for(idx = 0; idx < TotalAlertLevelToAdd; idx++)
	{
		bFoundAppropriateRegion = false;
		iterations = 0;
		do 
		{			
			RegionalAIState = NewRegionalAIs[`SYNC_RAND_STATIC(NewRegionalAIs.Length)];
			if (RegionalAIState.LocalAlertLevel < default.STARTING_LOCAL_MAX_ALERT_LEVEL)
				bFoundAppropriateRegion = true;
		} until (bFoundAppropriateRegion || (++iterations > 1000));

		if (!bFoundAppropriateRegion)
		{
			//If by this point no region to add another alert point was found,
			//then it is likely that there are no available regions left at all.
			//At this point we can either respect STARTING_LOCAL_MAX_ALERT_LEVEL 
			//or TOTAL_STARTING_ALERT_LEVEL but seemingly not both.

			//Let's respect TOTAL_STARTING_ALERT_LEVEL and dump remaining points
			//into random regions.
			for(idx2 = idx; idx2 < TotalAlertLevelToAdd; idx2++)
			{
				RegionalAIState = NewRegionalAIs[`SYNC_RAND_STATIC(NewRegionalAIs.Length)];
				RegionalAIState.LocalAlertLevel += 1;
			}
			break;
		}

		RegionalAIState.LocalAlertLevel += 1;
	}

	//Remaining force points are to be distributed randomly
	for(idx = 0; idx < TotalForceLevelToAdd; idx++)
	{
		bFoundAppropriateRegion = false;
		iterations = 0;
		do
		{
			RegionalAIState = NewRegionalAIs[`SYNC_RAND_STATIC(NewRegionalAIs.Length)];
			if (RegionalAIState.LocalForceLevel < default.STARTING_LOCAL_MAX_FORCE_LEVEL)
				bFoundAppropriateRegion = true;
		} until (bFoundAppropriateRegion || (++iterations > 1000));

		if (!bFoundAppropriateRegion)
		{
			//If by this point no region to add another force point was found,
			//then it is likely that there are no available regions left at all.
			//At this point we can either respect STARTING_LOCAL_MAX_FORCE_LEVEL 
			//or TOTAL_STARTING_FORCE_LEVEL but seemingly not both.

			//Let's respect STARTING_LOCAL_MAX_FORCE_LEVEL and dump remaining points
			//into random regions.
			for(idx2 = idx; idx2 < TotalForceLevelToAdd; idx2++)
			{
				RegionalAIState = NewRegionalAIs[`SYNC_RAND_STATIC(NewRegionalAIs.Length)];
				RegionalAIState.LocalForceLevel += 1;
			}
			break;
		}

		RegionalAIState.LocalForceLevel += 1;
	}

	//Setting regions vigilance the same way as before.
	//Given current settings, vigilance will be increased by 1 NumVigilanceToDeviate times,
	//but decreased only up to NumVigilanceToDeviate times, sometimes less, since some regions 
	//may have starting alert level of 1. Therefore, starting global vigilance may change slightly,
	//but overall shouldn't matter much.
	foreach NewRegionalAIs(RegionalAIState, RegionCount)
	{
		VigilanceLevelToAdd = RegionalAIState.LocalAlertLevel;
		if(NumVigilanceUp++ < NumVigilanceToDeviate)
			VigilanceLevelToAdd += 1;
		else if(NumVigilanceDown++ < NumVigilanceToDeviate)
			VigilanceLevelToAdd -= 1;

		VigilanceLevelToAdd = Clamp (VigilanceLevelToAdd, 1, default.STARTING_LOCAL_MAX_VIGILANCE_LEVEL);
		RegionalAIState.LocalVigilanceLevel = VigilanceLevelToAdd;
		RegionalAIState.LastVigilanceUpdateTime = class'XComGameState_GeoscapeEntity'.static.GetCurrentTime();
	}

	if(bNeedsGameState)
	{
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}

}

static function array<XComGameState_WorldRegion_LWStrategyAI> RandomizeOrder(const array<XComGameState_WorldRegion_LWStrategyAI> SourceRegions)
{
	local array<XComGameState_WorldRegion_LWStrategyAI> Regions;
	local array<XComGameState_WorldRegion_LWStrategyAI> RemainingRegions;
	local int ArrayLength, idx, Selection;

	ArrayLength = SourceRegions.Length;
	RemainingRegions = SourceRegions;

	for(idx = 0; idx < ArrayLength; idx++)
	{
		Selection = `SYNC_RAND_STATIC(RemainingRegions.Length);
		Regions.AddItem(RemainingRegions[Selection]);
		RemainingRegions.Remove(Selection, 1);
	}

	return Regions;
}

function XComGameState_WorldRegion GetOwningRegion()
{
	return XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(OwningObjectId));
}

static function int GetGlobalAlertLevel(optional XComGameState NewGameState)
{
    local XComGameState_WorldRegion RegionState;
    local XComGameStateHistory History;
	local int AlertLevel;

    History = `XCOMHISTORY;

	AlertLevel = 0;
    foreach History.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
    {
		AlertLevel += GetRegionalAI(RegionState, NewGameState).LocalAlertLevel;
	}

	return AlertLevel;
}

// Returns the regional AI component attached to a given region
static function XComGameState_WorldRegion_LWStrategyAI GetRegionalAI(XComGameState_WorldRegion RegionState, optional XComGameState NewGameState, optional bool bAddToGameState)
{
	 local XComGameState_WorldRegion_LWStrategyAI RegionalAI;

	if (RegionState == none)
	{
		`LWTRACE("GetRegionalAI ERROR : NONE Region Passed");
		ScriptTrace();
		return none;
	}
	if (NewGameState != none)
	{
		foreach NewGameState.IterateByClassType(class'XComGameState_WorldRegion_LWStrategyAI', RegionalAI)
		{
			if (RegionalAI.OwningObjectId == RegionState.ObjectID)
			{
				return RegionalAI;
			}
		}
	}
	RegionalAI = XComGameState_WorldRegion_LWStrategyAI(RegionState.FindComponentObject(class'XComGameState_WorldRegion_LWStrategyAI'));
	if (RegionalAI != none && NewGameState != none && bAddToGameState)
	{
		RegionalAI = XComGameState_WorldRegion_LWStrategyAI(NewGameState.CreateStateObject(class'XComGameState_WorldRegion_LWStrategyAI', RegionalAI.ObjectID));
		NewGameState.AddStateObject(RegionalAI);
	}
	return RegionalAI;
}

function AddVigilance(optional XComGameState NewGameState, optional int Amount = 1)
{
	local XComGameState_WorldRegion_LWStrategyAI UpdatedRegionalAIState;
	local bool bCreatingOwnGameState;
	local int OldVigilanceLevel;

	if (Amount == 0)
	{
		return;
	}
	bCreatingOwnGameState = NewGameState == none;
	if(bCreatingOwnGameState)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Updating RegionalAI Vigilance Level");
	}
	UpdatedRegionalAIState = XComGameState_WorldRegion_LWStrategyAI(NewGameState.CreateStateObject(class'XComGameState_WorldRegion_LWStrategyAI', ObjectID));
	NewGameState.AddStateObject(UpdatedRegionalAIState);

	OldVigilanceLevel = LocalVigilanceLevel;

	UpdatedRegionalAIState.LocalVigilanceLevel += Amount;
	if (UpdatedRegionalAIState.LocalVigilanceLevel < 1)
		UpdatedRegionalAIState.LocalVigilanceLevel = 1;

	if (OldVigilanceLevel != UpdatedRegionalAIState.LocalVigilanceLevel)
	{
		`LWTRACE ("Updating LastVigilanceUpdateTime for" @ GetOwningRegion().GetMyTemplateName());
		UpdatedRegionalAIState.LastVigilanceUpdateTime = class'XComGameState_GeoscapeEntity'.static.GetCurrentTime();
	}

	if(bCreatingOwnGameState)
	{
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}

}

//Updates RegionalAI based on regular time update
function bool UpdateRegionalAI(XComGameState NewGameState)
{
	local TDateTime CurrentTime;
	local ActivityCooldownTimer Cooldown;
	local array<ActivityCooldownTimer> CooldownsToRemove;
	local bool bUpdated;
	local XComGameState_LWOutpost					OutPostState;
	local int WorkingRebels, EmptySlots, SlotsDelta, HoursMod, OldLocalVigilanceLevel;

	//handle vigilance decay

	//`LWTRACE ("Pretest" @ class'X2StrategyGameRulesetDataStructures'.static.GetDateString(LastVigilanceUpdateTime) @ class'X2StrategyGameRulesetDataStructures'.static.GetMonth (LastVigilanceUpdateTime));
	// This is a fix for existing campaigns
	if (class'X2StrategyGameRulesetDataStructures'.static.GetMonth(LastVigilanceUpdateTime) < 1 || class'X2StrategyGameRulesetDataStructures'.static.GetMonth(LastVigilanceUpdateTime) > 12)
	{
		`LOG ("Fixing bad LastVigilanceUpdateTime in" @ GetOwningRegion().GetMyTemplateName());
		LastVigilanceUpdateTime = class'XComGameState_GeoscapeEntity'.static.GetCurrentTime();
		//`LWTRACE (class'X2StrategyGameRulesetDataStructures'.static.GetDateString(LastVigilanceUpdateTime) @ class'X2StrategyGameRulesetDataStructures'.static.GetMonth (LastVigilanceUpdateTime));
		bUpdated = true;
	}
	
	// Vigilance Decay
	if (GetOwningRegion().HaveMadeContact() && LocalVigilanceLevel > 1)
	{
		CurrentTime = class'XComGameState_GeoscapeEntity'.static.GetCurrentTime();
		NextVigilanceDecayTime = LastVigilanceUpdateTime;
		class'X2StrategyGameRulesetDataStructures'.static.AddHours(NextVigilanceDecayTime, default.LOCAL_VIGILANCE_DECAY_RATE_HOURS);
		
		// modify by number of hidings / inactives. First count people on jobs. subtract that from the max who can be working in a haven (13)
		HoursMod = 0;
		OutPostState = `LWOUTPOSTMGR.GetOutpostForRegion(GetOwningRegion());
		WorkingRebels = OutPostState.Rebels.Length - OutPostState.GetNumRebelsOnJob (class'LWRebelJob_DefaultJobSet'.const.HIDING_JOB);
		EmptySlots = class'XComGameState_LWOutpost'.default.DEFAULT_OUTPOST_MAX_SIZE - WorkingRebels;
		SlotsDelta = class'XComGameState_LWOutPost'.default.DEFAULT_OUTPOST_MAX_SIZE - default.BASELINE_OUTPOST_WORKERS_FOR_STD_VIG_DECAY - EmptySlots;
		HoursMod = (float (SlotsDelta) / float (default.BASELINE_OUTPOST_WORKERS_FOR_STD_VIG_DECAY)) * default.MAX_VIG_DECAY_CHANGE_HOURS;
		//`LWTRACE("Setting new HoursMod for this region" @ HoursMod @ EmptySlots @ SlotsDelta);
		If (!default.BUSY_HAVENS_SLOW_VIGILANCE_DECAY && HoursMod > 0.0)
		{
			HoursMod = 0;
		}
		class'X2StrategyGameRulesetDataStructures'.static.AddHours(NextVigilanceDecayTime, HoursMod);

		//`LWTRACE("Current Time:" @ class'X2StrategyGameRulesetDataStructures'.static.GetDateString(CurrentTime) @ class'X2StrategyGameRulesetDataStructures'.static.GetTimeString(CurrentTime));
		//`LWTRACE("Next Vigilance Decay for" @ GetOwningRegion().GetMyTemplateName() @ "scheduled for" @ class'X2StrategyGameRulesetDataStructures'.static.GetDateString(NextVigilanceDecayTime) @ class'X2StrategyGameRulesetDataStructures'.static.GetTimeString(NextVigilanceDecayTime));
		if (class'X2StrategyGameRulesetDataStructures'.static.LessThan(NextVigilanceDecayTime, class'XComGameState_GeoscapeEntity'.static.GetCurrentTime()))
		{
			OldLocalVigilanceLevel = LocalVigilanceLevel;

			// Towers permanently piss off ADVENT outside of starting region
			if (GetOwningRegion().ResistanceLevel >= eResLevel_Outpost && LocalVigilanceLevel < 2 && !GetOwningRegion().IsStartingRegion())
			{
				LocalVigilanceLevel = 2;
			}
			else
			{	
				LocalVigilanceLevel -= 1;
			}
			if (LocalVigilanceLevel != OldLocalVigilanceLevel)
			{
				//`LWTRACE("PASS: Region " $ GetOwningRegion().GetMyTemplateName() $ " Vigilance Decay by 1.");
				LastVigilanceUpdateTime = CurrentTime;
				bUpdated = true;	
			}
		}
	}

	//handle local activity cooldowns
	foreach RegionalCooldowns(Cooldown)
	{
		if(class'X2StrategyGameRulesetDataStructures'.static.LessThan(Cooldown.CooldownDateTime, class'XComGameState_GeoscapeEntity'.static.GetCurrentTime()))
		{
			CooldownsToRemove.AddItem(Cooldown);
		}
	}
	if(CooldownsToRemove.Length > 0)
	{
		foreach CooldownsToRemove(Cooldown)
		{
			RegionalCooldowns.RemoveItem(Cooldown);
		}
		bUpdated = true;
	}
	return bUpdated;
}

