//---------------------------------------------------------------------------------------
//  FILE:    LWTemplateMods
//  AUTHOR:  tracktwo / Pavonis Interactive
//
//  PURPOSE: Mods to base XCOM2 templates
//--------------------------------------------------------------------------------------- 

class LWTemplateMods extends X2StrategyElement config(LW_Overhaul);

struct ItemTableEntry
{
	var name ItemTemplateName;
	var int Slots;
	var bool Starting;
	var bool Infinite;
	var bool Buildable;
	var name RequiredTech1;
	var name RequiredTech2;
	var int SupplyCost;
	var int AlloyCost;
	var int CrystalCost;
	var int CoreCost;
	var name SpecialItemTemplateName;
	var int SpecialItemCost;
	var int TradingPostValue;
	var int RequiredEngineeringScore;
	var int PointsToComplete;
	var int Weight;
	var int Tier;
	var string InventoryImage;
	
	structdefaultproperties
	{
		ItemTemplateName=None
		Slots=3
		Starting=false
		Infinite=false
		Buildable=false
		RequiredTech1=none
		RequiredTech2=none
		SupplyCost=0
		AlloyCost=0
		CrystalCost=0
		CoreCost=0
		SpecialItemTemplateName=None
		SpecialItemCost=0
		TradingPostValue=0
		RequiredEngineeringScore=0
		PointsToComplete=0
		Weight = 0
		Tier = -1
		InventoryImage = ""
	}
};

struct TechTableEntry
{
	var name TechTemplateName;
	var bool ProvingGround;
	var int ResearchPointCost;
	var bool ModPointsToCompleteOnly;
	var name PrereqTech1;
	var name PrereqTech2;
	var name PrereqTech3;
	var int SupplyCost;
	var int AlloyCost;
	var int CrystalCost;
	var int CoreCost;
	var name ReqItemTemplateName1;
	var int ReqItemCost1;
	var name ReqItemTemplateName2;
	var int ReqItemCost2;
	var name ItemGranted;
	var int RequiredScienceScore;
	var int RequiredEngineeringScore;

	structdefaultproperties
	{
		TechTemplateName=None
		ProvingGround=false
		ResearchPointCost=0
		ModPointsToCompleteOnly=true
		PrereqTech1=None
		PrereqTech2=None
		PrereqTech3=None
		SupplyCost=0
		AlloyCost=0
		CrystalCost=0
		CoreCost=0
		ReqItemTemplateName1=None
		ReqItemCost1=0
		ReqItemTemplateName2=None
		ReqItemCost2=0
		ItemGranted=none
		RequiredScienceScore=0
		RequiredEngineeringScore=0
	}
};

struct GTSTableEntry
{
	var name    GTSProjectTemplateName;
	var int     SupplyCost;
	var int     RankRequired;
	var bool    HideifInsufficientRank;
	var name    UniqueClass;
	structdefaultproperties
	{
		GTSProjectTemplateName=None
		SupplyCost=0
		RankRequired=0
		HideifInsufficientRank=false
		UniqueClass=none
	}
};

struct FacilityTableEntry
{
	var name FacilityTemplateName;
	var int BuildDays;
	var int Power;
	var int UpkeepCost;
	var name RequiredTech;
	var int SupplyCost;
	var int AlloyCost;
	var int CrystalCost;
	var int CoreCost;
	structdefaultproperties
	{
		FacilityTemplateName=none
		BuildDays=1
		Power=0
		UpkeepCost=0
		RequiredTech=none
		SupplyCost=0
		AlloyCost=0
		CrystalCost=0
		CoreCost=0
	}
};

struct FacilityUpgradeTableEntry
{
	var name FacilityUpgradeTemplateName;
	var int PointsToComplete;
	var int iPower;
	var int UpkeepCost;
	var int SupplyCost;
	var int AlloyCost;
	var int CrystalCost;
	var int CoreCost;
	var name RequiredTech;
	var name ReqItemTemplateName1;
	var int ReqItemCost1;
	var name ReqItemTemplateName2;
	var int ReqItemCost2;
	var int MaxBuild;
	var int RequiredEngineeringScore;
	var int RequiredScienceScore;
	structdefaultproperties
	{
		FacilityUpgradeTemplateName=none
		PointsToComplete=0
		iPower=0
		UpkeepCost=0
		SupplyCost=0
		AlloyCost=0
		CrystalCost=0
		CoreCost=0
		RequiredTech=none
		ReqItemTemplateName1=None
		ReqItemCost1=0
		ReqItemTemplateName2=None
		ReqItemCost2=0
		MaxBuild=1
		RequiredEngineeringScore=0
		RequiredScienceScore=0
	}
};

struct DamageStep
{
	var float DistanceRatio;
	var float DamageRatio;
};

struct FlashbangResistEntry
{
	var name UnitName;
	var int Chance;
};

var config int SPIDER_GRAPPLE_COOLDOWN;
var config int WRAITH_GRAPPLE_COOLDOWN;
var config int RAPIDFIRE_COOLDOWN;
var config int MEDIUM_PLATED_MITIGATION_AMOUNT;
var config int SHIELDWALL_MITIGATION_AMOUNT;
var config int SHIELDWALL_DEFENSE_AMOUNT;
var config int HAIL_OF_BULLETS_AMMO_COST;
var config int SATURATION_FIRE_AMMO_COST;
var config int DEMOLITION_AMMO_COST;
var config int THROW_GRENADE_COOLDOWN;
var config int AID_PROTOCOL_COOLDOWN;
var config int FUSE_COOLDOWN;
var config int INSANITY_MIND_CONTROL_DURATION;
var config bool INSANITY_ENDS_TURN;
var config int RUPTURE_CRIT_BONUS;
var config int FACEOFF_CHARGES;
var config int DRAGON_ROUNDS_APPLY_CHANCE;
var config int VENOM_ROUNDS_APPLY_CHANCE;
var config int FIREBOMB_FIRE_APPLY_CHANCE;
var config int FIREBOMB_2_FIRE_APPLY_CHANCE;
var config int CONCEAL_ACTION_POINTS;
var config bool CONCEAL_ENDS_TURN;
var config int SERIAL_CRIT_MALUS_PER_KILL;
var config int SERIAL_AIM_MALUS_PER_KILL;
var config bool SERIAL_DAMAGE_FALLOFF;
var config int FUSION_SWORD_FIRE_CHANCE;

var config array<ItemTableEntry> ItemTable;
var config array<TechTableEntry> TechTable;
var config array<GTSTableEntry> GTSTable;
var config array<FacilityTableEntry> FacilityTable;
var config array<FacilityUpgradeTableEntry> FacilityUpgradeTable;

var config int ResistanceCommunicationsIntelCost;
var config int ResistanceRadioIntelCost;
var config int AlienEncryptionIntelCost;
var config int CodexBrainPt1IntelCost;
var config int CodexBrainPt2IntelCost;
var config int BlacksiteDataIntelCost;
var config int ForgeStasisSuitIntelCost;
var config int PsiGateIntelCost;
var config int AutopsyAdventPsiWitchIntelCost;
var config int ALIEN_FACILITY_LEAD_RP_INCREMENT;
var config int ALIEN_FACILITY_LEAD_INTEL;

var config array<name> SchematicsToPreserve;

var config array<name> UnlimitedItemsAdded;

var config bool EARLY_TURRET_SQUADSIGHT;
var config bool MID_TURRET_SQUADSIGHT;
var config bool LATE_TURRET_SQUADSIGHT;

var config bool EXPLOSIVES_NUKE_CORPSES;

var config float CIVILIAN_PANIC_RANGE;

var config array<float> UnitDistanceRatios;
var config array<float> UnitDamageRatios;

var config array<float> EnvironmentDistanceRatios;
var config array<float> EnvironmentDamageRatios;

var config array<DamageStep> UnitDamageSteps;
var config array<DamageStep> EnvironmentDamageSteps;

var config array<name> ExplosiveFalloffAbility_Exclusions;
var config array<name> ExplosiveFalloffAbility_Inclusions;

var config array<float> AWCHealingBonus;

var config int ALIEN_RULER_ACTION_BONUS_APPLY_CHANCE;

var config bool USE_ACTION_ICON_COLORS;

var config string ICON_COLOR_OBJECTIVE;
var config string ICON_COLOR_PSIONIC_2;
var config string ICON_COLOR_PSIONIC_END;
var config string ICON_COLOR_PSIONIC_1;
var config string ICON_COLOR_PSIONIC_FREE;
var config string ICON_COLOR_COMMANDER_ALL;
var config string ICON_COLOR_2;
var config string ICON_COLOR_END;
var config string ICON_COLOR_1;
var config string ICON_COLOR_FREE;

var config int RESCOMMS_1ST_ENGINEER_BONUS;
var config int RESCOMMS_2ND_ENGINEER_BONUS;

var config int SMALL_INTEL_CACHE_REWARD;
var config int LARGE_INTEL_CACHE_REWARD;

var config bool INSTANT_BUILD_TIMES;

var config array<Name> OffensiveReflexAbilities;
var config array<Name> DefensiveReflexAbilities;
var config array<Name> DoubleTapAbilities;

var config array<FlashbangResistEntry> ENEMY_FLASHBANG_RESIST;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	`LWTrace("LWTemplateMods.CreateTemplates --------------------------------");

	Templates.AddItem(CreateDelayedEvacTemplate());
	Templates.Additem(CreateReconfigGearTemplate());
	Templates.Additem(CreateRewireTechTreeTemplate());
	Templates.AddItem(CreateEditGTSProjectsTemplate());
	Templates.AddItem(CreateModifyAbilitiesTemplate());
	Templates.AddItem(CreateModifyAbilitiesGeneralTemplate());
	Templates.AddItem(CreateSwapExplosiveDamageFalloff());
	Templates.AddItem(CreateModifyGrenadeEffects());
	Templates.AddItem(CreateReconfigFacilitiesTemplate());
	Templates.AddItem(CreateReconfigStaffSlotsTemplate());
	Templates.AddItem(CreateRecoverItemTemplate());
	Templates.AddItem(CreateRemovePPClassesTemplate());
	Templates.AddItem(CreateUpdateQuestItemsTemplate());
	TEmplates.AddItem(CreateGeneralCharacterModTemplate());
	Templates.AddItem(CreateModifyDarkEventsTemplate());
	Templates.AddItem(CreateModifyPOIsTemplate());
	Templates.AddItem(CreateModifyHackRewardsTemplate());
	Templates.AddItem(CreateReconfigFacilityUpgradesTemplate());
	Templates.AddItem(CreateModifyStaffSlotsTemplate());
	Templates.AddItem(CreateModifyRewardsTemplate());
	Templates.AddItem(CreateModifyStrategyObjectivesTemplate());
	Templates.AddItem(CreateModifyCovertActionsTemplate());
	`Log("    Done");
	return Templates;
}

// Modify abilities to use graze band
static function X2LWTemplateModTemplate CreateModifyAbilitiesTemplate()
{
	local X2LWTemplateModTemplate Template;

	`CREATE_X2TEMPLATE(class'X2LWAbilitiesModTemplate', Template, 'UpdateAbilities');
	return Template;
}

// Update existing strategic objective templates
static function X2LWTemplateModTemplate CreateModifyStrategyObjectivesTemplate()
{
	local X2LWTemplateModTemplate Template;

	`CREATE_X2TEMPLATE(class'X2LWObjectivesModTemplate', Template, 'UpdateObjectives');
	return Template;
}

// Update existing strategic objective templates
static function X2LWTemplateModTemplate CreateModifyCovertActionsTemplate()
{
	local X2LWTemplateModTemplate Template;

	`CREATE_X2TEMPLATE(class'X2LWCovertActionsModTemplate', Template, 'UpdateCovertActions');
	return Template;
}

// Update StaffSlotTemplates as needed
static function X2LWTemplateModTemplate CreateModifyRewardsTemplate()
{
	local X2LWTemplateModTemplate Template;

	`CREATE_X2TEMPLATE(class'X2LWTemplateModTemplate', Template, 'UpdateRewards');

	// We need to modify grenade items and ability templates
	Template.StrategyElementTemplateModFn = UpdateRewardTemplate;
	return Template;
}

function GenerateRandomSoldierReward(XComGameState_Reward RewardState, XComGameState NewGameState, optional float RewardScalar = 1.0, optional StateObjectReference RegionRef)
{
	local XComGameState_HeadquartersResistance ResistanceHQ;
	local XComGameStateHistory History;
	local XComGameState_Unit NewUnitState;
	local XComGameState_WorldRegion RegionState;
	local int idx, NewRank;
	local name nmCountry, SelectedClass;
	local array<name> arrActiveTemplates;
	local X2SoldierClassTemplateManager ClassMgr;
	local array<X2SoldierClassTemplate> arrClassTemplates;
	local X2SoldierClassTemplate ClassTemplate;
	local XComGameState_HeadquartersAlien AlienHQ;

	History = `XCOMHISTORY;
	nmCountry = '';
	RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(RegionRef.ObjectID));

	if(RegionState != none)
	{
		nmCountry = RegionState.GetMyTemplate().GetRandomCountryInRegion();
	}

	//Use the character pool's creation method to retrieve a unit
	NewUnitState = `CHARACTERPOOLMGR.CreateCharacter(NewGameState, `XPROFILESETTINGS.Data.m_eCharPoolUsage, RewardState.GetMyTemplate().rewardObjectTemplateName, nmCountry);
	NewUnitState.RandomizeStats();
	NewGameState.AddStateObject(NewUnitState);

	ResistanceHQ = XComGameState_HeadquartersResistance(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));
	if(!NewGameState.GetContext().IsStartState())
	{
		ResistanceHQ = XComGameState_HeadquartersResistance(NewGameState.CreateStateObject(class'XComGameState_HeadquartersResistance', ResistanceHQ.ObjectID));
		NewGameState.AddStateObject(ResistanceHQ);
	}
	
	// Pick a random class
	ClassMgr = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();
	arrClassTemplates = ClassMgr.GetAllSoldierClassTemplates(true);
	foreach arrClassTemplates(ClassTemplate)
	{
		if (ClassTemplate.NuminDeck > 0)
		{
			arrActiveTemplates.AddItem(ClassTemplate.DataName);
		}
	}
	if (arrActiveTemplates.length > 0)
	{
		SelectedClass = arrActiveTemplates[`SYNC_RAND(arrActiveTemplates.length)];
	}
	else
	{
		SelectedClass = ResistanceHQ.SelectNextSoldierClass();
	}
	
	NewUnitState.ApplyInventoryLoadout(NewGameState);

	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	NewRank = 1;

	for(idx = 0; idx < class'X2StrategyElement_DefaultRewards'.default.SoldierRewardForceLevelGates.Length; idx++)
	{
		if(AlienHQ.GetForceLevel() >= class'X2StrategyElement_DefaultRewards'.default.SoldierRewardForceLevelGates[idx])
		{
			NewRank++;
		}
	}

	NewUnitState.SetXPForRank(NewRank);
	NewUnitState.StartingRank = NewRank;
	for(idx = 0; idx < NewRank; idx++)
	{
		// Rank up to squaddie
		if(idx == 0)
		{
			NewUnitState.RankUpSoldier(NewGameState, SelectedClass);
			NewUnitState.ApplySquaddieLoadout(NewGameState);
			NewUnitState.bNeedsNewClassPopup = false;
		}
		else
		{
			NewUnitState.RankUpSoldier(NewGameState, NewUnitState.GetSoldierClassTemplate().DataName);
		}
	}   
	RewardState.RewardObjectReference = NewUnitState.GetReference();
}

function UpdateRewardTemplate(X2StrategyElementTemplate Template, int Difficulty)
{
	local X2RewardTemplate RewardTemplate;

	RewardTemplate = X2RewardTemplate(Template);
	if(RewardTemplate == none)
		return;
	
	switch (RewardTemplate.DataName)
	{
		case 'Reward_FacilityLead':
			// change reward string delegate so it returns the template DisplayName
			RewardTemplate.GetRewardStringFn = class'X2StrategyElement_DefaultRewards'.static.GetMissionRewardString; 
			break;
		case 'Reward_Soldier':
			RewardTemplate.GenerateRewardFn = GenerateRandomSoldierReward;
			break;
		default:
			break;
	}
}

// Update StaffSlotTemplates as needed
static function X2LWTemplateModTemplate CreateModifyStaffSlotsTemplate()
{
	local X2LWTemplateModTemplate Template;

	`CREATE_X2TEMPLATE(class'X2LWTemplateModTemplate', Template, 'UpdateStaffSlots');

	// We need to modify grenade items and ability templates
	Template.StrategyElementTemplateModFn = UpdateStaffSlotTemplate;
	return Template;
}

function UpdateStaffSlotTemplate(X2StrategyElementTemplate Template, int Difficulty)
{
	local X2StaffSlotTemplate StaffSlotTemplate;

	StaffSlotTemplate = X2StaffSlotTemplate(Template);
	if(StaffSlotTemplate == none)
		return;
	
	/* WOTC TODO: Work out how to replace the AWC stuff
	switch (StaffSlotTemplate.DataName)
	{
		case 'AWCScientistStaffSlot':
			StaffSlotTemplate.GetContributionFromSkillFn = GetAWCContribution_LW;
			StaffSlotTemplate.FillFn = FillAWCSciSlot_LW;
			StaffSlotTemplate.EmptyFn = EmptyAWCSciSlot_LW;
			StaffSlotTemplate.GetAvengerBonusAmountFn = GetAWCAvengerBonus_LW;
			StaffSlotTemplate.GetBonusDisplayStringFn = GetAWCBonusDisplayString_LW;
			StaffSlotTemplate.MatineeSlotName = "Scientist";
			break;
		default:
			break;
	}
	*/
}

static function int GetAWCContribution_LW(XComGameState_Unit UnitState)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
	
	return class'X2StrategyElement_DefaultStaffSlots'.static.GetContributionDefault(UnitState) * (`ScaleGameLengthArrayInt(XComHQ.XComHeadquarters_BaseHealRates) / 5) * (default.AWCHealingBonus[`STRATEGYDIFFICULTYSETTING] / 100.0);
}

static function int GetAWCAvengerBonus_LW(XComGameState_Unit UnitState, optional bool bPreview)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local float PercentIncrease;

	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();

	// Need to return the percent increase in overall healing speed provided by this unit
	PercentIncrease = (GetAWCContribution_LW(UnitState) * 100.0) / (`ScaleGameLengthArrayInt(XComHQ.XComHeadquarters_BaseHealRates));

	return Round(PercentIncrease);
}

static function FillAWCSciSlot_LW(XComGameState NewGameState, StateObjectReference SlotRef, StaffUnitInfo UnitInfo)
{
	local XComGameState_HeadquartersXCom NewXComHQ;
	local XComGameState_Unit NewUnitState;
	local XComGameState_StaffSlot NewSlotState;

	class'X2StrategyElement_DefaultStaffSlots'.static.FillSlot(NewGameState, SlotRef, UnitInfo, NewSlotState, NewUnitState);
	NewXComHQ = class'X2StrategyElement_DefaultStaffSlots'.static.GetNewXComHQState(NewGameState);
	
	NewXComHQ.HealingRate += GetAWCContribution_LW(NewUnitState);
}

