//---------------------------------------------------------------------------------------
//  FILE:    X2HackReward_LWOverhaul.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Interface for adding new Hack Rewards to X-Com 2.
//---------------------------------------------------------------------------------------
class X2HackReward_LWOverhaul extends X2HackReward config(GameCore);

enum ApplicationRulesType
{
	eAR_ADVENTClones,
	eAR_AllADVENT,
	eAR_Robots,
	eAR_Aliens,
	eAR_AllEnemies,
	eAR_CustomList
};


var config int SapperApplicationChance;
var config ApplicationRulesType SapperApplicationRules;
var config array<name> SapperApplicationTargetArray;

var config int WilltoSurviveApplicationChance;
var config ApplicationRulesType WilltoSurviveApplicationRules;

var config int CenterMassApplicationChance;
var config ApplicationRulesType CenterMassApplicationRules;

var config int InfighterApplicationChance;
var config ApplicationRulesType InfighterApplicationRules;
var config array<name> InfighterApplicationTargetArray;

var config int LethalApplicationChance;
var config ApplicationRulesType LethalApplicationRules;

var config int FormidableApplicationChance;
var config ApplicationRulesType FormidableApplicationRules;
var config array<name> FormidableApplicationTargetArray;

var config int ShredderApplicationChance;
var config ApplicationRulesType ShredderApplicationRules;
var config array<name> ShredderApplicationTargetArray;

var config int HuntersInstinctApplicationChance;
var config ApplicationRulesType HuntersInstinctApplicationRules;
var config array<name> HuntersInstinctApplicationTargetArray;

var config int LightningReflexesApplicationChance;
var config ApplicationRulesType LightningReflexesApplicationRules;
var config array<name> LightningReflexesApplicationTargetArray;

var config int CloseCombatSpecialistApplicationChance;
var config ApplicationRulesType CloseCombatSpecialistApplicationRules;
var config array<name> CloseCombatSpecialistApplicationTargetArray;

var config int GrazingFireApplicationChance;
var config ApplicationRulesType GrazingFireApplicationRules;
var config array<name> GrazingFireApplicationTargetArray;

var config int CutthroatApplicationChance;
var config ApplicationRulesType CutthroatApplicationRules;
var config array<name> CutthroatApplicationTargetArray;

var config int CombatAwarenessApplicationChance;
var config ApplicationRulesType CombatAwarenessApplicationRules;
var config array<name> CombatAwarenessApplicationTargetArray;

var config int IronSkinApplicationChance;
var config ApplicationRulesType IronSkinApplicationRules;

var config int TacticalSenseApplicationChance;
var config ApplicationRulesType TacticalSenseApplicationRules;
var config array<name> TacticalSenseApplicationTargetArray;

var config int AggressionApplicationChance;
var config ApplicationRulesType AggressionApplicationRules;
var config array<name> AggressionApplicationTargetArray;

var config int ResilienceApplicationChance;
var config ApplicationRulesType ResilienceApplicationRules;
var config array<name> ResilienceApplicationTargetArray;

var config int ShadowstepApplicationChance;
var config ApplicationRulesType ShadowstepApplicationRules;
var config array<name> ShadowstepApplicationTargetArray;

var config int DamageControlApplicationChance;
var config ApplicationRulesType DamageControlApplicationRules;
var config array<name> DamageControlApplicationTargetArray;

var config int HardTargetApplicationChance;
var config ApplicationRulesType HardTargetApplicationRules;
var config array<name> HardTargetApplicationTargetArray;

