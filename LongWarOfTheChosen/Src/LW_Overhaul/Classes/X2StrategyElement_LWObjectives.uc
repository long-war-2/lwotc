//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_LWObjectives.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Defines new strategy-level objectives for LW Overhaul
//---------------------------------------------------------------------------------------
class X2StrategyElement_LWObjectives extends X2StrategyElement_DefaultObjectives config(LW_Overhaul);

var config int REGIONS_TO_BLACKSITE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Objectives;
	
	Objectives.AddItem(CreateLW_T2_M0_Outpost_Template());
	Objectives.AddItem(CreateLW_T2_M0_S1_ReviewOutpostTemplate());

	Objectives.AddItem(CreateLW_T2_M0_Liberate_RegionTemplate());
	Objectives.AddItem(CreateLW_T2_M0_S2_FindLiberation1ActivityTemplate()); // Find PR1

	Objectives.AddItem(CreateLW_T2_M0_S3_DefeatLiberation2ActivityTemplate()); // Find and win PR2

	Objectives.AddItem(CreateLW_T2_M0_S4_AssaultNetworkTowerTemplate()); // Go on last liberation chain
	Objectives.AddItem(CreateLW_T2_M0_S5_CompleteActivityTemplate());

	Objectives.AddItem(CreateLW_T2_M1_ContactBlacksiteRegionTemplate());
	Objectives.AddItem(CreateLW_T2_M1_L0_LookAtBlacksiteTemplate());
	Objectives.AddItem(CreateLW_T2_M1_N1_RevealBlacksiteObjectiveTemplate());
	Objectives.AddItem(CreateLW_T2_M1_N2_RevealAvatarProjectTemplate());

	return Objectives;
}

// #######################################################################################
// -------------------- LW T2 M0 --------------------------------------------------
static function X2DataTemplate CreateLW_T2_M0_Outpost_Template()
{
	local X2ObjectiveTemplate Template;
	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_T2_M0_Outpost');
	Template.bMainObjective = true;
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_Contact_Resistance";

	Template.Steps.AddItem('LW_T2_M0_S1_ReviewOutpost'); // assign some rebels to search for the activity

	return Template;
}

static function X2DataTemplate CreateLW_T2_M0_Liberate_RegionTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_T2_M0_Liberate_Region');
	Template.bMainObjective = true;
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_Contact_Resistance";

	Template.Steps.AddItem('LW_T2_M0_S2_FindLiberation1Activity'); // wait until activity is found
	Template.Steps.AddItem('LW_T2_M0_S3_DefeatLiberation2Activity'); // wait until activity is found
	Template.Steps.AddItem('LW_T2_M0_S4_AssaultNetworkTower'); // assault the network tower, which will reveal blacksite
	Template.Steps.AddItem('LW_T2_M0_S5_CompleteActivity'); // finish the activity once it is found

	Template.CompletionEvent = '';

	return Template;
}

static function X2DataTemplate CreateLW_T2_M0_S1_ReviewOutpostTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_T2_M0_S1_ReviewOutpost');
	Template.bMainObjective = false;
	Template.CompletionEvent = 'OnLeaveOutpost';

	return Template;
}

static function X2DataTemplate CreateLW_T2_M0_S2_FindLiberation1ActivityTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_T2_M0_S2_FindLiberation1Activity');
	Template.bMainObjective = false;
	Template.NextObjectives.AddItem('LW_T2_M0_S3_DefeatLiberation2Activity');
	Template.CompletionEvent = 'LiberateStage1Complete';
	Template.InProgressFn = MissionSearchInProgress;
	return Template;
}

