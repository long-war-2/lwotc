class X2StrategyElement_NewTechs_LW extends X2StrategyElement_DefaultTechs config(GameData);

var config int RENDER_REWARD_ELERIUM_CORE;
var config int RENDER_REWARD_SECTOID_CORPSE;
var config int RENDER_REWARD_VIPER_CORPSE;
var config int RENDER_REWARD_MUTON_CORPSE; 
var config int RENDER_REWARD_BERSERKER_CORPSE;
var config int RENDER_REWARD_ARCHON_CORPSE;
var config int RENDER_REWARD_GATEKEEPER_CORPSE;
var config int RENDER_REWARD_ANDROMEDON_CORPSE;
var config int RENDER_REWARD_FACELESS_CORPSE;
var config int RENDER_REWARD_CHRYSSALID_CORPSE;
var config int RENDER_REWARD_ADVENTTROOPER_CORPSE;
var config int RENDER_REWARD_ADVENTSTUNLANCER_CORPSE;
var config int RENDER_REWARD_ADVENTSHIELDBEARER_CORPSE;
var config int RENDER_REWARD_MEC_WRECK;
var config int RENDER_REWARD_TURRET_WRECK;
var config int RENDER_REWARD_SECTOPOD_WRECK;
var config int RENDER_REWARD_ADVENTOFFICER_CORPSE;
var config int RENDER_REWARD_DRONE_WRECK;
var config int RENDER_REWARD_MUTONELITE_CORPSE;
var config int RENDER_REWARD_ADVENTPRIEST_CORPSE;
var config int RENDER_REWARD_ADVENTPURIFIER_CORPSE;
var config int RENDER_REWARD_SPECTRE_CORPSE;

