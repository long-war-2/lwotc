//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_Effect_Scavenger.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: This is a component extension for Effect GameStates, containing
//				additional data used for Scavenger.
//---------------------------------------------------------------------------------------
class XComGameState_Effect_Scavenger extends XComGameState_BaseObject config(LW_OfficerPack);

var localized string m_strScavengerLoot;
var int ItemsRecovered;

function XComGameState_Effect_Scavenger InitComponent()
{
	return self;
}

function XComGameState_Effect GetOwningEffect()
{
	return XComGameState_Effect(`XCOMHISTORY.GetGameStateForObjectID(OwningObjectId));
}

//handle granting extra alloys/elerium on kill -- use 'KillMail' event instead of 'OnUnitDied' so gamestate is updated after regular auto-loot, instead of before
simulated function EventListenerReturn ScavengerAutoLoot(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState NewGameState;
	local XComGameState_Effect EffectState;
	//local XComGameState_Effect_Scavenger CurrentScavEffect;
	local XComGameState_Effect_Scavenger UpdatedScavEffect;
	local XComGameState_Unit KillerUnit, DeadUnit, ScavengingUnit;
	local XComGameStateHistory History;
	local XComLWTuple OverrideActivation;
	//local XComGameState_Ability AbilityState;
	//local XComGameState_Item SourceWeapon;
	//local bool bValidTarget;

	`Log("Scavenger: 'KillMail' event triggered");
	History = `XCOMHISTORY;

	KillerUnit = XComGameState_Unit (EventSource);
	if (KillerUnit == none)
	{
		`RedScreen("ScavengerCheck: no attacking unit");
		return ELR_NoInterrupt;
	}

	if ((KillerUnit.GetTeam() != eTeam_XCom) || KillerUnit.IsMindControlled()) { return ELR_NoInterrupt; }

	EffectState = GetOwningEffect();
	if (EffectState == none)
	{
		`RedScreen("ScavengerCheck: no parent effect");
		return ELR_NoInterrupt;
	}
	if (EffectState.bReadOnly) // this indicates that this is a stale effect from a previous battle
		return ELR_NoInterrupt;

	ScavengingUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if (ScavengingUnit == none)
		ScavengingUnit = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if (ScavengingUnit == none)
	{
		`RedScreen("ScavengerCheck: no scavenging officer unit");
		return ELR_NoInterrupt;
	}

	// Allow an event handler to override the activation of scavenger by setting the boolean
	// value of the Tuple to false.
	OverrideActivation = new class'XComLWTuple';
	OverrideActivation.Id = 'OverrideScavengerActivation';
	OverrideActivation.Data.Length = 1;
	OverrideActivation.Data[0].kind = XComLWTVBool;
	OverrideActivation.Data[0].b = false;
	`XEVENTMGR.TriggerEvent('OverrideScavengerActivation', OverrideActivation, self);

	if(OverrideActivation.Data[0].b)
	{
		`LOG("TRACE: Skipping Scavenger From Override");
		return ELR_NoInterrupt;
	}

	if(!ScavengingUnit.IsAbleToAct()) { return ELR_NoInterrupt; }
	if(ScavengingUnit.bRemovedFromPlay) { return ELR_NoInterrupt; }
	if(ScavengingUnit.IsMindControlled()) { return ELR_NoInterrupt; }

	//if (ScavengingUnit.IsDead()
		//|| ScavengingUnit.IsUnconscious()
		//|| ScavengingUnit.bRemovedFromPlay()
		//|| ScavengingUnit.IsBleedingOut())
		//{ return ELR_NoInterrupt; }

	DeadUnit = XComGameState_Unit (EventData);
	if (DeadUnit == none)
	{
		`RedScreen("ScavengerCheck: no dead unit");
		return ELR_NoInterrupt;
	}

	//add checks to make sure that killer is a permanent part of the XCOM team, dead unit is enemy
	if ((DeadUnit.GetTeam() == eTeam_Alien) && DeadUnit.IsLootable(GameState) && !DeadUnit.bKilledByExplosion)
	{
		//CurrentScavEffect = XComGameState_Effect_Scavenger(History.GetGameStateForObjectID(ObjectID));

		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
		UpdatedScavEffect = XComGameState_Effect_Scavenger(NewGameState.CreateStateObject(class'XComGameState_Effect_Scavenger', ObjectID));
		if(RollForScavengerForceLevelLoot(NewGameState, DeadUnit))
		{
			NewGameState.AddStateObject(UpdatedScavEffect);
			`TACTICALRULES.SubmitGameState(NewGameState);
		} else {
			History.CleanupPendingGameState(NewGameState);
		}
	}

	return ELR_NoInterrupt;
}