static function EmptyAWCSciSlot_LW(XComGameState NewGameState, StateObjectReference SlotRef)
{
	local XComGameState_HeadquartersXCom NewXComHQ;
	local XComGameState_StaffSlot NewSlotState;
	local XComGameState_Unit NewUnitState;

	class'X2StrategyElement_DefaultStaffSlots'.static.EmptySlot(NewGameState, SlotRef, NewSlotState, NewUnitState);
	NewXComHQ = class'X2StrategyElement_DefaultStaffSlots'.static.GetNewXComHQState(NewGameState);

	NewXComHQ.HealingRate -= GetAWCContribution_LW(NewUnitState);

	if (NewXComHQ.HealingRate < `ScaleGameLengthArrayInt(NewXComHQ.XComHeadquarters_BaseHealRates))
	{
		NewXComHQ.HealingRate = `ScaleGameLengthArrayInt(NewXComHQ.XComHeadquarters_BaseHealRates);
	}
}

static function string GetAWCBonusDisplayString_LW(XComGameState_StaffSlot SlotState, optional bool bPreview)
{
	local string Contribution;

	if (SlotState.IsSlotFilled())
	{
		Contribution = string(GetAWCAvengerBonus_LW(SlotState.GetAssignedStaff(), bPreview));
	}

	return class'X2StrategyElement_DefaultStaffSlots'.static.GetBonusDisplayString(SlotState, "%AVENGERBONUS", Contribution);
}

// Update QuestItemTemplates to include the new _LW MissionTypes
static function X2LWTemplateModTemplate CreateUpdateQuestItemsTemplate()
{
	local X2LWTemplateModTemplate Template;

	`CREATE_X2TEMPLATE(class'X2LWTemplateModTemplate', Template, 'UpdateQuestItems');

	// We need to modify grenade items and ability templates
	Template.ItemTemplateModFn = UpdateQuestItemsTemplate;
	return Template;
}

function UpdateQuestItemsTemplate(X2ItemTemplate Template, int Difficulty)
{
	local X2QuestItemTemplate QuestItemTemplate;
	local array<string> MissionTypes;
	local string MissionType;

	QuestItemTemplate = X2QuestItemTemplate(Template);
	if(QuestItemTemplate == none)
		return;
	
	MissionTypes = QuestItemTemplate.MissionType;
	foreach MissionTypes(MissionType)
	{
		QuestItemTemplate.MissionType.AddItem(MissionType $ "_LW");
	}
	if (QuestItemTemplate.RewardType.Length > 0)
		QuestItemTemplate.RewardType.AddItem('Reward_None');

	if (QuestItemTemplate.DataName == 'FlightDevice')
	{
		QuestItemTemplate.MissionSource.AddItem('MissionSource_RecoverFlightDevice'); // this will prevent FlightDevice from being selected for Activity-based missions - fixes TTP 335
	}
}

static function X2LWTemplateModTemplate CreateModifyGrenadeEffects()
{
	local X2LWTemplateModTemplate Template;

	`CREATE_X2TEMPLATE(class'X2LWTemplateModTemplate', Template, 'ModifyGrenadeEffects');

	// We need to modify grenade items and ability templates
	Template.ItemTemplateModFn = ModifyGrenadeEffects;
	return Template;
}