var config int GreaterFacelessApplicationChance;
var config ApplicationRulesType GreaterFacelessApplicationRules;
var config array<name> GreaterFacelessApplicationTargetArray;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	`LWTrace("  >> X2HackReward_LWOverhaul.CreateTemplates()");
	
	Templates.AddItem(CreateNavigatorPerkTemplate ('DarkEvent_MutonEngineers', ApplySapper));
	Templates.AddItem(CreateNavigatorPerkTemplate ('DarkEvent_WilltoSurvive', ApplyWilltoSurvive));
	Templates.AddItem(CreateNavigatorPerkTemplate ('DarkEvent_CenterMass', ApplyCenterMass));
	Templates.AddItem(CreateNavigatorPerkTemplate ('DarkEvent_Lethal', ApplyLethal));
	Templates.AddItem(CreateNavigatorPerkTemplate ('DarkEvent_Infighter', ApplyInfighter));
	Templates.AddItem(CreateNavigatorPerkTemplate ('DarkEvent_Formidable', ApplyFormidable));
	Templates.AddItem(CreateNavigatorPerkTemplate ('DarkEvent_Shredder', ApplyShredder));
	Templates.AddItem(CreateNavigatorPerkTemplate ('DarkEvent_HuntersInstinct', ApplyHuntersInstinct));
	Templates.AddItem(CreateNavigatorPerkTemplate ('DarkEvent_LightningReflexes_LW', ApplyLightningReflexes));
	Templates.AddItem(CreateNavigatorPerkTemplate ('DarkEvent_CloseCombatSpecialist', ApplyCloseCombatSpecialist));
	Templates.AddItem(CreateNavigatorPerkTemplate ('DarkEvent_GrazingFire', ApplyGrazingFire));
	Templates.AddItem(CreateNavigatorPerkTemplate ('DarkEvent_Cutthorat', ApplyCutthroat));
	Templates.AddItem(CreateNavigatorPerkTemplate ('DarkEvent_CombatAwareness', ApplyCombatAwareness));
	Templates.AddItem(CreateNavigatorPerkTemplate ('DarkEvent_IronSkin', ApplyIronSkin));
	Templates.AddItem(CreateNavigatorPerkTemplate ('DarkEvent_TacticalSense', ApplyTacticalSense));
	Templates.AddItem(CreateNavigatorPerkTemplate ('DarkEvent_Aggression', ApplyAggression));
	Templates.AddItem(CreateNavigatorPerkTemplate ('DarkEvent_Resilience', ApplyResilience));
	Templates.AddItem(CreateNavigatorPerkTemplate ('DarkEvent_Shadowstep', ApplyShadowstep));
	Templates.AddItem(CreateNavigatorPerkTemplate ('DarkEvent_DamageControl', ApplyDamageControl));
	Templates.AddItem(CreateNavigatorPerkTemplate ('DarkEvent_HardTarget', ApplyHardTarget));
	Templates.AddItem(CreateNavigatorPerkTemplate ('DarkEvent_GreaterFaceless', ApplyGreaterFaceless));
	Templates.AddItem(CreateHackLootTableReward('LootPCS_T1_LW'));
	Templates.AddItem(CreateHackLootTableReward('LootPCS_T2_LW'));
	Templates.AddItem(CreateHackLootTableReward('LootPCS_T3_LW'));

	return Templates;
}

function ApplySapper (XComGameState_Unit Hacker, XComGameState_BaseObject HackTarget, XComGameState NewGameState)
{
	ApplyNavigatorPerk (NewGameState, 'Sapper', default.SapperApplicationChance, default.SapperApplicationRules, false);
}

function ApplyWillToSurvive(XComGameState_Unit Hacker, XComGameState_BaseObject HackTarget, XComGameState NewGameState)
{
	ApplyNavigatorPerk (NewGameState, 'WilltoSurvive', default.WilltoSurviveApplicationChance, default.WilltoSurviveApplicationRules, false);
}

function ApplyCenterMass(XComGameState_Unit Hacker, XComGameState_BaseObject HackTarget, XComGameState NewGameState)
{
	ApplyNavigatorPerk (NewGameState, 'CenterMass', default.CenterMassApplicationChance, default.CenterMassApplicationRules, true);
}

function ApplyLethal (XComGameState_Unit Hacker, XComGameState_BaseObject HackTarget, XComGameState NewGameState)
{
	ApplyNavigatorPerk (NewGameState, 'Lethal', default.LethalApplicationChance, default.LethalApplicationRules, true);
}

function ApplyInfighter(XComGameState_Unit Hacker, XComGameState_BaseObject HackTarget, XComGameState NewGameState)
{
	ApplyNavigatorPerk (NewGameState, 'Infighter', default.InfighterApplicationChance, default.InfighterApplicationRules, false, default.InfighterApplicationTargetArray);
}

function ApplyFormidable(XComGameState_Unit Hacker, XComGameState_BaseObject HackTarget, XComGameState NewGameState)
{
	ApplyNavigatorPerk (NewGameState, 'Formidable', default.FormidableApplicationChance, default.FormidableApplicationRules, false, default.FormidableApplicationTargetArray);
}

function ApplyShredder(XComGameState_Unit Hacker, XComGameState_BaseObject HackTarget, XComGameState NewGameState)
{
	ApplyNavigatorPerk (NewGameState, 'Shredder', default.ShredderApplicationChance, default.ShredderApplicationRules, false, default.ShredderApplicationTargetArray);
}

function ApplyHuntersInstinct(XComGameState_Unit Hacker, XComGameState_BaseObject HackTarget, XComGameState NewGameState)
{
	ApplyNavigatorPerk (NewGameState, 'HuntersInstinct', default.HuntersInstinctApplicationChance, default.HuntersInstinctApplicationRules, false, default.HuntersInstinctApplicationTargetArray);
}

function ApplyLightningReflexes(XComGameState_Unit Hacker, XComGameState_BaseObject HackTarget, XComGameState NewGameState)
{
	ApplyNavigatorPerk (NewGameState, 'LightningReflexes_LW', default.LightningReflexesApplicationChance, default.LightningReflexesApplicationRules, false, default.LightningReflexesApplicationTargetArray);
}

function ApplyCloseCombatSpecialist(XComGameState_Unit Hacker, XComGameState_BaseObject HackTarget, XComGameState NewGameState)
{
	ApplyNavigatorPerk (NewGameState, 'CloseCombatSpecialist', default.CloseCombatSpecialistApplicationChance, default.CloseCombatSpecialistApplicationRules, true, default.CloseCombatSpecialistApplicationTargetArray);
}

function ApplyGrazingFire(XComGameState_Unit Hacker, XComGameState_BaseObject HackTarget, XComGameState NewGameState)
{
	ApplyNavigatorPerk (NewGameState, 'GrazingFire', default.GrazingFireApplicationChance, default.GrazingFireApplicationRules, false, default.GrazingFireApplicationTargetArray);
}

function ApplyCutthroat(XComGameState_Unit Hacker, XComGameState_BaseObject HackTarget, XComGameState NewGameState)
{
	ApplyNavigatorPerk (NewGameState, 'Cutthroat', default.CutthroatApplicationChance, default.CutthroatApplicationRules, false, default.CutthroatApplicationTargetArray);
}

function ApplyCombatAwareness(XComGameState_Unit Hacker, XComGameState_BaseObject HackTarget, XComGameState NewGameState)
{
	ApplyNavigatorPerk (NewGameState, 'CombatAwareness', default.CombatAwarenessApplicationChance, default.CombatAwarenessApplicationRules, false, default.CombatAwarenessApplicationTargetArray);
}

function ApplyIronSkin(XComGameState_Unit Hacker, XComGameState_BaseObject HackTarget, XComGameState NewGameState)
{
	ApplyNavigatorPerk (NewGameState, 'IronSkin', default.IronSkinApplicationChance, default.IronSkinApplicationRules, false);
}

function ApplyTacticalSense(XComGameState_Unit Hacker, XComGameState_BaseObject HackTarget, XComGameState NewGameState)
{
	ApplyNavigatorPerk (NewGameState, 'TacticalSense', default.TacticalSenseApplicationChance, default.TacticalSenseApplicationRules, false, default.TacticalSenseApplicationTargetArray);
}

function ApplyAggression(XComGameState_Unit Hacker, XComGameState_BaseObject HackTarget, XComGameState NewGameState)
{
	ApplyNavigatorPerk (NewGameState, 'Aggression', default.AggressionApplicationChance, default.AggressionApplicationRules, false, default.AggressionApplicationTargetArray);
}

function ApplyResilience(XComGameState_Unit Hacker, XComGameState_BaseObject HackTarget, XComGameState NewGameState)
{
	ApplyNavigatorPerk (NewGameState, 'Resilience', default.ResilienceApplicationChance, default.ResilienceApplicationRules, false, default.ResilienceApplicationTargetArray);
}

function ApplyShadowstep(XComGameState_Unit Hacker, XComGameState_BaseObject HackTarget, XComGameState NewGameState)
{
	ApplyNavigatorPerk (NewGameState, 'Shadowstep', default.ShadowstepApplicationChance, default.ShadowstepApplicationRules, false, default.ShadowstepApplicationTargetArray);
}

function ApplyDamageControl(XComGameState_Unit Hacker, XComGameState_BaseObject HackTarget, XComGameState NewGameState)
{
	ApplyNavigatorPerk (NewGameState, 'DamageControl', default.DamageControlApplicationChance, default.DamageControlApplicationRules, false, default.DamageControlApplicationTargetArray);
}

function ApplyHardTarget(XComGameState_Unit Hacker, XComGameState_BaseObject HackTarget, XComGameState NewGameState)
{
	ApplyNavigatorPerk (NewGameState, 'HardTarget', default.HardTargetApplicationChance, default.HardTargetApplicationRules, false, default.HardTargetApplicationTargetArray);
}

function ApplyGreaterFaceless(XComGameState_Unit Hacker, XComGameState_BaseObject HackTarget, XComGameState NewGameState)
{
	ApplyNavigatorPerk (NewGameState, 'GreaterFacelessStatImprovements', default.GreaterFacelessApplicationChance, default.GreaterFacelessApplicationRules, false, default.GreaterFacelessApplicationTargetArray);
}

static function X2HackRewardTemplate CreateNavigatorPerkTemplate (name TemplateName, delegate<X2HackRewardTemplate.ApplyHackReward> ApplyFn)
{
	local X2HackRewardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2HackRewardTemplate', Template, TemplateName);
	Template.AbilitySource=EHASS_Hacker;
	Template.ApplyHackRewardFn = ApplyFn;

	return Template;
}


function ApplyNavigatorPerk (XComGameState NewGameState, Name AbilityTemplateName, int ApplicationChance, ApplicationRulesType ApplicationRules, bool ApplyToPrimaryWeapon, optional array<name> ApplicationTargets)
{
	local XComGameStateHistory	History;
	local X2AbilityTemplate		AbilityTemplate;
	local X2AbilityTemplateManager AbilityTemplateManager;
	local XComGameState_Unit UnitState, NewUnitState;
	local StateObjectReference AbilityRef;
	local XComGameState_Ability AbilityState;
	local Name AdditionalAbilityName;
	local X2AbilityTemplate AdditionalAbilityTemplate;
	local XComGameState_Item kWeapon;
	History = `XCOMHISTORY;

	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	if(AbilityTemplateName != 'None')
    {
        AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(AbilityTemplateName);     
        if(AbilityTemplate == none)
        {
            `REDSCREEN ("Apply Navigator Perk specifies an unknown ability for AbilityTemplateName:" @ string(AbilityTemplateName));
            return;
        }
    }
	foreach History.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		AbilityRef = UnitState.FindAbility(AbilityTemplate.DataName);
		if (AbilityRef.ObjectID == 0)
		{
			if (UnitState.IsSoldier()) continue;
			if (ApplicationRules == eAR_ADVENTClones)
			{
				if (!UnitState.IsAdvent()) continue;
				if (UnitState.IsRobotic()) continue;
			}
			if (ApplicationRules == eAR_AllADVENT)
			{
				if (!UnitState.IsAdvent()) continue;
			}
			if (ApplicationRules == eAR_Robots)
			{
				if (!UnitState.IsAdvent()) continue;
				if (!UnitState.IsRobotic()) continue;
			}
			if (ApplicationRules == eAR_Aliens)
			{
				if (!UnitState.IsAlien()) continue;
			}
			if (ApplicationRules == eAR_AllEnemies)
			{
				if (!UnitState.IsAlien() && !UnitState.IsAdvent()) continue;
			}
			if (ApplicationRules == eAR_CustomList)
			{
				if (ApplicationTargets.Find(UnitState.GetMyTemplateName()) == -1) continue;
			}
			
			if( `SYNC_RAND(100) < ApplicationChance )
			{
				
				
				if(ApplyToPrimaryWeapon)
				{
					NewUnitState = XComGameState_Unit(NewGameState.CreateStateObject(UnitState.Class, UnitState.ObjectID));
					kWeapon = NewUnitState.GetItemInSlot(eInvSlot_PrimaryWeapon);
					NewGameState.AddStateObject(NewUnitState);

					AbilityRef = X2TacticalGameRuleset(XComGameInfo(class'Engine'.static.GetCurrentWorldInfo().Game).GameRuleset).InitAbilityForUnit(AbilityTemplate, NewUnitState, NewGameState,kWeapon.GetReference());
					if (AbilityRef.ObjectID == 0) continue;
				
					AbilityState = XComGameState_Ability(NewGameState.CreateStateObject(class'XComGameState_Ability', AbilityRef.ObjectID));
					NewGameState.AddStateObject(AbilityState);

					// Also add any additional abilities attached to this ability.
					foreach AbilityTemplate.AdditionalAbilities(AdditionalAbilityName)
					{
						AdditionalAbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(AdditionalAbilityName);
						if (AdditionalAbilityTemplate != none)
						{
							AbilityRef = X2TacticalGameRuleset(XComGameInfo(class'Engine'.static.GetCurrentWorldInfo().Game).GameRuleset).InitAbilityForUnit(AdditionalAbilityTemplate, NewUnitState, NewGameState,kWeapon.GetReference());
							if (AbilityRef.ObjectID == 0) continue;
							AbilityState = XComGameState_Ability(NewGameState.CreateStateObject(class'XComGameState_Ability', AbilityRef.ObjectID));
							NewGameState.AddStateObject(AbilityState);
						}
					}
				}
				else
				{
					NewUnitState = XComGameState_Unit(NewGameState.CreateStateObject(UnitState.Class, UnitState.ObjectID));
					NewGameState.AddStateObject(NewUnitState);

					AbilityRef = X2TacticalGameRuleset(XComGameInfo(class'Engine'.static.GetCurrentWorldInfo().Game).GameRuleset).InitAbilityForUnit(AbilityTemplate, NewUnitState, NewGameState);
					if (AbilityRef.ObjectID == 0) continue;
				
					AbilityState = XComGameState_Ability(NewGameState.CreateStateObject(class'XComGameState_Ability', AbilityRef.ObjectID));
					NewGameState.AddStateObject(AbilityState);

					// Also add any additional abilities attached to this ability.
					foreach AbilityTemplate.AdditionalAbilities(AdditionalAbilityName)
					{
						AdditionalAbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(AdditionalAbilityName);
						if (AdditionalAbilityTemplate != none)
						{
							AbilityRef = X2TacticalGameRuleset(XComGameInfo(class'Engine'.static.GetCurrentWorldInfo().Game).GameRuleset).InitAbilityForUnit(AdditionalAbilityTemplate, NewUnitState, NewGameState);
							if (AbilityRef.ObjectID == 0) continue;
							AbilityState = XComGameState_Ability(NewGameState.CreateStateObject(class'XComGameState_Ability', AbilityRef.ObjectID));
							NewGameState.AddStateObject(AbilityState);
						}
					}
				}
			}
		}
	}
}