simulated function bool RollForScavengerForceLevelLoot(XComGameState NewGameState, XComGameState_Unit DeadUnit)
{
	local XComGameState_BattleData BattleDataState;
	local XComGameStateHistory History;
	//local Name LootTemplateName;
	local X2ItemTemplateManager ItemTemplateManager;
	local X2ItemTemplate ItemTemplate;
	local X2CharacterTemplate CharTemplate;
	local float RollChance, fNumberOfRolls, ForceLevel;
	local int iNumberOfRollsAlloys, iNumberOfRollsElerium;
	local int iNumberOfAlloys, iNumberOfElerium;
	local int i;

	CharTemplate = DeadUnit.GetMyTemplate();

	if(CharTemplate.bIsAdvent)
	{
		return false;
	}
	ForceLevel = ComputeEffectiveForceLevel(CharTemplate);

	RollChance = class'X2Effect_Scavenger'.default.SCAVENGER_AUTOLOOT_CHANCE_MIN + ForceLevel/20.0 * (class'X2Effect_Scavenger'.default.SCAVENGER_AUTOLOOT_CHANCE_MAX - class'X2Effect_Scavenger'.default.SCAVENGER_AUTOLOOT_CHANCE_MIN);
	RollChance = FClamp(RollChance, class'X2Effect_Scavenger'.default.SCAVENGER_AUTOLOOT_CHANCE_MIN, class'X2Effect_Scavenger'.default.SCAVENGER_AUTOLOOT_CHANCE_MAX);

	fNumberOfRolls = class'X2Effect_Scavenger'.default.SCAVENGER_AUTOLOOT_NUMBER_MIN + ForceLevel/20.0 * (class'X2Effect_Scavenger'.default.SCAVENGER_AUTOLOOT_NUMBER_MAX - class'X2Effect_Scavenger'.default.SCAVENGER_AUTOLOOT_CHANCE_MIN);
	fNumberOfRolls = FClamp(fNumberOfRolls, class'X2Effect_Scavenger'.default.SCAVENGER_AUTOLOOT_NUMBER_MIN, class'X2Effect_Scavenger'.default.SCAVENGER_AUTOLOOT_NUMBER_MAX);
	iNumberOfRollsAlloys = int(fNumberOfRolls);
	if(`SYNC_FRAND() < (fNumberOfRolls - float(iNumberOfRollsAlloys)))
	{
		iNumberOfRollsAlloys++;
	}

	iNumberOfRollsElerium = int(fNumberOfRolls * class'X2Effect_Scavenger'.default.SCAVENGER_ELERIUM_TO_ALLOY_RATIO);
	if(`SYNC_FRAND() < (fNumberOfRolls - float(iNumberOfRollsElerium)))
	{
		iNumberOfRollsElerium++;
	}

	for(i = 0; i < iNumberOfRollsAlloys ; i++) 	{ if(`SYNC_FRAND() < RollChance) iNumberOfAlloys++; }
	for(i = 0; i < iNumberOfRollsElerium ; i++) 	{ if(`SYNC_FRAND() < RollChance) iNumberOfElerium++; }

	if((iNumberOfAlloys == 0) && (iNumberOfElerium == 0)) return false;

	if (ItemsRecovered > class'X2Effect_Scavenger'.default.SCAVENGER_MAX_PER_MISSION) return false;

	NewGameState.GetContext().PostBuildVisualizationFn.AddItem(VisualizeScavengerAutoLoot);

	History = `XCOMHISTORY;
	BattleDataState = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	BattleDataState = XComGameState_BattleData(NewGameState.CreateStateObject(class'XComGameState_BattleData', BattleDataState.ObjectID));
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	ItemTemplate = ItemTemplateManager.FindItemTemplate('AlienAlloy');
	if(ItemTemplate != None)
	{
		for(i = 0; i < iNumberOfAlloys ; i++) BattleDataState.AutoLootBucket.AddItem(ItemTemplate.DataName);
	}

	ItemsRecovered += iNumberOfAlloys;

	ItemTemplate = ItemTemplateManager.FindItemTemplate('EleriumDust');
	if(ItemTemplate != None)
	{
		for(i = 0; i < iNumberOfElerium ; i++) BattleDataState.AutoLootBucket.AddItem(ItemTemplate.DataName);
	}

	ItemsRecovered += iNumberOfElerium;

	NewGameState.AddStateObject(BattleDataState);
	return true;
}

simulated function float ComputeEffectiveForceLevel(X2CharacterTemplate CharTemplate)
{
	/* WOTC TODO: The base game appears to have nothing like LeaderLevelSpawnWeights any more (I assume that's
	   where this came from). Using an average force level, but we need a proper, scaling solution. Ideally one
	   that scales based on the enemies that the unit is facing.
	if(CharTemplate.LeaderLevelSpawnWeights.Length > 0)
	{
		return (CharTemplate.LeaderLevelSpawnWeights[0].MinForceLevel + CharTemplate.LeaderLevelSpawnWeights[0].MaxForceLevel) / 2.0;
	}
	if(CharTemplate.FollowerLevelSpawnWeights.Length > 0)
	{
		return (CharTemplate.FollowerLevelSpawnWeights[0].MinForceLevel + CharTemplate.FollowerLevelSpawnWeights[0].MaxForceLevel) / 2.0;
	}
	*/
	return float(XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData')).GetForceLevel());
}

//function RollForScavengerAutoLoot(XComGameState NewGameState, XComGameState_Unit DeadUnit)
//{
	//local LootResults PendingAutoLoot;
	//local XComGameState_BattleData BattleDataState;
	//local XComGameStateHistory History;
	//local Name LootTemplateName;
	//local X2ItemTemplateManager ItemTemplateManager;
	//local X2ItemTemplate ItemTemplate;
	//local X2CharacterTemplate CharTemplate;
//
	//CharTemplate = DeadUnit.GetMyTemplate();
//
	//if( CharTemplate.Loot.LootReferences.Length > 0)
	//{
		//class'X2LootTableManager'.static.GetLootTableManager().RollForLootCarrier(CharTemplate.Loot, PendingAutoLoot);
//
		//if( PendingAutoLoot.LootToBeCreated.Length > 0 )
		//{
			//NewGameState.GetContext().PostBuildVisualizationFn.AddItem(VisualizeScavengerAutoLoot);
//
			//History = `XCOMHISTORY;
			//BattleDataState = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
			//BattleDataState = XComGameState_BattleData(NewGameState.CreateStateObject(class'XComGameState_BattleData', BattleDataState.ObjectID));
			//ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
//
			//foreach PendingAutoLoot.LootToBeCreated(LootTemplateName)
			//{
				//`log("Scavenger: checking for item=" $ LootTemplateName);
				//ItemTemplate = ItemTemplateManager.FindItemTemplate(LootTemplateName);
				//if( (ItemTemplate != None) && (class'X2Effect_Scavenger'.default.VALID_SCAVENGER_AUTOLOOT_TYPES.Find(ItemTemplate.DataName) != -1))
				//{
					//`log("Scavenger: item=" $ LootTemplateName $ " passed type gate");
					//if (`SYNC_FRAND < class'X2Effect_Scavenger'.default.SCAVENGER_AUTOLOOT_CHANCE) // each applicable item rolled has a % chance to be added
					//{
						//`log("Scavenger: item=" $ LootTemplateName $ " passed roll");
						//BattleDataState.AutoLootBucket.AddItem(ItemTemplate.DataName);
					//}
				//}
			//}
			//NewGameState.AddStateObject(BattleDataState);
		//}
	//}
//}

function VisualizeScavengerAutoLoot(XComGameState VisualizeGameState)
{
	local XComGameState_BattleData OldBattleData, NewBattleData;
	local XComGameStateHistory History;
	local int LootBucketIndex;
	local VisualizationActionMetadata BuildTrack;
	local X2Action_PlayWorldMessage MessageAction;
	local XGParamTag kTag;
	local X2ItemTemplateManager ItemTemplateManager;
	local array<Name> UniqueItemNames;
	local array<int> ItemQuantities;
	local int ExistingIndex;

	History = `XCOMHISTORY;

	// add a message for each loot drop
	NewBattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	NewBattleData = XComGameState_BattleData(History.GetGameStateForObjectID(NewBattleData.ObjectID, , VisualizeGameState.HistoryIndex));
	OldBattleData = XComGameState_BattleData(History.GetGameStateForObjectID(NewBattleData.ObjectID, , VisualizeGameState.HistoryIndex - 1));

	History.GetCurrentAndPreviousGameStatesForObjectID(ObjectID, BuildTrack.StateObject_OldState, BuildTrack.StateObject_NewState, eReturnType_Reference, VisualizeGameState.HistoryIndex);
	BuildTrack.VisualizeActor = History.GetVisualizer(ObjectID);

	MessageAction = X2Action_PlayWorldMessage(class'X2Action_PlayWorldMessage'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext(), false, BuildTrack.LastActionAdded));

	kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	for( LootBucketIndex = OldBattleData.AutoLootBucket.Length; LootBucketIndex < NewBattleData.AutoLootBucket.Length; ++LootBucketIndex )
	{
		ExistingIndex = UniqueItemNames.Find(NewBattleData.AutoLootBucket[LootBucketIndex]);
		if( ExistingIndex == INDEX_NONE )
		{
			UniqueItemNames.AddItem(NewBattleData.AutoLootBucket[LootBucketIndex]);
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
		MessageAction.AddWorldMessage(`XEXPAND.ExpandString(m_strScavengerLoot));
	}
}
