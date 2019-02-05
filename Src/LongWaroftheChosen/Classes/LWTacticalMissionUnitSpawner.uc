//---------------------------------------------------------------------------------------
//  FILE:    LWTacticalMissionUnitSpawner
//  AUTHOR:  tracktwo (Pavonis Interactive)
//
//  PURPOSE: Handles spawning of units not in the main XCOM squad in tactical missions.
//           Primarily: rebels, resistance mecs, liaisons.
//--------------------------------------------------------------------------------------- 

`include(LongWaroftheChosen\Src\LW_Overhaul.uci)

class LWTacticalMissionUnitSpawner extends Object config(LW_Overhaul);

var config array<float> arrEncounterZoneWidths;
var config array<float> arrEncounterZoneOffsetsAlongLOP;

var config int RebelCapOnRetals;
var config int MecCap;

var config int MinCivilianSpawnDistanceSq;
var config int MaxCivilianSpawnDistanceSq;

// WOTC TODO: Relies on outpost management
//static function SpawnUnitsForMission(XComGameState_MissionSite Mission)
//{
	//local XComGameState_LWOutpost Outpost;
	//local XComGameState_WorldRegion Region;
	//local XComGameStateHistory History;
	//local XComGameState_MissionSiteRendezvous_LW RendezvousMission;
//
	//History = `XCOMHISTORY;
	//Region = XComGameState_WorldRegion(History.GetGameStateForObjectID(Mission.Region.ObjectID));
	//Outpost = `LWOUTPOSTMGR.GetOutpostForRegion(Region);
//
	//if (class'Utilities_LW'.static.CurrentMissionIsRetaliation())
	//{
		//if (Mission == None)
		//{
			//// Likely a tactical quicklaunch. Just create some random civvies.
			//CreateNewCivilianUnits();
		//}
		//else
		//{
			//LoadCivilianUnitsFromOutpost(Outpost);
			//LoadResistanceMECsFromOutpost(Outpost, false);
			//// Load the liaison. Soldiers go on XCOM's team, others start in the neutral team.
			//LoadLiaisonFromOutpost(Outpost, Outpost.HasLiaisonOfKind('Soldier') ? eTeam_XCom : eTeam_Neutral);
		//}
	//}
	//else
	//{
		//switch (class'Utilities_LW'.static.CurrentMissionType())
		//{
		//case "Rendezvous_LW":
			//if (Mission != None)
			//{
				//RendezvousMission = XComGameState_MissionSiteRendezvous_LW(Mission);
				//RendezvousMission.SetupFacelessUnits();
				//LoadResistanceMECsFromOutpost(Outpost, false);
			//}
			//break;
		//case "SupplyConvoy_LW":
			//// Supply convoy wants resistance MECs, and spawn them near the objective.
			//LoadResistanceMECsFromOutpost(Outpost, true);
			//if (Outpost.HasLiaisonValidForMission(Mission.GeneratedMission.Mission.sType))
			//{
				//LoadLiaisonFromOutpost(Outpost, eTeam_XCom, true);
			//}
			//LoadRebelsForRebelRaid(Mission);
			//break;
		//case "IntelRaid_LW":
			//LoadRebelsForRebelRaid(Mission);
			//if (Outpost.HasLiaisonValidForMission(Mission.GeneratedMission.Mission.sType))
			//{
				//LoadLiaisonFromOutpost(Outpost, eTeam_XCom, true);
			//}
			//break;
		//case "RecruitRaid_LW":
			//LoadRebelsForRebelRaid(Mission);
			//if (Outpost.HasLiaisonValidForMission(Mission.GeneratedMission.Mission.sType))
			//{
				//LoadLiaisonFromOutpost(Outpost, eTeam_XCom, false);
			//}
			//GiveEvacAbilityToRebels();
			//break;
		//}
	//}
//}
//
//static function array<XComGroupSpawn> GetCivilianSpawnLocations()
//{
	//local XComGameState_BattleData BattleData;
	//local array<XComGroupSpawn> SpawnPoints;
	//local XComGroupSpawn Spawn;
	//local Vector XComSpawnLocation;
	//local float SpawnDistance;
	//local int i;
