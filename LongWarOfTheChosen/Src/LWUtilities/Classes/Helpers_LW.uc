//---------------------------------------------------------------------------------------
//  FILE:    Helpers_LW
//  AUTHOR:  tracktwo / Pavonis Interactive
//
//  PURPOSE: Extra helper functions/data. Cannot add new data to native classes (e.g. Helpers)
//           so we need a new one.
//---------------------------------------------------------------------------------------

class Helpers_LW extends Object config(GameCore) dependson(Engine);

var config bool EnableLWTrace;
var config bool EnableLWDiversityTrace;
var config bool EnableLWDebug;
var config bool EnableLWPMTrace;

var config bool bUseTrueDifficultyCalc;

var const string CHOSEN_SPAWN_TAG_SUFFIX;

struct ProjectileSoundMapping
{
	var string ProjectileName;
	var string FireSoundPath;
	var string DeathSoundPath;
};

var config const array<string> RadiusManagerMissionTypes;        // The list of mission types to enable the radius manager to display rescue rings.

// If true, enable the yellow alert movement system.
var config const bool EnableYellowAlert;

// ORPHANED
// If true, hide havens on the geoscape
var config const bool HideHavens;

// ORPHANED/deprecated
// If true, encounter zones will not be updated based XCOM's current position.
var config bool DisableDynamicEncounterZones;

// ORPHANED
var config bool EnableAvengerCameraSpeedControl;
var config float AvengerCameraSpeedControlModifier;

// ORPHANED/deprecated
// The radius (in meters) for which a civilian noise alert can be heard.
var config int NoiseAlertSoundRange;

// Enable/disable the use of the 'Yell' ability before every civilian BT evaluation. Enabled by default.
var config bool EnableCivilianYellOnPreMove;

// ORPHANED
// If this flag is set, units in yellow alert will not peek around cover to determine LoS - similar to green units.
// This is useful when yellow alert is enabled because you can be in a situation where a soldier is only a single tile
// out of LoS from a green unit, and that neighboring tile that they would have LoS from is the tile they will use to
// peek. The unit will appear to be out of LoS of any unit, but any action that alerts that nearby pod will suddenly
// bring you into LoS and activate the pod when it begins peeking. Examples are a nearby out-of-los pod activating when you
// shoot at another pod you can see from concealment, or a nearby pod activating despite no aliens being in LoS when you
// break concealment by hacking an objective (which alerts all pods).
var config bool NoPeekInYellowAlert;

// ORPHANED
// this int controls how low the deployable soldier count has to get in order to trigger the low manpower warning
// if it is not set (at 0), then the game will default to GetMaxSoldiersAllowedOnMission
var config int LowStrengthTriggerCount;

//ORPHANED
// these variables control various world effects, to prevent additional voxel check that can cause mismatch between preview and effect
var config bool bWorldPoisonShouldDisableExtraLOSCheck;
var config bool bWorldSmokeShouldDisableExtraLOSCheck;
var config bool bWorldSmokeGrenadeShouldDisableExtraLOSCheck;

//ORPHANED
// Control whether or not to class-limit heavy weapons. If false, any class can equip any heavy weapon (provided they have the
// correct inventory items to allow it). If true heavy weapons can be class-limited. Used to restrict which weapons the technical
// can equip.
var config bool ClassLimitHeavyWeapons;

//ORPHANED
// This is to double check in grenade targeting that the affected unit is actually in a tile that will get the world effect, not just that it is occupying such a tile.
// This can occur because tiles are only 1 meter high, so many unit occupy multiple vertical tiles, but only really count as occupying the one at their feet in other places.
var config array<name> GrenadeRequiresWorldEffectToAffectUnit;

// Returns 'true' if the given mission type should enable the radius manager (e.g. the thingy
// that controls rescue rings on civvies). This is done through a config var that lists the
// desired mission types for extensibility.

//ORPHANED
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

//ORPHANED
//This is referenced in XCGS_Unit and must be true to run some code that ensures a powerful psi ability can be trained
var config bool EnablePsiTreeOrganization;

//ORPHANED
//These variables are generic patrol zone settings for reinforcements who land before concealment is broken
var config int REINF_EZ_WIDTH;
var config int REINF_EZ_DEPTH;
var config int REINF_EZ_OFFSET;

//ORPHANED
var config bool USE_FLOAT_PRICE_MULTIPLIER;
var config array<float> InterestPriceMultiplierFloat;

//ORPHANED
// These variables control AI AoE targeting behavior.
var config bool RequireVisibilityForAoETarget;
var config bool AllowSquadVisibilityForAoETarget;

//ORPHANED
// If true a graze cannot reduce weapon damage that was > 0 to 0. Mostly detectable on items that apply
// 1 damage, such as pistols or poison. If they hit with a graze, the damage would be reduced to < 1 and
// truncated to 0 by the graze modifier. With this set damage will not be reduced below 1 by graze.
var config bool ClampGrazeMinDamage;

