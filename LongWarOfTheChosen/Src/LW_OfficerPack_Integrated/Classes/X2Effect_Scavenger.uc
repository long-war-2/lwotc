//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_Scavenger
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Implements effect for Scavenger ability
//--------------------------------------------------------------------------------------- 
//---------------------------------------------------------------------------------------
class X2Effect_Scavenger extends X2Effect_Persistent config(LW_OfficerPack);

var localized string m_strScavengerLoot;
var config float SCAVENGER_BONUS_MULTIPLIER;
var config float SCAVENGER_AUTOLOOT_CHANCE_MIN;
var config float SCAVENGER_AUTOLOOT_CHANCE_MAX;
var config float SCAVENGER_AUTOLOOT_NUMBER_MIN;
var config float SCAVENGER_AUTOLOOT_NUMBER_MAX;
var config float SCAVENGER_ELERIUM_TO_ALLOY_RATIO;
var config int SCAVENGER_MAX_PER_MISSION;
var config array<name> VALID_SCAVENGER_AUTOLOOT_TYPES;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local Object EffectObj;

	EffectObj = EffectGameState;

	// allows activation/deactivation of effect
	`XEVENTMGR.RegisterForEvent(EffectObj, 'KillMail', ScavengerAutoLoot, ELD_OnStateSubmitted,,,, EffectObj);
}

//handle granting extra alloys/elerium on kill -- use 'KillMail' event instead of 'OnUnitDied' so gamestate is updated after regular auto-loot, instead of before
static function EventListenerReturn ScavengerAutoLoot(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState NewGameState;
	local XComGameState_Effect_EffectCounter EffectState;
	local XComGameState_Unit KillerUnit, DeadUnit, ScavengingUnit;
	local XComGameStateHistory History;
	local LWTuple OverrideActivation;

	History = `XCOMHISTORY;

	KillerUnit = XComGameState_Unit(EventSource);
	if (KillerUnit == none)
	{
		`RedScreen("ScavengerCheck: no attacking unit");
		return ELR_NoInterrupt;
	}

	if ((KillerUnit.GetTeam() != eTeam_XCom) || KillerUnit.IsMindControlled()) { return ELR_NoInterrupt; }

	EffectState = XComGameState_Effect_EffectCounter(CallbackData);
	if (EffectState == none)
	{
		`RedScreen("ScavengerCheck: no effect game state");
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
	OverrideActivation = new class'LWTuple';
	OverrideActivation.Id = 'OverrideScavengerActivation';
	OverrideActivation.Data.Length = 1;
	OverrideActivation.Data[0].kind = LWTVBool;
	OverrideActivation.Data[0].b = false;
	`XEVENTMGR.TriggerEvent('OverrideScavengerActivation', OverrideActivation, EffectState);

	if(OverrideActivation.Data[0].b)
	{
		`LOG("TRACE: Skipping Scavenger From Override");
		return ELR_NoInterrupt;
	}

	if(!ScavengingUnit.IsAbleToAct()) { return ELR_NoInterrupt; }
	if(ScavengingUnit.bRemovedFromPlay) { return ELR_NoInterrupt; }
	if(ScavengingUnit.IsMindControlled()) { return ELR_NoInterrupt; }

	DeadUnit = XComGameState_Unit (EventData);
	if (DeadUnit == none)
	{
		`RedScreen("ScavengerCheck: no dead unit");
		return ELR_NoInterrupt;
	}

	//add checks to make sure that killer is a permanent part of the XCOM team, dead unit is enemy
	if ((DeadUnit.GetTeam() == eTeam_Alien) && DeadUnit.IsLootable(GameState) && !DeadUnit.bKilledByExplosion)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
		EffectState = XComGameState_Effect_EffectCounter(NewGameState.ModifyStateObject(EffectState.Class, EffectState.ObjectID));
		if(RollForScavengerForceLevelLoot(NewGameState, EffectState, DeadUnit))
		{
			`TACTICALRULES.SubmitGameState(NewGameState);
		}
		else
		{
			History.CleanupPendingGameState(NewGameState);
		}
	}

	return ELR_NoInterrupt;
}

