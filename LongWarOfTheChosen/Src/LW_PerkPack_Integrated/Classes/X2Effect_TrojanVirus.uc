///---------------------------------------------------------------------------------------
//  FILE:    X2Effect_Trojan
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Implements effect for TrojanVirus ability -- hacked target has special effects at end of hack
//--------------------------------------------------------------------------------------- 
//---------------------------------------------------------------------------------------
class X2Effect_TrojanVirus extends X2Effect_Persistent config(LW_SoldierSkills);

var config int TROJANVIRUSROLLS;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;

	// Use a low priority so that the listener triggers *after* the last shutdown tick. Otherwise,
	// the check for IsStunned() happens while the target is still stunned, so the virus doesn't
	// trigger, but then the stun is removed and the target has actions to do something horrible.
	// Tedster: try dropping Trojan ELR priority even more to catch post hack end.
	EventMgr.RegisterForEvent(EffectObj,  'UnitGroupTurnBegun', PostEffectTickCheck, ELD_OnStateSubmitted, 12,,, EffectObj);
	EventMgr.RegisterForEvent(EffectObj,  'MindControlLost', OnMindControlLost, ELD_OnStateSubmitted, 12,,, EffectObj);
}

//This is triggered at the start of each turn, after OnTickEffects (so after Hack stun/Mind Control effects are lost)
//The purpose is to check and see if those effects have been removed, in which case the Trojan Virus effects activate, then the effect is removed
static function EventListenerReturn PostEffectTickCheck(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameStateContext_TickEffect TickContext;
	local XComGameState NewGameState;
	local XComGameState_AIGroup GroupState;
	local XComGameState_Unit OldTargetState, NewTargetState, SourceState;
	local XComGameState_Effect EffectState;
	local float AttackerHackStat, DefenderHackDefense, Damage;
	local int idx;

	History = `XCOMHISTORY;
	EffectState = XComGameState_Effect(CallbackData);
	GroupState = XComGameState_AIGroup(EventSource);
	OldTargetState = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	SourceState = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	// short circuit if the effect is already removed
	if(EffectState.bRemoved)
	{
		return ELR_NoInterrupt;
	}

	// Ignore if the current group doesn't match the target's
	`LWTrace("Trojan check: current unit:" @OldTargetState);
	`LWTrace("Trojan check: unit group is " @OldTargetState.GetGroupMembership() @"Compared to" @GroupState);
	if (OldTargetState.GetGroupMembership().ObjectID != GroupState.ObjectID)
	{
		return ELR_NoInterrupt;
	}

	`LWTrace("Trojan check: unit is mindcontrolled:" @OldTargetState.IsMindControlled() @". unit is stunned:" @OldTargetState.IsStunned());
	// don't do anything if unit is still mind controlled or stunned
	if(OldTargetState.IsMindControlled() || OldTargetState.IsStunned() || OldTargetState.AffectedByEffectNames.Find('FullOverride') != INDEX_NONE)
		return ELR_NoInterrupt;

	//NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Apply Trojan Virus Effects");
	TickContext = class'XComGameStateContext_TickEffect'.static.CreateTickContext(EffectState);
	NewGameState = History.CreateNewGameState(true, TickContext);
	NewTargetState = XComGameState_Unit(NewGameState.ModifyStateObject(OldTargetState.Class, OldTargetState.ObjectID));

	// effect has worn off, Trojan Virus now kicks in
	// Compute damage
	Damage = 0;
	AttackerHackStat = SourceState.GetCurrentStat(eStat_Hacking) + SourceState.GetUIStatFromAbilities(eStat_Hacking) + SourceState.GetUIStatFromInventory(eStat_Hacking, GameState);
	DefenderHackDefense = OldTargetState.GetCurrentStat(eStat_HackDefense);
	for(idx = 0; idx < default.TROJANVIRUSROLLS; idx++)
	{
		if(`SYNC_RAND_STATIC(100) < 50 + AttackerHackStat - DefenderHackDefense)
			Damage += 1.0;
	}
	NewTargetState.TakeEffectDamage(EffectState.GetX2Effect(), Damage, 0, 0, EffectState.ApplyEffectParameters,  NewGameState, false, false, true);

	//remove actions
	if(NewTargetState.IsAlive())
	{
		NewTargetState.ActionPoints.Length = 0;
		NewTargetState.ReserveActionPoints.Length = 0;
		NewTargetState.SkippedActionPoints.Length = 0;
	}

	//check that it wasn't removed already because of the unit being killed from damage
	if(!EffectState.bRemoved)
		EffectState.RemoveEffect(NewGameState, NewGameState);
	if( NewGameState.GetNumGameStateObjects() > 0 )
		`TACTICALRULES.SubmitGameState(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);

	return ELR_NoInterrupt;
}

static function EventListenerReturn OnMindControlLost(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_Unit UnitState;
	local XComGameStateHistory History;
	local XComGameStateContext_TickEffect TickContext;
	local XComGameState NewGameState;
	local XComGameState_Unit OldTargetState, NewTargetState, SourceState;
	local XComGameState_Effect EffectState;
	local StateObjectReference EffectRef;
	local float AttackerHackStat, DefenderHackDefense, Damage;
	local int idx;
	
	UnitState = XCOmGameState_Unit(EventData);
	History = `XCOMHISTORY;

	foreach UnitState.AffectedByEffects(EffectRef)
	{
		EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));

		if(EffectState.GetX2Effect().EffectName == 'TrojanVirus')
		{
			break;
		}
	}

	// short circuit if effect is gone.
	if(EffectState.GetX2Effect().EffectName != 'TrojanVirus' || EffectState.bRemoved)
	{
		return ELR_NoInterrupt;
	}

	TickContext = class'XComGameStateContext_TickEffect'.static.CreateTickContext(EffectState);
	NewGameState = History.CreateNewGameState(true, TickContext);

	OldTargetState = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	SourceState = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	if(OldTargetState.IsStunned() || OldTargetState.AffectedByEffectNames.Find('FullOverride') != INDEX_NONE)
		return ELR_NoInterrupt;


	
	NewTargetState = XComGameState_Unit(NewGameState.ModifyStateObject(OldTargetState.Class, OldTargetState.ObjectID));

	// effect has worn off, Trojan Virus now kicks in
	// Compute damage
	Damage = 0;
	AttackerHackStat = SourceState.GetCurrentStat(eStat_Hacking) + SourceState.GetUIStatFromAbilities(eStat_Hacking) + SourceState.GetUIStatFromInventory(eStat_Hacking, GameState);
	DefenderHackDefense = OldTargetState.GetCurrentStat(eStat_HackDefense);
	for(idx = 0; idx < default.TROJANVIRUSROLLS; idx++)
	{
		if(`SYNC_RAND_STATIC(100) < 50 + AttackerHackStat - DefenderHackDefense)
			Damage += 1.0;
	}
	NewTargetState.TakeEffectDamage(EffectState.GetX2Effect(), Damage, 0, 0, EffectState.ApplyEffectParameters,  NewGameState, false, false, true);

	//remove actions
	if(NewTargetState.IsAlive())
	{
		NewTargetState.ActionPoints.Length = 0;
		NewTargetState.ReserveActionPoints.Length = 0;
		NewTargetState.SkippedActionPoints.Length = 0;
	}

	//check that it wasn't removed already because of the unit being killed from damage
	if(!EffectState.bRemoved)
		EffectState.RemoveEffect(NewGameState, NewGameState);
	if( NewGameState.GetNumGameStateObjects() > 0 )
		`TACTICALRULES.SubmitGameState(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);



	return ELR_NoInterrupt;
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
	EffectName="TrojanVirus";
	bRemoveWhenSourceDies=true;
}