//ORPHANED
// If cumulative rupture is enabled, each rupture value from each successful attack on a unit stacks. However,
// unlike the default behavior, the new rupture value applied on a particular attack does not affect that attack,
// only subsequent attacks. For example, hitting a unit 3 times for 5 damage each with a weapon that does
// +1 rupture damage would do: (5+0), (5+1), (5+2) damage. Bonus rupture damage is capped at the average damage
// of the weapon making an attack.
// When false, the default algorithm is used, where only the highest rupture value is stored on a unit. Attacking
// a ruptured unit with a weapon that does less rupture damage than they already have will not change their rupture
// amount and so won't affect subsequent shots, but will still give a bonus to that particular attack.
var config bool CumulativeRupture;

//ORPHANED
// Configure ever vigilant trigger behavior: If these flags are set EV will not proc when a unit is impaired or
// burning, respectively.
var config bool EverVigilantExcludeImpaired;
var config bool EverVigilantExcludeBurning;

//ORPHANED
// If this flag is set then set the HP for soldier VIP proxies to have the same HP as the original soldier.
// This addresses an issue where the soldier has more HP than the proxy and becomes wounded even if the proxy
// was not wounded, simply because the soldier HP was greater than the proxy.
var config bool UseUnitHPForProxies;

// Cache installed mods during OPTC

var config bool bSmokeStopsFlanksActive;
var config bool bImprovedSmokeDefenseActive;

var config bool bWOTCRevertOverwatchRulesActive;
var config bool bWOTCCostBasedAbilityColorsActive;
var config bool bWorldWarLostActive;
var config bool XCOM2RPGOverhaulActive;

var config bool bKirukaFactionOverhaulActive;
var config bool bNewTemplarModJamActive;

var config bool bDABFLActive;
var config bool bKirukaSparkActive;

var config bool bDSLReduxActive;

var config bool bDudeWheresMyLootActive;

var config bool bDLC2Active;

var config array<string> cachedInstalledModNames, cachedInstalledDLCNames;

static final function bool IsModInstalled(coerce string DLCIdentifier)
{
    if (default.cachedInstalledModNames.Length == 0)
    {
        default.cachedInstalledModNames = class'Helpers'.static.GetInstalledModNames();
		default.cachedInstalledDLCNames = class'Helpers'.static.GetInstalledDLCNames();
    }

    return default.cachedInstalledModNames.Find(DLCIdentifier) != INDEX_NONE || default.cachedInstalledDLCNames.Find(DLCIdentifier) != INDEX_NONE;
}

static final function bool IsDLCInstalled(coerce string DLCIdentifier)

{
	local array<string> DLCs;

	DLCs = class'Helpers'.static.GetInstalledDLCNames();
	return DLCs.Find(DLCIdentifier) != INDEX_NONE;
}

simulated final static function class<object> LWCheckForRecursiveOverride(class<object> ClassToCheck)
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

static final function XComGameState_BaseObject GetGameStateForObjectIDFromPendingOrHistory(int ObjectID, optional XComGameState NewGameState = none)
{
	local XComGameState_BaseObject GameStateObject;

	if (NewGameState != none)
	{
		GameStateObject = NewGameState.GetGameStateForObjectID(ObjectID);
	}

	if (GameStateObject == none)
	{
		GameStateObject = `XCOMHISTORY.GetGameStateForObjectID(ObjectID);
	}

	return GameStateObject;
}

static final function bool ShouldUseRadiusManagerForMission(String MissionType)
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

static final function bool YellowAlertEnabled()
{
    return default.EnableYellowAlert;
}

static final function bool DynamicEncounterZonesDisabled()
{
	return default.DisableDynamicEncounterZones;
}

// Uses visibility rules to determine whether one unit is flanked by
// another. This is because XCGS_Unit.IsFlanked() does not work for
// squadsight attackers.
static final function bool IsUnitFlankedBy(XComGameState_Unit Target, XComGameState_Unit MaybeFlanker)
{
	local GameRulesCache_VisibilityInfo VisInfo;

	if (`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(MaybeFlanker.ObjectID, Target.ObjectID, VisInfo))
	{
		return Target.CanTakeCover() && VisInfo.TargetCover == CT_None;
	}
	else
	{
		return Target.IsFlanked(MaybeFlanker.GetReference(), true);
	}
}

// Copied from XComGameState_Unit::GetEnemiesInRange, except will retrieve all units on the alien team within
// the specified range.
static final function GetAlienUnitsInRange(TTile kLocation, int nMeters, out array<StateObjectReference> OutEnemies)
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
static final function XComGameState_ResistanceFaction GetFactionFromRegion(StateObjectReference RegionRef)
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

