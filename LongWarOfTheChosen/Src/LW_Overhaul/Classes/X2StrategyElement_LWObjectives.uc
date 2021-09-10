//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_LWObjectives.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Defines new strategy-level objectives for LW Overhaul
//---------------------------------------------------------------------------------------
class X2StrategyElement_LWObjectives extends X2StrategyElement_DefaultObjectives config(LW_Overhaul);

var config int BLACKSITE_INTEL;
var config int FORGE_INTEL;
var config int PSIGATE_INTEL;
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

	Objectives.AddItem(CreateT2_M3_CompleteForgeMissionTemplate_LW()); //Add rewards to, and make GP happen earlier
	Objectives.AddItem(CreateT4_M1_CompleteStargateMissionTemplate_LW()); //Add rewards to, and make GP happen earlier
	
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

	Template.AssignObjectiveFn = CreateBlacksiteMission_LW;
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

//override the original function to place blacksite very far away
static function CreateBlacksiteMission_LW(XComGameState NewGameState, XComGameState_Objective ObjectiveState)
{
	local array<XComGameState_Reward> Rewards;
	local X2StrategyElementTemplateManager StratMgr;
	local X2RewardTemplate RewardTemplate, RewardTemplateIntel;
	local XComGameState_Reward RewardState, RewardStateIntel;
	local XComGameState_MissionSite MissionState;
	local XComGameState_WorldRegion RegionState;

	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();

	RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_Supplies'));
	RewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
	RewardState.SetReward(, GetBlacksiteSupplyAmount());
	Rewards.AddItem(RewardState);

	RewardTemplateIntel = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_Intel'));
	RewardStateIntel = RewardTemplateIntel.CreateInstanceFromTemplate(NewGameState);
	RewardStateIntel.SetReward(, default.BLACKSITE_INTEL);

	Rewards.AddItem(RewardStateIntel);
	MissionState = CreateMission(NewGameState, Rewards, 'MissionSource_BlackSite', 0); // as far away from player as possible, because reasons

	RegionState = MissionState.GetWorldRegion();
	RegionState = XComGameState_WorldRegion(NewGameState.CreateStateObject(class'XComGameState_WorldRegion', RegionState.ObjectID));
	NewGameState.AddStateObject(RegionState);
	RegionState.SetShortestPathToContactRegion(NewGameState); // Flag the region to update its shortest path to a player-contacted region, used for region link display states
}

