class X2Effect_AcidEveryAction extends X2Effect_Burning;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMan;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMan = `XEVENTMGR;
	EffectObj = EffectGameState;
	
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	EventMan.RegisterForEvent(EffectObj, 'AbilityActivated', Ability_Tick_Listener, ELD_OnVisualizationBlockCompleted,, UnitState,, EffectObj);
	EventMan.RegisterForEvent(EffectObj, 'UnitTakeEffectDamage', Damage_Taken_Listener, ELD_OnVisualizationBlockCompleted,, UnitState,, EffectObj);
}

//	Big thanks to MrNice for this.
static function EventListenerReturn Ability_Tick_Listener(Object EventData, Object EventSource, XComGameState GameState, name InEventID, Object CallbackData)
{
	local XComGameState_Effect		EffectGameState;
	local XComGameState_Ability		AbilityState;
	local X2AbilityTemplate			AbilityTemplate;

	EffectGameState = XComGameState_Effect(CallbackData);
	AbilityState = XComGameState_Ability(EventData);
	AbilityTemplate = AbilityState.GetMyTemplate();

	if (AbilityCostsActionPoints(AbilityTemplate) && GameState.GetContext().GetFirstStateInEventChain() == GameState)
	{
		EffectGameState.OnPlayerTurnTicked(EventData, EventSource, GameState, InEventID, CallbackData);
	}

	return ELR_NoInterrupt;
}

static function EventListenerReturn Damage_Taken_Listener(Object EventData, Object EventSource, XComGameState GameState, name InEventID, Object CallbackData)
{
	local XComGameState_Effect		EffectGameState;
	local XComGameState_Unit		UnitState;

	EffectGameState = XComGameState_Effect(CallbackData);
	UnitState = XComGameState_Unit(EventData);
	
	//	If the unit takes damage from something other than Acid, tick the Acid effect.
	if (UnitState.DamageResults[UnitState.DamageResults.Length - 1].DamageTypes.Find('Acid') == INDEX_NONE)
	{
		EffectGameState.OnPlayerTurnTicked(EventData, EventSource, GameState, InEventID, CallbackData);
	}

	return ELR_NoInterrupt;
}

static function bool AbilityCostsActionPoints(const X2AbilityTemplate Template)
{
	local X2AbilityCost_ActionPoints ActionPoints;
	local int i;

	for (i = 0; i < Template.AbilityCosts.Length; i++)
	{
		ActionPoints = X2AbilityCost_ActionPoints(Template.AbilityCosts[i]);
		if (ActionPoints != none && (ActionPoints.iNumPoints > 0 && !ActionPoints.bFreeCost || ActionPoints.bMoveCost))
			return true;
	}
	return false;
}

//	Allows this effect to tick whenever we call OnPlayerTurnTicked()
simulated function bool FullTurnComplete(XComGameState_Effect kEffect, XComGameState_Player Player)
{
	return true;
}

simulated function SetBurnDamageEffect(X2Effect_ApplyWeaponDamage BurnDamage)
{
	ApplyOnTick.AddItem(BurnDamage);
}

defaultproperties
{
	EffectName = "IRI_Rocket_Acid_Effect";
}