static final function name GetChosenActiveMissionTag(XComGameState_AdventChosen ChosenState)
{
	local name ChosenSpawningTag;

	ChosenSpawningTag = ChosenState.GetMyTemplate().GetSpawningTag(0);
	ChosenSpawningTag = name(ChosenSpawningTag $ default.CHOSEN_SPAWN_TAG_SUFFIX);

	return ChosenSpawningTag;
}

// Creates a Hack Defense reduction effect with a unique name, so that they can
// stack. Also adds an icon for the effect, because the base game version doesn't
// have one.
//
// Note that the HackDefenseChangeAmount should be negative for an actual reduction
// in hack defense.
static final function X2Effect_PersistentStatChange CreateHackDefenseReductionStatusEffect(
	name EffectName,
	int HackDefenseChangeAmount,
	optional X2Condition Condition)
{
	local X2Effect_PersistentStatChange HackDefenseReductionEffect;

	HackDefenseReductionEffect = class'X2StatusEffects'.static.CreateHackDefenseChangeStatusEffect(HackDefenseChangeAmount, Condition);
	HackDefenseReductionEffect.EffectName = EffectName;
	HackDefenseReductionEffect.DuplicateResponse = eDupe_Refresh;
	HackDefenseReductionEffect.IconImage = "UILibrary_Common.TargetIcons.Hack_robot_icon";

	return HackDefenseReductionEffect;
}

// Recursively prints all visualization actions in the tree that is rooted
// at the given action. `iLayer` is the starting tree depth to start at.
static final function PrintActionRecursive(X2Action Action, int iLayer)
{
    local X2Action ChildAction;

    `LOG("Action layer: " @ iLayer @ ": " @ Action.Class.Name,, 'LWOTC'); 
    foreach Action.ChildActions(ChildAction)
    {
        PrintActionRecursive(ChildAction, iLayer + 1);
    }
}

// Returns whether resistance orders are enabled in the campaign or not. This
// not only checks for whether the second wave option is enabled, but it also
// checks where there are any active resistance orders. If there are, then
// they are automatically enabled.
//
// TODO: This check for active resistance orders is only needed for the transition
// when introducing the second wave option on existing campaigns. We can't hide the
// Resistance Orders UI while there are active cards.
static final function bool AreResistanceOrdersEnabled()
{
	local XComGameState_HeadquartersResistance ResistanceHQ;
	local array<XComGameState_ResistanceFaction> AllFactions;
	local XComGameState_ResistanceFaction FactionState;
	local array<StateObjectReference> CardSlots;
	local int i;

	// First check the "wild card" slots
	ResistanceHQ = XComGameState_HeadquartersResistance(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));
	CardSlots = ResistanceHQ.GetWildCardSlots();
	for (i = 0; i < CardSlots.Length; i++)
	{
		if (CardSlots[i].ObjectID != 0)
			return true;
	}

	// Next check whether there are any cards in faction slots
	AllFactions = ResistanceHQ.GetAllFactions();
	foreach AllFactions(FactionState)
	{
		CardSlots = FactionState.GetCardSlots();
		for (i = 0; i < CardSlots.Length; i++)
		{
			if (CardSlots[i].ObjectID != 0)
				return true;
		}
	}

	// Finally, check the second wave option
	return `SecondWaveEnabled('EnableResistanceOrders');
}

// Resumes or pauses any Will recovery projects for the given unit when
// updating their status.
static final function UpdateUnitWillRecoveryProject(XComGameState_Unit UnitState)
{
	local XComGameState_HeadquartersProjectRecoverWill WillProject;
	local ESoldierStatus UnitStatus;

	// Pause or resume the unit's Will recovery project if there is one, based on
	// the new status.
	WillProject = GetWillRecoveryProject(UnitState.GetReference());
	if (WillProject != none)
	{
		UnitStatus = UnitState.GetStatus();
		if ((UnitStatus == eStatus_Active || UnitStatus == eStatus_Healing) && IsHQProjectPaused(WillProject))
		{
			WillProject.ResumeProject();
		}
		else if ((UnitStatus != eStatus_Active && UnitStatus != eStatus_Healing) && !IsHQProjectPaused(WillProject))
		{
			WillProject.PauseProject();
		}
	}
}

static final function bool IsHQProjectPaused(XComGameState_HeadquartersProject ProjectState)
{
	return ProjectState.CompletionDateTime.m_iYear == 9999;
}

static final function XComGameState_HeadquartersProjectRecoverWill GetWillRecoveryProject(StateObjectReference UnitRef)
{
	local XComGameState_HeadquartersProjectRecoverWill WillProject;

	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_HeadquartersProjectRecoverWill', WillProject)
	{
		if (WillProject.ProjectFocus.ObjectID == UnitRef.ObjectID)
		{
			return WillProject;
		}
	}

	return none;
}