delegate name ResistFlashbang(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
	local int k;
	local XComGameState_Unit Target;

	Target = XComGameState_Unit(kNewTargetState);
	if (Target != none)
	{
		for (k = 0; k < default.ENEMY_FLASHBANG_RESIST.length; k++)
		{
			if (default.ENEMY_FLASHBANG_RESIST[k].UnitName == Target.GetMyTemplateName())
			{
				if (`SYNC_RAND(100) < default.ENEMY_FLASHBANG_RESIST[k].Chance)
				{
					return 'AA_EffectChanceFailed';
				}
			}
		}
	}
	return 'AA_Success';
}

// Modify grenade effects:
// Flashbangs and sting grenades get blue screen bombs effects (if the ability is
// present).
// Flashbangs, sting grenades, and advent grenadier flashbangs are not valid for
// volatile mix damage bonus (note: this damage bonus was from the original volatile
// mix, the damage bonus is now only applied to boosted cores).

function ModifyGrenadeEffects(X2ItemTemplate Template, int Difficulty)
{
	local X2GrenadeTemplate                             GrenadeTemplate;
	local int k;
	local X2Effect_Persistent                           Effect;

	GrenadeTemplate = X2GrenadeTemplate(Template);
	if(GrenadeTemplate == none)
		return;
	switch(GrenadeTemplate.DataName)
	{
		case 'FlashbangGrenade':
		case 'StingGrenade':
			GrenadeTemplate.ThrownGrenadeEffects.AddItem(class'X2Ability_LW_GrenadierAbilitySet'.static.CreateBluescreenBombsHackReductionEffect());
			GrenadeTemplate.ThrownGrenadeEffects.AddItem(class'X2Ability_LW_GrenadierAbilitySet'.static.CreateBluescreenBombsDisorientEffect());        
			GrenadeTemplate.LaunchedGrenadeEffects.AddItem(class'X2Ability_LW_GrenadierAbilitySet'.static.CreateBluescreenBombsHackReductionEffect());
			GrenadeTemplate.LaunchedGrenadeEffects.AddItem(class'X2Ability_LW_GrenadierAbilitySet'.static.CreateBluescreenBombsDisorientEffect());
			GrenadeTemplate.bAllowVolatileMix = false;

			for (k = 0; k < GrenadeTemplate.ThrownGrenadeEffects.Length; k++)
			{
				Effect = X2Effect_Persistent (GrenadeTemplate.ThrownGrenadeEffects[k]);
				if (Effect != none)
				{
					if (Effect.EffectName == class'X2AbilityTemplateManager'.default.DisorientedName)
					{
						GrenadeTemplate.ThrownGrenadeEffects[k].ApplyChanceFn = ResistFlashbang;
					}
				}
			}
			for (k = 0; k < GrenadeTemplate.LaunchedGrenadeEffects.Length; k++)
			{
				Effect = X2Effect_Persistent (GrenadeTemplate.LaunchedGrenadeEffects[k]);
				if (Effect != none)
				{
					if (Effect.EffectName == class'X2AbilityTemplateManager'.default.DisorientedName)
					{
						GrenadeTemplate.LaunchedGrenadeEffects[k].ApplyChanceFn = ResistFlashbang;
					}
				}
			}
			break;
		case 'AdvGrenadierFlashbangGrenade':
			for (k = 0; k < GrenadeTemplate.ThrownGrenadeEffects.Length; k++)
			{
				Effect = X2Effect_Persistent (GrenadeTemplate.ThrownGrenadeEffects[k]);
				if (Effect != none)
				{
					if (Effect.EffectName == class'X2AbilityTemplateManager'.default.DisorientedName)
					{
						GrenadeTemplate.ThrownGrenadeEffects[k].ApplyChanceFn = ResistFlashbang;
					}
				}
			}
			for (k = 0; k < GrenadeTemplate.LaunchedGrenadeEffects.Length; k++)
			{
				Effect = X2Effect_Persistent (GrenadeTemplate.LaunchedGrenadeEffects[k]);
				if (Effect != none)
				{
					if (Effect.EffectName == class'X2AbilityTemplateManager'.default.DisorientedName)
					{
						GrenadeTemplate.LaunchedGrenadeEffects[k].ApplyChanceFn = ResistFlashbang;
					}
				}
			}
			GrenadeTemplate.bAllowVolatileMix = false;
		default:
			break;
	}
}

// various small changes to vanilla abilities
static function X2LWTemplateModTemplate CreateModifyAbilitiesGeneralTemplate()
{
   local X2LWTemplateModTemplate Template;
   
   `CREATE_X2TEMPLATE(class'X2LWTemplateModTemplate', Template, 'ModifyAbilitiesGeneral');
   Template.AbilityTemplateModFn = ModifyAbilitiesGeneral;
   return Template;
}

static function string GetIconColorByActionPoints (X2AbilityTemplate Template)
{
	local int k, k2;
	local bool pass, found;
	local X2AbilityCost_ActionPoints        ActionPoints;
	local string AbilityIconColor;

	AbilityIconColor = "";
	for (k = 0; k < Template.AbilityCosts.Length; ++k)
	{   
		ActionPoints = X2AbilityCost_ActionPoints(Template.AbilityCosts[k]);
		if (ActionPoints != none)
		{
			Found = true;
			if (Template.AbilityIconColor == "53b45e") //Objective
			{
				AbilityIconColor = default.ICON_COLOR_OBJECTIVE; // orange
			} 
			else 
			{
				if (Template.AbilitySourceName == 'eAbilitySource_Psionic') 
				{
					if (ActionPoints.iNumPoints >= 2) 
					{
						AbilityIconColor = default.ICON_COLOR_PSIONIC_2;
					}
					else 
					{
						if (ActionPoints.bConsumeAllPoints) 
						{
							AbilityIconColor = default.ICON_COLOR_PSIONIC_END;
						} 
						else 
						{
							if (ActionPoints.iNumPoints == 1 && !ActionPoints.bFreeCost)
							{
								AbilityIconColor = default.ICON_COLOR_PSIONIC_1; // light lavender
							}
							else
							{   
								AbilityIconColor = default.ICON_COLOR_PSIONIC_FREE; // lavender-white
							}
						}
					}
				} 
				else 
				{
					if (ActionPoints.iNumPoints >= 2) 
					{
						AbilityIconColor = default.ICON_COLOR_2; // yellow
					}
					else 
					{
						if (ActionPoints.bConsumeAllPoints) 
						{
							AbilityIconColor = default.ICON_COLOR_END; // cyan
						} 
						else 
						{
							if (ActionPoints.iNumPoints == 1 && !ActionPoints.bFreeCost)
							{
								AbilityIconColor = default.ICON_COLOR_1; // white
							}
							else
							{
								AbilityIconColor = default.ICON_COLOR_FREE; //green
							}
						}
					}
				}
			}
			break;
		}
	}
	if (!found)
	{
		pass= false;
		for (k2 = 0; k2 < Template.AbilityTriggers.Length; k2++)
		{
		   if(Template.AbilityTriggers[k2].IsA('X2AbilityTrigger_PlayerInput'))
			{
				pass = true;
			}
		}
		if (pass)
		{
			if (Template.AbilitySourceName == 'eAbilitySource_Psionic') 
			{
				AbilityIconColor = default.ICON_COLOR_PSIONIC_FREE;
			}
			else
			{
				AbilityIconColor = default.ICON_COLOR_FREE;
			}
		}
	}
	return AbilityIconColor;
}

function ModifyAbilitiesGeneral(X2AbilityTemplate Template, int Difficulty)
{
	local X2Effect_PersistentStatChange     PersistentStatChangeEffect;
	local X2Condition_UnitEffects           UnitEffects;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2AbilityCharges_RevivalProtocol  RPCharges;
	local X2Condition_UnitInventory         InventoryCondition, InventoryCondition2;
	local X2Condition_UnitEffects           SuppressedCondition, UnitEffectsCondition, NotHaywiredCondition;
	local int                               k;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2EFfect_HuntersInstinctDamage_LW DamageModifier;
	local X2AbilityCooldown                 Cooldown;
	local X2AbilityCost_QuickdrawActionPoints_LW    QuickdrawActionPointCost;
	local X2Effect_Squadsight               Squadsight;
	local X2Effect_ToHitModifier            ToHitModifier;
	local X2Effect_Persistent               Effect, PersistentEffect, HaywiredEffect;
	local X2Effect_VolatileMix              MixEffect;
	local X2Effect_ModifyReactionFire       ReactionFire;
	local X2Effect_DamageImmunity           DamageImmunity;
	local X2Effect_HunkerDown_LW            HunkerDownEffect;
	local X2Effect_CancelLongRangePenalty   DFAEffect;
	local X2Condition_Visibility            VisibilityCondition, TargetVisibilityCondition;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	//local X2AbilityTarget_Single          PrimaryTarget;
	//local X2AbilityMultiTarget_Radius     RadiusMultiTarget;
	local X2Effect_SerialCritReduction      SerialCritReduction;
	local X2AbilityCharges                  Charges;
	local X2AbilityCost_Charges             ChargeCost;
	//local X2Effect_SoulSteal_LW           StealEffect;
	local X2Effect_Guardian_LW              GuardianEffect;
	local X2Effect                          ShotEffect;
	local X2Effect_MaybeApplyDirectionalWorldDamage WorldDamage;
	local X2Effect_DeathFromAbove_LW        DeathEffect;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;

	// WOTC TODO: Trying this out. Should be put somewhere more appropriate.
	if (Template.DataName == 'ReflexShotModifier')
	{
		`Log("TRACE: Using AbilityTemplateManager to get 'StandardShot'");
		Template.LocFriendlyName = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate('StandardShot').LocFriendlyName;
	}

	if (Template.DataName == 'CivilianPanicked')
	{
		FixCivilianPanicOnApproach(Template);
	}

	if (Template.DataName == 'Grapple')
	{
		Template.AbilityCooldown.iNumTurns = default.SPIDER_GRAPPLE_COOLDOWN;
	}
	if (Template.DataName == 'GrapplePowered')
	{
		Template.AbilityCooldown.iNumTurns = default.WRAITH_GRAPPLE_COOLDOWN;
	}
	if (Template.DataName == 'MediumPlatedArmorStats')
	{
		PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
		PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
		PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorChance, 100.0);
		PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorMitigation, float(default.MEDIUM_PLATED_MITIGATION_AMOUNT));
		Template.AddTargetEffect(PersistentStatChangeEffect);
	}
	//HighCoverGenerator()
	if (Template.DataName == 'HighCoverGenerator')
	{
		PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
		PersistentStatChangeEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
		PersistentStatChangeEffect.AddPersistentStatChange(eStat_Defense, default.SHIELDWALL_DEFENSE_AMOUNT);
		PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorChance, 100.0);
		PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorMitigation, default.SHIELDWALL_MITIGATION_AMOUNT);
		Template.AddShooterEffect (PersistentStatChangeEffect);
	}

	if (Template.DataName == 'HailofBullets')
	{
		InventoryCondition = new class'X2Condition_UnitInventory';
		InventoryCondition.RelevantSlot=eInvSlot_PrimaryWeapon;
		InventoryCondition.ExcludeWeaponCategory = 'shotgun';
		Template.AbilityShooterConditions.AddItem(InventoryCondition);
	
		InventoryCondition2 = new class'X2Condition_UnitInventory';
		InventoryCondition2.RelevantSlot=eInvSlot_PrimaryWeapon;
		InventoryCondition2.ExcludeWeaponCategory = 'sniper_rifle';
		Template.AbilityShooterConditions.AddItem(InventoryCondition2);

		for (k = 0; k < Template.AbilityCosts.length; k++)
		{
			AmmoCost = X2AbilityCost_Ammo(Template.AbilityCosts[k]);
			if (AmmoCost != none)
			{
				X2AbilityCost_Ammo(Template.AbilityCosts[k]).iAmmo = default.HAIL_OF_BULLETS_AMMO_COST;
			}
		}
	}

	if (Template.DataName == 'Demolition')
	{
		for (k = 0; k < Template.AbilityCosts.length; k++)
		{
			AmmoCost = X2AbilityCost_Ammo(Template.AbilityCosts[k]);
			if (AmmoCost != none)
			{
				X2AbilityCost_Ammo(Template.AbilityCosts[k]).iAmmo = default.DEMOLITION_AMMO_COST;
			}
		}
	}

	if (Template.DataName == 'InTheZone')
	{
		SerialCritReduction = new class 'X2Effect_SerialCritReduction';
		SerialCritReduction.BuildPersistentEffect(1, false, true, false, 8);
		SerialCritReduction.CritReductionPerKill = default.SERIAL_CRIT_MALUS_PER_KILL;
		SerialCritReduction.AimReductionPerKill = default.SERIAL_AIM_MALUS_PER_KILL;
		SerialCritReduction.Damage_Falloff = default.SERIAL_DAMAGE_FALLOFF;
		SerialCritReduction.SetDisplayInfo (ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true,, Template.AbilitySourceName);
		Template.AbilityTargetEffects.AddItem(SerialCritReduction);
	}

	// Disables the effect so they get full turns on alien turn
	if (Template.DataName == 'AlienRulerInitialState')
	{
		Template.AbilityTargetEffects.length = 0;
		DamageImmunity = new class'X2Effect_DamageImmunity';
		DamageImmunity.BuildPersistentEffect(1, true, true, true);
		DamageImmunity.ImmuneTypes.AddItem('Unconscious');
		DamageImmunity.EffectName = 'RulerImmunity';
		Template.AddTargetEffect(DamageImmunity);

		//Requires listeners set up so that "RULER REACTION" overlay gets removed
		Template.AddTargetEffect(new class'X2Effect_DLC2_HideSpecialTurnOverlay');
	}

	// Use alternate DFA effect so it's compatible with Double Tap 2, and add additional ability of canceling long-range sniper rifle penalty
	if (Template.DataName == 'DeathFromAbove')
	{
		Template.AbilityTargetEffects.Length = 0;
		DFAEffect = New class'X2Effect_CancelLongRangePenalty';
		DFAEffect.BuildPersistentEffect (1, true, false);
		DFAEffect.SetDisplayInfo (0, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, false,, Template.AbilitySourceName);
		Template.AddTargetEffect(DFAEffect);
		DeathEffect = new class'X2Effect_DeathFromAbove_LW';
		DeathEffect.BuildPersistentEffect(1, true, false, false);
		DeathEffect.SetDisplayInfo(0, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true,, Template.AbilitySourceName);
		Template.AddTargetEffect(DeathEffect);
	}

	// and partial turns only sometimes
	if (Template.DataName == 'AlienRulerActionSystem')
	{
		for (k = 0; k < Template.AbilityTargetEffects.length; k++)
		{
			if (Template.AbilityTargetEffects[k].IsA ('X2Effect_DLC_2RulerActionPoint'))
			{
				Template.AbilityTargetEffects[k].ApplyChance = default.ALIEN_RULER_ACTION_BONUS_APPLY_CHANCE;
			}
		}
	}

	if (Template.DataName == 'Insanity')
	{
		for (k = 0; k < Template.AbilityTargetEffects.length; k++)
		{
			if (Template.AbilityTargetEffects[k].IsA ('X2Effect_MindControl'))
			{
				X2Effect_MindControl(Template.AbilityTargetEffects[k]).iNumTurns = default.INSANITY_MIND_CONTROL_DURATION;
			}
		}
		for (k = 0; k < Template.AbilityCosts.length; k++)
		{
			ActionPointCost = X2AbilityCost_ActionPoints(Template.AbilityCosts[k]);
			if (ActionPointCost != none)
			{
				X2AbilityCost_ActionPoints(Template.AbilityCosts[k]).bConsumeAllPoints = default.INSANITY_ENDS_TURN;
			}
		}
	}

	if (Template.DataName == 'Fuse')
	{
		Template.PrerequisiteAbilities.AddItem ('Fortress');
	}

	if (Template.DataName == 'StasisShield')
	{
		Template.PrerequisiteAbilities.AddItem ('Fortress');
	}

	if (Template.DataName == 'Domination')
	{
		Template.PrerequisiteAbilities.AddItem ('Solace_LW');
		Template.PrerequisiteAbilities.AddItem ('Stasis');
	}

	if (Template.DataName == 'VoidRift')
	{
		Template.PrerequisiteAbilities.AddItem ('Fortress');
		Template.PrerequisiteAbilities.AddItem ('Solace_LW');
	}

	if (Template.DataName == 'NullLance')
	{
		Template.PrerequisiteAbilities.AddItem ('Stasis');
	}
	
	if (Template.DataName == 'PoisonSpit' || Template.DataName == 'MicroMissiles')
	{
		VisibilityCondition = new class'X2Condition_Visibility';
		VisibilityCondition.bVisibletoAnyAlly = true;
		VisibilityCondition.bAllowSquadsight = true;
		Template.AbilityTargetConditions.AddItem(VisibilityCondition);
		Template.AbilityMultiTargetConditions.AddItem(VisibilityCondition);
	}

	// should allow covering fire at micromissiles and ADVENT rockets
	if (Template.DataName == 'MicroMissiles' || Template.DataName == 'RocketLauncher')
	{
		Template.BuildInterruptGameStateFn = class'X2Ability'.static.TypicalAbility_BuildInterruptGameState;
	}

	if (Template.DataName == 'Stealth' && default.CONCEAL_ACTION_POINTS > 0)
	{
		for (k = 0; k < Template.AbilityCosts.length; k++)
		{
			ActionPointCost = X2AbilityCost_ActionPoints(Template.AbilityCosts[k]);
			if (ActionPointCost != none)
			{
				X2AbilityCost_ActionPoints(Template.AbilityCosts[k]).iNumPoints = default.CONCEAL_ACTION_POINTS;
				X2AbilityCost_ActionPoints(Template.AbilityCosts[k]).bConsumeAllPoints = default.CONCEAL_ENDS_TURN;
				X2AbilityCost_ActionPoints(Template.AbilityCosts[k]).bFreeCost = false;
			}
		}
	}

	// get rid of barfy screen shake on Berserker Rage
	if (Template.DataName == 'TriggerRage')
	{
		Template.CinescriptCameraType = "Archon_Frenzy";
	}

	// bugfix for Flashbangs doing damage
	if (Template.DataName == 'HuntersInstinct')
	{
		Template.AbilityTargetEffects.length = 0;
		DamageModifier = new class'X2Effect_HuntersInstinctDamage_LW';
		DamageModifier.BonusDamage = class'X2Ability_RangerAbilitySet'.default.INSTINCT_DMG;
		DamageModifier.BonusCritChance = class'X2Ability_RangerAbilitySet'.default.INSTINCT_CRIT;
		DamageModifier.BuildPersistentEffect(1, true, false, true);
		DamageModifier.SetDisplayInfo(0, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
		Template.AddTargetEffect(DamageModifier);
	}

	// bugfix for several vanilla perks being lost after bleeding out/revive
	if (Template.DataName == 'Squadsight')
	{
		Template.AbilityTargetEffects.length = 0;
		Squadsight = new class'X2Effect_Squadsight';
		Squadsight.BuildPersistentEffect(1, true, false, true);
		Squadsight.SetDisplayInfo(0, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,, Template.AbilitySourceName);
		Template.AddTargetEffect(Squadsight);
	}

	if (Template.DataName == 'HitWhereItHurts')
	{
		Template.AbilityTargetEffects.length = 0;
		ToHitModifier = new class'X2Effect_ToHitModifier';
		ToHitModifier.BuildPersistentEffect(1, true, false, true);
		ToHitModifier.SetDisplayInfo(0, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,, Template.AbilitySourceName);
		ToHitModifier.AddEffectHitModifier(1, class'X2Ability_SharpshooterAbilitySet'.default.HITWHEREITHURTS_CRIT, Template.LocFriendlyName,, false, true, true, true);
		Template.AddTargetEffect(ToHitModifier);
	}

	if (Template.DataName == 'HoloTargeting')
	{
		Template.AbilityTargetEffects.length = 0;
		PersistentEffect = new class'X2Effect_Persistent';
		PersistentEffect.BuildPersistentEffect(1, true, false);
		PersistentEffect.SetDisplayInfo(0, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true,, Template.AbilitySourceName);
		Template.AddTargetEffect(PersistentEffect);
	}

	if (Template.DataName == 'VolatileMix')
	{
		Template.AbilityTargetEffects.length = 0;
		MixEffect = new class'X2Effect_VolatileMix';
		MixEffect.BuildPersistentEffect(1, true, false, true);
		MixEffect.SetDisplayInfo(0, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,, Template.AbilitySourceName);
		MixEffect.BonusDamage = class'X2Ability_GrenadierAbilitySet'.default.VOLATILE_DAMAGE;
		Template.AddTargetEffect(MixEffect);
	}   
	
	if (Template.DataName == 'CoolUnderPressure')
	{
		Template.AbilityTargetEffects.length = 0;
		ReactionFire = new class'X2Effect_ModifyReactionFire';
		ReactionFire.bAllowCrit = true;
		ReactionFire.ReactionModifier = class'X2Ability_SpecialistAbilitySet'.default.UNDER_PRESSURE_BONUS;
		ReactionFire.BuildPersistentEffect(1, true, false, true);
		ReactionFire.SetDisplayInfo(0, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,, Template.AbilitySourceName);
		Template.AddTargetEffect(ReactionFire);
	}   

	if (Template.DataName == 'BulletShred')
	{
		StandardAim = new class'X2AbilityToHitCalc_StandardAim';
		StandardAim.bHitsAreCrits = false;
		StandardAim.BuiltInCritMod = default.RUPTURE_CRIT_BONUS;
		Template.AbilityToHitCalc = StandardAim;
		Template.AbilityToHitOwnerOnMissCalc = StandardAim;

		for (k = 0; k < Template.AbilityTargetConditions.Length; k++)
		{
			TargetVisibilityCondition = X2Condition_Visibility(Template.AbilityTargetConditions[k]);
			if (TargetVisibilityCondition != none)
			{
				// Allow rupture to work from SS
				TargetVisibilityCondition = new class'X2Condition_Visibility';
				TargetVisibilityCondition.bRequireGameplayVisible  = true;
				TargetVisibilityCondition.bAllowSquadsight = true;
				Template.AbilityTargetConditions[k] = TargetVisibilityCondition;
			}
		}
	}

	// Bump up skulljack damage, the default 20 will fail to kill advanced units
	// and glitches out the animations.
	if (Template.DataName == 'FinalizeSKULLJACK')
	{
		for (k = 0; k < Template.AbilityTargetEffects.Length; ++k)
		{
			WeaponDamageEffect = X2Effect_ApplyWeaponDamage(Template.AbilityTargetEffects[k]);
			if (WeaponDamageEffect != none)
			{
				WeaponDamageEffect.EffectDamageValue.Pierce = 99;
				WeaponDamageEffect.EffectDamageValue.Damage = 99;
			}
		}
	}

	// Removes Threat Assessment increase
	if (Template.DataName == 'AidProtocol')
	{
		Cooldown = new class'X2AbilityCooldown';
		Cooldown.iNumTurns = default.AID_PROTOCOL_COOLDOWN;
		Template.AbilityCooldown = Cooldown;
	}

	if (Template.DataName == 'KillZone' || Template.DataName == 'Deadeye' || Template.DataName == 'BulletShred')
	{
		for (k = 0; k < Template.AbilityCosts.length; k++)
		{
			ActionPointCost = X2AbilityCost_ActionPoints(Template.AbilityCosts[k]);
			if (ActionPointCost != none)
			{
				X2AbilityCost_ActionPoints(Template.AbilityCosts[k]).iNumPoints = 0;
				X2AbilityCost_ActionPoints(Template.AbilityCosts[k]).bAddWeaponTypicalCost = true;
			}
		}
	}

	if (Template.DataName == 'RapidFire') 
	{
		Cooldown = new class'X2AbilityCooldown';
		Cooldown.iNumTurns = default.RAPIDFIRE_COOLDOWN;
		Template.AbilityCooldown = Cooldown;
	}
	// Steady Hands
	// Stasis Vest
	// Air Controller

	//if (Template.DataName == 'HunterProtocolShot')
	//{
		//Cooldown = new class'X2AbilityCooldown';
		//Cooldown.iNumTurns = 1;
		//Template.AbilityCooldown = Cooldown;
	//}

	// lets RP gain charges from gremlin tech
	if (Template.DataName == 'RevivalProtocol')
	{
		RPCharges = new class 'X2AbilityCharges_RevivalProtocol';
		RPCharges.InitialCharges = class'X2Ability_SpecialistAbilitySet'.default.REVIVAL_PROTOCOL_CHARGES;
		Template.AbilityCharges = RPCharges;
	}

	// adds config to ammo cost and fixes vanilla bug in which 
	if (Template.DataName == 'SaturationFire')
	{
		for (k = 0; k < Template.AbilityCosts.length; k++)
		{
			AmmoCost = X2AbilityCost_Ammo(Template.AbilityCosts[k]);
			if (AmmoCost != none)
			{
				X2AbilityCost_Ammo(Template.AbilityCosts[k]).iAmmo = default.SATURATION_FIRE_AMMO_COST;
			}
		}

		Template.AbilityMultiTargetEffects.length = 0;
		Template.AddMultiTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
		WorldDamage = new class'X2Effect_MaybeApplyDirectionalWorldDamage';
		WorldDamage.bUseWeaponDamageType = true;
		WorldDamage.bUseWeaponEnvironmentalDamage = false;
		WorldDamage.EnvironmentalDamageAmount = 30;
		WorldDamage.bApplyOnHit = true;
		WorldDamage.bApplyOnMiss = true;
		WorldDamage.bApplyToWorldOnHit = true;
		WorldDamage.bApplyToWorldOnMiss = true;
		WorldDamage.bHitAdjacentDestructibles = true;
		WorldDamage.PlusNumZTiles = 1;
		WorldDamage.bHitTargetTile = true;
		WorldDamage.ApplyChance = class'X2Ability_GrenadierAbilitySet'.default.SATURATION_DESTRUCTION_CHANCE;
		Template.AddMultiTargetEffect(WorldDamage);
	}

	if (Template.DataName == 'CarryUnit' || Template.DataName == 'Interact_OpenChest' || Template.DataName == 'Interact_StasisTube')
	{
		Template.ConcealmentRule = eConceal_Never;
	}

	// can't shoot when on FIRE
	if (class'X2Ability_PerkPackAbilitySet'.default.NO_STANDARD_ATTACKS_WHEN_ON_FIRE)
	{
		switch (Template.DataName)
		{
			case 'StandardShot':
			case 'PistolStandardShot':
			case 'SniperStandardFire':
			case 'Shadowfall':
			// Light Em Up and Snap Shot are handled in the template
				UnitEffects = new class'X2Condition_UnitEffects';
				UnitEffects.AddExcludeEffect(class'X2StatusEffects'.default.BurningName, 'AA_UnitIsBurning');
				Template.AbilityShooterConditions.AddItem(UnitEffects);
				break;
			default:
				break;
		}   
	}
	if (class'X2Ability_PerkPackAbilitySet'.default.NO_MELEE_ATTACKS_WHEN_ON_FIRE)
	{
		if (Template.IsMelee())
		{           
			UnitEffects = new class'X2Condition_UnitEffects';
			UnitEffects.AddExcludeEffect(class'X2StatusEffects'.default.BurningName, 'AA_UnitIsBurning');
			Template.AbilityShooterConditions.AddItem(UnitEffects);
		}
	}

	if (Template.DataName == 'StandardShot')
	{
		`LOG ("Adding ReflexShotModifier to StandardShot");
		Template.AdditionalAbilities.AddItem('ReflexShotModifier');
	}

	// Gives names to unnamed effects so they can later be referenced)
	switch (Template.DataName)
	{
		case 'HackRewardBuffEnemy':
			for (k = 0; k < Template.AbilityTargetEffects.length; k++)
			{
				Effect = X2Effect_Persistent (Template.AbilityTargetEffects[k]);
				if (Effect != none)
				{
					if (k == 0)
					{
						X2Effect_Persistent(Template.AbilityTargetEffects[k]).EffectName = 'HackRewardBuffEnemy0';
					}
					if (k == 1)
					{
						X2Effect_Persistent(Template.AbilityTargetEffects[k]).EffectName = 'HackRewardBuffEnemy1';
					}
				}
			}
			break;
		default:
			break;
	}

	// centralizing suppression rules. first batch is new vanilla abilities restricted by suppress.
	// second batch is abilities affected by vanilla suppression that need area suppression change
	// Third batch are vanilla abilities that need suppression limits AND general shooter effect exclusions
	// Mod abilities have restrictions in template defintions
	switch (Template.DataName)
	{
		case 'ThrowGrenade':
		case 'LaunchGrenade':
		case 'MicroMissiles':
		case 'RocketLauncher':
		case 'PoisonSpit':
		case 'GetOverHere':
		case 'Bind':
		case 'AcidBlob':
		case 'BlazingPinionsStage1':
		case 'HailOfBullets':
		case 'SaturationFire':
		case 'Demolition':
		case 'PlasmaBlaster':
		case 'ShredderGun':
		case 'ShredstormCannon':
		case 'BladestormAttack':
		case 'Grapple':
		case 'GrapplePowered':
		case 'IntheZone':
		case 'Reaper':
		case 'Suppression':
			SuppressedCondition = new class'X2Condition_UnitEffects';
			SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
			SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
			Template.AbilityShooterConditions.AddItem(SuppressedCondition);
			break;
		case 'Overwatch':
		case 'PistolOverwatch':
		case 'SniperRifleOverwatch':
		case 'LongWatch':
		case 'Killzone':        
			SuppressedCondition = new class'X2Condition_UnitEffects';
			SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
			Template.AbilityShooterConditions.AddItem(SuppressedCondition);
			break;
		case 'MarkTarget':
		case 'EnergyShield':
		case 'EnergyShieldMk3':
		case 'BulletShred':
		case 'Stealth':
			Template.AddShooterEffectExclusions();
			SuppressedCondition = new class'X2Condition_UnitEffects';
			SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
			SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
			Template.AbilityShooterConditions.AddItem(SuppressedCondition);
			break;
		default:
			break;
	}

	if (Template.DataName == 'Shadowfall')
	{
		StandardAim = X2AbilityToHitCalc_StandardAim(Template.AbilityToHitCalc);
		if (StandardAim != none)
		{
			StandardAim.bGuaranteedHit = false;
			StandardAim.bAllowCrit = true;
			Template.AbilityToHitCalc = StandardAim;
			Template.AbilityToHitOwnerOnMissCalc = StandardAim;
		}
	}

	if (Template.DataName == class'X2Ability_Viper'.default.BindAbilityName)
	{
		SuppressedCondition = new class'X2Condition_UnitEffects';
		SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
		SuppressedCondition.AddExcludeEffect(class'X2Effect_AreaSuppression'.default.EffectName, 'AA_UnitIsSuppressed');
		SuppressedCondition.AddExcludeEffect(class'X2AbilityTemplateManager'.default.StunnedName, 'AA_UnitIsStunned');
		Template.AbilityTargetConditions.AddItem(SuppressedCondition);
	}

	if (Template.DataName == 'Mindspin' || Template.DataName == 'Domination' || Template.DataName == class'X2Ability_PsiWitch'.default.MindControlAbilityName)
	{
		UnitEffectsCondition = new class'X2Condition_UnitEffects';
		UnitEffectsCondition.AddExcludeEffect(class'X2AbilityTemplateManager'.default.StunnedName, 'AA_UnitIsStunned');
		Template.AbilityTargetConditions.AddItem(UnitEffectsCondition);
	}

	if (Template.DataName == 'ThrowGrenade')
	{
		Cooldown = new class'X2AbilityCooldown_AllInstances';
		Cooldown.iNumTurns = default.THROW_GRENADE_COOLDOWN;
		Template.AbilityCooldown = Cooldown;
		X2AbilityToHitCalc_StandardAim(Template.AbilityToHitCalc).bGuaranteedHit = true;
	}

	if (Template.DataName == 'LaunchGrenade')
	{
		X2AbilityToHitCalc_StandardAim(Template.AbilityToHitCalc).bGuaranteedHit = true;
	}

	if (Template.DataName == 'PistolStandardShot')
	{
		Template.AbilityCosts.length = 0;
		QuickdrawActionPointCost = new class'X2AbilityCost_QuickdrawActionPoints_LW';
		QuickdrawActionPointCost.iNumPoints = 1;
		QuickdrawActionPointCost.bConsumeAllPoints = true;
		Template.AbilityCosts.AddItem(QuickdrawActionPointCost);
		AmmoCost = new class'X2AbilityCost_Ammo';
		AmmoCost.iAmmo = 1;
		Template.AbilityCosts.AddItem(AmmoCost);
	}

	if (Template.DataName == 'Faceoff')
	{
		//Template.AbilityCooldown = none;
		if (default.FACEOFF_CHARGES > 0)
		{
			Charges = new class'X2AbilityCharges';
			Charges.InitialCharges = default.FACEOFF_CHARGES;
			Template.AbilityCharges = Charges;
			ChargeCost = new class'X2AbilityCost_Charges';
			ChargeCost.NumCharges = 1;
			Template.AbilityCosts.AddItem(ChargeCost);
		}
		UnitPropertyCondition=new class'X2Condition_UnitProperty';
		UnitPropertyCondition.ExcludeConcealed = true;
		Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
	}

	if (Template.DataName == 'HunkerDown')
	{
		Template.AbilityTargetEffects.length = 0;
		HunkerDownEffect = new class 'X2Effect_HunkerDown_LW';
		HunkerDownEffect.EffectName = 'HunkerDown';
		HunkerDownEffect.DuplicateResponse = eDupe_Refresh;
		HunkerDownEFfect.BuildPersistentEffect (1,,,, 7);
		HunkerDownEffect.SetDisplayInfo (ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage);
		Template.AddTargetEffect(HunkerDownEffect);
		Template.AddTargetEffect(class'X2Ability_SharpshooterAbilitySet'.static.SharpshooterAimEffect());
	}

	if (Template.DataName == 'Fuse' && default.FUSE_COOLDOWN > 0)
	{
		Cooldown = new class 'X2AbilityCooldown';
		Cooldown.iNumTurns = default.FUSE_COOLDOWN;
		Template.AbilityCooldown = Cooldown;
	}

	// Sets to one shot per target a turn
	if (Template.DataName == 'Sentinel')
	{
		Template.AbilityTargetEffects.length = 0;
		GuardianEffect = new class'X2Effect_Guardian_LW';
		GuardianEffect.BuildPersistentEffect(1, true, false);
		GuardianEffect.SetDisplayInfo(0, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
		GuardianEffect.ProcChance = class'X2Ability_SpecialistAbilitySet'.default.GUARDIAN_PROC;
		Template.AddTargetEffect(GuardianEffect);
	}

	// Adds shieldHP bonus
	if (Template.DataName == 'SoulSteal')
	{
		Template.AdditionalAbilities.AddItem('SoulStealTriggered2');
	}

	// When completeing a control robot hack remove any previous disorient effects as is done for dominate.
	if (Template.DataName == 'HackRewardControlRobot' || Template.DataName == 'HackRewardControlRobotWithStatBoost')
	{
		`Log("Adding disorient removal to " $ Template.DataName);
		Template.AddTargetEffect(class'X2StatusEffects'.static.CreateMindControlRemoveEffects());
		Template.AddTargetEffect(class'X2StatusEffects'.static.CreateStunRecoverEffect());
	}

	if (Template.DataName == 'FinalizeHaywire')
	{
		HaywiredEffect = new class'X2Effect_Persistent';
		HaywiredEffect.EffectName = 'Haywired';
		HaywiredEffect.BuildPersistentEffect(1, true, false);
		HaywiredEffect.bDisplayInUI = false;
		HaywiredEffect.bApplyOnMiss = true;
		Template.AddTargetEffect(HaywiredEffect);
	}

	if (Template.DataName == 'HaywireProtocol') 
	{
		NotHaywiredCondition = new class 'X2Condition_UnitEffects';
		NotHaywiredCondition.AddExcludeEffect ('Haywired', 'AA_NoTargets'); 
		Template.AbilityTargetConditions.AddItem(NotHaywiredCondition);
	}

	if (Template.DataName == 'Evac')
	{
		// Only mastered mind-controlled enemies can evac. Insert this one first, as it will return
		// 'AA_AbilityUnavailable' if they can't use the ability, so it will be hidden on any MC'd
		// alien instead of being shown but disabled when they aren't in an evac zone due to that
		// condition returning a different code.
		Template.AbilityShooterConditions.InsertItem(0, new class'X2Condition_MasteredEnemy');
	}

	switch (Template.DataName)
	{
		case 'OverwatchShot':
		case 'LongWatchShot':
		case 'GunslingerShot':
		case 'KillZoneShot':
		case 'PistolOverwatchShot':
		case 'SuppressionShot_LW':
		case 'SuppressionShot':
		case 'AreaSuppressionShot_LW':
		case 'CloseCombatSpecialistAttack':
			ShotEffect = class'X2Ability_PerkPackAbilitySet'.static.CoveringFireMalusEffect();
			ShotEffect.TargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());
			Template.AddTargetEffect(ShotEffect);
			break;
	}

	// that isn't available with X2WOTCCommunityHighlander right now. I'm building against a custom
	// version.
	if (default.USE_ACTION_ICON_COLORS)
	{
		for (k = 0; k < Template.AbilityCosts.length; k++)
		{
			ActionPointCost = X2AbilityCost_ActionPoints(Template.AbilityCosts[k]);
			if (ActionPointCost != none)
			{
				if (X2AbilityCost_ActionPoints(Template.AbilityCosts[k]).bAddWeaponTypicalCost)
				{
					Template.AbilityIconColor = "Variable";
				}
			}
		}

		switch (Template.DataName)
		{
			case 'LaunchGrenade':               // Salvo, Rapid Deployment
			case 'ThrowGrenade':                // Salvo, Rapid Deployment
			case 'LWFlamethrower':              // Quickburn
			case 'Roust':                       // Quickburn
			case 'Firestorm':                   // Quickburn
			case 'LWRocketLauncher':            // Salvo
			case 'LWBlasterLauncher':           // Salvo
			case 'RocketLauncher':              // Salvo
			case 'ConcussionRocket':            // Salvo
			case 'ShredderGun':                 // Salvo
			case 'PlasmaBlaster':               // Salvo
			case 'ShredstormCannon':            // Salvo
			case 'Flamethrower':                // Salvo
			case 'FlamethrowerMk2':             // Salvo
			case 'Holotarget':                  // Rapid Targeting (passive)
			case 'Reload':                      // Weapon Upgrade
			case 'PlaceEvacZone':
			case 'PlaceDelayedEvacZone':
			case 'PistolStandardShot':          // Quickdraw
			case 'ClutchShot':                  // Quickdraw
			case 'KillZone':                    // Varies by weapon type
			case 'DeadEye':                     // Varies by weapon type
			case 'Flush':                       // Varies by weapon type
			case 'PrecisionShot':               // Varies by weapon type
			case 'BulletShred':                 // varies by weapon type
				Template.AbilityIconColor = "Variable"; break; // This calls a function that changes the color on the fly
			case 'EVAC': 
				Template.AbilityIconColor = default.ICON_COLOR_FREE; break;
			case 'IntrusionProtocol':
			case 'IntrusionProtocol_Chest':
			case 'Hack_Chest':
				Template.AbilityIconColor = default.ICON_COLOR_1; break;
			case 'IntrusionProtocol_ObjectiveChest':
			case 'Hack_Workstation':
			case 'Hack_ObjectiveChest':
			case 'PlantExplosiveMissionDevice':
			case 'GatherEvidence':
			case 'Interact_PlantBomb':
			case 'Interact_TakeVial':
			case 'Interact_StasisTube':
			case 'IntrusionProtocol_Workstation':
			case 'Interact_SmashNGrab':
				Template.AbilityIconColor = default.ICON_COLOR_OBJECTIVE; break;
			case 'HaywireProtocol':
			case 'FullOverride':
			case 'SKULLJACKAbility':
			case 'SKULLMINEAbility':
			case 'Bombard':
				Template.AbilityIconColor = default.ICON_COLOR_END; break;
			default:
				Template.AbilityIconColor = GetIconColorByActionPoints (Template); break;
		}
	}
	
	// Yellow alert scamper ability table. Search these abilities for an X2AbilityCost_ActionPoints
	// and add the special 'ReflexActionPoint_LW' to the list of valid action points that can be used
	// for these actions. These special action points are awarded to some units during a scamper, and
	// they will only be able to use the abilities configured here.
	if (OffensiveReflexAbilities.Find(Template.DataName) >= 0)
	{
		AddReflexActionPoint(Template, class'Utilities_LW'.const.OffensiveReflexAction);
	}

	if (DefensiveReflexAbilities.Find(Template.DataName) >= 0)
	{
		AddReflexActionPoint(Template, class'Utilities_LW'.const.DefensiveReflexAction);
	}

	if (DoubleTapAbilities.Find(Template.DataName) >= 0)
	{
		`LOG ("Adding Double Tap to" @ Template.DataName);
		AddDoubleTapActionPoint (Template, class'X2Ability_LW_SharpshooterAbilitySet'.default.DoubleTapActionPoint);
	}

	// bugfix, hat tip to BountyGiver, needs test
	if (Template.DataName == 'SkullOuch')
	{
		Template.BuildNewGameStateFn = SkullOuch_BuildGameState;
	}
}

// Rather than having the loss of squad concealment panic all civilians on the
// map, only panic those that XCOM get close to. This has the added benefit of
// working on missions with either concealed or unconcealed starts.
static function FixCivilianPanicOnApproach(X2AbilityTemplate Template)
{
	local X2AbilityMultiTarget_Radius RadiusMultiTarget;
	local X2Condition_UnitProperty UnitPropertyCondition;
	local X2AbilityTrigger_EventListener EventListener;
	
	// Clear the 'SquadConcealmentBroken' ability trigger first
	Template.AbilityTriggers.Length = 0;
	
	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bUseWeaponRadius = false;
	RadiusMultiTarget.fTargetRadius = `TILESTOMETERS(default.CIVILIAN_PANIC_RANGE);
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	// Only triggers from player controlled units moving in range
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.IsPlayerControlled = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeConcealed = true;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.CheckForVisibleMovementInRadius_Self;
	EventListener.ListenerData.EventID = 'UnitMoveFinished';
	Template.AbilityTriggers.AddItem(EventListener);
}

static function XComGameState SkullOuch_BuildGameState (XComGameStateContext context)
{
	local XComGameState NewGameState;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit UnitState;

	NewGameState = class'X2Ability'.static.TypicalAbility_BuildGameState(context);
	AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext()); // or should it be just context
	UnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', AbilityContext.InputContext.SourceObject.ObjectID));
	UnitState.Abilities.RemoveItem(AbilityContext.InputContext.AbilityRef);
	NewGameState.AddStateObject(UnitState);
	return NewGameState;
}


function AddReflexActionPoint(X2AbilityTemplate Template, Name ActionPointName)
{
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCost                     Cost;

	foreach Template.AbilityCosts(Cost)
	{
		ActionPointCost = X2AbilityCost_ActionPoints(Cost);
		if (ActionPointCost != none)
		{
			ActionPointCost.AllowedTypes.AddItem(ActionPointName);
			`LWTrace("Adding reflex action point " $ ActionPointName $ " to " $ Template.DataName);
			return;
		}
	}

	`Log("Cannot add reflex ability " $ Template.DataName $ ": Has no action point cost");
}

function AddDoubleTapActionPoint(X2AbilityTemplate Template, Name ActionPointName)
{
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCost                     Cost;

	foreach Template.AbilityCosts(Cost)
	{
		ActionPointCost = X2AbilityCost_ActionPoints(Cost);
		if (ActionPointCost != none)
		{
			ActionPointCost.AllowedTypes.AddItem(ActionPointName);
		}
	}
}
//cyan 9acbcb
//red bf1e2e
//yellow fdce2b
//orange e69831
//green 53b45e
//gray 828282
//purple b6b3e3


// Replace the base game X2Effect_ApplyWeaponDamage with the new X2Effect_ApplyExplosiveFalloffWeaponDamage.
static function X2LWTemplateModTemplate CreateSwapExplosiveDamageFalloff()
{
	local X2LWTemplateModTemplate Template;

	`CREATE_X2TEMPLATE(class'X2LWTemplateModTemplate', Template, 'SwapExplosiveDamageFalloff');

	// We need to modify grenade items and ability templates
	Template.ItemTemplateModFn = SwapExplosiveFalloffItem;
	Template.AbilityTemplateModFn = SwapExplosiveFalloffAbility;
	return Template;
}

function SwapExplosiveFalloffItem(X2ItemTemplate Template, int Difficulty)
{
	local X2GrenadeTemplate                             GrenadeTemplate;
	local X2Effect_ApplyWeaponDamage                    ThrownDamageEffect, LaunchedDamageEffect;
	local X2Effect_ApplyExplosiveFalloffWeaponDamage    FalloffDamageEffect;
	local X2Effect                                      GrenadeEffect;

	GrenadeTemplate = X2GrenadeTemplate(Template);
	if(GrenadeTemplate == none)
		return;
	foreach GrenadeTemplate.ThrownGrenadeEffects(GrenadeEffect)
	{
		ThrownDamageEffect = X2Effect_ApplyWeaponDamage(GrenadeEffect);
		if (ThrownDamageEffect != none)
		{
			break;
		}
	}
	foreach GrenadeTemplate.LaunchedGrenadeEffects(GrenadeEffect)
	{
		LaunchedDamageEffect = X2Effect_ApplyWeaponDamage(GrenadeEffect);
		if (LaunchedDamageEffect != none)
		{
			break;
		}
	}
	if (ThrownDamageEffect != none || LaunchedDamageEffect != none)
	{
		FalloffDamageEffect = new class'X2Effect_ApplyExplosiveFalloffWeaponDamage' (ThrownDamageEffect);

		//Falloff-specific settings
		FalloffDamageEffect.UnitDamageAbilityExclusions.AddItem('TandemWarheads'); // if has any of these abilities, skip any falloff
		FalloffDamageEffect.EnvironmentDamageAbilityExclusions.AddItem('CombatEngineer'); // if has any of these abilities, skip any falloff
		FalloffDamageEffect.UnitDamageSteps=default.UnitDamageSteps;
		FalloffDamageEffect.EnvironmentDamageSteps=default.EnvironmentDamageSteps;

		if (ThrownDamageEffect != none)
		{
			//`LOG("Swapping ThrownGrenade DamageEffect for item " $ Template.DataName $ ", Difficulty=" $ Difficulty);
			GrenadeTemplate.ThrownGrenadeEffects.RemoveItem(ThrownDamageEffect);
			GrenadeTemplate.ThrownGrenadeEffects.AddItem(FalloffDamageEffect);
		}
		if (LaunchedDamageEffect != none)
		{
			//`LOG("Swapping LaunchedGrenade DamageEffect for item " $ Template.DataName $ ", Difficulty=" $ Difficulty);
			GrenadeTemplate.LaunchedGrenadeEffects.RemoveItem(ThrownDamageEffect);
			GrenadeTemplate.LaunchedGrenadeEffects.AddItem(FalloffDamageEffect);
		}
	}
}


function SwapExplosiveFalloffAbility(X2AbilityTemplate Template, int Difficulty)
{
	local X2Effect_ApplyWeaponDamage                    DamageEffect;
	local X2Effect_ApplyExplosiveFalloffWeaponDamage    FalloffDamageEffect;
	local X2Effect                                      MultiTargetEffect;

	//`LOG("Testing Ability " $ Template.DataName);

	foreach Template.AbilityMultiTargetEffects(MultiTargetEffect)
	{
		DamageEffect = X2Effect_ApplyWeaponDamage(MultiTargetEffect);
		if (DamageEffect != none)
		{
			break;
		}
	}
	if (DamageEffect != none && ValidExplosiveFalloffAbility(Template, DamageEffect))
	{
		FalloffDamageEffect = new class'X2Effect_ApplyExplosiveFalloffWeaponDamage' (DamageEffect);

		//Falloff-specific settings
		FalloffDamageEffect.UnitDamageAbilityExclusions.AddItem('TandemWarheads'); // if has any of these abilities, skip any falloff
		FalloffDamageEffect.EnvironmentDamageAbilityExclusions.AddItem('CombatEngineer'); // if has any of these abilities, skip any falloff
		FalloffDamageEffect.UnitDamageSteps=default.UnitDamageSteps;
		FalloffDamageEffect.EnvironmentDamageSteps=default.EnvironmentDamageSteps;

		//`LOG("Swapping AbilityMultiTargetEffects DamageEffect for item " $ Template.DataName);
		Template.AbilityMultiTargetEffects.RemoveItem(DamageEffect);
		Template.AbilityMultiTargetEffects.AddItem(FalloffDamageEffect);
	}
	else
	{
		//`LOG("Ability " $ Template.DataName $ " : Not Valid");
	}
}

function bool ValidExplosiveFalloffAbility(X2AbilityTemplate Template, X2Effect_ApplyWeaponDamage DamageEffect)
{
	if (!ClassIsChildOf(class'X2Effect_ApplyExplosiveFalloffWeaponDamage', DamageEffect.Class))
	{
		// Make
		`REDSCREEN("Can't apply explosive falloff to" @ DamageEffect.Class @ "as it's not a super class");
		return false;
	}

	//check specific exclusions
	if(default.ExplosiveFalloffAbility_Exclusions.Find(Template.DataName) != -1)
	{
		//`LOG("Ability " $ Template.DataName $ " : Explicitly Excluded");
		return false;
	}
	//exclude any psionic ability
	if(Template.AbilitySourceName == 'eAbilitySource_Psionic')
	{
		//`LOG("Ability " $ Template.DataName $ " : Excluded Because Psionic Source");
		return false;
	}
	//check for MultiTargetRadius
	if(Template.AbilityMultiTargetStyle.Class == class'X2AbilityMultiTarget_Radius')
	{
		if(DamageEffect.bExplosiveDamage)
			return true;
		//else
			//`LOG("Ability " $ Template.DataName $ " : Not bExplosiveDamage");

		if(DamageEffect.EffectDamageValue.DamageType == 'Explosion')
			return true;
		//else
			//`LOG("Ability " $ Template.DataName $ " : DamageType Not Explosion");

	}
	//check for specific inclusions
	if(default.ExplosiveFalloffAbility_Inclusions.Find(Template.DataName) != -1)
	{
		return true;
	}

	//`LOG("Ability " $ Template.DataName $ " : Excluded By Default");
	return false;
}

// Replace the base game "PlaceEvacZone" ability with a new "PlaceDelayedEvacZone" ability.
static function X2LWTemplateModTemplate CreateDelayedEvacTemplate()
{
	local X2LWTemplateModTemplate Template;

	`CREATE_X2TEMPLATE(class'X2LWTemplateModTemplate', Template, 'DelayedEvacMod');

	// We need to modify character templates
	Template.CharacterTemplateModFn = ReplacePlaceEvacAbility;
	return Template;
}

// Remove the 'PlaceEvacZone' ability from all characters. This has been replaced by
// the 'PlaceDelayedEvacZone', which is technically an item-granted ability to permit
// it to be visualized as a thrown flare (grenade). See X2Item_EvacFlare.
function ReplacePlaceEvacAbility(X2CharacterTemplate Template, int Difficulty)
{
	if (Template.Abilities.Find('PlaceEvacZone') != -1)
	{
		Template.Abilities.RemoveItem('PlaceEvacZone');
	}
}

static function X2LWTemplateModTemplate CreateGeneralCharacterModTemplate()
{
	local X2LWTemplateModTemplate Template;

	`CREATE_X2TEMPLATE(class'X2LWTemplateModTemplate', Template, 'GeneralCharacterMod');

	// We need to modify character templates
	Template.CharacterTemplateModFn = GeneralCharacterMod;
	return Template;
}

function GeneralCharacterMod(X2CharacterTemplate Template, int Difficulty)
{
	local LootReference Loot;

	if (class'X2Effect_TransferMecToOutpost'.default.VALID_FULLOVERRIDE_TYPES_TO_TRANSFER_TO_OUTPOST.Find(Template.DataName) >= 0)
	{
		`Log("Adding evac to " $ Template.DataName);
		Template.Abilities.AddItem('Evac');
	}

	switch (Template.DataName)
	{
		// Give ADVENT the hunker down ability
		case 'AdvTrooperM1':
		case 'AdvTrooperM2':
		case 'AdvTrooperM3':
		case 'AdvCaptainM1':
		case 'AdvCaptainM2':
		case 'AdvCaptainM3':
		case 'AdvShieldbearerM2':
		case 'AdvShieldbearerM3':
		case 'AdvStunLancerM1':
			Template.Abilities.AddItem('HunkerDown');
			break;
		case 'FacelessCivilian':
			// Set 'FacelessCivilian' as being hostile. These are mostly only used
			// with the Infiltrators DE, and without this set it's trivial to detect
			// which civilians are faceless because they won't have stealth detection
			// tiles around them.
			Template.bIsHostileCivilian = true;
			// Add faceless loot to the faceless civilian template. Ensures a corpse
			// drops if you kill the civvy before they transform (e.g. by stunning them 
			// first, or doing enough damage to kill them from concealment).
			Loot.ForceLevel = 0;
			Loot.LootTableName = 'Faceless_BaseLoot';
			Template.Loot.LootReferences.AddItem(Loot);
			break;
		case 'Gatekeeper':
			Template.ImmuneTypes.AddItem('Poison');
			Template.ImmuneTypes.AddItem(class'X2Item_DefaultDamageTypes'.default.ParthenogenicPoisonType);
			Template.ImmuneTypes.AddItem('Fire');
			break;
		case 'AdvStunLancerM2':
			Template.Abilities.AddItem('HunkerDown');
			Template.Abilities.AddItem('CoupdeGrace2');
			break;
		case 'AdvStunLancerM3':
			Template.Abilities.AddItem('HunkerDown');
			Template.Abilities.AddItem('CoupdeGrace2');
			Template.Abilities.AddItem('Whirlwind2');
			break;
		// Should turn off tick damage every action
		case 'ViperKing':
		case 'BerserkerQueen':
		case 'ArchonKing':
			Template.bCanTickEffectsEveryAction = false;
			break;
		case 'LostTowersSpark':
		case 'SparkSoldier':
			Template.bIgnoreEndTacticalHealthMod = false;       // This means Repair perk won't permanently fix Sparks
			Template.OnEndTacticalPlayFn = none;
			break;
		default:
			break;
	}

	// Any soldier templates get the Interact_SmashNGrab ability
	if (Template.bIsSoldier)
	{
		Template.Abilities.AddItem('Interact_SmashNGrab');
	}
}

static function X2LWTemplateModTemplate CreateReconfigGearTemplate()
{
	local X2LWTemplateModTemplate Template;

	`CREATE_X2TEMPLATE(class'X2LWTemplateModTemplate', Template, 'ReconfigGear');
	Template.ItemTemplateModFn = ReconfigGear;
	return Template;
}

function ReconfigGear(X2ItemTemplate Template, int Difficulty)
{
	local X2WeaponTemplate WeaponTemplate;
	local X2SchematicTemplate SchematicTemplate;
	local X2EquipmentTemplate EquipmentTemplate;
	local X2WeaponUpgradeTemplate WeaponUpgradeTemplate;
	local X2GrenadeTemplate GrenadeTemplate;
	local X2AmmoTemplate AmmoTemplate;
	local int i, k;
	local ArtifactCost Resources;
	local X2ArmorTemplate ArmorTemplate;
	local StrategyRequirement AltReq;
	local X2GremlinTemplate GremlinTemplate;
	local delegate<X2StrategyGameRulesetDataStructures.SpecialRequirementsDelegate> SpecialRequirement;
	local X2Effect_Persistent Effect;

	// Reconfig Weapons and Weapon Schematics
	WeaponTemplate = X2WeaponTemplate(Template);
	if (WeaponTemplate != none)
	{
		// substitute cannon range table
		if (WeaponTemplate.WeaponCat == 'cannon')
		{
			WeaponTemplate.RangeAccuracy = class'X2Item_DefaultWeaponMods_LW'.default.LMG_ALL_RANGE;
		}
		if (WeaponTemplate.DataName == 'Medikit')
		{
			WeaponTemplate.HideIfResearched = '';
		}
		if (WeaponTemplate.DataName == 'Medikit' || WeaponTemplate.DataName == 'NanoMedikit')
		{
			WeaponTemplate.Abilities.AddItem('Sedate');
		}
		if (WeaponTemplate.DataName == 'AdvTurretM1_WPN' && default.EARLY_TURRET_SQUADSIGHT)
		{
			WeaponTemplate.Abilities.AddItem('Squadsight');
		}
		if (WeaponTemplate.DataName == 'AdvTurretM2_WPN' && default.MID_TURRET_SQUADSIGHT)
		{
			WeaponTemplate.Abilities.AddItem('Squadsight');
		}
		if (WeaponTemplate.DataName == 'AdvTurretM3_WPN' && default.LATE_TURRET_SQUADSIGHT)
		{
			WeaponTemplate.Abilities.AddItem('Squadsight');
		}

		//if (WeaponTemplate.Abilities.Find('StandardShot') != -1)
		//{
			//WeaponTemplate.Abilities.AddItem('ReflexShot');
			//`LWTRACE ("Adding ReflexShot to" @ WeaponTemplate.DataName);
		//}

		//switch (WeaponTemplate.DataName)
		//{
			//case 'MutonM2_LW_WPN':
			//case 'MutonM3_LW_WPN':
			//case 'NajaM1_WPN':
			//case 'NajaM2_WPN':
			//case 'NajaM3_WPN':
			//case 'SidewinderM1_WPN':
			//case 'SidewinderM2_WPN':
			//case 'SidewinderM3_WPN':
				//break;
			//default;
				//break;
		//}
		for (i=0; i < ItemTable.Length; ++i)
		{
			if (WeaponTemplate.DataName == ItemTable[i].ItemTemplateName)
			{
				WeaponTemplate.NumUpgradeSlots = ItemTable[i].Slots;
			}
		}
		switch (WeaponTemplate.DataName)
		{
			case 'Muton_MeleeAttack':
			case 'AndromedonRobot_MeleeAttack':
			case 'ArchonStaff':
			case 'Viper_Tongue_WPN':
			case 'PsiZombie_MeleeAttack':
				WeaponTemplate.iEnvironmentDamage = 0;
				break;
			case 'Faceless_MeleeAoE':
				WeaponTemplate.iEnvironmentDamage = 5;
				break;
			default:
				break;
		}
		if (WeaponTemplate.DataName == 'Sword_BM')
		{
			for (k = 0; k < WeaponTemplate.BonusWeaponEffects.length; k++)
			{
				Effect = X2Effect_Persistent(WeaponTemplate.BonusWeaponEffects[k]);
				if (Effect != none)
				{
					if (Effect.EffectName == class'X2StatusEffects'.default.BurningName)
					{
						Effect.ApplyChance = default.FUSION_SWORD_FIRE_CHANCE;
					}
				}
			}

		}
	}   

	GremlinTemplate = X2GremlinTemplate(Template);
	if (GremlinTemplate != none)
	{
		if (GremlinTemplate.DataName == 'Gremlin_MG')
		{
			GremlinTemplate.RevivalChargesBonus = 1;
			GremlinTemplate.ScanningChargesBonus = 1;
			GremlinTemplate.AidProtocolBonus = 5;
		}
		if (GremlinTemplate.DataName == 'Gremlin_BM')
		{
			GremlinTemplate.RevivalChargesBonus = 2;
			GremlinTemplate.ScanningChargesBonus = 2;
			GremlinTemplate.AidProtocolBonus = 10;
		}
		if (GremlinTemplate.DataName == 'SparkBit_MG')
		{
			GremlinTemplate.HealingBonus = 1;
		}
		if (GremlinTemplate.DataName == 'SparkBit_BM')
		{
			GremlinTemplate.HealingBonus = 2;
		}
	}
	
	// KILL SCHEMATICS
	SchematicTemplate = X2SchematicTemplate(Template);
	if (SchematicTemplate != none && default.SchematicsToPreserve.Find(SchematicTemplate.DataName) == -1)
	{
		SchematicTemplate.CanBeBuilt = false;
		SchematicTemplate.PointsToComplete = 999999;
		SchematicTemplate.Requirements.RequiredEngineeringScore = 999999;
		SchematicTemplate.Requirements.bVisibleifPersonnelGatesNotMet = false;
		SchematicTemplate.OnBuiltFn = none;
		SchematicTemplate.Cost.ResourceCosts.Length = 0;
		SchematicTemplate.Cost.ArtifactCosts.Length = 0;
	}
	// special handling of DLC2 schematics so that they can't be used when units with them are deployed
	if (SchematicTemplate != none)
	{
		switch (SchematicTemplate.DataName)
		{
			case 'HunterRifle_MG_Schematic':
			case 'HunterRifle_BM_Schematic':
			case 'HunterPistol_MG_Schematic':
			case 'HunterPistol_BM_Schematic':
			case 'HunterAxe_MG_Schematic':
			case 'HunterAxe_BM_Schematic':
				class'LWDLCHelpers'.static.GetAlienHunterWeaponSpecialRequirementFunction(SpecialRequirement, SchematicTemplate.DataName);
				SchematicTemplate.Requirements.SpecialRequirementsFn = SpecialRequirement;
				SchematicTemplate.AlternateRequirements[0].SpecialRequirementsFn = SpecialRequirement;
				break;
			default:
				break;
		}

	}
	// ALL ITEMS, including resources -- config art and trading post value
	for (i=0; i < ItemTable.Length; ++i)
	{           
		if (Template.DataName == ItemTable[i].ItemTemplateName)
		{
			if (ItemTable[i].TradingPostValue != 0)
				Template.TradingPostValue = ItemTable[i].TradingPostValue;
			if (ItemTable[i].InventoryImage != "")
				Template.strInventoryImage = ItemTable[i].InventoryImage;
			if (ItemTable[i].Tier > -1)
			{
				Template.Tier = ItemTable[i].Tier;
			}
		}
	}

	if (default.EXPLOSIVES_NUKE_CORPSES)
	{
		// NOTE: Leaving off Codex and Avatar for plot reasons
		switch (Template.DataName)
		{
			case 'CorpseSectoid':
			case 'CorpseViper':
			case 'CorpseMuton':
			case 'CorpseBerserker':
			case 'CorpseArchon':
			case 'CorpseAndromedon':
			case 'CorpseFaceless':
			case 'CorpseChryssalid':
			case 'CorpseGatekeeper':
			case 'CorpseAdventTrooper':
			case 'CorpseAdventOfficer':
			case 'CorpseAdventTurret':
			case 'CorpseAdventMEC':
			case 'CorpseAdventStunLancer':
			case 'CorpseAdventShieldbearer':
			case 'CorpseDrone':
			case 'CorpseMutonElite':
				Template.LeavesExplosiveRemains = false;
				break;
			default:
				break;
		}
	}

	if (Template.DataName == 'SmallIntelCache')
	{
		Template.ResourceQuantity = default.SMALL_INTEL_CACHE_REWARD;
		`LWTRACE("SETTING SMALL INTEL CACHE REWARD TO" @ Template.ResourceQuantity);
	}
	if (Template.DataName == 'BigIntelCache')
	{
		Template.ResourceQuantity = default.LARGE_INTEL_CACHE_REWARD;
		`LWTRACE("SETTING LARGE INTEL CACHE REWARD TO" @ Template.ResourceQuantity);
	}

	EquipmentTemplate = X2EquipmentTemplate(Template);
	if (EquipmentTemplate != none)
	{
		if (EquipmentTemplate.DataName == 'HazmatVest') // BUGFIX TO INCLUDE ACID IMMUNITY
		{
			EquipmentTemplate.Abilities.Length = 0;
			EquipmentTemplate.Abilities.AddItem ('HazmatVestBonus_LW');
		}
		if (EquipmentTemplate.DataName == 'NanofiberVest') // THIS JUST MAKES IT BETTER
		{
			EquipmentTemplate.Abilities.Length = 0;
			EquipmentTemplate.Abilities.AddItem ('NanofiberVestBonus_LW');
		}
		///Add an ability icon for all of these so people can keep ammo straight
		if (EquipmentTemplate.DataName == 'APRounds')
		{
			if (EquipmentTemplate.Abilities.Find('AP_Rounds_Ability_PP') == -1)
			{
				EquipmentTemplate.Abilities.AddItem('AP_Rounds_Ability_PP');
			}
		}
		if (EquipmentTemplate.DataName == 'TalonRounds')
		{
			if (EquipmentTemplate.Abilities.Find('Talon_Rounds_Ability_PP') == -1)
			{
				EquipmentTemplate.Abilities.AddItem('Talon_Rounds_Ability_PP');
			}
		}
		if (EquipmentTemplate.DataName == 'VenomRounds')
		{
			if (EquipmentTemplate.Abilities.Find('Venom_Rounds_Ability_PP') == -1)
			{
				EquipmentTemplate.Abilities.AddItem('Venom_Rounds_Ability_PP');
			}
		}
		if (EquipmentTemplate.DataName == 'IncendiaryRounds')
		{
			if (EquipmentTemplate.Abilities.Find('Dragon_Rounds_Ability_PP') == -1)
			{
				EquipmentTemplate.Abilities.AddItem('Dragon_Rounds_Ability_PP');
			}
		}
		if (EquipmentTemplate.DataName == 'BluescreenRounds')
		{
			if (EquipmentTemplate.Abilities.Find('Bluescreen_Rounds_Ability_PP') == -1)
			{
				EquipmentTemplate.Abilities.AddItem('Bluescreen_Rounds_Ability_PP');
			}
		}
		if (EquipmentTemplate.DataName == 'TracerRounds')
		{
			if (EquipmentTemplate.Abilities.Find('Tracer_Rounds_Ability_PP') == -1)
			{
				EquipmentTemplate.Abilities.AddItem('Tracer_Rounds_Ability_PP');
			}
		}
		// Adds stat markup for medium plated armor
		ArmorTemplate = X2ArmorTemplate(Template);
		if (ArmorTemplate != none)
		{
			switch (ArmorTemplate.DataName)
			{
				// Let all soldier armors provide an extra utility slot
				case 'KevlarArmor':
				case 'LightPlatedArmor':
				case 'HeavyPlatedArmor':
				case 'LightPoweredArmor':
				case 'HeavyPoweredArmor':
				case 'ReaperArmor':
				case 'PoweredReaperArmor':
				case 'SkirmisherArmor':
				case 'PoweredSkirmisherArmor':
				case 'TemplarArmor':
				case 'PoweredTemplarArmor':
					ArmorTemplate.bAddsUtilitySlot = true;
					break;
				
				case 'PlatedReaperArmor':
				case 'PlatedSkirmisherArmor':
				case 'PlatedTemplarArmor':
					ArmorTemplate.bAddsUtilitySlot = true;
				case 'MediumPlatedArmor':
					ArmorTemplate.SetUIStatMarkup(class'XLocalizedData'.default.ArmorLabel, 14, default.MEDIUM_PLATED_MITIGATION_AMOUNT);
					break;

				case 'SparkArmor':
				case 'PlatedSparkArmor':
				case 'PoweredSparkArmor':
					ArmorTemplate.Abilities.AddItem('Carapace_Plating_Ability');
					break;
				
				default:
					// Assume any other armors we don't know about should get the extra
					// utility slot. (Issue #89)
					ArmorTemplate.bAddsUtilitySlot = true;
					break;
			}
		}

		GrenadeTemplate = X2GrenadeTemplate(Template);
		if (GrenadeTemplate != none)
		{
			if (GrenadeTemplate.DataName == 'ProximityMine')
			{
				GrenadeTemplate.iEnvironmentDamage = class'X2Item_DefaultWeaponMods_LW'.default.PROXIMITYMINE_iENVIRONMENTDAMAGE;
			}
			if (GrenadeTemplate.DataName == 'MutonGrenade')
			{
				GrenadeTemplate.iEnvironmentDamage = class'X2Item_DefaultWeaponMods_LW'.default.MUTONGRENADE_iENVIRONMENTDAMAGE;
			}
			if (GrenadeTemplate.DataName == 'FragGrenade')
			{
				GrenadeTemplate.HideIfResearched = '';
			}
			if (GrenadeTemplate.DataName == 'SmokeGrenade')
			{
				GrenadeTemplate.HideIfResearched = '';
			}
			if (GrenadeTemplate.DataName == 'EMPGrenade')
			{
				GrenadeTemplate.HideIfResearched = '';
			}
			if (GrenadeTemplate.DataName == 'FireBomb' || GrenadeTemplate.DataName == 'FireBombMk2')
			{
				for (k = 0; k < GrenadeTemplate.ThrownGrenadeEffects.length; k++)
				{
					if (GrenadeTemplate.ThrownGrenadeEffects[k].IsA ('X2Effect_Burning'))
					{
						GrenadeTemplate.ThrownGrenadeEffects[k].ApplyChance = default.FIREBOMB_FIRE_APPLY_CHANCE;
					}
				}
				for (k = 0; k < GrenadeTemplate.LaunchedGrenadeEffects.length; k++)
				{
					if (GrenadeTemplate.LaunchedGrenadeEffects[k].IsA ('X2Effect_Burning'))
					{
						GrenadeTemplate.LaunchedGrenadeEffects[k].ApplyChance = default.FIREBOMB_2_FIRE_APPLY_CHANCE;
					}
				}
			}


			switch (GrenadeTemplate.DataName) 
			{
				case 'AlienGrenade' :
				case 'MutonGrenade' :
				case 'MutonM2_LWGrenade' :
				case 'MutonM3_LWGrenade' :
					GrenadeTemplate.AddAbilityIconOverride('ThrowGrenade', "img:///UILibrary_LW_Overhaul.UIPerk_grenade_aliengrenade");
					GrenadeTemplate.AddAbilityIconOverride('LaunchGrenade', "img:///UILibrary_LW_Overhaul.UIPerk_grenade_aliengrenade");
					`LWTRACE("Added Ability Icon Override for Alien Grenade");
					break;
				default :
					break;
			}
		}

		AmmoTemplate = X2AmmoTemplate(Template);
		if (AmmoTemplate != none)
		{
			if (AmmoTemplate.DataName == 'IncendiaryRounds')
			{
				for (k = 0; k < AmmoTemplate.TargetEffects.length; k++)
				{
					if (AmmoTemplate.TargetEffects[k].IsA ('X2Effect_Burning'))
					{
						AmmoTemplate.TargetEffects[k].ApplyChance = default.DRAGON_ROUNDS_APPLY_CHANCE;
					}
				}
			}
			if (AmmoTemplate.DataName == 'VenomRounds')
			{
				for (k = 0; k < AmmoTemplate.TargetEffects.length; k++)
				{
					if (AmmoTemplate.TargetEffects[k].IsA ('X2Effect_PersistentStatChange'))
					{
						AmmoTemplate.TargetEffects[k].ApplyChance = default.VENOM_ROUNDS_APPLY_CHANCE;
					}
				}
			}
		}


		switch (EquipmentTemplate.DataName)
		{
			case 'ChosenSniperPistol_XCOM':
			case 'AlienHunterPistol_CV':
			case 'AlienHunterPistol_MG':
			case 'AlienHunterPistol_BM':
				EquipmentTemplate.InventorySlot = eInvSlot_Utility;
				X2WeaponTemplate(EquipmentTemplate).RangeAccuracy = class'X2Item_SMGWeapon'.default.MIDSHORT_BEAM_RANGE;
				X2WeaponTemplate(EquipmentTemplate).StowedLocation = eSlot_RearBackPack;
				EquipmentTemplate.Abilities.AddItem('PistolStandardShot'); // in base-game, this ability is a class ability, so need it added for utility slot pistols
				break;
			case 'Cannon_CV': // replace archetype with non-suppression shaking variant
				EquipmentTemplate.GameArchetype = "Cannon_NoShake_LW.Archetypes.WP_Cannon_NoShake_CV";
				break;
			case 'Cannon_MG': // replace archetype with non-suppression shaking variant
				EquipmentTemplate.GameArchetype = "Cannon_NoShake_LW.Archetypes.WP_Cannon_NoShake_MG";
				break;
			case 'Cannon_BM': // replace archetype with non-suppression shaking variant
				EquipmentTemplate.GameArchetype = "Cannon_NoShake_LW.Archetypes.WP_Cannon_NoShake_BM";
				break;
			default:
				break;
		}
		// KILL THE SCHEMATICS! (but only the schematics we want to kill)
		if (EquipmentTemplate.CreatorTemplateName != '' && default.SchematicsToPreserve.Find(EquipmentTemplate.CreatorTemplateName) == -1)
		{
			EquipmentTemplate.CreatorTemplateName = '';
			EquipmentTemplate.BaseItem = '';
			EquipmentTemplate.UpgradeItem = '';
		}
		// Mod
		for (i=0; i < ItemTable.Length; ++i)
		{           
			if (EquipmentTemplate.DataName == ItemTable[i].ItemTemplateName)
			{
				EquipmentTemplate.StartingItem = ItemTable[i].Starting;
				EquipmentTemplate.bInfiniteItem = ItemTable[i].Infinite;
				if (!ItemTable[i].Buildable)
					EquipmentTemplate.CanBeBuilt = false;

				if (ItemTable[i].Buildable)
				{
					EquipmentTemplate.CanBeBuilt = true;
					EquipmentTemplate.Requirements.RequiredEngineeringScore = ItemTable[i].RequiredEngineeringScore;
					EquipmentTemplate.PointsToComplete = ItemTable[i].PointsToComplete;
					if (default.INSTANT_BUILD_TIMES)
					{
						EquipmentTemplate.PointsToComplete = 0;
					}
					EquipmentTemplate.Requirements.bVisibleifPersonnelGatesNotMet = true;
					EquipmentTemplate.Cost.ResourceCosts.Length = 0;
					EquipmentTemplate.Cost.ArtifactCosts.Length = 0;
					EquipmentTemplate.Requirements.RequiredTechs.Length = 0;
					if (ItemTable[i].RequiredTech1 != '')
						EquipmentTemplate.Requirements.RequiredTechs.AddItem(ItemTable[i].RequiredTech1);
					if (ItemTable[i].RequiredTech2 != '')
						EquipmentTemplate.Requirements.RequiredTechs.AddItem(ItemTable[i].RequiredTech2);
					if (ItemTable[i].SupplyCost > 0)
					{
						Resources.ItemTemplateName = 'Supplies';
						Resources.Quantity = ItemTable[i].SupplyCost;
						EquipmentTemplate.Cost.ResourceCosts.AddItem(Resources);
					}
					if (ItemTable[i].AlloyCost > 0)
					{
						Resources.ItemTemplateName = 'AlienAlloy';
						Resources.Quantity = ItemTable[i].AlloyCost;
						EquipmentTemplate.Cost.ResourceCosts.AddItem(Resources);
					}
					if (ItemTable[i].CrystalCost > 0)
					{
						Resources.ItemTemplateName = 'EleriumDust';
						Resources.Quantity = ItemTable[i].CrystalCost;
						EquipmentTemplate.Cost.ResourceCosts.AddItem(Resources);
					}
					if (ItemTable[i].CoreCost > 0)
					{
						Resources.ItemTemplateName = 'EleriumCore';
						Resources.Quantity = ItemTable[i].CoreCost;
						EquipmentTemplate.Cost.ResourceCosts.AddItem(Resources);
					}
					if (ItemTable[i].SpecialItemTemplateName != '' && ItemTable[i].SpecialItemCost > 0)
					{
						Resources.ItemTemplateName = ItemTable[i].SpecialItemTemplateName;
						Resources.Quantity = ItemTable[i].SpecialItemCost;
						EquipmentTemplate.Cost.ArtifactCosts.AddItem(Resources);
					}
					if (EquipmentTemplate.InventorySlot == eInvSlot_CombatSim)
					{
						EquipmentTemplate.Requirements.RequiredFacilities.AddItem('OfficerTrainingSchool');
					}
				}
				if (EquipmentTemplate.Abilities.Find('SmallItemWeight') == -1)
				{
					if (ItemTable[i].Weight > 0)
					{
						EquipmentTemplate.Abilities.AddItem ('SmallItemWeight');
						EquipmentTemplate.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, -ItemTable[i].Weight, true);

						//`LOG ("Adding Weight to" @ EquipmentTemplate.DataName);
					}
				}
				//special handling for SLG DLC items
				switch (EquipmentTemplate.DataName)
				{
					case 'SparkRifle_MG':
					case 'SparkRifle_BM':
					case 'PlatedSparkArmor':
					case 'PoweredSparkArmor':
					case 'SparkBit_MG':
					case 'SparkBit_BM':
						AltReq.SpecialRequirementsFn = class'LWDLCHelpers'.static.IsLostTowersNarrativeContentComplete;
						if (ItemTable[i].RequiredTech1 != '')
							AltReq.RequiredTechs.AddItem(ItemTable[i].RequiredTech1);
						Template.AlternateRequirements.AddItem(AltReq);
						break;
					default:
						break;
				}
			}
		}
	}
	
	WeaponUpgradeTemplate = X2WeaponUpgradeTemplate(Template);
	if (WeaponUpgradeTemplate != none)
	{
		//specific alterations
		if (WeaponUpgradeTemplate.DataName == 'AimUpgrade_Bsc')
		{
			WeaponUpgradeTemplate.AimBonus = 0;
			//WeaponUpgradeTemplate.AimBonusNoCover = 0;
			WeaponUpgradeTemplate.AddHitChanceModifierFn = none;
			WeaponUpgradeTemplate.GetBonusAmountFn = none;
			WeaponUpgradeTemplate.BonusAbilities.length = 0;
			WeaponUpgradeTemplate.BonusAbilities.AddItem ('Scope_LW_Bsc_Ability');
		}
		if (WeaponUpgradeTemplate.DataName == 'AimUpgrade_Adv')
		{
			WeaponUpgradeTemplate.AimBonus = 0;
			//WeaponUpgradeTemplate.AimBonusNoCover = 0;
			WeaponUpgradeTemplate.AddHitChanceModifierFn = none;
			WeaponUpgradeTemplate.GetBonusAmountFn = none;
			WeaponUpgradeTemplate.BonusAbilities.length = 0;
			WeaponUpgradeTemplate.BonusAbilities.AddItem ('Scope_LW_Adv_Ability');
		}
		if (WeaponUpgradeTemplate.DataName == 'AimUpgrade_Sup')
		{
			WeaponUpgradeTemplate.AimBonus = 0;
			//WeaponUpgradeTemplate.AimBonusNoCover = 0;
			WeaponUpgradeTemplate.AddHitChanceModifierFn = none;
			WeaponUpgradeTemplate.GetBonusAmountFn = none;
			WeaponUpgradeTemplate.BonusAbilities.length = 0;
			WeaponUpgradeTemplate.BonusAbilities.AddItem ('Scope_LW_Sup_Ability');
		}

		if (WeaponUpgradeTemplate.DataName == 'FreeFireUpgrade_Bsc')
		{
			WeaponUpgradeTemplate.FreeFireChance = 0;
			WeaponUpgradeTemplate.FreeFireCostFn = none;
			WeaponUpgradeTemplate.GetBonusAmountFn = none;
			WeaponUpgradeTemplate.BonusAbilities.length = 0;
			WeaponUpgradeTemplate.BonusAbilities.AddItem ('Hair_Trigger_LW_Bsc_Ability');
		}
		if (WeaponUpgradeTemplate.DataName == 'FreeFireUpgrade_Adv')
		{
			WeaponUpgradeTemplate.FreeFireChance = 0;
			WeaponUpgradeTemplate.FreeFireCostFn = none;
			WeaponUpgradeTemplate.GetBonusAmountFn = none;
			WeaponUpgradeTemplate.BonusAbilities.length = 0;
			WeaponUpgradeTemplate.BonusAbilities.AddItem ('Hair_Trigger_LW_Adv_Ability');
		}
		if (WeaponUpgradeTemplate.DataName == 'FreeFireUpgrade_Sup')
		{
			WeaponUpgradeTemplate.FreeFireChance = 0;
			WeaponUpgradeTemplate.FreeFireCostFn = none;
			WeaponUpgradeTemplate.GetBonusAmountFn = none;
			WeaponUpgradeTemplate.BonusAbilities.length = 0;
			WeaponUpgradeTemplate.BonusAbilities.AddItem ('Hair_Trigger_LW_Sup_Ability');
		}

		if (WeaponUpgradeTemplate.DataName == 'MissDamageUpgrade_Bsc')
		{
			WeaponUpgradeTemplate.BonusDamage.Damage = 0;
			WeaponUpgradeTemplate.GetBonusAmountFn = none;
			WeaponUpgradeTemplate.BonusAbilities.length = 0;
			WeaponUpgradeTemplate.BonusAbilities.AddItem ('Stock_LW_Bsc_Ability');
		}
		if (WeaponUpgradeTemplate.DataName == 'MissDamageUpgrade_Adv')
		{
			WeaponUpgradeTemplate.BonusDamage.Damage = 0;
			WeaponUpgradeTemplate.GetBonusAmountFn = none;
			WeaponUpgradeTemplate.BonusAbilities.length = 0;
			WeaponUpgradeTemplate.BonusAbilities.AddItem ('Stock_LW_Adv_Ability');
		}
		if (WeaponUpgradeTemplate.DataName == 'MissDamageUpgrade_Sup')
		{
			WeaponUpgradeTemplate.BonusDamage.Damage = 0;
			WeaponUpgradeTemplate.GetBonusAmountFn = none;
			WeaponUpgradeTemplate.BonusAbilities.length = 0;
			WeaponUpgradeTemplate.BonusAbilities.AddItem ('Stock_LW_Sup_Ability');
		}
		
		if (WeaponUpgradeTemplate.DataName == 'FreeKillUpgrade_Bsc' || WeaponUpgradeTemplate.DataName == 'FreeKillUpgrade_Adv' || WeaponUpgradeTemplate.DataName == 'FreeKillUpgrade_Sup')
		{
			WeaponUpgradeTemplate.FreeKillChance = 0;
			WeaponUpgradeTemplate.FreeKillFn = none;
			WeaponUpgradeTemplate.GetBonusAmountFn = none;
			//Abilities are caught elsewhere
		}

		//Config-able items array -- Weapon Upgrades
		for (i=0; i < ItemTable.Length; ++i)
		{           
			if (WeaponUpgradeTemplate.DataName == ItemTable[i].ItemTemplateName)
			{
				WeaponUpgradeTemplate.StartingItem = ItemTable[i].Starting;
				WeaponUpgradeTemplate.bInfiniteItem = ItemTable[i].Infinite;
				if (!ItemTable[i].Buildable)
					WeaponUpgradeTemplate.CanBeBuilt = false;
				if (ItemTable[i].Buildable)
				{
					WeaponUpgradeTemplate.CanBeBuilt = true;
					WeaponUpgradeTemplate.Requirements.RequiredEngineeringScore = ItemTable[i].RequiredEngineeringScore;
					WeaponUpgradeTemplate.PointsToComplete = ItemTable[i].PointsToComplete;
					WeaponUpgradeTemplate.Requirements.bVisibleifPersonnelGatesNotMet = true;
					WeaponUpgradeTemplate.Cost.ResourceCosts.Length = 0;
					WeaponUpgradeTemplate.Cost.ArtifactCosts.Length = 0;
					WeaponUpgradeTemplate.Requirements.RequiredTechs.Length = 0;
					if (ItemTable[i].RequiredTech1 != '')
					{
						WeaponUpgradeTemplate.Requirements.RequiredTechs.AddItem(ItemTable[i].RequiredTech1);
					}
					if (ItemTable[i].RequiredTech2 != '')
						WeaponUpgradeTemplate.Requirements.RequiredTechs.AddItem(ItemTable[i].RequiredTech2);
					if (ItemTable[i].SupplyCost > 0)
					{
						Resources.ItemTemplateName = 'Supplies';
						Resources.Quantity = ItemTable[i].SupplyCost;
						WeaponUpgradeTemplate.Cost.ResourceCosts.AddItem(Resources);
					}
					if (ItemTable[i].AlloyCost > 0)
					{
						Resources.ItemTemplateName = 'AlienAlloy';
						Resources.Quantity = ItemTable[i].AlloyCost;
						WeaponUpgradeTemplate.Cost.ResourceCosts.AddItem(Resources);
					}
					if (ItemTable[i].CrystalCost > 0)
					{
						Resources.ItemTemplateName = 'EleriumDust';
						Resources.Quantity = ItemTable[i].CrystalCost;
						WeaponUpgradeTemplate.Cost.ResourceCosts.AddItem(Resources);
					}
					if (ItemTable[i].CoreCost > 0)
					{
						Resources.ItemTemplateName = 'EleriumCore';
						Resources.Quantity = ItemTable[i].CoreCost;
						WeaponUpgradeTemplate.Cost.ResourceCosts.AddItem(Resources);
					}
					if (ItemTable[1].SpecialItemTemplateName != '' && ItemTable[i].SpecialItemCost > 0)
					{
						Resources.ItemTemplateName = ItemTable[i].SpecialItemTemplateName;
						Resources.Quantity = ItemTable[i].SpecialItemCost;
						WeaponUpgradeTemplate.Cost.ArtifactCosts.AddItem(Resources);
					}

					if (default.INSTANT_BUILD_TIMES)
					{       
						WeaponUpgradeTemplate.PointsToComplete = 0;
					}

				}
			}
		}
	}
}

static function X2LWTemplateModTemplate CreateRewireTechTreeTemplate()
{
	local X2LWTemplateModTemplate Template;

	`CREATE_X2TEMPLATE(class'X2LWTemplateModTemplate', Template, 'RewireTechTree');
	Template.StrategyElementTemplateModFn = RewireTechTree;
	return Template;
}

function RewireTechTree(X2StrategyElementTemplate Template, int Difficulty)
{
	local int                       i;
	local ArtifactCost              Resources;
	local X2TechTemplate            TechTemplate;
	
	TechTemplate=X2TechTemplate(Template);
	If (TechTemplate != none)
	{
		// Disable breakthrough projects for now
		if (TechTemplate.bBreakthrough)
		{
			TechTemplate.Requirements.RequiredScienceScore = 99999;
		}

		//required by objective rework
		if (TechTemplate.DataName == 'ResistanceCommunications')
		{
			TechTemplate.Requirements.RequiredObjectives.length = 0;
			Resources.ItemTemplateName = 'Intel';
			Resources.Quantity = default.ResistanceCommunicationsIntelCost;
			TechTemplate.Cost.ResourceCosts.AddItem(Resources);
		}

		if (TechTemplate.DataName == 'ResistanceRadio')
		{
			TechTemplate.Requirements.RequiredObjectives.length = 0;
			Resources.ItemTemplateName = 'Intel';
			Resources.Quantity = default.ResistanceRadioIntelCost;
			TechTemplate.Cost.ResourceCosts.AddItem(Resources);
		}

		switch (TechTemplate.DataName)
		{
			case 'AlienEncryption':
				Resources.ItemTemplateName = 'Intel';
				Resources.Quantity = default.AlienEncryptionIntelCost;
				if (Resources.Quantity > 0)
					TechTemplate.Cost.ResourceCosts.AddItem(Resources);
				break;
			case 'CodexBrainPt1':
				Resources.ItemTemplateName = 'Intel';
				Resources.Quantity = default.CodexBrainPt1IntelCost;
				if (Resources.Quantity > 0)
					TechTemplate.Cost.ResourceCosts.AddItem(Resources);
				break;
			case 'CodexBrainPt2':
				Resources.ItemTemplateName = 'Intel';
				Resources.Quantity = default.CodexBrainPt2IntelCost;
				if (Resources.Quantity > 0)
					TechTemplate.Cost.ResourceCosts.AddItem(Resources);
				break;
			case 'BlacksiteData':
				Resources.ItemTemplateName = 'Intel';
				Resources.Quantity = default.BlacksiteDataIntelCost;
				if (Resources.Quantity > 0)
					TechTemplate.Cost.ResourceCosts.AddItem(Resources);
				break;
			case 'ForgeStasisSuit':
				Resources.ItemTemplateName = 'Intel';
				Resources.Quantity = default.ForgeStasisSuitIntelCost;
				if (Resources.Quantity > 0)
					TechTemplate.Cost.ResourceCosts.AddItem(Resources);
				break;
			case 'PsiGate':
				Resources.ItemTemplateName = 'Intel';
				Resources.Quantity = default.PsiGateIntelCost;
				if (Resources.Quantity > 0)
					TechTemplate.Cost.ResourceCosts.AddItem(Resources);
				break;
			case 'AutopsyAdventPsiWitch':
				Resources.ItemTemplateName = 'Intel';
				Resources.Quantity = default.AutopsyAdventPsiWitchIntelCost;
				if (Resources.Quantity > 0)
					TechTemplate.Cost.ResourceCosts.AddItem(Resources);
				break;
			default:
				break;
		}
		
		if (TechTemplate.DataName == 'Tech_AlienFacilityLead')
		{
			TechTemplate.ResearchCompletedFn = class'X2StrategyElement_DefaultAlienActivities'.static.FacilityLeadCompleted;
			TechTemplate.Requirements.SpecialRequirementsFn = none; // remove the base-game requirement, since it is now handled elsewhere
			TechTemplate.RepeatPointsIncrease = default.ALIEN_FACILITY_LEAD_RP_INCREMENT;
			TechTemplate.Cost.ResourceCosts.Length = 0;
			Resources.ItemTemplateName = 'Intel';
			Resources.Quantity = default.ALIEN_FACILITY_LEAD_INTEL;
			TechTemplate.Cost.ResourceCosts.AddItem(Resources);
		}

		if (TechTemplate.DataName == 'SpiderSuit')
			TechTemplate.bRepeatable = false;
		if (TechTemplate.DataName == 'ExoSuit')
			TechTemplate.bRepeatable = false;
		if (TechTemplate.DataName == 'WraithSuit')
			TechTemplate.bRepeatable = false;
		if (TechTemplate.DataName == 'WarSuit')
			TechTemplate.bRepeatable = false;
		if (TechTemplate.DataName == 'ShredstormCannonProject')
			TechTemplate.bRepeatable = false;
		if (TechTemplate.DataName == 'PlasmaBlasterProject')
			TechTemplate.bRepeatable = false;
		if (TechTemplate.DataName == 'Skulljack')
			TechTemplate.bRepeatable = false;

		if (TechTemplate.DataName == 'HeavyWeapons') // remove the alternative access to the heavy weapons proving ground project for sparks
			TechTemplate.AlternateRequirements.Length = 0;

		// Change the special requirements functions for Mechanized Warfare & SPARKs.
		if (TechTemplate.DataName == 'MechanizedWarfare')
			TechTemplate.Requirements.SpecialRequirementsFn = class'LWDLCHelpers'.static.IsMechanizedWarfareAvailable;
		if (TechTemplate.DataName == 'BuildSpark')
			TechTemplate.Requirements.SpecialRequirementsFn = class'LWDLCHelpers'.static.IsLostTowersNarrativeContentComplete;

		// remove the alternative access to the advanced heavy weapons proving ground project HeavyAlienArmorMk2_Schematic
		// from Alien Hunters.
		if (TechTemplate.DataName == 'AdvancedHeavyWeapons')
			TechTemplate.AlternateRequirements.Length = 0;

		for (i=0; i < TechTable.Length; ++i)
		{
			if (TechTemplate.DataName == TechTable[i].TechTemplateName)
			{
				TechTemplate.bProvingGround = TechTable[i].ProvingGround;
				TechTemplate.PointsToComplete = TechTable[i].ResearchPointCost;
				TechTemplate.Requirements.RequiredScienceScore=TechTable[i].RequiredScienceScore;
				TechTemplate.Requirements.RequiredEngineeringScore=TechTable[i].RequiredEngineeringScore;
				if (TechTable[i].RequiredScienceScore == 99999)
				{
					TechTemplate.Requirements.bVisibleIfPersonnelGatesNotMet = false;
				}
				else
				{
					TechTemplate.Requirements.bVisibleIfPersonnelGatesNotMet = true;
				}
				if (!TechTable[i].ModPointsToCompleteOnly)
				{
					TechTemplate.Cost.ResourceCosts.Length = 0;
					TechTemplate.Cost.ArtifactCosts.Length = 0;
					TechTemplate.Requirements.RequiredItems.Length = 0;
					if (TechTable[i].SupplyCost > 0)
					{
						Resources.ItemTemplateName = 'Supplies';
						Resources.Quantity = TechTable[i].SupplyCost;
						TechTemplate.Cost.ResourceCosts.AddItem(Resources);
					}
					if (TechTable[i].AlloyCost > 0)
					{
						Resources.ItemTemplateName = 'AlienAlloy';
						Resources.Quantity = TechTable[i].AlloyCost;
						TechTemplate.Cost.ResourceCosts.AddItem(Resources);
					}
					if (TechTable[i].CrystalCost > 0)
					{
						Resources.ItemTemplateName = 'EleriumDust';
						Resources.Quantity = TechTable[i].CrystalCost;
						TechTemplate.Cost.ResourceCosts.AddItem(Resources);
					}
					if (TechTable[i].CoreCost > 0)
					{
						Resources.ItemTemplateName = 'EleriumCore';
						Resources.Quantity = TechTable[i].CoreCost;
						TechTemplate.Cost.ResourceCosts.AddItem(Resources);
					}
					if (TechTable[i].ReqItemTemplateName1 != '' && TechTable[i].ReqItemCost1 > 0)
					{
						Resources.ItemTemplateName = TechTable[i].ReqItemTemplateName1;
						Resources.Quantity = TechTable[i].ReqItemCost1;
						TechTemplate.Cost.ArtifactCosts.AddItem(Resources);
						if (!TechTemplate.bProvingGround)
						{
							TechTemplate.Requirements.RequiredItems.AddItem(TechTable[i].ReqItemTemplateName1);
						}
					}
					TechTemplate.bCheckForceInstant = false;
					if (TechTable[i].ReqItemTemplateName2 != '' && TechTable[i].ReqItemCost2 > 0)
					{
						if (TechTable[i].ReqItemTemplateName2 == 'Instant')
						{
							Resources.ItemTemplateName = TechTable[i].ReqItemTemplateName1;
							Resources.Quantity = TechTable[i].ReqItemCost1 * TechTable[i].ReqItemCost2;
							TechTemplate.InstantRequirements.RequiredItemQuantities.AddItem(Resources);
							TechTemplate.bCheckForceInstant = true;
						}
						else
						{
							Resources.ItemTemplateName = TechTable[i].ReqItemTemplateName2;
							Resources.Quantity = TechTable[i].ReqItemCost2;
							TechTemplate.Cost.ArtifactCosts.AddItem(Resources);
							if (!TechTemplate.bProvingGround)
							{
								TechTemplate.Requirements.RequiredItems.AddItem(TechTable[i].ReqItemTemplateName2);
							}
						}
					}
					TechTemplate.Requirements.RequiredTechs.Length = 0;
					if (TechTable[i].PrereqTech1 != '')
						TechTemplate.Requirements.RequiredTechs.AddItem(TechTable[i].PrereqTech1);
					if (TechTable[i].PrereqTech2 != '')
						TechTemplate.Requirements.RequiredTechs.AddItem(TechTable[i].PrereqTech2);
					if (TechTable[i].PrereqTech3 != '')
						TechTemplate.Requirements.RequiredTechs.AddItem(TechTable[i].PrereqTech3);
					if (TechTable[i].ItemGranted != '')
					{
						if (TechTable[i].ItemGranted != 'nochange')
						{
							TechTemplate.ResearchCompletedFn = none;
							TechTemplate.ItemRewards.Length = 0;
							if (TechTable[i].ItemGranted != 'clear')
							{
								TechTemplate.ResearchCompletedFn = class'X2StrategyElement_DefaultTechs'.static.GiveRandomItemReward;
								TechTemplate.ItemRewards.AddItem(TechTable[i].ItemGranted);
							}
						}
					}
				}
			}
		}
	}
}

static function X2LWTemplateModTemplate CreateEditGTSProjectsTemplate()
{
	local X2LWTemplateModTemplate Template;

	`CREATE_X2TEMPLATE(class'X2LWTemplateModTemplate', Template, 'EditGTSProjectsTree');
	Template.StrategyElementTemplateModFn = EditGTSProjects;
	return Template;
}

function EditGTSProjects(X2StrategyElementTemplate Template, int Difficulty)
{
	local int                       i;
	local ArtifactCost              Resources;
	local X2SoldierUnlockTemplate   GTSTemplate;

	GTSTemplate = X2SoldierUnlockTemplate (Template);
	if (GTSTemplate != none)
	{
		for (i=0; i < GTSTable.Length; ++i)
		{
			if (GTSTemplate.DataName == GTSTable[i].GTSProjectTemplateName)
			{
				GTSTemplate.Cost.ResourceCosts.Length=0;
				if (GTSTable[i].SupplyCost > 0)
				{
					Resources.ItemTemplateName = 'Supplies';
					Resources.Quantity = GTSTable[i].SupplyCost;
					GTSTemplate.Cost.ResourceCosts.AddItem(Resources);
				}
				GTSTemplate.Requirements.RequiredHighestSoldierRank = GTSTable[i].RankRequired;
				//bVisibleIfSoldierRankGatesNotMet does not work
				GTSTemplate.Requirements.bVisibleIfSoldierRankGatesNotMet = !GTSTable[i].HideIfInsufficientRank;
				GTSTemplate.AllowedClasses.Length = 0;
				GTSTemplate.Requirements.RequiredSoldierClass = '';
				if (GTSTable[i].UniqueClass != '')
				{
					GTSTemplate.Requirements.RequiredSoldierRankClassCombo = true;
					GTSTemplate.AllowedClasses.AddItem(GTSTable[i].UniqueClass);
					GTSTemplate.Requirements.RequiredSoldierClass = GTSTable[i].UniqueClass;
				}
				else
				{
					GTSTemplate.bAllClasses=true;
				}
			}
		}
	}
}

static function X2LWTemplateModTemplate CreateReconfigFacilitiesTemplate()
{
	local X2LWTemplateModTemplate Template;

	`CREATE_X2TEMPLATE(class'X2LWTemplateModTemplate', Template, 'ReconfigFacilities');
	Template.StrategyElementTemplateModFn = ReconfigFacilities;
	return Template;
}

function ReconfigFacilities(X2StrategyElementTemplate Template, int Difficulty)
{
	local int                       i;
	local ArtifactCost              Resources;
	local X2FacilityTemplate        FacilityTemplate;
	local StaffSlotDefinition       StaffSlotDef;

	FacilityTemplate = X2FacilityTemplate (Template);
	if (FacilityTemplate != none)
	{
		if (FacilityTemplate.DataName == 'OfficerTrainingSchool')
		{
			FacilityTemplate.SoldierUnlockTemplates.RemoveItem('HuntersInstinctUnlock');
			FacilityTemplate.SoldierUnlockTemplates.RemoveItem('HitWhereItHurtsUnlock');
			FacilityTemplate.SoldierUnlockTemplates.RemoveItem('CoolUnderPressureUnlock');
			FacilityTemplate.SoldierUnlockTemplates.RemoveItem('BiggestBoomsUnlock');
			FacilityTemplate.SoldierUnlockTemplates.RemoveItem('SquadSizeIUnlock');
			FacilityTemplate.SoldierUnlockTemplates.RemoveItem('SquadSizeIIUnlock');
			FacilityTemplate.SoldierUnlockTemplates.AddItem('VultureUnlock');
			FacilityTemplate.SoldierUnlockTemplates.AddItem('VengeanceUnlock');
			FacilityTemplate.SoldierUnlockTemplates.AddItem('WetWorkUnlock');
			FacilityTemplate.SoldierUnlockTemplates.AddItem('LightningStrikeUnlock');
			FacilityTemplate.SoldierUnlockTemplates.AddItem('IntegratedWarfareUnlock');
			FacilityTemplate.SoldierUnlockTemplates.AddItem('StayWithMeUnlock');
			FacilityTemplate.SoldierUnlockTemplates.AddItem('Infiltration1Unlock');
			FacilityTemplate.SoldierUnlockTemplates.AddItem('Infiltration2Unlock');
		}
		if (FacilityTemplate.DataName == 'Laboratory')
		{
			StaffSlotDef.StaffSlotTemplateName = 'LaboratoryStaffSlot';
			StaffSlotDef.bStartsLocked = true;
			FacilityTemplate.StaffSlotDefs.AddItem(StaffSlotDef);
			FacilityTemplate.StaffSlotDefs.AddItem(StaffSlotDef);
			FacilityTemplate.Upgrades.AddItem('Laboratory_AdditionalResearchStation2');
			FacilityTemplate.Upgrades.AddItem('Laboratory_AdditionalResearchStation3');
		}
		if (FacilityTemplate.DataName == 'ProvingGround')
		{
			StaffSlotDef.StaffSlotTemplateName = 'ProvingGroundStaffSlot';
			StaffSlotDef.bStartsLocked = false;
			FacilityTemplate.StaffSlotDefs.AddItem(StaffSlotDef);
		}
		if (FacilityTemplate.DataName == 'PsiChamber')
		{
			StaffSlotDef.StaffSlotTemplateName = 'PsiChamberScientistStaffSlot';
			StaffSlotDef.bStartsLocked = false;
			FacilityTemplate.StaffSlotDefs.InsertItem(1, StaffSlotDef);
		}
		//if (FacilityTemplate.DataName == 'Storage') Didn't work
		//{
			//FacilityTemplate.StaffSlots.AddItem('SparkStaffSlot');
			//FacilityTemplate.StaffSlots.AddItem('SparkStaffSlot');
			//FacilityTemplate.StaffSlotsLocked = 3;
		//}

		// --- HACK HACK HACK --- 
		//
		// To allow debugging XcomGame with AH installed you need to uncomment this to strip the aux map from the hangar template.
		// The game will loop forever in the avenger waiting for the aux content to load unless this is done, because the content
		// is provided only in a cooked seek-free package and debugging always loads -noseekfreepackages. Thus the package is never
		// loaded and the process will never complete. I am not leaving this uncommented because doing so will leave a gap in the
		// avenger map where the hangar is supposed to be. Even with this expect a bazillion redscreens about missing content for
		// DLC1/2/3. If you need to do a lot of debugging in XComGame consider uninstalling the DLCs first to cut down redscreen spam.
		//
		// --- HACK HACK HACK ---
		/*
		if (FacilityTemplate.DataName == 'Hangar')
		{
			`Log("Found hangar with " $ FacilityTemplate.AuxMaps.Length $ " aux maps");
			for( i = 0; i < FacilityTemplate.AuxMaps.length; ++i)
			{
				`Log("Aux map: " $ FacilityTemplate.AuxMaps[i].MapName);
				if (InStr(FacilityTemplate.AuxMaps[i].MapName, "DLC2") >= 0)
				{
					FacilityTemplate.AuxMaps.Remove(i, 1);
					--i;
				}
			}
			FacilityTemplate.AuxMaps.Length = 0;
		}
		*/

		for (i=0; i < FacilityTable.Length; ++i)
		{
			if (FacilityTemplate.DataName == FacilityTable[i].FacilityTemplateName)
			{
				FacilityTemplate.PointsToComplete = class'X2StrategyElement_DefaultFacilities'.static.GetFacilityBuildDays(FacilityTable[i].BuildDays);
				FacilityTemplate.iPower = FacilityTable[i].Power;
				FacilityTemplate.UpkeepCost = FacilityTable[i].UpkeepCost;
				FacilityTemplate.Requirements.RequiredTechs.length = 0;
				if (FacilityTable[i].RequiredTech != '')
					FacilityTemplate.Requirements.RequiredTechs.AddItem(FacilityTable[i].RequiredTech);
				
				FacilityTemplate.Cost.ResourceCosts.Length = 0;
				FacilityTemplate.Cost.ArtifactCosts.Length = 0;             

				if (FacilityTable[i].SupplyCost > 0)
				{
					Resources.ItemTemplateName = 'Supplies';
					Resources.Quantity = FacilityTable[i].SupplyCost;
					FacilityTemplate.Cost.ResourceCosts.AddItem(Resources);
				}
				if (FacilityTable[i].AlloyCost > 0)
				{
					Resources.ItemTemplateName = 'AlienAlloy';
					Resources.Quantity = FacilityTable[i].AlloyCost;
					FacilityTemplate.Cost.ResourceCosts.AddItem(Resources);
				}
				if (FacilityTable[i].CrystalCost > 0)
				{
					Resources.ItemTemplateName = 'EleriumDust';
					Resources.Quantity = FacilityTable[i].CrystalCost;
					FacilityTemplate.Cost.ResourceCosts.AddItem(Resources);
				}
				if (FacilityTable[i].CoreCost > 0)
				{
					Resources.ItemTemplateName = 'EleriumCore';
					Resources.Quantity = FacilityTable[i].CoreCost;
					FacilityTemplate.Cost.ResourceCosts.AddItem(Resources);
				}
			}
		}
	}
}

static function X2LWTemplateModTemplate CreateReconfigStaffSlotsTemplate()
{
	local X2LWTemplateModTemplate Template;

	`CREATE_X2TEMPLATE(class'X2LWTemplateModTemplate', Template, 'ReconfigStaffSlots');
	Template.StrategyElementTemplateModFn = ReconfigStaffSlots;
	return Template;
}

function ReconfigStaffSlots(X2StrategyElementTemplate Template, int Difficulty)
{
	local X2StaffSlotTemplate   StaffSlotTemplate;

	StaffSlotTemplate = X2StaffSlotTemplate (Template);
	if (StaffSlotTemplate != none)
	{
		if (StaffSlotTemplate.DataName == 'AWCScientistStaffSlot')
		{
			StaffSlotTemplate.bEngineerSlot = false;
			StaffSlotTemplate.bScientistSlot = true;
			StaffSlotTemplate.MatineeSlotName = "Scientist";
		}
		else if (StaffSlotTemplate.DataName == 'PsiChamberScientistStaffSlot')
		{
			StaffSlotTemplate.bEngineerSlot = false;
			StaffSlotTemplate.bScientistSlot = true;
			StaffSlotTemplate.MatineeSlotName = "Scientist";
		}
		else if(StaffSlotTemplate.DataName == 'OTSStaffSlot')
		{
			StaffSlotTemplate.IsUnitValidForSlotFn = IsUnitValidForOTSSoldierSlot;
		}
		else if(StaffSlotTemplate.DataName == 'PsiChamberSoldierStaffSlot')
		{
			StaffSlotTemplate.IsUnitValidForSlotFn = IsUnitValidForPsiChamberSoldierSlot;
		}
		else if (StaffSlotTemplate.DataName == 'AWCSoldierStaffSlot')
		{
			StaffSlotTemplate.IsUnitValidForSlotFn = IsUnitValidForAWCSoldierSlot;
		}
		else if (StaffSlotTemplate.DataName == 'ResCommsStaffSlot')
		{
			StaffSlotTemplate.GetContributionFromSkillFn = SubstitueResCommStaffFn;
		}
		else if (StaffSlotTemplate.DataName == 'ResCommsBetterStaffSlot')
		{
			StaffSlotTemplate.GetContributionFromSkillFn = SubstitueBetterResCommStaffFn;
		}
		else if (StaffSlotTemplate.DataName == 'SparkStaffSlot')
		{
			StaffSlotTemplate.IsUnitValidForSlotFn = IsUnitValidForSparkSlotWithInfiltration;

			// DLC3 doesn't update the unit status when adding units to or removing them
			// from the repair slot. So provide our own that do that.
			StaffSlotTemplate.FillFn = FillSparkSlotAndSetHealing;
			StaffSlotTemplate.EmptyFn = EmptySparkSlotAndSetActive;
		}
	}
}

static function int SubstitueResCommStaffFn(XComGameState_Unit Unit)
{
	return default.RESCOMMS_1ST_ENGINEER_BONUS;
}

static function int SubstitueBetterResCommStaffFn(XComGameState_Unit Unit)
{
	return default.RESCOMMS_2ND_ENGINEER_BONUS;
}
	
// this is an override for the rookie training slot, to disallow training of soldiers currently on a mission
static function bool IsUnitValidForOTSSoldierSlot(XComGameState_StaffSlot SlotState, StaffUnitInfo UnitInfo)
{
	local XComGameState_Unit Unit;

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitInfo.UnitRef.ObjectID));
	if(class'LWDLCHelpers'.static.IsUnitOnMission(Unit))
		return false;

	return class'X2StrategyElement_DefaultStaffSlots'.static.IsUnitValidForOTSSoldierSlot(SlotState, UnitInfo);
}


// this is an override for the psi training slot, to disallow training of soldiers currently on a mission
static function bool IsUnitValidForPsiChamberSoldierSlot(XComGameState_StaffSlot SlotState, StaffUnitInfo UnitInfo)
{
	local XComGameState_Unit Unit;
	local X2SoldierClassTemplate SoldierClassTemplate;
	local SCATProgression ProgressAbility;
	local name AbilityName;
	local array<SoldierClassAbilityType> AllPsiAbilities;
	local SoldierClassAbilityType PsiAbility;

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitInfo.UnitRef.ObjectID));
	
	`LWTrace("Checking whether " $ Unit.GetName(eNameType_Full) $ " is valid for PsiChamber");
	if(class'LWDLCHelpers'.static.IsUnitOnMission(Unit)) // needed to work with infiltration system
		return false;

	if (Unit.CanBeStaffed()
		&& Unit.IsSoldier()
		&& !Unit.IsInjured()
		&& !Unit.IsTraining()
		&& !Unit.IsPsiTraining()
		&& !Unit.IsPsiAbilityTraining()
		&& SlotState.GetMyTemplate().ExcludeClasses.Find(Unit.GetSoldierClassTemplateName()) == INDEX_NONE)
	{
		if (Unit.GetRank() == 0 && !Unit.CanRankUpSoldier()) // All rookies who have not yet ranked up can be trained as Psi Ops
		{
			`LWTrace("Rookie! Can train as PsiOp");
			return true;
		}
		else if (Unit.IsPsiOperative()) // Psi Ops can only train if there are abilities left
		{ 
			`LWTrace("This is a PsiOp - need to check whether they can rank up");
			SoldierClassTemplate = Unit.GetSoldierClassTemplate();
			if (class'Utilities_PP_LW'.static.CanRankUpPsiSoldier(Unit)) // LW2 override, this limits to 8 abilities
			{
				// WOTC TODO: Need to test soldier selection for Psi Chamber. This may not work as it includes
				// a random deck of abilities. I don't know if it's possible to distinguish between Psi abilities
				// and others
				AllPsiAbilities = SoldierClassTemplate.GetAllPossibleAbilities();
				foreach AllPsiAbilities(PsiAbility)
				{
					`Log("Checking for (Psi?) ability " $ PsiAbility.AbilityName $ " (" $ PsiAbility.UtilityCat $ ")");
					if (PsiAbility.AbilityName != '' && !Unit.HasSoldierAbility(PsiAbility.AbilityName))
					{
						return true; // If we find an ability that the soldier hasn't learned yet, they are valid
					}
				}
			}
		}
	}
	return false;
}

