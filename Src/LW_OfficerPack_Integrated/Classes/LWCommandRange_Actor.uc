//---------------------------------------------------------------------------------------
//  FILE:    LWCommandRange_Actor.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: This Archetype is used to handle display of Command Range Particle Systems
//           
//---------------------------------------------------------------------------------------

//TODO -- currently not allowing creation of an archetype based on this in UnrealEd

class LWCommandRange_Actor extends Actor
	notplaceable
	HideCategories(Movement,Display,Attachment,Actor,Collision,Physics,Advanced,Debug);

struct Boundary
{
	var vector BoundaryCenter;
	var bool Rotated;
	var XComUnitPawn UnitPawn;
	var ParticleSystemComponent PSComponent;
};

var() ParticleSystem BoundaryPS;
var string ParticleSystemName;

var array<ParticleSystemComponent> PSComponents;
var array<Boundary> Boundaries;
var array<TTile> InRangeTiles;

simulated function Init()
{
	//if (BoundaryPS == none)
		BoundaryPS = ParticleSystem(DynamicLoadObject(ParticleSystemName, class'ParticleSystem'));
}

function DrawBoundaries()
{
	local Boundary CurrBoundary;

	foreach Boundaries(CurrBoundary)
	{
		if (CurrBoundary.Rotated)
		{
			CurrBoundary.PSComponent = CreateEffect(CurrBoundary.BoundaryCenter, rotator(vect(0, 1, 0)), CurrBoundary.UnitPawn);
		} else {
			CurrBoundary.PSComponent = CreateEffect(CurrBoundary.BoundaryCenter,, CurrBoundary.UnitPawn);
		}
	}
}