//
	//foreach class'WorldInfo'.static.GetWorldInfo().AllActors(class'XComGroupSpawn', Spawn)
	//{
		//SpawnPoints.AddItem(Spawn);
	//}
//
	//BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	//XComSpawnLocation = BattleData.MapData.SoldierSpawnLocation;
//
	//`Log("Found " $ SpawnPoints.Length $ " spawn possibilities");
	//// Filter the spawn point list to those within appropriate distances.
	//for (i = SpawnPoints.Length - 1; i >= 0; --i)
	//{
		//SpawnDistance = VSizeSq(SpawnPoints[i].Location - XComSpawnLocation);
		//if (SpawnDistance < default.MinCivilianSpawnDistanceSq || SpawnDistance > default.MaxCivilianSpawnDistanceSq)
		//{
			//SpawnPoints.Remove(i, 1);
		//}
	//}
//
	//`Log(SpawnPoints.Length $ " spawn possibilities remain after distance filter");
	//return SpawnPoints;
//}
//
//static  function bool IsValidSpawnTile(TTile Tile)
//{
	//local XComWorldData WorldData;
	//local TileData TData;
//
	//WorldData = `XWORLD;
//
	//// Must be in bounds on the map
	//if (WorldData.IsTileOutOfRange(Tile))
	//{
		//return false;
	//}
//
	//// Can't already be occupied
	//if (WorldData.IsTileFullyOccupied(Tile))
	//{
		//return false;
	//}
//
	//// No hazards
	//if (WorldData.TileContainsPoison(Tile) || WorldData.TileContainsFire(Tile) || WorldData.TileContainsAcid(Tile))
	//{
		//return false;
	//}
//
	//// Heuristic to avoid civvies standing around on top of vans in terror missions. Only allow placement above the
	//// ground floor if the tile has any cover.
	//WorldData.GetTileData(Tile, TData);
	//if (!WorldData.IsGroundTile(Tile) && 
		//(TData.CoverFlags & (class'XComWorldData'.const.COVER_DIR_ANY | class'XComWorldData'.const.COVER_LOW_ANY)) == 0)
	//{
		//return false;
	//}
//
	//return true;
//}
//
//static function array<TTile> PickSpawnTiles(array<XComGroupSpawn> SpawnPoints, int Count)
//{
	//local int SpawnIndex;
	//local int x, y;
	//local TTile Candidate;
	//local XComWorldData WorldData;
	//local array<TTile> SpawnTiles;
//
	//WorldData = `XWORLD;
	//`Log("Choosing " $ Count $ " spawn points out of " $ SpawnPoints.Length $ " candidates");
	//SpawnIndex = 0;
	//// Start in the corner of the spawn zone. We'll move through the zone and put multiple civs
	//// in the same spawn if we run out of valid spawns before we place all the civs.
	//x = -1;
	//y = -1;
//
	//while (Count >= 0)
	//{
		//// Find our candidate tile and add the current offset values to it.
		//WorldData.GetFloorTileForPosition(SpawnPoints[SpawnIndex].Location, Candidate, true);
		//Candidate.X += x;
		//Candidate.Y += y;
//
		//// Check if this tile is in a "good" place.
		//if (IsValidSpawnTile(Candidate))
		//{
			//// It's good. Add it to our list and reduce the number of civvies left to place.
			//`Log("Using spawn tile " $ Candidate.X $ " " $ Candidate.Y);
			//SpawnTiles.AddItem(Candidate);
			//--Count;
		//}
//
		//// Move to the next spawn point on our list, cycling back to the beginning and updating
		//// the offsets if we run off the end. It'd probably be better to use a more spread out
		//// system instead of just incrementing the offsets so the civs don't spawn right next to
		//// each other when they get doubled up, but this should ideally be rare.
		//if (++SpawnIndex >= SpawnPoints.Length)
		//{
			//SpawnIndex = 0;
			//if (++x > 1)
			//{
				//x = -1;
				//if (++y > 1)
				//{
					//// We hit the end of the spawn box - no candidates left.
					//return SpawnTiles;
				//}
			//}
		//}
	//}
