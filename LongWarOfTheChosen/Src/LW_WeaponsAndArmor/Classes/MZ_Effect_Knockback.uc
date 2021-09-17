// This is an Unreal Script

class MZ_Effect_Knockback extends X2Effect;
//what I want to do here is reverse the order tiles are checked in, so you can punt things through walls, cars, etc.

/** Distance that the target will be thrown backwards, in meters */
var() int KnockbackDistance;

/** Used to step the knockback forward along the movement vector until either knock back distance is reached, or there are no more valid tiles*/
var private float StepSize;

/** If true, the knocked back unit will cause non fragile destruction ( like kinetic strike ) */
var() bool bKnockbackDestroysNonFragile;

/** Distance that the target will be thrown backwards, in meters */
var() float OverrideRagdollFinishTimerSec;

/** Knockback effects can happen on every attack or only killing attacks */
var() bool OnlyOnDeath;

var()	float DefaultDamage;
var()	float DefaultRadius;

defaultproperties
{
	StepSize = 8.0

	Begin Object Class=X2Condition_UnitProperty Name=UnitPropertyCondition
		ExcludeTurret = true
		ExcludeDead = false
		FailOnNonUnits = true
	End Object

	TargetConditions.Add(UnitPropertyCondition)

	DamageTypes.Add("KnockbackDamage");

	OverrideRagdollFinishTimerSec=-1

	OnlyOnDeath=false

	ApplyChanceFn=WasTargetPreviouslyDead

	DefaultDamage=30.0
	DefaultRadius=64.0
}