function AddBoundariesFromOfficer(XComGameState_Unit Unit)
{
	local float CommandRangeSq;
	local int i, j, CR;
	local TTile UnitTile, TestTile, DeltaTileX, DeltaTileY;
	local Boundary NewBoundary;
	local XComWorldData WorldData;

	WorldData = `XWORLD;

	CommandRangeSq = class'X2Ability_OfficerAbilitySet'.static.GetCommandRangeSq(Unit);
	CR = int(Sqrt(CommandRangeSq) + 1.0);
	UnitTile = Unit.TileLocation;
	TestTile = UnitTile;
	DeltaTileY = TestTile;
	DeltaTileX = TestTile;

	NewBoundary.UnitPawn = XGUnit(Unit.GetVisualizer()).GetPawn();

	for (i = -CR ; i <= CR; i++)
	{
		for (j = -CR ; j <= CR; j++)
		{
			TestTile.X = UnitTile.X + i;
			TestTile.Y = UnitTile.Y + j;
			DeltaTileY.X = TestTile.X ;
			DeltaTileY.Y = TestTile.Y + 1;
			DeltaTileX.X = TestTile.X + 1;
			DeltaTileX.Y = TestTile.Y ;
			if (class'Helpers'.static.IsTileInRange(UnitTile, TestTile, CommandRangeSq) != class'Helpers'.static.IsTileInRange(UnitTile, DeltaTileY, CommandRangeSq))
			{
				NewBoundary.BoundaryCenter = (WorldData.GetPositionFromTileCoordinates(TestTile) + WorldData.GetPositionFromTileCoordinates(DeltaTileY))/2;
				NewBoundary.Rotated = true;
				Boundaries.AddItem(NewBoundary);
			}
			if (class'Helpers'.static.IsTileInRange(UnitTile, TestTile, CommandRangeSq) != class'Helpers'.static.IsTileInRange(UnitTile, DeltaTileX, CommandRangeSq))
			{
				NewBoundary.BoundaryCenter = (WorldData.GetPositionFromTileCoordinates(TestTile) + WorldData.GetPositionFromTileCoordinates(DeltaTileX))/2;
				NewBoundary.Rotated = false;
				Boundaries.AddItem(NewBoundary);
			}
		}
	}
}

function ParticleSystemComponent CreateEffect(vector EffectLocation, optional rotator EffectRotation = rotator(vect(0, 0, 0)), optional XComUnitPawn UnitPawn = none)
{
	// The instance of the Particle system component playing this effect.
	local ParticleSystemComponent PSComponent;

	//PSComponent = class'WorldInfo'.static.GetWorldInfo().MyEmitterPool.SpawnEmitter(ParticleSystem(DynamicLoadObject(ParticleSystemName, class'ParticleSystem')), EffectLocation, EffectRotation);
	if (UnitPawn == none) 
	{
		PSComponent = class'WorldInfo'.static.GetWorldInfo().MyEmitterPool.SpawnEmitter(BoundaryPS, EffectLocation, EffectRotation);
	} else {
		PSComponent = class'WorldInfo'.static.GetWorldInfo().MyEmitterPool.SpawnEmitter(BoundaryPS, UnitPawn.Location - EffectLocation, EffectRotation);
	}
	PSComponent.SetScale(18.0);

	if (UnitPawn != none)
	{
		PSComponent.SetAbsolute(false, true, true);
		UnitPawn.AttachComponent( PSComponent );
	}
	//PSComponents.AddItem(PSComponent);
	return PSComponent;
}

function RemoveEffects()
{
	local ParticleSystemComponent PSComponent;
	local Boundary CurrBoundary;
	local ParticleSystemComponent TestPSComponent;
	local int CountDetach, CountDeactivate;

	foreach Boundaries(CurrBoundary) 
	{
		if (CurrBoundary.UnitPawn != none)
		{
			foreach CurrBoundary.UnitPawn.ComponentList( class'ParticleSystemComponent', TestPSComponent )
			{
				if (PathName( TestPSComponent.Template ) == ParticleSystemName)
				{
					PSComponent = TestPSComponent;
					PSComponent.SetAbsolute(class'EmitterPool'.default.PSCTemplate.AbsoluteTranslation, class'EmitterPool'.default.PSCTemplate.AbsoluteRotation, class'EmitterPool'.default.PSCTemplate.AbsoluteScale);
					CurrBoundary.UnitPawn.DetachComponent( PSComponent );
					CountDetach++;
					break;
				}
			}
		}
		if (PSComponent != none)
		{
			PSComponent.DeactivateSystem();
			CountDeactivate++;
		}
	}
	Boundaries.length = 0;
	`log("LWCommandRange_Actor: Detached=" $ string(CountDetach) $ ", Deactivated=" $ string(CountDeactivate));
}

//----------------- Below is prototype code for tile drawing, which uses the ShapeManager to draw debug boxes ----------------

simulated function DrawTiles()
{
	local byte R, G, B;
	local TTile CurrTile;
	local SimpleShapeManager ShapeManager;

	ShapeManager = `SHAPEMGR;

	R = 96;
	G = 255;
	B = 96;

	foreach InRangeTiles(CurrTile)
	{
		ShapeManager.DrawTile(CurrTile, R, G, B);
	}
}

simulated function AddTilesFromOfficer(XComGameState_Unit Unit)
{
	local float CommandRangeSq;
	local int i, j, CR;
	local TTile TestTile, UnitTile;

	CommandRangeSq = class'X2Ability_OfficerAbilitySet'.static.GetCommandRangeSq(Unit);
	CR = int(Sqrt(CommandRangeSq) + 2.0);
	UnitTile = Unit.TileLocation;
	TestTile = UnitTile;

	for (i = -CR ; i <= CR; i++)
	{
		for (j = -CR ; j <= CR; j++)
		{
			TestTile.X = UnitTile.X + i;
			TestTile.Y = UnitTile.Y + j;
			if (class'Helpers'.static.IsTileInRange(UnitTile, TestTile, CommandRangeSq))
			{
				InRangeTiles.AddItem(TestTile);
			}
		}
	}
}

simulated function ClearTiles()
{
	InRangeTiles.Length = 0;
	class'WorldInfo'.static.GetWorldInfo().FlushPersistentDebugLines();
}


defaultProperties
{
	ParticleSystemName = "LWCommandRange.Boundary.P_LeaderRange_Persistent"
}