//
	//return SpawnTiles;
//}
//
//static function LoadCivilianUnitsFromOutpost(XComGameState_LWOutpost Outpost)
//{
	//local int i, WorkingRebels, HidingRebelsforMission;
	//local Name TemplateName;
	//local array<XComGroupSpawn> SpawnPoints;
	//local array<TTile> SpawnTiles;
	//local array<int> RebelsOnMission;
//
	//WorkingRebels = OutPost.Rebels.Length - OutPost.GetNumRebelsOnJob(class'LWRebelJob_DefaultJobSet'.const.HIDING_JOB);
	//HidingRebelsforMission = default.RebelCapOnRetals - WorkingRebels;
//
	//`LWTRACE("Outpost size:" @ OutPost.Rebels.length @ "Working Rebels:" @ string (WorkingRebels) @ "Hiding Rebels appearing on this mission");
//
	//// All rebels with a job go on the mission, plus enough hiding to get us up to the cap
	//for (i = 0; i < Outpost.Rebels.Length; ++i)
	//{
		//if (OutPost.Rebels.Length <= default.RebelCapOnRetals || OutPost.Rebels[i].Job != class'LWRebelJob_DefaultJobSet'.const.HIDING_JOB)
		//{
			//RebelsOnMission.AddItem(i);
		//}
		//else
		//{
			//if (HidingRebelsforMission > 0)
			//{
				//RebelsOnMission.AddItem(i);
				//HidingRebelsforMission -= 1;
			//}
		//}
	//}
//
	//SpawnPoints = GetCivilianSpawnLocations();
	//SpawnTiles = PickSpawnTiles(SpawnPoints, RebelsOnMission.Length);
//
	//// If we found fewer spawn tiles than rebels on mission (which should be extremely rare unless map mods have
	//// lots of parcels with no spawn possibilities) the rebels who don't get a spot get a pass on this mission.
	//if (SpawnTiles.Length < RebelsOnMission.Length)
	//{
		//`Redscreen("Found only " $ SpawnTiles.Length $ " candidates but have " $ RebelsOnMission.Length $ " rebels.");
		//RebelsOnMission.Length = SpawnTiles.Length;
	//}
	//for (i = 0; i < RebelsOnMission.Length; ++i)
	//{
		//if (Outpost.Rebels[RebelsOnMission[i]].IsFaceless)
		//{
			//TemplateName = 'FacelessRebelProxy';
		//}
		//else
		//{
			//TemplateName = 'Rebel';
		//}
//
		//class'Utilities_LW'.static.AddRebelToMission(Outpost.Rebels[RebelsOnMission[i]].Unit, Outpost.GetReference(), TemplateName, SpawnTiles[i], eTeam_Neutral);
	//}
//}
//
static function bool IsVisibleToAI(out TTile Tile)
{
	local XComGameState_Unit Viewer;
	local XComGameStateHistory History;
	local X2GameRulesetVisibilityManager VisibilityMgr;
	local array<GameRulesCache_VisibilityInfo> VisibilityInfos;
	local int i;

	History = `XCOMHISTORY;
	VisibilityMgr = `TACTICALRULES.VisibilityMgr;

	VisibilityMgr.GetAllViewersOfLocation(Tile, VisibilityInfos, class'XComGameState_Unit');

	for (i = VisibilityInfos.Length - 1; i >= 0; --i)
	{
		if(VisibilityInfos[i].bVisibleBasic)
		{
			Viewer = XComGameState_Unit(History.GetGameStateForObjectID(VisibilityInfos[i].SourceID));

			//Remove non-enemies from the list
			if(Viewer == none || Viewer.GetTeam() != eTeam_Alien)
			{
				VisibilityInfos.Remove(I, 1);
			}
			else if (!Viewer.IsAlive( ))
			{
				VisibilityInfos.Remove( I, 1 );
			}
		}
		else
		{
			VisibilityInfos.Remove(i, 1);
		}
	}

	return VisibilityInfos.Length > 0;
}
//
//static function LoadResistanceMECsFromOutpost(XComGameState_LWOutpost Outpost, bool SpawnNearObjective)
//{
	//local XComGameStateHistory History;
	//local X2TacticalGameRuleset Rules;
	//local XComGameState_Player PlayerState;
	//local XComGameStateContext_TacticalGameRule NewGameStateContext;
	//local XComGameState NewGameState;
	//local XComGameState_Unit Unit;
	//local XComGameState_Unit ProxyUnit;
	//local StateObjectReference ItemReference;
	//local XComGameState_Item ItemState;
	//local XComGameState_LWOutpost NewOutpost;
	//local XComGameState_BattleData BattleData;
	//local TTile UnitTile;
	//local TTile RootTile;
	//local int i;
	//local bool FoundTile;
