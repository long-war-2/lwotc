//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_Scavenger
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Implements effect for Scavenger ability
//--------------------------------------------------------------------------------------- 
//---------------------------------------------------------------------------------------
class X2Effect_ChosenLoot extends X2Effect_Persistent config(LW_OfficerPack);

var localized string m_strChosenLoot;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local Object EffectObj;

	EffectObj = EffectGameState;

	// allows activation/deactivation of effect
	`XEVENTMGR.RegisterForEvent(EffectObj, 'UnitDied', ScavengerAutoLoot, ELD_OnStateSubmitted,,,, EffectObj);
}

//handle granting extra alloys/elerium on kill -- use 'KillMail' event instead of 'OnUnitDied' so gamestate is updated after regular auto-loot, instead of before
static function EventListenerReturn ScavengerAutoLoot(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState NewGameState;
	local XComGameState_Effect_EffectCounter EffectState;
	local XComGameState_Unit DeadUnit;

	DeadUnit = XComGameState_Unit (EventData);
	if (DeadUnit == none)
	{
		`RedScreen("Chosen Loot Check: no dead unit");
		return ELR_NoInterrupt;
	}

    
    if(DeadUnit.IsChosen())	
    {
        NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
        EffectState = XComGameState_Effect_EffectCounter(NewGameState.ModifyStateObject(EffectState.Class, EffectState.ObjectID));
        PutChosenLoot(NewGameState, EffectState, DeadUnit);
        `TACTICALRULES.SubmitGameState(NewGameState);
    }

        return ELR_NoInterrupt;
    }

static function bool PutChosenLoot(XComGameState NewGameState, XComGameState_Effect_EffectCounter EffectState, XComGameState_Unit DeadUnit)
{
	local X2LootTableManager LootManager;
	local int LootIndex;
	local LootResults Loot;
	local Name LootName;
	local int Idx;
	local XComGameState_Item Item;
	local X2ItemTemplate ItemTemplate;
	local XComGameState_BattleData BattleData;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameStateHistory History;
	local X2ItemTemplateManager ItemTemplateManager;

	NewGameState.GetContext().PostBuildVisualizationFn.AddItem(VisualizeChosenLoot);

    History = `XCOMHISTORY;

	LootManager = class'X2LootTableManager'.static.GetLootTableManager();
	LootIndex = LootManager.FindGlobalLootCarrier('ChosenLoot');
	if (LootIndex >= 0)
	{
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

	}

	return true;
}

static function float ComputeEffectiveForceLevel(XComGameState_BattleData BattleDataState)
{
	return float(BattleDataState.GetForceLevel());
}

static function VisualizeChosenLoot(XComGameState VisualizeGameState)
{
	local XComGameState_BattleData OldBattleData, NewBattleData;
	local XComGameStateHistory History;
    local XComGameStateContext_Ability Context;
	local int LootBucketIndex;
	local VisualizationActionMetadata BuildTrack;
	local X2Action_PlayWorldMessage MessageAction;
	local XGParamTag kTag;
	local X2ItemTemplateManager ItemTemplateManager;
	local array<Name> UniqueItemNames;
	local array<int> ItemQuantities;
	local int ExistingIndex;
	//local X2Action_PlayMessageBanner MessageAction;

	History = `XCOMHISTORY;
    Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

	// add a message for each loot drop
	NewBattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	NewBattleData = XComGameState_BattleData(History.GetGameStateForObjectID(NewBattleData.ObjectID, , VisualizeGameState.HistoryIndex));
	OldBattleData = XComGameState_BattleData(History.GetGameStateForObjectID(NewBattleData.ObjectID, , VisualizeGameState.HistoryIndex - 1));

	History.GetCurrentAndPreviousGameStatesForObjectID(Context.InputContext.SourceObject.ObjectID, BuildTrack.StateObject_OldState, BuildTrack.StateObject_NewState, eReturnType_Reference, VisualizeGameState.HistoryIndex);
	BuildTrack.VisualizeActor = History.GetVisualizer(Context.InputContext.SourceObject.ObjectID);

	// The actual VisualizeActor used for X2Action_PlayWorldMessage seems to be irrelevant.
	MessageAction = X2Action_PlayWorldMessage(class'X2Action_PlayWorldMessage'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext(), false, BuildTrack.LastActionAdded));

	kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	for( LootBucketIndex = OldBattleData.CarriedOutLootBucket.Length; LootBucketIndex < NewBattleData.CarriedOutLootBucket.Length; ++LootBucketIndex )
	{
		ExistingIndex = UniqueItemNames.Find(NewBattleData.CarriedOutLootBucket[LootBucketIndex]);
		if( ExistingIndex == INDEX_NONE )
		{
			UniqueItemNames.AddItem(NewBattleData.CarriedOutLootBucket[LootBucketIndex]);
			ItemQuantities.AddItem(1);
		}
		else
		{
			++ItemQuantities[ExistingIndex];
		}
	}

	for( LootBucketIndex = 0; LootBucketIndex < UniqueItemNames.Length; ++LootBucketIndex )
	{
		kTag.StrValue0 = ItemTemplateManager.FindItemTemplate(UniqueItemNames[LootBucketIndex]).GetItemFriendlyName();
		kTag.IntValue0 = ItemQuantities[LootBucketIndex];
		MessageAction.AddWorldMessage(`XEXPAND.ExpandString(default.m_strChosenLoot));
	}



}

defaultproperties
{
	EffectName=ChosenLoot;
	bRemoveWhenSourceDies=false;
}
