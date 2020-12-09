///---------------------------------------------------------------------------------------
//  FILE:    LWSpawnUnitFromAvenger.uc
//  AUTHOR:  Aminer / Pavonis Interactive
//  PURPOSE: Adapted from SeqAct version, used to spawn additional units into tactical play
//---------------------------------------------------------------------------------------

class LWSpawnUnitFromAvenger extends Object;

//

var XComGameState_Unit SpawnedUnit;

static function XComGameState_Unit SpawnUnitFromAvenger(StateObjectReference UnitRef)
{
	local XComGameStateHistory History;
	local XComGameState_Unit StrategyUnit;

	History = `XCOMHISTORY;

	`LOG("LWSpawnFromAvenger: Starting SpawnUnit");

	if(History.FindStartStateIndex() > 1) // this is a strategy game
	{
		// try to get a unit from the strategy game
		StrategyUnit = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));
		if(StrategyUnit == none)
			return none;

		// and add it to the board
		return AddStrategyUnitToBoard(StrategyUnit, History);
	}
}

// Places the given strategy unit on the game board near the spawn zone
static function XComGameState_Unit AddStrategyUnitToBoard(XComGameState_Unit Unit, XComGameStateHistory History, optional TTile SpawnTile)
{
	local Vector SpawnLocation;
	
	// pick a floor point at random to spawn the unit at
	if (!ChooseSpawnLocation(SpawnLocation))
	{
		return none;
	}

	return AddStrategyUnitToBoardAtLocation(Unit, History, SpawnLocation);
}