//
	//History = `XCOMHISTORY;
	//Rules = `TACTICALRULES;
//
	//PlayerState = class'Utilities_LW'.static.FindPlayer(eTeam_XCom);
	//BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
//
	//if (SpawnNearObjective)
	//{
		//`XWORLD.GetFloorTileForPosition(BattleData.MapData.ObjectiveLocation, RootTile);
	//}
	//else
	//{
		//`XWORLD.GetFloorTileForPosition(BattleData.MapData.SoldierSpawnLocation, RootTile);
	//}
//
	//for (i = 0; i < Outpost.ResistanceMecs.Length; ++i)
	//{
		//if (i >= default.MecCap)
			//break;
//
		//// Find a spawn tile near our root (spawn or objective, depending on mission)
		//UnitTile = RootTile;
		//FoundTile = class'Utilities_LW'.static.GetSpawnTileNearTile(UnitTile, 2, 4);
//
		//if (FoundTile)
		//{
			//NewGameStateContext = class'XComGameStateContext_TacticalGameRule'.static.BuildContextFromGameRule(eGameRule_UnitAdded);
			//NewGameState = History.CreateNewGameState(true, NewGameStateContext);
//
			//// Create a proxy for the mec. We need this because the mecs were not added to the start state of the mission, so their inventory
			//// can't be found by the visualizer. We need to create a new unit/inventory proxy for use during the mission.
			//Unit = XComGameState_Unit(History.GetGameStateForObjectID(Outpost.ResistanceMecs[i].Unit.ObjectID));
			//ProxyUnit = class'Utilities_LW'.static.CreateProxyUnit(Unit, 'ResistanceMEC', true, NewGameState, 'ResistanceMecM1_Loadout');
			//NewGameState.AddStateObject(ProxyUnit);
			//ProxyUnit.SetVisibilityLocation(UnitTile);
			//ProxyUnit.SetControllingPlayer(PlayerState.GetReference());
			//NewOutpost = XComGameState_LWOutpost(NewGameState.CreateStateObject(class'XComGameState_LWOutpost', Outpost.ObjectID));
			//NewGameState.AddStateObject(NewOutpost);
			//NewOutpost.SetMecProxy(Unit.GetReference(), ProxyUnit.GetReference());
			//NewOutpost.SetMecOnMission(Unit.GetReference());
			//// submit it
			//XComGameStateContext_TacticalGameRule(NewGameState.GetContext()).UnitRef = ProxyUnit.GetReference();
			//`TACTICALRULES.SubmitGameState(NewGameState);
//
			 //// make sure the visualizer has been created so self-applied abilities have a target in the world
			//ProxyUnit.FindOrCreateVisualizer(NewGameState);
//
			//// add abilities
			//// Must happen after unit is submitted, or it gets confused about when the unit is in play or not 
			//NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Adding Resistance MEC Unit Abilities");
			//ProxyUnit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', ProxyUnit.ObjectID));
			//NewGameState.AddStateObject(ProxyUnit);
