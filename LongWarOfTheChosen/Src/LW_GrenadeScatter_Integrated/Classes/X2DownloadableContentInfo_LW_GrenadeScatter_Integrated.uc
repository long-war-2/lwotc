class X2DownloadableContentInfo_LW_GrenadeScatter_Integrated extends X2DownloadableContentInfo;

//var config bool bDisableCinematicCam;
var config(Scatter) bool bLog;
var config(Scatter) bool bDisplayScatterText;
var config(Scatter) bool bDisplayScatterCircles;

struct ScatterStruct
{
	var float MissScatter;
	var float HitScatter;
	var float MinScatter;
	var bool IgnoreSoldierAim;		//	If this is true, soldier's Aim will not count towards Effective Aim.
	var bool SkipScatterAimAdjust;	//	If this is true, scatter values will not be adjusted based on Effective Aim.
	var array<int> RangeTable;
	var name AbilityName;
	var name WeaponName;
	var name ItemCat;
	var name WeaponCat;
	var bool OnlyAfterMove;
	var bool CosmeticScatter;	//	If this is true, this ability will DISPLAY scatter, but will not actually scatter. Necessary for multi stage abilities.
	var bool bRemoveCinematicCam;

	var bool OverrideExistingModifyContextFn;	//	deprecated.
	structdefaultproperties
	{
		bRemoveCinematicCam = true
	}
};
var config(Scatter) array<ScatterStruct> SCATTER;

struct ScatterAbilityStruct
{
	var name	AbilityName;
	var array<name> AffectAbilities;
	var float	MissScatterAdjust;
	var float	HitScatterAdjust;
	var int		AimAdjust;
	var bool	SearchInventory;
};
var config(Scatter) array<ScatterAbilityStruct> SCATTER_ABILITY;

var config(Scatter) array<name> EXCLUDE_WEAPON;