// this is an override for the AWC class ability re-training slot, to disallow training of soldiers currently on a mission
static function bool IsUnitValidForAWCSoldierSlot(XComGameState_StaffSlot SlotState, StaffUnitInfo UnitInfo)
{
	local XComGameState_Unit Unit;

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitInfo.UnitRef.ObjectID));
	if(class'LWDLCHelpers'.static.IsUnitOnMission(Unit))
		return false;

	return class'X2StrategyElement_DefaultStaffSlots'.static.IsUnitValidForAWCSoldierSlot(SlotState, UnitInfo);
}

// this is an override for the DLC3 spark healing slot, to disallow healing of sparks currently on a mission
static function bool IsUnitValidForSparkSlotWithInfiltration(XComGameState_StaffSlot SlotState, StaffUnitInfo UnitInfo)
{
	local XComGameState_Unit Unit;

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitInfo.UnitRef.ObjectID));
	
	if (Unit.IsAlive()
		&& Unit.GetMyTemplate().bStaffingAllowed
		&& Unit.GetReference().ObjectID != SlotState.GetAssignedStaffRef().ObjectID
		&& Unit.IsSoldier()
		&& Unit.IsInjured()
		&& Unit.GetMyTemplateName() == 'SparkSoldier'
		&& !class'LWDLCHelpers'.static.IsUnitOnMission(Unit)) // added condition to prevent healing spark units on mission here
	{
		return true;
	}

	return false;
}