//
			//// add the items to the gamestate for ammo merging
			//foreach ProxyUnit.InventoryItems(ItemReference)
			//{
				//ItemState = XComGameState_Item(NewGameState.CreateStateObject(class'XComGameState_Item', ItemReference.ObjectID));
				//NewGameState.AddStateObject(ItemState);
			//}
//
			//Rules.InitializeUnitAbilities(NewGameState, ProxyUnit);
//
			//`TACTICALRULES.SubmitGameState(NewGameState);
			//ProxyUnit.OnBeginTacticalPlay();
		//}
	//}
//}
//
//static function LoadRebelsForRebelRaid(XComGameState_MissionSite Mission)
//{
	//local XComGameState_MissionSiteRebelRaid_LW RebelRaidMission;
//
	//if (Mission != none)
	//{
		//RebelRaidMission = XComGameState_MissionSiteRebelRaid_LW(Mission);
		//RebelRaidMission.LoadRebels();
	//}
//}
//
//static function LoadLiaisonFromOutpost(XComGameState_LWOutpost Outpost, 
								//ETeam Team,
								//optional bool SpawnAtObjective = false)
//{
	//local XComGameStateHistory History;
	//local X2TacticalGameRuleset Rules;
	//local XComGameState_Player PlayerState;
	//local XComGameStateContext_TacticalGameRule NewGameStateContext;
	//local XComGameState NewGameState;
	//local XComGameState_Unit Unit;
	//local TTile UnitTile;
	//local StateObjectReference ItemReference;
	//local XComGameState_Item ItemState;
	//local XComGameState_BattleData BattleData;
	//local bool FoundTile;
//
	//if (!Outpost.HasLiaison())
	//{
		//return;
	//}
//
	//Rules = `TACTICALRULES;
	//History = `XCOMHISTORY;
//
	//Unit = XComGameState_Unit(History.GetGameStateForObjectID(Outpost.GetLiaison().ObjectID));
	//BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
//
	//// If we are requested to spawn at the objective, do so. Otherwise, if the adviser
	//// is on XCOM's team it'll start with the squad, and if it's not it'll spawn
	//// at a random location.
	//if (SpawnAtObjective)
	//{
		//`XWORLD.GetFloorTileForPosition(BattleData.MapData.ObjectiveLocation, UnitTile);
		//FoundTile = class'Utilities_LW'.static.GetSpawnTileNearTile(UnitTile, 2, 4);
	//}
	//else if (Team == eTeam_XCom)
	//{
		//`XWORLD.GetFloorTileForPosition(BattleData.MapData.SoldierSpawnLocation, UnitTile);
		//FoundTile = class'Utilities_LW'.static.GetSpawnTileNearTile(UnitTile, 2, 4);
	//}
	//else
	//{
		//FoundTile = GetTileForCivilian(0, UnitTile);
	//}
//
	//if (FoundTile)
	//{
		//NewGameStateContext = class'XComGameStateContext_TacticalGameRule'.static.BuildContextFromGameRule(eGameRule_UnitAdded);
		//NewGameState = History.CreateNewGameState(true, NewGameStateContext);
		//Unit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', Unit.ObjectID));
		//NewGameState.AddStateObject(Unit);
//
		//PlayerState = class'Utilities_LW'.static.FindPlayer(Team);
		//// If the adviser is not a soldier, we want it to start on the neutral team.
		//if (!Unit.IsASoldier())
		//{
			//// Work around a problem introduced with the SLG DLC. See the big comment in X2Character_Resistance.EmptyPawnName
			//// about why we use an empty pawn name override for rebel/faceless rebel characters. Unfortunately the engineer and
			//// scientist templates don't have such an override set, so when they have their pictures taken for the adviser slot
			//// in the resistance UI the code introduced in SLG sets their pawn to 'soldier'. This causes them to use the wrong 
			//// anims and hold empty guns in mission. The fix is to force their pawn name back to '' before their visualizer is
			//// created, which works for the same reason as described in EmptyPawnName().
			//Unit.kAppearance.nmPawn = '';
		//}
