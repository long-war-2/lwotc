//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_AwardLoot
//  AUTHOR:  tracktwo / Pavonis Interactive
//
//  PURPOSE: Kismet action to award loot on a mission
//--------------------------------------------------------------------------------------- 

class SeqAct_AwardLoot extends SequenceAction;

var() Name LootCarrierName;

event Activated()
{
	local X2LootTableManager LootManager;
	local int LootIndex;
	local LootResults Loot;
	local Name LootName;
	local int Idx;
	local XComGameState_Item Item;
	local X2ItemTemplate ItemTemplate;
	local XComGameState NewGameState;
	local XComGameState_BattleData BattleData;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameStateHistory History;
	local X2ItemTemplateManager ItemTemplateManager;

	History = `XCOMHISTORY;
	LootManager = class'X2LootTableManager'.static.GetLootTableManager();
	LootIndex = LootManager.FindGlobalLootCarrier(LootCarrierName);
	if (LootIndex >= 0)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("SeqAct_AwardLoot");

		BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
		BattleData = XComGameState_BattleData(NewGameState.CreateStateObject(class'XComGameState_BattleData', 
				BattleData.ObjectID));
		NewGameState.AddStateObject(BattleData);
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
		XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', 
				XComHQ.ObjectID));
		NewGameState.AddStateObject(XComHQ);

		LootManager.RollForGlobalLootCarrier(LootIndex, Loot);
		ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
		foreach Loot.LootToBeCreated(LootName, Idx)
		{
			ItemTemplate = ItemTemplateManager.FindItemTemplate(LootName);
			Item = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
			NewGameState.AddStateObject(Item);
			XComHQ.PutItemInInventory(NewGameState, Item, true);
			BattleData.CarriedOutLootBucket.AddItem(LootName);
		}

		`TACTICALRULES.SubmitGameState(NewGameState);
	}
}

defaultproperties
{
	ObjCategory="LWOverhaul"
	ObjName="Award Loot"
	bConvertedForReplaySystem=true
	bAutoActivateOutputLinks=true
	VariableLinks.Empty
}
