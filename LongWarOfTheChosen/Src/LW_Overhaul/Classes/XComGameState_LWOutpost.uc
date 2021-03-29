//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_LWOutpost.uc
//  AUTHOR:  tracktwo / Pavonis Interactive
//  PURPOSE: A state representing a rebel outpost associated with a particular region
//---------------------------------------------------------------------------------------

class XComGameState_LWOutpost extends XComGameState_GeoscapeEntity config(LW_Outposts) dependson(X2StrategyElement_DefaultAlienActivities) // needed for mission settings
	;

const STAFF_SLOT_TEMPLATE_NAME='LWOutpostStaffSlot';

struct RebelUnit
{
	var StateObjectReference Unit;  // The unit state
	var StateObjectReference Proxy; // A proxy for this unit
	var Name Job;                   // Current task
	var Name JobAtLastUpdate;       // What job did this rebel have the last time we did a haven update?
	var int Level;                  // Current level
	var bool IsFaceless;            // Is this actually a faceless?
	var TDateTime StartDate;        // Time recruited
	var bool IsOnMission;           // Was this rebel selected for duty in this mission?
};

// Income is recorded per job daily. It's stored in a pool, and is drained from the pool on a job-dependent rate.
// E.g. jobs like 'Recruit' fill the pool and award a new recruit when the pool reaches a given threshold value.
// Other jobs like 'Resupply' gather continuously into the pool and only drain at the end of the month.
struct JobIncomePool
{
	var Name Job;
	var float Value;
};

struct RebelLevelData
{
	var float Value;
	var int DaysNeededForPromotion;
	var int ChanceForPromotion;
};

struct ProhibitedJobStruct
{
	var name Job;
	var int DaysLeft;
};	

struct RebelJobDays
{
	var Name Job;
	var int Days;
};

struct RebelAbilityConfig
{
	var int Level;
	var name AbilityName;
	var EInventorySlot ApplyToWeaponSlot;
};

struct RetributionJobStruct
{
	var int DaysLeft;
	//Technically does not need to be a struct, but i think it makes it more readable
};

// The maximum number of rebels supported by this outpost.
var protectedwrite int MaxRebels;

// New rebels are assigned this job on creation.
var const config Name DEFAULT_REBEL_JOB;

// The default value for MaxRebels
var const config int DEFAULT_OUTPOST_MAX_SIZE;

// The default chance (0.0 = never 1.0 = always) that a new rebel will be a faceless.
var const config float DEFAULT_FACELESS_CHANCE;

// Faceless won't generate if they will take the proportion in the Haven past this value
var config float MAX_FACELESS_PROPORTION;

// Psi abilities which reduce the chance of recruiting Faceless if the liason has at least one of them (they don't stack)
var config array<name> FacelessReductionPsiAbilities;

// Outpost will begin with INITIAL_REBEL_COUNT + Rand(0, RANDOM_REBEL_COUNT)
// rebels.
var const config int HOME_REBEL_COUNT;
var const config int INITIAL_REBEL_COUNT;
var const config int RANDOM_REBEL_COUNT;

// The amount of income needed in a particular rebel job to trigger the "income" event.
var const config float INCOME_POOL_THRESHOLD;

// The value each rebel of a given level is "worth". Should be normalized where level 1 is 1.0.
// Level 0 is unused.
var config array<RebelLevelData> LEVEL_DATA;

// Minimum rank required for soldiers to be eligible for haven liaison duty
var const config int REQUIRED_RANK_FOR_LIAISON_DUTY;

// Number of supplies drained from the outpost per faceless-day.
var const config float FACELESS_SUPPLY_DRAIN;

// Defines valid abilities for rebels
var config array<RebelAbilityConfig> REBEL_AWC_ABILITIES_OFFENSE;
var config array<RebelAbilityConfig> REBEL_AWC_ABILITIES_DEFENSE;

// All rebels in this outpost & what they're up to
var protectedwrite array<RebelUnit> Rebels;

// How many Faceless-days have we accumulated in this outpost this month?
var float FacelessDays;

// The current income pools for each job. Rebels on a particular job accrue "points"
// each day, and all points go into job-specific pools. When these pools reach threshold
// values, "income events" fire and the pools are emptied. The income rate, thresholds,
// and income events are determined by the particular job templates.
var protectedwrite array<JobIncomePool> IncomePools;

// These buckets are used for retaliations
var array<RebelJobDays> JobBuckets;
var float TotalResistanceBucket;
var config array<int> JOB_DETECTION_CHANCE;
var config array<int> JOB_DETECTION_CHANCE_BONUS_PER_FACELESS;
var config array<int> JOB_DETECTION_CHANCE_BONUS_PER_VIGILANCE;
var config array<int> JOB_DETECTION_CHANCE_BONUS_PER_ALERT;
var config array<int> JOB_DETECTION_CHANCE_BONUS_PER_FORCE;

// Staff slot for engineer/scientist liaisons. Allows us to use the existing staff slot
// mechanics to "assign" scientists/engineers to the haven as liaisons and have the rest
// of the game treat them as "busy" so they can't also be assigned elsewhere.
var protectedwrite StateObjectReference StaffSlot;

// Resistance MECs in this outpost
var protectedwrite array<RebelUnit> ResistanceMecs;

// When the next rebel update tick will occur
var protectedwrite TDateTime NextUpdateTime;

// Mechanism to reduce returns of supply job over time
var config int SupplyCap_Min;
var config int SupplyCap_Rand;
var int SupplyCap, SuppliesTaken;

// ProhibitedJobs from failing raid operations
var array <ProhibitedJobStruct> ProhibitedJobs;
var localized string m_strProhibitedJobAlert;
var localized string m_strProhibitedJobEnded;
//Current Retributions affecting that outpost
var array <RetributionJobStruct> CurrentRetributions;
var localized string m_strRetributionEnded;

// DEBUG VARs

// Force the next recruit in this outpost to roll the given value.
var int ForceRecruitRoll;


// Create a new outpost, associated with the given region.
static function XComGameState_LWOutpost CreateOutpost(XComGameState NewState, XComGameState_WorldRegion WorldRegion)
{
	local XComGameState_LWOutpost Outpost;

	Outpost = XComGameState_LWOutpost(NewState.CreateStateObject(class'XComGameState_LWOutpost'));

	Outpost.InitOutpost(NewState, WorldRegion);
	NewState.AddStateObject(Outpost);
	return Outpost;
}

// Create the income pools for each possible rebel job. Can also be used to update existing game states
// to react to new jobs being added mid-campaign.
function InitJobs()
{
	local X2StrategyElementTemplateManager StrategyTemplateMgr;
	local LWRebelJobTemplate JobTemplate;
	local array<X2StrategyElementTemplate> Templates;
	local int idx;
	local JobIncomePool Pool, EmptyPool;
	local RebelJobDays JobDaysBucket, EmptyJobDaysBucket;

	StrategyTemplateMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	Templates = StrategyTemplateMgr.GetAllTemplatesOfClass(class'LWRebelJobTemplate');

	for (idx = 0; idx < Templates.Length; ++idx)
	{
		JobTemplate = LWRebelJobTemplate(Templates[idx]);
		Pool = EmptyPool;
		Pool.Job = JobTemplate.DataName;
		Pool.Value = 0.0f;

		JobDaysBucket = EmptyJobDaysBucket;
		JobDaysBucket.Job = JobTemplate.DataName;
		JobDaysBucket.Days = 0;

		// Only add the job if it's not previously been seen.
		if (IncomePools.Find('Job', Pool.Job) == -1)
		{
			IncomePools.AddItem(Pool);
		}
		if (JobBuckets.Find('Job', JobDaysBucket.Job) == -1)
		{
			JobBuckets.AddItem(JobDaysBucket);
		}
	}
}