static final simulated function GrenadeScatter_ModifyActivatedAbilityContext(XComGameStateContext Context)
{
	local XComGameState_Unit			UnitState;
	local XComGameState_Ability			AbilityState;
	local XComGameStateContext_Ability	AbilityContext;
	local XComGameStateHistory			History;
	local vector						NewLocation;
	local XComWorldData					World;
	local float							ScatterAmount;
	local AvailableTarget				Target;
	local int							bHit;
	local TTile							TileLocation;

	History = `XCOMHISTORY;
	
	AbilityContext = XComGameStateContext_Ability(Context);
	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));

	`LOG("Mofying context for: " @ AbilityState.GetMyTemplateName() @ " cast by: "@ UnitState.GetFullName(), default.bLog, 'IRI_Scatter');

	World = `XWORLD;
	NewLocation = AbilityContext.InputContext.TargetLocations[0];
	
	if (GetScatterAmount(AbilityState, UnitState, NewLocation, ScatterAmount, bHit))
	{
		`LOG("Original hit loc: " @ NewLocation @ "Num multi targets:" @ AbilityContext.InputContext.MultiTargets.Length @ "multi hit results:" @ AbilityContext.ResultContext.MultiTargetHitResults.Length @ "scatter, tiles: " @ ScatterAmount, default.bLog, 'IRI_Scatter');

		ScatterAmount = class'XComWorldData'.const.WORLD_StepSize * ScatterAmount;

		`LOG("Scatter, units: " @ ScatterAmount, default.bLog, 'IRI_Scatter');

		NewLocation.X += `SYNC_RAND_STATIC(int(ScatterAmount * 2)) - ScatterAmount;
		NewLocation.Y += `SYNC_RAND_STATIC(int(ScatterAmount * 2)) - ScatterAmount;
		NewLocation.Z += `SYNC_RAND_STATIC(int(ScatterAmount));

		`LOG("New hit loc: " @ NewLocation, default.bLog, 'IRI_Scatter');

		//	Prevents from targeting off-map locations
		TileLocation = World.GetTileCoordinatesFromPosition(NewLocation);
		if (World.IsTileOutOfRange(TileLocation))
		{
			NewLocation = World.FindClosestValidLocation(NewLocation, false, false);
			`LOG("Scatter tile is out of bounds, new valid hit loc: " @ NewLocation, default.bLog, 'IRI_Scatter');
		}
		
		if (AbilityState.GetMyTemplate().TargetingMethod.static.UseGrenadePath())
		{
			`LOG("Ability uses grenade path, scatter to floor", default.bLog, 'IRI_Scatter');
			NewLocation.Z = World.GetFloorZForPosition(NewLocation);
		}
		else
		{
			`LOG("Ability uses direct projectiles, get optimal Z.", default.bLog, 'IRI_Scatter');
			GetOptimalZ(NewLocation, World);
		}

		AbilityState.GatherAdditionalAbilityTargetsForLocation(NewLocation, Target);
		AbilityContext.InputContext.MultiTargets = Target.AdditionalTargets;

		AbilityContext.InputContext.TargetLocations.Length = 0;
		AbilityContext.InputContext.TargetLocations.AddItem(NewLocation);

		AbilityContext.ResultContext.ProjectileHitLocations.Length = 0;
		AbilityContext.ResultContext.ProjectileHitLocations.AddItem(NewLocation);

		// To Hit Calc is done before this function runs, so we have to re-roll multi target hit results.
		if (AbilityState.GetMyTemplate().AbilityToHitCalc != none)
		{
			AbilityContext.ResultContext.MultiTargetHitResults.Length = 0;
			AbilityState.GetMyTemplate().AbilityToHitCalc.RollForAbilityHit(AbilityState, Target, AbilityContext.ResultContext);
		}

		`LOG("Final hit loc: " @ NewLocation @ "new multi targets:" @ AbilityContext.InputContext.MultiTargets.Length @ "new multi hit results:" @ AbilityContext.ResultContext.MultiTargetHitResults.Length, default.bLog, 'IRI_Scatter');

		if (bHit > 0) AbilityContext.PostBuildVisualizationFn.AddItem(ScatterHit_PostBuildVisualization);
		else AbilityContext.PostBuildVisualizationFn.AddItem(ScatterMiss_PostBuildVisualization);
	}
}

//	Change the Z-point the projectile hits based on if the targeted tile has some sort of object in it.
static final function GetOptimalZ(out vector ScatteredTargetLoc, XComWorldData World)
{
	local TTile							TileLocation;
	local array<StateObjectReference>	TargetsOnTile;
	local XComGameState_Unit			TargetUnit;

	`LOG("Running:" @ GetFuncName() @ "for original scatter location:", default.bLog, 'IRI_Scatter');
	`LOG(ScatteredTargetLoc, default.bLog, 'IRI_Scatter');

	ScatteredTargetLoc.Z = World.GetFloorZForPosition(ScatteredTargetLoc);

	`LOG("Lowered Z to the floor:", default.bLog, 'IRI_Scatter');
	`LOG(ScatteredTargetLoc, default.bLog, 'IRI_Scatter');

	//	Check if there are any units on targeted tile, and grab a unit state for the first of them.
	TileLocation = World.GetTileCoordinatesFromPosition(ScatteredTargetLoc);
	TargetsOnTile = World.GetUnitsOnTile(TileLocation);
	if (TargetsOnTile.Length > 0)
	{
		TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(TargetsOnTile[0].ObjectID));
		if (TargetUnit != none)
		{
			//	If there is a unit, the rocket hits a random point on the upper part of the target's vertical profile.
			ScatteredTargetLoc.Z += TargetUnit.UnitHeight * (class'XComWorldData'.const.WORLD_FloorHeight - class'XComWorldData'.const.WORLD_HalfFloorHeight * `SYNC_FRAND_STATIC());

			`LOG("There's a unit on tile, raising Z:" @ TargetUnit.GetFullName() @ "Unit height:" @ TargetUnit.UnitHeight, default.bLog, 'IRI_Scatter');
			`LOG(ScatteredTargetLoc, default.bLog, 'IRI_Scatter');
		}
	}
	else if (World.IsTileFullyOccupied(TileLocation)) // Tile contains an object
	{	
		ScatteredTargetLoc.Z += class'XComWorldData'.const.WORLD_HalfFloorHeight + class'XComWorldData'.const.WORLD_HalfFloorHeight * `SYNC_FRAND_STATIC();

		`LOG("Tile is fully occupied, raising Z:", default.bLog, 'IRI_Scatter');
		`LOG(ScatteredTargetLoc, default.bLog, 'IRI_Scatter');
	}
}

static function ScatterHit_PostBuildVisualization(XComGameState VisualizeGameState)
{
	Scatter_PostBuildVisualization(VisualizeGameState, true);
}

static function ScatterMiss_PostBuildVisualization(XComGameState VisualizeGameState)
{
	Scatter_PostBuildVisualization(VisualizeGameState, false);
}

static private function Scatter_PostBuildVisualization(XComGameState VisualizeGameState, bool bHit)
{
	local VisualizationActionMetadata	ActionMetadata;
	local XComGameStateHistory			History;
	local XComGameStateVisualizationMgr VisMgr;
	local X2Action_PlaySoundAndFlyOver	FlyOverAction;

	local XComGameStateContext_Ability	Context;
	local XComGameState_Ability			AbilityState;
	local XComGameState_Unit			UnitState;
	local X2Action						FindAction;
	local array<X2Action>				FoundActions;
	local X2Action_MarkerNamed			ReplaceAction;
	local ScatterStruct ScatterParams;

	History = `XCOMHISTORY;
	VisMgr = `XCOMVISUALIZATIONMGR;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(Context.InputContext.AbilityRef.ObjectID));
	UnitState = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(Context.InputContext.SourceObject.ObjectID));
	ActionMetadata.VisualizeActor = History.GetVisualizer(Context.InputContext.SourceObject.ObjectID);
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(UnitState.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = UnitState;

	if (GetScatterParams(AbilityState, UnitState, ScatterParams))
	{
		//	Replace any Cinescript Camera Actions associated with the ability shooter with dummy stubs.
		if (ScatterParams.bRemoveCinematicCam)
		{
			VisMgr.GetNodesOfType(VisMgr.BuildVisTree, class'X2Action_StartCinescriptCamera', FoundActions, , Context.InputContext.SourceObject.ObjectID);
			foreach FoundActions(FindAction)
			{
				ReplaceAction = X2Action_MarkerNamed(class'X2Action'.static.CreateVisualizationActionClass(class'X2Action_MarkerNamed', Context));
				ReplaceAction.SetName("ReplaceCinescriptCameraAction");
				VisMgr.ReplaceNode(ReplaceAction, FindAction);			
			}
			VisMgr.GetNodesOfType(VisMgr.BuildVisTree, class'X2Action_EndCinescriptCamera', FoundActions, , Context.InputContext.SourceObject.ObjectID);
			foreach FoundActions(FindAction)
			{
				ReplaceAction = X2Action_MarkerNamed(class'X2Action'.static.CreateVisualizationActionClass(class'X2Action_MarkerNamed', Context));
				ReplaceAction.SetName("ReplaceCinescriptCameraAction");
				VisMgr.ReplaceNode(ReplaceAction, FindAction);			
			}
		}
	}

	//	Try to put the Flyover Action right after Fire Action, if it exists. If not, let it autoparent.
	FindAction = VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_Fire', ActionMetadata.VisualizeActor, Context.InputContext.SourceObject.ObjectID);
	if (FindAction != none)
	{
		FlyOverAction = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, FindAction));
	}
	else
	{
		FlyOverAction = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext()));
	}

	if (bHit)
	{
		FlyOverAction.SetSoundAndFlyOverParameters(None, class'X2TacticalGameRulesetDataStructures'.default.m_aAbilityHitResultStrings[eHit_Success], '', eColor_Good, AbilityState.GetMyIconImage());
	}
	else
	{
		FlyOverAction.SetSoundAndFlyOverParameters(None, class'X2TacticalGameRulesetDataStructures'.default.m_aAbilityHitResultStrings[eHit_Miss], '', eColor_Bad, AbilityState.GetMyIconImage());
	}

	//`LOG("========= TREE AFTER ===============");
	//PrintActionRecursive(VisMgr.BuildVisTree, 0);
	//`LOG("-------------------------------------");
}

