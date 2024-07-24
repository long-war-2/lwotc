//---------------------------------------------------------------------------------------
//  FILE:    X2LWActivityDetectionCalc.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Basic detection mechanics for alien activities
//---------------------------------------------------------------------------------------
class X2LWActivityDetectionCalc extends Object config(LW_Activities);



var config array <bool> USE_DETECTION_FORCE_LEVEL_MODIFIERS;
var config array <float> FORCE_LEVEL_DETECTION_MODIFIER_ROOKIE;
var config array <float> FORCE_LEVEL_DETECTION_MODIFIER_VETERAN;
var config array <float> FORCE_LEVEL_DETECTION_MODIFIER_COMMANDER;
var config array <float> FORCE_LEVEL_DETECTION_MODIFIER_LEGENDARY;

var config bool BOOST_EARLY_DETECTION;
var config float EARLY_DETECTION_CHANCE_BOOST;
var config int EARLY_DETECTION_DAYS;

struct DetectionModifierInfo
{
	var float   Value;
	var string  Reason;
};

var bool bSkipUncontactedRegions;
var protectedwrite bool bAlwaysDetected;
var protectedwrite bool bNeverDetected;

var array<DetectionModifierInfo> DetectionModifiers;       // Can be configured in the activity template to provide always-on modifiers.

var protected name RebelMissionsJob;

var bool bDebugLog;

function AddDetectionModifier(const int ModValue, const string ModReason)
{
	local DetectionModifierInfo Mod;
	Mod.Value = ModValue;
	Mod.Reason = ModReason;
	DetectionModifiers.AddItem(Mod);
}

function SetAlwaysDetected(bool Val)
{
	bAlwaysDetected = Val;
	if(Val)
		bNeverDetected = false;
}

function SetNeverDetected(bool Val)
{
	bNeverDetected = Val;
	if(Val)
		bAlwaysDetected = false;
}

//activity detection mechanic
function bool CanBeDetected(XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
	local XComGameState_WorldRegion RegionState;
	local XComGameState_LWOutpost OutpostState;
	local XComGameState_LWOutpostManager OutpostManager;
	local X2LWAlienActivityTemplate ActivityTemplate;
	local float DetectionChance, RandValue;

	//`LWTRACE("TypicalActivity Discovery: Starting");
	if(bAlwaysDetected)
		return true;

	if(bNeverDetected)
		return false;

	OutpostManager = class'XComGameState_LWOutpostManager'.static.GetOutpostManager();
	
    RegionState = GetRegion(ActivityState);
	if(RegionState == none)
	{
		`REDSCREEN("Cannot find region for activity " $ ActivityState.GetMyTemplateName());
		return false;
	}
	if(!RegionState.HaveMadeContact() && ShouldSkipUncontactedRegion())
		return false;

	OutpostState = OutpostManager.GetOutpostForRegion(RegionState);
	if(OutpostState == none)
	{
		`REDSCREEN("Activity Discovery : No outpost found in region");
		return false;
	}

	ActivityTemplate = ActivityState.GetMyTemplate();

	//DEPRECATED -- liberation activity now directly removes/modifies activities directly
	// activities may "effectively" disappear after liberation -- we do this for undetected ones by making them undetectable
	//if(class'X2StrategyElement_DefaultAlienActivities'.static.RegionIsLiberated(RegionState, NewGameState))
	//{
		//if(ShouldSkipLiberatedRegion(ActivityTemplate))
			//return false;
	//}

	ActivityState.MissionResourcePool += GetMissionIncomeForUpdate(OutpostState);
	ActivityState.MissionResourcePool += GetExternalMissionModifiersForUpdate(ActivityState, NewGameState); // for other mods to hook into

	if(bDebugLog)
	{
		`LWTrace("Activity" @ActivityTemplate.DataName@ "Mission income pool:" @ActivityState.MissionResourcePool);
	}

	if(MeetsRequiredMissionIncome(ActivityState, ActivityTemplate)) // have enough income
	{
		if(MeetsOnMissionJobRequirements(ActivityState, ActivityTemplate, OutpostState))  // have enough rebels on job -- use the daily income, to include Avenger/Dark Events, etc
		{
	
			DetectionChance = GetDetectionChance(ActivityState, ActivityTemplate, OutpostState);
			`LWTRACE("DISCOVERY:" @ RegionState.GetMyTemplate().DisplayName @ ": DetectionChance for" @ ActivityTemplate.DataName @ ":" @ string(DetectionChance));

			RandValue = `SYNC_FRAND() * 100.0;
			if(RandValue < DetectionChance)  // pass random roll
			{
				`LWTRACE("SUCCESS: Roll was" @ string(Randvalue));
				//we found the activity (which will spawn the mission) so spend the income
				ActivityState.MissionResourcePool = 0;
				return true;
			}
		}
	}

	return false;
}