static function StateObjectReference CreateResistanceMec(XComGameState NewGameState)
{
	local X2CharacterTemplate CharacterTemplate;
	local XComGameState_Unit NewUnit;

	CharacterTemplate = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager().FindCharacterTemplate('ResistanceMEC');
	NewUnit = CharacterTemplate.CreateInstanceFromTemplate(NewGameState);
	NewUnit.ApplyInventoryLoadout(NewGameState);
	NewGameState.AddStateObject(NewUnit);
	return NewUnit.GetReference();
}

static function bool IsDarkEventActive(name DarkEventName)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_DarkEvent DarkEventState;

	History = `XCOMHISTORY;
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	foreach History.IterateByClassType(class'XComGameState_DarkEvent', DarkEventState)
	{
		if(DarkEventState.GetMyTemplateName() == DarkEventName)
		{
			if(AlienHQ.ActiveDarkEvents.Find('ObjectID', DarkEventState.ObjectID) != -1)
			{
				return true;
			}
		}
	}
	return false;
}


function StateObjectReference CreateRebel(XComGameState NewGameState, XComGameState_WorldRegion RegionState, bool allowFaceless, optional bool forceFaceless)
{
	local name nmCountry;
	local name CharacterTemplateName;
	local XComGameState_Unit NewUnit, Unit;
	local X2CharacterTemplate CharacterTemplate;
	local XGCharacterGenerator CharacterGenerator;
	local TSoldier CharacterGeneratorResult;
	local array<X2StrategyElementTemplate> PersonalityTemplates;
	local StateObjectReference NewUnitRef;
	local float FacelessChance;
	local name PsionAbilityName;

	CharacterGenerator = `XCOMGRI.Spawn(class'XGCharacterGenerator');
	nmCountry = RegionState.GetMyTemplate().GetRandomCountryInRegion();

	FacelessChance = default.DEFAULT_FACELESS_CHANCE;

	if (IsDarkEventActive ('DarkEvent_HavenInfiltration'))
	{
		FacelessChance *= 2;
	}

	if (HasLiaison())
	{
		Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(GetLiaison().ObjectID));
		if (Unit.IsSoldier())
		{
			If (Unit.HasSoldierAbility('ScanningProtocol'))
			{
				FacelessChance *= 0.6;
			}
			if (Unit.HasAbilityFromAnySource.Find(PsionAbilityName))
			{
				FacelessChance *= 0.6;
			}
			if (Unit.HasItemOfTemplateType('Battlescanner'))
			{
				FacelessChance *= 0.6;
			}
		}
	}

	if (forceFaceless || (allowFaceless && `SYNC_FRAND() < FacelessChance && GetNumFaceless() / GetRebelCount() < default.MAX_FACELESS_PROPORTION))
	{
		CharacterTemplateName = 'FacelessRebel';
	}
	else
	{
		CharacterTemplateName = 'Rebel';
	}

	//`LWTRACE ("Faceless Chance:" @ string(Facelesschance) @ "Outcome:" @ CharacterTemplateName @ "ForceFaceless:" @ ForceFaceless);

	CharacterTemplate = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager().FindCharacterTemplate(CharacterTemplateName);
	NewUnit = CharacterTemplate.CreateInstanceFromTemplate(NewGameState);
	CharacterGeneratorResult = CharacterGenerator.CreateTSoldier(CharacterTemplateName, /* Gender */, nmCountry);
	PersonalityTemplates = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager().GetAllTemplatesOfClass(class'X2SoldierPersonalityTemplate');
	CharacterGeneratorResult.kAppearance.iAttitude = `SYNC_RAND_STATIC(PersonalityTemplates.Length);

	NewUnit.SetTAppearance(CharacterGeneratorResult.kAppearance);

	// Give them a voice - CreateTSoldier skils voice assignment for non-soldiers, but rebels will often be controllable.
	NewUnit.SetVoice(CharacterGenerator.GetVoiceFromCountryAndGender(nmCountry, NewUnit.kAppearance.iGender));

	NewUnit.SetCharacterName(CharacterGeneratorResult.strFirstName, CharacterGeneratorResult.strLastName, CharacterGeneratorResult.strNickName);
	NewUnit.SetCountry(CharacterGeneratorResult.nmCountry);
	class'XComGameState_Unit'.static.NameCheck(CharacterGenerator, NewUnit, eNameType_Full);

	// Fire an event to allow NCE to apply to the rebel stats
	`XEVENTMGR.TriggerEvent('SoldierCreatedEvent', NewUnit, NewUnit, NewGameState);
	NewUnit.RandomizeStats();
	NewUnit.GiveRandomPersonality();
	NewGameState.AddStateObject(NewUnit);
	CharacterGenerator.Destroy();

	NewUnitRef = NewUnit.GetReference();

	//`GAME.StrategyPhotographer.AddHeadshotRequest(NewUnitRef, 'UIPawnLocation_ArmoryPhoto', 'SoldierPicture_Head_Armory', 512, 512, none, 
	//     class'X2StrategyElement_DefaultSoldierPersonalities'.static.Personality_ByTheBook());

	return NewUnitRef;
}

function StateObjectReference AddRebel(StateObjectReference RebelRef, XComGameState NewGameState)
{
	local RebelUnit Rebel;
	local XComGameState_Unit Unit;

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(RebelRef.ObjectID));
	Rebel.Unit = RebelRef;
	Rebel.IsFaceless = Unit.GetMyTemplateName() == 'FacelessRebel';
	Rebel.Job = DEFAULT_REBEL_JOB;
	Rebel.Level = 0;
	Rebel.StartDate = GetCurrentTime();
	Rebels.AddItem(Rebel);

	`XEVENTMGR.TriggerEvent('RebelAdded_LW', Unit, self, NewGameState);

	return Rebel.Unit;
}


function InitOutpost(XComGameState NewState, XComGameState_WorldRegion WorldRegion)
{
	local int i;
	local int InitCount;
	local StateObjectReference RebelReference;
	local XComGameState_StaffSlot StaffSlotState;
	local X2StaffSlotTemplate StaffSlotTemplate;
	local XComGameState_FacilityXCom FacilityState;

	Region = WorldRegion.GetReference();
	MaxRebels = DEFAULT_OUTPOST_MAX_SIZE;

	if (WorldRegion.IsStartingRegion())
	{
		InitCount = HOME_REBEL_COUNT;
	}
	else
	{
		InitCount = INITIAL_REBEL_COUNT + `SYNC_RAND(RANDOM_REBEL_COUNT);
	}

	InitJobs();

	// Create characters for each. Each has an independent chance to be faceless.
	for (i = 0; i < InitCount; ++i)
	{
		if (WorldRegion.IsStartingRegion())
		{
			RebelReference = CreateRebel(NewState, WorldRegion, false, false);
		}
		else
		{
			RebelReference = CreateRebel(NewState, WorldRegion, true);
		}

		AddRebel(RebelReference, NewState);

		// Rebels are assigned to jobs roughly in thirds, with remainders going to "intel".
		// On Rookie, Vet, push some more toward intel to help generate easier missions

		if (i <= MaxRebels) 
			Rebels[i].Job = class'LWRebelJob_DefaultJobSet'.const.INTEL_JOB;
		else
			Rebels[i].Job = class'LWRebelJob_DefaultJobSet'.const.HIDING_JOB;

	}

	UpdateJobs(NewState);

	// Initialize the staff slot
	StaffSlotTemplate = X2StaffSlotTemplate(class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager().FindStrategyElementTemplate(STAFF_SLOT_TEMPLATE_NAME));
	StaffSlotState = StaffSlotTemplate.CreateInstanceFromTemplate(NewState);
	StaffSlot = StaffSlotState.GetReference();
	// Attach the staff slot to the commander's quarters (all slots need an associated room)
	FacilityState = `XCOMHQ.GetFacilityByName('CommandersQuarters');
	StaffSlotState.Facility = FacilityState.GetReference();
	NewState.AddStateObject(StaffSlotState);

	// Set up for Mechanism for diminishing returns from Supplies.
	if (WorldRegion.IsStartingRegion())
	{
		SupplyCap = default.SupplyCap_Min + default.SupplyCap_Rand;
	}
	else
	{
		SupplyCap = default.SupplyCap_Min + `SYNC_RAND (default.SupplyCap_Rand) + `SYNC_RAND (default.SupplyCap_Rand);
	}
	SuppliesTaken = 0;
	FacelessDays = 0;
	`LWTRACE ("New campaign Supply Cap" @ WorldRegion.GetDisplayName() @ string (SupplyCap));

	NextUpdateTime = GetCurrentTime();
	class'X2StrategyGameRulesetDataStructures'.static.AddDay(NextUpdateTime);
}