static function bool RollForScavengerForceLevelLoot(XComGameState NewGameState, XComGameState_Effect_EffectCounter EffectState, XComGameState_Unit DeadUnit)
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

	History = `XCOMHISTORY;
	BattleDataState = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	CharTemplate = DeadUnit.GetMyTemplate();

	if (CharTemplate.bIsAdvent)
	{
		return false;
	}
	ForceLevel = ComputeEffectiveForceLevel(BattleDataState);

	RollChance = default.SCAVENGER_AUTOLOOT_CHANCE_MIN + ForceLevel/20.0 * (default.SCAVENGER_AUTOLOOT_CHANCE_MAX - default.SCAVENGER_AUTOLOOT_CHANCE_MIN);
	RollChance = FClamp(RollChance, default.SCAVENGER_AUTOLOOT_CHANCE_MIN, default.SCAVENGER_AUTOLOOT_CHANCE_MAX);

	fNumberOfRolls = default.SCAVENGER_AUTOLOOT_NUMBER_MIN + ForceLevel/20.0 * (default.SCAVENGER_AUTOLOOT_NUMBER_MAX - default.SCAVENGER_AUTOLOOT_CHANCE_MIN);
	fNumberOfRolls = FClamp(fNumberOfRolls, default.SCAVENGER_AUTOLOOT_NUMBER_MIN, default.SCAVENGER_AUTOLOOT_NUMBER_MAX);
	iNumberOfRollsAlloys = int(fNumberOfRolls);
	if(`SYNC_FRAND_STATIC() < (fNumberOfRolls - float(iNumberOfRollsAlloys)))
	{
		iNumberOfRollsAlloys++;
	}

	iNumberOfRollsElerium = int(fNumberOfRolls * default.SCAVENGER_ELERIUM_TO_ALLOY_RATIO);
	if(`SYNC_FRAND_STATIC() < (fNumberOfRolls - float(iNumberOfRollsElerium)))
	{
		iNumberOfRollsElerium++;
	}

	for(i = 0; i < iNumberOfRollsAlloys ; i++) 	{ if(`SYNC_FRAND_STATIC() < RollChance) iNumberOfAlloys++; }
	for(i = 0; i < iNumberOfRollsElerium ; i++) 	{ if(`SYNC_FRAND_STATIC() < RollChance) iNumberOfElerium++; }

	if((iNumberOfAlloys == 0) && (iNumberOfElerium == 0)) return false;

	if (EffectState.uses > default.SCAVENGER_MAX_PER_MISSION) return false;

	NewGameState.GetContext().PostBuildVisualizationFn.AddItem(VisualizeScavengerAutoLoot);

	BattleDataState = XComGameState_BattleData(NewGameState.ModifyStateObject(class'XComGameState_BattleData', BattleDataState.ObjectID));
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	ItemTemplate = ItemTemplateManager.FindItemTemplate('AlienAlloy');
	if(ItemTemplate != None)
	{
		for(i = 0; i < iNumberOfAlloys ; i++) BattleDataState.AutoLootBucket.AddItem(ItemTemplate.DataName);
	}

	EffectState.uses += iNumberOfAlloys;

	ItemTemplate = ItemTemplateManager.FindItemTemplate('EleriumDust');
	if(ItemTemplate != None)
	{
		for(i = 0; i < iNumberOfElerium ; i++) BattleDataState.AutoLootBucket.AddItem(ItemTemplate.DataName);
	}

	EffectState.uses += iNumberOfElerium;

	return true;
}

static function float ComputeEffectiveForceLevel(XComGameState_BattleData BattleDataState)
{
	return float(BattleDataState.GetForceLevel());
}

static function VisualizeScavengerAutoLoot(XComGameState VisualizeGameState)
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
		MessageAction.AddWorldMessage(`XEXPAND.ExpandString(default.m_strScavengerLoot));
	}
}

defaultproperties
{
	EffectName=Scavenger;
	GameStateEffectClass=class'XComGameState_Effect_EffectCounter';
	bRemoveWhenSourceDies=false;
}
