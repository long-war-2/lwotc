class X2TargetingMethod_IRI_RocketLauncher extends X2TargetingMethod_RocketLauncher config(RocketLaunchers);

var config int NUM_AIM_SCATTER_ROLLS;
var config int ONE_ACTION_SCATTER_TILE_MODIFIER;

var config array<name> SCATTER_REDUCTION_ABILITIES;
var config array<int> SCATTER_REDUCTION_MODIFIERS;

var config array<name> OFFENSE_INCREASE_ABILITIES;
var config array<int> OFFENSE_INCREASE_MODIFIERS;

var config int STEADY_TILE_MODIFIER;
var localized string strMaxScatter;

var UIScrollingTextField ScatterAmountText;

function Init(AvailableAction InAction, int NewTargetIndex)
{
    local UITacticalHUD TacticalHUD;

    super.Init(InAction, NewTargetIndex);

    TacticalHUD = UITacticalHUD(`SCREENSTACK.GetScreen(class'UITacticalHUD'));
    ScatterAmountText = TacticalHUD.Spawn(class'UIScrollingTextField', TacticalHUD);
    ScatterAmountText.bAnimateOnInit = false;
    ScatterAmountText.InitScrollingText('AverageScatterText_LW', "", 400, 0, 0);
    ScatterAmountText.SetHTMLText(class'UIUtilities_Text'.static.GetColoredText("N/A", eUIState_Bad, class'UIUtilities_Text'.const.BODY_FONT_SIZE_3D));
    ScatterAmountText.ShowShadow(0);

	////`LOG(Ability.GetMyTemplateName() @ "radius: " @ Ability.GetAbilityRadius(),, 'IRIROCK');
}

function GetTargetLocations(out array<Vector> TargetLocations)
{
	local XComWorldData					World;
    local vector						ScatteredTargetLoc;
	local TTile							TileLocation;
	local array<StateObjectReference>	TargetsOnTile;
	local XComGameState_Unit			TargetUnit;

	World = `XWORLD;

    ScatteredTargetLoc = NewTargetLocation;
	ScatteredTargetLoc = static.GetScatterAmount(UnitState, ScatteredTargetLoc);
    
	//	Added by Iridar
	//	By default, the LW2 targeting logic makes the rocket hit half a floor above the tile targeted by scatter mechanics.
	//	This piece of code will change the Z-point the rocket hits based on if the targeted tile has some sort of object in it.

	//	Check if there are any units on targeted tile, and grab a unit state for the first of them.
	
	TileLocation = World.GetTileCoordinatesFromPosition(ScatteredTargetLoc);
	TargetsOnTile = World.GetUnitsOnTile(TileLocation);
	if (TargetsOnTile.Length > 0)
	{
		TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(TargetsOnTile[0].ObjectID));
	}

	//	If there is a unit, the rocket hits a random point on the target's vertical profile, excluding the lower part of the "legs".
	if (TargetUnit != none)
	{
		ScatteredTargetLoc.Z = World.GetFloorZForPosition(ScatteredTargetLoc) + TargetUnit.UnitHeight * class'XComWorldData'.const.WORLD_HalfFloorHeight + `SYNC_FRAND() * (TargetUnit.UnitHeight - 1) * class'XComWorldData'.const.WORLD_FloorHeight;
	}
	else
	{
		//	if there are no units, we check if there's an object or a piece of cover on the tile.
		if (!World.IsTileOccupied(TileLocation) && !World.IsLocationHighCover(ScatteredTargetLoc))
		{	
			// if there aren't, it basically means there's naked floor in there, so we make the rocket hit the floor
			ScatteredTargetLoc.Z = World.GetFloorZForPosition(ScatteredTargetLoc);
		}
	}
	//	Otherwise, the rocket uses the default logic and hits somewhere above the targeted tile.

	// End of added

	NewTargetLocation = ScatteredTargetLoc;
	TargetLocations.Length = 0;
    TargetLocations.AddItem(ScatteredTargetLoc);
}