static private function PrintActionRecursive(X2Action Action, int iLayer)
{
	local X2Action ChildAction;

	`LOG("Action layer: " @ iLayer @ ": " @ Action.Class.Name,, 'IRIPISTOLVIZ'); 
	foreach Action.ChildActions(ChildAction)
	{
		PrintActionRecursive(ChildAction, iLayer + 1);
	}
}

static private function int TileDistanceBetween(const XComGameState_Unit Unit, const vector TargetLoc)
{
    local XComWorldData WorldData;
    local vector UnitLoc;
    local float Dist;
    local int Tiles;

    WorldData = `XWORLD;
    UnitLoc = WorldData.GetPositionFromTileCoordinates(Unit.TileLocation);
    Dist = VSize(UnitLoc - TargetLoc);
    Tiles = Dist / WorldData.WORLD_StepSize;
    return Tiles;
}

static private function bool GetScatterAmount(const XComGameState_Ability AbilityState, const XComGameState_Unit UnitState, const vector TargetLoc, out float ScatterAmount, out int bHit)
{
	local float			EffectiveAim;
	local int			RandRoll;
	local ScatterStruct ScatterParams;

	//	Get Range Table, Base Scatter, Minimum Scatter.
	if (GetScatterParamsForEffectiveAim(AbilityState, UnitState, TargetLoc, ScatterParams, EffectiveAim))
	{
		//	Perform Hit / Miss Roll
		RandRoll = `SYNC_RAND_STATIC(101);
		`LOG("Performing Hit/Miss Check, EffectiveAim: " @ EffectiveAim @ "RandRoll:" @ RandRoll, default.bLog, 'IRI_Scatter');
		if (EffectiveAim > RandRoll)
		{
			//	Hit
			`LOG("This is a hit, Minimum Scatter:" @ ScatterParams.HitScatter, default.bLog, 'IRI_Scatter');
			bHit = 1;
			ScatterAmount = ScatterParams.HitScatter;
		}
		else
		{
			//	Miss
			`LOG("This is a miss, Maximum Scatter:" @ ScatterParams.MissScatter, default.bLog, 'IRI_Scatter');
			bHit = 0;
			ScatterAmount = ScatterParams.MissScatter;
		}
		return true;
	}
	else
	{
		`redscreen("GrenadeScatter -> WARNING! Ability: " @ AbilityState.GetMyTemplateName() @ "has no configuration! -Iridar");
		`LOG("WARNING! Ability: " @ AbilityState.GetMyTemplateName() @ "has no configuration!",, 'IRI_Scatter');
		return false;
	}
}