function float GetDetectionChance(XComGameState_LWAlienActivity ActivityState, X2LWAlienActivityTemplate ActivityTemplate, XComGameState_LWOutpost OutpostState)
{
	local float ResourcePool;
	local float DetectionChance;
	local DetectionModifierInfo Mod;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;

	local TDateTime GameStartDate;
	local int TimeToDays;
	local int DiffInHours;

	ResourcePool = ActivityState.MissionResourcePool;

	if (ActivityTemplate.RequiredRebelMissionIncome > 0)
		ResourcePool -= ActivityTemplate.RequiredRebelMissionIncome;

	if(bDebugLog)
	{
		`LWTrace("GetDetectionChance pool post required income:" @ResourcePool);
	}

	
	DetectionChance = ResourcePool / 100.0 * ActivityTemplate.DiscoveryPctChancePerDayPerHundredMissionIncome;

	if(bDebugLog)
	{
		`LWTrace("GetDetectionChance initial chance:" @DetectionChance);
	}

	//add fixed modifiers
	foreach DetectionModifiers(Mod)
	{
		DetectionChance += Mod.Value;
	}

	if(bDebugLog)
	{
		`LWTrace("GetDetectionChance chance after modifiers:" @DetectionChance);
	}

	// insert something sort of cheaty
	//`LWTRACE ("Bugcheck:" @ string(`STRATEGYDIFFICULTYSETTING) @ default.USE_DETECTION_FORCE_LEVEL_MODIFIERS[`STRATEGYDIFFICULTYSETTING]);
	if (default.USE_DETECTION_FORCE_LEVEL_MODIFIERS[`STRATEGYDIFFICULTYSETTING])
	{
	    RegionState = GetRegion(ActivityState);
		RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState);
		if(RegionState == none)
		{
			`REDSCREEN("Cannot find region for activity " $ ActivityState.GetMyTemplateName());
		}
		switch (`STRATEGYDIFFICULTYSETTING)
		{
			case 0: DetectionChance += default.FORCE_LEVEL_DETECTION_MODIFIER_ROOKIE[clamp(RegionalAI.LocalForceLevel, 1, 20)]; break;
			case 1: DetectionChance += default.FORCE_LEVEL_DETECTION_MODIFIER_VETERAN[clamp(RegionalAI.LocalForceLevel, 1, 20)]; break;
			case 2: DetectionChance += default.FORCE_LEVEL_DETECTION_MODIFIER_COMMANDER[clamp(RegionalAI.LocalForceLevel, 1, 20)]; break;
			case 3: DetectionChance += default.FORCE_LEVEL_DETECTION_MODIFIER_LEGENDARY[clamp(RegionalAI.LocalForceLevel, 1, 20)]; break;
			default: break;
		}
	}
	`LWTrace("GetDetectionChance: DetectionChance pre-early boost:" @DetectionChance);

	// New early campaign detection chance boost system
	if(default.BOOST_EARLY_DETECTION)
	{
		class'X2StrategyGameRulesetDataStructures'.static.SetTime( GameStartDate, 0, 0, 0,
					class'X2StrategyGameRulesetDataStructures'.default.START_MONTH,
					class'X2StrategyGameRulesetDataStructures'.default.START_DAY,
					class'X2StrategyGameRulesetDataStructures'.default.START_YEAR );
		
		// Compares date the activity was started to start date.
		TimeToDays = class'X2StrategyGameRulesetDataStructures'.static.DifferenceInDays( ActivityState.DateTimeStarted, GameStartDate );

		//If we're within the time period, boost the detection.
		if(TimeToDays <= default.EARLY_DETECTION_DAYS)
		{
			DiffInHours = class'X2StrategyGameRulesetDataStructures'.static.DifferenceInHours(class'XComGameState_GeoscapeEntity'.static.GetCurrentTime(), ActivityState.DateTimeStarted);
			DetectionChance += (default.EARLY_DETECTION_CHANCE_BOOST * ((1+DiffInHours)/24.0));
		}
	}

	`LWTrace("GetDetectionChance: DetectionChance post early boost:" @DetectionChance);

	//normalize for update rate
	DetectionChance *= float(class'X2LWAlienActivityTemplate'.default.HOURS_BETWEEN_ALIEN_ACTIVITY_DETECTION_UPDATES) / 24.0;

	//`LWTrace("GetDetectionChance: DetectionChance post normaliation for tick rate:" @DetectionChance);
	return DetectionChance;
}

function bool MeetsOnMissionJobRequirements(XComGameState_LWAlienActivity ActivityState, X2LWAlienActivityTemplate ActivityTemplate, XComGameState_LWOutpost OutpostState)
{
	return true;
	//return OutpostState.GetTrueDailyIncomeForJob(default.RebelMissionsJob) >= ActivityTemplate.MinimumRequiredIntelDailyIncome;
}

function bool MeetsRequiredMissionIncome(XComGameState_LWAlienActivity ActivityState, X2LWAlienActivityTemplate ActivityTemplate)
{
	return ActivityState.MissionResourcePool >= ActivityTemplate.RequiredRebelMissionIncome;
}

function float GetMissionIncomeForUpdate(XComGameState_LWOutpost OutpostState)
{
	local float NewIncome;

	NewIncome = OutpostState.GetDailyIncomeForJob(default.RebelMissionsJob);
	NewIncome *= float(class'X2LWAlienActivityTemplate'.default.HOURS_BETWEEN_ALIEN_ACTIVITY_DETECTION_UPDATES) / 24.0;

	return NewIncome;
}

function float GetExternalMissionModifiersForUpdate(XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
    local XComLWTuple Tuple;

    Tuple = new class'XComLWTuple';
	Tuple.Data.Add(1);
    Tuple.Id = 'GetActivityDetectionIncomeModifier';

    // add the new amount
    Tuple.Data[0].Kind = XComLWTVFloat;
    Tuple.Data[0].f = 0;

    // Fire the event
    `XEVENTMGR.TriggerEvent('GetActivityDetectionIncomeModifier', Tuple, ActivityState, NewGameState);

    if (Tuple.Data.Length == 0 || Tuple.Data[0].Kind != XComLWTVFloat)
		return 0;
	else
		return Tuple.Data[0].f;
}

function XComGameState_WorldRegion GetRegion(XComGameState_LWAlienActivity ActivityState)
{
	return XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
}

function bool ShouldSkipUncontactedRegion()
{
	 return bSkipUncontactedRegions;
}

function bool ShouldSkipLiberatedRegion(X2LWAlienActivityTemplate ActivityTemplate)
{
	 return !ActivityTemplate.CanOccurInLiberatedRegion;
}

defaultProperties
{
	bSkipUncontactedRegions = true

	RebelMissionsJob="Intel"

	bDebugLog = true;

}