// Places the given strategy unit on the game board at a given location
static function XComGameState_Unit AddStrategyUnitToBoardAtLocation(XComGameState_Unit Unit, XComGameStateHistory History, Vector SpawnLocation)
{
	local X2TacticalGameRuleset Rules;
	local XComGameStateContext_TacticalGameRule NewGameStateContext;
	local XComGameState NewGameState;
	local XComGameState_Player PlayerState;
	local StateObjectReference ItemReference;
	local XComGameState_Item ItemState;
	local array<XComGameState_Item> Items;
	local XComGameState_Item Item, UpdatedItem;
	local XComGameState_Unit UpdatedUnit;

	if(Unit == none)
	{
		return none;
	}

	// create the history frame with the new tactical unit state
	NewGameStateContext = class'XComGameStateContext_TacticalGameRule'.static.BuildContextFromGameRule(eGameRule_UnitAdded);
	NewGameState = History.CreateNewGameState(true, NewGameStateContext);
	Unit = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', Unit.ObjectID));
	Unit.SetVisibilityLocationFromVector(SpawnLocation);
	Unit.BeginTacticalPlay(NewGameState);
	//Unit.bSpawnedFromAvenger = true; // removed to fix TTP 225 (Missions counting twice) -- shouldn't be needed here, since these soldiers are in the Crew

	// assign the new unit to the human team
	foreach History.IterateByClassType(class'XComGameState_Player', PlayerState)
	{
		if(PlayerState.GetTeam() == eTeam_XCom)
		{
			Unit.SetControllingPlayer(PlayerState.GetReference());
			break;
		}
	}

	// Make sure the unit is added to XCOM's initiative group, otherwise the
	// player won't be able to control them.
	class'Helpers_LW'.static.AddUnitToXComGroup(NewGameState, Unit, PlayerState, History);

	// add item states. This needs to be done so that the visualizer sync picks up the IDs and
	// creates their visualizers
	foreach Unit.InventoryItems(ItemReference)
	{
		ItemState = XComGameState_Item(NewGameState.ModifyStateObject(class'XComGameState_Item', ItemReference.ObjectID));
		//Issue #159, this is needed now for loading units from avenger to properly update gamestate.
		ItemState.BeginTacticalPlay(NewGameState);

		// add any cosmetic items that might exists
		ItemState.CreateCosmeticItemUnit(NewGameState);
	}

	Rules = `TACTICALRULES;
	// submit it
	XComGameStateContext_TacticalGameRule(NewGameState.GetContext()).UnitRef = Unit.GetReference();
	Rules.SubmitGameState(NewGameState);

	// make sure the visualizer has been created so self-applied abilities have a target in the world
	Unit.FindOrCreateVisualizer(NewGameState);

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("LWS: Ammo Merging");
	UpdatedUnit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', Unit.ObjectID));
	NewGameState.AddStateObject(UpdatedUnit);
	// Must add items to gamestate to do ammo merging properly.
	Items = UpdatedUnit.GetAllInventoryItems(NewGameState);
	foreach Items(Item)
	{
		UpdatedItem = XComGameState_Item(NewGameState.CreateStateObject(class'XComGameState_Item', Item.ObjectID));
		NewGameState.AddStateObject(UpdatedItem);
	}
	// call GatherUnitAbilitiesForInit in order to merge ammo and submit to history, since InitializeUnitAbilities needs those in the History to function properly
	UpdatedUnit.GatherUnitAbilitiesForInit(NewGameState, PlayerState);
	Rules.SubmitGameState(NewGameState);

	// add abilities
	// Must happen after unit is submitted and ammo merged, or it gets confused about when the unit is in play or not, and it can pull stale item info
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("LWS: Initializing Abilities");
	UpdatedUnit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', UpdatedUnit.ObjectID));
	NewGameState.AddStateObject(UpdatedUnit);
	Items = UpdatedUnit.GetAllInventoryItems(NewGameState);
	foreach Items(Item)
	{
		UpdatedItem = XComGameState_Item(NewGameState.ModifyStateObject(class'XComGameState_Item', Item.ObjectID));
		//Issue #159, this is needed now for loading units from avenger to properly update gamestate.
		ItemState.BeginTacticalPlay(NewGameState);
	}

	Rules.InitializeUnitAbilities(NewGameState, UpdatedUnit);

	// make the unit concealed, if they have Phantom
	// (special-case code, but this is how it works when starting a game normally)
	if (UpdatedUnit.FindAbility('Phantom').ObjectID > 0)
	{
		UpdatedUnit.EnterConcealmentNewGameState(NewGameState);
	}

	Rules.SubmitGameState(NewGameState);

	return UpdatedUnit;
}

// chooses a location for the unit to spawn in the spawn zone
static function bool ChooseSpawnLocation(out Vector SpawnLocation)
{
	local XComParcelManager ParcelManager;
	local XComGroupSpawn SoldierSpawn;
	local array<Vector> FloorPoints;

	// attempt to find a place in the spawn zone for this unit to spawn in
	ParcelManager = `PARCELMGR;
	SoldierSpawn = ParcelManager.SoldierSpawn;

	if(SoldierSpawn == none) // check for test maps, just grab any spawn
	{
		return false;
	}

	GetValidFloorLocations(FloorPoints, SoldierSpawn);
	if(FloorPoints.Length == 0)
	{
		return false;
	}
	else
	{
		SpawnLocation = FloorPoints[`SYNC_RAND_STATIC(FloorPoints.Length)];
		return true;
	}
}

// gets all the floor locations that this group spawn encompasses
static function GetValidFloorLocations(out array<Vector> FloorPoints, XComGroupSpawn kSoldierSpawn)
{
	local TTile RootTile, Tile;
	local array<TTile> FloorTiles;
	local XComWorldData World;
	local int Width, Height, NumSoldiers;
	local bool Toggle;

	Width = 3;
	Height = 3;
	Toggle = false;
	NumSoldiers = `XCOMHQ.Squad.Length;

	World = `XWORLD;
	RootTile = kSoldierSpawn.GetTile();
	while(FloorPoints.Length < NumSoldiers)
	{
		FloorPoints.Length = 0;
		World.GetSpawnTilePossibilities(RootTile, Width, Height, 1, FloorTiles);

		foreach FloorTiles(Tile)
		{
			FloorPoints.AddItem(World.GetPositionFromTileCoordinates(Tile));
		}
		if(Toggle)
			Width ++;
		else
			Height ++;

		Toggle = !Toggle;		
	}
}