var config int BASIC_RESEARCH_SCIENCE_BONUS;
var config int BASIC_RESEARCH_ENGINEERING_BONUS;
var config int REPEAT_BASIC_RESEARCH_INCREASE;
var config int REPEAT_BASIC_ENGINEERING_INCREASE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Techs;

	`LWTrace("  >> X2StrategyElement_NewTechs_LW.CreateTemplates()");
	
	//New LW Overhaul techs
	Techs.AddItem(CreateLaserWeaponsTemplate());
	Techs.AddItem(CreateAdvancedLaserWeaponsTemplate());
	Techs.AddItem(CreateCoilgunsTemplate());
	Techs.AddItem(CreateAdvancedCoilgunsTemplate());
	Techs.AddItem(CreateAutopsyDroneTemplate());
	Techs.AddItem(CreateAutopsyBlutonTemplate());

	Techs.AddItem(CreateBasicResearchTemplate());
	Techs.AddItem(CreateBasicEngineeringTemplate());

	Techs.AddItem(CreateRenderTech ('RenderEleriumCore', "img:///UILibrary_StrategyImages.ScienceIcons.IC_Elerium", 'EleriumCore', 500, 'HybridMaterials'));
	Techs.AddItem(CreateRenderTech ('RenderSectoidCorpse', "img:///UILibrary_StrategyImages.ScienceIcons.IC_AutopsySectoid", 'CorpseSectoid', 600, 'AlienBiotech'));
	Techs.AddItem(CreateRenderTech ('RenderViperCorpse', "img:///UILibrary_StrategyImages.ScienceIcons.IC_AutopsyViper", 'CorpseViper', 600, 'AlienBiotech'));
	Techs.AddItem(CreateRenderTech ('RenderMutonCorpse', "img:///UILibrary_StrategyImages.ScienceIcons.IC_AutopsyMuton", 'CorpseMuton', 600, 'AlienBiotech'));
	Techs.AddItem(CreateRenderTech ('RenderBerserkerCorpse', "img:///UILibrary_StrategyImages.ScienceIcons.IC_AutopsyBerserker", 'CorpseBerserker', 600, 'AlienBiotech'));
	Techs.AddItem(CreateRenderTech ('RenderArchonCorpse', "img:///UILibrary_StrategyImages.ScienceIcons.IC_AutopsyArchon", 'CorpseArchon', 650, 'AlienBiotech'));
	Techs.AddItem(CreateRenderTech ('RenderGatekeeperCorpse', "img:///UILibrary_StrategyImages.ScienceIcons.IC_AutopsyGatekeeper", 'CorpseGatekeeper', 1000, 'AlienBiotech', 'EleriumCore'));
	Techs.AddItem(CreateRenderTech ('RenderAndromedonCorpse', "img:///UILibrary_StrategyImages.ScienceIcons.IC_AutopsyAndromedon", 'CorpseAndromedon', 800, 'AlienBiotech', 'EleriumCore'));
	Techs.AddItem(CreateRenderTech ('RenderFacelessCorpse', "img:///UILibrary_StrategyImages.ScienceIcons.IC_AutopsyFaceless", 'CorpseFaceless', 600, 'AlienBiotech'));
	Techs.AddItem(CreateRenderTech ('RenderChryssalidCorpse', "img:///UILibrary_StrategyImages.ScienceIcons.IC_AutopsyCryssalid", 'CorpseChryssalid', 600, 'AlienBiotech')); 
	Techs.AddItem(CreateRenderTech ('RenderAdventTrooperCorpse', "img:///UILibrary_StrategyImages.ScienceIcons.IC_AutopsyAdventTrooper", 'CorpseAdventTrooper', 500, 'AlienBiotech'));
	Techs.AddItem(CreateRenderTech ('RenderAdventStunLancerCorpse', "img:///UILibrary_StrategyImages.ScienceIcons.IC_AutopsyAdventStunLancer", 'CorpseAdventStunLancer', 500, 'AlienBiotech'));
	Techs.AddItem(CreateRenderTech ('RenderAdventShieldbearerCorpse', "img:///UILibrary_StrategyImages.ScienceIcons.IC_AutopsyAdventShieldbearer", 'CorpseAdventShieldbearer', 500, 'AlienBiotech'));
	Techs.AddItem(CreateRenderTech ('RenderMECWreck', "img:///UILibrary_StrategyImages.ScienceIcons.IC_AutopsyMEC", 'CorpseAdventMEC', 600, 'HybridMaterials'));
	Techs.AddItem(CreateRenderTech ('RenderTurretWreck', "img:///UILibrary_StrategyImages.ScienceIcons.IC_AutopsyAdventTurret", 'CorpseAdventTurret', 500, 'HybridMaterials'));
	Techs.AddItem(CreateRenderTech ('RenderSectopodWreck', "img:///UILibrary_StrategyImages.ScienceIcons.IC_AutopsySextopod", 'CorpseSectopod', 1200, 'HybridMaterials', 'EleriumCore'));
	Techs.AddItem(CreateRenderTech ('RenderAdventOfficerCorpse', "img:///UILibrary_StrategyImages.ResearchTech.GOLDTECH_Advent_Officer", 'CorpseAdventOfficer', 500, 'AlienBiotech'));
	Techs.AddItem(CreateRenderTech ('RenderAdventPriestCorpse', "img:///UILibrary_XPACK_StrategyImages.IC_Priest", 'CorpseAdventPriest', 600, 'AlienBiotech'));
	Techs.AddItem(CreateRenderTech ('RenderAdventPurifierCorpse', "img:///UILibrary_XPACK_StrategyImages.IC_Purifier", 'CorpseAdventPurifier', 600, 'AlienBiotech'));
	Techs.AddItem(CreateRenderTech ('RenderSpectreCorpse', "img:///UILibrary_XPACK_StrategyImages.IC_Spectre", 'CorpseSpectre', 600, 'AlienBiotech'));

	Techs.AddItem(CreateRenderTech ('RenderAdventDroneWreck', "img:///UILibrary_LW_Overhaul.LW_IC_AutopsyDrone", 'CorpseDrone', 300, 'HybridMaterials'));
	Techs.AddItem(CreateRenderTech ('RenderBlutonCorpse', "img:///UILibrary_LW_Overhaul.IC_AutopsyBluton", 'CorpseMutonElite', 700, 'AlienBiotech'));

	//O so many LW Overhaul Proving Grounds Projects
	Techs.AddItem(CreateHazMatVestProjectTemplate());
	Techs.AddItem(CreatePlatedVestProjectTemplate());
	Techs.AddItem(CreateStasisVestProjectTemplate());
	Techs.AddItem(CreateHellweaveProjectTemplate());
	Techs.AddItem(CreateAlloyPlatingProjectTemplate());
	Techs.AddItem(CreateChameleonSuitProjectTemplate());
	Techs.AddItem(CreateCarapacePlatingProjectTemplate());

	Techs.AddItem(CreateChitinPlatingProjectTemplate());
//	Techs.AddItem(CreateAPRoundsProjectTemplate());
	Techs.AddItem(CreateStilettoRoundsProjectTemplate());
	Techs.AddItem(CreateTalonRoundsProjectTemplate());
	Techs.AddItem(CreateFlechetteRoundsProjectTemplate());
	Techs.AddItem(CreateFalconRoundsProjectTemplate());
//	Techs.AddItem(CreateTracerRoundsProjectTemplate());
	Techs.AddItem(CreateVenomRoundsProjectTemplate());
	Techs.AddItem(CreateRedscreenRoundsProjectTemplate());
	Techs.AddItem(CreateNeedleRoundsProjectTemplate());
	Techs.AddItem(CreateDragonRoundsProjectTemplate());
	Techs.AddItem(CreateBluescreenRoundsProjectTemplate());
	Techs.AddItem(CreateBattleScannerProjectTemplate());
	Techs.AddItem(CreateIncendiaryGrenadeProjectTemplate());
	Techs.AddItem(CreateIncendiaryBombProjectTemplate());
	Techs.AddItem(CreateAcidGrenadeProjectTemplate());
	Techs.AddItem(CreateAcidBombProjectTemplate());
	Techs.AddItem(CreateEMPGrenadeProjectTemplate());
	Techs.AddItem(CreateEMPBombProjectTemplate());
	Techs.AddItem(CreateGasGrenadeProjectTemplate());
	Techs.AddItem(CreateGasBombProjectTemplate());
	Techs.AddItem(CreateSmokeBombProjectTemplate());
	Techs.AddItem(CreateProximityMineProjectTemplate());
	Techs.AddItem(CreateMimicBeaconProjectTemplate());
	Techs.AddItem(CreateShredstormProjectTemplate());
	Techs.AddItem(CreatePlasmaBlasterProjectTemplate());
	Techs.AddItem(CreateBasicScopeProjectTemplate());
	Techs.AddItem(CreateAdvancedScopeProjectTemplate());
	Techs.AddItem(CreateSuperiorScopeProjectTemplate());
	Techs.AddItem(CreateBasicLaserSightProjectTemplate());
	Techs.AddItem(CreateAdvancedLaserSightProjectTemplate());
	Techs.AddItem(CreateSuperiorLaserSightProjectTemplate());
	Techs.AddItem(CreateBasicStockProjectTemplate());
	Techs.AddItem(CreateAdvancedStockProjectTemplate());
	Techs.AddItem(CreateSuperiorStockProjectTemplate());
	Techs.AddItem(CreateBasicClipSizeProjectTemplate());
	Techs.AddItem(CreateAdvancedClipSizeProjectTemplate());
	Techs.AddItem(CreateSuperiorClipSizeProjectTemplate());
	Techs.AddItem(CreateBasicHairTriggerProjectTemplate());
	Techs.AddItem(CreateAdvancedHairTriggerProjectTemplate());
	Techs.AddItem(CreateSuperiorHairTriggerProjectTemplate());
	Techs.AddItem(CreateBasicAutoMagProjectTemplate());
	Techs.AddItem(CreateAdvancedAutoMagProjectTemplate());
	Techs.AddItem(CreateSuperiorAutoMagProjectTemplate());
	Techs.AddItem(CreateBasicSuppressorProjectTemplate());
	Techs.AddItem(CreateAdvancedSuppressorProjectTemplate());
	Techs.AddItem(CreateSuperiorSuppressorProjectTemplate());

	return Techs;
}


static function X2DataTemplate CreateLaserWeaponsTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'LaserWeapons');
	Template.PointsToComplete = 5000;
	Template.SortingTier = 1;
	Template.strImage = "img:///UILibrary_LW_LaserPack.TECH_LaserWeapons"; 

	Template.Requirements.RequiredTechs.AddItem('ModularWeapons');
	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 10;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateAdvancedLaserWeaponsTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'AdvancedLasers');
	Template.PointsToComplete = 5000;
	Template.SortingTier = 1;
	Template.Requirements.RequiredTechs.AddItem('LaserWeapons');
	Template.strImage = "img:///UILibrary_LW_LaserPack.TECH_AdvancedLaserWeapons"; 

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 10;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateCoilgunsTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'Coilguns');
	Template.PointsToComplete = 11000;
	Template.SortingTier = 1;
	Template.strImage = "img:///UILibrary_LW_Coilguns.TECH_CoilWeapons"; 
	
	Template.Requirements.RequiredTechs.AddItem('GaussWeapons');
	Template.Requirements.RequiredTechs.AddItem('Tech_Elerium');

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 15;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 15;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateAdvancedCoilgunsTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'AdvancedCoilguns');
	Template.PointsToComplete = 11000;
	Template.SortingTier = 1;
	Template.strImage = "img:///UILibrary_LW_Coilguns.TECH_AdvancedCoilWeapons"; 

	Template.Requirements.RequiredTechs.AddItem('Coilguns');

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 15;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = 15;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateAutopsyDroneTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'AutopsyDrone');
	Template.PointsToComplete = 3000;
	Template.SortingTier = 2;

	Template.strImage = "img:///UILibrary_LW_Overhaul.LW_IC_AutopsyDrone"; 
	Template.Requirements.RequiredScienceScore = 10;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventOfficer');
	
	// Instant Requirements. Will become the Cost if the tech is forced to Instant.
	Artifacts.ItemTemplateName = 'CorpseDrone';
	Artifacts.Quantity = 20;
	Template.InstantRequirements.RequiredItemQuantities.AddItem(Artifacts);

	// Cost
	Artifacts.ItemTemplateName = 'CorpseDrone';
	Artifacts.Quantity = 5;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	return Template;
}


static function X2DataTemplate CreateAutopsyBlutonTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'AutopsyMutonElite');
	Template.PointsToComplete = 4200;
	Template.SortingTier = 2;

	Template.TechStartedNarrative = "LWNarrativeMoments_Bink.Strategy.Autopsy_MutonM3_LW";

	Template.strImage = "img:///UILibrary_LW_Overhaul.IC_AutopsyBluton"; 
	Template.Requirements.RequiredScienceScore = 10;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	Template.Requirements.RequiredTechs.AddItem('AutopsyMuton');
	
	// Instant Requirements. Will become the Cost if the tech is forced to Instant.
	Artifacts.ItemTemplateName = 'CorpseMutonElite';
	Artifacts.Quantity = 15;
	Template.InstantRequirements.RequiredItemQuantities.AddItem(Artifacts);

	// Cost
	Artifacts.ItemTemplateName = 'CorpseMutonElite';
	Artifacts.Quantity = 3;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	return Template;
}

static function X2DataTemplate CreateRenderTech (name TechName, string strImage, name ItemName, int PointsToComplete, optional name ReqTech, optional name BonusItemName)
{
	local X2TechTemplate Template;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, TechName);
	Template.PointsToComplete = PointsToComplete;
	Template.RepeatPointsIncrease = 0;
	Template.SortingTier = 3;
	Template.bRepeatable = true;

	Template.Requirements.bVisibleIfTechsNotMet = false;
	Template.Requirements.bVisibleIfItemsNotMet = false;

	Template.strImage = strImage;
	if (ReqTech != '')
		Template.Requirements.RequiredTechs.AddItem(ReqTech);

	Template.Requirements.RequiredItems.AddItem(ItemName);

	Artifacts.ItemTemplateName = ItemName;
	Artifacts.Quantity = 1;

	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	if (BonusItemName != '')
		Template.ItemRewards.AddItem (BonusItemName);

	Template.ResearchCompletedFn = RenderTechCompleted;

	return Template;
}


function RenderTechCompleted(XComGameState NewGameState, XComGameState_Tech TechState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local string Techname;
	local name RewardType;
	local int RewardAmount, TechID;
	local X2ItemTemplateManager ItemTemplateManager;
	local X2ItemTemplate ItemTemplate;

	History = `XCOMHISTORY;

	foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersXCom', XComHQ)
	{
		break;
	}

	if(XComHQ == none)
	{
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
		XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
		NewGameState.AddStateObject(XComHQ);
	}

	TechName = string(TechState.GetMyTemplateName());

	switch (TechName)
	{
		case "RenderEleriumCore":				RewardType = 'EleriumDust'; RewardAmount = default.RENDER_REWARD_ELERIUM_CORE; break;
		case "RenderSectoidCorpse":				RewardType = 'AlienAlloy';	RewardAmount = default.RENDER_REWARD_SECTOID_CORPSE; break;
		case "RenderViperCorpse":				RewardType = 'AlienAlloy'; 	RewardAmount = default.RENDER_REWARD_VIPER_CORPSE; break;
		case "RenderMutonCorpse":				RewardType = 'AlienAlloy'; 	RewardAmount = default.RENDER_REWARD_MUTON_CORPSE; break;
		case "RenderBerserkerCorpse":			RewardType = 'AlienAlloy'; 	RewardAmount = default.RENDER_REWARD_BERSERKER_CORPSE; break;
		case "RenderArchonCorpse":				RewardType = 'EleriumDust';	RewardAmount = default.RENDER_REWARD_ARCHON_CORPSE; break;
		case "RenderGatekeeperCorpse":			RewardType = 'AlienAlloy'; 	RewardAmount = default.RENDER_REWARD_GATEKEEPER_CORPSE; break;
		case "RenderAndromedonCorpse":			RewardType = 'AlienAlloy'; 	RewardAmount = default.RENDER_REWARD_ANDROMEDON_CORPSE; break;
		case "RenderFacelessCorpse":			RewardType = 'EleriumDust';	RewardAmount = default.RENDER_REWARD_FACELESS_CORPSE; break;
		case "RenderChryssalidCorpse":			RewardType = 'AlienAlloy'; 	RewardAmount = default.RENDER_REWARD_CHRYSSALID_CORPSE; break;
		case "RenderAdventTrooperCorpse":		RewardType = 'AlienAlloy'; 	RewardAmount = default.RENDER_REWARD_ADVENTTROOPER_CORPSE; break;
		case "RenderAdventStunLancerCorpse":	RewardType = 'AlienAlloy'; 	RewardAmount = default.RENDER_REWARD_ADVENTSTUNLANCER_CORPSE; break;
		case "RenderAdventShieldbearerCorpse":	RewardType = 'AlienAlloy'; 	RewardAmount = default.RENDER_REWARD_ADVENTSHIELDBEARER_CORPSE; break;
		case "RenderMECWreck":					RewardType = 'AlienAlloy'; 	RewardAmount = default.RENDER_REWARD_MEC_WRECK; break;
		case "RenderTurretWreck":				RewardType = 'AlienAlloy'; 	RewardAmount = default.RENDER_REWARD_TURRET_WRECK; break;
		case "RenderSectopodWreck":				RewardType = 'AlienAlloy'; 	RewardAmount = default.RENDER_REWARD_SECTOPOD_WRECK; break;
		case "RenderAdventOfficerCorpse":		RewardType = 'AlienAlloy'; 	RewardAmount = default.RENDER_REWARD_ADVENTOFFICER_CORPSE; break;
		case "RenderAdventDroneWreck":			RewardType = 'AlienAlloy'; 	RewardAmount = default.RENDER_REWARD_DRONE_WRECK; break;
		case "RenderBlutonCorpse":				RewardType = 'AlienAlloy'; 	RewardAmount = default.RENDER_REWARD_MUTONELITE_CORPSE; break;
		case "RenderAdventPriestCorpse":		RewardType = 'AlienAlloy'; 	RewardAmount = default.RENDER_REWARD_ADVENTPRIEST_CORPSE; break;
		case "RenderAdventPurifierCorpse":		RewardType = 'AlienAlloy'; 	RewardAmount = default.RENDER_REWARD_ADVENTPURIFIER_CORPSE; break;
		case "RenderSpectreCorpse":				RewardType = 'EleriumDust'; RewardAmount = default.RENDER_REWARD_SPECTRE_CORPSE; break;

		default: break;
	}

	TechID = TechState.ObjectID;
	TechState = XComGameState_Tech(NewGameState.GetGameStateForObjectID(TechID));

	if(TechState == none)
	{
		TechState = XComGameState_Tech(NewGameState.CreateStateObject(class'XComGameState_Tech', TechID));
		NewGameState.AddStateObject(TechState);
	}

	// Contrary to its name
	TechState.IntelReward = RewardAmount;
	XCOMHQ.AddResource(NewGameState, RewardType, RewardAmount);

	if (TechState.GetMyTemplate().ItemRewards.length > 0)
	{
		`LWTRACE("ITEM REWARD HIT");

		ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
		ItemTemplate = ItemTemplateManager.FindItemTemplate(TechState.GetMyTemplate().ItemRewards[TechState.GetMyTemplate().ItemRewards.length-1]);
		class'XComGameState_HeadquartersXCom'.static.GiveItem(NewGameState, ItemTemplate);
		TechState.ItemRewards.AddItem(ItemTemplate);
		TechState.bSeenResearchCompleteScreen = false;
	}
}

static function X2DataTemplate CreateBasicResearchTemplate()
{
	local X2TechTemplate Template;
	
	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'BasicResearchProject');
	Template.SortingTier = 4;

	Template.bProvingGround = false;
	Template.PointsToComplete = 5400;
    Template.RepeatPointsIncrease = default.REPEAT_BASIC_RESEARCH_INCREASE;
    Template.bRepeatable = true;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.IC_Alien_Encryption";
	Template.ResearchCompletedFn = BasicResearchCompleted;
	return Template;
}


function BasicResearchCompleted(XComGameState NewGameState, XComGameState_Tech TechState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	History = `XCOMHISTORY;

	foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersXCom', XComHQ)
	{
		break;
	}
	if(XComHQ == none)
	{
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
		XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
		NewGameState.AddStateObject(XComHQ);
	}	
	XComHQ.BonusScienceScore += default.BASIC_RESEARCH_SCIENCE_BONUS;
}

