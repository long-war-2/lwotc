//-----------------------------------------------------------
// Used by the visualizer system to control a Visualization Actor
//-----------------------------------------------------------
class X2Action_Fire_Flamethrower_LW extends X2Action_Fire_Flamethrower;


function Init()
{
	local Vector TempDir;
	local XComWorldData WorldData;
	local vector ShootAtLocation;

	super.Init();

	WorldData = `XWORLD;

	AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));

	if (AbilityState.GetMyTemplate().TargetingMethod == class'X2TargetingMethod_Cone_Flamethrower_LW')
	{
		coneTemplate = X2AbilityMultiTarget_Cone(AbilityState.GetMyTemplate().AbilityMultiTargetStyle);

		ConeLength = coneTemplate.GetConeLength(AbilityState);
		ConeWidth = coneTemplate.GetConeEndDiameter(AbilityState) * 1.35;

		StartLocation = UnitPawn.Location;

		EndLocation = AbilityContext.InputContext.TargetLocations[0];

		// Update Z
		ShootAtLocation = Unit.GetShootAtLocation(eHit_Success, Unit.GetVisualizedStateReference());
		AimZOffset = ShootAtLocation.Z - WorldData.GetFloorZForPosition(Unit.Location, true);
		EndLocation.Z = WorldData.GetFloorZForPosition(EndLocation, true) + AimZOffset;

		StartLocation.Z = EndLocation.Z;
		
		ConeDir = EndLocation - StartLocation;
		UnitDir = Normal(ConeDir);

		ConeAngle = ConeWidth / ConeLength;

		ArcDelta = ConeAngle / SweepDuration;

		TempDir.x = UnitDir.x * cos(-ConeAngle / 2) - UnitDir.y * sin(-ConeAngle / 2);
		TempDir.y = UnitDir.x * sin(-ConeAngle / 2) + UnitDir.y * cos(-ConeAngle / 2);
		TempDir.z = UnitDir.z;

		SweepEndLocation_Begin = StartLocation + (TempDir * ConeLength);

		TempDir.x = UnitDir.x * cos(ConeAngle / 2) - UnitDir.y * sin(ConeAngle / 2);
		TempDir.y = UnitDir.x * sin(ConeAngle / 2) + UnitDir.y * cos(ConeAngle / 2);
		TempDir.z = UnitDir.z;

		SweepEndLocation_End = StartLocation + (TempDir * ConeLength);

		SecondaryTiles = AbilityContext.InputContext.VisibleNeighborTiles;

//		`SHAPEMGR.DrawSphere(EndLocation, vect(15, 15, 15), MakeLinearColor(1, 0, 0, 1), true);
	}

	currDuration = 0.0;
	beginAimingAnim = false;
	endAimingAnim = false;

	CurrentFlameLength = -1.0;
	TargetFlameLength = -1.0;
}

