class X2Effect_RuptureImmunity extends X2Effect_Persistent;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local Object EffectObj;

	EffectObj = EffectGameState;

	`XEVENTMGR.RegisterForEvent(EffectObj, 'UnitTakeEffectDamage', OnUnitTakeEffectDamage, ELD_OnStateSubmitted,,,, EffectGameState);
}

static function EventListenerReturn OnUnitTakeEffectDamage(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Effect EffectGameState;
	local XComGameStateHistory History;
	local XComGameState_Unit    SourceUnit;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState NewGameState;

	if (GameState.GetContext().InterruptionStatus == eInterruptionStatus_Interrupt)
		return ELR_NoInterrupt;

	EffectGameState = XComGameState_Effect(CallbackData);
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

	//	if not taking damage from an ability, ignore it (e.g. damage over time effects)
	if (AbilityContext == none)
		return ELR_NoInterrupt;

	History = `XCOMHISTORY;
	
	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	// short circuit if unit is not ruptured
	if (SourceUnit.Ruptured == 0)
		return ELR_NoInterrupt;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Remove Rupture from unit");
	SourceUnit = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit',EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
    //Clear Out the Unit's Rupture
    SourceUnit.Ruptured = 0;
	
	`LWTrace("Setting unit rupture to 0:" @SourceUnit.GetMyTemplateName());

	`TACTICALRULES.SubmitGameState(NewGameState);

    return ELR_NoInterrupt;
}
