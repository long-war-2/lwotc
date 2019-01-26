//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_Effect_Whirlwind.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: This is an effect component extension that:
//				- listens for end of movement, to end effect
//				- handles gamestate movement updates, inserting attacks as needed
//---------------------------------------------------------------------------------------

class XComGameState_Effect_Whirlwind extends XComGameState_BaseObject config(LW_PerkPack);

var StateObjectReference OwnerUnitRef;				//the unit using whirlwind, cached for better history observer performance
var array<StateObjectReference> PossibleTargets;	// possible targets, cached for better performance and to limit to one attack per ability activation

function XComGameState_Effect GetOwningEffect()
{
	return XComGameState_Effect(`XCOMHISTORY.GetGameStateForObjectID(OwningObjectId));
}

function XComGameState_Effect_Whirlwind InitComponent(XComGameState_Effect NewEffectState)
{
	local XComGameStateHistory History;
	local XComGameState_Unit WhirlwindUnit;

	//`LOG("Whirlwind : Starting InitComponent");
	History = `XCOMHISTORY;
	OwnerUnitRef = NewEffectState.ApplyEffectParameters.TargetStateObjectRef;
	WhirlwindUnit = XComGameState_Unit(History.GetGameStateForObjectID(OwnerUnitRef.ObjectID));
	//`LOG("Whirlwind : Owning Unit:" @ WhirlwindUnit.GetFullName());

	WhirlwindUnit.GetEnemiesInRange(WhirlwindUnit.TileLocation, 20, PossibleTargets);

	//PossibleTargets.Length = 0;
	//foreach History.IterateByClassType(class'XComGameState_Unit', Unit )
	//{
		////`LOG("Whirlwind : Checking Possible Target:" @ Unit.GetFullName());
		//if(WhirlwindUnit.IsEnemyUnit(Unit))
		//{
			////`LOG("Whirlwind : Possible Target Added:" @ Unit.GetFullName());
			//PossibleTargets.AddItem(Unit.GetReference());
		//}
	//}
	return self;
}

// triggered by 'ObjectMoved' -- triggers on each tile entered
function EventListenerReturn OnUnitEnteredTile(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateHistory				History;
	local StateObjectReference				PossibleTargetRef;
	local XComGameState_Effect_Whirlwind	UpdatedEffectState;
	local XComGameState_Unit				ThisUnitState, PossibleTargetState;;
	local StateObjectReference				AbilityRef;
	local XComGameState_Ability				AbilityState;
	local XComGameStateContext				AbilityContext;
	local name								AbilityActivationCode;

	History = `XCOMHISTORY;

	ThisUnitState = XComGameState_Unit(History.GetGameStateForObjectID(OwnerUnitRef.ObjectID));
	`LOG("Whirlwind: Unit" @ ThisUnitState.GetFullName() @ "entered a new tile.");

	UpdatedEffectState = XComGameState_Effect_Whirlwind(GameState.CreateStateObject(Class, ObjectID));
	GameState.AddStateObject(UpdatedEffectState);

	AbilityRef = ThisUnitState.FindAbility('WhirlwindSlash');
	if( AbilityRef.ObjectID > 0)
	{
		foreach PossibleTargets(PossibleTargetRef)
		{
			PossibleTargetState = XComGameState_Unit(History.GetGameStateForObjectID(PossibleTargetRef.ObjectID));
			`LOG("Whirlwind: Attempting to activate slash against unit" @ PossibleTargetState.GetFullName());
			AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityRef.ObjectID));
			if(AbilityState != none)
			{
				AbilityActivationCode = AbilityState.CanActivateAbilityForObserverEvent( PossibleTargetState, ThisUnitState );
				`LOG("Whirlwind: Retrieved AbilityState : ActivationCode=" $ AbilityActivationCode);
				if(AbilityActivationCode == 'AA_Success' )
				{
					`LOG("Whirlwind: CanActivateAbilityForObserverEvent passed.");
					AbilityContext = class'XComGameStateContext_Ability'.static.BuildContextFromAbility(AbilityState, PossibleTargetRef.ObjectID);
					if( AbilityContext != none && AbilityContext.Validate() )
					{
						`LOG("Whirlwind: Ability Context created and validated, submitting.");
						`XCOMGAME.GameRuleset.SubmitGameStateContext(AbilityContext);
						PossibleTargets.RemoveItem(PossibleTargetRef);
					}
				}
			}
		}


		//if(ActivateAbility('WhirlwindSlash', OwnerUnitRef, PossibleTargetRef))
		//{
			//PossibleTargets.RemoveItem(PossibleTargetRef);
		//}
	}


	return ELR_NoInterrupt;
}


//This is used to activate the the melee attack which can be triggered after each tile is entered
function bool ActivateAbility(name AbilityName, StateObjectReference SourceRef, StateObjectReference TargetRef)
{
	local GameRulesCache_Unit UnitCache;
	local int i, j;
	local X2TacticalGameRuleset TacticalRules;
	local StateObjectReference AbilityRef;
	local XComGameState_Unit SourceState; //, TargetState;
	local XComGameStateHistory History;
	local bool bActivated;

	History = `XCOMHISTORY;
	SourceState = XComGameState_Unit(History.GetGameStateForObjectID(SourceRef.ObjectID));
	AbilityRef = SourceState.FindAbility(AbilityName);

	bActivated = false;
	TacticalRules = `TACTICALRULES;
	if( AbilityRef.ObjectID > 0 &&  TacticalRules.GetGameRulesCache_Unit(SourceRef, UnitCache) )
	{
		`LOG("PerkPack(Whirlwind): Valid ability, retrieved UnitCache.");
		for( i = 0; i < UnitCache.AvailableActions.Length; ++i )
		{
			if( UnitCache.AvailableActions[i].AbilityObjectRef.ObjectID == AbilityRef.ObjectID )
			{
				`LOG("PerkPack(Whirlwind): Found matching Ability ObjectID=" $ AbilityRef.ObjectID);
				for( j = 0; j < UnitCache.AvailableActions[i].AvailableTargets.Length; ++j )
				{
					if( UnitCache.AvailableActions[i].AvailableTargets[j].PrimaryTarget == TargetRef )
					{
						`LOG("PerkPack(Whirlwind): Found Target ObjectID=" $ TargetRef.ObjectID);
						if( UnitCache.AvailableActions[i].AvailableCode == 'AA_Success' )
						{
							`LOG("PerkPack(Whirlwind): AvailableCode AA_Success");
							class'XComGameStateContext_Ability'.static.ActivateAbility(UnitCache.AvailableActions[i], j);
							bActivated = true;
						}
						else
						{
							`LOG("PerkPack(Whirlwind): AvailableCode = " $ UnitCache.AvailableActions[i].AvailableCode);
						}
						break;
					}
				}
				break;
			}
		}
	}
	return bActivated;
}

//This is triggered when the unit finishes moving, and shuts down the movement observer and ends the effect
simulated function EventListenerReturn OnUnitMoveFinished(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameStateContext_TickEffect TickContext;
	local XComGameState NewGameState;
	local XComGameState_Effect OwningEffect;
	local XComGameState_Unit NewThisUnitState;

	History = `XCOMHISTORY;
	OwningEffect = GetOwningEffect();

	TickContext = class'XComGameStateContext_TickEffect'.static.CreateTickContext(OwningEffect);
	NewGameState = History.CreateNewGameState(true, TickContext);

	//check that it wasn't removed already because of the unit being killed from damage
	if(!OwningEffect.bRemoved)
		OwningEffect.RemoveEffect(NewGameState, NewGameState);

	//remove any left-over actions
	NewThisUnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', OwnerUnitRef.ObjectID));
	NewThisUnitState.ActionPoints.Length = 0;
	NewThisUnitState.ReserveActionPoints.Length = 0;
	NewThisUnitState.SkippedActionPoints.Length = 0;

	`LOG("Whirlwind: Unit" @ NewThisUnitState.GetFullName() @ "finished movement.");


	if( NewGameState.GetNumGameStateObjects() > 0 )
		`TACTICALRULES.SubmitGameState(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);

	//un-register the gamestate observer that was watching for unit movement
	//History.UnRegisterOnNewGameStateDelegate(OnNewGameState);

	return ELR_NoInterrupt;
}

//register to receive new gamestates in order to update RedFog whenever HP changes on a unit, and in tactical
//function OnNewGameState(XComGameState NewGameState)
//{
	//local XComGameState GameState;
	//local int StateObjectIndex;
	//local MovedObjectStatePair MovedStateObj;
	//local array<MovedObjectStatePair> MovedStateObjects;
//
	//MovedStateObjects.Length = 0;
	//class'X2TacticalGameRulesetDataStructures'.static.GetMovedStateObjectList(NewGameState, MovedStateObjects);
	//if(MovedStateObjects.Length == 0) return;
	//
	////GameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Update RedFog OnNewGameState");
	//for( StateObjectIndex = 0; StateObjectIndex < MovedStateObjects.Length; ++StateObjectIndex )
	//{	
		//MovedStateObj = MovedStateObjects[StateObjectIndex]; // Cache this because it apparently can be removed from the array mid-loop.
//
		////verify that it's the Whirlwind effect owner that moved
		//if(MovedStateObj.PostMoveState.ObjectID == OwnerUnitRef.ObjectID)
		//{
			//
		//}
		////if(HPChangedUnit.IsUnitAffectedByEffectName(class'X2Effect_RedFog_LW'.default.EffectName))
		////{
			////RedFogEffect = HPChangedUnit.GetUnitAffectedByEffectState(class'X2Effect_RedFog_LW'.default.EffectName);
			////if(RedFogEffect != none)
			////{
				////RFEComponent = XComGameState_Effect_RedFog_LW(RedFogEffect.FindComponentObject(class'XComGameState_Effect_RedFog_LW'));
				////if(RFEComponent != none)
				////{
					////RFEComponent.UpdateRedFogPenalties(HPChangedUnit, GameState);
				////}
			////}
		////}
	//}
	//if(GameState.GetNumGameStateObjects() > 0)
		//`TACTICALRULES.SubmitGameState(GameState);
	//else
		//`XCOMHISTORY.CleanupPendingGameState(GameState);
//}
