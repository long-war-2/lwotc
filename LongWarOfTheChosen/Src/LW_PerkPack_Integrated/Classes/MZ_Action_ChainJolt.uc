class MZ_Action_ChainJolt extends X2Action_Fire
	config(GameData);

var config String ParticleSystemName;
var config Name StartingSocket;
var config Name TargetSocket;
var config float ChainDelay;
var config float ReactDelay;

var ParticleSystem ArcTether;
var Array<ParticleSystemComponent> TethersSpawned;
var int MultiTargetIndex;
var Array<int> UnitsTethered;
var bool StartChain;

var AnimNodeSequence PlayingSequence;

var name AnimName;

function Init()
{
	Super.Init();

	ArcTether = ParticleSystem(DynamicLoadObject(ParticleSystemName, class'ParticleSystem'));
}

function NotifyTargetsAbilityApplied()
{
	StartChain = true;
}

function HandleSingleTarget(int ObjectID, int TargetObjectID, Name StartSocket, Name EndSocket)
{
	local XComUnitPawn FirstTethered, SecondTethered;
	local int TetherIndex;
	local Vector Origin, Delta;

	if( ObjectID > 0 && TargetObjectID > 0 )
	{
		FirstTethered = XGUnit(History.GetVisualizer(ObjectID)).GetPawn();
		SecondTethered = XGUnit(History.GetVisualizer(TargetObjectID)).GetPawn();
		if(ArcTether != None && FirstTethered != None && SecondTethered != None )
		{
			// Spawn then immediately update its location/rotation to be correct
			TetherIndex = TethersSpawned.AddItem(class'WorldInfo'.static.GetWorldInfo().MyEmitterPool.SpawnEmitter(ArcTether, vect(0,0,0), Rotator(vect(0,0,0))));
			
			if( UnitsTethered.Find(ObjectID) == INDEX_NONE )
			{
				UnitsTethered.AddItem(ObjectID);
			}
			if( UnitsTethered.Find(TargetObjectID) == INDEX_NONE )
			{
				UnitsTethered.AddItem(TargetObjectID);
			}

			UpdateSingleTether(TetherIndex, ObjectID, TargetObjectID, StartSocket, EndSocket, Origin, Delta);

			`XEVENTMGR.TriggerEvent('Visualizer_ProjectileHit', History.GetGameStateForObjectID( TargetObjectID ), self);

			NotifyInterveningStateObjects( Origin, Delta );
		}
	}
}

function NotifyInterveningStateObjects(vector Origin, vector Delta)
{	
	local XComGameState_EnvironmentDamage EnvironmentDamageEvent;
	local XComGameState_InteractiveObject InteractiveObject;
	local XComInteractiveLevelActor InteractiveLevelActor;
	local vector StateObjectDelta;
	local float DistFromDelta;

	// find all the environmental damage that are within half a tile of the arc segment
	foreach VisualizeGameState.IterateByClassType(class'XComGameState_EnvironmentDamage', EnvironmentDamageEvent)
	{
		StateObjectDelta = Normal( EnvironmentDamageEvent.HitLocation - Origin );
		DistFromDelta = VSize( StateObjectDelta - ProjectOnTo( StateObjectDelta, Delta ) );

		if(DistFromDelta < (class'XComWorldData'.const.WORLD_StepSize / 2))
		{			
			`XEVENTMGR.TriggerEvent('Visualizer_WorldDamage', EnvironmentDamageEvent, self);			
		}
	}

	// find all the interactive objects that are within half a tile of the arc segment
	foreach VisualizeGameState.IterateByClassType(class'XComGameState_InteractiveObject', InteractiveObject)
	{
		InteractiveLevelActor = XComInteractiveLevelActor(History.GetVisualizer(InteractiveObject.ObjectID));
		StateObjectDelta = Normal( InteractiveLevelActor.Location - Origin );
		DistFromDelta = VSize( StateObjectDelta - ProjectOnTo( StateObjectDelta, Delta ) );

		if(DistFromDelta < (class'XComWorldData'.const.WORLD_StepSize / 2))
		{			
			`XEVENTMGR.TriggerEvent('Visualizer_ProjectileHit', InteractiveObject, self);		
		}
	}
}


function UpdateSingleTether(int TetherIndex, int FirstObjectID, int SecondObjectID, Name StartSocket, Name EndSocket, optional out vector Origin, optional out vector Delta)
{
	local XComUnitPawn FirstTethered, SecondTethered;
	local Vector FirstLocation, SecondLocation;
	local Vector FirstToSecond;
	local float DistanceBetween;
	local Vector DistanceBetweenVector;

	FirstTethered = XGUnit(History.GetVisualizer(UnitsTethered[TetherIndex])).GetPawn();
	SecondTethered = XGUnit(History.GetVisualizer(UnitsTethered[TetherIndex + 1])).GetPawn();

	FirstTethered.Mesh.GetSocketWorldLocationAndRotation(StartSocket, FirstLocation);
	SecondTethered.Mesh.GetSocketWorldLocationAndRotation(EndSocket, SecondLocation);
	FirstToSecond = SecondLocation - FirstLocation;
	DistanceBetween = VSize(FirstToSecond);
	FirstToSecond = Normal(FirstToSecond);

	TethersSpawned[TetherIndex].SetAbsolute(true, true);
	TethersSpawned[TetherIndex].SetTranslation(FirstLocation);
	TethersSpawned[TetherIndex].SetRotation(Rotator(FirstToSecond));

	DistanceBetweenVector.X = DistanceBetween;
	DistanceBetweenVector.Y = DistanceBetween;
	DistanceBetweenVector.Z = DistanceBetween;
	TethersSpawned[TetherIndex].SetVectorParameter('Distance', DistanceBetweenVector);
	TethersSpawned[TetherIndex].SetFloatParameter('Distance', DistanceBetween);

	Origin = FirstLocation;
	Delta = SecondLocation - FirstLocation;
}

simulated state Executing
{
	simulated event Tick(float fDeltaT)
	{
		local int TetherIndex;
		local Name UseSocket;

		Super.Tick(fDeltaT);

		// Loop through our tethers and update the distance parameter and their location/rotation
		UseSocket = StartingSocket;
		for( TetherIndex = 0; TetherIndex < TethersSpawned.Length && TetherIndex + 1 < UnitsTethered.Length; ++TetherIndex )
		{
			UpdateSingleTether(TetherIndex, UnitsTethered[TetherIndex], UnitsTethered[TetherIndex + 1], UseSocket, TargetSocket);
			UseSocket = TargetSocket;
		}
	}
Begin:
	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);
	
	AnimParams.AnimName = AnimName;

	PlayingSequence = UnitPawn.GetAnimTreeController().PlayDynamicAnim(AnimParams, 0);

	while( !StartChain &&
		   !IsTimedOut() )	// ADDING THIS ISTIMEDOUT UNTIL WE FIX THE VISUALIZATION FOR THESE ABILITIES
	{
		Sleep(0.0f);
	}

	HandleSingleTarget(UnitPawn.ObjectID, PrimaryTargetID, StartingSocket, TargetSocket);
	if( AbilityContext.InputContext.MultiTargets.Length != 0 )
	{
		Sleep(ChainDelay);
		HandleSingleTarget(PrimaryTargetID, AbilityContext.InputContext.MultiTargets[0].ObjectID, TargetSocket, TargetSocket);
		for( MultiTargetIndex = 0; MultiTargetIndex < AbilityContext.InputContext.MultiTargets.length - 1; ++MultiTargetIndex )
		{
			Sleep(ChainDelay);

			HandleSingleTarget(AbilityContext.InputContext.MultiTargets[MultiTargetIndex].ObjectID, AbilityContext.InputContext.MultiTargets[MultiTargetIndex + 1].ObjectID, TargetSocket, TargetSocket);
		}
	}

	FinishAnim(PlayingSequence);

	CompleteAction();
}

DefaultProperties
{
	bNotifyMultiTargetsAtOnce = false;
	AnimName = "NO_CombatProtocol"
}