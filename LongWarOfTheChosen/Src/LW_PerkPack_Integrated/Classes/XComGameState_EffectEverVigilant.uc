class XComGameState_EffectEverVigilant extends XComGameState_Effect;

var int MovesThisTurn;

function SubmitNewGameStateN(out XComGameState NewGameState)
{
	local X2TacticalGameRuleset TacticalRules;
	local XComGameStateHistory History;

	if (NewGameState.GetNumGameStateObjects() > 0)
	{
		TacticalRules = `TACTICALRULES;
		TacticalRules.SubmitGameState(NewGameState);

		//  effects may have changed action availability - if a unit died, took damage, etc.
	}
	else
	{
		History = `XCOMHISTORY;
		History.CleanupPendingGameState(NewGameState);
	}
}

function bool TickEffect(XComGameState NewGameState, bool FirstApplication, XComGameState_Player Player)
{
	local XComGameState_EffectEverVigilant NewEffectState;
	local X2Effect_Persistent EffectTemplate;
	local bool bContinueTicking;

	EffectTemplate = GetX2Effect();

	NewEffectState = XComGameState_EffectEverVigilant(NewGameState.CreateStateObject(Class, ObjectID));
	//`log("Reset Counter",, 'NewEverVigilant');
	NewEffectState.MovesThisTurn = 0;

	//Apply the tick effect to our target / source	
	bContinueTicking = EffectTemplate.OnEffectTicked(  ApplyEffectParameters,
															 NewEffectState,
															 NewGameState,
															 FirstApplication,
															 Player );

	NewGameState.AddStateObject(NewEffectState);
	// If the effect removes itself return false, stop the ticking of the effect
	// If the effect does not return iteslf, then the effect will be ticked again if it is infinite or there is time remaining
	return bContinueTicking;
}