// Returns:
//  1 - Easy
//  2 - Moderate
//  3 - Hard
static final function int GetCovertActionDifficulty(XComGameState_CovertAction ActionState)
{
	local CovertActionRisk Risk;

	foreach ActionState.Risks(Risk)
	{
		switch (Risk.RiskTemplateName)
		{
		case 'CovertActionRisk_Failure_Easy':
			return 1;
		case 'CovertActionRisk_Failure_Moderate':
			return 2;
		case 'CovertActionRisk_Failure_Hard':
			return 3;
		default:
			break;
		}
	}

	// Default to Moderate
	return 2;
}

// Use this to determine whether a unit is interrupting another team's turn,
// for example via Skirmisher's Battlelord or Skirmisher Interrupt.
static final function bool IsUnitInterruptingEnemyTurn(XComGameState_Unit UnitState)
{
	local XComGameState_BattleData BattleState;

	BattleState = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	return BattleState.InterruptingGroupRef == UnitState.GetGroupMembership().GetReference();
}

// Adds the given unit to the XCom (primary) initiative group, ensuring that the unit
// is controllable by the player.
static final function AddUnitToXComGroup(XComGameState NewGameState, XComGameState_Unit Unit, XComGameState_Player Player, optional XComGameStateHistory History = None)
{
    local XComGameState_Unit CurrentUnit;
    local XComGameState_AIGroup Group;

    if (History == None)
    {
        History = `XCOMHISTORY;
    }

    // Need to search through all current units to find a squad member
    // whose initiative group we can grab.
    foreach History.IterateByClassType(class'XComGameState_Unit', CurrentUnit)
    {
        if (CurrentUnit.ControllingPlayer.ObjectID == Player.ObjectID)
        {
            // Found a squad member. Grab that unit's initiative group and add the
            // liaison to it.
            Group = CurrentUnit.GetGroupMembership();
            Group.AddUnitToGroup(Unit.ObjectID, NewGameState);
        }
    }
}

// Copied from LW2's highlander. Since `XComGameState_Unit.HasSoldierAbility()`
// does not take into account any mod additions to `XCGS_Unit.GetEarnedSoldierAbilities()`,
// we need this custom implementation to check for officer abilities.
static final function bool HasSoldierAbility(XComGameState_Unit Unit, name Ability, optional bool bSearchAllAbilities = true)
{
	local array<SoldierClassAbilityType> EarnedAbilities;
	local SoldierClassAbilityType EarnedAbility;

	EarnedAbilities = Unit.GetEarnedSoldierAbilities();
	foreach EarnedAbilities(EarnedAbility)
	{
		if (EarnedAbility.AbilityName == Ability)
		{
			return true;
		}
	}

	if (bSearchAllAbilities)
	{
		if (Unit.FindAbility(Ability).ObjectID != 0)
		{
			return true;
		}
	}

	return false;
}

// Attempts to find a captured soldier that can be used as a mission reward. This
// checks for normal as well as Chosen captures and also checks that there isn't
// already a rescue mission for that soldier.
//
// If no such soldier can be found, this returns an empty reference, i.e. the `ObjectID`
// is zero.
static final function array<StateObjectReference> FindAvailableCapturedSoldiers(optional XComGameState NewGameState = none)
{
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_AdventChosen ChosenState;
	local StateObjectReference CapturedSoldierRef;
	local array<XComGameState_AdventChosen> AllChosen;
	local array<StateObjectReference> CapturedSoldiers;

	AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	AllChosen = AlienHQ.GetAllChosen();

	// First collect any soldiers captured "normally", i.e. not by the Chosen
	foreach AlienHQ.CapturedSoldiers(CapturedSoldierRef)
	{
		// Check whether the soldier is already attached as a mission or covert action reward
		if (!IsRescueMissionAvailableForSoldier(CapturedSoldierRef, NewGameState))
		{
			`LWTrace("[RescueSoldier] Captured soldier (normal) available for rescue " $ CapturedSoldierRef.ObjectID);
			CapturedSoldiers.AddItem(CapturedSoldierRef);
		}
	}

	// Now collect any soldiers captured by the Chosen
	foreach AllChosen(ChosenState)
	{
		foreach ChosenState.CapturedSoldiers(CapturedSoldierRef)
		{
			// Check whether the soldier is already attached as a mission or covert action reward
			if (!IsRescueMissionAvailableForSoldier(CapturedSoldierRef, NewGameState))
			{
				`LWTrace("[RescueSoldier] Captured soldier (Chosen - " $ ChosenState.GetMyTemplateName() $ ") available for rescue " $ CapturedSoldierRef.ObjectID);
				CapturedSoldiers.AddItem(CapturedSoldierRef);
			}
		}
	}

	return CapturedSoldiers;
}

// Determines whether a mission or covert action has spawned that has the
// given (captured) soldier as a reward. If there is such a mission or covert
// action, even one that is in progress, this returns `true`.
static final function bool IsRescueMissionAvailableForSoldier(StateObjectReference CapturedSoldierRef, optional XComGameState NewGameState = none)
{
	local XComGameStateHistory History;
	local XComGameState_ResistanceFaction FactionState;
	local XComGameState_MissionSite MissionState;
	local XComGameState_CovertAction ActionState;
	local XComGameState_Reward RewardState;
	local StateObjectReference StateRef;

	// Check whether there are any captured soldier rewards in the given
	// game state. This is needed for anything that can have multiple
	// captured soldiers as rewards because those rewards are generated
	// independently of one another and we want to make sure we don't
	// duplicate any of them.
	if (NewGameState != none)
	{
		foreach NewGameState.IterateByClassType(class'XComGameState_Reward', RewardState)
		{
			if (RewardState.RewardObjectReference.ObjectID == CapturedSoldierRef.ObjectID)
			{
				`LWTrace("[RescueSoldier] Found existing reward in new game state for captured soldier " $ CapturedSoldierRef.ObjectID);
				return true;
			}
		}
	}

	// Next check normal LWOTC missions to see whether any has the captured soldier
	// as a reward.
	History = `XCOMHISTORY;
	foreach History.IterateByClassType(class'XComGameState_MissionSite', MissionState)
	{
		foreach MissionState.Rewards(StateRef)
		{
			RewardState = XComGameState_Reward(History.GetGameStateForObjectID(StateRef.ObjectID));
			if (RewardState.RewardObjectReference.ObjectID == CapturedSoldierRef.ObjectID)
			{
				`LWTrace("[RescueSoldier] Found existing mission for captured soldier " $ CapturedSoldierRef.ObjectID);
				return true;
			}
		}
	}

	// No normal missions were found, so check the covert action that's currently running,
	// if there is one
	ActionState = class'XComGameState_HeadquartersResistance'.static.GetCurrentCovertAction();
	if (ActionState != none && CovertActionHasReward(ActionState, CapturedSoldierRef))
	{
		`LWTrace("[RescueSoldier] Currently active covert action is to rescue captured soldier " $ CapturedSoldierRef.ObjectID);
		return true;
	}

	// Finally check all available covert actions	
	foreach History.IterateByClassType(class'XComGameState_ResistanceFaction', FactionState)
	{
		foreach FactionState.CovertActions(StateRef)
		{
			ActionState = XComGameState_CovertAction(History.GetGameStateForObjectID(StateRef.ObjectID));
			if (ActionState != none && CovertActionHasReward(ActionState, CapturedSoldierRef))
			{
				`LWTrace("[RescueSoldier] Found existing covert action for rescuing captured soldier " $ CapturedSoldierRef.ObjectID);
				return true;
			}
		}
	}

	`LWTrace("[RescueSoldier] No existing rescue mission/covert action found for soldier " $ CapturedSoldierRef.ObjectID);
	return false;
}

// Determines whether the given covert action has the given reward
// attached. Returns true if the covert action does have that reward.
static final function bool CovertActionHasReward(XComGameState_CovertAction ActionState, StateObjectReference RewardRef)
{
	local XComGameStateHistory History;
	local XComGameState_Reward RewardState;
	local int i;

	History = `XCOMHISTORY;
	for (i = 0; i < ActionState.RewardRefs.Length; ++i)
	{
		RewardState = XComGameState_Reward(History.GetGameStateForObjectID(ActionState.RewardRefs[i].ObjectID));
		if (RewardState.RewardObjectReference.ObjectID == RewardRef.ObjectID)
			return true;
	}
}

