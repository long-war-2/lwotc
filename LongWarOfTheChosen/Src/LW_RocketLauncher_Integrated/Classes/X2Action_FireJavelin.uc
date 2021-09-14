class X2Action_FireJavelin extends X2Action_BlazingPinionsStage2;

//var private int TimeDelayIndex;

//Cached info for the unit performing the action
//*************************************
/*
var private CustomAnimParams Params;
var private AnimNotify_FireWeaponVolley FireWeaponNotify;
var private int TimeDelayIndex;

var bool		ProjectileHit;
var XGWeapon	UseWeapon;
var XComWeapon	PreviousWeapon;
var XComUnitPawn FocusUnitPawn;
*/
//*************************************

//	This function fires a projectile between two points
function AddProjectile()
{
	local TTile SourceTile;
	local XComWorldData World;
	local vector SourceLocation, ImpactLocation;
	local int ZValue;
	local StateObjectReference	TargetRef;
	local XComGameState_Unit	TargetState;
	local int HistoryIndex;

	World = `XWORLD;

	// Calculate the upper z position for the projectile
	// Move it above the top level of the world a bit with *2
	ZValue = World.WORLD_FloorHeightsPerLevel * World.WORLD_TotalLevels * 2;

	TargetRef = AbilityContext.InputContext.PrimaryTarget;
	TargetState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(TargetRef.ObjectID));
	
	if (TargetState != none)
	{
		//	if the ability missed, fire the rocket at the miss position
		if (AbilityContext.ResultContext.HitResult == eHit_Miss)
		{
			////`LOG(AbilityContext.ResultContext.ProjectileHitLocations.Length,, 'IRIROCK');
			ZValue *= World.WORLD_FloorHeight;
			SourceLocation = AbilityContext.ResultContext.ProjectileHitLocations[0];
			SourceLocation.Z = ZValue;
			ImpactLocation = AbilityContext.ResultContext.ProjectileHitLocations[0];
		}
		else
		{
			//	otherwise fire the rocket directly at the target

			//	if the target will be killed by this attack, the projectile will hit where the target's corpse will be once the target dies.
			//	which looks bad, the rocket hits the position of the corpse, and only then the corpse falls into that position.
			//	so if target was killed by the attack, we go back through history until we find the Unit State of the target when it was still alive
			//	... or we run out of history to search through.
			if (TargetState.IsDead())
			{
				HistoryIndex = History.GetCurrentHistoryIndex();
				do
				{
					TargetState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(TargetRef.ObjectID,, --HistoryIndex));
				}
				until (!TargetState.IsDead() || HistoryIndex == 1);
			}

			//ImpactLocation = AbilityContext.InputContext.TargetLocations[ProjectileIndex];	//	this just returns zero vector??? why is this necessary?
																							//	there is only one Target Location, probably returns zero because of non-zero ProjectileIndex
			//SourceTile = World.GetTileCoordinatesFromPosition(ImpactLocation);

			SourceTile = TargetState.TileLocation;
			ImpactLocation = World.GetPositionFromTileCoordinates(SourceTile);
			SourceTile.Z = ZValue;
			SourceLocation = World.GetPositionFromTileCoordinates(SourceTile);
		
			//ImpactLocation = SourceLocation;
			//ImpactLocation.Z = 0;
		
			//World.GetFloorPositionForTile(SourceTile, ImpactLocation);
		
			////`LOG("SourceLocation: " @ SourceLocation,, 'IRIDAR');
			////`LOG("ImpactLocation: " @ ImpactLocation,, 'IRIDAR');
		}
		AddPsiPinionProjectile(SourceLocation, ImpactLocation, AbilityContext, Unit);

	//		`SHAPEMGR.DrawSphere(SourceLocation, vect(15,15,15), MakeLinearColor(0,0,1,1), true);
	//		`SHAPEMGR.DrawSphere(ImpactLocation, vect(15,15,15), MakeLinearColor(0,0,1,1), true);
	}
}

function AddPsiPinionProjectile(vector SourceLocation, vector TargetLocationObj, XComGameStateContext_Ability AbilityContextObj, XGUnit XGUnitVar)
{
	local XComWeapon WeaponEntity;
	local XComUnitPawn UnitPawnObj;
	local X2UnifiedProjectile NewProjectile;
	local AnimNotify_FireWeaponVolley FireVolleyNotify;
	
	UnitPawnObj = XGUnitVar.GetPawn();

	//The archetypes for the projectiles come from the weapon entity archetype
	WeaponEntity = XComWeapon(UnitPawnObj.Weapon);

	if (WeaponEntity != none)
	{
		FireVolleyNotify = new class'AnimNotify_FireWeaponVolley';
		FireVolleyNotify.NumShots = 1;
		FireVolleyNotify.ShotInterval = 0.0f;
		//FireVolleyNotify.bCosmeticVolley = false;
		//FireVolleyNotify.bCustom = true;
		//FireVolleyNotify.CustomID = 11;

		NewProjectile = class'WorldInfo'.static.GetWorldInfo().Spawn(class'X2UnifiedProjectile', , , , , WeaponEntity.DefaultProjectileTemplate);
		NewProjectile.ConfigureNewProjectileCosmetic(FireVolleyNotify, AbilityContextObj, , , XGUnitVar.CurrentFireAction, SourceLocation, TargetLocationObj, true);
		NewProjectile.GotoState('Executing');
	}
}

simulated state Executing
{
Begin:
	//PreviousWeapon = XComWeapon(UnitPawn.Weapon);
	//UnitPawn.SetCurrentWeapon(XComWeapon(UseWeapon.m_kEntity));

	Unit.CurrentFireAction = self;

	Sleep(GetDelayModifier());
	AddProjectile();

	while (!ProjectileHit)
	{
		Sleep(0.01f);
	}

	//UnitPawn.SetCurrentWeapon(PreviousWeapon);

	Sleep(0.5f * GetDelayModifier()); // Sleep to allow destruction to be seenw

	CompleteAction();
}