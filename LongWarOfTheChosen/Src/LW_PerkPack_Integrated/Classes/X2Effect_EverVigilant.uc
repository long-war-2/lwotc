class X2Effect_EverVigilant extends X2Effect_Persistent config(LW_SoldierSkills);

var config array<name> EverVigilantIgnore;
var config array<name> EverVigilantStopOnAbility;

var config array<name> OverwatchAbilities;

var config int TurnEndEventPriority;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager EventMgr;
    local Object EffectObj;
    local XComGameState_EffectEverVigilant EffectState;
    local XComGameState_Unit UnitState;
    local XComGameState_Player PlayerState;

    UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

    if(UnitState != none)
    {
        PlayerState = XComGameState_Player(`XCOMHISTORY.GetGameStateForObjectID(UnitState.ControllingPlayer.ObjectID));
    }

    if(PlayerState != none)
    {
        EffectState = XComGameState_EffectEverVigilant(EffectGameState);
    }
    if(EffectState != none)
    {
        EventMgr = `XEVENTMGR;

        EffectObj = EffectGameState;
        
        EventMgr.RegisterForEvent(EffectObj, 'PlayerTurnEnded', EffectState.EverVigilantTurnEndListener, ELD_OnStateSubmitted, class'X2Effect_EverVigilant'.default.TurnEndEventPriority, PlayerState);
        EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', EffectState.AbilityTriggerUsedListener, ELD_OnStateSubmitted,, UnitState);
        //`log("Effect registered",, 'NewEverVigilant');
    }
}

defaultproperties
{
	GameStateEffectClass = class'XComGameState_EffectEverVigilant';
	EffectName = "BEverVigilantEffect";
}