// Modifies an ability to be a free action. This is not idempotent, so
// be careful calling it on an ability that is already a free action,
// since the behaviour may subtly change. For example if the original
// ability point cost is zero and free, that will change to 1 and free.
static final function MakeFreeAction(X2AbilityTemplate Template)
{
	local X2AbilityCost Cost;

	foreach Template.AbilityCosts(Cost)
	{
		if (Cost.IsA('X2AbilityCost_ActionPoints'))
		{
			X2AbilityCost_ActionPoints(Cost).iNumPoints = 1;
			X2AbilityCost_ActionPoints(Cost).bFreeCost = true;
			X2AbilityCost_ActionPoints(Cost).bConsumeAllPoints = false;
		}
	}
}

static final function RemoveAbilityTargetEffects(X2AbilityTemplate Template, name EffectClass)
{
	local int i;
	for (i = Template.AbilityTargetEffects.Length - 1; i >= 0; i--)
	{
		if (Template.AbilityTargetEffects[i].isA(EffectClass))
		{
			Template.AbilityTargetEffects.Remove(i, 1);
		}
	}
}

static final function RemoveAbilityShooterEffects(X2AbilityTemplate Template, name EffectClass)
{
	local int i;
	for (i = Template.AbilityShooterEffects.Length - 1; i >= 0; i--)
	{
		if (Template.AbilityShooterEffects[i].isA(EffectClass))
		{
			Template.AbilityShooterEffects.Remove(i, 1);
		}
	}
}

