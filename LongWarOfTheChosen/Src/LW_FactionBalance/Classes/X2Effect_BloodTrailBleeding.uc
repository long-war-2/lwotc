//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_BloodTrailBleeding
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Adds a bleeding effect on targets shot by a unit with Blood Trail.
//--------------------------------------------------------------------------------------- 

class X2Effect_BloodTrailBleeding extends X2Effect_Persistent;

// Registers a listener that is called when the Claymore is thrown, so that
// we can then attach another listener for when the Claymore is destroyed.
function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local Object EffectObj;

	EffectObj = EffectGameState;

	`XEVENTMGR.RegisterForEvent(EffectObj, 'UnitTakeEffectDamage', OnUnitTakeEffectDamage, ELD_OnStateSubmitted,,,, EffectGameState);
}

static function EventListenerReturn OnUnitTakeEffectDamage(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameState_Effect EffectGameState;
	local XComGameState_Ability AbilityState;
	local AvailableAction Action;
	local AvailableTarget Target;
	local XComGameStateHistory History;
	local XComGameState_Unit    UnitState, SourceUnit;
	local XComGameStateContext_Ability AbilityContext;
	local X2Effect CurrentEffect;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
	local bool TookNormalWeaponDamage;

	if (GameState.GetContext().InterruptionStatus == eInterruptionStatus_Interrupt)
		return ELR_NoInterrupt;

	EffectGameState = XComGameState_Effect(CallbackData);
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

	//	if not taking damage from an ability, ignore it (e.g. damage over time effects)
	if (AbilityContext == none)
		return ELR_NoInterrupt;

	History = `XCOMHISTORY;
	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	// Check that it's the unit with the Blood Trail effect that caused the damage
	if (AbilityContext.InputContext.SourceObject.ObjectID != SourceUnit.ObjectID)
		return ELR_NoInterrupt;

	// Now check to see whether the ability caused normal weapon damage, rather than
	// just poison or explosive or whatever.
	foreach AbilityContext.ResultContext.TargetEffectResults.Effects(CurrentEffect)
	{
		WeaponDamageEffect = X2Effect_ApplyWeaponDamage(CurrentEffect);
		if (WeaponDamageEffect != none && WeaponDamageEffect.DamageTag == '')
		{
			TookNormalWeaponDamage = true;
			break;
		}
	}

	if (!TookNormalWeaponDamage)
		return ELR_NoInterrupt;

	Action.AbilityObjectRef = SourceUnit.FindAbility('ApplyBloodTrailBleeding');
	if (Action.AbilityObjectRef.ObjectID != 0)
	{
		AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(Action.AbilityObjectRef.ObjectID));
		if (AbilityState != none)
		{
			Action.AvailableCode = 'AA_Success';
			UnitState = XComGameState_Unit(EventSource);
			Target.PrimaryTarget = UnitState.GetReference();
			Action.AvailableTargets.AddItem(Target);
			class'XComGameStateContext_Ability'.static.ActivateAbility(Action, 0,, ,,,GameState.HistoryIndex);
		}
	}
	return ELR_NoInterrupt;
}

defaultProperties
{
	GameStateEffectClass = class'XComGameState_Effect_AbilityTrigger';
	bInfiniteDuration = true;
}
