//---------------------------------------------------------------------------------------
//  FILE:    X2HackReward_LWOverhaul.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Interface for adding new Hack Rewards to X-Com 2.
//---------------------------------------------------------------------------------------
class X2HackReward_LWOverhaul extends X2HackReward config(GameCore);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	`LWTrace("  >> X2HackReward_LWOverhaul.CreateTemplates()");

	Templates.AddItem(CreateHackLootTableReward('LootPCS_T1_LW'));
	Templates.AddItem(CreateHackLootTableReward('LootPCS_T2_LW'));
	Templates.AddItem(CreateHackLootTableReward('LootPCS_T3_LW'));

	return Templates;
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

static function ApplyResistanceBroadcast_LW_1 (XComGameState_Unit Hacker, XComGameState_BaseObject HackTarget, XComGameState NewGameState)
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

static function ApplyResistanceBroadcast_LW_2 (XComGameState_Unit Hacker, XComGameState_BaseObject HackTarget, XComGameState NewGameState)
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

static function ApplyPCSDropsBasic (XComGameState_Unit Hacker, XComGameState_BaseObject HackTarget, XComGameState NewGameState)
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

static function ApplyPCSDropsRare (XComGameState_Unit Hacker, XComGameState_BaseObject HackTarget, XComGameState NewGameState)
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

static function ApplyPCSDropsEpic (XComGameState_Unit Hacker, XComGameState_BaseObject HackTarget, XComGameState NewGameState)
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