function SetRebelJob(StateObjectReference UnitRef, Name JobName)
{
	local int i;
	for (i = 0; i < Rebels.Length; ++i)
	{
		if (Rebels[i].Unit.ObjectID == UnitRef.ObjectID && 
				Rebels[i].Job != JobName)
		{
			Rebels[i].Job = JobName;
			return;
		}
	}
}

function int GetRebelCount()
{
	return Rebels.Length;
}

function int GetResistanceMecCount()
{
	return ResistanceMecs.Length;
}

function int GetNumFaceless()
{
	local int idx, NumFaceless;

	for (idx = 0; idx < Rebels.Length; ++idx)
	{
		if (Rebels[idx].IsFaceless)
		{
			++NumFaceless;
		}
	}
	return NumFaceless;
}

function int GetMaxRebelCount()
{
	return MaxRebels;
}

function name GetRebelTemplateName(int idx)
{
	return Rebels[idx].IsFaceless ? 'FacelessRebel' : 'Rebel';
}

static function String GetJobName(Name Job)
{
	local LWRebelJobTemplate JobTemplate;

	JobTemplate = GetJobTemplate(Job);
	if (JobTemplate == None)
	{
		return "ERROR: Missing job " $ Job;
	}

	return JobTemplate.strJobName;
}

// Update whatever values need updating to reflect change in jobs.
function UpdateJobs(XComGameState NewGameState)
{
	local XComGameState_WorldRegion RegionState, NewRegionState;
	local int Supplies;

	// Adjust the region supply to be the estimated supply value for this month.
	Supplies = GetProjectedMonthlyIncomeForJob('Resupply');
	RegionState = GetWorldRegionForOutpost();

	NewRegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(RegionState.ObjectID));
	if (NewRegionState != none)
	{
		RegionState = NewRegionState;
	}
	else
	{
		RegionState = XComGameState_WorldRegion(NewGameState.CreateStateObject(class'XComGameState_WorldRegion', RegionState.ObjectID));
		NewGameState.AddStateObject(RegionState);
	}

	RegionState.BaseSupplyDrop = Supplies;
}

// Did the given unit survive the mission?
function bool UnitSurvived(XComGameState_Unit Unit, bool IsFaceless, String MissionType)
{
	local XComGameState_BattleData BattleData;

	BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));

	// If they're dead, obviously not.
	if (Unit.IsDead())
		return false;

	// Anyone that was captured is gone too
	if (Unit.bCaptured)
	{
		return false;
	}

	// Haven adviser will have returned from the mission as long as they
	// aren't dead or captured.
	if (Unit.ObjectID == GetLiaison().ObjectID)
	{
		return true;
	}

	// The IntelRaid and SupplyRaid missions are sweeps, so any rebels/mecs that are not dead lived. Likewise for
	// rendezvous. Note that the faceless spies will be counted as 'survived' here because when they transform
	// they are removed from play but not killed. The caller will handle those separately. Here we need to ensure
	// that any rebels on the XCOM team that happened to be faceless aren't marked as killed by the faceless check
	// below, since on these mission types faceless can be acting on the XCOM team and have not blown their cover.
	switch (MissionType)
	{
		case "IntelRaid_LW":
		case "SupplyConvoy_LW":
		case "Rendezvous_LW":
			return true;
	}

	if (IsFaceless)
	{
		// Faceless rebels always transform instead of being controlled, so they can never
		// evac. Which is good, because we don't have an easy way to distinguish whether a
		// unit was removed because it evac'd or if it was a faceless that transformed.
		// (Transformation removes the civvie unit from the board and replaces it with an alien).
		// So, any faceless that's removed from play must have transformed, and since the
		// mission is over it's either dead or the player aborted. Either way, they're gone.
		// Unrevealed faceless only remain in the outpost if the player won the mission and
		// they aren't removed from play. Which means that faceless *cannot* survive a defend,
		// because any one you walked up to transformed, and anyone left on the map is dead.
		if (MissionType == "Defend_LW")
			return false;

		// On a recruit raid, faceless don't transform. So anyone that made it to evac is ok.
		if (MissionType == "RecruitRaid_LW")
		{
			return Unit.bRemovedFromPlay;
		}

		// On a terror mission, faceless can only have survived if you won the sweep objective.
		if (MissionType == "Terror_LW")
		{
			return (!Unit.bRemovedFromPlay && BattleData.AllTriadObjectivesCompleted());
		}

		// Otherwise, if they weren't removed from play and we won, they're good.
		return (!Unit.bRemovedFromPlay && BattleData.bLocalPlayerWon);
	}
	else
	{
		// Any rebel/mec that made it to evac is safe.
		if (Unit.bRemovedFromPlay)
			return true;

		// Defend missions require evac: Anyone left on the map is dead
		if (MissionType == "Defend_LW")
		{
			return false;
		}

		// Terror missions require either evac or the sweep objective to be complete. This is the 'triad' objective
		// (you get loot if you complete it, but no corpses).
		if (MissionType == "Terror_LW")
		{
			return BattleData.AllTriadObjectivesCompleted();
		}

		// For other mission types anyone left on the map is safe if we won.
		return BattleData.bLocalPlayerWon;
	}
}


