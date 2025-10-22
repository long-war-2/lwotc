///---------------------------------------------------------------------------------------
//  FILE:    SeqAct_SpawnAdditionalObjective.uc
//  AUTHOR:  David Burchanowski  --  9/16/2014
//  PURPOSE: Spawns additional, mission specific objectives outside the normal
//           
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class SeqAct_SpawnAdditionalObjective extends SequenceAction
	native;

var() int MinTileDistance; // min tiles from the main objective to spawn the new objective
var() int MaxTileDistance; // max tiles from the main objective to spawn the new objective
var() int MaxTilesFromLineOfPlay; // if < 0, does not place the objective along the line of play, but in a circle around the end of the line of play
var() float LineOfPlayJustification; // Offsets the spawn box by some percentage of the box's width. -0.5 puts the spawn range on the left side of the LOP, 0.5 is the left side, 0.0 is centered.

var() XComInteractiveLevelActor ObjectiveArchetype; // specifies the archetype of the new objective
var() string                    ObjectiveArchetypePathString; // specifies the archetype of the new objective, as a full path

// selection criteria
var() bool AvoidWalls; // if true, will try not to place the objective against a wall
var() bool AvoidOpenAreas; // if true, will try to place the objective against a wall
var() bool AvoidPathBlocking; // if true, the objective will not block special pathing traversals

var() bool SpawnIndoors; // if true, will try to place the objective against a wall
var() bool SpawnOutdoors; // if true, the objective will not block special pathing traversals

var() bool AffectsLineOfPlay; // if true, the location of this objective will influence the endpoint of the line of play
var() bool ObjectiveRelated; // if false, this isn't spawning for an objective but some other purpose like a Sitrep.
								// for XCom3 we should really have a seperate node and perhaps one that can support Destructibles
								// instead of requiring Interactive.

var XComGameState_InteractiveObject SpawnedObjective;

event Activated()
{
	local XComTacticalMissionManager MissionManager;
	local XComGameState_ObjectiveInfo ObjectiveInfo;
	local XComGameStateContext_ChangeContainer ChangeContext;
	local XComGameState NewGameState;
	local TTile SpawnTile;

	SpawnedObjective = none;

	if(SelectSpawnTile(SpawnTile))
	{
		MissionManager = `TACTICALMISSIONMGR;
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("SeqAct_SpawnAdditionalObjective::Activate()");
		ChangeContext = XComGameStateContext_ChangeContainer(NewGameState.GetContext());
		ChangeContext.BuildVisualizationFn = BuildVisualization;

		SpawnedObjective = XComGameState_InteractiveObject(NewGameState.CreateNewStateObject(class'XComGameState_InteractiveObject'));
		SpawnedObjective.ArchetypePath = ObjectiveArchetype != none ? PathName(ObjectiveArchetype) : ObjectiveArchetypePathString;
		SpawnedObjective.TileLocation = SpawnTile;
		SpawnedObjective.bRequiresVisibilityUpdate = true;

		if (ObjectiveRelated)
		{
			ObjectiveInfo = XComGameState_ObjectiveInfo(NewGameState.CreateNewStateObject(class'XComGameState_ObjectiveInfo'));
			ObjectiveInfo.MissionType = MissionManager.ActiveMission.sType;
			ObjectiveInfo.AffectsLineOfPlay = AffectsLineOfPlay;

			SpawnedObjective.AddComponentObject(ObjectiveInfo);
		}

		NewGameState.GetContext().SetAssociatedPlayTiming(SPT_AfterSequential);

		`TACTICALRULES.SubmitGameState(NewGameState);
		OutputLinks[0].bHasImpulse = true;
		OutputLinks[1].bHasImpulse = false;
	}
	else
	{
		`Redscreen("SeqAct_SpawnAdditionalObjective: no matching spawn location found.");
		OutputLinks[0].bHasImpulse = false;
		OutputLinks[1].bHasImpulse = true;
	}
}

static function BuildVisualization(XComGameState GameState)
{
	local VisualizationActionMetadata ActionMetadata;
	local XComGameState_InteractiveObject InteractiveObject;

	foreach GameState.IterateByClassType(class'XComGameState_InteractiveObject', InteractiveObject)
	{
		ActionMetadata.StateObject_OldState = none;
		ActionMetadata.StateObject_NewState = InteractiveObject;
		class'X2Action_SyncVisualizer'.static.AddToVisualizationTree(ActionMetadata, GameState.GetContext());		
	}
}

// chooses the tile to spawn the objective on, if not using OSPs
native function bool SelectSpawnTile(out TTile SpawnTile);

function ModifyKismetGameState(out XComGameState NewGameState);

static event int GetObjClassVersion()
{
	return super.GetObjClassVersion() + 2;
}

defaultproperties
{
	ObjName="Spawn Additional Objective"
	ObjCategory="Level"
	bCallHandler=false;

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	AvoidPathBlocking=true
	AvoidOpenAreas=true

	MinTileDistance=0
	MaxTileDistance=7
	MaxTilesFromLineOfPlay=-1
	LineOfPlayJustification=0.0f

	SpawnIndoors=true
	SpawnOutdoors=true

	AffectsLineOfPlay=false
	ObjectiveRelated=true

	OutputLinks(0)=(LinkDesc="Success")
	OutputLinks(1)=(LinkDesc="Failure")

	VariableLinks.Empty
	VariableLinks(0)=(ExpectedType=class'SeqVar_InteractiveObject',LinkDesc="Spawned Objective",PropertyName=SpawnedObjective,bWriteable=true)
	VariableLinks(1)=(ExpectedType=class'SeqVar_String',LinkDesc="Archetype Path",PropertyName=ObjectiveArchetypePathString)
}