static function X2DataTemplate CreateBasicEngineeringTemplate()
{
	local X2TechTemplate Template;
	
	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'BasicEngineeringProject');
	Template.SortingTier = 4;

	Template.bProvingGround = false;
	Template.PointsToComplete = 5400;
    Template.RepeatPointsIncrease = default.REPEAT_BASIC_ENGINEERING_INCREASE;
    Template.bRepeatable = true;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Bluescreen_Project";
	Template.ResearchCompletedFn = BasicEngineeringCompleted;
	return Template;
}


function BasicEngineeringCompleted(XComGameState NewGameState, XComGameState_Tech TechState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	History = `XCOMHISTORY;

	foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersXCom', XComHQ)
	{
		break;
	}
	if(XComHQ == none)
	{
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
		XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
		NewGameState.AddStateObject(XComHQ);
	}	
	XComHQ.BonusEngineeringScore += default.BASIC_RESEARCH_ENGINEERING_BONUS;
}



// **** PROVING GROUNDS ****

static function X2DataTemplate CreateHazMatVestProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'HazmatVestProject');
	Template.SortingTier = 2;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_ExperimentalArmor";
	Template.bProvingGround = true;
	Template.bArmor = true;


	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventTrooper');
	
	Template.Requirements.RequiredItems.AddItem('CorpseAdventTrooper');
	Resources.ItemTemplateName='CorpseAdventTrooper';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.ItemRewards.AddItem('HazmatVest');

	return Template;
}

static function X2DataTemplate CreatePlatedVestProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'PlatedVestProject');
	Template.SortingTier = 2;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_ExperimentalArmor";
	Template.bProvingGround = true;
	Template.bArmor = true;
	Template.PointsToComplete = StafferXDays(1, 20);

	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');
	Template.Requirements.RequiredTechs.AddItem('AutopsyMuton');
	
	Template.Requirements.RequiredItems.AddItem('CorpseMuton');
	Resources.ItemTemplateName='CorpseMuton';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName='AlienAlloy';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);


	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.ItemRewards.AddItem('PlatedVest');

	return Template;
}

static function X2DataTemplate CreateStasisVestProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'StasisVestProject');
	Template.SortingTier = 2;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_ExperimentalArmor";
	Template.bProvingGround = true;
	Template.bArmor = true;
	Template.PointsToComplete = StafferXDays(1, 25);

	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');
	Template.Requirements.RequiredTechs.AddItem('AutopsyGatekeeper');
	
	Template.Requirements.RequiredItems.AddItem('CorpseGatekeeper');
	Resources.ItemTemplateName='CorpseGatekeeper';
	Resources.Quantity = 3;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName='EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName='AlienAlloy';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);


	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.ItemRewards.AddItem('StasisVest');

	return Template;
}

static function X2DataTemplate CreateHellweaveProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'HellweaveProject');
	Template.SortingTier = 2;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_ExperimentalArmor";
	Template.bProvingGround = true;
	Template.bArmor = true;
	Template.PointsToComplete = StafferXDays(1, 15);

	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');
	Template.Requirements.RequiredTechs.AddItem('AutopsyBerserker');
	
	Template.Requirements.RequiredItems.AddItem('CorpseBerserker');
	Resources.ItemTemplateName='CorpseBerserker';
	Resources.Quantity = 3;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName='EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName='AlienAlloy';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.ItemRewards.AddItem('Hellweave');

	return Template;
}

static function X2DataTemplate CreateAlloyPlatingProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'AlloyPlatingProject');
	Template.SortingTier = 2;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_ExperimentalArmor";
	Template.bProvingGround = true;
	Template.bArmor = true;
	Template.PointsToComplete = StafferXDays(1, 15);

	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventStunLancer');
	
	Template.Requirements.RequiredItems.AddItem('CorpseAdventStunLancer');
	Resources.ItemTemplateName='CorpseAdventStunLancer';
	Resources.Quantity = 3;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName='AlienAlloy';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.ItemRewards.AddItem('AlloyPlating');

	return Template;
}

static function X2DataTemplate CreateChameleonSuitProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'ChameleonSuitProject');
	Template.SortingTier = 2;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_ExperimentalArmor";
	Template.bProvingGround = true;
	Template.bArmor = true;
	Template.PointsToComplete = StafferXDays(1, 15);

	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');
	Template.Requirements.RequiredTechs.AddItem('AutopsyFaceless');
	
	Template.Requirements.RequiredItems.AddItem('CorpseFaceless');
	Resources.ItemTemplateName='CorpseFaceless';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName='AlienAlloy';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.ItemRewards.AddItem('ChameleonSuit');

	return Template;
}

static function X2DataTemplate CreateCarapacePlatingProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'CarapacePlatingProject');
	Template.SortingTier = 2;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_ExperimentalArmor";
	Template.bProvingGround = true;
	Template.bArmor = true;
	Template.PointsToComplete = StafferXDays(1, 20);

	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventShieldbearer');
	
	Template.Requirements.RequiredItems.AddItem('CorpseAdventShieldBearer');
	Resources.ItemTemplateName='CorpseAdventShieldBearer';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName='AlienAlloy';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.ItemRewards.AddItem('CarapacePlating');

	return Template;
}

static function X2DataTemplate CreateChitinPlatingProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'ChitinPlatingProject');
	Template.SortingTier = 2;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_ExperimentalArmor";
	Template.bProvingGround = true;
	Template.bArmor = true;
	Template.PointsToComplete = StafferXDays(1, 25);

	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');
	Template.Requirements.RequiredTechs.AddItem('AutopsyChryssalid');
	
	Template.Requirements.RequiredItems.AddItem('CorpseChryssalid');
	Resources.ItemTemplateName='CorpseChryssalid';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName='AlienAlloy';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.ItemRewards.AddItem('ChitinPlating');

	return Template;
}

// Experimental Ammos

static function X2DataTemplate CreateAPRoundsProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'APRoundsProject');
	Template.SortingTier =3;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Experimental_Ammo";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 20);

	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');
	Template.Requirements.RequiredTechs.AddItem('AutopsyAndromedon');
	
	Template.Requirements.RequiredItems.AddItem('CorpseAndromedon');
	Resources.ItemTemplateName='CorpseAndromedon';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName='AlienAlloy';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.ItemRewards.AddItem('APRounds');

	return Template;
}


static function X2DataTemplate CreateStilettoRoundsProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'StilettoRoundsProject');
	Template.SortingTier =3;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Experimental_Ammo";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 15);

	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');
	Template.Requirements.RequiredTechs.AddItem('AutopsyFaceless');
	
	Template.Requirements.RequiredItems.AddItem('CorpseFaceless');
	Resources.ItemTemplateName='CorpseFaceless';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName='AlienAlloy';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.ItemRewards.AddItem('StilettoRounds');

	return Template;
}


static function X2DataTemplate CreateTalonRoundsProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'TalonRoundsProject');
	Template.SortingTier =3;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Experimental_Ammo";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 20);

	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventShieldbearer');
	
	Template.Requirements.RequiredItems.AddItem('CorpseAdventShieldbearer');
	Resources.ItemTemplateName='CorpseAdventShieldbearer';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName='AlienAlloy';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.ItemRewards.AddItem('TalonRounds');

	return Template;
}

static function X2DataTemplate CreateFlechetteRoundsProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'FlechetteRoundsProject');
	Template.SortingTier =3;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Experimental_Ammo";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 20);

	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventShieldbearer');
	
	Template.Requirements.RequiredItems.AddItem('CorpseAdventShieldbearer');
	Resources.ItemTemplateName='CorpseAdventShieldbearer';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName='AlienAlloy';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.ItemRewards.AddItem('FlechetteRounds');

	return Template;
}

// These are shredder rounds ingame
static function X2DataTemplate CreateFalconRoundsProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'FalconRoundsProject');
	Template.SortingTier =3;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Experimental_Ammo";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 20);

	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');
	Template.Requirements.RequiredTechs.AddItem('AutopsyArchon');
	
	Template.Requirements.RequiredItems.AddItem('CorpseArchon');
	Resources.ItemTemplateName='CorpseArchon';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName='AlienAlloy';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.ItemRewards.AddItem('FalconRounds');

	return Template;
}

static function X2DataTemplate CreateTracerRoundsProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'TracerRoundsProject');
	Template.SortingTier =3;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Experimental_Ammo";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 15);

	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventTurret');
	
	Template.Requirements.RequiredItems.AddItem('CorpseAdventTurret');
	Resources.ItemTemplateName='CorpseAdventTurret';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName='AlienAlloy';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.ItemRewards.AddItem('TracerRounds');

	return Template;
}

static function X2DataTemplate CreateVenomRoundsProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'VenomRoundsProject');
	Template.SortingTier =3;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Experimental_Ammo";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 20);

	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');
	Template.Requirements.RequiredTechs.AddItem('AutopsyViper');
	
	Template.Requirements.RequiredItems.AddItem('CorpseViper');
	Resources.ItemTemplateName='CorpseViper';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName='AlienAlloy';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.ItemRewards.AddItem('VenomRounds');

	return Template;
}

static function X2DataTemplate CreateRedscreenRoundsProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'RedscreenRoundsProject');
	Template.SortingTier =3;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Experimental_Ammo";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 25);

	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');
	Template.Requirements.RequiredTechs.AddItem('AutopsyDrone');
	
	Template.Requirements.RequiredItems.AddItem('CorpseDrone');
	Resources.ItemTemplateName='CorpseDrone';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName='AlienAlloy';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.ItemRewards.AddItem('RedscreenRounds');

	return Template;
}

static function X2DataTemplate CreateNeedleRoundsProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'NeedleRoundsProject');
	Template.SortingTier =3;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Experimental_Ammo";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 20);

	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventTrooper');
	
	Template.Requirements.RequiredItems.AddItem('CorpseAdventTrooper');
	Resources.ItemTemplateName='CorpseAdventTrooper';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName='AlienAlloy';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.ItemRewards.AddItem('NeedleRounds');

	return Template;
}

static function X2DataTemplate CreateDragonRoundsProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'DragonRoundsProject');
	Template.SortingTier =3;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Experimental_Ammo";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 20);

	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');
	Template.Requirements.RequiredTechs.AddItem('AutopsyMuton');
	
	Template.Requirements.RequiredItems.AddItem('CorpseMuton');
	Resources.ItemTemplateName='CorpseMuton';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName='EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName='AlienAlloy';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.ItemRewards.AddItem('IncendiaryRounds');

	return Template;
}

static function X2DataTemplate CreateBluescreenRoundsProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'BluescreenRoundsProject');
	Template.SortingTier =3;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Experimental_Ammo";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 30);

	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');
	Template.Requirements.RequiredTechs.AddItem('Bluescreen');
	
	Template.Requirements.RequiredItems.AddItem('CorpseAdventMec');
	Resources.ItemTemplateName='CorpseAdventMec';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName='EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName='AlienAlloy';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.ItemRewards.AddItem('BluescreenRounds');

	return Template;
}

static function X2DataTemplate CreateBattleScannerProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'BattlescannerProject');
	Template.SortingTier = 4;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Experimental_Grenade";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 15);

	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');
	Template.Requirements.RequiredTechs.AddItem('AutopsyDrone');
	
	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName='AlienAlloy';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.ItemRewards.AddItem('Battlescanner');

	return Template;
}

static function X2DataTemplate CreateIncendiaryGrenadeProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'IncendiaryGrenadeProject');
	Template.SortingTier = 4;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Experimental_Grenade";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 20);

	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');
	Template.Requirements.RequiredTechs.AddItem('AutopsyArchon');
	
	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName='AlienAlloy';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.ItemRewards.AddItem('Firebomb');

	return Template;
}

static function X2DataTemplate CreateIncendiaryBombProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'IncendiaryBombProject');
	Template.SortingTier =4;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Experimental_Grenade";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 20);

	Template.Requirements.RequiredTechs.AddItem('AdvancedGrenades');
	Template.Requirements.RequiredTechs.AddItem('IncendiaryGrenadeProject');
	
	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName='AlienAlloy';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.ItemRewards.AddItem('FirebombMk2');

	return Template;
}

static function X2DataTemplate CreateAcidGrenadeProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'AcidGrenadeProject');
	Template.SortingTier =4;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Experimental_Grenade";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 20);

	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');
	Template.Requirements.RequiredTechs.AddItem('AutopsyAndromedon');
	
	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName='AlienAlloy';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.ItemRewards.AddItem('AcidGrenade');

	return Template;
}

static function X2DataTemplate CreateAcidBombProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'AcidBombProject');
	Template.SortingTier =4;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Experimental_Grenade";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 20);

	Template.Requirements.RequiredTechs.AddItem('AdvancedGrenades');
	Template.Requirements.RequiredTechs.AddItem('AcidGrenadeProject');
	
	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName='AlienAlloy';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.ItemRewards.AddItem('AcidBomb');

	return Template;
}


static function X2DataTemplate CreateEMPGrenadeProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'EMPGrenadeProject');
	Template.SortingTier =4;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Experimental_Grenade";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 20);

	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');
	Template.Requirements.RequiredTechs.AddItem('Bluescreen');
	
	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName='AlienAlloy';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.ItemRewards.AddItem('EMPGrenade');

	return Template;
}

static function X2DataTemplate CreateEMPBombProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'EMPBombProject');
	Template.SortingTier =4;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Experimental_Grenade";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 20);

	Template.Requirements.RequiredTechs.AddItem('AdvancedGrenades');
	Template.Requirements.RequiredTechs.AddItem('EMPGrenadeProject');
	
	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName='AlienAlloy';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.ItemRewards.AddItem('EMPBomb');

	return Template;
}

static function X2DataTemplate CreateGasGrenadeProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'GasGrenadeProject');
	Template.SortingTier =4;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Experimental_Grenade";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 20);

	Template.Requirements.RequiredTechs.AddItem('HybridMaterials');
	Template.Requirements.RequiredTechs.AddItem('AutopsyViper');
	
	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName='AlienAlloy';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.ItemRewards.AddItem('GasGrenade');

	return Template;
}

static function X2DataTemplate CreateGasBombProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'GasBombProject');
	Template.SortingTier =4;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Experimental_Grenade";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 20);

	Template.Requirements.RequiredTechs.AddItem('AdvancedGrenades');
	Template.Requirements.RequiredTechs.AddItem('GasGrenadeProject');
	
	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName='AlienAlloy';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.ItemRewards.AddItem('GasBomb');

	return Template;
}

static function X2DataTemplate CreateSmokeBombProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'SmokeBombProject');
	Template.SortingTier =4;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Experimental_Grenade";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 15);

	Template.Requirements.RequiredTechs.AddItem('AdvancedGrenades');
	
	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName='AlienAlloy';
	Resources.Quantity = 1;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.ItemRewards.AddItem('SmokeBomb');

	return Template;
}

static function X2DataTemplate CreateProximityMineProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'ProximityMineProject');
	Template.SortingTier =4;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Experimental_Grenade";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 25);

	Template.Requirements.RequiredTechs.AddItem('AdvancedGrenades');
	Template.Requirements.RequiredTechs.AddItem('SectopodAutopsy');

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 2;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName='AlienAlloy';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.ItemRewards.AddItem('ProximityMine');

	return Template;
}

static function X2DataTemplate CreateMimicBeaconProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'MimicBeaconProject');
	Template.SortingTier =4;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Experimental_Grenade";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 30);

	Template.Requirements.RequiredTechs.AddItem('AdvancedGrenades');
	Template.Requirements.RequiredTechs.AddItem('PsiGate');

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 2;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName='AlienAlloy';
	Resources.Quantity = 5;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.ItemRewards.AddItem('MimicBeacon');

	return Template;
}


static function X2DataTemplate CreateShredstormProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'ShredstormCannonProject');
	Template.SortingTier = 5;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Heavy_Weapons_Project";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 30);

	Template.Requirements.RequiredTechs.AddItem('AutopsySectopod');
	Template.Requirements.RequiredTechs.AddItem('AdvancedCoilguns');
	Template.Requirements.RequiredTechs.AddItem('WARSuit');
	Template.Requirements.RequiredItems.AddItem('CorpseSectopod');

	Resources.ItemTemplateName = 'CorpseSectopod';
	Resources.Quantity = 3;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 5;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName='AlienAlloy';
	Resources.Quantity = 30;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.ItemRewards.AddItem('ShredstormCannon');

	return Template;
}


static function X2DataTemplate CreatePlasmaBlasterProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'PlasmaBlasterProject');
	Template.SortingTier = 5;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_AdvHeavy_Weapons_Project";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 30);

	Template.Requirements.RequiredTechs.AddItem('PlasmaRifle');
	Template.Requirements.RequiredTechs.AddItem('EXOSuit');

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 2;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName='AlienAlloy';
	Resources.Quantity = 20;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.ResearchCompletedFn = GiveRandomItemReward;
	Template.ItemRewards.AddItem('PlasmaBlaster');

	return Template;
}

static function X2DataTemplate CreateBasicScopeProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	
	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'BasicScopeProject');
	Template.SortingTier = 6;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Modular_Weapons";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 15);	
	
	Template.Requirements.RequiredItems.AddItem('AimUpgrade_Bsc');
	Template.Requirements.RequiredTechs.AddItem('ModularWeapons');
	
	Resources.ItemTemplateName = 'AimUpgrade_Bsc';
	Resources.Quantity = 3;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateAdvancedScopeProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	
	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'AdvancedScopeProject');
	Template.SortingTier = 6;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Modular_Weapons";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 20);	

	Template.Requirements.RequiredItems.AddItem('AimUpgrade_Adv');
	Template.Requirements.RequiredTechs.AddItem('BasicScopeProject');

	Resources.ItemTemplateName = 'AimUpgrade_Adv';
	Resources.Quantity = 3;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateSuperiorScopeProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	
	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'SuperiorScopeProject');
	Template.SortingTier = 6;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Modular_Weapons";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 25);	

	Template.Requirements.RequiredItems.AddItem('AimUpgrade_Sup');
	Template.Requirements.RequiredTechs.AddItem('AdvancedScopeProject');

	Resources.ItemTemplateName = 'AimUpgrade_Sup';
	Resources.Quantity = 3;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	return Template;
}


static function X2DataTemplate CreateBasicLaserSightProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	
	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'BasicLaserSightProject');
	Template.SortingTier = 6;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Modular_Weapons";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 15);	

	Template.Requirements.RequiredItems.AddItem('CritUpgrade_Bsc');
	Template.Requirements.RequiredTechs.AddItem('ModularWeapons');

	Resources.ItemTemplateName = 'CritUpgrade_Bsc';
	Resources.Quantity = 3;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateAdvancedLaserSightProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	
	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'AdvancedLaserSightProject');
	Template.SortingTier = 6;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Modular_Weapons";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 20);	

	Template.Requirements.RequiredItems.AddItem('CritUpgrade_Adv');
	Template.Requirements.RequiredTechs.AddItem('BasicLaserSightProject');

	Resources.ItemTemplateName = 'CritUpgrade_Adv';
	Resources.Quantity = 3;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateSuperiorLaserSightProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	
	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'SuperiorLaserSightProject');
	Template.SortingTier = 6;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Modular_Weapons";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 25);	

	Template.Requirements.RequiredItems.AddItem('CritUpgrade_Sup');
	Template.Requirements.RequiredTechs.AddItem('AdvancedLaserSightProject');

	Resources.ItemTemplateName = 'CritUpgrade_Sup';
	Resources.Quantity = 3;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	return Template;
}


static function X2DataTemplate CreateBasicStockProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	
	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'BasicStockProject');
	Template.SortingTier = 6;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Modular_Weapons";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 15);	

	Template.Requirements.RequiredItems.AddItem('MissDamageUpgrade_Bsc');
	Template.Requirements.RequiredTechs.AddItem('ModularWeapons');

	Resources.ItemTemplateName = 'MissDamageUpgrade_Bsc';
	Resources.Quantity = 3;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateAdvancedStockProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	
	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'AdvancedStockProject');
	Template.SortingTier = 6;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Modular_Weapons";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 20);	

	Template.Requirements.RequiredItems.AddItem('MissDamageUpgrade_Adv');
	Template.Requirements.RequiredTechs.AddItem('BasicStockProject');

	Resources.ItemTemplateName = 'MissDamageUpgrade_Adv';
	Resources.Quantity = 3;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateSuperiorStockProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	
	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'SuperiorStockProject');
	Template.SortingTier = 6;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Modular_Weapons";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 25);	

	Template.Requirements.RequiredItems.AddItem('MissDamageUpgrade_Sup');
	Template.Requirements.RequiredTechs.AddItem('AdvancedStockProject');

	Resources.ItemTemplateName = 'MissDamageUpgrade_Sup';
	Resources.Quantity = 3;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	return Template;
}


static function X2DataTemplate CreateBasicClipSizeProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	
	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'BasicClipSizeProject');
	Template.SortingTier = 6;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Modular_Weapons";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 15);	

	Template.Requirements.RequiredItems.AddItem('ClipSizeUpgrade_Bsc');
	Template.Requirements.RequiredTechs.AddItem('ModularWeapons');

	Resources.ItemTemplateName = 'ClipSizeUpgrade_Bsc';
	Resources.Quantity = 3;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateAdvancedClipSizeProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	
	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'AdvancedClipSizeProject');
	Template.SortingTier = 6;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Modular_Weapons";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 20);	

	Template.Requirements.RequiredItems.AddItem('ClipSizeUpgrade_Adv');
	Template.Requirements.RequiredTechs.AddItem('BasicClipSizeProject');

	Resources.ItemTemplateName = 'ClipSizeUpgrade_Adv';
	Resources.Quantity = 3;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateSuperiorClipSizeProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	
	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'SuperiorClipSizeProject');
	Template.SortingTier = 6;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Modular_Weapons";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 25);	

	Template.Requirements.RequiredItems.AddItem('ClipSizeUpgrade_Sup');
	Template.Requirements.RequiredTechs.AddItem('AdvancedClipSizeProject');

	Resources.ItemTemplateName = 'ClipSizeUpgrade_Sup';
	Resources.Quantity = 3;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	return Template;
}


static function X2DataTemplate CreateBasicHairTriggerProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	
	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'BasicHairTriggerProject');
	Template.SortingTier = 6;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Modular_Weapons";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 15);	

	Template.Requirements.RequiredItems.AddItem('FreeFireUpgrade_Bsc');
	Template.Requirements.RequiredTechs.AddItem('ModularWeapons');

	Resources.ItemTemplateName = 'FreeFireUpgrade_Bsc';
	Resources.Quantity = 3;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateAdvancedHairTriggerProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	
	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'AdvancedHairTriggerProject');
	Template.SortingTier = 6;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Modular_Weapons";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 20);	

	Template.Requirements.RequiredItems.AddItem('FreeFireUpgrade_Adv');
	Template.Requirements.RequiredTechs.AddItem('BasicHairTriggerProject');

	Resources.ItemTemplateName = 'FreeFireUpgrade_Adv';
	Resources.Quantity = 3;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateSuperiorHairTriggerProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	
	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'SuperiorHairTriggerProject');
	Template.SortingTier = 6;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Modular_Weapons";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 25);	

	Template.Requirements.RequiredItems.AddItem('FreeFireUpgrade_Sup');
	Template.Requirements.RequiredTechs.AddItem('AdvancedHairTriggerProject');

	Resources.ItemTemplateName = 'FreeFireUpgrade_Sup';
	Resources.Quantity = 3;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	return Template;
}


static function X2DataTemplate CreateBasicAutoMagProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	
	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'BasicAutoMagProject');
	Template.SortingTier = 6;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Modular_Weapons";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 15);	

	Template.Requirements.RequiredItems.AddItem('ReloadUpgrade_Bsc');
	Template.Requirements.RequiredTechs.AddItem('ModularWeapons');

	Resources.ItemTemplateName = 'ReloadUpgrade_Bsc';
	Resources.Quantity = 3;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateAdvancedAutoMagProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	
	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'AdvancedAutoMagProject');
	Template.SortingTier = 6;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Modular_Weapons";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 20);	

	Template.Requirements.RequiredItems.AddItem('ReloadUpgrade_Adv');
	Template.Requirements.RequiredTechs.AddItem('BasicAutoMagProject');

	Resources.ItemTemplateName = 'ReloadUpgrade_Adv';
	Resources.Quantity = 3;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateSuperiorAutoMagProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	
	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'SuperiorAutoMagProject');
	Template.SortingTier = 6;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Modular_Weapons";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 25);	

	Template.Requirements.RequiredItems.AddItem('ReloadUpgrade_Sup');
	Template.Requirements.RequiredTechs.AddItem('AdvancedAutoMagProject');

	Resources.ItemTemplateName = 'ReloadUpgrade_Sup';
	Resources.Quantity = 3;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	return Template;
}


static function X2DataTemplate CreateBasicSuppressorProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	
	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'BasicSuppressorProject');
	Template.SortingTier = 6;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Modular_Weapons";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 15);	

	Template.Requirements.RequiredItems.AddItem('FreeKillUpgrade_Bsc');
	Template.Requirements.RequiredTechs.AddItem('ModularWeapons');

	Resources.ItemTemplateName = 'FreeKillUpgrade_Bsc';
	Resources.Quantity = 3;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateAdvancedSuppressorProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	
	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'AdvancedSuppressorProject');
	Template.SortingTier = 6;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Modular_Weapons";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 20);	

	Template.Requirements.RequiredTechs.AddItem('BasicSuppressorProject');
	Template.Requirements.RequiredItems.AddItem('FreeKillUpgrade_Adv');

	Resources.ItemTemplateName = 'FreeKillUpgrade_Adv';
	Resources.Quantity = 3;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateSuperiorSuppressorProjectTemplate()
{
	local X2TechTemplate Template;
	local ArtifactCost Resources;
	
	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'SuperiorSuppressorProject');
	Template.SortingTier = 6;
	Template.strImage = "img:///UILibrary_StrategyImages.ResearchTech.TECH_Modular_Weapons";
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, 25);	

	Template.Requirements.RequiredTechs.AddItem('AdvancedSuppressorProject');
	Template.Requirements.RequiredItems.AddItem('FreeKillUpgrade_Sup');

	Resources.ItemTemplateName = 'FreeKillUpgrade_Sup';
	Resources.Quantity = 3;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'EleriumCore';
	Resources.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Resources);

	return Template;
}