//
		//Unit.SetControllingPlayer(PlayerState.GetReference());
		//// Set the 'spawned from avenger' flag on soldier liaisons. The post-mission cleanup code needs it needs to handle
		//// someone who isn't in the squad. This will make sure they get recorded in the memorial if they die, and handles
		//// captures, shaken effects, etc.
		//if (Unit.IsASoldier())
		//{
			//Unit.bSpawnedFromAvenger = true;
		//}
		//Unit.SetVisibilityLocation(UnitTile);
//
		//foreach Unit.InventoryItems(ItemReference)
		//{
			//ItemState = XComGameState_Item(NewGameState.CreateStateObject(class'XComGameState_Item', ItemReference.ObjectID));
			//NewGameState.AddStateObject(ItemState);
//
			//// add any cosmetic items that might exists
			//ItemState.CreateCosmeticItemUnit(NewGameState);
		//}
//
		//// submit it
		//XComGameStateContext_TacticalGameRule(NewGameState.GetContext()).UnitRef = Unit.GetReference();
		//`TACTICALRULES.SubmitGameState(NewGameState);
//
		 //// make sure the visualizer has been created so self-applied abilities have a target in the world
	   //Unit.FindOrCreateVisualizer(NewGameState);
//
		//// add abilities
		//// Must happen after unit is submitted, or it gets confused about when the unit is in play or not 
		//NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Adding Liaison Unit Abilities");
		//Unit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', Unit.ObjectID));
		//NewGameState.AddStateObject(Unit);
		//// add the items to the gamestate for ammo merging
		//foreach Unit.InventoryItems(ItemReference)
		//{
			//ItemState = XComGameState_Item(NewGameState.CreateStateObject(class'XComGameState_Item', ItemReference.ObjectID));
			//NewGameState.AddStateObject(ItemState);
		//}
		//Rules.InitializeUnitAbilities(NewGameState, Unit);
//
		//// make the unit concealed, if they have Phantom
		//// (special-case code, but this is how it works when starting a game normally)
		//if (Unit.FindAbility('Phantom').ObjectID > 0)
		//{
			//Unit.EnterConcealmentNewGameState(NewGameState);
		//}
//
		//`TACTICALRULES.SubmitGameState(NewGameState);
		//Unit.OnBeginTacticalPlay();
	//}
//}
//
//static function CreateNewCivilianUnits()
//{
	//local name CharacterTemplateName;
	//local StateObjectReference NewUnitRef;
	//local XComAISpawnManager SpawnManager;
	//local UIUnitFlag UnitFlag;
	//local int i;
//
	//SpawnManager = `SPAWNMGR;
//
	//for (i = 0; i < 13; ++i)
	//{
		//CharacterTemplateName = `SYNC_RAND_STATIC(10) == 0 ? 'FacelessRebel' : 'Rebel';
		//NewUnitRef = SpawnManager.CreateUnit(GetPositionForCivilian(i), 
											//CharacterTemplateName, 
											//eTeam_Neutral, 
											//false,
											//false);
		//UnitFlag = `PRES.m_kUnitFlagManager.GetFlagForObjectID(NewUnitRef.ObjectID);
		//UnitFlag.Hide();
		//`PRES.m_kUnitFlagManager.RemoveFlag(UnitFlag);
		//UnitFlag.Destroy();
	//}
//}
//
//// For the recruit raid mission, we need to override the globally disabled evac ability
//// on all rebel units.
//static function GiveEvacAbilityToRebels()
//{
	//local XComGameState_Unit Unit;
	//local XComGameStateHistory History;
	//local XComGameState NewGameState;
	//local XComGameState_Unit NewUnit;
//
	//History = `XCOMHISTORY;
	//NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Enable Evac on Rebels");
//
	//foreach History.IterateByClassType(class'XComGameState_Unit', Unit)
	//{
		//if (Unit.GetMyTemplateName() == 'Rebel')
		//{
			//NewUnit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', Unit.ObjectID));
			//NewUnit.EnableGlobalAbilityForUnit('Evac');
			//NewGameState.AddStateObject(NewUnit);
		//}
	//}