function bool MissionSearchInProgress()
{
    local XComGameState_LWOutpost Outpost;

	if(`XCOMHQ.IsObjectiveCompleted('LW_T2_M0_S2_FindLiberation1Activity'))
		return false;
    foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_LWOutpost', Outpost)
    {
		if(Outpost.GetNumRebelsOnJob('Intel') > 0)
			return true;
    }
	return false;
}

static function X2DataTemplate CreateLW_T2_M0_S3_DefeatLiberation2ActivityTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_T2_M0_S3_DefeatLiberation2Activity');
	Template.bMainObjective = false;

	Template.NextObjectives.AddItem('LW_T2_M0_S4_AssaultNetworkTower');
	Template.CompletionEvent = 'LiberateStage2Complete';
	Template.InProgressFn = Mission2SearchInProgress;

	return Template;
}

function bool Mission2SearchInProgress()
{
	local XComGameState_LWAlienActivity ActivityState;

	if(`XCOMHQ.IsObjectiveCompleted('LW_T2_M0_S3_DefeatLiberation2Activity'))
		return false;

	foreach `XCOMHistory.IterateByClassType(class'XComGameState_LWAlienActivity', ActivityState)
	{
		if(ActivityState.GetMyTemplateName() == class'X2StrategyElement_DefaultAlienActivities'.default.ProtectRegionMidName && ActivityState.bDiscovered)
		{
			return true;
		}
	}
	return false;
}

static function X2DataTemplate CreateLW_T2_M0_S4_AssaultNetworkTowerTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_T2_M0_S4_AssaultNetworkTower');
	Template.bMainObjective = false;

	Template.NextObjectives.AddItem('LW_T2_M0_S5_CompleteActivity');
	Template.NextObjectives.AddItem('LW_T2_M1_ContactBlacksiteRegion');  // this leads into the regular base-game objectives
	Template.NextObjectives.AddItem('LW_T2_M1_L1_LookAtBlacksite');
	Template.NextObjectives.AddItem('LW_T2_M1_N1_RevealBlacksiteObjective');
	Template.CompletionEvent = 'NetworkTowerDefeated';  // Do Blacksite after Network Tower, and move Avatar Project to after AssaultAlienBase
	Template.InProgressFn = AnyProtectRegion3ActivityVisible;
	return Template;
}

static function ActivateChosenIfEnabled(XComGameState NewGameState, XComGameState_Objective ObjectiveState)
{
	if (!`SecondWaveEnabled('DisableChosen'))
	{
		class'X2StrategyElement_XpackObjectives'.static.ActivateChosen(NewGameState, ObjectiveState);
	}
}

static function X2DataTemplate CreateLW_T2_M0_S5_CompleteActivityTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_T2_M0_S5_CompleteActivity');
	Template.bMainObjective = false;
	Template.NextObjectives.AddItem('LW_T2_M1_N2_RevealAvatarProject');
	Template.CompletionEvent = 'RegionLiberatedFlagSet';
	Template.InProgressFn = AnyProtectRegion3ActivityVisible;
	return Template;
}

function bool AnyProtectRegion3ActivityVisible()
{
	local XComGameState_LWAlienActivity ActivityState;

	if(`XCOMHQ.IsObjectiveCompleted('LW_T2_M0_S4_AssaultNetworkTower'))
		return false;

	foreach `XCOMHistory.IterateByClassType(class'XComGameState_LWAlienActivity', ActivityState)
	{
		if(ActivityState.GetMyTemplateName() == class'X2StrategyElement_DefaultAlienActivities'.default.ProtectRegionName && ActivityState.bDiscovered)
		{
			return true;
		}
	}
	return false;
}

// #######################################################################################
// -------------------- LW T2 M1 --------------------------------------------------

static function X2DataTemplate CreateLW_T2_M1_ContactBlacksiteRegionTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_T2_M1_ContactBlacksiteRegion');
	Template.bMainObjective = true;
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_Contact_Resistance";

	Template.NextObjectives.AddItem('T2_M1_InvestigateBlacksite');  // this leads into the regular base-game objectives
	Template.Steps.AddItem('T2_M1_S1_ResearchResistanceComms');  // this is a base-game subobjective
	Template.Steps.AddItem('T2_M1_S2_MakeContactWithBlacksiteRegion'); // this is a base-game subobjective

	Template.AssignObjectiveFn = MakeBlacksiteMissionAvailable;
	Template.CompletionEvent = '';

	Template.NagDelayHours = 2160; // 90 days = 3 months

	Template.AddNarrativeTrigger("X2NarrativeMoments.Strategy.GP_BlacksiteRegionContactReminder_Council", NAW_OnNag, 'OnGeoscapeEntry', '', ELD_OnStateSubmitted, NPC_Multiple, 'MakeContactNag');
	Template.AddNarrativeTrigger("X2NarrativeMoments.Strategy.Central_Support_Reminder_Make_Contact", NAW_OnNag, 'OnGeoscapeEntry', '', ELD_OnStateSubmitted, NPC_Multiple, 'MakeContactNag');

	return Template;
}

