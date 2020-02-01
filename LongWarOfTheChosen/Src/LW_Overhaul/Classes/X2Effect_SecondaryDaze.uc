class X2Effect_SecondaryDaze extends X2Effect_Persistent;

//	Event Listener must be registered in a unique effect to make sure if the soldier has multiple weapons with Singe equipped, Singe is activated only once.
//	Otherwise, the soldier will have several identical listeners which will all correctly execute Singe at the same time.

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager		EventMgr;
	local XComGameState_Unit	SourceUnitState;
	local Object				EffectObj;

	EventMgr = `XEVENTMGR;
	EffectObj = EffectGameState;
	SourceUnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', class'X2Ability_LW_ChosenAbilities'.static.AbilityTriggerEventListener_SecondaryDaze, ELD_OnStateSubmitted, 40, SourceUnitState);
}

DefaultProperties
{
    EffectName="SecondaryDazeEffect"
    DuplicateResponse=eDupe_Ignore
}