//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_LWListenerManager.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: This singleton object manages general persistent listeners that should live for both strategy and tactical play
//---------------------------------------------------------------------------------------
class XComGameState_LWListenerManager extends XComGameState_BaseObject config(LW_Overhaul) dependson(XComGameState_LWPersistentSquad);

struct ToHitAdjustments
{
	var int ConditionalCritAdjust;	// reduction in bonus damage chance from it being conditional on hitting
	var int DodgeCritAdjust;		// reduction in bonus damage chance from enemy dodge
	var int DodgeHitAdjust;			// reduction in hit chance from dodge converting graze to miss
	var int FinalCritChance;
	var int FinalSuccessChance;
	var int FinalGrazeChance;
	var int FinalMissChance;
};

struct ClassMissionExperienceWeighting
{
	var name SoldierClass;
	var float MissionExperienceWeight;
};

struct MinimumInfilForConcealEntry
{
	var string MissionType;
	var float MinInfiltration;
};

var localized string strCritReductionFromConditionalToHit;

var localized string CannotModifyOnMissionSoldierTooltip;

var config int DEFAULT_LISTENER_PRIORITY;

var config bool ALLOW_NEGATIVE_DODGE;
var config bool DODGE_CONVERTS_GRAZE_TO_MISS;
var config bool GUARANTEED_HIT_ABILITIES_IGNORE_GRAZE_BAND;

var config int RENDEZVOUS_EVAC_DELAY; // deprecated
var config int SNARE_EVAC_DELAY; // deprecated

var int OverrideNumUtilitySlots;

var config float DEFAULT_MISSION_EXPERIENCE_WEIGHT;
var config array<ClassMissionExperienceWeighting> CLASS_MISSION_EXPERIENCE_WEIGHTS;

var config float MAX_RATIO_MISSION_XP_ON_FAILED_MISSION;
var config int SQUAD_SIZE_MIN_FOR_XP_CALCS;
var config float TOP_RANK_XP_TRANSFER_FRACTION;
var localized string ResistanceHQBodyText;


var config bool TIERED_RESPEC_TIMES;
var config bool AI_PATROLS_WHEN_SIGHTED_BY_HIDDEN_XCOM;

var config int PSI_SQUADDIE_BONUS_ABILITIES;

var config array<MinimumInfilForConcealEntry> MINIMUM_INFIL_FOR_CONCEAL;
var config array<float> MINIMUM_INFIL_FOR_GREEN_ALERT;

var config array<int>INITIAL_PSI_TRAINING;

static function XComGameState_LWListenerManager GetListenerManager(optional bool AllowNULL = false)
{
	return XComGameState_LWListenerManager(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_LWListenerManager', AllowNULL));
}

static function CreateListenerManager(optional XComGameState StartState)
{
	local XComGameState_LWListenerManager ListenerMgr;
	local XComGameState NewGameState;
	`Log("Creating LW Listener Manager --------------------------------");

	//first check that there isn't already a singleton instance of the listener manager
	if(GetListenerManager(true) != none)
	{
		`Log("LW listener manager already exists");
		return;
	}

	if(StartState != none)
	{
		ListenerMgr = XComGameState_LWListenerManager(StartState.CreateNewStateObject(class'XComGameState_LWListenerManager'));
	}
	else
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Creating LW Listener Manager Singleton");
		ListenerMgr = XComGameState_LWListenerManager(NewGameState.CreateNewStateObject(class'XComGameState_LWListenerManager'));
	}

	ListenerMgr.InitListeners();
}