function EventListenerReturn EverVigilantTurnEndListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_Unit UnitState;
	local StateObjectReference OverwatchRef;
	local XComGameState_Ability OverwatchState;
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local EffectAppliedData ApplyData;
	local X2Effect VigilantEffect;
	local XComGameState_EffectEverVigilant EverVigilantState;
	local name OverwatchAbilityName;
	local X2AbilityCost Cost;
	local bool CanUseOverwatch;

	History = `XCOMHISTORY;
	UnitState = XComGameState_Unit(GameState.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	//`log("===End turn triggered:" @ ApplyEffectParameters.SourceStateObjectRef.ObjectID $ "===",, 'NewEverVigilant');

	if (UnitState == none)
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	if (UnitState.NumAllReserveActionPoints() == 0)     //  don't activate overwatch if the unit is potentially doing another reserve action
	{
		EverVigilantState = XComGameState_EffectEverVigilant(GameState.GetGameStateForObjectID(ObjectID));

		if (EverVigilantState == none)
			EverVigilantState = XComGameState_EffectEverVigilant(History.GetGameStateForObjectID(ObjectID));
		if (EverVigilantState != none && EverVigilantState.MovesThisTurn == 0)
		{
			//`log("Ever vigilant conditions satisfied",, 'NewEverVigilant');
			//`log("CHECK:" @ class'X2Effect_EverVigilant'.default.OverwatchAbilities.Length,, 'NewEverVigilant');
			foreach class'X2Effect_EverVigilant'.default.OverwatchAbilities(OverwatchAbilityName)
			{
				//`log("CHECK:" @ OverwatchAbilityName,, 'NewEverVigilant');
				OverwatchRef = UnitState.FindAbility(OverwatchAbilityName);
				if (OverwatchRef.ObjectID != 0)
				{
					//`log("has overwatch ability",, 'NewEverVigilant');
					OverwatchState = XComGameState_Ability(History.GetGameStateForObjectID(OverwatchRef.ObjectID));
					if (OverwatchState.CanActivateAbility(UnitState,, true) == 'AA_Success')
					{
						//`log("Can activate without cost",, 'NewEverVigilant');
						CanUseOverwatch = true;
						foreach OverwatchState.GetMyTemplate().AbilityCosts(Cost)
						{
							if (X2AbilityCost_ActionPoints(Cost) == none) // non action point costs
							{
								if (Cost.CanAfford(OverwatchState, UnitState) != 'AA_Success')
								{
									//`log("one of the action cost is unsaisfied",, 'NewEverVigilant');
									CanUseOverwatch = false;
									break;
								}
								//`log("1 non action cost satisfied",, 'NewEverVigilant');
							}
						}
						if (CanUseOverwatch)
							break; // Can use ability, success!
						else
						{
							//`log("Ability cost not satisfied",, 'NewEverVigilant');
							OverwatchRef.ObjectID = 0;
							OverwatchState = none; // No such ability, next
						}
					}
					else
					{
						//`log("No overwatch ability",, 'NewEverVigilant');
						OverwatchRef.ObjectID = 0;
						OverwatchState = none; // No such ability, next
					}
				}
			}
			if (OverwatchState != none)
			{
				//`log("Applying ever vigilant effect and use overwatch",, 'NewEverVigilant');
				NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
				UnitState = XComGameState_Unit(NewGameState.CreateStateObject(UnitState.Class, UnitState.ObjectID));
				//  apply the EverVigilantActivated effect directly to the unit
				ApplyData.EffectRef.LookupType = TELT_AbilityShooterEffects;
				ApplyData.EffectRef.TemplateEffectLookupArrayIndex = 0;
				ApplyData.EffectRef.SourceTemplateName = 'EverVigilantTrigger';
				ApplyData.PlayerStateObjectRef = UnitState.ControllingPlayer;
				ApplyData.SourceStateObjectRef = UnitState.GetReference();
				ApplyData.TargetStateObjectRef = UnitState.GetReference();
				VigilantEffect = class'X2Effect'.static.GetX2Effect(ApplyData.EffectRef);
				`assert(VigilantEffect != none);
				VigilantEffect.ApplyEffect(ApplyData, UnitState, NewGameState);

				if (UnitState.NumActionPoints() == 0)
				{
					//  give the unit an action point so they can activate overwatch										
					UnitState.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);					
				}
				UnitState.SetUnitFloatValue(class'X2Ability_SpecialistAbilitySet'.default.EverVigilantEffectName, 1, eCleanup_BeginTurn);
				
				NewGameState.AddStateObject(UnitState);
				`TACTICALRULES.SubmitGameState(NewGameState);
				//`log("===Overwatch for" @ ApplyEffectParameters.SourceStateObjectRef.ObjectID $ "===",, 'NewEverVigilant');
				return OverwatchState.AbilityTriggerEventListener_Self(EventData, EventSource, GameState, EventID, CallbackData);
			}
		}
	}
	//`log("===End turn triggered ended for " @ ApplyEffectParameters.SourceStateObjectRef.ObjectID $ "===",, 'NewEverVigilant');

	return ELR_NoInterrupt;
}

function EventListenerReturn AbilityTriggerUsedListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_EffectEverVigilant NewState;
	local XComGameState NewGameState;
	local XComGameState_Ability AbilityState;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("MoveEverVigilantCounter");
	AbilityState = XComGameState_Ability(EventData);

	//`log("Ability used:" @ AbilityState.GetMyTemplateName() @ "for" @ ApplyEffectParameters.SourceStateObjectRef.ObjectID,, 'NewEverVigilant');

	if ((class'X2Effect_EverVigilant'.default.EverVigilantIgnore.Find(AbilityState.GetMyTemplateName()) == INDEX_NONE &&
		AbilityState.GetMyTemplate().Hostility != eHostility_Movement && AbilityState.IsAbilityInputTriggered()) ||
		class'X2Effect_EverVigilant'.default.EverVigilantStopOnAbility.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
	{
		NewState = XComGameState_EffectEverVigilant(NewGameState.CreateStateObject(class'XComGameState_EffectEverVigilant', ObjectID));
		NewGameState.AddStateObject(NewState);
		++NewState.MovesThisTurn;
		//`log("Ability count as move",, 'NewEverVigilant');
	}
	
	SubmitNewGameStateN(NewGameState);
	return ELR_NoInterrupt;
}