static function X2DataTemplate CreateLW_T2_M1_L0_LookAtBlacksiteTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_T2_M1_L1_LookAtBlacksite');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.CompletionEvent = 'CameraAtBlacksite';

	Template.AddNarrativeTrigger("", NAW_OnAssignment, 'OnEnteredFacility_CIC', '', ELD_OnStateSubmitted, NPC_Once, '', EnableFlightMode);
	Template.AddNarrativeTrigger("", NAW_OnAssignment, 'OnGeoscapeEntry', '', ELD_OnStateSubmitted, NPC_Once, '', CameraLookAtBlacksiteOpenUI);
	Template.AddNarrativeTrigger("X2NarrativeMoments.Strategy.GP_BlacksiteMissionSpawn_Council", NAW_OnAssignment, 'CameraAtBlacksite', '', ELD_OnStateSubmitted, NPC_Multiple, 'BlacksiteLockedLines');

	//removed because it references avatar project
	//Template.AddNarrativeTrigger("X2NarrativeMoments.Strategy.Central_Support_Blacksite_Mission_Locked", NAW_OnAssignment, 'CameraAtBlacksite', '', ELD_OnStateSubmitted, NPC_Multiple, 'BlacksiteLockedLines');

	return Template;
}

static function X2DataTemplate CreateLW_T2_M1_N1_RevealBlacksiteObjectiveTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_T2_M1_N1_RevealBlacksiteObjective');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.CompletionEvent = 'NarrativeUICompleted';

	// After liberating first region
	Template.AddNarrativeTrigger("LWNarrativeMoments_Bink.TACTICAL.CIN_BlacksiteIntro_LW", NAW_OnReveal, '', '', ELD_OnStateSubmitted, NPC_Once, '', BlacksiteJumpToCommandersQuarters);
	Template.AddNarrativeTrigger("X2NarrativeMoments.Strategy.GP_ContactBlacksiteRegionScreen", NAW_OnReveal, 'CinematicComplete', '', ELD_OnStateSubmitted, NPC_Once, '');

	// If first mission is skipped
	//Template.AddNarrativeTrigger("X2NarrativeMoments.Strategy.GP_WelcomeToTheResistance", NAW_OnReveal, '', '', ELD_OnStateSubmitted, NPC_Once, '', class'X2StrategyElement_DefaultObjectives'.static.WelcomeToTheResistanceComplete);
	//Template.AddNarrativeTrigger("X2NarrativeMoments.Strategy.GP_ContactBlacksiteRegionScreen", NAW_OnReveal, 'WelcomeToResistanceComplete', '', ELD_OnStateSubmitted, NPC_Once, '');

	return Template;
}


static function X2DataTemplate CreateLW_T2_M1_N2_RevealAvatarProjectTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_T2_M1_N2_RevealAvatarProject');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.RevealEvent = 'StartAvatarProjectReveal';
	Template.CompletionEvent = 'AvatarProjectRevealComplete';

	Template.AddNarrativeTrigger("", NAW_OnReveal, '', '', ELD_OnStateSubmitted, NPC_Once, '', RevealAvatarProject);
	//Template.AddNarrativeTrigger("X2NarrativeMoments.CIN_Avatar_Project", NAW_OnReveal, '', '', ELD_OnStateSubmitted, NPC_Once, '', AvatarProjectCinematicComplete);
	//Template.AddNarrativeTrigger("X2NarrativeMoments.S_GP_Avatar_Bar_Geoscape_Central", NAW_OnAssignment, 'CameraAtFortress', '', ELD_OnStateSubmitted, NPC_Once, '', AvatarProjectRevealComplete);

	return Template;
}

function RevealAvatarProject()
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_HeadquartersAlien AlienHQ;

	History = `XCOMHISTORY;
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	if(AlienHQ != none)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Reveal AVATAR Project");
		AlienHQ = XComGameState_HeadquartersAlien(NewGameState.CreateStateObject(class'XComGameState_HeadquartersAlien', AlienHQ.ObjectID));
		NewGameState.AddStateObject(AlienHQ);
	
	

	AlienHQ.bHasSeenFortress = true;

	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

	CinematicComplete();

	`HQPRES.UIFortressReveal();
	}
}


// tweaked functions for base game Golden Path:

static function CreatePreplacedGoldenPathMissionsLW(XComGameState NewGameState, XComGameState_Objective ObjectiveState)
{
	CreateGoldenPathMissionsLW(NewGameState);
	//CreateForgeAndPsiGateMissionsLW(NewGameState);
	CreateFortressMissionLW(NewGameState);

	// With missions now placed home regions for Chosen and Factions can be assigned
	AssignFactionAndChosenHomeRegionsLW(NewGameState);
}