function ApplyResistanceBroadcast_LW_1 (XComGameState_Unit Hacker, XComGameState_BaseObject HackTarget, XComGameState NewGameState)
{
    local StateObjectReference NewUnitRef;
    local XComGameState_WorldRegion RegionState;
    local XComGameState_MissionSite MissionState;
    local XComGameState_LWOutpostManager OutpostManager;
    local XComGameState_LWOutpost Outpost;

    MissionState = XComGameState_MissionSite(`XCOMHistory.GetGameStateForObjectID(`XCOMHQ.MissionRef.ObjectID));
    RegionState = XComGameState_WorldRegion(`XCOMHistory.GetGameStateForObjectID(MissionState.Region.ObjectID));
	if (RegionState != none)
	{
		OutpostManager = `LWOUTPOSTMGR;
		Outpost = OutpostManager.GetOutpostForRegion(RegionState);
		Outpost = XComGameState_LWOutpost(NewGameState.CreateStateObject(class'XComGameState_LWOutpost', Outpost.ObjectID));
		NewGameState.AddStateObject(Outpost);
		NewUnitRef = Outpost.CreateRebel(NewGameState, RegionState, true);
		Outpost.AddRebel(NewUnitRef, NewGameState);
	}

}

function ApplyResistanceBroadcast_LW_2 (XComGameState_Unit Hacker, XComGameState_BaseObject HackTarget, XComGameState NewGameState)
{
    local StateObjectReference NewUnitRef;
    local XComGameState_WorldRegion RegionState;
    local XComGameState_MissionSite MissionState;
    local XComGameState_LWOutpostManager OutpostManager;
    local XComGameState_LWOutpost Outpost;
	
    MissionState = XComGameState_MissionSite(`XCOMHistory.GetGameStateForObjectID(`XCOMHQ.MissionRef.ObjectID));
    RegionState = XComGameState_WorldRegion(`XCOMHistory.GetGameStateForObjectID(MissionState.Region.ObjectID));
	if (RegionState != none)
	{
	    OutpostManager = `LWOUTPOSTMGR;
		Outpost = OutpostManager.GetOutpostForRegion(RegionState);
		Outpost = XComGameState_LWOutpost(NewGameState.CreateStateObject(class'XComGameState_LWOutpost', Outpost.ObjectID));
		NewGameState.AddStateObject(Outpost);
        NewUnitRef = Outpost.CreateRebel(NewGameState, RegionState, true);
		Outpost.AddRebel(NewUnitRef, NewGameState);
		NewUnitRef = Outpost.CreateRebel(NewGameState, RegionState, true);
		Outpost.AddRebel(NewUnitRef, NewGameState);
	}
}