static function FillSparkSlotAndSetHealing(XComGameState NewGameState, StateObjectReference SlotRef, StaffUnitInfo UnitInfo, optional bool bTemporary = false)
{
	local XComGameState_Unit NewUnitState;

	NewUnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', UnitInfo.UnitRef.ObjectID));

	class'X2StrategyElement_DLC_Day90StaffSlots'.static.FillSparkSlot(NewGameState, SlotRef, UnitInfo, bTemporary);

	NewUnitState.SetStatus(eStatus_Healing);
}

static function EmptySparkSlotAndSetActive(XComGameState NewGameState, StateObjectReference SlotRef)
{
	local XComGameState_StaffSlot SlotState;
	local XComGameState_Unit NewUnitState;

	SlotState = XComGameState_StaffSlot(`XCOMHISTORY.GetGameStateForObjectID(SlotRef.ObjectID));
	NewUnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', SlotState.AssignedStaff.UnitRef.ObjectID));

	class'X2StrategyElement_DLC_Day90StaffSlots'.static.EmptySparkSlot(NewGameState, SlotRef);

	NewUnitState.SetStatus(eStatus_Active);
}

static function X2LWTemplateModTemplate CreateRecoverItemTemplate()
{
	local X2LWTemplateModTemplate Template;

	`CREATE_X2TEMPLATE(class'X2LWTemplateModTemplate', Template, 'RecoverItem');
	Template.MissionNarrativeTemplateModFn = RecoverItemNarrativeMod;
	return Template;
}

function bool ExpectNarrativeCount(X2MissionNarrativeTemplate Template, int Cnt)
{
	// We better have 24 items as the narrative # we want is in the objective map Kismet.
	if(Template.NarrativeMoments.Length != Cnt)
	{
		`redscreen("LWTemplateMods: Found too many narrative moments for " $ Template.DataName);
		`log("LWTemplateMods: Found too many narrative moments for " $ Template.DataName);
		return false;
	}

	return true;
}

function RecoverItemNarrativeMod(X2MissionNarrativeTemplate Template)
{
	switch(Template.DataName)
	{
	case 'DefaultRecover':
	case 'DefaultRecover_ADV':
	case 'DefaultRecover_Train':
	case 'DefaultRecover_Vehicle':
		if (ExpectNarrativeCount(Template, 24))
		{
			Template.NarrativeMoments[24] = "X2NarrativeMoments.TACTICAL.Blacksite.BlackSite_SecureRetreat";
		}
		break;
	case 'DefaultHack':
	case 'DefaultHack_ADV':
	case 'DefaultHack_Train':
		if (ExpectNarrativeCount(Template, 22))
		{
			Template.NarrativeMoments[22] = "X2NarrativeMoments.TACTICAL.Blacksite.BlackSite_SecureRetreat";
		}
		break;
	case 'DefaultDestroyRelay':
		if (ExpectNarrativeCount(Template, 20))
		{
			Template.NarrativeMoments[20] = "X2NarrativeMoments.TACTICAL.Blacksite.BlackSite_SecureRetreat";
			Template.NarrativeMoments[21] = "X2NarrativeMoments.TACTICAL.General.CEN_Gen_SecureRetreat_03";
		}
	default:
		break;
	}
}

static function X2LWTemplateModTemplate CreateRemovePPClassesTemplate()
{
	local X2LWTemplateModTemplate Template;

	//`LOG("PP: 0");
	`CREATE_X2TEMPLATE(class'X2LWTemplateModTemplate', Template, 'RemovePPClasses');
	Template.SoldierClassTemplateModFn = RemovePPClasses;
	return Template;
}

//this makes sure perkpack classes do not show up
function RemovePPClasses(X2SoldierClassTemplate Template, int Difficulty)
{
	//`LOG ("PP: 1");
	if (Template != none)
	{
		//`LOG ("PP: 2");
		switch (Template.DataName)
		{
			case 'LW_Assault':
			case 'LW_Shinobi':
			case 'LW_Sharpshooter':
			case 'LW_Ranger':
			case 'LW_Gunner':
			case 'LW_Grenadier':
			case 'LW_Specialist':
				//`LOG ("PP: 3");
				Template.NumInForcedDeck = 0;
				Template.NumInDeck = 0;
				break;
			default:
				break;
		}
		Template.KillAssistsPerKill = 0;
	}
}

static function X2LWTemplateModTemplate CreateModifyDarkEventsTemplate()
{
	local X2LWTemplateModTemplate Template;

	`CREATE_X2TEMPLATE(class'X2LWTemplateModTemplate', Template, 'ModifyDarkEvents');
	Template.StrategyElementTemplateModFn = ModifyDarkEvents;
	return Template;
}

function ModifyDarkEvents (X2StrategyElementTemplate Template, int Difficulty)
{
	local X2DarkEventTemplate DarkEventTemplate;
	
	DarkEventTemplate = X2DarkEventTemplate (Template);
	if (DarkEventTemplate != none)
	{
		DarkEventTemplate.bNeverShowObjective = true; // this is added so no Dark Events show in the objective list, since it would get overwhelmed
		switch (DarkEventTemplate.DataName)
		{
			case 'DarkEvent_NewConstruction':
			case 'DarkEvent_RuralCheckpoints':
			case 'DarkEvent_BendingReed':
			case 'DarkEvent_CollateralDamage':
			case 'DarkEvent_StilettoRounds':
			case 'DarkEvent_SignalJamming':
			case 'DarkEvent_GoneToGround':
				// Remove these from play
				DarkEventTemplate.StartingWeight = 0;
				DarkEventTemplate.MinWeight = 0;
				DarkEventTemplate.MaxWeight = 0;
				break;
			case 'DarkEvent_AlloyPadding': DarkEventTemplate.bInfiniteDuration = true; DarkEventTemplate.bRepeatable = false; DarkEventTemplate.CanActivateFn = class 'X2StrategyElement_DarkEvents_LW'.static.CanActivateCodexUpgrade; break;
			case 'DarkEvent_ViperRounds': DarkEventTemplate.bInfiniteDuration = true; DarkEventTemplate.bRepeatable = false; break;
			case 'DarkEvent_AlienCypher': 
				DarkEventTemplate.OnActivatedFn = class'X2StrategyElement_DarkEvents_LW'.static.ActivateAlienCypher_LW; 
				DarkEventTemplate.OnDeactivatedFn = class'X2StrategyElement_DarkEvents_LW'.static.DeactivateAlienCypher_LW;
				break;
			case 'DarkEvent_ResistanceInformant':
				DarkEventTemplate.MinDurationDays = 21;
				DarkEventTemplate.MaxDurationDays = 28;
				DarkEventTemplate.GetSummaryFn = GetResistanceInformantSummary;
				break;
			case 'DarkEvent_MinorBreakthrough':
				DarkEventTemplate.MinActivationDays = 15;
				DarkEventTemplate.MaxActivationDays = 20;
				DarkEventTemplate.MutuallyExclusiveEvents.AddItem('DarkEvent_MinorBreakthrough2');
				DarkEventTemplate.MutuallyExclusiveEvents.AddItem('DarkEvent_MajorBreakthrough2');
				DarkEventTemplate.CanActivateFn = class'X2StrategyElement_DarkEvents_LW'.static.CanActivateMinorBreakthroughAlt; // Will check for whether avatar project has been revealed
				DarkEventTemplate.OnActivatedFn = class'X2StrategyElement_DarkEvents_LW'.static.ActivateMinorBreakthroughMod;
				`LWTRACE("Redefined Minor Breakthrough Dark Event Template");
				break;
			case 'DarkEvent_MajorBreakthrough':
				DarkEventTemplate.MutuallyExclusiveEvents.AddItem('DarkEvent_MinorBreakthrough2');
				DarkEventTemplate.MutuallyExclusiveEvents.AddItem('DarkEvent_MajorBreakthrough2');
				DarkEventTemplate.CanActivateFn = class'X2StrategyElement_DarkEvents_LW'.static.CanActivateMajorBreakthroughAlt;
				DarkEventTemplate.OnActivatedFn = class'X2StrategyElement_DarkEvents_LW'.static.ActivateMajorBreakthroughMod;
				`LWTRACE("Redefined Major Breakthrough Dark Event Template");
				break;
			case 'DarkEvent_HunterClass':
				DarkEventTemplate.CanActivateFn = class'X2StrategyElement_DarkEvents_LW'.static.CanActivateHunterClass_LW;
				break;
			case 'DarkEvent_RapidResponse':
				DarkEventTemplate.CanActivateFn = class'X2StrategyElement_DarkEvents_LW'.static.CanActivateAdvCaptainM2Upgrade;
				DarkEventTemplate.bRepeatable = true;
				break;
			case 'DarkEvent_HighAlert':
			case 'DarkEvent_UndyingLoyalty':
				DarkEventTemplate.MinDurationDays = 12;
				DarkEventTemplate.MaxDurationDays = 18;
				break;
			case 'DarkEvent_TheCollectors':
			case 'DarkEvent_MadeWhole':
			case 'DarkEvent_WildHunt':
				// Remove these from play when the Chosen are all dead
				DarkEventTemplate.CanActivateFn = ChosenAliveCheck;
				break;
			default: break;
		}
	}
}

//---------------------------------------------------------------------------------------
static function bool ChosenAliveCheck(XComGameState_DarkEvent DarkEventState)
{
	local XComGameStateHistory History;
	local XComGameState_AdventChosen ChosenState;
	local int NumActiveChosen;
	local bool bSpecifiedChosenActive;

	History = `XCOMHISTORY;
	NumActiveChosen = 0;
	bSpecifiedChosenActive = false;

	foreach History.IterateByClassType(class'XComGameState_AdventChosen', ChosenState)
	{
		if (ChosenState.bMetXCom && !ChosenState.bDefeated)
		{
			// At least one Chosen is alive
			return true;
		}
	}

	return false;
}

//---------------------------------------------------------------------------------------
function string GetResistanceInformantSummary(string strSummaryText)
{
	local XGParamTag ParamTag;
	local float Divider, TempFloat;
	local int TempInt;

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));

	Divider = class'X2LWActivityDetectionCalc_Terror'.default.RESISTANCE_INFORMANT_DETECTION_DIVIDER[`STRATEGYDIFFICULTYSETTING];
	Divider = 1.0f;
	TempInt = Round(Divider);
	if (float(TempInt) ~= Divider)
	{
		ParamTag.StrValue0 = string(TempInt);
	}
	else
	{
		TempFloat = Round(Divider * 10.0) / 10.0;
		ParamTag.StrValue0 = Repl(string(TempFloat), "0", "");
	}

	return `XEXPAND.ExpandString(strSummaryText);
}
//---------------------------------------------------------------------------------------