function bool UpdatePostMission(XComGameState_MissionSite MissionSite, XComGameState NewGameState)
{
	local int i;
	local XComGameState_Unit Unit;
	local XComGameStateHistory History;
	local String MissionType;
	local XComGameState_MissionSiteRendezvous_LW RendezvousMission;
	local StateObjectReference EmptyRef;
	local XComGameState_Item ItemState;
	local array<XComGameState_Item> Items;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_BattleData BattleData;

	History = `XCOMHISTORY;

	MissionType = class'Utilities_LW'.static.CurrentMissionType();

	switch(MissionType)
	{
		case "Invasion_LW":
		case "Terror_LW":
		case "Defend_LW":
		case "Rendezvous_LW":
		case "IntelRaid_LW":
		case "SupplyConvoy_LW":
		case "RecruitRaid_LW":
			break;
		default:
			// Other mission types: nothing to do.
			return false;
	}

	// Create new battle data and xcomhq objects for loot.
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	NewGameState.AddStateObject(XComHQ);

	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	BattleData = XComGameState_BattleData(NewGameState.CreateStateObject(class'XComGameState_BattleData', BattleData.ObjectID));
	NewGameState.AddStateObject(BattleData);

	for (i = 0; i < Rebels.Length; ++i)
	{
		// Skip any rebels not on mission: they survived
		if (!Rebels[i].IsOnMission)
			continue;

		// Check to see if we have a proxy for this rebel
		if (Rebels[i].Proxy.ObjectID != 0)
		{
			Unit = XComGameState_Unit(History.GetGameStateForObjectID(Rebels[i].Proxy.ObjectID));
			`LWTrace("Found proxy unit " $ Unit);
		}
		else
		{
			Unit = XComGameState_Unit(History.GetGameStateForObjectID(Rebels[i].Unit.ObjectID));
		}

		if (!UnitSurvived(Unit, Rebels[i].IsFaceless, MissionType))
		{
			// RIP rebel.
			`LWTrace("Unit " $ Unit.GetFullName() $ " died");
			Rebels.Remove(i, 1);
			--i;
		}
		else
		{
			`LWTrace("Unit " $ Unit.GetFullName() $ " survived");

			// Rebels may need their backpacks emptied, because they aren't squad members. Advisers are always
			// squad members (needed so they get XP and usual post-mission udpates like wound/bleedout handling,
			// shaken status or recovery, etc) so they already have their loot handled. Rebels on rendezvous are
			// part of the squad too but in this case they will have had their loot emptied already and we won't
			// see it again here.
			Items = Unit.GetAllItemsInSlot(eInvSlot_Backpack, NewGameState);
			foreach Items(ItemState)
			{
				ItemState = XComGameState_Item(NewGameState.CreateStateObject(class'XComGameState_Item', ItemState.ObjectID));
				NewGameState.AddStateObject(ItemState);
				Unit.RemoveItemFromInventory(ItemState, NewGameState);
				ItemState.OwnerStateObject = XComHQ.GetReference();
				XComHQ.PutItemInInventory(NewGameState, ItemState, true);
				BattleData.CarriedOutLootBucket.AddItem(ItemState.GetMyTemplateName());
			}
		}
	}


	// if this is a rendezvous mission, the faceless spies are gone: either we killed them or we lost the mission, but in either
	// case their cover is blown and they're not coming back.
	if (MissionType == "Rendezvous_LW")
	{
		RendezvousMission = XComGameState_MissionSiteRendezvous_LW(MissionSite);
		for (i = 0; i < Rebels.Length; ++i)
		{
			if (RendezvousMission.FacelessSpies.Find('ObjectID', Rebels[i].Unit.ObjectID) >= 0)
			{
				Rebels.Remove(i, 1);
				--i; 
			}
		}
	}

	// If the liaison was present on this mission they may need some updates.
	if (HasLiaisonValidForMission(MissionSite.GeneratedMission.Mission.sType))
	{
		Unit = XComGameState_Unit(History.GetGameStateForObjectID(GetLiaison().ObjectID));
		if (!UnitSurvived(Unit, false, MissionSite.GeneratedMission.Mission.sType))
		{
			// Liaison didn't make it. Remove them from the haven and optionally capture them.
			RemoveAndCaptureLiaison(NewGameState);
		}
		else if (Unit.IsInjured() || Unit.GetMentalState() == eMentalState_Shaken)
		{
			// Injured and shaken units are removed from the haven but remain on the avenger.
			SetLiaison(EmptyRef, NewGameState);
		}
	}

	// We no longer need the proxies, and nobody is on mission anymore
	for (i = 0; i < Rebels.Length; ++i)
	{
		Rebels[i].Proxy.ObjectID = 0;
		Rebels[i].IsOnMission = false;
	}

	// Update MECs
	for (i = 0; i < ResistanceMecs.Length; ++i)
	{
		if (!ResistanceMecs[i].IsOnMission)
			continue;

		// Check to see if we have a proxy for this rebel
		if (ResistanceMecs[i].Proxy.ObjectID != 0)
		{
			Unit = XComGameState_Unit(History.GetGameStateForObjectID(ResistanceMecs[i].Proxy.ObjectID));
			`LWTrace("Found proxy unit " $ Unit);
		}
		else
		{
			Unit = XComGameState_Unit(History.GetGameStateForObjectID(ResistanceMecs[i].Unit.ObjectID));
		}

		if (!UnitSurvived(Unit, false, MissionType))
		{
			`LWTrace("Mec died");
			ResistanceMecs.Remove(i, 1);
			--i;
		}
		else
		{
			ResistanceMecs[i].IsOnMission = false;
			ResistanceMecs[i].Proxy.ObjectID = 0;
		}
	}

	// Refresh the job totals to reflect the fact that anyone who is now dead is no longer doing any work.
	UpdateJobs(NewGameState);

	`HQPRES.m_kAvengerHUD.UpdateResources();

	return true;
}

function bool HasLiaisonValidForMission(String MissionType)
{
	if (!HasLiaison())
	{
		return false;
	}

	switch (MissionType)
	{
		case "Invasion_LW":
		case "Terror_LW":
		case "Defend_LW":
			// Any liaison is used on this mission.
			return true;

		case "IntelRaid_LW":
			return HasLiaisonOfKind('Soldier') || HasLiaisonOfKind('Scientist');
		case "SupplyConvoy_LW":
			return HasLiaisonOfKind('Soldier') || HasLiaisonOfKind('Engineer');
		case "RecruitRaid_LW":
		case "Rendezvous_LW":
			return HasLiaisonOfKind('Soldier');
	}

	return false;
}

// used to reduce outpost to virtual ruin
function bool WipeOutOutpost(XComGameState NewGameState)
{
	local int i;
	local XComGameState_Unit Unit;
	local XComGameStateHistory History;
	local XComGameState_WorldRegion RegionState;

	History = `XCOMHISTORY;

	for (i = 0; i < Rebels.Length; ++i)
	{
		// Check to see if we have a proxy for this rebel
		if (Rebels[i].Proxy.ObjectID != 0)
		{
			Unit = XComGameState_Unit(History.GetGameStateForObjectID(Rebels[i].Proxy.ObjectID));
			`LWTrace("Found proxy unit " $ Unit);
		}
		else
		{
			Unit = XComGameState_Unit(History.GetGameStateForObjectID(Rebels[i].Unit.ObjectID));
		}

		// RIP rebel.
		`LWTrace("Unit " $ Unit.GetFullName() $ " died");
		Rebels.Remove(i, 1);
		--i;
	}

	// RIP Liaison unless they roped out.
	if (HasLiaison())
	{
		Unit = XComGameState_Unit(History.GetGameStateForObjectID(GetLiaison().ObjectID));
		if (!Unit.bRemovedFromPlay)
		{
			RemoveAndCaptureLiaison(NewGameState);
		}
	}

	// Destroy the radio relay (if present)
	RegionState = GetWorldRegionForOutpost();
	if (RegionState.ResistanceLevel >= eResLevel_Outpost && !RegionState.IsStartingRegion())
	{
		RegionState = XComGameState_WorldRegion(NewGameState.CreateStateObject(
					class'XComGameState_WorldRegion', RegionState.ObjectID));
		NewGameState.AddStateObject(RegionState);
		RegionState.SetResistanceLevel(NewGameState, eResLevel_Contact);
	}


	// Refresh the job totals to reflect the fact that anyone who is now dead is no longer doing any work.
	UpdateJobs(NewGameState);
	ResetJobIncomePools(NewGameState);
	FacelessDays = 0;

	// Update mecs.
	ResistanceMecs.Length = 0;

	`HQPRES.m_kAvengerHUD.UpdateResources();

	return true;
}

function RemoveAndCaptureLiaison(XComGameState NewGameState)
{
	local XComGameState_Unit Unit;
	local XComGameStateHistory History;
	local StateObjectReference EmptyRef;
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_HeadquartersXCom XComHQ;

	History = `XCOMHISTORY;

	// Remove the unit from the haven and the HQ.
	Unit = XComGameState_Unit(History.GetGameStateForObjectID(GetLiaison().ObjectID));
	SetLiaison(EmptyRef, NewGameState);
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(
				class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(
				class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	XComHQ.RemoveFromCrew(Unit.GetReference());

	// If they're not dead and they're a soldier, capture them.
	if (!Unit.IsDead() && !Unit.bCaptured && Unit.IsSoldier())
	{
		AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(
					class'XComGameState_HeadquartersAlien'));
		AlienHQ = XComGameState_HeadquartersAlien(NewGameState.ModifyStateObject(
					class'XComGameState_HeadquartersAlien', AlienHQ.ObjectID));
		AlienHQ.CapturedSoldiers.AddItem(Unit.GetReference());
	}
}

function RemoveRebel(StateObjectReference UnitToRemove, XComGameState NewGameState)
{
	local int i;

	i = Rebels.Find('Unit', UnitToRemove);
	if (i == -1)
	{
		`redscreen("Outpost.RemoveRebel: Failed to find unit " $ UnitToRemove.ObjectID);
		return;
	}

	Rebels.Remove(i, 1);
	UpdateJobs(NewGameState);
}

function AddResistanceMEC(StateObjectReference UnitRef, XComGameState NewGameState)
{
	local RebelUnit Rebel;
	local XComGameState_Unit Unit;

	Rebel.Unit = UnitRef;
	Rebel.IsOnMission = false;
	Rebel.StartDate = GetCurrentTime();
	ResistanceMecs.AddItem(Rebel);

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitRef.ObjectID));
	`XEVENTMGR.TriggerEvent('ResistanceMECAdded_LW', Unit, self, NewGameState);
}

function static LWRebelJobTemplate GetJobTemplate(Name JobName)
{
	local X2StrategyElementTemplateManager StrategyTemplateMgr;

	StrategyTemplateMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	return LWRebelJobTemplate(StrategyTemplateMgr.FindStrategyElementTemplate(JobName));
}

// Get the index of the income pool for a particular job
protected function int GetIncomePoolIndexForJob(Name JobName)
{
	local int idx;

	idx = IncomePools.Find('Job', JobName);
	if (idx == -1)
	{
		`redscreen("Failed to find job income pool for job " $ JobName);
	}

	return idx;
}

// Get the current true income pool value for a job.
function float GetIncomePoolForJob(Name JobName)
{
	local int idx;

	idx = GetIncomePoolIndexForJob(JobName);
	return IncomePools[idx].Value;
}

function float GetJobBucketForJob(Name JobName)
{
	local int idx;

	idx = JobBuckets.Find('Job', Jobname);
	`LWTRACE ("GetJobBucketForJob: Testing" @ JobName @ idx);
	return JobBuckets[idx].Days;
}


// Return the number of apparent rebels working on a job (e.g. for UI display).
// Always treats faceless as normal rebels, and always counts rebels that have switched
// jobs since the last haven update.
function int GetNumRebelsOnjob(Name JobName)
{
	local int Count;
	local int Idx;

	for (Idx = 0; Idx < Rebels.Length; ++Idx)
	{
		if (Rebels[idx].Job == JobName)
		{
			++Count;
		}
	}

	return Count;
}

function int GetNumFacelessOnjob(Name JobName)
{
	local int Count;
	local int Idx;

	for (Idx = 0; Idx < Rebels.Length; ++Idx)
	{
		if (Rebels[idx].Job == JobName && Rebels[idx].IsFaceless)
		{
			++Count;
		}
	}

	return Count;
}
// Determine the total value of levels for all rebels & faceless on a job. Does not include
// any rebel that has switched jobs since the last outpost update unless the optional
// IgnoreJobChanges parameter is true.
function float GetRebelLevelsOnJob(Name JobName, optional bool IgnoreJobChanges = false)
{
	local int idx;
	local float RebelLevels;

	for (idx = 0; idx < Rebels.Length; ++idx)
	{
		// Only count rebels that are on this job and which haven't switched jobs today, unless
		// IgnoreJobChanges is true.
		if (Rebels[idx].Job == JobName && 
				(IgnoreJobChanges || Rebels[idx].JobAtLastUpdate == Rebels[idx].Job))
		{
			RebelLevels += LEVEL_DATA[Rebels[idx].Level].Value;
		}
	}

	return RebelLevels;
}

// Reset the income pool for a particular job to zero.
function ResetIncomePool(Name JobName)
{
	local int idx;
	
	idx = GetIncomePoolIndexForJob(JobName);
	IncomePools[idx].Value = 0;
}

function ResetJobBucket(Name JobName)
{
	local int idx;
	local RebelJobDays JobDaysBucket;
	idx = JobBuckets.Find('Job', Jobname);
	if (idx != -1)
	{
		`LWTRACE ("GetJobBucketForJob: Clearing" @ JobName @ idx);
		JobBuckets[idx].Days = 0;
	}
	else
	{
		JobDaysBucket.Job = JobName;
		JobDaysBucket.Days = 0;
		`LWTRACE ("Bad Clear / Adding" @ JobDaysBucket.Job);
		JobBuckets.AddItem(JobDaysBucket);
	}
}

// Return the amount of income that will be applied each day to the given job. This is a factor of the number of rebel levels
// on this job + any modifiers to be applied to this job. If "IgnoreJobChanges" is true, the value returned will be assuming
// each rebel on the job is actively working. If false (the default) only rebels that have not changed jobs today will count.
// if "Verbose" is true, additional info is logged about modifiers applied to the values.
function float GetDailyIncomeForJob(Name JobName, bool IgnoreJobChanges = false, optional bool Verbose = false)
{
	local X2StrategyElementTemplateManager StrategyTemplateMgr;
	local LWRebelJobTemplate JobTemplate;
	local float Mod;
	local LWRebelJobIncomeModifier Modifier;
	local float RebelLevels;
	//local int NumFaceless;
	local float DailyJobIncome;

	StrategyTemplateMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	JobTemplate = LWRebelJobTemplate(StrategyTemplateMgr.FindStrategyElementTemplate(JobName));

	RebelLevels = GetRebelLevelsOnJob(JobName, IgnoreJobChanges);

	if(JobTemplate != none)
	{
		if (JobTemplate.GetDailyIncomeFn != none)
		{
			DailyJobIncome = JobTemplate.GetDailyIncomeFn(self, RebelLevels, JobTemplate);
		}
		else
		{
			// No income function, use the "standard" formula
			DailyJobIncome = ((RebelLevels * JobTemplate.IncomePerRebel));
		}
	}

	if (Verbose)
	{
		`LWTrace("[" $ JobName $ "] Daily base income: " $ DailyJobIncome);
	}

	// Apply modifiers on the income
	foreach JobTemplate.IncomeModifiers(Modifier)
	{
		Mod = Modifier.GetModifier(self);
		DailyJobIncome *= Mod;
		if (Mod != 1.0 && Verbose)
		{
			`LWTrace("[" $ JobName $ "] Income after modifier " $ Modifier.GetDebugName() $ ": " $ Mod $ " = " $ DailyJobIncome);
		}
	}

	return DailyJobIncome;
}

// Fetch the projected income for a given job. This is done with the assumption that everyone on the job is a real rebel and not a faceless.
function float GetProjectedMonthlyIncomeForJob(Name JobName)
{
	local XComGameState_HeadquartersResistance ResistanceHQ;
	local int DaysRemaining;

	ResistanceHQ = class'UIUtilities_Strategy'.static.GetResistanceHQ();
	DaysRemaining = class'X2StrategyGameRulesetDataStructures'.static.DifferenceInDays(ResistanceHQ.MonthIntervalEndTime, GetCurrentTime());

	// The expected income for this month is the sum of:
	// 1) What we've gathered so far
	// 2) What we can expect to get today, considering that rebels that changed jobs today don't count
	// 3) What we can expect to get for the rest of the month excluding today, for all rebels including those that have changed jobs today
	return (GetDailyIncomeForJob(JobName, true) * (DaysRemaining-1)) + GetDailyIncomeForJob(JobName, false) + GetIncomePoolForJob(JobName);
}

protected function bool AddJobIncome(Name JobName, float RebelLevels, XComGameState NewGameState)
{
	local LWRebelJobTemplate JobTemplate;
	local int idx;
	local bool GiveIncome;
	local float Income;
	local String RegionName;

	JobTemplate = GetJobTemplate(JobName);
	if (JobTemplate == none)
	{
		`redscreen("Couldn't find the template for job " $ JobName);
		return false;
	}

	RegionName = GetWorldRegionForOutpost().GetMyTemplate().DisplayName;

	idx = GetIncomePoolIndexForJob(JobName);
	`LWTrace("[" $ JobName $ " " $ RegionName $ "] Previous income pool: " $ IncomePools[idx].Value);

	// Add to the pool value according to the income rate in the template and the number of rebels on the job.
	Income = GetDailyIncomeForJob(JobName, false, true);

	IncomePools[idx].Value += Income;

	`LWTrace("[" $ JobName $ " " $ RegionName $ "] Final income pool: " $ IncomePools[idx].Value);

	// Negative income is possible (for the true values) - make sure the pool totals don't go negative
	if (IncomePools[idx].Value < 0)
		IncomePools[idx].Value = 0;
		
	// If we've accumulated enough income, fire the income event (if present)
	if (JobTemplate.IncomeEventFn != none)
	{
		if (JobTemplate.IncomeThresholdFn != none && JobTemplate.IncomeThresholdFn(self, IncomePools[idx].Value, JobTemplate))
		{
			GiveIncome = true;
		}
		else if (JobTemplate.IncomeThresholdFn == none && IncomePools[idx].Value >= INCOME_POOL_THRESHOLD)
		{
			GiveIncome = true;
		}

		if (GiveIncome)
		{
			JobTemplate.IncomeEventFn(self, NewGameState, JobTemplate);
			ResetIncomePool(JobName);
			return true;
		}
	}

	return false;
}

protected function UpdateJobIncomePools(XComGameState NewGameState, out array<LWRebelJobTemplate> JobsPendingVisualization)
{
	local X2StrategyElementTemplateManager StrategyTemplateMgr;
	local array<X2StrategyElementTemplate> Templates;
	local int idx;
	local float RebelLevels;
	local Name JobName;

	StrategyTemplateMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	Templates = StrategyTemplateMgr.GetAllTemplatesOfClass(class'LWRebelJobTemplate');

	for (idx = 0; idx < Templates.Length; ++idx)
	{
		JobName = Templates[idx].DataName;
		RebelLevels = GetRebelLevelsOnJob(JobName); 
		if (AddJobIncome(JobName, RebelLevels, NewGameState)) 
		{
			JobsPendingVisualization.AddItem(LWRebelJobTemplate(Templates[idx]));
		}
	}
}

function UpdateJobBuckets(XComGameState NewGameState)
{
	local X2StrategyElementTemplateManager StrategyTemplateMgr;
	local array<X2StrategyElementTemplate> Templates;
	local int idx, RebelsOnJob, k, DetectionChance;
	local name JobName;
	local RebelJobDays JobDaysBucket, EmptyJobDaysBucket;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;

	StrategyTemplateMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	Templates = StrategyTemplateMgr.GetAllTemplatesOfClass(class'LWRebelJobTemplate');

	RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(GetWorldRegionForOutpost(), NewGameState);

	`LWTRACE("UpdateJobBuckets");

	// updates campaigns to 1.3
	if (JobBuckets.length == 0)
	{
		`LWTRACE ("Adding Missing Job Buckets");

		for (idx = 0; idx < Templates.Length; ++idx)
		{
			JobDaysBucket = EmptyJobDaysBucket;
			JobDaysBucket.Job = Templates[idx].DataName;
			JobDaysBucket.Days = 0;
			`LWTRACE ("Adding" @ JobDaysBucket.Job);
			JobBuckets.AddItem(JobDaysBucket);
		}
	}

	for (idx = 0; idx < Templates.Length; ++idx)
	{
		JobName = Templates[idx].DataName;
		RebelsOnJob = GetNumRebelsOnJob(JobName);
		
		if (JobName != class'LWRebelJob_DefaultJobSet'.const.HIDING_JOB)
		{
			for (k = 0; k < RebelsOnJob; k++)
			{
				DetectionChance = default.JOB_DETECTION_CHANCE[`STRATEGYDIFFICULTYSETTING];
				DetectionChance += GetNumFaceless() * default.JOB_DETECTION_CHANCE_BONUS_PER_FACELESS[`STRATEGYDIFFICULTYSETTING];
				DetectionChance += RegionalAI.LocalVigilanceLevel * default.JOB_DETECTION_CHANCE_BONUS_PER_VIGILANCE[`STRATEGYDIFFICULTYSETTING];
				DetectionChance += RegionalAI.LocalAlertLevel * default.JOB_DETECTION_CHANCE_BONUS_PER_ALERT[`STRATEGYDIFFICULTYSETTING];
				DetectionChance += RegionalAI.LocalAlertLevel * default.JOB_DETECTION_CHANCE_BONUS_PER_FORCE[`STRATEGYDIFFICULTYSETTING];

				if (`SYNC_RAND (100) < DetectionChance)
				{
					//`LWTRACE ("Rebel Activity Detected");
					JobBuckets[idx].Days += 1;
					TotalResistanceBucket += 1;
				}
			}
		}
	}
}

protected function ResetJobIncomePools(XComGameState NewGameState)
{
	local X2StrategyElementTemplateManager StrategyTemplateMgr;
	local array<X2StrategyElementTemplate> Templates;
	local int idx;
	local Name JobName;

	StrategyTemplateMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	Templates = StrategyTemplateMgr.GetAllTemplatesOfClass(class'LWRebelJobTemplate');

	for (idx = 0; idx < Templates.Length; ++idx)
	{
		JobName = Templates[idx].DataName;
		ResetIncomePool(JobName);
	}
}

function bool Update(XComGameState NewGameState, optional out array<LWRebelJobTemplate> JobsPendingVisualization)
{
	local XComGameState_WorldRegion WorldRegion;
	local int k;
	local string AlertString;
	local XGParamTag ParamTag;
	local UIStrategyMap StrategyMap;
	local XGGeoscape Geoscape;

	WorldRegion = GetWorldRegionForOutpost();

	if (class'X2StrategyGameRulesetDataStructures'.static.LessThan(NextUpdateTime, GetCurrentTime()))
	{
		if (WorldRegion.ResistanceLevel >= eResLevel_Contact)
		{
			UpdateJobIncomePools(NewGameState, JobsPendingVisualization);
			UpdateJobBuckets(NewGameState);

			// Handle jobs temporarily prohibited by enemy action
			for (k = ProhibitedJobs.Length-1; k >= 0; k--)
			{
				ProhibitedJobs[k].DaysLeft -= 1;
				if (ProhibitedJobs[k].DaysLeft <= 0)
				{
					ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
					ParamTag.StrValue0 = WorldRegion.GetMyTemplate().DisplayName;
					ParamTag.StrValue1 = GetJobName(ProhibitedJobs[k].Job);
					AlertString = `XEXPAND.ExpandString(class'XComGameState_LWOutPost'.default.m_strProhibitedJobEnded);
					`HQPRES.Notify (AlertString);
					StrategyMap = `HQPRES.StrategyMap2D;
					if (StrategyMap != none && StrategyMap.m_eUIState != eSMS_Flight)
					{
						Geoscape = `GAME.GetGeoscape();
						Geoscape.Pause();
						Geoscape.Resume();
					}
					ProhibitedJobs.Remove(k,1);
				}
			}
			
			for (k = CurrentRetributions.Length-1; k >= 0; k--)
			{
				CurrentRetributions[k].DaysLeft -= 1;
				if (CurrentRetributions[k].DaysLeft <= 0)
				{
					ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
					ParamTag.StrValue0 = WorldRegion.GetMyTemplate().DisplayName;
					AlertString = `XEXPAND.ExpandString(class'XComGameState_LWOutPost'.default.m_strRetributionEnded);
					`HQPRES.Notify (AlertString);
					StrategyMap = `HQPRES.StrategyMap2D;
					if (StrategyMap != none && StrategyMap.m_eUIState != eSMS_Flight)
					{
						Geoscape = `GAME.GetGeoscape();
						Geoscape.Pause();
						Geoscape.Resume();
					}
					CurrentRetributions.Remove(k,1);
				}
			}
		}

		FacelessDays += GetNumFaceless();

		// Update all the last update jobs for each rebel
		for (k = 0; k < Rebels.Length; ++k)
		{
			Rebels[k].JobAtLastUpdate = Rebels[k].Job;
		}

		// Update the jobs to refresh the supply totals shown in regions and in the top right sum.
		UpdateJobs(NewGameState);

		// Same time tomorrow. We gotta keep ticking up this next update time every day even for uncontacted
		// regions, otherwise when they do become contacted this update will fire on each update (which are very frequent),
		// incrementing the next update time by 24 hours each time until it finally catches up to the current game time.
		class'X2StrategyGameRulesetDataStructures'.static.AddDay(NextUpdateTime);
		return true;
	}
	return false;
}

