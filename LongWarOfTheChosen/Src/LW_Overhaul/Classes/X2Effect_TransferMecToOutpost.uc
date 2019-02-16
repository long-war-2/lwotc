//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_TransferMecToOutpost.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Basic LW version of holotargeting effect
//---------------------------------------------------------------------------------------
class X2Effect_TransferMecToOutpost extends X2Effect_Persistent config(LW_SoldierSkills);

var config array<name> VALID_FULLOVERRIDE_TYPES_TO_TRANSFER_TO_OUTPOST;

simulated function AddMECToOutpostIfValid(XComGameState_Effect EffectState, XComGameState_Unit TargetUnit, XComGameState NewGameState, bool GiveWreck)
{
	local XComGameStateHistory History;
	local XComGameState_BattleData BattleData;
	local XComGamestate_MissionSite MissionState;
	local XComGameState_LWOutpostManager OutpostMgr;
	local XComGameState_WorldRegion Region;
	local XComGameState_LWOutpost LocalOutpost, UpdatedOutpost;

	if (TargetUnit == none || TargetUnit.IsDead() || TargetUnit.bCaptured)
		return;

	if(!IsValidEnemyType(TargetUnit))
	{
		if (GiveWreck)
		{
			// This isn't a transferrable unit type. As a consolation prize, have a wreck/loot!
			TargetUnit.RollForAutoLoot(NewGameState);
		}
		return;
	}

	History = `XCOMHISTORY;
	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	if(BattleData == none)
		return;
	MissionState = XComGameState_MissionSite(History.GetGameStateForObjectID(BattleData.m_iMissionID));
	if(MissionState == none)
		return;
	Region = MissionState.GetWorldRegion();
	if(Region == none)
		return;
	OutpostMgr = class'XComGameState_LWOutpostManager'.static.GetOutpostManager(true); // allow null to avoid redscreens when testing tactical stuff
	if(OutpostMgr == none)
		return;
	LocalOutpost = OutpostMgr.GetOutpostForRegion(Region);
	if(LocalOutpost == none)
		return;

	UpdatedOutpost = XComGameState_LWOutpost(NewGameState.ModifyStateObject(class'XComGameState_LWOutpost', LocalOutpost.ObjectID));
	UpdatedOutpost.AddResistanceMEC(UpdatedOutpost.CreateResistanceMec(NewGameState), NewGameState);
}

function bool IsValidEnemyType(XComGameState_Unit UnitState)
{
	if(default.VALID_FULLOVERRIDE_TYPES_TO_TRANSFER_TO_OUTPOST.Find(UnitState.GetMyTemplateName()) != -1)
		return true;

	return false;
}

// listen for a unit death, bleeding out, or remove from play
// these conditions may leave only permanent mind-controlled entities left (which may not be able to evac), so end mind control in this case
function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;
	local XComGameState_Effect_TransferMecToOutpost TransferEffect;

	EventMgr = `XEVENTMGR;

	TransferEffect = XComGameState_Effect_TransferMecToOutpost(EffectGameState);
	if (TransferEffect == none)
	{
		`REDSCREEN("Unable to convert Effect gamestate to correct child class.\n\n" $ GetScriptTrace());
		return;
	}
	EffectObj = EffectGameState;

	// register listeners for all of the conditions that can reduce the number of playable units
	EventMgr.RegisterForEvent(EffectObj, 'UnitUnconscious', TransferEffect.UnitRemovedListener, ELD_OnStateSubmitted, 44);
	EventMgr.RegisterForEvent(EffectObj, 'UnitDied', TransferEffect.UnitRemovedListener, ELD_OnStateSubmitted, 44);
	EventMgr.RegisterForEvent(EffectObj, 'UnitBleedingOut', TransferEffect.UnitRemovedListener, ELD_OnStateSubmitted, 44);
	EventMgr.RegisterForEvent(EffectObj, 'UnitRemovedFromPlay', TransferEffect.UnitRemovedListener, ELD_OnStateSubmitted, 44);
	EventMgr.RegisterForEvent(EffectObj, 'UnitChangedTeam', TransferEffect.UnitRemovedListener, ELD_OnStateSubmitted, 44);
}

defaultproperties
{
	bRemoveWhenTargetDies=true
	bRemoveWhenSourceDies=false
	GameStateEffectClass = class'XComGameState_Effect_TransferMecToOutpost';
	EffectName="TransferMecToOutpost"
}