static function AssignFactionAndChosenHomeRegionsLW(XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersResistance ResHQ;
	local XComGameState_HeadquartersAlien AlienHQ;

	History = `XCOMHISTORY;

	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	AlienHQ = XComGameState_HeadquartersAlien(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersAlien', AlienHQ.ObjectID));
	AlienHQ.SetChosenHomeAndTerritoryRegions(NewGameState);

	ResHQ = XComGameState_HeadquartersResistance(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));
	ResHQ = XComGameState_HeadquartersResistance(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersResistance', ResHQ.ObjectID));
	ResHQ.SetFactionHomeRegions(NewGameState);
}

static function CreateGoldenPathMissionsLW(XComGameState NewGameState)
{
	local XComGameState_MissionSite MissionState;
	local XComGameState_WorldRegion RegionState;
	local array<XComGameState_Reward> Rewards;
	local X2StrategyElementTemplateManager StratMgr;
	local X2RewardTemplate RewardTemplate;
	local XComGameState_Reward RewardState;
	local XComGameState_Continent ContinentState;
	local array<XComGameState_Continent> Continents;
	local array<XComGameState_WorldRegion> Regions;

	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();

	RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_Supplies'));
	RewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
	RewardState.SetReward(, GetBlacksiteSupplyAmount());
	Rewards.AddItem(RewardState);


	MissionState = CreateGPMissionLW(NewGameState, Rewards, 'MissionSource_BlackSite', default.REGIONS_TO_BLACKSITE, false, false, false);
	
	RegionState = MissionState.GetWorldRegion();
	RegionState = XComGameState_WorldRegion(NewGameState.ModifyStateObject(class'XComGameState_WorldRegion', RegionState.ObjectID));
	RegionState.SetShortestPathToContactRegion(NewGameState); // Flag the region to update its shortest path to a player-contacted region, used for region link display states

	Regions.AddItem(RegionState);

	ContinentState = XComGameState_Continent(NewGameState.GetGameStateForObjectID(RegionState.Continent.ObjectID));

	if(ContinentState == none)
	{
		ContinentState = RegionState.GetContinent();
	}

	Continents.AddItem(ContinentState);

	RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_Supplies'));
	RewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
	RewardState.SetReward(, GetPsiGateForgeSupplyAmount());
	Rewards.AddItem(RewardState);

	MissionState = CreateGPMissionLW(NewGameState, Rewards, 'MissionSource_Forge', 3, false, false, false, Regions, , , , , Continents);
	RegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(MissionState.Region.ObjectID));

	if(RegionState == none)
	{
		RegionState = MissionState.GetWorldRegion();
	}

	Regions.AddItem(RegionState);

	ContinentState = XComGameState_Continent(NewGameState.GetGameStateForObjectID(RegionState.Continent.ObjectID));

	if(ContinentState == none)
	{
		ContinentState = RegionState.GetContinent();
	}

	Continents.AddItem(ContinentState);

	Rewards.Length = 0;
	RewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
	RewardState.SetReward(, GetPsiGateForgeSupplyAmount());
	Rewards.AddItem(RewardState);

	CreateGPMissionLW(NewGameState, Rewards, 'MissionSource_PsiGate', 4, false, false, false, Regions, , , , , Continents);
}

static function CreateFortressMissionLW(XComGameState NewGameState)
{
	local array<XComGameState_Reward> Rewards;

	CreateMission(NewGameState, Rewards, 'MissionSource_Final', 0, false, true, false, , , true, default.FortressLocation);
}


static function XComGameState_MissionSite CreateGPMissionLW(XComGameState NewGameState, out array<XComGameState_Reward> MissionRewards, Name MissionSourceTemplateName,
												 int IdealDistanceFromResistanceNetwork, optional bool bForceAtThreshold = false, 
												 optional bool bSetMissionData = false, optional bool bAvailable = true, 
												 optional array<XComGameState_WorldRegion> AvoidRegions, optional int IdealDistanceFromRegion = -1, 
												 optional bool bNoRegion, optional Vector2D ForceLocation, optional name ForceRegionName = '', optional array<XComGameState_Continent> ExcludeContinents)
{
	local XComGameState_MissionSite MissionState;
	local X2RewardTemplate RewardTemplate;
	local XComGameState_Reward RewardState;
	local XComGameState_WorldRegion RegionState;
	local X2StrategyElementTemplateManager StratMgr;
	local X2MissionSourceTemplate MissionSource;
	local StateObjectReference RegionRef;
	local Vector2D v2Loc;

	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();

	// Create the mission site
	MissionState = XComGameState_MissionSite(NewGameState.CreateNewStateObject(class'XComGameState_MissionSite'));

	if(MissionRewards.Length == 0)
	{
		RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_None'));
		RewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
		MissionRewards.AddItem(RewardState);
	}

	// select the mission source
	MissionSource = X2MissionSourceTemplate(StratMgr.FindStrategyElementTemplate(MissionSourceTemplateName));

	// select the region for the mission
	if(!bNoRegion)
	{
		RegionState = SelectRegionForMissionLW(NewGameState, IdealDistanceFromResistanceNetwork, AvoidRegions, IdealDistanceFromRegion, ForceRegionName, ExcludeContinents);
		RegionRef = RegionState.GetReference();

		// have to set the initial "threshold" for mission visibility
		MissionState.bNotAtThreshold = (!RegionState.HaveMadeContact());
	}
	else
	{
		MissionState.bNotAtThreshold = true;
	}

	// build the mission, location needs to be updated when map generates if not forced
	if(ForceLocation != v2Loc)
	{
		v2Loc = ForceLocation;
	}
	else
	{
		MissionState.bNeedsLocationUpdate = true;
	}

	// Add the chosen stronghold unlock here.

	if (!`SecondWaveEnabled('DisableChosen'))
	{
		RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_LWRevealStronghold'));
		RewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
		RewardState.GenerateReward(NewGameState, ,RegionState.GetReference());
		MissionRewards.AddItem(RewardState);
	}

	MissionState.BuildMission(MissionSource, v2Loc, RegionRef, MissionRewards, bAvailable, false, , , , , bSetMissionData);
	
	if(bForceAtThreshold)
	{
		MissionState.bNotAtThreshold = false;
	}

	return MissionState;
}