function int GetOptimalZForTile(const vector VectorLocation)
{
	local XComWorldData					World;
	local TTile							TileLocation;
	local array<StateObjectReference>	TargetsOnTile;

	World = `XWORLD;

	TileLocation = World.GetTileCoordinatesFromPosition(VectorLocation);
	TargetsOnTile = World.GetUnitsOnTile(TileLocation);

	//	If there's a unit on the tile, or the tile contains a high cover object
	if (TargetsOnTile.Length > 0 || World.IsLocationHighCover(VectorLocation))
	{
		//	then we aim at a point a floor above the tile (around soldier's waist-chest level)
		return World.GetFloorZForPosition(VectorLocation) + class'XComWorldData'.const.WORLD_FloorHeight;
	}
	else
	{
		//	if the tile contains low cover object, then we aim slightly above the floor
		if (World.IsLocationLowCover(VectorLocation))
		{
			return class'XComWorldData'.const.WORLD_HalfFloorHeight;
		}
		else
		{
			//	otherwise we aim at floor
			return World.GetFloorZForPosition(VectorLocation);
		}
	}
}

function bool GetAdditionalTargets(out AvailableTarget AdditionalTargets)
{
    Ability.GatherAdditionalAbilityTargetsForLocation(NewTargetLocation, AdditionalTargets);
    return true;
}

function Update(float DeltaTime)
{
    local XComWorldData World;
    local VoxelRaytraceCheckResult Raytrace;
    local array<Actor> CurrentlyMarkedTargets;
    local int Direction, CanSeeFromDefault;
    local UnitPeekSide PeekSide;
    local int OutRequiresLean;
    local TTile BlockedTile, PeekTile, UnitTile, SnapTile;
    local bool GoodView;
    local CachedCoverAndPeekData PeekData;
    local array<TTile> Tiles;
    local vector2d vMouseCursorPos;
    local float ExpectedScatter;
	local float MaximumScatter;
    local GameRulesCache_VisibilityInfo OutVisibilityInfo;
    local vector FiringLocation;

	//	LW2 lines
    //NewTargetLocation = Cursor.GetCursorFeetLocation();
    //NewTargetLocation.Z += class'XComWorldData'.const.WORLD_FloorHeight;

	NewTargetLocation = Cursor.GetCursorFeetLocation();
	NewTargetLocation.Z = GetOptimalZForTile(NewTargetLocation);
	
    if( NewTargetLocation != CachedTargetLocation )
    {
        FiringLocation = FiringUnit.Location;
		FiringLocation.Z += class'XComWorldData'.const.WORLD_FloorHeight;
        
        World = `XWORLD;
        GoodView = false;
        if( World.VoxelRaytrace_Locations(FiringLocation, NewTargetLocation, Raytrace) )
        {
            BlockedTile = Raytrace.BlockedTile; 
            //  check left and right peeks
            FiringUnit.GetDirectionInfoForPosition(NewTargetLocation, OutVisibilityInfo, Direction, PeekSide, CanSeeFromDefault, OutRequiresLean, true);

            if (PeekSide != eNoPeek)
            {
                UnitTile = World.GetTileCoordinatesFromPosition(FiringUnit.Location);
                PeekData = World.GetCachedCoverAndPeekData(UnitTile);
                if (PeekSide == ePeekLeft)
                    PeekTile = PeekData.CoverDirectionInfo[Direction].LeftPeek.PeekTile;
                else
                    PeekTile = PeekData.CoverDirectionInfo[Direction].RightPeek.PeekTile;

                if (!World.VoxelRaytrace_Tiles(UnitTile, PeekTile, Raytrace))
                    GoodView = true;
                else
                    BlockedTile = Raytrace.BlockedTile;
            }               
        }       
        else
        {
            GoodView = true;
        }

        if( !GoodView )
        {
            NewTargetLocation = World.GetPositionFromTileCoordinates(BlockedTile);
           // Cursor.CursorSetLocation(NewTargetLocation); // new // Commented out per MrNice
        }
        else // new
        {
            if (SnapToTile)
            {
                SnapTile = `XWORLD.GetTileCoordinatesFromPosition(NewTargetLocation);
                `XWORLD.GetFloorPositionForTile(SnapTile, NewTargetLocation);
            }
        }
        GetTargetedActors(NewTargetLocation, CurrentlyMarkedTargets, Tiles);
        CheckForFriendlyUnit(CurrentlyMarkedTargets);   
        MarkTargetedActors(CurrentlyMarkedTargets, (!AbilityIsOffensive) ? FiringUnit.GetTeam() : eTeam_None );
        DrawSplashRadius();
        DrawAOETiles(Tiles);

        //update expected scatter amount display

		//	Controller Support per MrNice
		//vMouseCursorPos = LocalPlayer(`LOCALPLAYERCONTROLLER.Player).Project(Cursor.GetCursorFeetLocation());

		/* since the scatter depends on the NewTargetLocation, not the actual point aimed at with the 3DCursor
		 (when they differ), may be better to have it track the NewTargetLocation? -- MrNice*/
		vMouseCursorPos = LocalPlayer(`LOCALPLAYERCONTROLLER.Player).Project(NewTargetLocation);

		/*may need to tweak the x/y offsets to get the precise kind of positioning you want, 
		but that makes it move with the 3D cursor,which always exists, as opposed to the mouse pointer -- MrNice*/
		//ScatterAmountText.SetPosition((vMouseCursorPos.X+1)*960 + 2, (1-vMouseCursorPos.Y)*540 + 14);
		ScatterAmountText.SetPosition((vMouseCursorPos.X+1)*960 - 15, (1-vMouseCursorPos.Y)*540 + 50); // this follows cursor // 14 original value

		//	Original LW2 code
        //vMouseCursorPos = class'UIUtilities_LW'.static.GetMouseCoords();
        //ScatterAmountText.SetPosition(vMouseCursorPos.X + 2, vMouseCursorPos.Y + 14); // this follows cursor

		MaximumScatter = static.GetNumAimRolls(UnitState);
        ExpectedScatter = static.GetExpectedScatter(UnitState, NewTargetLocation);
        ScatterAmountText.SetHTMLText(class'UIUtilities_LW'.static.GetHTMLTilesText1() $ class'UIUtilities_LW'.static.GetHTMLAverageScatterValueText(ExpectedScatter) $ class'UIUtilities_LW'.static.GetHTMLMaximumScatterValueText(MaximumScatter) $ class'UIUtilities_LW'.static.GetHTMLTilesText2());
    }

    super(X2TargetingMethod_Grenade).UpdateTargetLocation(DeltaTime);
}

function Canceled()
{
    super.Canceled();

    ScatterAmountText.Remove();
  //ScatterAmountText.Destroy();	// Commented out per MrNice
}

static function vector GetScatterAmount(XComGameState_Unit Unit, vector ScatteredTargetLoc)
{
    local vector ScatterVector, ReturnPosition;
    local float EffectiveOffense;
    local int Idx, NumAimRolls, TileDistance, TileScatter;
    local float AngleRadians;
    local XComWorldData WorldData;

    WorldData = `XWORLD;

    NumAimRolls = GetNumAimRolls(Unit);
    TileDistance = TileDistanceBetween(Unit, ScatteredTargetLoc);
    NumAimRolls = Min(NumAimRolls, TileDistance);   //clamp the scatter for short range

    EffectiveOffense = GetEffectiveOffense(Unit, TileDistance);

    for(Idx=0 ; Idx < NumAimRolls  ; Idx++)
    {
        if(`SYNC_RAND_STATIC(100) >= EffectiveOffense)
            TileScatter += 1;
    }

    //pick a random direction in radians
    AngleRadians = `SYNC_FRAND_STATIC() * 2.0 * 3.141592653589793;
    ScatterVector.x = Cos(AngleRadians) * TileScatter * WorldData.WORLD_StepSize;
    ScatterVector.y = Sin(AngleRadians) * TileScatter * WorldData.WORLD_StepSize;
    ReturnPosition = ScatteredTargetLoc + ScatterVector;

    ReturnPosition = WorldData.FindClosestValidLocation(ReturnPosition, true, true);

    return ReturnPosition;
}

static function float GetExpectedScatter(XComGameState_Unit Unit, vector TargetLoc)
{
    local float ExpectedScatter;
    local int TileDistance;

    TileDistance = TileDistanceBetween(Unit, TargetLoc);
    ExpectedScatter = (100.0 - GetEffectiveOffense(Unit, TileDistance))/100.0 * float(GetNumAimRolls(Unit));

	if (ExpectedScatter < 0) return 0;
	else return ExpectedScatter;
}

static function float GetEffectiveOffense(XComGameState_Unit Unit, int TileDistance)
{
    local float EffectiveOffense;
	local name AbilityName;
    local int Idx;
	local array<int> RangeAccuracy;

	//	Get soldier's Aim Stat as the baseline
    EffectiveOffense = Unit.GetCurrentStat(eStat_Offense);

	// Get the appropriate Range Accuracy depending on rocket launcher's weapon tech level
	// and number of remaining actions on the soldier 
	RangeAccuracy = GetRangeAccuracyArray(Unit);

	// need this check in case GetRangeAccuracyArray() returns an empty array
	if (RangeAccuracy.Length > 0)
	{
		//adjust effective aim for distance
		if (TileDistance < RangeAccuracy.Length)
		{
			EffectiveOffense += RangeAccuracy[TileDistance];
					
		}
		else  //  if this tile is not configured, use the last configured tile		
		{
			//	an error would happen here if `RangeAccuracy` has zero length
			EffectiveOffense += RangeAccuracy[RangeAccuracy.Length - 1];
		}				
	}	
	
	//	adjust effective aim for abilities and passives
	foreach default.OFFENSE_INCREASE_ABILITIES(AbilityName, Idx)
    {
		//if(Unit.HasSoldierAbility(AbilityName)) - this is probably worse because it could be checking for soldier class abilities rather than abilities on weapons, TODO - check this
		if(Unit.FindAbility(AbilityName).ObjectID != 0)
		{
            EffectiveOffense += default.OFFENSE_INCREASE_MODIFIERS[Idx];
		}
    }

    return EffectiveOffense;
}

static function array<int> GetRangeAccuracyArray(XComGameState_Unit Unit)
{
	local XComGameState_Item		RocketLauncherState;
	local X2GrenadeLauncherTemplate	WeaponTemplate;
	local array<int> EmptyReturnArray;

	RocketLauncherState = Unit.GetItemInSlot(eInvSlot_SecondaryWeapon);
	if (RocketLauncherState != none)
	{
		WeaponTemplate = X2GrenadeLauncherTemplate(RocketLauncherState.GetMyTemplate());
		if (WeaponTemplate  != none /*&& WeaponTemplate.WeaponCat == 'iri_rocket_launcher'*/)	//	Weapon Cat check is not necessary, it's done in the ability conditions.
		{	
			// not entirely satisfied with this method of checking how many "proper" actions the soldier has left. Implacable action shouldn't count towards RL accuracy.
			// not to mention it was really crappy way of checking whether the soldier has moved or not. smh, pavonis
			if (GetNumActionPoints(Unit) <= 1)
			{
				switch (WeaponTemplate.WeaponTech)
				{
					case 'conventional': 
						return class'X2Item_IRI_RocketLaunchers'.default.CV_RL_RANGE_ACCURACY_ONE_ACTION;
					case 'magnetic':
						return class'X2Item_IRI_RocketLaunchers'.default.MG_RL_RANGE_ACCURACY_ONE_ACTION;
					case 'beam':
						return class'X2Item_IRI_RocketLaunchers'.default.BM_RL_RANGE_ACCURACY_ONE_ACTION;
					default:
						`redscreen("Rocket Launcher Targeting -> could not retrieve Range Accuracy Array" @ getfuncname() @ "weapon tech " @ WeaponTemplate.WeaponTech @ "-Iridar");
						return EmptyReturnArray;
						EmptyReturnArray.Length = 0;	//	Stop compiler moaning
				}
			}
			else
			{
				switch (WeaponTemplate.WeaponTech)
				{
					case 'conventional': 
						return class'X2Item_IRI_RocketLaunchers'.default.CV_RL_RANGE_ACCURACY;
					case 'magnetic':
						return class'X2Item_IRI_RocketLaunchers'.default.MG_RL_RANGE_ACCURACY;
					case 'beam':
						return class'X2Item_IRI_RocketLaunchers'.default.BM_RL_RANGE_ACCURACY;
					default:
						`redscreen("Rocket Launcher Targeting -> could not retrieve Range Accuracy Array" @ getfuncname() @ "weapon tech " @ WeaponTemplate.WeaponTech @ "-Iridar");
						return EmptyReturnArray;
				}
			}
		}
		else `redscreen("Rocket Launcher Targeting -> weapon is not rocket launcher in" @ getfuncname() @ "-Iridar");
	}
	else `redscreen("Rocket Launcher Targeting -> No rocket launcher weapon state in" @ getfuncname() @ "-Iridar");
}

static function int GetNumActionPoints(const XComGameState_Unit Unit)
{
//	local X2AbilityTemplate				AbilityTemplate;
	//local X2AbilityCost					AbilityCost;
	//local X2AbilityCost_ActionPoints	ActionCost;
	local int AP;
	local int i;
	/*
	AbilityTemplate = Ability.GetMyTemplate();
	foreach AbilityTemplate.AbilityCosts(AbilityCost)
	{
		ActionCost = X2AbilityCost_ActionPoints(AbilityCost);
		if (ActionCost != none && !ActionCost.bFreeCost) break;
	}*/

	//if (ActionCost != none)
	//{
		for (i = 0; i < Unit.ActionPoints.Length; i++)
		{
			if (class'X2Ability_IRI_Rockets'.default.RocketActionCost.AllowedTypes.Find(Unit.ActionPoints[i]) != INDEX_NONE) 
			{
				AP++;
			}
		}
	//}
	return AP;
}

static function int GetNumAimRolls(XComGameState_Unit Unit)
{
    local int NumAimRolls;
    local name AbilityName;
    local int Idx;
	local StateObjectReference EffectRef;
	local XComGameState_Effect EffectState;
	local X2Effect EffectTemplate;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;
    //set up baseline value
    NumAimRolls = default.NUM_AIM_SCATTER_ROLLS;

    foreach default.SCATTER_REDUCTION_ABILITIES(AbilityName, Idx)
    {
		//if(Unit.HasSoldierAbility(AbilityName)) - this is probably worse because it could be checking for soldier class abilities rather than abilities on weapons, TODO - check this
		if(Unit.FindAbility(AbilityName).ObjectID > 0)
		{
            NumAimRolls += default.SCATTER_REDUCTION_MODIFIERS[Idx];
		}
    }

    if(Unit.ActionPoints.Length <= 1)
	{
        NumAimRolls += default.ONE_ACTION_SCATTER_TILE_MODIFIER;
	}

	foreach Unit.AffectedByEffects(EffectRef)
	{
		EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
		EffectTemplate = EffectState.GetX2Effect();
		if(EffectTemplate.IsA('X2Effect_SteadyWeapon') && Unit.HasSoldierAbility('PlatformStability') )
		{
			NumAimRolls = 0;
		}
		else if (EffectTemplate.IsA('X2Effect_SteadyWeapon'))
		{
			NumAimRolls += default.STEADY_TILE_MODIFIER;
		}
	}

    return NumAimRolls;
}

static function int TileDistanceBetween(XComGameState_Unit Unit, vector TargetLoc)
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

defaultproperties
{
    SnapToTile = false;
}


/*
static function float GetEffectiveOffense(XComGameState_Unit Unit, int TileDistance)
{
	local XComGameState_Item		RocketLauncherState;
	local XComGameState_Unit		UnitState;
	local X2GrenadeLauncherTemplate WeaponTemplate;

    local float EffectiveOffense;
	local name AbilityName;
    local int Idx;

    EffectiveOffense = Unit.GetCurrentStat(eStat_Offense);
	// not entirely satisfied with this method of checking how many "proper" actions the soldier has left. Implacable action shouldn't count towards RL accuracy.
	// not to mention it was really crappy way of checking whether the soldier has moved or not. smh, pavonis
    if(Unit.ActionPoints.Length <= 1)
	{
        EffectiveOffense += default.ONE_ACTION_AIM_MODIFIER;
	}

    //adjust effective aim for distance
	RocketLauncherState = Unit.GetItemInSlot(eInvSlot_SecondaryWeapon);
	if (RocketLauncherState != none)
	{
		WeaponTemplate = X2GrenadeLauncherTemplate(RocketLauncherState.GetMyTemplate());
		if (WeaponTemplate  != none && WeaponTemplate.WeaponCat == 'iri_rocket_launcher')
		{	
			if (WeaponTemplate.RangeAccuracy.Length > 0)
			{
				if (TileDistance < WeaponTemplate.RangeAccuracy.Length)
					EffectiveOffense += WeaponTemplate.RangeAccuracy[TileDistance];
				else  //  if this tile is not configured, use the last configured tile					
					EffectiveOffense += WeaponTemplate.RangeAccuracy[WeaponTemplate.RangeAccuracy.Length-1];
			}
		}
		else `redscreen("Rocket Launcher Targeting -> weapon is not rocket launcher in" @ getfuncname() @ "-Iridar");
	}
	else `redscreen("Rocket Launcher Targeting -> No rocket launcher weapon state in" @ getfuncname() @ "-Iridar");

	//	adjust effective aim for abilities and passives
	foreach default.OFFENSE_INCREASE_ABILITIES(AbilityName, Idx)
    {
		//if(Unit.HasSoldierAbility(AbilityName)) - this is probably worse because it could be checking for soldier class abilities rather than abilities on weapons, TODO - check this
		if(Unit.FindAbility(AbilityName).ObjectID > 0)
		{
            EffectiveOffense += default.OFFENSE_INCREASE_MODIFIERS[Idx];
		}
    }

    return EffectiveOffense;
}
*/