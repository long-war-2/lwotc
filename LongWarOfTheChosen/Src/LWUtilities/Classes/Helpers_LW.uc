//---------------------------------------------------------------------------------------
//  FILE:    Helpers_LW
//  AUTHOR:  tracktwo / Pavonis Interactive
//
//  PURPOSE: Extra helper functions/data. Cannot add new data to native classes (e.g. Helpers)
//           so we need a new one.
//---------------------------------------------------------------------------------------

class Helpers_LW extends Object config(GameCore) dependson(Engine);

struct ProjectileSoundMapping
{
	var string ProjectileName;
	var string FireSoundPath;
	var string DeathSoundPath;
};

var config const array<string> RadiusManagerMissionTypes;        // The list of mission types to enable the radius manager to display rescue rings.

// If true, enable the yellow alert movement system.
var config const bool EnableYellowAlert;

// If true, hide havens on the geoscape
var config const bool HideHavens;

// If true, encounter zones will not be updated based XCOM's current position.
var config bool DisableDynamicEncounterZones;

var config bool EnableAvengerCameraSpeedControl;
var config float AvengerCameraSpeedControlModifier;

// The radius (in meters) for which a civilian noise alert can be heard.
var config int NoiseAlertSoundRange;

// Enable/disable the use of the 'Yell' ability before every civilian BT evaluation. Enabled by default.
var config bool EnableCivilianYellOnPreMove;

// If this flag is set, units in yellow alert will not peek around cover to determine LoS - similar to green units.
// This is useful when yellow alert is enabled because you can be in a situation where a soldier is only a single tile
// out of LoS from a green unit, and that neighboring tile that they would have LoS from is the tile they will use to
// peek. The unit will appear to be out of LoS of any unit, but any action that alerts that nearby pod will suddenly
// bring you into LoS and activate the pod when it begins peeking. Examples are a nearby out-of-los pod activating when you
// shoot at another pod you can see from concealment, or a nearby pod activating despite no aliens being in LoS when you
// break concealment by hacking an objective (which alerts all pods).
var config bool NoPeekInYellowAlert;


// this int controls how low the deployable soldier count has to get in order to trigger the low manpower warning
// if it is not set (at 0), then the game will default to GetMaxSoldiersAllowedOnMission
var config int LowStrengthTriggerCount;

// these variables control various world effects, to prevent additional voxel check that can cause mismatch between preview and effect
var config bool bWorldPoisonShouldDisableExtraLOSCheck;
var config bool bWorldSmokeShouldDisableExtraLOSCheck;
var config bool bWorldSmokeGrenadeShouldDisableExtraLOSCheck;

// Control whether or not to class-limit heavy weapons. If false, any class can equip any heavy weapon (provided they have the
// correct inventory items to allow it). If true heavy weapons can be class-limited. Used to restrict which weapons the technical
// can equip.
var config bool ClassLimitHeavyWeapons;

// This is to double check in grenade targeting that the affected unit is actually in a tile that will get the world effect, not just that it is occupying such a tile.
// This can occur because tiles are only 1 meter high, so many unit occupy multiple vertical tiles, but only really count as occupying the one at their feet in other places.
var config array<name> GrenadeRequiresWorldEffectToAffectUnit;

// Returns 'true' if the given mission type should enable the radius manager (e.g. the thingy
// that controls rescue rings on civvies). This is done through a config var that lists the
// desired mission types for extensibility.

var config bool EnableRestartMissionButtonInNonIronman;
var config bool EnableRestartMissionButtonInIronman;

// A list of replacement projectile sound effects mapping a projectile element to a sound cue name.
//
// 'ProjectileName' can have one of two forms:
//
// 1) (Preferred), the full path of the object archetype of the projectile element you want to modify. This is the
// name as it appears in the Unreal Editor X2UnifiedProjectile "Projectile Elements" array, without the surrounding
// X2UnifiedProjectileElement''. That is, for the vanilla beam assault rifle, the path for the element with the
// fire and death sounds is "WP_AssaultRifle_BM.PJ_AssaultRifle_BM:X2UnifiedProjectileElement_3".
//
// 2) (Deprecated) The 'ProjectileName' is of the form ProjectileName_Index where ProjectileName is the name of the
// projectile archetype, and Index is the index into the projectile array for the element that should have
// the sound associated with it. e.g. "PJ_Shotgun_CV_15" to set index 15 in the conventional shotgun (the
// one with the fire sound). Note that the index counts individual projectile elements, and may not exactly
// match what is present in the editor. For example, the conventional shotgun has only two elements in the array,
// but the first one is a volley of 15 projectiles. So the sound attached to index 1 in the array is
// actually index 15 at runtime.
//
// The first form is preferred because it is always the same regardless of hit/miss settings that may impact the
// index on some projectiles, making it impossible to statically provide the right index. The second form is
// still provided for backwards compatibility.
//
// The fire or death sound is the name of a sound cue loaded into the sound manager system. See the SoundCuePaths
// array in XComSoundManager.
var config array<ProjectileSoundMapping> ProjectileSounds;