function bool DisablePOI(XComGameState_PointOfInterest POIState)
{
	return false;
}

static function X2LWTemplateModTemplate CreateModifyPOIsTemplate()
{
	local X2LWTemplateModTemplate Template;

	`CREATE_X2TEMPLATE(class'X2LWTemplateModTemplate', Template, 'ModifyPOIs');
	Template.StrategyElementTemplateModFn = ModifyPOIs;
	return Template;
}

function bool DelayGrenades(XComGameState_PointOfInterest POIState)
{
	local XComGameState_HeadquartersAlien AlienHQ;

	AlienHQ = XComGameState_HeadquartersAlien(`XCOMHistory.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	if (AlienHQ == none)
	{
		return false;
	}
	if (AlienHQ.GetForceLevel() <= 10)
	{
		return false;
	}
	return true;
}

// This also modifies the description of the city center in invasion missions
function ModifyPOIs (X2StrategyElementTemplate Template, int Difficulty)
{
	local X2PointOfInterestTemplate POITemplate;
	local X2MissionSiteDescriptionTemplate MissionSiteDescription;

	POITemplate = X2PointofInterestTemplate(Template);
	if (POITemplate != none)
	{
		switch (POITemplate.DataName)
		{
			case 'POI_FacilityLead':
			case 'POI_GuerillaOp':
			case 'POI_HeavyWeapon':
			case 'POI_SupplyRaid':
			case 'POI_IncreaseIncome':
				POITemplate.CanAppearFn = DisablePOI;
				break;
			case 'POI_GrenadeAmmo':
				POITemplate.CanAppearFn = DelayGrenades;
				break;
			default:
				break;
		}
	}
	MissionSiteDescription = X2MissionSiteDescriptionTemplate(Template);
	if (MissionSiteDescription != none)
	{
		if (MissionSiteDescription.DataName == 'CityCenter')
		{
			MissionSiteDescription.GetMissionSiteDescriptionFn = class'X2StrategyElement_MissionSiteDescriptions_LW'.static.GetCityCenterMissionSiteDescription_LW;
		}
	}
}