static function X2HackRewardTemplate CreateHackLootTableReward (name TemplateName)
{
	local X2HackRewardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2HackRewardTemplate', Template, TemplateName);
	switch (TemplateName)
	{
		case 'LootPCS_T1_LW': Template.ApplyHackRewardFn = ApplyPCSDropsBasic; break;
		case 'LootPCS_T2_LW': Template.ApplyHackRewardFn = ApplyPCSDropsRare; break;
		case 'LootPCS_T3_LW': Template.ApplyHackRewardFn = ApplyPCSDropsEpic; break;
		default: break;
	}
	Template.HackAbilityTemplateRestriction = 'FinalizeSKULLMINE';
	return Template;
}

function ApplyPCSDropsBasic (XComGameState_Unit Hacker, XComGameState_BaseObject HackTarget, XComGameState NewGameState)
{
	local array<name> Loots;
	local X2LootTableManager LootTableManager;
	local XComGameState_BattleData BattleData;
    local XComGameState_Item NewItemState;
    local X2ItemTemplate ItemTemplate;
	local name LootTableName;

	LootTableManager = class'X2LootTableManager'.static.GetLootTableManager();
	LootTableName = 'PCSDropsBasic';
	LootTableManager.RollForLootTable(LootTableName, Loots);
	BattleData = XComGameState_BattleData(`XCOMHistory.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
    BattleData = XComGameState_BattleData(NewGameState.CreateStateObject(class'XComGameState_BattleData', BattleData.ObjectID));
    NewGameState.AddStateObject(BattleData);
	if(Loots[0] != 'None')
	{
		ItemTemplate = class'X2ItemTemplateManager'.static.GetItemTemplateManager().FindItemTemplate(Loots[0]);
		NewItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
		NewGameState.AddStateObject(NewItemState);
		Hacker.AddLoot(NewItemState.GetReference(), NewGameState);
	}
}

function ApplyPCSDropsRare (XComGameState_Unit Hacker, XComGameState_BaseObject HackTarget, XComGameState NewGameState)
{
	local array<name> Loots;
	local X2LootTableManager LootTableManager;
	local XComGameState_BattleData BattleData;
    local XComGameState_Item NewItemState;
    local X2ItemTemplate ItemTemplate;
	local name LootTableName;

	LootTableManager = class'X2LootTableManager'.static.GetLootTableManager();
	LootTableName = 'PCSDropsRare';
	LootTableManager.RollForLootTable(LootTableName, Loots);
	BattleData = XComGameState_BattleData(`XCOMHistory.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
    BattleData = XComGameState_BattleData(NewGameState.CreateStateObject(class'XComGameState_BattleData', BattleData.ObjectID));
    NewGameState.AddStateObject(BattleData);
	if(Loots[0] != 'None')
	{
		ItemTemplate = class'X2ItemTemplateManager'.static.GetItemTemplateManager().FindItemTemplate(Loots[0]);
		NewItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
		NewGameState.AddStateObject(NewItemState);
		Hacker.AddLoot(NewItemState.GetReference(), NewGameState);
	}
}

function ApplyPCSDropsEpic (XComGameState_Unit Hacker, XComGameState_BaseObject HackTarget, XComGameState NewGameState)
{
	local array<name> Loots;
	local X2LootTableManager LootTableManager;
	local XComGameState_BattleData BattleData;
    local XComGameState_Item NewItemState;
    local X2ItemTemplate ItemTemplate;
	local name LootTableName;

	LootTableManager = class'X2LootTableManager'.static.GetLootTableManager();
	LootTableName = 'PCSDropsEpic';
	LootTableManager.RollForLootTable(LootTableName, Loots);
	BattleData = XComGameState_BattleData(`XCOMHistory.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
    BattleData = XComGameState_BattleData(NewGameState.CreateStateObject(class'XComGameState_BattleData', BattleData.ObjectID));
    NewGameState.AddStateObject(BattleData);
	if(Loots[0] != 'None')
	{
		ItemTemplate = class'X2ItemTemplateManager'.static.GetItemTemplateManager().FindItemTemplate(Loots[0]);
		NewItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
		NewGameState.AddStateObject(NewItemState);
		Hacker.AddLoot(NewItemState.GetReference(), NewGameState);
	}
}