//allow certain classes to be overridden recursively, so the override can be overridden
var config array<ModClassOverrideEntry> UIDynamicClassOverrides;

//Configuration array to control how much damage fire does when it finishes burning
// This is indexed by the number of turns it has been burning, which is typically 1 to 3,
// but can be longer if the environment actor was configured with Toughness.AvailableFireFuelTurns
var config array<int> FireEnvironmentDamageAfterNumTurns;

//This is referenced in XCGS_Unit and must be true to run some code that ensures a powerful psi ability can be trained
var config bool EnablePsiTreeOrganization;

//These variables are generic patrol zone settings for reinforcements who land before concealment is broken
var config int REINF_EZ_WIDTH;
var config int REINF_EZ_DEPTH;
var config int REINF_EZ_OFFSET;

var config bool USE_FLOAT_PRICE_MULTIPLIER;
var config array<float> InterestPriceMultiplierFloat;

// These variables control AI AoE targeting behavior.
var config bool RequireVisibilityForAoETarget;
var config bool AllowSquadVisibilityForAoETarget;

// If true a graze cannot reduce weapon damage that was > 0 to 0. Mostly detectable on items that apply
// 1 damage, such as pistols or poison. If they hit with a graze, the damage would be reduced to < 1 and
// truncated to 0 by the graze modifier. With this set damage will not be reduced below 1 by graze.
var config bool ClampGrazeMinDamage;

// If cumulative rupture is enabled, each rupture value from each successful attack on a unit stacks. However,
// unlike the default behavior, the new rupture value applied on a particular attack does not affect that attack,
// only subsequent attacks. For example, hitting a unit 3 times for 5 damage each with a weapon that does
// +1 rupture damage would do: (5+0), (5+1), (5+2) damage. Bonus rupture damage is capped at the average damage
// of the weapon making an attack.
// When false, the default algorithm is used, where only the highest rupture value is stored on a unit. Attacking
// a ruptured unit with a weapon that does less rupture damage than they already have will not change their rupture
// amount and so won't affect subsequent shots, but will still give a bonus to that particular attack.
var config bool CumulativeRupture;

// Configure ever vigilant trigger behavior: If these flags are set EV will not proc when a unit is impaired or
// burning, respectively.
var config bool EverVigilantExcludeImpaired;
var config bool EverVigilantExcludeBurning;

// If this flag is set then set the HP for soldier VIP proxies to have the same HP as the original soldier.
// This addresses an issue where the soldier has more HP than the proxy and becomes wounded even if the proxy
// was not wounded, simply because the soldier HP was greater than the proxy.
var config bool UseUnitHPForProxies;

simulated static function class<object> LWCheckForRecursiveOverride(class<object> ClassToCheck)
{
	local int idx;
	local class<object> CurrentBestClass, TestClass;
	local bool NeedsCheck;
	local name BestClassName;

	BestClassName = name(string(ClassToCheck));
	CurrentBestClass = ClassToCheck;
	NeedsCheck = true;

	while (NeedsCheck)
	{
		NeedsCheck = false;
		idx = class'Helpers_LW'.default.UIDynamicClassOverrides.Find('BaseGameClass', BestClassName);
		if (idx != -1)
		{
			TestClass = class<object>(DynamicLoadObject(string(class'Helpers_LW'.default.UIDynamicClassOverrides[idx].ModClass), class'Class'));
			if (TestClass != none) // && TestClass.IsA(BestClassName))
			{
				BestClassName = name(string(TestClass));
				CurrentBestClass = TestClass;
				NeedsCheck = true;
			}
		}
	}
	`LOG("LWCheckForRecursiveOverride : Overrode " $ string(ClassToCheck) $ " to " $ CurrentBestClass);
	return CurrentBestClass;
}

static function bool ShouldUseRadiusManagerForMission(String MissionType)
{
	local XComGameStateHistory History;
	local XComGameState_BattleData BattleData;
	local XComGameState_MissionSite MissionSite;

	// Note: X2TacticalGameRuleset checked the mission type very early in the mission startup process, before the MapData
	// is set in the BattleData object. If we are called with an empty string, try to find the type from the mission state.
	if (MissionType == "")
	{
		History = `XCOMHISTORY;
		BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
		MissionSite = XComGameState_MissionSite(History.GetGameStateForObjectID(BattleData.m_iMissionID));
		MissionType = MissionSite.GeneratedMission.Mission.sType;
	}
    return default.RadiusManagerMissionTypes.Find(MissionType) >= 0;
}

static function bool YellowAlertEnabled()
{
    return default.EnableYellowAlert;
}