static function X2LWTemplateModTemplate CreateModifyHackRewardsTemplate()
{
	local X2LWTemplateModTemplate Template;

	`CREATE_X2TEMPLATE(class'X2LWTemplateModTemplate', Template, 'ModifyHackRewards');
	Template.HackRewardTemplateModFn = ModifyHackRewards;
	return Template;
}

function ModifyHackRewards (X2HackRewardTemplate Template, int Difficulty)
{
	local X2HackRewardTemplate HackRewardTemplate;

	if (Template != none)
	{
		HackRewardTemplate = Template;
		if (HackRewardTemplate.DataName == 'PriorityData_T1' || HackRewardTemplate.DataName == 'PriorityData_T2')
		{
			HackRewardTemplate.ApplyHackRewardFn = none;
		}
		if (HackRewardTemplate.DataName == 'ResistanceBroadcast_T1')
		{
			HackRewardTemplate.ApplyHackRewardFn = class'X2HackReward_LWOverhaul'.static.ApplyResistanceBroadcast_LW_1;
		} 
		if (HackRewardTemplate.DataName == 'ResistanceBroadcast_T2')
		{
			HackRewardTemplate.ApplyHackRewardFn = class'X2HackReward_LWOverhaul'.static.ApplyResistanceBroadcast_LW_2;
		}
	}
}

static function X2LWTemplateModTemplate CreateReconfigFacilityUpgradesTemplate()
{
	local X2LWTemplateModTemplate Template;

	`CREATE_X2TEMPLATE(class'X2LWTemplateModTemplate', Template, 'ModifyFacilityUpgrades');
	Template.StrategyElementTemplateModFn = ModifyFacilityUpgrades;
	return Template;
}