static function RefreshListeners()
{
	local XComGameState_LWListenerManager ListenerMgr;
	local XComGameState_LWSquadManager    SquadMgr;
	`Log("Refreshing listeners --------------------------------");

	ListenerMgr = GetListenerManager(true);
	if(ListenerMgr == none)
		CreateListenerManager();
	else
		ListenerMgr.InitListeners();
		
	SquadMgr = class'XComGameState_LWSquadManager'.static.GetSquadManager(true);
	if (SquadMgr != none)
		SquadMgr.InitSquadManagerListeners();
}

function InitListeners()
{
	local X2EventManager EventMgr;
	local Object ThisObj;

	`LWTrace ("Init Listeners Firing!");

	ThisObj = self;
	EventMgr = `XEVENTMGR;
	EventMgr.UnregisterFromAllEvents(ThisObj); // clear all old listeners to clear out old stuff before re-registering

	//end of month and reward soldier handling of new soldiers
	EventMgr.RegisterForEvent(ThisObj, 'OnMonthlyReportAlert', OnMonthEnd, ELD_OnStateSubmitted,,,true);
	EventMgr.RegisterForEvent(ThisObj, 'SoldierCreatedEvent', OnSoldierCreatedEvent, ELD_OnStateSubmitted,,,true);
	
	//xp system modifications -- handles assigning of mission "encounters" as well as adding to effective kills based on the value
	// WOTC TODO: Requires change to CHL XComGameState_XpManager
	EventMgr.RegisterForEvent(ThisObj, 'OnDistributeTacticalGameEndXP', OnAddMissionEncountersToUnits, ELD_OnStateSubmitted,,,true);
	// WOTC TODO: Requires change to CHL XComGameState_Unit
	EventMgr.RegisterForEvent(ThisObj, 'GetNumKillsForRankUpSoldier', OnGetNumKillsForMissionEncounters, ELD_Immediate,,,true);
	// WOTC TODO: Requires change to CHL XComGameState_Unit
	EventMgr.RegisterForEvent(ThisObj, 'ShouldShowPromoteIcon', OnCheckForPsiPromotion, ELD_Immediate,,,true);
	EventMgr.RegisterForEvent(ThisObj, 'XpKillShot', OnRewardKillXp, ELD_Immediate,,,true);
	EventMgr.RegisterForEvent(ThisObj, 'OverrideCollectorActivation', OverrideCollectorActivation, ELD_Immediate,,,true);
	EventMgr.RegisterForEvent(ThisObj, 'OverrideScavengerActivation', OverrideScavengerActivation, ELD_Immediate,,,true);
	
	// Mission summary civilian counts
	// WOTC TODO: Requires change to CHL Helpers and UIMissionSummary
	EventMgr.RegisterForEvent(ThisObj, 'GetNumCiviliansKilled', OnNumCiviliansKilled, ELD_Immediate,,,true);
		
	// listener for turn change
	EventMgr.RegisterForEvent(ThisObj, 'PlayerTurnBegun', LW2OnPlayerTurnBegun);

	// WOTC TODO: I think this is just required for graze band mechanics. Not sure if I want
	// to reintroduce those. At least, not yet.
	//to hit
	// EventMgr.RegisterForEvent(ThisObj, 'OnFinalizeHitChance', ToHitOverrideListener,,,,true);
	
	// WOTC TODO: This disables buttons in the armory main menu based on soldier
	// status. See issue https://github.com/pledbrook/lwotc/issues/40 for an alternative
	// approach.
	//override disable flags
	// EventMgr.RegisterForEvent(ThisObj, 'OverrideSquadSelectDisableFlags', OverrideSquadSelectDisableFlags,,,,true);

	// WOTC TODO: See issue above for alternative approach. Although we may need it
	// to handle Haven liaisons and those in psi training. Perhaps officer training
	// as well? Need to check all of those.
	// Armory Main Menu - disable buttons for On-Mission soldiers
	EventMgr.RegisterForEvent(ThisObj, 'OnArmoryMainMenuUpdate', UpdateArmoryMainMenuItems, ELD_Immediate,,,true);


    // Various end of month handling, especially for supply income determination.
    // Note: this is very fiddly. There are several events fired from different parts of the end-of-month processing
    // in the HQ. For most of this, there is an outstanding game state being generated but which hasn't yet been added
    // to the history. This state persists over several of these events before finally being submitted, so care must be
    // taken to check if the object we want to change is already present in the game state rather than fetching the
    // latest submitted one from the history, which would be stale.

    // Pre end of month. Called before we begin any end of month processing, but after the new game state is created.
    // This is used to make sure we trigger one last update event on all the outposts so the income for the last
    // day of the month is computed. This updates the outpost but the won't be submitted yet.
	// WOTC TODO: Needs a change to CHL's `XCGS_HeadquartersResistance`
    EventMgr.RegisterForEvent(ThisObj, 'PreEndOfMonth', PreEndOfMonth, ELD_Immediate,,,true);

    // A request was made for the real monthly supply reward. This is called twice: first from the HQ to get the true
    // number of supplies to reward, and then again by UIResistanceReport to display the value in the report screen.
    // The first one is called while the game state is still pending and so needs to pull the outpost from the pending
    // game state. The second is called after the update is submitted and is passed a null game state, so it can read the
    // outpost from the history.
    EventMgr.RegisterForEvent(ThisObj, 'OnMonthlySuppliesReward', OnMonthlySuppliesReward, ELD_Immediate,,,true);

	//process negative monthly income -- this happens after deductions for maint, so can't go into the OnMonthlySuppliesReward
    EventMgr.RegisterForEvent(ThisObj, 'OnMonthlyNegativeSupplies', OnMonthlyNegativeSupplyIncome, ELD_Immediate,,,true);

    // After closing the monthly report dialog. This is responsible for doing outpost end-of-month processing including
    // resetting the supply state.
    EventMgr.RegisterForEvent(ThisObj, 'OnClosedMonthlyReportAlert', PostEndOfMonth, ELD_OnStateSubmitted,,,true);

	// WOTC TODO: Get this done! Need it for early missions.
	//Special First Mission Icon handling -- only for replacing the Resistance HQ icon functionality
	EventMgr.RegisterForEvent(ThisObj, 'OnInsertFirstMissionIcon', OnInsertFirstMissionIcon, ELD_Immediate,,,true);

	//listener to interrupt OnSkyrangerArrives to not play narrative event -- we will manually trigger it when appropriate in screen listener
	EventMgr.RegisterForEvent(ThisObj, 'OnSkyrangerArrives', OnSkyrangerArrives, ELD_OnStateSubmitted, 100,,true);

	// Override KilledbyExplosion variable to conditionally allow loot to survive
	EventMgr.RegisterForEvent(ThisObj, 'KilledbyExplosion', OnKilledbyExplosion,,,,true);

	// Recalculate respec time so it goes up with soldier rank
	EventMgr.RegisterForEvent(ThisObj, 'SoldierRespecced', OnSoldierRespecced,,,,true);

	//PCS Images
	EventMgr.RegisterForEvent(ThisObj, 'OnGetPCSImage', GetPCSImage,,,,true);

    // Tactical mission cleanup hook
    EventMgr.RegisterForEvent(ThisObj, 'CleanupTacticalMission', OnCleanupTacticalMission, ELD_Immediate,,, true);

    // Outpost built
    EventMgr.RegisterForEvent(ThisObj, 'RegionBuiltOutpost', OnRegionBuiltOutpost, ELD_OnStateSubmitted,,, true);

    // VIP Recovery screen
    EventMgr.RegisterForEvent(ThisObj, 'GetRewardVIPStatus', OnGetRewardVIPStatus, ELD_Immediate,,, true);

    // Version check
    EventMgr.RegisterForEvent(ThisObj, 'GetLWVersion', OnGetLWVersion, ELD_Immediate,,, true);

    // Async rebel photographs
    EventMgr.RegisterForEvent(ThisObj, 'RefreshCrewPhotographs', OnRefreshCrewPhotographs, ELD_Immediate,,, true);

    // Override UFO interception time (since base-game uses Calendar, which no longer works for us)
    EventMgr.RegisterForEvent(ThisObj, 'PostUFOSetInterceptionTime', OnUFOSetInfiltrationTime, ELD_Immediate,,, true);

    // Supply decrease monthly report string replacement
    EventMgr.RegisterForEvent(ThisObj, 'GetSupplyDropDecreaseStrings', OnGetSupplyDropDecreaseStrings, ELD_Immediate,,, true);

	//
	EventMgr.RegisterForEvent(ThisObj, 'PostPsiProjectCompleted', OnPsiProjectCompleted, ELD_Immediate,,, true);

	// listeners for weapon mod stripping
	EventMgr.RegisterForEvent(ThisObj, 'OnCheckBuildItemsNavHelp', AddSquadSelectStripWeaponsButton, ELD_Immediate);
	EventMgr.RegisterForEvent(ThisObj, 'ArmoryLoadout_PostUpdateNavHelp', AddArmoryStripWeaponsButton, ELD_Immediate);

	// listener for when squad conceal is set
	EventMgr.RegisterForEvent(ThisObj, 'OnSetMissionConceal', CheckForConcealOverride, ELD_Immediate,,, true);

	// listener for when an enemy unit's alert status is set -- not working
	//EventMgr.RegisterForEvent(ThisObj, 'OnSetUnitAlert', CheckForUnitAlertOverride, ELD_Immediate,,, true);

	//General Use, currently used for alert change to red
	EventMgr.RegisterForEvent(ThisObj, 'AbilityActivated', OnAbilityActivated, ELD_OnStateSubmitted,,, true);

	/* WOTC TODO: Might be a while before these events are available
	// Attempt to tame Serial
	EventMgr.RegisterForEvent(ThisObj, 'SerialKiller', OnSerialKill, ELD_OnStateSubmitted);

	// initial psi training time override
	EventMgr.RegisterForEvent(ThisObj, 'PsiTrainingBegun', OnOverrideInitialPsiTrainingTime, ELD_Immediate,,, true);

	//Help for some busted objective triggers
	EventMgr.RegisterForEvent(ThisObj, 'OnGeoscapeEntry', OnGeoscapeEntry, ELD_Immediate,,, true);
	*/
}

function EventListenerReturn OnSkyrangerArrives(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	return ELR_InterruptListeners;
}

function EventListenerReturn OnAddMissionEncountersToUnits(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	local XComGameState_BattleData BattleState;
	local XComGameState_MissionSite MissionState;
	local XComGameStateHistory History;
	local XComGameState_XpManager XpManager;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState NewGameState;
	local StateObjectReference UnitRef;
	local XComGameState_Unit UnitState;
	local array<XComGameState_Unit> UnitStates;
	local UnitValue Value, TestValue, Value2;
	local float MissionWeight, UnitShare, MissionExperienceWeighting, UnitShareDivisor;
	local bool TBFInEffect;
	local int TrialByFireKills, KillsNeededForLevelUp, WeightedBonusKills, idx;
	local XComGameState_Unit_LWOfficer OfficerState;
	local X2MissionSourceTemplate MissionSource;
	local bool PlayerWonMission;
    local MissionSettings_LW Settings;
    local XComGameState_LWOutpost Outpost;

	`LWTRACE ("OnAddMissionEncountersToUnits triggered");

	XComHQ = XComGameState_HeadquartersXCom(EventData);
	if(XComHQ == none)
		return ELR_NoInterrupt;

	XpManager = XComGameState_XpManager(EventSource);
	if(XpManager == none)
	{
		`REDSCREEN("OnAddMissionEncountersToUnits event triggered with invalid event source.");
		return ELR_NoInterrupt;
	}

	History = `XCOMHISTORY;

	BattleState = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	if (BattleState.m_iMissionID != XComHQ.MissionRef.ObjectID)
	{
		`REDSCREEN("LongWar: Mismatch in BattleState and XComHQ MissionRef when assigning XP");
		return ELR_NoInterrupt;
	}

	MissionState = XComGameState_MissionSite(History.GetGameStateForObjectID(BattleState.m_iMissionID));
	if(MissionState == none)
		return ELR_NoInterrupt;

	MissionWeight = GetMissionWeight(History, XComHQ, BattleState, MissionState);

	//Build NewGameState change container
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Add Mission Encounter Values");
	foreach XComHQ.Squad(UnitRef)
	{
		if (UnitRef.ObjectID == 0)
			continue;

		UnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', UnitRef.ObjectID));
		if (UnitState.IsSoldier())
		{
			NewGameState.AddStateObject(UnitState);
			UnitStates.AddItem(UnitState);
		}
		else
		{
			NewGameState.PurgeGameStateForObjectID(UnitState.ObjectID);
		}
	}

    // Include the adviser if they were on this mission too
    if (class'Utilities_LW'.static.GetMissionSettings(MissionState, Settings))
    {
        if (Settings.RestrictsLiaison)
        {
            Outpost = `LWOUTPOSTMGR.GetOutpostForRegion(MissionState.GetWorldRegion());
            UnitRef = Outpost.GetLiaison();
            if (UnitRef.ObjectID > 0)
            {
                UnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', UnitRef.ObjectID));
                if (UnitState.IsSoldier())
                {
                    NewGameState.AddStateObject(UnitState);
                    UnitStates.AddItem(UnitState);
                    // Set the liaison as not ranked up. This is handled in DistributeTacticalGameEndXp but only
                    // for members of the squad.
                    if (!class'X2ExperienceConfig'.default.bUseFullXpSystem)
                    {
                        UnitState.bRankedUp = false;
                    }
                }
                else
                {
                    NewGameState.PurgeGameStateForObjectID(UnitState.ObjectID);
                }
            }
        }
    }

	PlayerWonMission = true;
	MissionSource = MissionState.GetMissionSource();
	if(MissionSource.WasMissionSuccessfulFn != none)
	{
		PlayerWonMission = MissionSource.WasMissionSuccessfulFn(BattleState);
	}


	TBFInEffect = false;

	if (PlayerWonMission)
	{
		foreach UnitStates(UnitState)
		{
			if (UnitState.IsSoldier() && !UnitState.IsDead() && !UnitState.bCaptured)
			{
				if (class'LWOfficerUtilities'.static.IsOfficer(UnitState))
				{
					if (class'LWOfficerUtilities'.static.IsHighestRankOfficerinSquad(UnitState))
					{
						OfficerState = class'LWOfficerUtilities'.static.GetOfficerComponent(UnitState);
						if (OfficerState.HasOfficerAbility('TrialByFire'))
						{
							TBFInEffect = true;
							`LWTRACE ("TBFInEffect set from" @ UnitState.GetLastName());
						}
					}
				}
			}
		}
	}

	UnitShareDivisor = UnitStates.Length;

	// Count top rank
	foreach UnitStates(UnitState)
	{
		if (UnitState.IsSoldier() && !UnitState.IsDead() && !UnitState.bCaptured)
		{
			if (UnitState.GetRank() >= class'X2ExperienceConfig'.static.GetMaxRank())
			{
				UnitShareDivisor -= default.TOP_RANK_XP_TRANSFER_FRACTION;
			}
		}
	}

	UnitShareDivisor = Max (UnitShareDivisor, default.SQUAD_SIZE_MIN_FOR_XP_CALCS);

	if (UnitShareDivisor < 1) 
		UnitShareDivisor = 1;

	UnitShare = MissionWeight / UnitShareDivisor;

	foreach UnitStates(UnitState)
	{

		// Zero out any previous value from an earlier iteration: GetUnitValue will return without zeroing
		// the out param if the value doesn't exist on the unit. If this is the first mission this unit went
		// on they will "inherit" the total XP of the unit immediately before them in the squad unless this
		// is cleared.
		Value.fValue = 0;
		UnitState.GetUnitValue('MissionExperience', Value);
		UnitState.SetUnitFloatValue('MissionExperience', UnitShare + Value.fValue, eCleanup_Never);
		UnitState.GetUnitValue('MissionExperience', TestValue);
		`LWTRACE("MissionXP: PreXp=" $ Value.fValue $ ", PostXP=" $ TestValue.fValue $ ", UnitShare=" $ UnitShare $ ", Unit=" $ UnitState.GetFullName());

		if (TBFInEffect)
		{
			if (class'LWOfficerUtilities'.static.IsOfficer(UnitState))
			{
				if (class'LWOfficerUtilities'.static.IsHighestRankOfficerinSquad(UnitState))
				{
					`LWTRACE (UnitState.GetLastName() @ "is the TBF officer.");
					continue;
				}
			}

			if (UnitState.GetRank() < class'LW_OfficerPack_Integrated.X2Ability_OfficerAbilitySet'.default.TRIAL_BY_FIRE_RANK_CAP)
			{
				idx = CLASS_MISSION_EXPERIENCE_WEIGHTS.Find('SoldierClass', UnitState.GetSoldierClassTemplateName());
				if (idx != -1)
					MissionExperienceWeighting = CLASS_MISSION_EXPERIENCE_WEIGHTS[idx].MissionExperienceWeight;
				else
					MissionExperienceWeighting = DEFAULT_MISSION_EXPERIENCE_WEIGHT;

				WeightedBonusKills = Round(Value.fValue * MissionExperienceWeighting);

				Value2.fValue = 0;
				UnitState.GetUnitValue ('OfficerBonusKills', Value2);
				TrialByFireKills = int(Value2.fValue);
				KillsNeededForLevelUp = class'X2ExperienceConfig'.static.GetRequiredKills(UnitState.GetRank() + 1);
				`LWTRACE (UnitState.GetLastName() @ "needs" @ KillsNeededForLevelUp @ "kills to level up. Base kills:" @UnitState.GetNumKills() @ "Mission Kill-eqivalents:" @  WeightedBonusKills @ "Old TBF Kills:" @ TrialByFireKills);

				// Replace tracking num kills for XP with our own custom kill tracking
				//KillsNeededForLevelUp -= UnitState.GetNumKills();
				KillsNeededForLevelUp -= GetUnitValue(UnitState, 'XpKills');
				KillsNeededForLevelUp -= Round(float(UnitState.WetWorkKills) * class'X2ExperienceConfig'.default.NumKillsBonus);
				KillsNeededForLevelUp -= UnitState.GetNumKillsFromAssists();
				KillsNeededForLevelUp -= class'X2ExperienceConfig'.static.GetRequiredKills(UnitState.StartingRank);
				KillsNeededForLevelUp -= WeightedBonusKills;
				KillsNeededForLevelUp -= TrialByFireKills;

				if (KillsNeededForLevelUp > 0)
				{
					`LWTRACE ("Granting" @ KillsNeededForLevelUp @ "TBF kills to" @ UnitState.GetLastName());
					TrialByFireKills += KillsNeededForLevelUp;
					UnitState.SetUnitFloatValue ('OfficerBonusKills', TrialByFireKills, eCleanup_Never);
					`LWTRACE (UnitState.GetLastName() @ "now has" @ TrialByFireKills @ "total TBF bonus Kills");
				}
				else
				{
					`LWTRACE (UnitState.GetLastName() @ "already ranking up so TBF has no effect.");
				}
			}
			else
			{
				`LWTRACE (UnitState.GetLastName() @ "rank too high for TBF");
			}
		}
	}
	`GAMERULES.SubmitGameState(NewGameState);
	return ELR_NoInterrupt;
}

/* Find the number of enemies that were on the original mission schedule.
 * If the mission was an RNF-only mission then it returns 8 + the region alert
 * the mission is in.
 */
function int GetNumEnemiesOnMission(XComGameState_MissionSite MissionState)
{
	local int OrigMissionAliens;
	local array<X2CharacterTemplate> UnitTemplatesThatWillSpawn;
	local XComGameState_WorldRegion Region;
	local XComGameState_WorldRegion_LWStrategyAI RegionAI;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	MissionState.GetShadowChamberMissionInfo(OrigMissionAliens, UnitTemplatesThatWillSpawn);

	// Handle missions built primarily around RNFs by granting a minimum alien count
	if (OrigMissionAliens <= 6)
	{
		Region = XComGameState_WorldRegion(History.GetGameStateForObjectID(MissionState.Region.ObjectID));
		RegionAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(Region);
		OrigMissionAliens = 7 + RegionAI.LocalAlertLevel;
	}

	return OrigMissionAliens;
}

/* Finds the number of aliens that should be used in determining distributed mission xp.
 * If the mission was a failure then it will scale the amount down by the ratio of the
 * number of aliens killed to the number originally on the mission, and a further configurable
 * amount.
 */
function float GetMissionWeight(XComGameStateHistory History, XComGameState_HeadquartersXCom XComHQ, XComGameState_BattleData BattleState, XComGameState_MissionSite MissionState)
{
	local X2MissionSourceTemplate MissionSource;
	local bool PlayerWonMission;
	local float fTotal;
	local int AliensSeen, AliensKilled, OrigMissionAliens;

	AliensKilled = class'UIMissionSummary'.static.GetNumEnemiesKilled(AliensSeen);
	OrigMissionAliens = GetNumEnemiesOnMission(MissionState);

	PlayerWonMission = true;
	MissionSource = MissionState.GetMissionSource();
	if(MissionSource.WasMissionSuccessfulFn != none)
	{
		PlayerWonMission = MissionSource.WasMissionSuccessfulFn(BattleState);
	}

	fTotal = float (OrigMissionAliens);

	if (!PlayerWonMission)
	{
		fTotal *= default.MAX_RATIO_MISSION_XP_ON_FAILED_MISSION * FMin (1.0, float (AliensKilled) / float(OrigMissionAliens));
	}

	return fTotal;
}

function EventListenerReturn OnGetNumKillsForMissionEncounters(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple Tuple;
	local XComGameState_Unit UnitState;
	local UnitValue MissionExperienceValue, OfficerBonusKillsValue;
	local float MissionExperienceWeighting;
	local int WeightedBonusKills, idx, TrialByFireKills, XpKills, UnitKills;

	Tuple = XComLWTuple(EventData);
	if(Tuple == none)
		return ELR_NoInterrupt;

	UnitState = XComGameState_Unit(EventSource);
	if(UnitState == none)
	{
		`REDSCREEN("OnGetNumKillsForMissionEncounters event triggered with invalid event source.");
		return ELR_NoInterrupt;
	}

	if (Tuple.Data[0].kind != XComLWTVInt)
		return ELR_NoInterrupt;

	UnitState.GetUnitValue('MissionExperience', MissionExperienceValue);

	idx = CLASS_MISSION_EXPERIENCE_WEIGHTS.Find('SoldierClass', UnitState.GetSoldierClassTemplateName());
	if (idx != -1)
		MissionExperienceWeighting = CLASS_MISSION_EXPERIENCE_WEIGHTS[idx].MissionExperienceWeight;
	else
		MissionExperienceWeighting = DEFAULT_MISSION_EXPERIENCE_WEIGHT;

	WeightedBonusKills = Round(MissionExperienceValue.fValue * MissionExperienceWeighting);

	//check for officer with trial by and folks under rank, give them sufficient kills to level-up

	OfficerBonusKillsValue.fValue = 0;
	UnitState.GetUnitValue ('OfficerBonusKills', OfficerBonusKillsValue);
	TrialByFireKills = int(OfficerBonusKillsValue.fValue);

	//`LWTRACE (UnitState.GetLastName() @ "has" @ WeightedBonusKills @ "bonus kills from Mission XP and" @ TrialByFireKills @ "bonus kills from Trial By Fire.");

	// We need to add in our own xp tracking and remove the unit kills
	// that are added by vanilla
	XpKills = GetUnitValue(UnitState, 'KillXp');
	UnitKills = UnitState.GetNumKills();

	Tuple.Data[0].i = WeightedBonusKills + TrialByFireKills + XpKills - UnitKills;

	return ELR_NoInterrupt;
}

function EventListenerReturn OnCheckForPsiPromotion(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple Tuple;
	local XComGameState_Unit UnitState;

	Tuple = XComLWTuple(EventData);
	if(Tuple == none)
		return ELR_NoInterrupt;

	UnitState = XComGameState_Unit(EventSource);
	if(UnitState == none)
	{
		`REDSCREEN("OnCheckForPsiPromotion event triggered with invalid event source.");
		return ELR_NoInterrupt;
	}

	if (Tuple.Data[0].kind != XComLWTVBool)
		return ELR_NoInterrupt;

	if (UnitState.IsPsiOperative())
	{
		if (class'Utilities_PP_LW'.static.CanRankUpPsiSoldier(UnitState))
		{
			Tuple.Data[0].B = true;
		}
	}
	return ELR_NoInterrupt;
}

/* Triggered by XpKillShot event so that we can increment the kill xp for the
	killer as long as the total gained kill xp does not exceed the number of
	enemy units that were initially spawned.
*/
function EventListenerReturn OnRewardKillXp(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComGameState_Unit NewUnitState;
	local XpEventData XpEvent;

	XpEvent = XpEventData(EventData);

	// Create a new unit state if we need one.
	NewUnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(XpEvent.XpEarner.ObjectID));
	if(NewUnitState == none)
	{
		NewUnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', XpEvent.XpEarner.ObjectID));
		NewGameState.AddStateObject(NewUnitState);
	}

	// Ensure we don't award xp kills beyond what was originally on the mission
	if(!KillXpIsCapped())
	{
		NewUnitState.SetUnitFloatValue('MissionKillXp', GetUnitValue(NewUnitState, 'MissionKillXp') + 1, eCleanup_BeginTactical);
		NewUnitState.SetUnitFloatValue('KillXp', GetUnitValue(NewUnitState, 'KillXp') + 1, eCleanup_Never);
	}

	return ELR_NoInterrupt;
}

function EventListenerReturn OverrideCollectorActivation(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple OverrideActivation;

	OverrideActivation = XComLWTuple(EventData);

	if(OverrideActivation != none && OverrideActivation.Id == 'OverrideCollectorActivation' && OverrideActivation.Data[0].kind == XComLWTVBool)
	{
		OverrideActivation.Data[0].b = KillXpIsCapped();
	}

	return ELR_NoInterrupt;
}

function EventListenerReturn OverrideScavengerActivation(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple OverrideActivation;

	OverrideActivation = XComLWTuple(EventData);

	if(OverrideActivation != none && OverrideActivation.Id == 'OverrideScavengerActivation' && OverrideActivation.Data[0].kind == XComLWTVBool)
	{
		OverrideActivation.Data[0].b = KillXpIsCapped();
	}

	return ELR_NoInterrupt;
}

function bool KillXpIsCapped()
{
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;
	local XComGameState_BattleData BattleState;
	local XComGameState_MissionSite MissionState;
	local int MissionKillXp, MaxKillXp;

	History = `XCOMHISTORY;

	BattleState = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	if(BattleState == none)
		return false;

	MissionState = XComGameState_MissionSite(History.GetGameStateForObjectID(BattleState.m_iMissionID));
	if(MissionState == none)
		return false;

	MaxKillXp = GetNumEnemiesOnMission(MissionState);

	// Get the sum of xp kills so far this mission
	MissionKillXp = 0;
	foreach History.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		if(UnitState.IsSoldier() && UnitState.IsPlayerControlled())
			MissionKillXp += int(GetUnitValue(UnitState, 'MissionKillXp'));
	}

	return MissionKillXp >= MaxKillXp;
}

function float GetUnitValue(XComGameState_Unit UnitState, Name ValueName)
{
	local UnitValue Value;

	Value.fValue = 0.0;
	UnitState.GetUnitValue(ValueName, Value);
	return Value.fValue;
}

function EventListenerReturn OnInsertFirstMissionIcon(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple Tuple;
	local UIStrategyMap_MissionIcon MissionIcon;
	local UIStrategyMap StrategyMap;

	Tuple = XComLWTuple(EventData);
	if(Tuple == none)
		return ELR_NoInterrupt;

	StrategyMap = UIStrategyMap(EventSource);
	if(StrategyMap == none)
	{
		`REDSCREEN("OnInsertFirstMissionIcon event triggered with invalid event source.");
		return ELR_NoInterrupt;
	}

	MissionIcon = StrategyMap.MissionItemUI.MissionIcons[0];
	MissionIcon.LoadIcon("img:///UILibrary_StrategyImages.X2StrategyMap.MissionIcon_ResHQ");
	MissionIcon.OnClickedDelegate = SelectOutpostManager;
	MissionIcon.HideTooltip();
	MissionIcon.SetMissionIconTooltip(StrategyMap.m_ResHQLabel, ResistanceHQBodyText);

	MissionIcon.Show();

	Tuple.Data[0].b = true; // skip to the next mission icon

	return ELR_NoInterrupt;
}

function SelectOutpostManager()
{
    //local XComGameState_LWOutpostManager OutpostMgr;
	local UIResistanceManagement_LW TempScreen;
    local XComHQPresentationLayer HQPres;

    HQPres = `HQPRES;

    //OutpostMgr = class'XComGameState_LWOutpostManager'.static.GetOutpostManager();
	//OutpostMgr.GoToResistanceManagement();

    if(HQPres.ScreenStack.IsNotInStack(class'UIResistanceManagement_LW'))
    {
        TempScreen = HQPres.Spawn(class'UIResistanceManagement_LW', HQPres);
		TempScreen.EnableCameraPan = false;
        HQPres.ScreenStack.Push(TempScreen, HQPres.Get3DMovie());
    }
}

function EventListenerReturn UpdateArmoryMainMenuItems(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local UIList List;
	local XComGameState_Unit Unit;
	local UIArmory_MainMenu ArmoryMainMenu;
	//local array<string> ButtonsToDisableStrings;
	local array<name> ButtonToDisableMCNames;
	local int idx;
	local UIListItemString CurrentButton;
	local XComGameState_StaffSlot StaffSlotState;

	`LOG("AWCPack / UpdateArmoryMainMenuItems: Starting.");

	List = UIList(EventData);
	if(List == none)
	{
		`REDSCREEN("Update Armory MainMenu event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}
	ArmoryMainMenu = UIArmory_MainMenu(EventSource);
	if(ArmoryMainMenu == none)
	{
		`REDSCREEN("Update Armory MainMenu event triggered with invalid event source.");
		return ELR_NoInterrupt;
	}

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ArmoryMainMenu.UnitReference.ObjectID));
	if (class'LWDLCHelpers'.static.IsUnitOnMission(Unit))
	{
		//ButtonToDisableMCNames.AddItem('ArmoryMainMenu_LoadoutButton'); // adding ability to view loadout, but not modifiy it

		// If this unit isn't a haven adviser, or is a haven adviser that is locked, disable loadout
		// changing. (Allow changing equipment on haven advisers in regions where you can change the
		// adviser to save some clicks).
		if (!`LWOUTPOSTMGR.IsUnitAHavenLiaison(Unit.GetReference()) ||
			`LWOUTPOSTMGR.IsUnitALockedHavenLiaison(Unit.GetReference()))
		{
			ButtonToDisableMCNames.AddItem('ArmoryMainMenu_PCSButton');
			ButtonToDisableMCNames.AddItem('ArmoryMainMenu_WeaponUpgradeButton');

			//update the Loadout button handler to one that locks all of the items
			CurrentButton = FindButton(0, 'ArmoryMainMenu_LoadoutButton', ArmoryMainMenu);
			CurrentButton.ButtonBG.OnClickedDelegate = OnLoadoutLocked;
		}

		// Dismiss is still disabled for all on-mission units, including liaisons.
		ButtonToDisableMCNames.AddItem('ArmoryMainMenu_DismissButton');


		// -------------------------------------------------------------------------------
		// Disable Buttons:
		for (idx = 0; idx < ButtonToDisableMCNames.Length; idx++)
		{
			CurrentButton = FindButton(idx, ButtonToDisableMCNames[idx], ArmoryMainMenu);
			if(CurrentButton != none)
			{
				CurrentButton.SetDisabled(true, default.CannotModifyOnMissionSoldierTooltip);
			}
		}

		return ELR_NoInterrupt;
	}
	switch(Unit.GetStatus())
	{
		case eStatus_PsiTraining:
		case eStatus_PsiTesting:
		case eStatus_Training:
			CurrentButton = FindButton(idx, 'ArmoryMainMenu_DismissButton', ArmoryMainMenu);
			if (CurrentButton != none)
			{
				StaffSlotState = Unit.GetStaffSlot();
				if (StaffSlotState != none)
				{
					CurrentButton.SetDisabled(true, StaffSlotState.GetBonusDisplayString());
				}
				else
				{
					CurrentButton.SetDisabled(true, "");
				}
			}
			break;
		default:
			break;
	}
	return ELR_NoInterrupt;
}

function UIListItemString FindButton(int DefaultIdx, name ButtonName, UIArmory_MainMenu MainMenu)
{
	if(ButtonName == '')
		return none;

	return UIListItemString(MainMenu.List.GetChildByName(ButtonName, false));
}

simulated function OnLoadoutLocked(UIButton kButton)
{
	local XComHQPresentationLayer HQPres;
	local array<EInventorySlot> CannotEditSlots;
	local UIArmory_MainMenu MainMenu;

	CannotEditSlots.AddItem(eInvSlot_Utility);
	CannotEditSlots.AddItem(eInvSlot_Armor);
	CannotEditSlots.AddItem(eInvSlot_GrenadePocket);
	CannotEditSlots.AddItem(eInvSlot_GrenadePocket);
	CannotEditSlots.AddItem(eInvSlot_PrimaryWeapon);
	CannotEditSlots.AddItem(eInvSlot_SecondaryWeapon);
	CannotEditSlots.AddItem(eInvSlot_HeavyWeapon);
	CannotEditSlots.AddItem(eInvSlot_TertiaryWeapon);
	CannotEditSlots.AddItem(eInvSlot_QuaternaryWeapon);
	CannotEditSlots.AddItem(eInvSlot_QuinaryWeapon);
	CannotEditSlots.AddItem(eInvSlot_SenaryWeapon);
	CannotEditSlots.AddItem(eInvSlot_SeptenaryWeapon);
	CannotEditSlots.AddItem(eInvSlot_AmmoPocket);

	MainMenu = UIArmory_MainMenu(GetScreenOrChild('UIArmory_MainMenu'));
	if (MainMenu == none) { return; }

	if( UIListItemString(kButton.ParentPanel) != none && UIListItemString(kButton.ParentPanel).bDisabled )
	{
		`XSTRATEGYSOUNDMGR.PlaySoundEvent("Play_MenuClickNegative");
		return;
	}

	HQPres = `HQPRES;
	if( HQPres != none )
		HQPres.UIArmory_Loadout(MainMenu.UnitReference, CannotEditSlots);
	`XSTRATEGYSOUNDMGR.PlaySoundEvent("Play_MenuSelect");
}

function EventListenerReturn OnSoldierCreatedEvent(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_Unit Unit, UpdatedUnit;
	local XComGameState NewGameState;

	Unit = XComGameState_Unit(EventData);
	if(Unit == none)
	{
		`REDSCREEN("OnSoldierCreatedEvent with no UnitState EventData");
		return ELR_NoInterrupt;
	}

	//Build NewGameState change container
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Update newly created soldier");
	UpdatedUnit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', Unit.ObjectID));
	NewGameState.AddStateObject(UpdatedUnit);
	GiveDefaultUtilityItemsToSoldier(UpdatedUnit, NewGameState);
	`GAMERULES.SubmitGameState(NewGameState);

	return ELR_NoInterrupt;
}

// Pre end-of month processing. The HQ object responsible for triggering end of month gets ticked before our outposts, so
// we haven't yet run the update routine for the last day of the month. Run it now.
function EventListenerReturn PreEndOfMonth(Object EventData, Object EventSource, XComGameState NewGameState, Name EventID, Object CallbackData)
{
	/* WOTC TODO: Restore this
    local XComGameState_LWOutpost Outpost, NewOutpost;
    local XComGameState_WorldRegion WorldRegion;

    foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_LWOutpost', Outpost)
    {
        WorldRegion = Outpost.GetWorldRegionForOutpost();

        // Skip uncontacted regions.
        if (WorldRegion.ResistanceLevel < eResLevel_Contact)
        {
            continue;
        }

        // See if we already have an outstanding state for this outpost, and create one if not. (This shouldn't ever
        // be the case as this is the first thing done in the end-of-month processing.)
        NewOutpost = XComGameState_LWOutpost(NewGameState.GetGameStateForObjectID(Outpost.ObjectID));
        if (NewOutpost != none)
        {
            `LWTrace("PreEndOfMonth: Found existing outpost");
            Outpost = NewOutpost;
        }
        else
        {
            Outpost = XComGameState_LWOutpost(NewGameState.CreateStateObject(class'XComGameState_LWOutpost', Outpost.ObjectID));
            NewGameState.AddStateObject(Outpost);
        }

        if (Outpost.Update(NewGameState))
        {
            `LWTrace("Update succeeded");
        }
        else
        {
            `LWTrace("Update failed");
        }
    }
	*/
    return ELR_NoInterrupt;
}

// Retreive the amount of supplies to reward for the month by summing up the income pools in each region. This is called twice:
// first to get the value to put in the supply cache, and then again to get the string to display in the UI report. The first
// time will have a non-none GameState that must be used to get the latest outpost states rather than the history, as the history
// won't yet have the state including the last day update from the pre event above.
function EventListenerReturn OnMonthlySuppliesReward(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	/* WOTC TODO: Restore this
	local XComGameStateHistory History;
    local XComGameState_LWOutpost Outpost, NewOutpost;
    local XComLWTuple Tuple;
    local int Supplies;

    History = `XCOMHISTORY;
    Tuple = XComLWTuple(EventData);
    if (Tuple == none || Tuple.Id != 'OverrideSupplyDrop' || Tuple.Data[0].kind != XComLWTVBool || Tuple.Data[0].b == true)
    {
        // Not an expected tuple, or another mod has already done the override: return
        return ELR_NoInterrupt;
    }

    foreach History.IterateByClassType(class'XComGameState_LWOutpost', Outpost)
    {
        // Look for a more recent version in the outstanding game state, if one exists. We don't need to add this to the
        // pending game state if one doesn't exist cause this is a read-only operation on the outpost. We should generally
        // find an existing state here cause the pre event above should have created one and added it.
        if (GameState != none)
        {
            NewOutpost = XComGameState_LWOutpost(GameState.GetGameStateForObjectID(Outpost.ObjectID));
            if (NewOutpost != none)
            {
                `LWTrace("OnMonthlySuppliesReward: Found existing outpost");
                Outpost = NewOutpost;
            }
        }
        Supplies += Outpost.GetEndOfMonthSupply();
    }

    `LWTrace("OnMonthlySuppliesReward: Returning " $ Supplies);
    Tuple.Data[1].i = Supplies;
    Tuple.Data[0].b = true;
	*/
    return ELR_NoInterrupt;
}

// Process Negative Supply income events on EndOfMonth processing
function EventListenerReturn OnMonthlyNegativeSupplyIncome(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateHistory History;
    local XComLWTuple Tuple;
    local int RemainingSupplyLoss, AvengerSupplyLoss;
	local int CacheSupplies;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_ResourceCache CacheState;

    History = `XCOMHISTORY;
    Tuple = XComLWTuple(EventData);
    if (Tuple == none || Tuple.Id != 'NegativeMonthlyIncome')
    {
        // Not an expected tuple
        return ELR_NoInterrupt;
    }
    Tuple.Data[0].b = true; // allow display of negative supplies

	if (Tuple.Data[2].b) { return ELR_NoInterrupt; } // if DisplayOnly, return immediately with no other changes

	// retrieve XComHQ object, since we'll be modifying supplies resource
	foreach GameState.IterateByClassType(class'XComGameState_HeadquartersXCom', XComHQ)
	{
		break;
	}
	if (XComHQ == none)
	{
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
		GameState.AddStateObject(XComHQ);
	}

	RemainingSupplyLoss = -Tuple.Data[1].i;
	AvengerSupplyLoss = Min (RemainingSupplyLoss, XComHQ.GetResourceAmount('Supplies'));
	XComHQ.AddResource(GameState, 'Supplies', -AvengerSupplyLoss);
    `LWTrace("OnNegativeMonthlySupplies : Removed " $ AvengerSupplyLoss $ " supplies from XComHQ");

	RemainingSupplyLoss -= AvengerSupplyLoss;
	if (RemainingSupplyLoss <= 0) { return ELR_NoInterrupt; }

	// retrieve supplies cache, in case there are persisting supplies to be removed
	foreach GameState.IterateByClassType(class'XComGameState_ResourceCache', CacheState)
	{
		break;
	}
	if (CacheState == none)
	{
		CacheState = XComGameState_ResourceCache(History.GetSingleGameStateObjectForClass(class'XComGameState_ResourceCache'));
		GameState.AddStateObject(CacheState);
	}
	CacheSupplies = CacheState.ResourcesRemainingInCache + CacheState.ResourcesToGiveNextScan;

	if (CacheSupplies > 0)
	{
		if (RemainingSupplyLoss > CacheSupplies) // unlikely, but just in case
		{
			// remove all resources, and hide it
			CacheState.ResourcesToGiveNextScan = 0;
			CacheState.ResourcesRemainingInCache = 0;
			CacheState.bNeedsScan = false;
			CacheState.NumScansCompleted = 999;
			`LWTrace("OnNegativeMonthlySupplies : Removed existing supply cache");
		}
		else
		{
			CacheState.ShowResourceCache(GameState, -RemainingSupplyLoss); // just reduce the existing one
			`LWTrace("OnNegativeMonthlySupplies : Removed " $ RemainingSupplyLoss $ " supplies from existing supply cache");
		}
	}

    return ELR_NoInterrupt;
}

// Recruit updating.
function EventListenerReturn OnMonthEnd(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
    local XComGameState_HeadquartersResistance ResistanceHQ;
	local XComGameState_Unit UnitState;
	local StateObjectReference UnitRef;

	History = `XCOMHISTORY;
	ResistanceHQ = XComGameState_HeadquartersResistance(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("");

    // Add utility items to each recruit
	foreach ResistanceHQ.Recruits(UnitRef)
	{
		UnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', UnitRef.ObjectID));
		NewGameState.AddStateObject(UnitState);
		GiveDefaultUtilityItemsToSoldier(UnitState, NewGameState);
	}

	if (NewGameState.GetNumGameStateObjects() > 0)
		`GAMERULES.SubmitGameState(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);

	return ELR_NoInterrupt;
}

// Post end of month processing: called after closing the report UI.
function EventListenerReturn PostEndOfMonth(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	/* WOTC TODO: Restore this
    local XComGameStateHistory History;
	local XComGameState NewGameState;
    local XComGameState_LWOutpost Outpost, NewOutpost;

    History = `XCOMHISTORY;
    NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("");

    `LWTrace("Running post end of month update");

    // Do end-of-month processing on each outpost.
    foreach History.IterateByClassType(class'XComGameState_LWOutpost', Outpost)
	{
        // Check for existing game states (there shouldn't be any, since this is invoked after the HQ updates are
        // submitted to history.)
        NewOutpost = XComGameState_LWOutpost(NewGameState.GetGameStateForObjectID(Outpost.ObjectID));
        if (NewOutpost != none)
        {
            Outpost = NewOutpost;
            `LWTrace("PostEndOfMonth: Found existing outpost");
        }
        else
        {
		    Outpost = XComGameState_LWOutpost(NewGameState.CreateStateObject(class'XComGameState_LWOutpost', Outpost.ObjectID));
            NewGameState.AddStateObject(Outpost);
        }

        Outpost.OnMonthEnd(NewGameState);
	}

    if (NewGameState.GetNumGameStateObjects() > 0)
		`GAMERULES.SubmitGameState(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);
	*/
	return ELR_NoInterrupt;
}

static function GiveDefaultUtilityItemsToSoldier(XComGameState_Unit UnitState, XComGameState NewGameState)
{
	local array<XComGameState_Item> CurrentInventory;
	local XComGameState_Item InventoryItem;
	local array<X2EquipmentTemplate> DefaultEquipment;
	local X2EquipmentTemplate EquipmentTemplate;
	local XComGameState_Item ItemState;
	local X2ItemTemplateManager ItemTemplateManager;
	local InventoryLoadout RequiredLoadout;
	local array<name> RequiredNames;
	local InventoryLoadoutItem LoadoutItem;
	local bool bRequired;
	local int idx;

	UnitState.bIgnoreItemEquipRestrictions = true;

	//first remove any existing utility slot items the unit has, that aren't on the RequiredLoadout
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	idx = ItemTemplateManager.Loadouts.Find('LoadoutName', UnitState.GetMyTemplate().RequiredLoadout);
	if(idx != -1)
	{
		RequiredLoadout = ItemTemplateManager.Loadouts[idx];
		foreach RequiredLoadout.Items(LoadoutItem)
		{
			RequiredNames.AddItem(LoadoutItem.Item);
		}
	}
	CurrentInventory = UnitState.GetAllInventoryItems(NewGameState);
	foreach CurrentInventory(InventoryItem)
	{
		bRequired = RequiredNames.Find(InventoryItem.GetMyTemplateName()) != -1;
		if(!bRequired && InventoryItem.InventorySlot == eInvSlot_Utility)
		{
			UnitState.RemoveItemFromInventory(InventoryItem, NewGameState);
		}
	}

	//equip the default loadout
	DefaultEquipment = GetCompleteDefaultLoadout(UnitState);
	foreach DefaultEquipment(EquipmentTemplate)
	{
		if(EquipmentTemplate.InventorySlot == eInvSlot_Utility)
		{
			ItemState = EquipmentTemplate.CreateInstanceFromTemplate(NewGameState);
			NewGameState.AddStateObject(ItemState);
			UnitState.AddItemToInventory(ItemState, eInvSlot_Utility, NewGameState);
		}
	}
	UnitState.bIgnoreItemEquipRestrictions = false;
}

// combines rookie and squaddie loadouts so that things like kevlar armor and grenades are included
// but without the silliness of "only one item per slot type"
static function array<X2EquipmentTemplate> GetCompleteDefaultLoadout(XComGameState_Unit UnitState)
{
	local x2itemtemplatemanager itemtemplatemanager;
	local x2soldierclasstemplate soldierclasstemplate;
	local inventoryloadout loadout;
	local inventoryloadoutitem loadoutitem;
	local x2equipmenttemplate equipmenttemplate;
	local array<x2equipmenttemplate> completedefaultloadout;
	local int idx;

	itemtemplatemanager = class'x2itemtemplatemanager'.static.getitemtemplatemanager();

	// first grab squaddie loadout if possible
	soldierclasstemplate = UnitState.getsoldierclasstemplate();

	if(soldierclasstemplate != none && soldierclasstemplate.squaddieloadout != '')
	{
		idx = itemtemplatemanager.loadouts.find('loadoutname', soldierclasstemplate.squaddieloadout);
		if(idx != -1)
		{
			loadout = itemtemplatemanager.loadouts[idx];
			foreach loadout.items(loadoutitem)
			{
				equipmenttemplate = x2equipmenttemplate(itemtemplatemanager.finditemtemplate(loadoutitem.item));
				if(equipmenttemplate != none)
					completedefaultloadout.additem(equipmenttemplate);
			}
		}
		return completedefaultloadout;
	}

	// grab default loadout
	idx = itemtemplatemanager.loadouts.find('loadoutname', UnitState.getmytemplate().defaultloadout);
	if(idx != -1)
	{
		loadout = itemtemplatemanager.loadouts[idx];
		foreach loadout.items(loadoutitem)
		{
			equipmenttemplate = x2equipmenttemplate(itemtemplatemanager.finditemtemplate(loadoutitem.item));
			if(equipmenttemplate != none)
					completedefaultloadout.additem(equipmenttemplate);
		}
	}

	return completedefaultloadout;
}

function UIScreen GetScreenOrChild(name ScreenType)
{
	local UIScreenStack ScreenStack;
	local int Index;
	ScreenStack = `SCREENSTACK;
	for( Index = 0; Index < ScreenStack.Screens.Length;  ++Index)
	{
		if(ScreenStack.Screens[Index].IsA(ScreenType))
			return ScreenStack.Screens[Index];
	}
	return none;
}

// add restrictions on when units can be editted, have loadout changed, or dismissed, based on status
//function EventListenerReturn OverrideSquadSelectDisableFlags(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
//{
	//local XComLWTuple				OverrideTuple;
	//local UISquadSelect			SquadSelect;
	//local XComGameState_Unit	UnitState;
	//local XComLWTValue				Value;
//
	//`LWTRACE("DisableAutoFillSquad : Starting listener.");
	//OverrideTuple = XComLWTuple(EventData);
	//if(OverrideTuple == none)
	//{
		//`REDSCREEN("OverrideSquadSelectDisableFlags event triggered with invalid event data.");
		//return ELR_NoInterrupt;
	//}
//
	//SquadSelect = UISquadSelect(EventSource);
	//if(SquadSelect == none)
	//{
		//`REDSCREEN("OverrideSquadSelectDisableFlags event triggered with invalid source data.");
		//return ELR_NoInterrupt;
	//}
//
	//if(OverrideTuple.Id != 'OverrideSquadSelectDisableFlags')
		//return ELR_NoInterrupt;
//
	//if (class'XComGameState_HeadquartersXCom'.static.GetObjectiveStatus('T0_M3_WelcomeToHQ') == eObjectiveState_InProgress)
	//{
		////retain this just in case
		//OverrideTuple.Data[0].b = true; // bDisableEdit
		//OverrideTuple.Data[1].b = true; // bDisableDismiss
		//OverrideTuple.Data[2].b = false; // bDisableLoadout
		//return ELR_NoInterrupt;
	//}
	//UnitState = XComGameState_Unit(OverrideTuple.Data[3].o);
	//if (UnitState == none) { return ELR_NoInterrupt; }
//
	///* WOTC TODO: Requires LWDLCHelpers
	//if (class'LWDLCHelpers'.static.IsUnitOnMission(UnitState))
	//{
		//OverrideTuple.Data[0].b = false; // bDisableEdit
		//OverrideTuple.Data[1].b = true; // bDisableDismiss
		//OverrideTuple.Data[2].b = true; // bDisableLoadout
//
		//Value.Kind = XComLWTVInt;
		//Value.i = eInvSlot_Utility;
		//OverrideTuple.Data.AddItem(Value);
//
		//Value.i = eInvSlot_Armor;
		//OverrideTuple.Data.AddItem(Value);
//
		//Value.i = eInvSlot_GrenadePocket;
		//OverrideTuple.Data.AddItem(Value);
//
		//Value.i = eInvSlot_GrenadePocket;
		//OverrideTuple.Data.AddItem(Value);
//
		//Value.i = eInvSlot_PrimaryWeapon;
		//OverrideTuple.Data.AddItem(Value);
//
		//Value.i = eInvSlot_SecondaryWeapon;
		//OverrideTuple.Data.AddItem(Value);
//
		//Value.i = eInvSlot_HeavyWeapon;
		//OverrideTuple.Data.AddItem(Value);
//
		//Value.i = eInvSlot_TertiaryWeapon;
		//OverrideTuple.Data.AddItem(Value);
//
		//Value.i = eInvSlot_QuaternaryWeapon;
		//OverrideTuple.Data.AddItem(Value);
//
		//Value.i = eInvSlot_QuinaryWeapon;
		//OverrideTuple.Data.AddItem(Value);
//
		//Value.i = eInvSlot_SenaryWeapon;
		//OverrideTuple.Data.AddItem(Value);
//
		//Value.i = eInvSlot_SeptenaryWeapon;
		//OverrideTuple.Data.AddItem(Value);
//
		//`LWTRACE("OverrideSquadSelectDisableFlags : Disabling Dismiss/Loadout for Status OnMission soldier");
	//}
	//*/
	//`LWTRACE("OverrideSquadSelectDisableFlags : Reached end of event handler.");
//
	//return ELR_NoInterrupt;
//}

///////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////  TO HIT MOD LISTENERS //////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////

//function EventListenerReturn ToHitOverrideListener(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
//{
	//local XComLWTuple						OverrideToHit;
	//local X2AbilityToHitCalc				ToHitCalc;
	//local X2AbilityToHitCalc_StandardAim	StandardAim;
	//local ToHitAdjustments					Adjustments;
	//local ShotModifierInfo					ModInfo;
//
	////`LWTRACE("OverrideToHit : Starting listener delegate.");
	//OverrideToHit = XComLWTuple(EventData);
	//if(OverrideToHit == none)
	//{
		//`REDSCREEN("ToHitOverride event triggered with invalid event data.");
		//return ELR_NoInterrupt;
	//}
	////`LWTRACE("OverrideToHit : Parsed XComLWTuple.");
//
	//ToHitCalc = X2AbilityToHitCalc(EventSource);
	//if(ToHitCalc == none)
	//{
		//`REDSCREEN("ToHitOverride event triggered with invalid source data.");
		//return ELR_NoInterrupt;
	//}
	////`LWTRACE("OverrideToHit : EventSource valid.");
//
	//StandardAim = X2AbilityToHitCalc_StandardAim(ToHitCalc);
	//if(StandardAim == none)
	//{
		////exit silently with no error, since we're just intercepting StandardAim
		//return ELR_NoInterrupt;
	//}
	////`LWTRACE("OverrideToHit : Is StandardAim.");
//
	//if(OverrideToHit.Id != 'FinalizeHitChance')
		//return ELR_NoInterrupt;
//
	////`LWTRACE("OverrideToHit : XComLWTuple ID matches, ready to override!");
//
	//GetUpdatedHitChances(StandardAim, Adjustments);
//
	//StandardAim.m_ShotBreakdown.FinalHitChance = StandardAim.m_ShotBreakdown.ResultTable[eHit_Success] + Adjustments.DodgeHitAdjust;
	//StandardAim.m_ShotBreakdown.ResultTable[eHit_Crit] = Adjustments.FinalCritChance;
	//StandardAim.m_ShotBreakdown.ResultTable[eHit_Success] = Adjustments.FinalSuccessChance;
	//StandardAim.m_ShotBreakdown.ResultTable[eHit_Graze] = Adjustments.FinalGrazeChance;
	//StandardAim.m_ShotBreakdown.ResultTable[eHit_Miss] = Adjustments.FinalMissChance;
//
	//if(Adjustments.DodgeHitAdjust != 0)
	//{
		//ModInfo.ModType = eHit_Success;
		//ModInfo.Value   = Adjustments.DodgeHitAdjust;
		//ModInfo.Reason  = class'XLocalizedData'.default.DodgeStat;
		//StandardAim.m_ShotBreakdown.Modifiers.AddItem(ModInfo);
	//}
	//if(Adjustments.ConditionalCritAdjust != 0)
	//{
		//ModInfo.ModType = eHit_Crit;
		//ModInfo.Value   = Adjustments.ConditionalCritAdjust;
		//ModInfo.Reason  = strCritReductionFromConditionalToHit;
		//StandardAim.m_ShotBreakdown.Modifiers.AddItem(ModInfo);
	//}
	//if(Adjustments.DodgeCritAdjust != 0)
	//{
		//ModInfo.ModType = eHit_Crit;
		//ModInfo.Value   = Adjustments.DodgeCritAdjust;
		//ModInfo.Reason  = class'XLocalizedData'.default.DodgeStat;
		//StandardAim.m_ShotBreakdown.Modifiers.AddItem(ModInfo);
	//}
//
	//OverrideToHit.Data[0].b = true;
//
	//return ELR_NoInterrupt;
//}

//doesn't actually assign anything to the ToHitCalc, just computes relative to-hit adjustments
//function GetUpdatedHitChances(X2AbilityToHitCalc_StandardAim ToHitCalc, out ToHitAdjustments Adjustments)
//{
	//local int GrazeBand;
	//local int CriticalChance, DodgeChance;
	//local int MissChance, HitChance, CritChance;
	//local int GrazeChance, GrazeChance_Hit, GrazeChance_Miss;
	//local int CritPromoteChance_HitToCrit;
	//local int CritPromoteChance_GrazeToHit;
	//local int DodgeDemoteChance_CritToHit;
	//local int DodgeDemoteChance_HitToGraze;
	//local int DodgeDemoteChance_GrazeToMiss;
	//local int i;
	//local EAbilityHitResult HitResult;
	//local bool bLogHitChance;
//
	//bLogHitChance = false;
//
	//if(bLogHitChance)
	//{
		//`LWTRACE("==" $ GetFuncName() $ "==\n");
		//`LWTRACE("Starting values...", bLogHitChance);
		//for (i = 0; i < eHit_MAX; ++i)
		//{
			//HitResult = EAbilityHitResult(i);
			//`LWTRACE(HitResult $ ":" @ ToHitCalc.m_ShotBreakdown.ResultTable[i]);
		//}
	//}
//
	//// STEP 1 "Band of hit values around nominal to-hit that results in a graze
	//GrazeBand = `LWOVERHAULOPTIONS.GetGrazeBand();
//
	//// options to zero out the band for certain abilities -- either GuaranteedHit or an ability-by-ability
	//if (default.GUARANTEED_HIT_ABILITIES_IGNORE_GRAZE_BAND && ToHitCalc.bGuaranteedHit)
	//{
		//GrazeBand = 0;
	//}
//
	//HitChance = ToHitCalc.m_ShotBreakdown.ResultTable[eHit_Success];
	//if(HitChance < 0)
	//{
		//GrazeChance = Max(0, GrazeBand + HitChance); // if hit drops too low, there's not even a chance to graze
	//} else if(HitChance > 100)
	//{
		//GrazeChance = Max(0, GrazeBand - (HitChance-100));  // if hit is high enough, there's not even a chance to graze
	//} else {
		//GrazeChance_Hit = Clamp(HitChance, 0, GrazeBand); // captures the "low" side where you just barely hit
		//GrazeChance_Miss = Clamp(100 - HitChance, 0, GrazeBand);  // captures the "high" side where  you just barely miss
		//GrazeChance = GrazeChance_Hit + GrazeChance_Miss;
	//}
	//if(bLogHitChance)
		//`LWTRACE("Graze Chance from band = " $ GrazeChance, bLogHitChance);
//
	////STEP 2 Update Hit Chance to remove GrazeChance -- for low to-hits this can be zero
	//HitChance = Clamp(Min(100, HitChance)-GrazeChance_Hit, 0, 100-GrazeChance);
	//if(bLogHitChance)
		//`LWTRACE("HitChance after graze graze band removal = " $ HitChance, bLogHitChance);
//
	////STEP 3 "Crits promote from graze to hit, hit to crit
	//CriticalChance = ToHitCalc.m_ShotBreakdown.ResultTable[eHit_Crit];
	//if (ALLOW_NEGATIVE_DODGE && ToHitCalc.m_ShotBreakdown.ResultTable[eHit_Graze] < 0)
	//{
		//// negative dodge acts like crit, if option is enabled
		//CriticalChance -= ToHitCalc.m_ShotBreakdown.ResultTable[eHit_Graze];
	//}
	//CriticalChance = Clamp(CriticalChance, 0, 100);
	//CritPromoteChance_HitToCrit = Round(float(HitChance) * float(CriticalChance) / 100.0);
//
	////if (!ToHitCalc.bAllowCrit) JL -- Took this out b/c it was impacting biggest booms, hopefully we don't need it
	////{
		////CritPromoteChance_HitToCrit = 0;
	////}
//
	//CritPromoteChance_GrazeToHit = Round(float(GrazeChance) * float(CriticalChance) / 100.0);
	//if(bLogHitChance)
	//{
		//`LWTRACE("CritPromoteChance_HitToCrit = " $ CritPromoteChance_HitToCrit, bLogHitChance);
		//`LWTRACE("CritPromoteChance_GrazeToHit = " $ CritPromoteChance_GrazeToHit, bLogHitChance);
	//}
//
	//CritChance = CritPromoteChance_HitToCrit; // crit chance is the chance you promoted to crit
	//HitChance = HitChance + CritPromoteChance_GrazeToHit - CritPromoteChance_HitToCrit;  // add chance for promote from dodge, remove for promote to crit
	//GrazeChance = GrazeChance - CritPromoteChance_GrazeToHit; // remove chance for promote to hit
	//if(bLogHitChance)
	//{
		//`LWTRACE("PostCrit:", bLogHitChance);
		//`LWTRACE("CritChance  = " $ CritChance, bLogHitChance);
		//`LWTRACE("HitChance   = " $ HitChance, bLogHitChance);
		//`LWTRACE("GrazeChance = " $ GrazeChance, bLogHitChance);
	//}
//
	////save off loss of crit due to conditional on to-hit
	//Adjustments.ConditionalCritAdjust = -(CriticalChance - CritPromoteChance_HitToCrit);
//
	////STEP 4 "Dodges demotes from crit to hit, hit to graze, (optional) graze to miss"
	//if (ToHitCalc.m_ShotBreakdown.ResultTable[eHit_Graze] > 0)
	//{
		//DodgeChance = Clamp(ToHitCalc.m_ShotBreakdown.ResultTable[eHit_Graze], 0, 100);
		//DodgeDemoteChance_CritToHit = Round(float(CritChance) * float(DodgeChance) / 100.0);
		//DodgeDemoteChance_HitToGraze = Round(float(HitChance) * float(DodgeChance) / 100.0);
		//if(DODGE_CONVERTS_GRAZE_TO_MISS)
		//{
			//DodgeDemoteChance_GrazeToMiss = Round(float(GrazeChance) * float(DodgeChance) / 100.0);
		//}
		//CritChance = CritChance - DodgeDemoteChance_CritToHit;
		//HitChance = HitChance + DodgeDemoteChance_CritToHit - DodgeDemoteChance_HitToGraze;
		//GrazeChance = GrazeChance + DodgeDemoteChance_HitToGraze - DodgeDemoteChance_GrazeToMiss;
//
		//if(bLogHitChance)
		//{
			//`LWTRACE("DodgeDemoteChance_CritToHit   = " $ DodgeDemoteChance_CritToHit);
			//`LWTRACE("DodgeDemoteChance_HitToGraze  = " $ DodgeDemoteChance_HitToGraze);
			//`LWTRACE("DodgeDemoteChance_GrazeToMiss = " $DodgeDemoteChance_GrazeToMiss);
			//`LWTRACE("PostDodge:");
			//`LWTRACE("CritChance  = " $ CritChance);
			//`LWTRACE("HitChance   = " $ HitChance);
			//`LWTRACE("GrazeChance = " $ GrazeChance);
		//}
//
		////save off loss of crit due to dodge demotion
		//Adjustments.DodgeCritAdjust = -DodgeDemoteChance_CritToHit;
//
		////save off loss of to-hit due to dodge demotion of graze to miss
		//Adjustments.DodgeHitAdjust = -DodgeDemoteChance_GrazeToMiss;
	//}
//
	////STEP 5 Store
	//Adjustments.FinalCritChance = CritChance;
	//Adjustments.FinalSuccessChance = HitChance;
	//Adjustments.FinalGrazeChance = GrazeChance;
//
	////STEP 6 Miss chance is what is left over
	//MissChance = 100 - (CritChance + HitChance + GrazeChance);
	//Adjustments.FinalMissChance = MissChance;
	//if(MissChance < 0)
	//{
		////This is an error so flag it
		//`REDSCREEN("OverrideToHit : Negative miss chance!");
	//}
//}

// Fetch the true supply reward for a region. This only gets the value, it doesn't reset the accumulated pool to zero.
function EventListenerReturn OnGetSupplyDrop(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	/* WOTC TODO: Restore this
    local XComGameState_WorldRegion Region;
    local XComGameState_LWOutpostManager OutpostMgr;
    local XComGameState_LWOutpost Outpost;
    local XComLWTuple Tuple;
    local XComLWTValue Value;

    Tuple = XComLWTuple(EventData);
    Region = XComGameState_WorldRegion(EventSource);

    if (Tuple == none || Tuple.Id != 'GetSupplyDropReward' || Tuple.Data.Length > 0)
    {
        // Either this is a tuple we don't recognize or some other mod got here first and defined the reward. Just return.
        return ELR_NoInterrupt;
    }

    OutpostMgr = `LWOUTPOSTMGR;
    Outpost = OutpostMgr.GetOutpostForRegion(Region);
    Value.Kind = XComLWTVInt;
    Value.i = Outpost.GetIncomePoolForJob('Resupply');
    Tuple.Data.AddItem(Value);
	*/
    return ELR_NoInterrupt;
}

function EventListenerReturn OnNumCiviliansKilled(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
    local XComLWTuple Tuple;
    local XComLWTValue Value;
    local XGBattle_SP Battle;
    local XComGameState_BattleData BattleData;
    local array<XComGameState_Unit> arrUnits;
    local bool RequireEvac;
    local bool PostMission;
	local bool RequireTriadObjective;
    local int i, Total, Killed;
	local array<Name> TemplateFilter;

    Tuple = XComLWTuple(EventData);
    if (Tuple == none || Tuple.Id != 'GetNumCiviliansKilled' || Tuple.Data.Length > 1)
    {
        return ELR_NoInterrupt;
    }

    PostMission = Tuple.Data[0].b;

    switch(class'Utilities_LW'.static.CurrentMissionType())
    {
        case "Terror_LW":
            // For terror, all neutral units are interesting, and we save anyone
            // left on the map if we win the triad objective (= sweep). Rebels left on
			// the map if sweep wasn't completed are lost.
			RequireTriadObjective = true;
            break;
        case "Defend_LW":
            // For defend, all neutral units are interesting, but we don't count
            // anyone left on the map, regardless of win.
            RequireEvac = true;
            break;
        case "Invasion_LW":
            // For invasion, we only want to consider civilians with the 'Rebel' or
            // 'FacelessRebelProxy' templates.
			TemplateFilter.AddItem('Rebel');
            break;
        case "Jailbreak_LW":
            // For jailbreak we only consider evac'd units as 'saved' regardless of whether
            // we have won or not. We also only consider units with the template 'Rebel' or
			// 'Soldier_VIP', and don't count any regular civvies in the mission.
            RequireEvac = true;
            TemplateFilter.AddItem('Rebel');
			TemplateFilter.AddItem('Soldier_VIP');
            break;
        default:
            return ELR_NoInterrupt;
    }

    Battle = XGBattle_SP(`BATTLE);
    BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));

    if (Battle != None)
    {
        Battle.GetCivilianPlayer().GetOriginalUnits(arrUnits);
    }

    for (i = 0; i < arrUnits.Length; ++i)
    {
        if (arrUnits[i].GetMyTemplateName() == 'FacelessRebelProxy')
        {
            // A faceless rebel proxy: we only want to count this guy if it isn't removed from play: they can't
            // be evac'd so if they're removed they must have been revealed so we don't want to count them.
            if (arrUnits[i].bRemovedFromPlay)
            {
                arrUnits.Remove(i, 1);
                --i;
                continue;
            }
        }
        else if (TemplateFilter.Length > 0 && TemplateFilter.Find(arrUnits[i].GetMyTemplateName()) == -1)
        {
            arrUnits.Remove(i, 1);
            --i;
            continue;
        }
    }

    // Compute the number killed
    Total = arrUnits.Length;

    for (i = 0; i < Total; ++i)
    {
        if (arrUnits[i].IsDead())
        {
            ++Killed;
        }
        else if (PostMission && !arrUnits[i].bRemovedFromPlay)
        {
			// If we require the triad objective, units left behind on the map
			// are lost unless it's completed.
			if (RequireTriadObjective && !BattleData.AllTriadObjectivesCompleted())
			{
				++Killed;
			}
            // If we lose or require evac, anyone left on map is killed.
            else if (!BattleData.bLocalPlayerWon || RequireEvac)
			{
                ++Killed;
			}
        }
    }

    Value.Kind = XComLWTVInt;
    Value.i = Killed;
    Tuple.Data.AddItem(Value);

    Value.i = Total;
    Tuple.Data.AddItem(Value);
    return ELR_NoInterrupt;
}

function EventListenerReturn OnSoldierRespecced (Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple OverrideTuple;

	//`LOG ("Firing OnSoldierRespecced");
	OverrideTuple = XComLWTuple(EventData);
	if(OverrideTuple == none)
	{
		`REDSCREEN("On Soldier Respecced event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}
	//`LOG("OverrideTuple : Parsed XComLWTuple.");

	if(OverrideTuple.Id != 'OverrideRespecTimes')
		return ELR_NoInterrupt;

	//`LOG ("Point 2");

	if (default.TIERED_RESPEC_TIMES)
	{
		//Respec days = rank * difficulty setting
		OverrideTuple.Data[1].i = OverrideTuple.Data[0].i * class'XComGameState_HeadquartersXCom'.default.XComHeadquarters_DefaultRespecSoldierDays[`STRATEGYDIFFICULTYSETTING] * 24;
		//`LOG ("Point 3" @ OverrideTuple.Data[1].i @ OverrideTuple.Data[0].i);
	}

	return ELR_NoInterrupt;

}

function EventListenerReturn OnKilledByExplosion(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple				OverrideTuple;
	local XComGameState_Unit		Killer, Target;

	//`LOG ("Firing OnKilledByExplosion");
	OverrideTuple = XComLWTuple(EventData);
	if(OverrideTuple == none)
	{
		`REDSCREEN("OnKilledByExplosion event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}
	//`LOG("OverrideTuple : Parsed XComLWTuple.");

	Target = XComGameState_Unit(EventSource);
	if(Target == none)
		return ELR_NoInterrupt;
	//`LOG("OverrideTuple : EventSource valid.");

	if(OverrideTuple.Id != 'OverrideKilledbyExplosion')
		return ELR_NoInterrupt;

	Killer = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(OverrideTuple.Data[1].i));

	if (OverrideTuple.Data[0].b && Killer.HasSoldierAbility('NeedleGrenades', true))
	{
		OverrideTuple.Data[0].b = false;
		//`LOG ("Converting to non explosive kill");
	}

	return ELR_NoInterrupt;
}

function EventListenerReturn OnShouldUnitPatrol (Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple				OverrideTuple;
	local XComGameState_Unit		UnitState;
	local XComGameState_AIUnitData	AIData;
	local int						AIUnitDataID, idx;
	local XComGameState_Player		ControllingPlayer;
	local bool						bHasValidAlert;

	//`LOG ("Firing OnShouldUnitPatrol");
	OverrideTuple = XComLWTuple(EventData);
	if(OverrideTuple == none)
	{
		`REDSCREEN("OnShouldUnitPatrol event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}
	UnitState = XComGameState_Unit(OverrideTuple.Data[1].o);
	if (default.AI_PATROLS_WHEN_SIGHTED_BY_HIDDEN_XCOM)
	{
		if (UnitState.GetCurrentStat(eStat_AlertLevel) <= `ALERT_LEVEL_YELLOW)
		{
			if (UnitState.GetCurrentStat(eStat_AlertLevel) == `ALERT_LEVEL_YELLOW)
			{
				// don't do normal patrolling if the unit has current AlertData
				AIUnitDataID = UnitState.GetAIUnitDataID();
				if (AIUnitDataID > 0)
				{
					if (NewGameState != none)
						AIData = XComGameState_AIUnitData(NewGameState.GetGameStateForObjectID(AIUnitDataID));

					if (AIData == none)
					{
						AIData = XComGameState_AIUnitData(`XCOMHISTORY.GetGameStateForObjectID(AIUnitDataID));
					}
					if (AIData != none)
					{
						if (AIData.m_arrAlertData.length == 0)
						{
							OverrideTuple.Data[0].b = true;
						}
						else // there is some alert data, but how old ?
						{
							ControllingPlayer = XComGameState_Player(`XCOMHISTORY.GetGameStateForObjectID(UnitState.ControllingPlayer.ObjectID));
							for (idx = 0; idx < AIData.m_arrAlertData.length; idx++)
							{
								if (ControllingPlayer.PlayerTurnCount - AIData.m_arrAlertData[idx].PlayerTurn < 3)
								{
									bHasValidAlert = true;
									break;
								}
							}
							if (!bHasValidAlert)
							{
								OverrideTuple.Data[0].b = true;
							}
						}
					}
				}
			}
			OverrideTuple.Data[0].b = true;
		}
	}
	return ELR_NoInterrupt;
}

function EventListenerReturn GetPCSImage(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple			OverridePCSImageTuple;
	local string				ReturnImagePath;
	local XComGameState_Item	ItemState;
	//local UIUtilities_Image		Utility;

	OverridePCSImageTuple = XComLWTuple(EventData);
	if(OverridePCSImageTuple == none)
	{
		`REDSCREEN("OverrideGetPCSImage event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}
	//`LOG("OverridePCSImageTuple : Parsed XComLWTuple.");

	ItemState = XComGameState_Item(EventSource);
	if(ItemState == none)
		return ELR_NoInterrupt;
	//`LOG("OverridePCSImageTuple : EventSource valid.");

	if(OverridePCSImageTuple.Id != 'OverrideGetPCSImage')
		return ELR_NoInterrupt;

	switch (ItemState.GetMyTemplateName())
	{
		case 'DepthPerceptionPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_depthperception"; break;
		case 'HyperReactivePupilsPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_hyperreactivepupils"; break;
		case 'CombatAwarenessPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_threatassessment"; break;
		case 'DamageControlPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_damagecontrol"; break;
		case 'AbsorptionFieldsPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_impactfield"; break;
		case 'BodyShieldPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_bodyshield"; break;
		case 'EmergencyLifeSupportPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_emergencylifesupport"; break;
		case 'IronSkinPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_ironskin"; break;
		case 'SmartMacrophagesPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_smartmacrophages"; break;
		case 'CombatRushPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_combatrush"; break;
		case 'CommonPCSDefense': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_defense"; break;
		case 'RarePCSDefense': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_defense"; break;
		case 'EpicPCSDefense': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_defense"; break;
		case 'CommonPCSAgility': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_dodge"; break;
		case 'RarePCSAgility': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_dodge"; break;
		case 'EpicPCSAgility': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_dodge"; break;
		case 'CommonPCSHacking': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_hacking"; break;
		case 'RarePCSHacking': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_hacking"; break;
		case 'EpicPCSHacking': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_hacking"; break;
		case 'FireControl25PCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_firecontrol"; break;
		case 'FireControl50PCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_firecontrol"; break;
		case 'FireControl75PCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_firecontrol"; break;

		default:  OverridePCSImageTuple.Data[0].b = false;
	}
	ReturnImagePath = OverridePCSImageTuple.Data[1].s;  // anything set by any other listener that went first
	ReturnImagePath = ReturnImagePath;

	//`LOG("GetPCSImage Override : working!.");

	return ELR_NoInterrupt;
}

function EventListenerReturn OnCleanupTacticalMission(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
    local XComGameState_BattleData BattleData;
    local XComGameState_Unit Unit;
    local XComGameStateHistory History;
	local XComGameState_Effect EffectState;
	local StateObjectReference EffectRef;
	local bool AwardWrecks;

    History = `XCOMHISTORY;
    BattleData = XComGameState_BattleData(EventData);
    BattleData = XComGameState_BattleData(NewGameState.GetGameStateForObjectID(BattleData.ObjectID));

	// If we completed this mission with corpse recovery, you get the wreck/loot from any turret
	// left on the map as well as any Mastered unit that survived but is not eligible to be
	// transferred to a haven.
	AwardWrecks = BattleData.AllTacticalObjectivesCompleted();

    if (AwardWrecks)
    {
        // If we have completed the tactical objectives (e.g. sweep) we are collecting corpses.
        // Generate wrecks for each of the turrets left on the map that XCOM didn't kill before
        // ending the mission.
        foreach History.IterateByClassType(class'XComGameState_Unit', Unit)
        {
            if (Unit.IsTurret() && !Unit.IsDead())
            {
                // We can't call the RollForAutoLoot() function here because we have a pending
                // gamestate with a modified BattleData already. Just add a corpse to the list
                // of pending auto loot.
                BattleData.AutoLootBucket.AddItem('CorpseAdventTurret');
            }
        }
    }

	// Handle effects that can only be performed at mission end:
	//
	// Handle full override mecs. Look for units with a full override effect that are not dead
	// or captured. This is done here instead of in an OnEffectRemoved hook, because effect removal
	// isn't fired when the mission ends on a sweep, just when they evac. Other effect cleanup
	// typically happens in UnitEndedTacticalPlay, but since we need to update the haven gamestate
	// we can't use that: we don't get a reference to the current XComGameState being submitted.
	// This works because the X2Effect_TransferMecToOutpost code sets up its own UnitRemovedFromPlay
	// event listener, overriding the standard one in XComGameState_Effect, so the effect won't get
	// removed when the unit is removed from play and we'll see it here.
	//
	// Handle Field Surgeon. We can't let the effect get stripped on evac via OnEffectRemoved because
	// the surgeon themself may die later in the mission. We need to wait til mission end and figure out
	// which effects to apply.
	//
	// Also handle units that are still living but are affected by mind-control - if this is a corpse
	// recovering mission, roll their auto-loot so that corpses etc. are granted despite them not actually
	// being killed.

	foreach History.IterateByClassType(class'XComGameState_Unit', Unit)
	{
		if(Unit.IsAlive() && !Unit.bCaptured)
		{
			foreach Unit.AffectedByEffects(EffectRef)
			{
				EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
				if (EffectState.GetX2Effect().EffectName == class'X2Effect_TransferMecToOutpost'.default.EffectName)
				{
					X2Effect_TransferMecToOutpost(EffectState.GetX2Effect()).AddMECToOutpostIfValid(EffectState, Unit, NewGameState, AwardWrecks);
				}
				else if (EffectState.GetX2Effect().EffectName == class'X2Effect_FieldSurgeon'.default.EffectName)
				{
					X2Effect_FieldSurgeon(EffectState.GetX2Effect()).ApplyFieldSurgeon(EffectState, Unit, NewGameState);
				}
				else if (EffectState.GetX2Effect().EffectName == class'X2Effect_MindControl'.default.EffectName && AwardWrecks)
				{
					Unit.RollForAutoLoot(NewGameState);

					// Super hacks for andromedon, since only the robot drops a corpse.
					if (Unit.GetMyTemplateName() == 'Andromedon')
					{
						BattleData.AutoLootBucket.AddItem('CorpseAndromedon');
					}
				}
			}
		}
	}

    return ELR_NoInterrupt;
}

function EventListenerReturn OnRegionBuiltOutpost(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
    local XComGameStateHistory History;
    local XComGameState_WorldRegion Region;
    local XComGameState NewGameState;

    History = `XCOMHISTORY;
    foreach History.IterateByClassType(class'XComGameState_WorldRegion', Region)
    {
        // Look for regions that have an outpost built, which have their "bScanforOutpost" flag reset
        // (this is cleared by XCGS_WorldRegion.Update() when the scan finishes) and the scan has begun.
        // For these regions, reset the scan. This will reset the scanner UI to "empty". The reset
        // call will reset the scan started flag so subsequent triggers will not redo this change
        // for this region.
        if (Region.ResistanceLevel == eResLevel_Outpost &&
            !Region.bCanScanForOutpost &&
            Region.GetScanPercentComplete() > 0)
        {
            NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Reset outpost scanner");
            Region = XComGameState_WorldRegion(NewGameState.CreateStateObject(class'XComGameState_WorldRegion', Region.ObjectID));
            NewGameState.AddStateObject(Region);
            Region.ResetScan();
            `GAMERULES.SubmitGameState(NewGameState);
        }
    }

    return ELR_NoInterrupt;
}

function EventListenerReturn OnGetRewardVIPStatus(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
    local XComLWTuple Tuple;
    local XComLWTValue Value;
    local XComGameState_Unit Unit;
    local XComGameState_MissionSite MissionSite;

    Tuple = XComLWTuple(EventData);
    // Not a tuple or already filled out?
    if (Tuple == none || Tuple.Data.Length != 1 || Tuple.Data[0].Kind != XComLWTVObject)
    {
        return ELR_NoInterrupt;
    }

    // Make sure we have a unit
    Unit = XComGameState_Unit(Tuple.Data[0].o);
    if (Unit == none)
    {
        return ELR_NoInterrupt;
    }

    // Make sure we have a mission site
    MissionSite = XComGameState_MissionSite(EventSource);
    if (MissionSite == none)
    {
        return ELR_NoInterrupt;
    }

    if (MissionSite.GeneratedMission.Mission.sType == "Jailbreak_LW")
    {
        // Jailbreak mission: Only evac'd units are considered rescued.
        // (But dead ones are still dead!)
        Value.Kind = XComLWTVInt;
        if (Unit.IsDead())
        {
            Value.i = eVIPStatus_Killed;
        }
        else
        {
            Value.i = Unit.bRemovedFromPlay ? eVIPStatus_Recovered : eVIPStatus_Lost;
        }
        Tuple.Data.AddItem(Value);
    }

    return ELR_NoInterrupt;
}

// Allow mods to query the LW version number. Trigger the 'GetLWVersion' event with an empty tuple as the eventdata and it will
// return a 3-tuple of ints with Data[0]=Major, Data[1]=Minor, and Data[2]=Build.
function EventListenerReturn OnGetLWVersion(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
    local XComLWTuple Tuple;
    local int Major, Minor, Build;
    Tuple = XComLWTuple(EventData);
    if (Tuple == none)
    {
        return ELR_NoInterrupt;
    }

    class'LWVersion'.static.GetVersionNumber(Major, Minor, Build);
    Tuple.Data.Add(3);
    Tuple.Data[0].Kind = XComLWTVInt;
    Tuple.Data[0].i = Major;
    Tuple.Data[1].Kind = XComLWTVInt;
    Tuple.Data[1].i = Minor;
    Tuple.Data[2].Kind = XComLWTVInt;
    Tuple.Data[2].i = Build;

    return ELR_NoInterrupt;
}

// It's school picture day. Add all the rebels.
function EventListenerReturn OnRefreshCrewPhotographs(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	/* WOTC TODO: Restore this
    local XComLWTuple Tuple;
    local XComLWTValue Value;
    local XComGameState_LWOutpost Outpost;
    local XComGameState_WorldRegion Region;
    local int i;

    Tuple = XComLWTuple(EventData);
    if (Tuple == none)
    {
        return ELR_NoInterrupt;
    }

    Value.Kind = XComLWTVInt;
    foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_LWOutpost', Outpost)
    {
        Region = Outpost.GetWorldRegionForOutPost();
        if (!Region.HaveMadeContact())
            continue;

        for (i = 0; i < Outpost.Rebels.Length; ++i)
        {
            Value.i = Outpost.Rebels[i].Unit.ObjectID;
            Tuple.Data.AddItem(Value);
        }
    }
	*/
    return ELR_NoInterrupt;
}

// Override how the UFO interception works, since we don't use the calendar
function EventListenerReturn OnUFOSetInfiltrationTime(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
    local XComGameState_UFO UFO;
	local int HoursUntilIntercept;

    UFO = XComGameState_UFO(EventData);
    if (UFO == none)
    {
        return ELR_NoInterrupt;
    }

	if (UFO.bDoesInterceptionSucceed)
	{
		UFO.InterceptionTime == UFO.GetCurrentTime();

		HoursUntilIntercept = (UFO.MinNonInterceptDays * 24) + `SYNC_RAND((UFO.MaxNonInterceptDays * 24) - (UFO.MinNonInterceptDays * 24) + 1);
		class'X2StrategyGameRulesetDataStructures'.static.AddHours(UFO.InterceptionTime, HoursUntilIntercept);
	}

    return ELR_NoInterrupt;
}

function EventListenerReturn OnGetSupplyDropDecreaseStrings(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	/* WOTC TODO: Restore this
    local XComGameState_LWOutpost Outpost;
    local XComGameStateHistory History;
    local XComLWTuple Tuple;
    local XComLWTValue Value;
    local int NetSupplies;
    local int GrossSupplies;
    local int SupplyDelta;

    Tuple = XComLWTuple(EventData);
    if (Tuple == none || Tuple.Data.Length > 0)
    {
        return ELR_NoInterrupt;
    }

    // Figure out how many supplies we have lost.
    History = `XCOMHISTORY;
    foreach History.IterateByClassType(class'XComGameState_LWOutpost', Outpost)
    {
        GrossSupplies += Outpost.GetIncomePoolForJob('Resupply');
        NetSupplies += Outpost.GetEndOfMonthSupply();
    }

    SupplyDelta = GrossSupplies - NetSupplies;

    if (SupplyDelta > 0)
    {
        Value.Kind = XComLWTVString;
        Value.s = class'UIBarMemorial_Details'.default.m_strUnknownCause;
        Tuple.Data.AddItem(Value);
        Value.s = "-" $ class'UIUtilities_Strategy'.default.m_strCreditsPrefix $ String(int(Abs(SupplyDelta)));
        Tuple.Data.AddItem(Value);
    }
	*/
    return ELR_NoInterrupt;
}

// Grants bonus psi abilities after promotion to squaddie
function EventListenerReturn OnPsiProjectCompleted (Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	local StateObjectReference ProjectFocus;
	local XComGameState_Unit UnitState;
	local X2SoldierClassTemplate SoldierClassTemplate;
	local int BonusAbilityRank, BonusAbilityBranch, BonusAbilitiesGranted, Tries;
	local name BonusAbility;
	local XComGameState NewGameState;

	if (XComGameState_HeadquartersProjectPsiTraining(EventSource) == none)
	{
		`LWTRACE ("OnPsiProjectCompleted called with invalid EventSource.");
		return ELR_NoInterrupt;
	}
	ProjectFocus = XComGameState_HeadquartersProjectPsiTraining(EventSource).ProjectFocus;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ProjectFocus.ObjectID));

	if (UnitState == none || UnitState.GetRank() != 1)
	{
		`LWTRACE ("OnPsiProjectCompleted could not find valid unit state.");
		return ELR_NoInterrupt;
	}

	BonusAbilitiesGranted = 0;

	SoldierClassTemplate = UnitState.GetSoldierClassTemplate();
	if (SoldierClassTemplate == none)
	{
		`LWTRACE ("OnPsiProjectCompleted could not find valid class template for unit.");
		return ELR_NoInterrupt;
	}

	Tries = 0;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Granting Bonus Psi Starter abilities");
	while (BonusAbilitiesGranted < default.PSI_SQUADDIE_BONUS_ABILITIES)
	{
		BonusAbilityRank = `SYNC_RAND(1 + (default.PSI_SQUADDIE_BONUS_ABILITIES / 2));
		BonusAbilityBranch = `SYNC_RAND(2);
		BonusAbility = SoldierClassTemplate.GetAbilitySlots(BonusAbilityRank)[BonusAbilityBranch].AbilityType.AbilityName;
		Tries += 1;

		if (!UnitState.HasSoldierAbility(BonusAbility, true))
		{
			if (UnitState.BuySoldierProgressionAbility(NewGameState,BonusAbilityRank,BonusAbilityBranch))
			{
				BonusAbilitiesGranted += 1;
				`LWTRACE("OnPsiProjectCompleted granted bonus ability " $ string(BonusAbility));
			}
		}
		if (Tries > 999)
		{
			`LWTRACE ("OnPsiProjectCompleted Can't find an ability");
			break;
		}
	}

	if (BonusAbilitiesGranted > 0)
	{
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
		`LWTRACE("OnPsiProjectCompleted granted unit " $ UnitState.GetFullName() @ string(BonusAbilitiesGranted) $ " extra psi abilities.");
	}
	else
	{
		`XCOMHISTORY.CleanupPendingGameState(NewGameState);
	}

	return ELR_NoInterrupt;
}

//listener that adds an extra NavHelp button
function EventListenerReturn AddSquadSelectStripWeaponsButton (Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	local UINavigationHelp NavHelp;

	NavHelp = `HQPRES.m_kAvengerHUD.NavHelp;

	NavHelp.AddCenterHelp(class'UIUtilities_LW'.default.m_strStripWeaponUpgrades, "", OnStripUpgrades, false, class'UIUtilities_LW'.default.m_strTooltipStripWeapons);
	
	return ELR_NoInterrupt;
}

function EventListenerReturn AddArmoryStripWeaponsButton (Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	local UINavigationHelp NavHelp;

	NavHelp = `HQPRES.m_kAvengerHUD.NavHelp;

	// Add a button to make upgrades available.
	NavHelp.AddLeftHelp(class'UIUtilities_LW'.default.m_strStripWeaponUpgrades, "", OnStripUpgrades, false, class'UIUtilities_LW'.default.m_strTooltipStripWeapons);
	// Add a button to strip just the upgrades from this weapon.
	NavHelp.AddLeftHelp(Caps(class'UIScreenListener_ArmoryWeaponUpgrade_LW'.default.strStripWeaponUpgradesButton), "", OnStripWeaponClicked, false, class'UIScreenListener_ArmoryWeaponUpgrade_LW'.default.strStripWeaponUpgradesTooltip);
	
	return ELR_NoInterrupt;
}

simulated function OnStripWeaponClicked()
{
	local XComPresentationLayerBase Pres;
	local TDialogueBoxData DialogData;

	Pres = `PRESBASE;
	Pres.PlayUISound(eSUISound_MenuSelect);

	DialogData.eType = eDialog_Warning;
	DialogData.strTitle = class'UIScreenListener_ArmoryWeaponUpgrade_LW'.default.strStripWeaponUpgradeDialogueTitle;
	DialogData.strText = class'UIScreenListener_ArmoryWeaponUpgrade_LW'.default.strStripWeaponUpgradeDialogueText;
	DialogData.strAccept = class'UIUtilities_Text'.default.m_strGenericYes;
	DialogData.strCancel = class'UIUtilities_Text'.default.m_strGenericNO;
	DialogData.fnCallback = ConfirmStripSingleWeaponUpgradesCallback;
	Pres.UIRaiseDialog(DialogData);
}

simulated function ConfirmStripSingleWeaponUpgradesCallback(Name eAction)
{
	local XComGameState_Item ItemState;
	local UIArmory_Loadout LoadoutScreen;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit Soldier;
	local XComGameState UpdateState;

	if (eAction == 'eUIAction_Accept')
	{
		LoadoutScreen = UIArmory_Loadout(`SCREENSTACK.GetFirstInstanceOf(class'UIArmory_Loadout'));
		if (LoadoutScreen != none)
		{
			Soldier = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(LoadoutScreen.GetUnitRef().ObjectID));
			ItemState = Soldier.GetItemInSlot(eInvSlot_PrimaryWeapon);
			if (ItemState != none && ItemState.HasBeenModified())
			{
				UpdateState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Strip Weapon Upgrades");
				XComHQ = `XCOMHQ;
				XComHQ = XComGameState_HeadquartersXCom(UpdateState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
				UpdateState.AddStateObject(XComHQ);
				StripWeaponUpgradesFromItem(ItemState, XComHQ, UpdateState);
				`GAMERULES.SubmitGameState(UpdateState);
				LoadoutScreen.UpdateData(true);
			}
		}
	}
}

simulated function OnStripUpgrades()
{
	local TDialogueBoxData DialogData;
	DialogData.eType = eDialog_Normal;
	DialogData.strTitle = class'UIUtilities_LW'.default.m_strStripWeaponUpgradesConfirm;
	DialogData.strText = class'UIUtilities_LW'.default.m_strStripWeaponUpgradesConfirmDesc;
	DialogData.fnCallback = OnStripUpgradesDialogCallback;
	DialogData.strAccept = class'UIDialogueBox'.default.m_strDefaultAcceptLabel;
	DialogData.strCancel = class'UIDialogueBox'.default.m_strDefaultCancelLabel;
	`HQPRES.UIRaiseDialog(DialogData);
	`HQPRES.m_kAvengerHUD.NavHelp.ClearButtonHelp();
}

simulated function OnStripUpgradesDialogCallback(Name eAction)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState UpdateState;
	local array<StateObjectReference> Inventory;
	local array<XComGameState_Unit> Soldiers;
	local int idx;
	local StateObjectReference ItemRef;
	local XComGameState_Item ItemState;
	local X2EquipmentTemplate EquipmentTemplate;
	local TWeaponUpgradeAvailabilityData WeaponUpgradeAvailabilityData;
	local XComGameState_Unit OwningUnitState;
	local UIArmory_Loadout LoadoutScreen;

	LoadoutScreen = UIArmory_Loadout(`SCREENSTACK.GetFirstInstanceOf(class'UIArmory_Loadout'));

	if (eAction == 'eUIAction_Accept')
	{
		History = `XCOMHISTORY;
		XComHQ =`XCOMHQ;

		//strip upgrades from weapons that aren't equipped to any soldier. We need to fetch, strip, and put the items back in the HQ inventory,
		// which will involve de-stacking and re-stacking items, so do each one in an individual gamestate submission.
		Inventory = class'UIUtilities_Strategy'.static.GetXComHQ().Inventory;
		foreach Inventory(ItemRef)
		{
			ItemState = XComGameState_Item(History.GetGameStateForObjectID(ItemRef.ObjectID));
			if (ItemState != none)
			{
				OwningUnitState = XComGameState_Unit(History.GetGameStateForObjectID(ItemState.OwnerStateObject.ObjectID));
				if (OwningUnitState == none) // only if the item isn't owned by a unit
				{
					EquipmentTemplate = X2EquipmentTemplate(ItemState.GetMyTemplate());
					if(EquipmentTemplate != none && EquipmentTemplate.InventorySlot == eInvSlot_PrimaryWeapon && ItemState.HasBeenModified()) // primary weapon that has been modified
					{
						UpdateState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Strip Unequipped Upgrades");
						XComHQ = XComGameState_HeadquartersXCom(UpdateState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
						UpdateState.AddStateObject(XComHQ);

						// If this is the only instance of this weapon in the inventory we'll just get back a non-updated state.
						// That's ok, StripWeaponUpgradesFromItem will create/add it if it's not already in the update state. If it
						// is, we'll use that one directly to do the stripping.
						XComHQ.GetItemFromInventory(UpdateState, ItemState.GetReference(), ItemState);
						StripWeaponUpgradesFromItem(ItemState, XComHQ, UpdateState);
						ItemState = XComGameState_Item(UpdateState.GetGameStateForObjectID(ItemState.ObjectID));
						XComHQ.PutItemInInventory(UpdateState, ItemState);
						`GAMERULES.SubmitGameState(UpdateState);
					}
				}
			}
		}

		// strip upgrades from weapons on soldiers that aren't active. These can all be batched in one state because
		// soldiers maintain their equipped weapon, so there is no stacking of weapons to consider.
		UpdateState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Strip Unequipped Upgrades");
		XComHQ = XComGameState_HeadquartersXCom(UpdateState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
		UpdateState.AddStateObject(XComHQ);
		Soldiers = GetSoldiersToStrip(XComHQ, UpdateState);
		for (idx = 0; idx < Soldiers.Length; idx++)
		{
			class'UIUtilities_Strategy'.static.GetWeaponUpgradeAvailability(Soldiers[idx], WeaponUpgradeAvailabilityData);
			if (!WeaponUpgradeAvailabilityData.bCanWeaponBeUpgraded)
			{
				continue;
			}

			ItemState = Soldiers[idx].GetItemInSlot(eInvSlot_PrimaryWeapon, UpdateState);
			if (ItemState != none && ItemState.HasBeenModified())
			{
				StripWeaponUpgradesFromItem(ItemState, XComHQ, UpdateState);
			}
		}

		`GAMERULES.SubmitGameState(UpdateState);
	}
	if (LoadoutScreen != none)
	{
		LoadoutScreen.UpdateNavHelp();
	}
}

simulated function array<XComGameState_Unit> GetSoldiersToStrip(XComGameState_HeadquartersXCom XComHQ, XComGameState UpdateState)
{
	local array<XComGameState_Unit> Soldiers;
	local int idx;
	local UIArmory ArmoryScreen;
	local UISquadSelect SquadSelectScreen;

	// Look for an armory screen. This will tell us what soldier we're looking at right now, we never want
	// to strip this one.
	ArmoryScreen = UIArmory(`SCREENSTACK.GetFirstInstanceOf(class'UIArmory'));

	// Look for a squad select screen. This will tell us which soldiers we shouldn't strip because they're
	// in the active squad.
	SquadSelectScreen = UISquadSelect(`SCREENSTACK.GetFirstInstanceOf(class'UISquadSelect'));

	// Start with all soldiers: we only want to selectively ignore the ones in XComHQ.Squad if we're
	// in squad select. Otherwise it contains stale unit refs and we can't trust it.
	Soldiers = XComHQ.GetSoldiers(false);

	// LWS : revamped loop to remove multiple soldiers
	for(idx = Soldiers.Length - 1; idx >= 0; idx--)
	{

		// Don't strip items from the guy we're currently looking at (if any)
		if (ArmoryScreen != none)
		{
			if(Soldiers[idx].ObjectID == ArmoryScreen.GetUnitRef().ObjectID)
			{
				Soldiers.Remove(idx, 1);
				continue;
			}
		}
		//LWS: prevent stripping of gear of soldier with eStatus_CovertAction
		if(Soldiers[idx].GetStatus() == eStatus_CovertAction)
		{
			Soldiers.Remove(idx, 1);
			continue;
		}
		// prevent stripping of soldiers in current XComHQ.Squad if we're in squad
		// select. Otherwise ignore XComHQ.Squad as it contains stale unit refs.
		if (SquadSelectScreen != none)
		{
			if (XComHQ.Squad.Find('ObjectID', Soldiers[idx].ObjectID) != -1)
			{
				Soldiers.Remove(idx, 1);
				continue;
			}
		}
	}

	return Soldiers;
}

function StripWeaponUpgradesFromItem(XComGameState_Item ItemState, XComGameState_HeadquartersXCom XComHQ, XComGameState UpdateState)
{
	local int k;
	local array<X2WeaponUpgradeTemplate> UpgradeTemplates;
	local XComGameState_Item UpdateItemState, UpgradeItemState;

	UpdateItemState = XComGameState_Item(UpdateState.GetGameStateForObjectID(ItemState.ObjectID));
	if (UpdateItemState == none)
	{
		UpdateItemState = XComGameState_Item(UpdateState.CreateStateObject(class'XComGameState_Item', ItemState.ObjectID));
		UpdateState.AddStateObject(UpdateItemState);
	}

	UpgradeTemplates = ItemState.GetMyWeaponUpgradeTemplates();
	for (k = 0; k < UpgradeTemplates.length; k++)
	{
		UpgradeItemState = UpgradeTemplates[k].CreateInstanceFromTemplate(UpdateState);
		UpdateState.AddStateObject(UpgradeItemState);
		XComHQ.PutItemInInventory(UpdateState, UpgradeItemState);
	}

	UpdateItemState.NickName = "";
	UpdateItemState.WipeUpgradeTemplates();
}


// return true to override XComSquadStartsConcealed=true setting in mission schedule and have the game function as if it was false
function EventListenerReturn CheckForConcealOverride(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	/* WOTC TODO: Restore this
	local XComLWTuple						OverrideTuple;
	local XComGameState_MissionSite			MissionState;
	local XComGameState_LWPersistentSquad	SquadState;
	local XComGameState_BattleData			BattleData;
	local int k;

	//`LWTRACE("CheckForConcealOverride : Starting listener.");

	OverrideTuple = XComLWTuple(EventData);
	if(OverrideTuple == none)
	{
		`REDSCREEN("CheckForConcealOverride event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}
	OverrideTuple.Data[0].b = false;

	// If within a configurable list of mission types, and infiltration below a set value, set it to true
	BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(BattleData.m_iMissionID));

    if (MissionState == none)
    {
        return ELR_NoInterrupt;
    }

	//`LWTRACE ("CheckForConcealOverride: Found MissionState");

	for (k = 0; k < default.MINIMUM_INFIL_FOR_CONCEAL.length; k++)
    if (MissionState.GeneratedMission.Mission.sType == MINIMUM_INFIL_FOR_CONCEAL[k].MissionType)
	{
		SquadState = `LWSQUADMGR.GetSquadOnMission(MissionState.GetReference());
		//`LWTRACE ("CheckForConcealOverride: Mission Type correct. Infiltration:" @ SquadState.CurrentInfiltration);
		If (SquadState.CurrentInfiltration < MINIMUM_INFIL_FOR_CONCEAL[k].MinInfiltration)
		{
			//`LWTRACE ("CheckForConcealOverride: Conditions met to start squad revealed");
			OverrideTuple.Data[0].b = true;
		}
	}
	*/
	return ELR_NoInterrupt;
}

function EventListenerReturn CheckForUnitAlertOverride(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	/* WOTC TODO: Restore this
	local XComLWTuple						OverrideTuple;
	local XComGameState_MissionSite			MissionState;
	local XComGameState_LWPersistentSquad	SquadState;
	local XComGameState_BattleData			BattleData;

	//`LWTRACE("CheckForUnitAlertOverride : Starting listener.");

	OverrideTuple = XComLWTuple(EventData);
	if(OverrideTuple == none)
	{
		`REDSCREEN("CheckForUnitAlertOverride event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}

	// If within a configurable list of mission types, and infiltration below a set value, set it to true
	BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(BattleData.m_iMissionID));

    if (MissionState == none)
    {
        return ELR_NoInterrupt;
    }

	SquadState = `LWSQUADMGR.GetSquadOnMission(MissionState.GetReference());

	if (`LWSQUADMGR.IsValidInfiltrationMission(MissionState.GetReference()))
	{
		if (SquadState.CurrentInfiltration < default.MINIMUM_INFIL_FOR_GREEN_ALERT[`STRATEGYDIFFICULTYSETTING])
		{
			if (OverrideTuple.Data[0].i == `ALERT_LEVEL_GREEN)
			{
				OverrideTuple.Data[0].i = `ALERT_LEVEL_YELLOW;
				`LWTRACE ("Changing unit alert to yellow");
			}
		}
	}
	*/
	return ELR_NoInterrupt;
}

function EventListenerReturn OnAbilityActivated(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	/* WOTC TODO: Restore this
    local XComGameState_Ability ActivatedAbilityState;
	local XComGameState_LWReinforcements Reinforcements;
	local XComGameState NewGameState;

	//ActivatedAbilityStateContext = XComGameStateContext_Ability(GameState.GetContext());
	ActivatedAbilityState = XComGameState_Ability(EventData);
	if (ActivatedAbilityState.GetMyTemplate().DataName == 'RedAlert')
	{
		Reinforcements = XComGameState_LWReinforcements(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_LWReinforcements', true));
		if (Reinforcements == none)
			return ELR_NoInterrupt;

		if (Reinforcements.RedAlertTriggered)
			return ELR_NoInterrupt;

		Reinforcements.RedAlertTriggered = true;

		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Check for reinforcements");
		Reinforcements = XComGameState_LWReinforcements(NewGameState.CreateStateObject(class'XComGameState_LWReinforcements', Reinforcements.ObjectID));
		NewGameState.AddStateObject(Reinforcements);
		`TACTICALRULES.SubmitGameState(NewGameState);
	}
	*/
	return ELR_NoInterrupt;
}

//function EventListenerReturn OnSerialKill(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
//{
	//local XComGameState_Unit ShooterState;
    //local UnitValue UnitVal;
//
	//ShooterState = XComGameState_Unit (EventSource);
	//If (ShooterState == none)
	//{
		//return ELR_NoInterrupt;
	//}
	//ShooterState.GetUnitValue ('SerialKills', UnitVal);
	//ShooterState.SetUnitFloatValue ('SerialKills', UnitVal.fValue + 1.0, eCleanup_BeginTurn);
	//return ELR_NoInterrupt;
//}
//

function EventListenerReturn LW2OnPlayerTurnBegun(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	local XComGameState_Player PlayerState;

	PlayerState = XComGameState_Player (EventData);
	if (PlayerState == none)
	{
		`LOG ("LW2OnPlayerTurnBegun: PlayerState Not Found");
		return ELR_NoInterrupt;
	}

	if(PlayerState.GetTeam() == eTeam_XCom)
	{
		`XEVENTMGR.TriggerEvent('XComTurnBegun', PlayerState, PlayerState);
	}
	if(PlayerSTate.GetTeam() == eTeam_Alien)
	{
		`XEVENTMGR.TriggerEvent('AlienTurnBegun', PlayerState, PlayerState);
	}

	return ELR_NoInterrupt;
}

//function EventListenerReturn OnOverrideInitialPsiTrainingTime(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
//{
	//local XComLWTuple Tuple;
//
	//Tuple = XComLWTuple(EventData);
	//if (Tuple == none)
	//{
		//return ELR_NoInterrupt;
	//}
	//Tuple.Data[0].i=default.INITIAL_PSI_TRAINING[`STRATEGYDIFFICULTYSETTING];
	//return ELR_NoInterrupt;
//}
//
//// This sets a flag that skips the automatic alert placed on the squad when reinfs land.
//function EventListenerReturn OnOverrideReinforcementsAlert(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
//{
	///* WOTC TODO: Restore this
	//local XComLWTuple Tuple;
	//local XComGameState_Player PlayerState;
//
	//Tuple = XComLWTuple(EventData);
	//if (Tuple == none)
	//{
		//return ELR_NoInterrupt;
	//}
//
	//PlayerState = class'Utilities_LW'.static.FindPlayer(eTeam_XCom);
	//Tuple.Data[0].b = PlayerState.bSquadIsConcealed;
	//*/
	//return ELR_NoInterrupt;
//}
//
//// this function cleans up some weird objective states by firing specific events
//function EventListenerReturn OnGeoscapeEntry(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
//{
	//local XComGameState_MissionSite					MissionState;
//
	//if (`XCOMHQ.GetObjectiveStatus('T2_M1_S1_ResearchResistanceComms') <= eObjectiveState_InProgress)
	//{
		//if (`XCOMHQ.IsTechResearched ('ResistanceCommunications'))
		//{
			//foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_MissionSite', MissionState)
			//{
				//if (MissionState.GetMissionSource().DataName == 'MissionSource_Blacksite')
				//{
					//`XEVENTMGR.TriggerEvent('ResearchCompleted',,, NewGameState);
					//break;
				//}
			//}
		//}
	//}
//
	//if (`XCOMHQ.GetObjectiveStatus('T2_M1_S2_MakeContactWithBlacksiteRegion') <= eObjectiveState_InProgress)
	//{
		//foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_MissionSite', MissionState)
		//{
			//if (MissionState.GetMissionSource().DataName == 'MissionSource_Blacksite')
			//{
				//if (MissionState.GetWorldRegion().ResistanceLevel >= eResLevel_Contact)
				//{
					//`XEVENTMGR.TriggerEvent('OnBlacksiteContacted',,, NewGameState);
					//break;
				//}
			//}
		//}
	//}
//
	//return ELR_NoInterrupt;
//}

// TechState, TechState


defaultproperties
{
	OverrideNumUtilitySlots = 3;
}
