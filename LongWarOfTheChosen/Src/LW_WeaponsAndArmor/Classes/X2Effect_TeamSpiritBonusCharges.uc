class X2Effect_TeamSpiritBonusCharges extends X2Effect_Persistent;

var int NumCharges;
var name AbilityName;

simulated function bool OnEffectTicked(const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication, XComGameState_Player Player) {
	local XComGameState_Unit UnitState;
	local XComGameState_Ability AbilityState;
			
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(UnitState.FindAbility(AbilityName).ObjectID ));
	
	if ( AbilityState != none ) {
		AbilityState.iCharges += NumCharges;
	}

	return false;
}