// THIS DOES NOT MODIFY REQUIREMENTS (TECHS, SPECIAL ARTIFACTS, RANK ACHIEVED) WHICH ARE HARDCODED, CAN ADD SCI/ENG SCORE REQUIREMENT IF SET
function ModifyFacilityUpgrades(X2StrategyElementTemplate Template, int Difficulty)
{
	local X2FacilityUpgradeTemplate FacilityUpgradeTemplate;
	local int k;
	local ArtifactCost Resources;

	FacilityUpgradeTemplate = X2FacilityUpgradeTemplate(Template);
	if (FacilityUpgradeTemplate != none)
	{
		for (k = 0; k < FacilityUpgradeTable.length; k++)
		{
			If (FacilityUpgradeTable[k].FacilityUpgradeTemplateName == FacilityUpgradeTemplate.DataName)
			{
				FacilityUpgradeTemplate.PointsToComplete = FacilityUpgradeTable[k].PointsToComplete;
				FacilityUpgradeTemplate.iPower = FacilityUpgradeTable[k].iPower;
				FacilityUpgradeTemplate.UpkeepCost = FacilityUpgradeTable[k].UpkeepCost;
				
				FacilityUpgradeTemplate.Cost.ResourceCosts.Length = 0;
				FacilityUpgradeTemplate.Cost.ArtifactCosts.Length = 0;
				FacilityUpgradeTemplate.Requirements.RequiredTechs.Length = 0;

				if (FacilityUpgradeTable[k].RequiredTech != '')
				{
					FacilityUpgradeTemplate.Requirements.RequiredTechs.AddItem(FacilityUpgradeTable[k].RequiredTech);
				}
				if (FacilityUpgradeTable[k].SupplyCost > 0)
				{
					Resources.ItemTemplateName = 'Supplies';
					Resources.Quantity = FacilityUpgradeTable[k].SupplyCost;
					FacilityUpgradeTemplate.Cost.ResourceCosts.AddItem(Resources);                  
				}
				if (FacilityUpgradeTable[k].AlloyCost > 0)
				{
					Resources.ItemTemplateName = 'AlienAlloy';
					Resources.Quantity = FacilityUpgradeTable[k].AlloyCost;
					FacilityUpgradeTemplate.Cost.ResourceCosts.AddItem(Resources);                  
				}
				if (FacilityUpgradeTable[k].CrystalCost > 0)
				{
					Resources.ItemTemplateName = 'EleriumDust';
					Resources.Quantity = FacilityUpgradeTable[k].CrystalCost;
					FacilityUpgradeTemplate.Cost.ResourceCosts.AddItem(Resources);                  
				}
				if (FacilityUpgradeTable[k].CoreCost > 0)
				{
					Resources.ItemTemplateName = 'EleriumCore';
					Resources.Quantity = FacilityUpgradeTable[k].CoreCost;
					FacilityUpgradeTemplate.Cost.ResourceCosts.AddItem(Resources);                  
				}
				if (FacilityUpgradeTable[k].ReqItemCost1 > 0)
				{
					Resources.ItemTemplateName = FacilityUpgradeTable[k].ReqItemTemplateName1;
					Resources.Quantity = FacilityUpgradeTable[k].ReqItemCost1;
					FacilityUpgradeTemplate.Cost.ArtifactCosts.AddItem(Resources);
				}
				if (FacilityUpgradeTable[k].ReqItemCost2 > 0)
				{
					Resources.ItemTemplateName = FacilityUpgradeTable[k].ReqItemTemplateName2;
					Resources.Quantity = FacilityUpgradeTable[k].ReqItemCost2;
					FacilityUpgradeTemplate.Cost.ArtifactCosts.AddItem(Resources);
				}
				FacilityUpgradeTemplate.MaxBuild = FacilityUpgradeTable[k].MaxBuild;
				if (FacilityUpgradeTable[k].RequiredEngineeringScore > 0)
				{
					FacilityUpgradeTemplate.Requirements.RequiredEngineeringScore = FacilityUpgradeTable[k].RequiredEngineeringScore;
				}
				if (FacilityUpgradeTable[k].RequiredScienceScore > 0)
				{
					FacilityUpgradeTemplate.Requirements.RequiredScienceScore = FacilityUpgradeTable[k].RequiredScienceScore;
				}
			}
		}
	}
}