static function XComGameState_WorldRegion SelectRegionForMissionLW(XComGameState NewGameState, int IdealDistanceFromResistanceNetwork, optional array<XComGameState_WorldRegion> AvoidRegions,
														  optional int IdealDistanceFromRegion = -1, optional name ForceRegionName = '', optional array <XComGameState_Continent> ExcludeContinents)
{
	local XComGameStateHistory History;
	local XComGameState_WorldRegion RegionState, TempRegion;
	local array<XComGameState_WorldRegion> AllRegions, PreferredRegions, BestRegions;
	local XComGameState_Continent ExcludeContinent;
	local int BestLinkDiff, CurrentLinkDiff;
	local bool bExcluded;

	History = `XCOMHISTORY;

	//Gather a list of all regions
	if( NewGameState.GetContext().IsStartState() )
	{
		foreach NewGameState.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
		{
			if(RegionState.GetMyTemplateName() == ForceRegionName)
			{
				return RegionState;
			}
			AllRegions.AddItem(RegionState);
		}
	}
	else
	{
		foreach History.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
		{
			if(RegionState.GetMyTemplateName() == ForceRegionName)
			{
				return RegionState;
			}
			AllRegions.AddItem(RegionState);
		}
	}

	BestLinkDiff = -1;

	//Make a list of valid regions based on ideal link distance
	foreach AllRegions(RegionState)
	{
		// TODO: track which regions have been selected for GP missions and exclude those from this list (maybe?)
		bExcluded = false;
		if(ExcludeContinents.Length > 0)
		{
			foreach ExcludeContinents (ExcludeContinent)
			{
				if(ExcludeContinent.Regions.Find('ObjectID', RegionState.ObjectID) != INDEX_NONE)
				{
					bExcluded = true;
					break;
				}

			}
			if(!bExcluded)
			{
				CurrentLinkDiff = Abs(IdealDistanceFromResistanceNetwork - RegionState.GetLinkCountToMinResistanceLevel(eResLevel_Contact));

				if(BestLinkDiff == -1 || CurrentLinkDiff < BestLinkDiff)
				{
					BestLinkDiff = CurrentLinkDiff;
					PreferredRegions.Length = 0;
					PreferredRegions.AddItem(RegionState);
				}
				else if(CurrentLinkDiff == BestLinkDiff)
				{
					PreferredRegions.AddItem(RegionState);
				}
			}	
		}	
	}

	if(PreferredRegions.Length == 0)
	{
		PreferredRegions = AllRegions;
	}

	if(AvoidRegions.Length > 0 && IdealDistanceFromRegion > 0)
	{
		BestLinkDiff = -1;
		
		foreach PreferredRegions(RegionState)
		{
			CurrentLinkDiff = Abs(IdealDistanceFromRegion - RegionState.FindClosestRegion(AvoidRegions, TempRegion));

			if(BestLinkDiff == -1 || CurrentLinkDiff < BestLinkDiff)
			{
				BestLinkDiff = CurrentLinkDiff;
				BestRegions.Length = 0;
				BestRegions.AddItem(RegionState);
			}
			else if(CurrentLinkDiff == BestLinkDiff)
			{
				BestRegions.AddItem(RegionState);
			}
		}
	}
	
	if(BestRegions.Length > 0)
	{
		return BestRegions[`SYNC_RAND_STATIC(BestRegions.Length)];
	}

	return PreferredRegions[`SYNC_RAND_STATIC(PreferredRegions.Length)];
}