//
	//if (NewGameState.GetNumGameStateObjects() > 0)
	//{
		//`TACTICALRULES.SubmitGameState(NewGameState);
	//}
	//else
	//{
		//History.CleanupPendingGameState(NewGameState);
	//}
//}
//
//static function Vector GetPositionForCivilian(int i)
//{
	//local EncounterZone MyEncounterZone;
	//local XComAISpawnManager SpawnManager;
	//local XComTacticalMissionManager MissionManager;
	//local MissionSchedule ActiveMissionSchedule;
	//local XComGameStateHistory History;
	//local float MyEncounterZoneDepth;
	//local XComGameState_BattleData BattleData;
	//local Vector XComLocation;
	//local Vector SpawnPosition;
//
	//SpawnManager = `SPAWNMGR;
	//MissionManager = `TACTICALMISSIONMGR;
	//History = `XCOMHISTORY;
//
	//MissionManager.GetActiveMissionSchedule(ActiveMissionSchedule);
	//BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
//
	//XComLocation = SpawnManager.GetCurrentXComLocation();
	//MyEncounterZoneDepth = ActiveMissionSchedule.EncounterZonePatrolDepth;
//
	//if (i >= default.arrEncounterZoneWidths.Length)
	//{
		//i = i % default.arrEncounterZoneWidths.Length;
	//}
//
	//if (i >= default.arrEncounterZoneOffsetsAlongLOP.Length)
	//{
		//i = i % default.arrEncounterZoneOffsetsAlongLOP.Length;
	//}
//
	//MyEncounterZone = SpawnManager.BuildEncounterZone(
		//BattleData.MapData.ObjectiveLocation,
		//XComLocation,
		//MyEncounterZoneDepth,
		//default.arrEncounterZoneWidths[i],
		///*MyEncounterZoneOffsetFromLOP*/ 0.0f,
		//default.arrEncounterZoneOffsetsAlongLOP[i]);
//
	//// Choose a random position within the encounter zone bounding box.
	//SpawnPosition = class'XComAISpawnmanager'.static.CastVector(MyEncounterZone.Origin);
	//SpawnPosition.X += `SYNC_RAND_STATIC(int(MyEncounterZone.SideA.X) - int(MyEncounterZone.Origin.X));
	//SpawnPosition.Y += `SYNC_RAND_STATIC(int(MyEncounterZone.SideB.Y) - int(MyEncounterZone.Origin.Y));
	//return SpawnPosition;
//}
//
//static function bool GetTileForCivilian(int i, out TTile UnitTile)
//{
	//local XComWorldData WorldData;
	//local Vector Position;
	//local int j;
//
	//WorldData = `XWORLD;
//
	//for (j = 0; j < default.arrEncounterZoneWidths.Length; ++j)
	//{
		//Position = GetPositionForCivilian(i + j);
		//WorldData.GetFloorTileForPosition(Position, UnitTile);
		//if (class'Utilities_LW'.static.GetSpawnTileNearTile(UnitTile, 3, 9))
		//{
			//return true;
		//}
	//}
//
	//if (j == default.arrEncounterZoneWidths.Length)
	//{
		//`redscreen("Failed to find a valid position for civilian " $ i $ " in any encounter zone!");
		//return false;
	//}
//}

static function bool FindSpawnTile(out TTile SpawnLocation)
{
	local XComGroupSpawn SoldierSpawn;
	local array<Vector> FloorPoints;
	local XComWorldData World;

	World = `XWORLD;

	foreach `XComGRI.AllActors(class'XComGroupSpawn', SoldierSpawn)
	{
		FloorPoints.Length = 0;
		SoldierSpawn.GetValidFloorLocations(FloorPoints);
		if(FloorPoints.Length > 0)
		{
			World.GetFloorTileForPosition(FloorPoints[0], SpawnLocation);
			if (!IsVisibleToAI(SpawnLocation))
				return true;
		}
	}

	`Redscreen("Failed to find a valid spawn tile");
	return false;

}
