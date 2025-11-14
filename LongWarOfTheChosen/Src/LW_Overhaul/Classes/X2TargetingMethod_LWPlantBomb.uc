//---------------------------------------------------------------------------------------
//  FILE:    X2TargetingMethod_LWPlantBomb.uc
//  AUTHOR:  Furu -- 11/11/2025
//  PURPOSE: To draw radial damage tiles of component objects of an object unit is targeting
//---------------------------------------------------------------------------------------

class X2TargetingMethod_LWPlantBomb extends X2TargetingMethod_TopDown;

function DirectSetTarget(int TargetIndex)
{
	local array<TTile> Tiles;
	local array<Actor> CurrentlyMarkedTargets;

	local XComGameState_BaseObject TargetedObject;
	local array<XComGameState_BaseObject> ComponentObjects;
	local XComGameState_BaseObject ComponentObject;
	local XComDestructibleActor DestructibleActor;

	super.DirectSetTarget(TargetIndex);

	TargetedObject = `XCOMHISTORY.GetGameStateForObjectID(GetTargetedObjectID());
	if(TargetedObject != None)
	{
		TargetedObject.GetAllComponentObjects(ComponentObjects);
		foreach ComponentObjects(ComponentObject)
		{
			DestructibleActor = XComDestructibleActor(ComponentObject.GetVisualizer());
			if(DestructibleActor != None && DestructibleActor.HasRadialDamage())
			{
				DestructibleActor.GetRadialDamageTiles(Tiles);
			}
		}
	}

	if( Tiles.Length > 0 )
	{
		// makes AOE tiles orange like you would expect from an offensive ability
		AOEMeshActor.InstancedMeshComponent.SetStaticMesh(StaticMesh(DynamicLoadObject("UI_3D.Tile.AOETile", class'StaticMesh')));

		GetTargetedActorsInTiles(Tiles, CurrentlyMarkedTargets, false);
		CheckForFriendlyUnit(CurrentlyMarkedTargets);
		MarkTargetedActors(CurrentlyMarkedTargets, (!AbilityIsOffensive) ? FiringUnit.GetTeam() : eTeam_None);
		DrawAOETiles(Tiles);
	}
	else
	{
		if(!AbilityIsOffensive)
		{
			AOEMeshActor.InstancedMeshComponent.SetStaticMesh(StaticMesh(DynamicLoadObject("UI_3D.Tile.AOETile_Neutral", class'StaticMesh')));
		}
	}
}