function name WasTargetPreviouslyDead(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState)
{
	// A unit that was dead before this game state should not get a knockback, they are already a corpse
	local name AvailableCode;
	local XComGameState_Unit TestUnitState;
	local XComGameStateHistory History;

	AvailableCode = 'AA_Success';

	History = `XCOMHISTORY;

	TestUnitState = XComGameState_Unit(History.GetGameStateForObjectID(kNewTargetState.ObjectID));
	if( (TestUnitState != none) && TestUnitState.IsDead() )
	{
		return 'AA_UnitIsDead';
	}

	if( OnlyOnDeath )
	{
		TestUnitState = XComGameState_Unit(kNewTargetState);
		if( TestUnitState != None && (TestUnitState.IsAlive() || TestUnitState.IsIncapacitated()) )
		{
			return 'AA_UnitIsAlive';
		}
	}

	return AvailableCode;
}

private function bool CanBeDestroyed(XComInteractiveLevelActor InteractiveActor, float DamageAmount)
{
	//make sure the knockback damage can destroy this actor.
	//check the number of interaction points to prevent larger objects from being destroyed.
	return InteractiveActor != none && DamageAmount >= InteractiveActor.Health && InteractiveActor.InteractionPoints.Length <= 8;
}

//Returns the list of tiles that the unit will pass through as part of the knock back. The last tile in the array is the final destination.
private function GetTilesEnteredArray(XComGameStateContext_Ability AbilityContext, XComGameState_BaseObject kNewTargetState, out array<TTile> OutTilesEntered, out Vector OutAttackDirection, float DamageAmount, XComGameState NewGameState)
{
	local XComWorldData						WorldData;
	local XComGameState_Unit				SourceUnit;
	local XComGameState_Unit				TargetUnit;
	local Vector							SourceLocation;
	local Vector							TargetLocation;
	local Vector							StartLocation;
	local TTile								TempTile, StartTile;
	local TTile								LastTempTile, KnockbackLandingTile;
	local Vector							KnockbackToLocation;	
	local float								StepDistance;
	local Vector							TestLocation;
	local float								TestDistanceUnits;
	local X2AbilityTemplate					AbilityTemplate;
	local bool								bCursorTargetFound;
	local array<StateObjectReference>		TileUnits;
	//local int								i;

	WorldData = `XWORLD;
	if(AbilityContext != none)
	{
		AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(AbilityContext.InputContext.AbilityTemplateName);
		
		TargetUnit = XComGameState_Unit(kNewTargetState);
		TargetUnit.GetKeystoneVisibilityLocation(StartTile);
		TargetLocation = WorldData.GetPositionFromTileCoordinates(StartTile);

		/*
		if (ToHitCalc != none && ToHitCalc.bReactionFire)
		{
			//If this was reaction fire, just drop the unit where they are. The physics of their motion may move them a few tiles
			WorldData.GetFloorTileForPosition(TargetLocation, MoveToTile, true);
			OutTilesEntered.AddItem(MoveToTile);
		}
		else
		{
		*/
			
			//For pressure blast, we always want to trace from the caster. none of this wierd bounce-it-toward-you bullshit. take 3.
			if (AbilityTemplate != none && AbilityTemplate.AbilityTargetStyle.IsA('X2AbilityTarget_Cursor') && !AbilityTemplate.AbilityMultiTargetStyle.IsA('X2AbilityMultiTarget_Cone'))
			{
				//attack source is at cursor location
				`assert( AbilityContext.InputContext.TargetLocations.Length > 0 );
				SourceLocation = AbilityContext.InputContext.TargetLocations[0];

				TempTile = WorldData.GetTileCoordinatesFromPosition(SourceLocation);
				SourceLocation = WorldData.GetPositionFromTileCoordinates(TempTile);

				//Need to produce a non-zero vector
				bCursorTargetFound = (SourceLocation.X != TargetLocation.X || SourceLocation.Y != TargetLocation.Y);
			}
			

			if (!bCursorTargetFound)
			{
				//attack source is from a Unit
				SourceUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
				SourceUnit.GetKeystoneVisibilityLocation(TempTile);
				SourceLocation = WorldData.GetPositionFromTileCoordinates(TempTile);
			}

			OutAttackDirection = Normal(TargetLocation - SourceLocation);
			OutAttackDirection.Z = 0.0f;
			StartLocation = TargetLocation;

			KnockbackToLocation = StartLocation + (OutAttackDirection * float(KnockbackDistance) * 64.0f); //Convert knockback distance to meters



			//Totally borked. sends this flying into the sunset.
			//if( WorldData.GetAllActorsTrace(StartLocation, KnockbackToLocation, Hits, Extents) )
			//{
			//	i = Hits.length;
			//	while( i--> 0)
			//	{
			//		TraceHitInfo = Hits[i];
			//		TempTile = WorldData.GetTileCoordinatesFromPosition(TraceHitInfo.HitLocation);
			//		FloorTileActor = WorldData.GetFloorTileActor(TempTile);

			//		if ((!CanBeDestroyed(XComInteractiveLevelActor(TraceHitInfo.HitActor), DamageAmount) && XComFracLevelActor(TraceHitInfo.HitActor) == none) || !bKnockbackDestroysNonFragile)
			//		{
						//We hit an indestructible object			
			//			continue;	//so check the next space
			//		}

			//		if( TraceHitInfo.HitActor == FloorTileActor )
			//		{
						//found a tile that can be stood on
			//			TileUnits = WorldData.GetUnitsOnTile(TempTile);
			//			if (TileUnits.Length == 0)
			//			{
			//				//It's unoccupied. So this is where we knockback to.
			//				KnockbackToLocation = TraceHitInfo.HitLocation;
			//				KnockbackLandingTile = TempTile;
			//				break;
			//			}
			//		}
			//	}
			//}

			//walk backwards along attack vector until a valid location to knockback to is found.
			TestDistanceUnits = VSize2D(KnockbackToLocation - StartLocation);
			StepDistance = TestDistanceUnits;
			OutTilesEntered.Length = 0;
			KnockbackLandingTile = StartTile;		
			while (StepDistance > 0)
			{
				TestLocation = StartLocation + (OutAttackDirection * StepDistance);	
	
				if (WorldData.GetFloorTileForPosition(TestLocation, TempTile, true) && WorldData.CanUnitsEnterTile(TempTile))
				{
					//Found floor. now check if it is unoccupied
					TileUnits = WorldData.GetUnitsOnTile(TempTile);
					if (TileUnits.Length == 0)
					{
						//tile is unoccupied.
						KnockbackLandingTile = TempTile;
						break;
					}
				}
				StepDistance -= StepSize;
			}

			//next we need to build a list of tiles the target will pass through
			StepDistance = 0.0f;
			LastTempTile = StartTile;
			OutTilesEntered.AddItem(StartTile);
			while (StepDistance < TestDistanceUnits)
			{
				TestLocation = StartLocation + (OutAttackDirection * StepDistance);
	
				TempTile = WorldData.GetTileCoordinatesFromPosition( TestLocation, false );
	
				if (LastTempTile != TempTile)
				{
					OutTilesEntered.AddItem(TempTile);
					LastTempTile = TempTile;
				}
	
				if (KnockbackLandingTile == TempTile)
				{
					break;
				}
	
				StepDistance += StepSize;
			}

			//Move the target unit to the knockback location			
			//if (OutTilesEntered.Length == 0 || OutTilesEntered[OutTilesEntered.Length - 1] != KnockbackLandingTile)
				OutTilesEntered.AddItem(KnockbackLandingTile);
				//try making it always tack it on the end. see if looks better
		//}
	}
}

simulated function ApplyEffectToWorld(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_BaseObject kNewTargetState;
	local int Index;
	local XComGameState_EnvironmentDamage DamageEvent;
	local XComWorldData WorldData;
	local TTile HitTile;
	local array<TTile> TilesEntered;
	local Vector AttackDirection;
	local XComGameState_Item SourceItemStateObject;
	local XComGameStateHistory History;
	local X2WeaponTemplate WeaponTemplate;
	local array<StateObjectReference> Targets;
	local StateObjectReference CurrentTarget;
	local XComGameState_Unit TargetUnit;
	local TTile NewTileLocation;
	local float KnockbackDamage;
	local float KnockbackRadius;
	local int EffectIndex, MultiTargetIndex;
	local MZ_Effect_Knockback KnockbackEffect;

	AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());
	if(AbilityContext != none)
	{
		if (AbilityContext.InputContext.PrimaryTarget.ObjectID > 0)
		{
			// Check the Primary Target for a successful knockback
			for (EffectIndex = 0; EffectIndex < AbilityContext.ResultContext.TargetEffectResults.Effects.Length; ++EffectIndex)
			{
				KnockbackEffect = MZ_Effect_Knockback(AbilityContext.ResultContext.TargetEffectResults.Effects[EffectIndex]);
				if (KnockbackEffect != none)
				{
					if (AbilityContext.ResultContext.TargetEffectResults.ApplyResults[EffectIndex] == 'AA_Success')
					{
						Targets.AddItem(AbilityContext.InputContext.PrimaryTarget);
						break;
					}
				}
			}
		}

		for (MultiTargetIndex = 0; MultiTargetIndex < AbilityContext.InputContext.MultiTargets.Length; ++MultiTargetIndex)
		{
			// Check the MultiTargets for a successful knockback
			for (EffectIndex = 0; EffectIndex < AbilityContext.ResultContext.MultiTargetEffectResults[MultiTargetIndex].Effects.Length; ++EffectIndex)
			{
				KnockbackEffect = MZ_Effect_Knockback(AbilityContext.ResultContext.MultiTargetEffectResults[MultiTargetIndex].Effects[EffectIndex]);
				if (KnockbackEffect != none)
				{
					if (AbilityContext.ResultContext.MultiTargetEffectResults[MultiTargetIndex].ApplyResults[EffectIndex] == 'AA_Success')
					{
						Targets.AddItem(AbilityContext.InputContext.MultiTargets[MultiTargetIndex]);
						break;
					}
				}
			}
		}

		foreach Targets(CurrentTarget)
		{
			History = `XCOMHISTORY;
				SourceItemStateObject = XComGameState_Item(History.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));
			if (SourceItemStateObject != None)
				WeaponTemplate = X2WeaponTemplate(SourceItemStateObject.GetMyTemplate());

			if (WeaponTemplate != none)
			{
				KnockbackDamage = WeaponTemplate.fKnockbackDamageAmount >= 0.0f ? WeaponTemplate.fKnockbackDamageAmount : DefaultDamage;
				KnockbackRadius = WeaponTemplate.fKnockbackDamageRadius >= 0.0f ? WeaponTemplate.fKnockbackDamageRadius : DefaultRadius;
			}
			else
			{
				KnockbackDamage = DefaultDamage;
				KnockbackRadius = DefaultRadius;
			}

			kNewTargetState = NewGameState.GetGameStateForObjectID(CurrentTarget.ObjectID);
			TargetUnit = XComGameState_Unit(kNewTargetState);
			if(TargetUnit != none) //Only units can be knocked back
			{
				TilesEntered.Length = 0;
				GetTilesEnteredArray(AbilityContext, kNewTargetState, TilesEntered, AttackDirection, KnockbackDamage, NewGameState);

				//Only process the code below if the target went somewhere
				if(TilesEntered.Length > 0)
				{
					WorldData = `XWORLD;

					if(bKnockbackDestroysNonFragile)
					{
						for(Index = 0; Index < TilesEntered.Length; ++Index)
						{
							HitTile = TilesEntered[Index];
							HitTile.Z += 1;

							DamageEvent = XComGameState_EnvironmentDamage(NewGameState.CreateNewStateObject(class'XComGameState_EnvironmentDamage'));
							DamageEvent.DEBUG_SourceCodeLocation = "UC: X2Effect_Knockback:ApplyEffectToWorld";
							DamageEvent.DamageAmount = KnockbackDamage;
							DamageEvent.DamageTypeTemplateName = 'Melee';
							DamageEvent.HitLocation = WorldData.GetPositionFromTileCoordinates(HitTile);
							DamageEvent.Momentum = AttackDirection;
							DamageEvent.DamageDirection = AttackDirection; //Limit environmental damage to the attack direction( ie. spare floors )
							DamageEvent.PhysImpulse = 100;
							DamageEvent.DamageRadius = KnockbackRadius;
							DamageEvent.DamageCause = ApplyEffectParameters.SourceStateObjectRef;
							DamageEvent.DamageSource = DamageEvent.DamageCause;
							DamageEvent.bRadialDamage = false;
						}
					}

					NewTileLocation = TilesEntered[TilesEntered.Length - 1];
					TargetUnit.SetVisibilityLocation(NewTileLocation);
				}
			}			
		}
	}
}

simulated function int CalculateDamageAmount(const out EffectAppliedData ApplyEffectParameters, out int ArmorMitigation, out int NewShred)
{
	return 0;
}

simulated function bool PlusOneDamage(int Chance)
{
	return false;
}

simulated function bool IsExplosiveDamage() 
{ 
	return false; 
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, name EffectApplyResult)
{
	local X2Action_Knockback KnockbackAction;

	if (EffectApplyResult == 'AA_Success')
	{
		if( ActionMetadata.StateObject_NewState.IsA('XComGameState_Unit') )
		{
			KnockbackAction = X2Action_Knockback(class'X2Action_Knockback'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
			if( OverrideRagdollFinishTimerSec >= 0 )
			{
				KnockbackAction.OverrideRagdollFinishTimerSec = OverrideRagdollFinishTimerSec;
			}
		}
		else if (ActionMetadata.StateObject_NewState.IsA('XComGameState_EnvironmentDamage') || ActionMetadata.StateObject_NewState.IsA('XComGameState_Destructible'))
		{
			//This can be added by other effects, so check to see whether this track already has one of these
			class'X2Action_ApplyWeaponDamageToTerrain'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext());//auto-parent to damage initiating action
		}
	}
}

simulated function AddX2ActionsForVisualization_Tick(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const int TickIndex, XComGameState_Effect EffectState)
{
	
}