static public function bool GetScatterParamsForEffectiveAim(const XComGameState_Ability AbilityState, const XComGameState_Unit UnitState, const vector TargetLoc, out ScatterStruct ScatterParams, out float EffectiveAim)
{
	local ScatterAbilityStruct	ScatterAbility;
	local float					RangeTableModifier;

	if (GetScatterParams(AbilityState, UnitState, ScatterParams))
	{
		//	Pring a Warning if the Range Table is empty.
		if (ScatterParams.RangeTable.Length == 0)
		{
			`redscreen("GrenadeScatter -> WARNING! Ability: " @ AbilityState.GetMyTemplateName() @ "has no range table! -Iridar");
			`LOG("WARNING! Ability: " @ AbilityState.GetMyTemplateName() @ "has no range table!",, 'IRI_Scatter');
		}

		EffectiveAim = GetEffectiveAim(UnitState, TargetLoc, ScatterParams, RangeTableModifier);

		//	## Abilities that improve Scatter - START
		foreach default.SCATTER_ABILITY(ScatterAbility)
		{
			if (UnitState.HasSoldierAbility(ScatterAbility.AbilityName, ScatterAbility.SearchInventory))
			{
				//	If this scatter-improving ability is not configured to affect only specific abilties, or this ability is in the configured list of affected abilities
				if (ScatterAbility.AffectAbilities.Length == 0 || ScatterAbility.AffectAbilities.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
				{
					ScatterParams.MissScatter += ScatterAbility.MissScatterAdjust;
					ScatterParams.HitScatter += ScatterAbility.HitScatterAdjust;
					EffectiveAim += ScatterAbility.AimAdjust;
				}
			}
		}
		//	## Abilities that improve Scatter - END

		//	Adjust Scatter for Range Table
		if (!ScatterParams.SkipScatterAimAdjust)
		{
			RangeTableModifier = RangeTableModifier / 100;
			ScatterParams.HitScatter = ScatterParams.HitScatter - ScatterParams.HitScatter * RangeTableModifier;
			ScatterParams.MissScatter = ScatterParams.MissScatter - ScatterParams.HitScatter * RangeTableModifier;	//	Not a typo, we modify Miss Scatter by Hit Scatter
		}

		//	Clamp the Aim value between 0 and 100, so it can be properly used by UI and Hit Rolls
		if (EffectiveAim > 100) 
		{
			//	Start reducing Hit Scatter based on Effective Aim.
			`LOG("Modifying Hit Scatter: " @ ScatterParams.HitScatter @ "by: " @ (1 + (100 - EffectiveAim) / 100) @ "result: " @ ScatterParams.HitScatter * (1 + (100 - EffectiveAim) / 100), default.bLog, 'IRI_Scatter');
			ScatterParams.HitScatter *= 1 + (100 - EffectiveAim) / 100;

			//	We can never lose the scatter roll.
			ScatterParams.MissScatter = ScatterParams.HitScatter;

			EffectiveAim = 100;
		}
		if (EffectiveAim < 0) 
		{
			//	Start increasing Min Scatter based on Effective Aim.
			`LOG("Modifying Miss Scatter: " @ ScatterParams.MissScatter @ "by: " @ (100 - EffectiveAim) / 100 @ "result: " @ ScatterParams.MissScatter * (100 - EffectiveAim) / 100, default.bLog, 'IRI_Scatter');
			ScatterParams.MissScatter *= (100 - EffectiveAim) / 100;

			//	We can never win the scatter roll.
			ScatterParams.HitScatter = ScatterParams.MissScatter;

			EffectiveAim = 0;
		}

		//	 Ensure both final scatter values are not smaller than MinScatter
		if (ScatterParams.MissScatter < ScatterParams.MinScatter) ScatterParams.MissScatter = ScatterParams.MinScatter;
		if (ScatterParams.HitScatter < ScatterParams.MinScatter) ScatterParams.HitScatter = ScatterParams.MinScatter;

		return true;

	}
	else return false;
}

static private function bool GetScatterParams(const XComGameState_Ability AbilityState, const XComGameState_Unit UnitState, out ScatterStruct ScatterParams)
{
	local array<ScatterStruct>	AllScatterStructs;

	local name					AbilityName;
	local name					WeaponName;
	local name					AmmoName;
	local XComGameState_Item	SourceWeapon;
	local XComGameState_Item	SourceAmmo;
	local name					ItemCat;
	local name					WeaponCat;
	local name					AmmoWeaponCat;
	local name					AmmoItemCat;
	local X2WeaponTemplate		WeaponTemplate;
	local bool					UnitMoved;
	local int i;

	
	AbilityName = AbilityState.GetMyTemplateName();

	SourceWeapon = AbilityState.GetSourceWeapon();
	if (SourceWeapon != none)
	{
		WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
		if (WeaponTemplate != none)
		{
			WeaponName = WeaponTemplate.DataName;

			if (default.EXCLUDE_WEAPON.Find(WeaponName) != INDEX_NONE) return false;

			WeaponCat = WeaponTemplate.WeaponCat;
		}
		//	Don't need to be a weapon template to have Item Cat
		ItemCat = SourceWeapon.GetMyTemplate().ItemCat;
	}

	//	If this is a grenade launcher launching a grenade, then the Loaded Ammo will be the grenade.
	//	If this is a regular rifle firing with Dragon Rounds, then the Loaded Ammo will be special rounds. 
	SourceAmmo = AbilityState.GetSourceAmmo();
	if (SourceAmmo != none)
	{
		AmmoName = SourceAmmo.GetMyTemplateName();
		AmmoItemCat = SourceAmmo.GetMyTemplate().ItemCat;
		AmmoWeaponCat = SourceAmmo.GetWeaponCategory();

		if (default.EXCLUDE_WEAPON.Find(AmmoName) != INDEX_NONE) return false;
	}

	UnitMoved = DidUnitMoveThisTurn(UnitState);

	//	Filter out scatter entries that don't concern this ability/weapon combination.
	AllScatterStructs = default.SCATTER;
	for (i = AllScatterStructs.Length - 1; i >= 0; i--)
	{
		if (AllScatterStructs[i].AbilityName != '' && AllScatterStructs[i].AbilityName != AbilityName)
		{
			`LOG("Removing entry. AbilityName mismatch:" @ AllScatterStructs[i].AbilityName @ "vs" @ AbilityName, default.bLog, 'IRI_Scatter');
			AllScatterStructs.Remove(i, 1);
			continue;
		}

		if (AllScatterStructs[i].ItemCat != '' && AllScatterStructs[i].ItemCat != ItemCat && AllScatterStructs[i].ItemCat != AmmoItemCat)
		{
			`LOG("Removing entry. ItemCat mismatch:" @ AllScatterStructs[i].ItemCat @ "vs" @ ItemCat, default.bLog, 'IRI_Scatter');
			AllScatterStructs.Remove(i, 1);
			continue;
		}

		//	Technically, ammo can have abilities as well, so whenever we compare the weapon, compare the ammo as well.
		if (AllScatterStructs[i].WeaponName != '' && AllScatterStructs[i].WeaponName != WeaponName && AllScatterStructs[i].WeaponName != AmmoName)
		{
			`LOG("Removing entry. WeaponName mismatch:" @ AllScatterStructs[i].WeaponName @ "vs" @ WeaponName, default.bLog, 'IRI_Scatter');
			AllScatterStructs.Remove(i, 1);
			continue;
		}
		if (AllScatterStructs[i].WeaponCat != '' && AllScatterStructs[i].WeaponCat != WeaponCat && AllScatterStructs[i].WeaponCat != AmmoWeaponCat)
		{
			`LOG("Removing entry. WeaponCat mismatch:" @ AllScatterStructs[i].WeaponCat @ "vs" @ WeaponCat, default.bLog, 'IRI_Scatter');
			AllScatterStructs.Remove(i, 1);
			continue;
		}
	}

	//	Filter out configs that should activate only if the unit has moved, and the unit did not move.
	for (i = AllScatterStructs.Length - 1; i >= 0; i--)
	{
		//	If the scatter is configured to be there only after a move, and the unit did not move, then we remove the entry.
		if (AllScatterStructs[i].OnlyAfterMove && !UnitMoved)
		{
			`LOG("Removing entry. OnlyAfterMove mismatch:" @ AllScatterStructs[i].OnlyAfterMove @ "vs !UnitMoved" @ !UnitMoved, default.bLog, 'IRI_Scatter');
			AllScatterStructs.Remove(i, 1);
			continue;
		}
	}

	//	Filter out configs that should activate if the unit did not move, and the unit did move. But only if it's not the last entry remaining,
	//	which means the move and non-move config will be the same.
	if (AllScatterStructs.Length != 1)
	{
		for (i = AllScatterStructs.Length - 1; i >= 0; i--)
		{
				//	Don't remove the non-move entry if it's the last one remaining.
			if (!AllScatterStructs[i].OnlyAfterMove && UnitMoved)
			{
				`LOG("Removing entry. OnlyAfterMove mismatch: !AllScatterStructs[i].OnlyAfterMove:" @ !AllScatterStructs[i].OnlyAfterMove @ "vs UnitMoved" @ UnitMoved, default.bLog, 'IRI_Scatter');
				AllScatterStructs.Remove(i, 1);
				continue;
			}
		}
	}

	//	Ideally we should end up with one array entry.
	if (AllScatterStructs.Length == 1)
	{
		`LOG("Found exact scatter params match.", default.bLog, 'IRI_Scatter');
		ScatterParams = AllScatterStructs[0];
		return true;
	}
	else
	{
		if (AllScatterStructs.Length > 1)
		{
			`LOG("Found more than one match.", default.bLog, 'IRI_Scatter');
			ScatterParams = AllScatterStructs[0];
			return true;
		}
		else
		{
			`LOG("Didn't find even one match.", default.bLog, 'IRI_Scatter');
		}
	}

	return false;
}

static private function int GetEffectiveAim(const XComGameState_Unit UnitState, const vector TargetLoc, const ScatterStruct ScatterParams, out float AimAdjustment)
{
	local int	EffectiveAim;
	local int	TileDistance;
	
	//	Get Soldier's Aim Stat
	if (!ScatterParams.IgnoreSoldierAim)
	{
		EffectiveAim = UnitState.GetCurrentStat(eStat_Offense);
	}
	//	Adjust it for distance to the target using the Range Table
	TileDistance = TileDistanceBetween(UnitState, TargetLoc);

	if (ScatterParams.RangeTable.Length > 0)
	{
		if (TileDistance > ScatterParams.RangeTable.Length - 1) TileDistance = ScatterParams.RangeTable.Length - 1;

		AimAdjustment = ScatterParams.RangeTable[TileDistance];
	}
	else
	{
		AimAdjustment = 0;
	}
	`LOG("TileDistance: " @ TileDistance @ ", base aim: " @ EffectiveAim @ ", aim adjust: " @ AimAdjustment @ ", effective aim: " @ EffectiveAim + AimAdjustment, default.bLog, 'IRI_Scatter');
	EffectiveAim += AimAdjustment;

	return EffectiveAim;
}

static private function bool DidUnitMoveThisTurn(const XComGameState_Unit UnitState)
{
	local UnitValue MovesThisTurn;

	UnitState.GetUnitValue('MovesThisTurn', MovesThisTurn);

	return MovesThisTurn.fValue > 0;
}

exec function CheckLocation()
{
	local TTile TileLocation;
	local vector CursoLoc;

	CursoLoc = `Cursor.GetCursorFeetLocation();

	TileLocation = `XWORLD.GetTileCoordinatesFromPosition(CursoLoc);

	class'Helpers'.static.OutputMsg("Clicked on location:" @ CursoLoc);
	class'Helpers'.static.OutputMsg("Tile:" @ TileLocation.X @ TileLocation.Y @ TileLocation.Z);

	class'Helpers'.static.OutputMsg("IsTileFullyOccupied:" @ `XWORLD.IsTileFullyOccupied(TileLocation));
	class'Helpers'.static.OutputMsg("CanUnitsEnterTile:" @ `XWORLD.CanUnitsEnterTile(TileLocation));
}