static function X2DataTemplate CreateLW_T2_M1_N2_RevealAvatarProjectTemplate()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'LW_T2_M1_N2_RevealAvatarProject');
	Template.bMainObjective = true;
	Template.bNeverShowObjective = true;

	Template.RevealEvent = '';
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
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Reveal AVATAR Project");
	AlienHQ = XComGameState_HeadquartersAlien(NewGameState.CreateStateObject(class'XComGameState_HeadquartersAlien', AlienHQ.ObjectID));
	NewGameState.AddStateObject(AlienHQ);

	AlienHQ.bHasSeenFortress = true;

	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

	CinematicComplete();

	`HQPRES.UIFortressReveal();
}

static function X2DataTemplate CreateT2_M3_CompleteForgeMissionTemplate_LW()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'T2_M3_CompleteForgeMission');
	Template.bMainObjective = true;
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_Forged";

	Template.NextObjectives.AddItem('T2_M4_BuildStasisSuit');

	Template.AssignObjectiveFn = CreateForgeMission_LW;
	Template.CompletionRequirements.RequiredItems.AddItem('StasisSuitComponent');
	Template.CompletionEvent = 'PostMissionDone';
	

	Template.NagDelayHours = 336;

	Template.AddNarrativeTrigger("X2NarrativeMoments.Strategy.GP_ForgeMissionScreen", NAW_OnReveal, '', '', ELD_OnStateSubmitted, NPC_Once, '', ShowShadowProjectResearchReport);

	return Template;
}

static function CreateForgeMission_LW(XComGameState NewGameState, XComGameState_Objective ObjectiveState)
{
	local XComGameState_MissionSite MissionState;
	local XComGameState_WorldRegion RegionState;
	local XComGameStateHistory History;
	local array<XComGameState_Reward> Rewards;
	local X2StrategyElementTemplateManager StratMgr;
	local X2RewardTemplate RewardTemplate, RewardTemplateIntel;
	local XComGameState_Reward RewardState, RewardStateIntel;
	local XComGameState_HeadquartersXCom XComHQ;
	local int SuppliesToAdd;
	local bool bFound;

	bFound = false;
	SuppliesToAdd = 0;
	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	if(XComHQ.IsObjectiveCompleted('T1_M4_S1_StudyCodexBrainPt1'))
	{
		SuppliesToAdd = GetPsiGateForgeSupplyAdd();
	}

	foreach NewGameState.IterateByClassType(class'XComGameState_MissionSite', MissionState)
	{
		if(MissionState.Source == 'MissionSource_Forge')
		{
			MissionState.Available = true;
			bFound = true;
			break;
		}
	}

	if(!bFound)
	{
		foreach History.IterateByClassType(class'XComGameState_MissionSite', MissionState)
		{
			if(MissionState.Source == 'MissionSource_Forge')
			{
				MissionState = XComGameState_MissionSite(NewGameState.ModifyStateObject(class'XComGameState_MissionSite', MissionState.ObjectID));
				MissionState.Available = true;
				bFound = true;
				break;
			}
		}
	}

	if(bFound)
	{
		// Flag the region to update its shortest path to a player-contacted region, used for region link display states
		RegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(MissionState.Region.ObjectID));

		if(RegionState == none)
		{
			RegionState = XComGameState_WorldRegion(NewGameState.ModifyStateObject(class'XComGameState_WorldRegion', MissionState.Region.ObjectID));
		}
		
		RegionState.SetShortestPathToContactRegion(NewGameState);

		if(SuppliesToAdd != 0)
		{
			RewardState = XComGameState_Reward(NewGameState.GetGameStateForObjectID(MissionState.Rewards[0].ObjectID));

			if(RewardState == none)
			{
				RewardState = XComGameState_Reward(NewGameState.ModifyStateObject(class'XComGameState_Reward', MissionState.Rewards[0].ObjectID));
			}

			RewardState.SetReward(, (GetPsiGateForgeSupplyAmount() + SuppliesToAdd));
		}
	}
	else
	{
		// Should only reach this point on very old saves
		StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
		RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_Supplies'));
		RewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
		RewardState.SetReward(, (GetPsiGateForgeSupplyAmount() + SuppliesToAdd));
		Rewards.AddItem(RewardState);

		RewardTemplateIntel = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_Intel'));
		RewardStateIntel = RewardTemplateIntel.CreateInstanceFromTemplate(NewGameState);
		RewardStateIntel.SetReward(, default.FORGE_INTEL);
		Rewards.AddItem(RewardStateIntel);

		CreateMission(NewGameState, Rewards, 'MissionSource_Forge', 1);
	}
}
static function X2DataTemplate CreateT4_M1_CompleteStargateMissionTemplate_LW()
{
	local X2ObjectiveTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ObjectiveTemplate', Template, 'T4_M1_CompleteStargateMission');
	Template.bMainObjective = true;
	Template.ImagePath = "img:///UILibrary_StrategyImages.X2StrategyMap.Alert_PsiGate";

	Template.NextObjectives.AddItem('T4_M2_ConstructPsiGate');

	Template.AssignObjectiveFn = CreateStargateMission_LW;
	Template.CompletionRequirements.RequiredItems.AddItem('PsiGateArtifact');
	Template.CompletionEvent = 'PostMissionDone';
	
	Template.NagDelayHours = 336;

	Template.AddNarrativeTrigger("X2NarrativeMoments.TACTICAL.goldenpath.GP_FirstPsiGateAppears_Tygan", NAW_OnReveal, 'PsiGateSeen', '', ELD_OnStateSubmitted, NPC_Once, '');

	return Template;
}


static function CreateStargateMission_LW(XComGameState NewGameState, XComGameState_Objective ObjectiveState)
{
	local XComGameState_MissionSite MissionState;
	local XComGameState_WorldRegion RegionState;
	local XComGameStateHistory History;
	local array<XComGameState_Reward> Rewards;
	local X2StrategyElementTemplateManager StratMgr;
	local X2RewardTemplate RewardTemplate, RewardTemplateIntel;
	local XComGameState_Reward RewardState, RewardStateIntel;
	local XComGameState_HeadquartersXCom XComHQ;
	local int SuppliesToAdd;
	local bool bFound;

	bFound = false;
	SuppliesToAdd = 0;
	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	if(XComHQ.IsObjectiveCompleted('T2_M2_StudyBlacksiteData'))
	{
		SuppliesToAdd = GetPsiGateForgeSupplyAdd();
	}

	foreach NewGameState.IterateByClassType(class'XComGameState_MissionSite', MissionState)
	{
		if(MissionState.Source == 'MissionSource_PsiGate')
		{
			MissionState.Available = true;
			bFound = true;
			break;
		}
	}

	if(!bFound)
	{
		foreach History.IterateByClassType(class'XComGameState_MissionSite', MissionState)
		{
			if(MissionState.Source == 'MissionSource_PsiGate')
			{
				MissionState = XComGameState_MissionSite(NewGameState.ModifyStateObject(class'XComGameState_MissionSite', MissionState.ObjectID));
				MissionState.Available = true;
				bFound = true;
				break;
			}
		}
	}

	if(bFound)
	{
		// Flag the region to update its shortest path to a player-contacted region, used for region link display states
		RegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(MissionState.Region.ObjectID));

		if(RegionState == none)
		{
			RegionState = XComGameState_WorldRegion(NewGameState.ModifyStateObject(class'XComGameState_WorldRegion', MissionState.Region.ObjectID));
		}

		RegionState.SetShortestPathToContactRegion(NewGameState);

		if(SuppliesToAdd != 0)
		{
			RewardState = XComGameState_Reward(NewGameState.GetGameStateForObjectID(MissionState.Rewards[0].ObjectID));

			if(RewardState == none)
			{
				RewardState = XComGameState_Reward(NewGameState.ModifyStateObject(class'XComGameState_Reward', MissionState.Rewards[0].ObjectID));
			}

			RewardState.SetReward(, (GetPsiGateForgeSupplyAmount() + SuppliesToAdd));
		}
	}
	else
	{
		// Should only reach this point on very old saves
		StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
		RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_Supplies'));
		RewardState = RewardTemplate.CreateInstanceFromTemplate(NewGameState);
		RewardState.SetReward(, (GetPsiGateForgeSupplyAmount() + SuppliesToAdd));
		Rewards.AddItem(RewardState);

		RewardTemplateIntel = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_Intel'));
		RewardStateIntel = RewardTemplateIntel.CreateInstanceFromTemplate(NewGameState);
		RewardStateIntel.SetReward(, default.PSIGATE_INTEL);
		Rewards.AddItem(RewardStateIntel);


		CreateMission(NewGameState, Rewards, 'MissionSource_PsiGate', 1);
	}
}