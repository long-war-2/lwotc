//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_MoveClimbWall_Override extends X2Action_MoveClimbWall;

//var vector  Destination;
//var vector	Source;
//var float   Distance;

var private Name m_StartAnim;
var private Name m_LoopAnim;
var private Name m_StopAnim;
var private CustomAnimParams AnimParams;
var private bool m_bAscending;
var private BoneAtom StartingAtom;
var private vector EndingPoint;
var EDiscState eDisc;
var bool    bStoredSkipIK;
var Rotator DesiredRotation;
var float WallHeight;
var Quat QuatRotation;

function Init()
{
	super(X2Action_Move).Init();

	DesiredRotation = Normalize(Rotator(Destination - UnitPawn.Location));
	DesiredRotation.Pitch = 0;
	DesiredRotation.Roll = 0;
	QuatRotation = QuatFromRotator(DesiredRotation);
	PathTileIndex = FindPathTileIndex();
}

function ParsePathSetParameters(int InPathIndex, const out vector InDestination, const out vector InSource, float InDistance)
{
	PathIndex = InPathIndex;	
	Destination = InDestination;
	Source = InSource;
	Distance = InDistance;
}

simulated function ChooseAnims()
{
	m_StartAnim = 'MV_ClimbLadderUp_StartA';
	m_LoopAnim = 'MV_ClimbLadderUp_LoopA';
	m_StopAnim = 'MV_ClimbLadderUp_StopA';
}

simulated state Executing
{
Begin:
	ChooseAnims();

	eDisc = Unit.m_eDiscState;
	Unit.SetDiscState(eDS_None);

	bStoredSkipIK = UnitPawn.bSkipIK;
	UnitPawn.bSkipIK = true;
	UnitPawn.EnableRMA(true, true);
	UnitPawn.EnableRMAInteractPhysics(true);

	WallHeight = Destination.Z - Source.Z;

	// Start
	AnimParams.AnimName = m_StartAnim;
	AnimParams.PlayRate = GetMoveAnimationSpeed();
	StartingAtom.Translation = AbilityContext.InputContext.MovementPaths[MovePathIndex].MovementData[PathIndex].Position;
	StartingAtom.Rotation = QuatRotation;
	StartingAtom.Scale = 1.0f;
	StartingAtom.Translation.Z = Unit.GetDesiredZForLocation(StartingAtom.Translation);
	UnitPawn.GetAnimTreeController().GetDesiredEndingAtomFromStartingAtom(AnimParams, StartingAtom);
	FinishAnim(UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(AnimParams));
	
	// Loop
	if (WallHeight > 400)
	{
		AnimParams = default.AnimParams;
		AnimParams.PlayRate = GetMoveAnimationSpeed();
		AnimParams.AnimName = m_LoopAnim;
		FinishAnim(UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(AnimParams));
	}
	
	//NewDirection.Z = 0.0f;
	//if( abs(NewDirection.X) < 0.001f && abs(NewDirection.Y) < 0.001f )
	//{
		//NewDirection = vector(UnitPawn.Rotation);
	//}

	// Stop

	AnimParams = default.AnimParams;
	AnimParams.DesiredEndingAtoms.Add(1);
	AnimParams.DesiredEndingAtoms[0].Translation = Destination;
	AnimParams.DesiredEndingAtoms[0].Translation.Z = UnitPawn.GetDesiredZForLocation(Destination);
	AnimParams.DesiredEndingAtoms[0].Rotation = QuatRotation;
	AnimParams.DesiredEndingAtoms[0].Scale = 1.0f;;
	AnimParams.PlayRate = GetMoveAnimationSpeed();
	AnimParams.AnimName = m_StopAnim;
	FinishAnim(UnitPawn.GetAnimTreeController().PlayFullBodyDynamicAnim(AnimParams));

	UnitPawn.Acceleration = Vect(0, 0, 0);
	UnitPawn.vMoveDirection = Vect(0, 0, 0);
	UnitPawn.m_fDistanceMovedAlongPath = Distance;

	UnitPawn.bSkipIK = bStoredSkipIK;
	UnitPawn.EnableRMA(false, false);
	UnitPawn.EnableRMAInteractPhysics(false);
	UnitPawn.SnapToGround();

	Unit.SetDiscState(eDisc);
	CompleteAction();
}

function bool CheckInterrupted()
{
	//Do not allow interruptions while climbing. Interruptions like an AI reveal/scamper would break badly if this happened.
	//Nearly everything else will happen before the unit gets to the ladder, or can just wait until the unit is at the other end.
	//Some contrived cases will look wrong doing this (overwatching a unit that was briefly visible during a ladder climb) - but none are as bad as that.
	return false;
}

DefaultProperties
{
}
