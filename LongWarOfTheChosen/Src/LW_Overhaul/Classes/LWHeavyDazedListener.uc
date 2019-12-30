class LWHeavyDazedListener extends Actor implements(X2VisualizationMgrObserverInterface);

var LWInstancedTileComponent TileComp;
var bool UpdateFlag;

event PostBeginPlay()
{
	TileComp = new class'LWInstancedTileComponent';
	TileComp.CustomInit();
	TileComp.SetMesh(StaticMesh(DynamicLoadObject("UI3D_XPack.Tile.BuddyTile_Safe_Enter", class'StaticMesh')));
	`XCOMVISUALIZATIONMGR.RegisterObserver(self);
}

event Tick(float DeltaTime)
{
	if (UpdateFlag && !`XCOMVISUALIZATIONMGR.VisualizerBusy())
	{
		UpdateFlag = false;
		UpdateDazedTiles();
	}
}

function UpdateDazedTiles()
{
	local XComGameStateVisualizationMgr VisMgr;
	local XComGameStateHistory History;
	local XComWorldData WorldData;
	local int LastStateHistoryVisualized;
	local XComGameState_Unit Unit, ControllingUnit;
	local XComGameState_Ability Ability;
	local int LocalPlayerID;
	local ETeam TeamFlag;

	local vector UnitPos;
	local array<TilePosPair> TilePosPairs;
	local TilePosPair Pair;

	local array<TTile> Tiles;
	Tiles.Length = 0;

	VisMgr = `XCOMVISUALIZATIONMGR;
	History = `XCOMHISTORY;
	WorldData = `XWORLD;
	LastStateHistoryVisualized = VisMgr.LastStateHistoryVisualized;
	
	ControllingUnit = XComTacticalController(class'WorldInfo'.static.GetWorldInfo().GetALocalPlayerController())
							.ControllingUnitVisualizer.GetVisualizedGameState();

	LocalPlayerID = `TACTICALRULES.GetLocalClientPlayerObjectID();
	TeamFlag = XComGameState_Player(History.GetGameStateForObjectID(LocalPlayerID)).TeamFlag;
	foreach History.IterateByClassType(class'XComGameState_Unit', Unit, , , LastStateHistoryVisualized)
	{
		// Only Allies...
		if (Unit.IsEnemyTeam(TeamFlag)) continue;

		// ... affected by HeavyDazed...
		if (Unit.AffectedByEffectNames.Find(class'X2StatusEffects_LW'.default.HeavyDazedName) == INDEX_NONE) continue;

		// ... that we have vision on (TODO: History Index???)...
		if (!class'X2TacticalVisibilityHelpers'.static.CanSquadSeeTarget(LocalPlayerID, Unit.GetReference().ObjectID)) continue;

		// ... TODO: Any more conditions?

		UnitPos = WorldData.GetPositionFromTileCoordinates(Unit.TileLocation);
		// Collect tiles in radius
		TilePosPairs.Length = 0;
		WorldData.CollectTilesInSphere(TilePosPairs, UnitPos, class'X2Ability_DefaultAbilitySet'.default.REVIVE_RANGE_UNITS);
		foreach TilePosPairs(Pair)
		{
			if (WorldData.IsFloorTileAndValidDestination(Pair.Tile, ControllingUnit) && WorldData.CanUnitsEnterTile(Pair.Tile))
			{
				Tiles.AddItem(Pair.Tile);
			}
		}
	}

	foreach History.IterateByClassType(class'XComGameState_Ability', Ability, , , LastStateHistoryVisualized)
	{
		break;
	}

	TileComp.SetMockParameters(Ability);
	TileComp.SetTiles(Tiles);
	TileComp.SetMockParameters(none);
}

// TODO?: Replace this with a HL event in XComPathingPawn

/// <summary>
/// Called when an active visualization block is marked complete 
/// </summary>
event OnVisualizationBlockComplete(XComGameState AssociatedGameState)
{
	UpdateFlag = true;
}

/// <summary>
/// Called when the visualizer runs out of active and pending blocks, and becomes idle
/// </summary>
event OnVisualizationIdle()
{
	UpdateFlag = true;
}

/// <summary>
/// Called when the active unit selection changes
/// </summary>
event OnActiveUnitChanged(XComGameState_Unit NewActiveUnit)
{
	UpdateFlag = true;
}