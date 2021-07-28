//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_Unstoppable
//  AUTHOR:  Grobobobo
//
//  PURPOSE: Gives a buff to mobility when unit's mobility is below a certain amount.
//--------------------------------------------------------------------------------------- 
class X2Effect_Unstoppable extends X2Effect_PersistentStatChange;

var int MinimumMobility;


simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;
	local XComGameState_Ability AbilityState;
	local int i;
    local int Mob, MobDifference;
    local XComGameState_Effect EffectState;
    local bool Maimed;
    local StateObjectReference EffectRef;

	History = `XCOMHISTORY;
	UnitState = XComGameState_Unit(kNewTargetState);
    Mob = UnitState.GetCurrentStat(eStat_Mobility);
    MobDifference = MinimumMobility - UnitState.GetCurrentStat(eStat_Mobility);

    //Maim is purged, so don't take it into account
    foreach UnitState.AffectedByEffects(EffectRef)
    {
        // Loop over all effects affecting the target of the maim effect
        EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
        if(EffectState.GetX2Effect().isA('X2Effect_Immobilize'))
        {
            Maimed = true;
            break;
        }
    }
    if(UnitState.GetCurrentStat(eStat_Mobility) < MinimumMobility && !Maimed)
    {
        AddPersistentStatChange(eStat_Mobility,MinimumMobility - UnitState.GetCurrentStat(eStat_Mobility));
    }
    super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

defaultproperties
{
    DuplicateResponse = eDupe_Allow
    MinimumMobility = 7
}