static final function RemoveAbilityShooterConditions(X2AbilityTemplate Template, name EffectClass)
{
	local int i;
	for (i = Template.AbilityShooterConditions.Length - 1; i >= 0; i--)
	{
		if (Template.AbilityShooterConditions[i].isA(EffectClass))
		{
			Template.AbilityShooterConditions.Remove(i, 1);
		}
	}
}

static final function RemoveAbilityTargetConditions(X2AbilityTemplate Template, name EffectClass)
{
	local int i;
	for (i = Template.AbilityTargetConditions.Length - 1; i >= 0; i--)
	{
		if (Template.AbilityTargetConditions[i].isA(EffectClass))
		{
			Template.AbilityTargetConditions.Remove(i, 1);
		}
	}
}

static final function RemoveAbilityMultiTargetEffects(X2AbilityTemplate Template, name EffectClass)
{
	local int i;
	for (i = Template.AbilityMultiTargetEffects.Length - 1; i >= 0; i--)
	{
		if (Template.AbilityMultiTargetEffects[i].isA(EffectClass))
		{
			Template.AbilityMultiTargetEffects.Remove(i, 1);
		}
	}
}

static final function bool AlwaysFail()
{
	return false;
}

/// Chosen region stuff.  Not currently implemented because it needs fixing.
/* 
static function SetLWChosenHomeAndTerritoryRegions(XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_HeadquartersAlien AlienHQ;
	local array<XComGameState_AdventChosen> AllChosen;
	local array<StateObjectReference> RemainingRegions, RemainingContinents;
	local XComGameState_MissionSite MissionState;
	local XComGameState_AdventChosen ChosenState;
	local XComGameState_WorldRegion RegionState;
	local XComGameState_Continent ContinentState;
	local StateObjectReference StartRef, BlacksiteRef, ForgeRef, PsiGateRef, StartingContinentRef;
	local int idx;

	// @mnauta - this function isn't really equipped to deal with more Chosen (from mods etc.)
	// If you want your to set your own territory regions, it's probably best to blast these and re-pick them

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));

	AlienHQ = XComGameState_HeadquartersAlien(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersAlien', AlienHQ.ObjectID));

	
	// Grab and add all Chosen in order
	for(idx = 0; idx < AlienHQ.AdventChosen.Length; idx++)
	{
		ChosenState = XComGameState_AdventChosen(NewGameState.ModifyStateObject(class'XComGameState_AdventChosen', AlienHQ.AdventChosen[idx].ObjectID));
		ChosenState.ControlledContinents.length = 0;
		ChosenState.TerritoryRegions.Length = 0;
		AllChosen.AddItem(ChosenState);
	}

	// Grab regions, list will shrink as they are assigned to chosen
	foreach History.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
	{
		RemainingRegions.AddItem(RegionState.GetReference());
	}

	// Grab Continents
	foreach History.IterateByClassType(class'XComGameState_Continent', ContinentState)
	{
		RemainingContinents.AddItem(ContinentState.GetReference());
	}

	// Grab Start Region and Continent
	StartRef = XComHQ.StartingRegion;
	RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(StartRef.ObjectID));
	StartingContinentRef = RegionState.GetContinent().GetReference();
	RemainingContinents.RemoveItem(StartingContinentRef);

	// Grab Golden Path Mission Regions
	foreach History.IterateByClassType(class'XComGameState_MissionSite', MissionState)
	{
		if(MissionState.Source == 'MissionSource_Blacksite')
		{
			BlacksiteRef = MissionState.Region;
		}
		else if(MissionState.Source == 'MissionSource_Forge')
		{
			ForgeRef = MissionState.Region;
		}
		else if(MissionState.Source == 'MissionSource_PsiGate')
		{
			PsiGateRef = MissionState.Region;
		}
	}

	// Set first Chosen continent and regions
	AllChosen[0].ControlledContinents.AddItem(StartingContinentRef);
	AllChosen[0].TerritoryRegions.AddItem(StartRef);
	RemainingRegions.RemoveItem(StartRef);
	AllChosen[0].TerritoryRegions.AddItem(BlacksiteRef);
	RemainingRegions.RemoveItem(BlacksiteRef);
	AllChosen[0].bOccupiesStartingContinent = true;
	SetChosenHomeRegion(AllChosen[0]);
	AllChosen[0].CreateStrongholdMission(NewGameState);

	// Second Chosen gets Forge continent and regions
	RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(ForgeRef.ObjectID));
	ContinentState = RegionState.GetContinent();
	AllChosen[1].ControlledContinents.AddItem(ContinentState.GetReference());
	RemainingContinents.RemoveItem(ContinentState.GetReference());
	ChosenGrabAllRemainingContinentRegions(ContinentState, AllChosen[1], RemainingRegions);

	// Third Chosen gets Psi Gate continent and regions
	RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(PsiGateRef.ObjectID));
	ContinentState = RegionState.GetContinent();
	AllChosen[2].ControlledContinents.AddItem(ContinentState.GetReference());
	RemainingContinents.RemoveItem(ContinentState.GetReference());
	ChosenGrabAllRemainingContinentRegions(ContinentState, AllChosen[2], RemainingRegions);

	// Pick the rest of the regions and continents
	while(RemainingRegions.Length > 0)
	{
		NextChosenPickRegions(AllChosen[1], AllChosen[2], StartingContinentRef, RemainingRegions, RemainingContinents);
	}

	ContinentState = XComGameState_Continent(History.GetGameStateForObjectID(StartingContinentRef.ObjectID));
	SetChosenHomeRegion(AllChosen[1], ContinentState);
	AllChosen[1].CreateStrongholdMission(NewGameState);
	SetChosenHomeRegion(AllChosen[2], ContinentState);
	AllChosen[2].CreateStrongholdMission(NewGameState);
}

//---------------------------------------------------------------------------------------
private static function NextChosenPickRegions(out XComGameState_AdventChosen ChosenStateA, out XComGameState_AdventChosen ChosenStateB,
									   StateObjectReference StartingContinentRef, out array<StateObjectReference> RemainingRegions, out array<StateObjectReference> RemainingContinents)
{
	local XComGameStateHistory History;
	local XComGameState_AdventChosen ChosenState;
	local XComGameState_Continent ContinentState;
	local array<StateObjectReference> ChosenLinkedContinents, OtherChosenLinkedContinents, PreferredContinents, TempLinkedContinents;
	local StateObjectReference ContinentRef;
	local bool bPickedA, bForceStartingRegion;
	local int NumControlledA, NumControlledB;

	History = `XCOMHISTORY;
	bForceStartingRegion = false;
	NumControlledA = ChosenStateA.ControlledContinents.Length;
	NumControlledB = ChosenStateB.ControlledContinents.Length;

	if(ChosenStateA.bOccupiesStartingContinent)
	{
		NumControlledA++;
	}
	else if(ChosenStateB.bOccupiesStartingContinent)
	{
		NumControlledB++;
	}

	if(NumControlledA < NumControlledB)
	{
		ChosenState = ChosenStateA;
		ChosenLinkedContinents = GetChosenLinkedContinentsWithAvailableRegions(ChosenStateA, StartingContinentRef, RemainingRegions, RemainingContinents);
		OtherChosenLinkedContinents = GetChosenLinkedContinentsWithAvailableRegions(ChosenStateB, StartingContinentRef, RemainingRegions, RemainingContinents);
		bPickedA = true;
	}
	else if(NumControlledA > NumControlledB)
	{
		ChosenState = ChosenStateB;
		ChosenLinkedContinents = GetChosenLinkedContinentsWithAvailableRegions(ChosenStateB, StartingContinentRef, RemainingRegions, RemainingContinents);
		OtherChosenLinkedContinents = GetChosenLinkedContinentsWithAvailableRegions(ChosenStateA, StartingContinentRef, RemainingRegions, RemainingContinents);
		bPickedA = false;
	}
	else
	{
		ChosenState = ChosenStateA;
		ChosenLinkedContinents = GetChosenLinkedContinentsWithAvailableRegions(ChosenStateA, StartingContinentRef, RemainingRegions, RemainingContinents);
		OtherChosenLinkedContinents = GetChosenLinkedContinentsWithAvailableRegions(ChosenStateB, StartingContinentRef, RemainingRegions, RemainingContinents);
		bPickedA = true;

		if(ChosenLinkedContinents.Length == 0)
		{
			if(OtherChosenLinkedContinents.Length == 0)
			{
				if(RemainingContinents.Length > 0)
				{
					ChosenLinkedContinents = RemainingContinents;
				}
				else
				{
					bForceStartingRegion = true;
				}
			}
			else
			{
				TempLinkedContinents = ChosenLinkedContinents;
				ChosenLinkedContinents = OtherChosenLinkedContinents;
				OtherChosenLinkedContinents = TempLinkedContinents;

				ChosenState = ChosenStateB;
				bPickedA = false;

			}
		}
	}

	if(ChosenLinkedContinents.Length == 0)
	{
		if(RemainingContinents.Length > 0)
		{
			ChosenLinkedContinents = RemainingContinents;
		}
		else
		{
			bForceStartingRegion = true;
		}
	}

	if(ChosenLinkedContinents.Find('ObjectID', StartingContinentRef.ObjectID) != INDEX_NONE || bForceStartingRegion)
	{
		// Always pick starting continent if it's linked
		ContinentState = XComGameState_Continent(History.GetGameStateForObjectID(StartingContinentRef.ObjectID));
		ChosenGrabAllRemainingContinentRegions(ContinentState, ChosenState, RemainingRegions);
		ChosenState.bOccupiesStartingContinent = true;
	}
	else
	{
		PreferredContinents = ChosenLinkedContinents;

		foreach OtherChosenLinkedContinents(ContinentRef)
		{
			PreferredContinents.RemoveItem(ContinentRef);
		}

		if(PreferredContinents.Length > 0)
		{
			ContinentRef = PreferredContinents[`SYNC_RAND(PreferredContinents.Length)];
		}
		else
		{
			ContinentRef = ChosenLinkedContinents[`SYNC_RAND(ChosenLinkedContinents.Length)];
		}

		ChosenState.ControlledContinents.AddItem(ContinentRef);
		RemainingContinents.RemoveItem(ContinentRef);
		ContinentState = XComGameState_Continent(History.GetGameStateForObjectID(ContinentRef.ObjectID));
		ChosenGrabAllRemainingContinentRegions(ContinentState, ChosenState, RemainingRegions);
	}

	if(bPickedA)
	{
		ChosenStateA = ChosenState;
	}
	else
	{
		ChosenStateB = ChosenState;
	}
}

//---------------------------------------------------------------------------------------
private static function array<StateObjectReference> GetChosenLinkedContinentsWithAvailableRegions(XComGameState_AdventChosen ChosenState, StateObjectReference StartingContinentRef, 
																						   array<StateObjectReference> RemainingRegions, array<StateObjectReference> RemainingContinents)
{
	local XComGameStateHistory History;
	local XComGameState_WorldRegion RegionState, LinkedRegionState;
	local array<StateObjectReference> LinkedContinents;
	local StateObjectReference RegionRef, LinkedRegionRef;

	History = `XCOMHISTORY;
	LinkedContinents.Length = 0;

	foreach ChosenState.TerritoryRegions(RegionRef)
	{
		RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(RegionRef.ObjectID));

		foreach RegionState.LinkedRegions(LinkedRegionRef)
		{
			if(RemainingRegions.Find('ObjectID', LinkedRegionRef.ObjectID) != INDEX_NONE)
			{
				LinkedRegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(LinkedRegionRef.ObjectID));

				if(LinkedContinents.Find('ObjectID', LinkedRegionState.Continent.ObjectID) == INDEX_NONE && 
				   (RemainingContinents.Find('ObjectID', LinkedRegionState.Continent.ObjectID) != INDEX_NONE ||
				   LinkedRegionState.Continent == StartingContinentRef))
				{
					LinkedContinents.AddItem(LinkedRegionState.Continent);
				}
			}
		}
	}

	return LinkedContinents;
}

//---------------------------------------------------------------------------------------
private static function ChosenGrabAllRemainingContinentRegions(XComGameState_Continent ContinentState, out XComGameState_AdventChosen ChosenState, out array<StateObjectReference> RemainingRegions)
{
	local StateObjectReference RegionRef;

	foreach ContinentState.Regions(RegionRef)
	{
		if(RemainingRegions.Find('ObjectID', RegionRef.ObjectID) != INDEX_NONE)
		{
			ChosenState.TerritoryRegions.AddItem(RegionRef);
			RemainingRegions.RemoveItem(RegionRef);
		}
	}
}

//---------------------------------------------------------------------------------------
private static function SetChosenHomeRegion(out XComGameState_AdventChosen ChosenState, optional XComGameState_Continent AvoidContinent)
{
	local array<StateObjectReference> ValidRegions;
	local StateObjectReference RegionRef;

	ValidRegions = ChosenState.TerritoryRegions;

	if(AvoidContinent != none)
	{
		foreach AvoidContinent.Regions(RegionRef)
		{
			ValidRegions.RemoveItem(RegionRef);
		}
	}

	ChosenState.HomeRegion = ValidRegions[`SYNC_RAND(ValidRegions.Length)];
	ChosenState.ChooseLocation(); // Choose a location for their Geoscape icon now that they have a Home Region
}

//---------------------------------------------------------------------------------------
private static function array<XComGameState_WorldRegion> GetRemainingRegionStates(array<StateObjectReference> RemainingRegions)
{
	local XComGameStateHistory History;
	local array<XComGameState_WorldRegion> RemainingRegionStates;
	local XComGameState_WorldRegion RegionState;
	local StateObjectReference RegionRef;

	History = `XCOMHISTORY;
	RemainingRegionStates.Length = 0;

	foreach RemainingRegions(RegionRef)
	{
		RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(RegionRef.ObjectID));
		RemainingRegionStates.AddItem(RegionState);
	}

	return RemainingRegionStates;
}
*/

// Taken from CI to better check geoscape things
static function bool GeoscapeReadyForUpdate()
{
	local UIStrategyMap StrategyMap;

	StrategyMap = `HQPRES.StrategyMap2D;

	return
		StrategyMap != none &&
		StrategyMap.m_eUIState != eSMS_Flight &&
		StrategyMap.Movie.Pres.ScreenStack.GetCurrentScreen() == StrategyMap;
}

defaultproperties
{
	CHOSEN_SPAWN_TAG_SUFFIX="_LWOTC_ChosenTag"
}