//---------------------------------------------------------------------------------------
function UpdateGameBoard()
{
	local XComGameState NewGameState;
	local XComGameState_LWOutpost OutpostState;
	local XComGameStateHistory History;
	local LWRebelJobTemplate JobTemplate;
	local array<LWRebelJobTemplate> JobsPendingVisualization;

	History = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Update Outpost");

	OutpostState = XComGameState_LWOutpost(NewGameState.CreateStateObject(class'XComGameState_LWOutpost', ObjectID));
	NewGameState.AddStateObject(OutpostState);

	if (!OutpostState.Update(NewGameState, JobsPendingVisualization))
	{
		NewGameState.PurgeGameStateForObjectID(OutpostState.ObjectID);
	}

	if (NewGameState.GetNumGameStateObjects() > 0)
	{
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
	else
	{
		// Nobody should've fired any income events if we have nothing in our state.
		`assert(JobsPendingVisualization.Length == 0);
		History.CleanupPendingGameState(NewGameState);
	}

	foreach JobsPendingVisualization(JobTemplate)
	{
		if (JobTemplate.IncomeEventVisualizationFn != none)
		{
			JobTemplate.IncomeEventVisualizationFn(self, JobTemplate);
		}
	}
}

function XComGameState_WorldRegion GetWorldRegionForOutpost()
{
	return XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(Region.ObjectID));
}

// Perform end-of-month maintenance
function OnMonthEnd(XComGameState NewGameState)
{
	local int i;
	local int DaysServed;
	local XComGameState_WorldRegion RegionState;

	// Level up rebels

	RegionState = GetWorldRegionForOutPost();

	if (RegionState.HaveMadeContact())
	{
		for (i = 0; i < Rebels.Length; ++i)
		{
			DaysServed = class'X2StrategyGameRulesetDataStructures'.static.DifferenceInDays(GetCurrentTime(), Rebels[i].StartDate);
			if ((Rebels[i].Level+1) < LEVEL_DATA.Length)
			{
				if (DaysServed >= LEVEL_DATA[Rebels[i].Level].DaysNeededForPromotion &&
						`SYNC_RAND(100) < LEVEL_DATA[Rebels[i].Level].ChanceForPromotion)
				{
					`LWTrace("Rebel " $ Rebels[i].Unit.ObjectID $ " has leveled up");
					PromoteRebel(Rebels[i].Unit, NewGameState);
				}
			}
		}
	}

	// Record supplies taken for diminishingreturnsmechanic
	SuppliesTaken += GetIncomePoolForJob('Resupply');

	// Clear the supply pool
	ResetIncomePool('Resupply');

	// Reset our faceless-days
	FacelessDays = 0;

	// Refresh the region's base supply for the new month
	UpdateJobs(NewGameState);
}

function SetLiaison(StateObjectReference UnitRef, XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_StaffSlot StaffSlotState;
	local XComGameState_StaffSlot OldStaffSlot;
	local XComGameState_Unit Unit;
	local StaffUnitInfo UnitInfo;

	History = `XCOMHISTORY;

	if (UnitRef.ObjectID != 0)
	{
		Unit = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));
	}

	StaffSlotState = XComGameState_StaffSlot(History.GetGameStateForObjectId(StaffSlot.ObjectID));

	// If the unit we're assigning was previously assigned to a slot we need to remove them.
	if (Unit != none && Unit.StaffingSlot.ObjectID != 0)
	{
		OldStaffSlot = XComGameState_StaffSlot(History.GetGameStateForObjectID(Unit.StaffingSlot.ObjectID));
	}

	if (OldStaffSlot != none)
	{
		if (StaffSlotState.ObjectID == OldStaffSlot.ObjectID)
		{
			// Re-assigning to same location: do nothing.
			return;
		}
		else
		{
			// Remove the unit from their previous job.
			if (!OldStaffSlot.CanStaffBeMoved())
			{
				// This should've been handled by the adviser picker disallowing them as candidates.
				`redscreen("Tried to assign an advisor that can't leave their old job");
				return;
			}
			else
			{
				OldStaffSlot.EmptySlot(NewGameState);
			}
		}
	}

	// Remove any previous adviser
	if (StaffSlotState.IsSlotFilled())
	{
		StaffSlotState.EmptySlot(NewGameState);
	}

	if (UnitRef.ObjectID != 0)
	{
		UnitInfo.UnitRef = UnitRef;
		StaffSlotState.FillSlot(UnitInfo, NewGameState);
	}
}

function StateObjectReference GetLiaison()
{
	local XComGameState_StaffSlot StaffSlotState;
	local StateObjectReference NullRef;

	StaffSlotState = XComGameState_StaffSlot(`XCOMHISTORY.GetGameStateForObjectId(StaffSlot.ObjectID));
	if (StaffSlotState != none)
	{
		return StaffSlotState.AssignedStaff.UnitRef;
	}
	return NullRef;
}

function bool HasLiaison()
{
	return GetLiaison().ObjectID != 0;
}

function int GetRebelIndex(StateObjectReference UnitRef)
{
	local int i;

	i = Rebels.Find('Unit', UnitRef);
	if (i == -1)
		i = Rebels.Find('Proxy', UnitRef);

	return i;
}

function SetRebelProxy(StateObjectReference UnitRef, StateObjectReference ProxyRef)
{
	local int i;

	i = Rebels.Find('Unit', UnitRef);
	if (i == -1)
	{
		`redscreen("SetRebelProxy: No such rebel");
	}
	else
	{
		Rebels[i].Proxy = ProxyRef;
	}
}

function SetRebelOnMission(StateObjectReference UnitRef)
{
	local int i;

	i = GetRebelIndex(UnitRef);

	if (i == -1)
	{
		`redscreen("SetRebelOnMission: No such rebel");
	}
	else
	{
		Rebels[i].IsOnMission = true;
	}
}

function SetMecProxy(StateObjectReference UnitRef, StateObjectReference ProxyRef)
{
	local int i;

	i = ResistanceMecs.Find('Unit', UnitRef);
	if (i == -1)
	{
		`redscreen("SetMecProxy: No such mec");
	}
	else
	{
		ResistanceMecs[i].Proxy = ProxyRef;
	}
}

function SetMecOnMission(StateObjectReference UnitRef)
{
	local int i;

	i = ResistanceMecs.Find('Unit', UnitRef);
	if (i == -1)
		i = ResistanceMecs.Find('Proxy', UnitRef);

	if (i == -1)
	{
		`redscreen("SetResistanceMecOnMission: No such Mec");
	}
	else
	{
		ResistanceMecs[i].IsOnMission = true;
	}
}

function bool IsProxyUnit(StateObjectReference UnitRef)
{
	return Rebels.Find('Proxy', UnitRef) >= 0 || ResistanceMecs.Find('Proxy', UnitRef) >= 0;
}

function bool HasLiaisonOfKind(Name TemplateName)
{
	local XComGameState_Unit Unit;

	if (!HasLiaison())
		return false;

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(GetLiaison().ObjectID));
	// Special case 'Soldier' to work with any soldier type.
	if (TemplateName == 'Soldier')
	{
		return Unit.IsSoldier();
	}

	// Otherwise we need an exact match
	return (Unit.GetMyTemplateName() == TemplateName);
}

function int GetRebelLevel(StateObjectReference UnitRef)
{
	local int i;

	i = GetRebelIndex(UnitRef);

	if (i == -1)
	{
		`Redscreen("GetRebelLevel: No such rebel");
		return 0;
	}

	return Rebels[i].Level;
}

function PromoteRebel(StateObjectReference UnitRef, XComGameState NewGameState)
{
	local int i;
	local XComGameState_Unit Unit;

	i = GetRebelIndex(UnitRef);

	if (i == -1)
	{
		`Redscreen("PromoteRebel: No such rebel");
		return;
	}

	Rebels[i].Level++;

	Unit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', UnitRef.ObjectID));
	NewGameState.AddStateObject(Unit);

	GiveAWCPerk(Unit, default.REBEL_AWC_ABILITIES_OFFENSE, Rebels[i].Level);
	GiveAWCPerk(Unit, default.REBEL_AWC_ABILITIES_DEFENSE, Rebels[i].Level);
}

function GiveAWCPerk(XComGameState_Unit Unit, array<RebelAbilityConfig> AbilitySet, int Level)
{
	local array<ClassAgnosticAbility> Abilities;
	local int i;
	local ClassAgnosticAbility Ability;

	Abilities = GetValidAbilitiesForRebel(Unit, AbilitySet, Level);
	
	if (Abilities.Length == 0)
	{
		`REDSCREEN("No abilities left for unit promotion!");
	}

	i = `SYNC_RAND(Abilities.Length);

	Ability = Abilities[i];
	Ability.bUnlocked = true;
	Ability.iRank = 0;
	`LWTrace("Awarding ability " $ Ability.AbilityType.AbilityName $ " to " $ Unit.GetFullName());
	Unit.AWCAbilities.AddItem(Ability);
}

static function array<ClassAgnosticAbility> GetValidAbilitiesForRebel(XComGameState_Unit UnitState, array<RebelAbilityConfig> SourceAbilities, int AWCLevel)
{
	local array<ClassAgnosticAbility> Abilities;
	local ClassAgnosticAbility NewAbility;
	local RebelAbilityConfig PossibleAbility;
	local X2AbilityTemplateManager AbilityTemplateManager;
	local X2AbilityTemplate AbilityTemplate;

	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	foreach SourceAbilities(PossibleAbility)
	{
		AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(PossibleAbility.AbilityName);
		if (AbilityTemplate != none && PossibleAbility.Level == AWCLevel &&!HasEarnedAbility(UnitState, PossibleAbility.AbilityName))
		{
			NewAbility.iRank = PossibleAbility.Level;
			NewAbility.bUnlocked = false;
			NewAbility.AbilityType.AbilityName = PossibleAbility.AbilityName;
			NewAbility.AbilityType.ApplyToWeaponSlot = PossibleAbility.ApplyToWeaponSlot;
			Abilities.AddItem(NewAbility);
		}
	}

	return Abilities;
}

static function bool HasEarnedAbility(XComGameState_Unit Unit, name AbilityName)
{
	local array<SoldierClassAbilityType> EarnedAbilities;
	local int i;

	EarnedAbilities = Unit.GetEarnedSoldierAbilities();
	for (i = 0; i < EarnedAbilities.Length; ++i)
	{
		if (EarnedAbilities[i].AbilityName == AbilityName)
			return true;
	}

	return false;
}

function StateObjectReference GetRebelByName(String FirstName, String LastName)
{
	local int i;
	local XComGameState_Unit RebelState;
	local StateObjectReference EmptyRef;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	for (i = 0; i < Rebels.Length; ++i)
	{
		RebelState = XComGameState_Unit(History.GetGameStateForObjectID(Rebels[i].Unit.ObjectID));
		if (RebelState.GetFirstName() ~= FirstName && RebelState.GetLastName() ~= LastName)
		{
			return Rebels[i].Unit;
		}
	}

	`Redscreen("GetRebelByName: No rebel with name " $ FirstName $ " " $ LastName);
	return EmptyRef;
}

function bool AreMaxRebelsAssigned()
{
	local int WorkingRebels;

	WorkingRebels = Rebels.Length - GetNumRebelsOnJob(class'LWRebelJob_DefaultJobSet'.const.HIDING_JOB);
	if (WorkingRebels == MaxRebels)
		return true;
	if (WorkingRebels > MaxRebels)
	{
		`LWTRACE ("Error: Too many rebels have a job in this outpost somehow.");
		return true;
	}
	return false;
}

function AddProhibitedJob (name JobName, int DurationinDays)
{
	local ProhibitedJobStruct ProhibitedJob;

	ProhibitedJob.Job = JobName;
	ProhibitedJob.DaysLeft = DurationinDays;
	ProhibitedJobs.AddItem(ProhibitedJob);	
}

function bool CanLiaisonBeMoved()
{
	local XComGameState_MissionSite MissionSite;
	local MissionSettings_LW MissionSettings;

	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_MissionSite', MissionSite)
	{
		// We only care about detected missions in this region
		if (MissionSite.Region == Region && MissionSite.Available)
		{
			if (class'Utilities_LW'.static.GetMissionSettings(MissionSite, MissionSettings))
			{
				if (MissionSettings.RestrictsLiaison)
					return false;
			}
		}
	}

	return true;
}

function int GetEndOfMonthSupply()
{
	local float GrossSupplies, Penalty, NetSupplies, SupplyMonthDuration;
	local String RegionName;

	RegionName = GetWorldRegionForOutpost().GetMyTemplate().DisplayName;
	GrossSupplies = GetIncomePoolForJob('Resupply');
	SupplyMonthDuration = float (class'XComGameState_HeadquartersResistance'.default.MinSuppliesInterval + class'XComGameState_HeadquartersResistance'.default.MaxSuppliesInterval) / 2.0;
	// Supply month duration in the config is in hours but faceless time is counted in days. Convert supply interval to days.
	SupplyMonthDuration /= 24.0;
	Penalty = (FACELESS_SUPPLY_DRAIN/100.0) * (FacelessDays/SupplyMonthDuration) * GrossSupplies ;
	NetSupplies = Max(GrossSupplies - Penalty, 0);
	`LWTrace("[" $ RegionName $ "] End of month supply: " $ GrossSupplies $ " - " $ Penalty $ " = " $ NetSupplies);
	return NetSupplies;
}

// We need a UI class for all strategy elements (but they'll never be visible)
function class<UIStrategyMapItem> GetUIClass()
{
	return class'UIStrategyMapItem';
}

// Never show these on the map.
function bool ShouldBeVisible()
{
	return false;
}

function UpdateRebelAbilities(XComGameState NewGameState)
{
	local RebelUnit Rebel;
	local XComGameState_Unit UnitState;

	foreach Rebels(Rebel)
	{
		UnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', Rebel.Unit.ObjectID));
		NewGameState.AddStateObject(UnitState);
		// Rebel has ranked up but has no abilities, so give them abilities
		if (Rebel.Level > 0 && UnitState.AWCAbilities.Length == 0)
		{
			if (Rebel.Level >= 1)
			{
				GiveAWCPerk(UnitState, default.REBEL_AWC_ABILITIES_OFFENSE, 1); 
				GiveAWCPerk(UnitState, default.REBEL_AWC_ABILITIES_DEFENSE, 1); 
			}

			if (Rebel.Level >= 2)
			{
				GiveAWCPerk(UnitState, default.REBEL_AWC_ABILITIES_OFFENSE, 2); 
				GiveAWCPerk(UnitState, default.REBEL_AWC_ABILITIES_DEFENSE, 2); 
			}
		}
	}
}

function AddChosenRetribution(int DurationinDays)
{
	local RetributionJobStruct RetributionInstance;
	RetributionInstance.DaysLeft = DurationinDays;
	CurrentRetributions.AddItem(RetributionInstance);
}