static function bool DynamicEncounterZonesDisabled()
{
	return default.DisableDynamicEncounterZones;
}

// Copied from XComGameState_Unit::GetEnemiesInRange, except will retrieve all units on the alien team within
// the specified range.
static function GetAlienUnitsInRange(TTile kLocation, int nMeters, out array<StateObjectReference> OutEnemies)
{
	local vector vCenter, vLoc;
	local float fDistSq;
	local XComGameState_Unit kUnit;
	local XComGameStateHistory History;
	local float AudioDistanceRadius, UnitHearingRadius, RadiiSumSquared;

	History = `XCOMHISTORY;
	vCenter = `XWORLD.GetPositionFromTileCoordinates(kLocation);
	AudioDistanceRadius = `METERSTOUNITS(nMeters);
	fDistSq = Square(AudioDistanceRadius);

	foreach History.IterateByClassType(class'XComGameState_Unit', kUnit)
	{
		if( kUnit.GetTeam() == eTeam_Alien && kUnit.IsAlive() )
		{
			vLoc = `XWORLD.GetPositionFromTileCoordinates(kUnit.TileLocation);
			UnitHearingRadius = kUnit.GetCurrentStat(eStat_HearingRadius);

			RadiiSumSquared = fDistSq;
			if( UnitHearingRadius != 0 )
			{
				RadiiSumSquared = Square(AudioDistanceRadius + UnitHearingRadius);
			}

			if( VSizeSq(vLoc - vCenter) < RadiiSumSquared )
			{
				OutEnemies.AddItem(kUnit.GetReference());
			}
		}
	}
}

function static SoundCue FindFireSound(String ObjectArchetypeName, int Index, optional String ProjectileElementArchetypePath = "")
{
	local String strKey;
	local int SoundIdx;
	local XComSoundManager SoundMgr;

	SoundIdx = -1;

	// First try to search based on the projectile element, if provided.
	if (Len(ProjectileElementArchetypePath) > 0)
		SoundIdx = default.ProjectileSounds.Find('ProjectileName', ProjectileElementArchetypePath);

	// Failing that fall-back to the old projectile archetype + index method
	if (SoundIdx < 0)
	{
		strKey = ObjectArchetypeName $ "_" $ String(Index);
		SoundIdx = default.ProjectileSounds.Find('ProjectileName', strKey);
	}

	if (SoundIdx >= 0 && default.ProjectileSounds[SoundIdx].FireSoundPath != "")
	{
		SoundMgr = `SOUNDMGR;
		SoundIdx = SoundMgr.SoundCues.Find('strKey', default.ProjectileSounds[SoundIdx].FireSoundPath);
		if (SoundIdx >= 0)
		{
			return SoundMgr.SoundCues[SoundIdx].Cue;
		}
	}

	return none;
}

function static SoundCue FindDeathSound(String ObjectArchetypeName, int Index, optional String ProjectileElementArchetypePath = "")
{
	local string strKey;
	local int SoundIdx;
	local XComSoundManager SoundMgr;

	SoundIdx = -1;

	// First try to search based on the projectile element, if provided.
	if (Len(ProjectileElementArchetypePath) > 0)
		SoundIdx = default.ProjectileSounds.Find('ProjectileName', ProjectileElementArchetypePath);

	// Failing that fall-back to the old projectile archetype + index method
	if (SoundIdx < 0)
	{
		strKey = ObjectArchetypeName $ "_" $ String(Index);
		SoundIdx = default.ProjectileSounds.Find('ProjectileName', strKey);
	}

	if (SoundIdx >= 0 && default.ProjectileSounds[SoundIdx].DeathSoundPath != "")
	{
		SoundMgr = `SOUNDMGR;
		SoundIdx = SoundMgr.SoundCues.Find('strKey', default.ProjectileSounds[SoundIdx].DeathSoundPath);
		if (SoundIdx >= 0)
		{
			return SoundMgr.SoundCues[SoundIdx].Cue;
		}
	}

	return none;
}

// Returns the game state object reference for the faction whose rival
// Chosen controls the given region.
static function XComGameState_ResistanceFaction GetFactionFromRegion(StateObjectReference RegionRef)
{
	local XComGameStateHistory History;
	local XComGameState_AdventChosen ChosenState;
	local XComGameState_ResistanceFaction FactionState;

	// First, find the Chosen that controls this region
	History = `XCOMHISTORY;
	foreach History.IterateByClassType(class'XComGameState_AdventChosen', ChosenState)
	{
		if (ChosenState.ChosenControlsRegion(RegionRef))
		{
			break;
		}
	}

	// Finally, get the faction who has this Chosen as their rival
	foreach History.IterateByClassType(class'XComGameState_ResistanceFaction', FactionState)
	{
		if (FactionState.RivalChosen.ObjectID == ChosenState.ObjectID)
		{
			break;
		}
	}

	return FactionState;
}
