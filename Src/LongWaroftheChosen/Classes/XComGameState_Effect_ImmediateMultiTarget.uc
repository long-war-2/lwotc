//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_Effect_ImmediateMultiTarget.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: This is an effect component extension listening for an immediate trigger event, with code to handle application to multiple targets
//---------------------------------------------------------------------------------------

class XComGameState_Effect_ImmediateMultiTarget extends XComGameState_BaseObject;

function XComGameState_Effect_ImmediateMultiTarget InitComponent()
{
	return self;
}

function XComGameState_Effect GetOwningEffect()
{
	return XComGameState_Effect(`XCOMHISTORY.GetGameStateForObjectID(OwningObjectId));
}

// This is called when the a X2Effect_ImmediateMultiTargetAbilityActivation is added to a unit
function EventListenerReturn OnFireImmediateMultiTargetAbility(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
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
	local XComGameState_Effect OwningEffect;
	
	History = `XCOMHISTORY;
	
	OwningEffect = GetOwningEffect();

	EffectSourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(OwningEffect.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	`assert(EffectSourceUnit != none);
	EffectTargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(OwningEffect.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if( EffectTargetUnit == None )
	{
		// Target can be an interactive object, in which case, we don't want to apply any effects.
		return ELR_NoInterrupt;
	}

	//multi-target handling -- make sure that the target units are the same, effect and event -- source unit filtering is handled via PreFilter in X2EventManager
	EventTargetUnit = XComGameState_Unit(EventData);
	if(EventTargetUnit.ObjectID != EffectTargetUnit.ObjectID)
		return ELR_NoInterrupt;

	EffectTemplate = X2Effect_ImmediateMultiTargetAbilityActivation(OwningEffect.GetX2Effect());
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
							EffectRemovedState = class'XComGameStateContext_EffectRemoved'.static.CreateEffectRemovedContext(OwningEffect);
							NewGameState = History.CreateNewGameState(true, EffectRemovedState);
							OwningEffect.RemoveEffect(NewGameState, GameState);
							NewGameState.RemoveStateObject(ObjectID);
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
