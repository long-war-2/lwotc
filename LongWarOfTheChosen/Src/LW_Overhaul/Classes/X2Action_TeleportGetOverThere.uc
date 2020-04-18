class X2Action_TeleportGetOverThere extends X2Action;

var vector Destination;

var private bool bAbilityEffectReceived;

//Cached info for the unit performing the action
//*************************************
var protected CustomAnimParams AnimParams;

var private X2Camera_LookAtActorTimed LookAtCam;
var private Actor FOWViewer;					// The current FOW Viewer actor
												//*************************************
function bool CheckInterrupted()
{
	return false;
}

function bool IsTimedOut()
{
	return false;
}

function HandleTrackMessage()
{
	bAbilityEffectReceived = true;
}

simulated state Executing
{
	private function RequestLookAtCamera()
	{
		if (ShouldAddCameras())
		{
			LookAtCam = new class'X2Camera_LookAtActorTimed';
			LookAtCam.ActorToFollow = UnitPawn;
			LookAtCam.UseTether = false;
			`CAMERASTACK.AddCamera(LookAtCam);

			FOWViewer = `XWORLD.CreateFOWViewer(Unit.GetLocation(), 3 * class'XComWorldData'.const.WORLD_StepSize);
		}
	}

	private function ClearLookAtCamera()
	{
		`CAMERASTACK.RemoveCamera(LookAtCam);
		LookAtCam = None;

		if (FOWViewer != None)
		{
			`XWORLD.DestroyFOWViewer(FOWViewer);
			FOWViewer = None;
		}
	}

Begin:
	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);

	//Ensure Time Dilation is full speed
	VisualizationMgr.SetInterruptionSloMoFactor(Metadata.VisualizeActor, 1.0f);
	
	AnimParams.AnimName = 'HL_TeleportStart';
	FinishAnim(UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(AnimParams));

	// Move the pawn to the end position
	Destination.Z = `XWORLD.GetFloorZForPosition(Destination, true) + UnitPawn.CollisionHeight + class'XComWorldData'.const.Cover_BufferDistance;
	UnitPawn.SetLocation(Destination);

	if (!bNewUnitSelected)
	{
		RequestLookAtCamera();
		while (LookAtCam != None && !LookAtCam.HasArrived && LookAtCam.IsLookAtValid())
		{
			Sleep(0.0);
		}
	}

	// Play the teleport stop animation
	AnimParams.AnimName = 'HL_TeleportStop';
	FinishAnim(UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(AnimParams));

	ClearLookAtCamera();

	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);
	UnitPawn.SnapToGround();

	CompleteAction();
}
