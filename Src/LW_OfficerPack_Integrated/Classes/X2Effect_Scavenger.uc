//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_Scavenger
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Implements effect for Scavenger ability
//--------------------------------------------------------------------------------------- 
//---------------------------------------------------------------------------------------
class X2Effect_Scavenger extends X2Effect_Persistent config(LW_OfficerPack);

var config float SCAVENGER_BONUS_MULTIPLIER;
var config float SCAVENGER_AUTOLOOT_CHANCE_MIN;
var config float SCAVENGER_AUTOLOOT_CHANCE_MAX;
var config float SCAVENGER_AUTOLOOT_NUMBER_MIN;
var config float SCAVENGER_AUTOLOOT_NUMBER_MAX;
var config float SCAVENGER_ELERIUM_TO_ALLOY_RATIO;
var config int SCAVENGER_MAX_PER_MISSION;
var config array<name> VALID_SCAVENGER_AUTOLOOT_TYPES;


//add a component to XComGameState_Effect to track cumulative number of attacks
simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Effect_Scavenger EffectState;
	local X2EventManager EventMgr;
	local Object ListenerObj;

	EventMgr = `XEVENTMGR;

	if (GetScavengerComponent(NewEffectState) == none)
	{
		//create component and attach it to GameState_Effect, adding the new state object to the NewGameState container
		EffectState = XComGameState_Effect_Scavenger(NewGameState.CreateStateObject(class'XComGameState_Effect_Scavenger'));
		EffectState.InitComponent();
		NewEffectState.AddComponentObject(EffectState);
		NewGameState.AddStateObject(EffectState);
	}

	//add listener to new component effect -- do it here because the RegisterForEvents call happens before OnEffectAdded, so component doesn't yet exist
	ListenerObj = EffectState;
	if (ListenerObj == none)
	{
		`Redscreen("Scavenger: Failed to find Scavenger Component when registering listener");
		return;
	}
	//register on 'KillMail' instead of 'UnitDied' so Killer unit is passed, and so that it triggers after regular auto-loot
	EventMgr.RegisterForEvent(ListenerObj, 'KillMail', EffectState.ScavengerAutoLoot, ELD_OnStateSubmitted,,,true);
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameState_BaseObject EffectComponent;
	local Object EffectComponentObj;
	
	super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);

	EffectComponent = GetScavengerComponent(RemovedEffectState);
	if (EffectComponent == none)
		return;

	EffectComponentObj = EffectComponent;
	`XEVENTMGR.UnRegisterFromAllEvents(EffectComponentObj);

	NewGameState.RemoveStateObject(EffectComponent.ObjectID);
}

static function XComGameState_Effect_Scavenger GetScavengerComponent(XComGameState_Effect Effect)
{
	if (Effect != none) 
		return XComGameState_Effect_Scavenger(Effect.FindComponentObject(class'XComGameState_Effect_Scavenger'));
	return none;
}

// Moved to X2DLCInfo.OnPostMission
//on end of tactical play, if unit is still alive, add bonus to mission loot
//simulated function UnitEndedTacticalPlay(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
//{
	//local int idx, Bonus;
	////local bool bUpdatedAnyReward;
	//local XComGameStateHistory History;
	//local XComGameStateContext_ChangeContainer ChangeContainer;
	//local XComGameState UpdateState;
	//local XComGameState_MissionSite MissionState;
	//local XComGameState_Reward RewardState, UpdatedReward;
//
	////requires unit to be alive and conscious
	//if (UnitState == none || UnitState.IsDead() || UnitState.IsUnconscious())
		//return;
//
	//History = `XCOMHISTORY;
//
	////requires all objectives complete
	//if(!XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData')).AllStrategyObjectivesCompleted() )
		//return;
//
	//MissionState = XComGameState_MissionSite(History.GetGameStateForObjectID(`XCOMHQ.MissionRef.ObjectID));
	//ChangeContainer = class'XComGameStateContext_ChangeContainer'.static.CreateEmptyChangeContainer("Scavenger Reward Added");
	//UpdateState = History.CreateNewGameState(true, ChangeContainer);
//
	//for(idx = 0; idx < MissionState.Rewards.Length; idx++)
	//{
		//RewardState = XComGameState_Reward(History.GetGameStateForObjectID(MissionState.Rewards[idx].ObjectID));
		//UpdatedReward = XComGameState_Reward(UpdateState.CreateStateObject(class'XComGameState_Reward', RewardState.ObjectID));
//
		//switch(RewardState.GetMyTemplateName()) 
		//{
			//case 'Reward_Supplies': 
			//case 'Reward_Alloys': 
			//case 'Reward_Elerium': 
				//Bonus = RewardState.Quantity;
				//Bonus *= default.SCAVENGER_BONUS_MULTIPLIER;
				//UpdatedReward.Quantity += Max(1, Bonus);
				//UpdateState.AddStateObject(UpdatedReward);
				//`log("LW Officer Ability (Scavenger): RewardType=" $ RewardState.GetMyTemplateName() $ ", Amount=" $ Bonus);
				////bUpdatedAnyReward = true;
				//break;
			//default:
				//break;
		//}
	//}
	////if(bUpdatedAnyReward)
		//`TACTICALRULES.SubmitGameState(UpdateState);
	////else
		////History.CleanupPendingGameState(UpdateState);
//}


defaultproperties
{
	EffectName=Scavenger;
	bRemoveWhenSourceDies=false;
}
