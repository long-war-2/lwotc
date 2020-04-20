//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_ImmediateMultiTargetAbilityActivation.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Variation of base-game ImmediateAbilityActivation that works correctly when applied to multiple targets
//---------------------------------------------------------------------------------------
class X2Effect_ImmediateMultiTargetAbilityActivation extends X2Effect_Persistent;

var name AbilityName;      // Used to identify the ability that this effect will trigger

var private name EventName;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	EventMgr.RegisterForEvent(EffectObj, default.EventName, OnFireImmediateMultiTargetAbility, ELD_OnStateSubmitted,, UnitState, true, EffectObj);
}

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit						SourceUnit, TargetUnit;
	local XComGameStateHistory						History;

	History = `XCOMHISTORY;

	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	if (AbilityName == '')
	{
		`RedScreen("X2Effect_ImmediateMultiTargetAbilityActivation - AbilityName must be set:"@AbilityName);
	}

	`XEVENTMGR.TriggerEvent(default.EventName, TargetUnit, SourceUnit, NewGameState);
}

// This is called when the a X2Effect_ImmediateMultiTargetAbilityActivation is added to a unit
static function EventListenerReturn OnFireImmediateMultiTargetAbility(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_Unit EffectSourceUnit, EffectTargetUnit, EventTargetUnit;
	local X2Effect_ImmediateMultiTargetAbilityActivation EffectTemplate;
	local StateObjectReference AbilityRef;
	local XComGameStateHistory History;
	local X2TacticalGameRuleset TacticalRules;
	local GameRulesCache_Unit UnitCache;
	local int i, j;
	local XComGameStateContext_EffectRemoved EffectRemovedState;
	local XComGameState NewGameState;
	local XComGameState_Effect EffectState;
	
	History = `XCOMHISTORY;
	
	EffectState = XComGameState_Effect(CallbackData);

	EffectSourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	`assert(EffectSourceUnit != none);
	EffectTargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if( EffectTargetUnit == None )
	{
		// Target can be an interactive object, in which case, we don't want to apply any effects.
		return ELR_NoInterrupt;
	}

	//multi-target handling -- make sure that the target units are the same, effect and event -- source unit filtering is handled via PreFilter in X2EventManager
	EventTargetUnit = XComGameState_Unit(EventData);
	if(EventTargetUnit.ObjectID != EffectTargetUnit.ObjectID)
		return ELR_NoInterrupt;

	EffectTemplate = X2Effect_ImmediateMultiTargetAbilityActivation(EffectState.GetX2Effect());
	if(EffectTemplate == none)
	{
		`REDSCREEN("MultiTargetImmediate called with invalid X2Effect type.");
		return ELR_NoInterrupt;
	}

	// Get the associated sustain ability and attempt to build a context for it
	AbilityRef = EffectSourceUnit.FindAbility(EffectTemplate.AbilityName);
	if(AbilityRef.ObjectID == 0)
	{
		`REDSCREEN("MultiTargetImmediate called with invalid ability " $ EffectTemplate.AbilityName);
		return ELR_NoInterrupt;
	}

	TacticalRules = `TACTICALRULES;

	if (TacticalRules.GetGameRulesCache_Unit(EffectSourceUnit.GetReference(), UnitCache))
	{
		for (i = 0; i < UnitCache.AvailableActions.Length; ++i)
		{
			if (UnitCache.AvailableActions[i].AbilityObjectRef.ObjectID == AbilityRef.ObjectID)
			{
				for (j = 0; j < UnitCache.AvailableActions[i].AvailableTargets.Length; ++j)
				{
					if (UnitCache.AvailableActions[i].AvailableTargets[j].PrimaryTarget.ObjectID == EffectTargetUnit.ObjectID)
					{
						if (UnitCache.AvailableActions[i].AvailableCode == 'AA_Success')
						{
							EffectRemovedState = class'XComGameStateContext_EffectRemoved'.static.CreateEffectRemovedContext(EffectState);
							NewGameState = History.CreateNewGameState(true, EffectRemovedState);
							EffectState.RemoveEffect(NewGameState, GameState);
							NewGameState.RemoveStateObject(EffectState.ObjectID);
							TacticalRules.SubmitGameState(NewGameState);

							class'XComGameStateContext_Ability'.static.ActivateAbility(UnitCache.AvailableActions[i], j);
						}
						break;
					}
				}
				break;
			}
		}
	}

	return ELR_NoInterrupt;
}

defaultproperties
{
	EventName="MultiTargetTriggerImmediateAbility"
}
