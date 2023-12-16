class X2Effect_TemplarShieldAnimations extends X2Effect_AdditionalAnimSets;

// A version of Additional AnimSet effects that is set up to remove itself whenever the unit's Shield HP is exhausted.

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	EffectObj = EffectGameState;

	EventMgr.RegisterForEvent(EffectObj, 'ShieldsExpended', EffectGameState.OnShieldsExpended, ELD_OnStateSubmitted, , UnitState);
}

defaultproperties
{
	EffectName = "IRI_X2Effect_TemplarShieldAnimations"
	DuplicateResponse = eDupe_Ignore
}
