//---------------------------------------------------------------------------------------
//  FILE:    X2Character_Resistance.uc
//  AUTHOR:  tracktwo / Pavonis Interactive
//  PURPOSE: Templates for Resistance outpost characters.
//---------------------------------------------------------------------------------------

class X2Character_Resistance extends X2Character;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

	`LWTrace("  >> X2Character_Resistance.CreateTemplates()");
	
    // Various templates for unarmed rebels (retaliations, jailbreaks)
    Templates.AddItem(CreateRebel());
    Templates.AddItem(CreateFacelessRebel());
    Templates.AddItem(CreateFacelessRebelProxy());

    // Rebel proxies for armed rebels - levels 1, 2, and 3.
    Templates.AddItem(CreateRebelSoldierProxy());
    Templates.AddItem(CreateRebelSoldierProxyM2());
    Templates.AddItem(CreateRebelSoldierProxyM3());

    // Resitance MECs
    Templates.AddItem(CreateResistanceMEC());

    return Templates;
}


static function X2CharacterTemplate CreateRebel(optional name TemplateName = 'Rebel')
{
	local X2CharacterTemplate CharTemplate;
	
	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.UnitSize = 1;
	CharTemplate.BehaviorClass = class'XGAIBehavior_Civilian';
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
    // Note: different from 'Civilian': rebels can dropdown. Needed to allow controllable rebels to move appropriately in some
    // retaliation maps. Failure to dropdown means they need to take roundabout ways to some areas.
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = false;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bAppearanceDefinesPawn = true;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bIsAlien = false;
	CharTemplate.bIsCivilian = true;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bCanTakeCover = true;
	CharTemplate.bDisplayUIUnitFlag=false;
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_XComCivilians.ARC_Unit_XComCivilianUnisex");
	// WOTC TODO: Can't find an alternative to GetPhotographerPawnNameFn
    // CharTemplate.GetPhotographerPawnNameFn = EmptyPawnName;

	CharTemplate.Abilities.AddItem('Evac');
	CharTemplate.Abilities.AddItem('HunkerDown');
	CharTemplate.Abilities.AddItem('CivilianInitialState');
	CharTemplate.Abilities.AddItem('CivilianEasyToHit');
	CharTemplate.Abilities.AddItem('CivilianRescuedState');
	CharTemplate.strBehaviorTree="CivRoot";

	CharTemplate.bShouldCreateDifficultyVariants = false;

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Civilian;
	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator';

	return CharTemplate;
}

// The FacelessRebel template is used for rebels in outposts in the strategic game. They are generally
// not used in tactical missions. When a faceless rebel is placed in a mission a proxy unit is generated
// and placed on the map instead. 
//
// The reason for this is primarily because we need to treat the tactical faceless rebels as bIsAlien=true
// for certain mechanics to work (prevent ADVENT from shooting faceless civs during retaliations, etc). But
// making them bIsAlien=true has a bizarre side-effect with the strategy photographer skewing their images.
// So the 'FaclessRebel' template is used in strategy with bIsAlien=false, and the 'FacelessRebelProxy' used
// in tactical with bIsAlien=true.
//
// For missions where faceless rebels should be indistinguishable from regular rebels (e.g. jailbreaks where
// we don't want faceless to expose themselves, even if they do something silly like run an overwatch and get
// shot, or accidentally caught on fire) they can be created with a proxy unit with the normal Rebel template.
static function X2CharacterTemplate CreateFacelessRebel(optional name TemplateName = 'FacelessRebel')
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;
	
	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.UnitSize = 1;
	CharTemplate.BehaviorClass = class'XGAIBehavior_Civilian';
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = false;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bAppearanceDefinesPawn = true;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bIsAlien = false;
	CharTemplate.bIsCivilian = true;
	//CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bCanTakeCover = true;
	CharTemplate.bDisplayUIUnitFlag=false;
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_XComCivilians.ARC_Unit_XComCivilianUnisex");
	// WOTC TODO: Can't find an alternative to GetPhotographerPawnNameFn
    // CharTemplate.GetPhotographerPawnNameFn = EmptyPawnName;

	CharTemplate.Abilities.AddItem('HunkerDown');
	CharTemplate.Abilities.AddItem('CivilianInitialState');

	// Drop a faceless corpse on death
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'Faceless_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	CharTemplate.strBehaviorTree="FacelessCivRoot";
	CharTemplate.strPanicBT = "";

	CharTemplate.bShouldCreateDifficultyVariants = false;

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Civilian;
	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator';

	return CharTemplate;
}

// Force the pawn name for photography for rebels and rebel faceless to to an empty name.
// Ideally, we'd use this mechanism to give the correct pawn name for the rebels, but it was
// added for DLC3 in a way that isn't very extensible: SPARKS are genderless, so they always use
// the same pawn name. Rebels are not, so we'd want to return the correct _M or _F pawn for this
// rebel/faceless, but we can't determine which one to use as we get no arguments passed for us
// to be able to know what rebel we're getting a pawn name for.
//
// Returning '' works, in a roundabout way. By having this delegate set, we avoid the logic in 
// XComPhotographer_Strategy.CreateUnitPawn() that forces the pawn to the soldier pawn. This works
// because if the pawn is the empty name, the correct pawn name will be looked up from the torso
// of the unit (see X2CharacterTemplate.GetPawnArchetypeString). This is a legacy codepath where
// the torso defines the pawn, but it works.
//
// This is needed because if we don't override this setting the photographer will set the pawn
// for rebels/faceless to soldier, and this doesn't get reset after the picture is taken. So if
// you start a retaliation/jailbreak/etc after viewing the rebel photos in the outpost management
// ui, they'll all load in-mission with soldier pawns. This causes two bugs: the rescued civvies
// all use the soldier animations, so they use the idle animations where they hold invisible guns
// (since rebels have no equipment) and triggering a faceless to transform causes a redscreen and doesn't
// show the transform matinee because the soldier animset lacks the transform animation: only civvie 
// animsets have that.
static function name EmptyPawnName()
{
    return '';
}

// Proxy unit for faceless rebels in tactical games.
static function X2CharacterTemplate CreateFacelessRebelProxy(optional name TemplateName = 'FacelessRebelProxy')
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;
	
	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.UnitSize = 1;
	CharTemplate.BehaviorClass = class'XGAIBehavior_Civilian';
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = false;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bAppearanceDefinesPawn = true;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bIsAlien = true;
	CharTemplate.bIsCivilian = true;
	//CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bCanTakeCover = true;
	CharTemplate.bDisplayUIUnitFlag=false;
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_XComCivilians.ARC_Unit_XComCivilianUnisex");

	// Use the custom rebel change form ability instead of the civilian 'ChangeForm'. This version
    // does not trigger on a unit death to reveal if there aren't any aliens left on map.
	CharTemplate.Abilities.AddItem('RebelChangeForm');
	CharTemplate.Abilities.AddItem('HunkerDown');
	CharTemplate.Abilities.AddItem('CivilianInitialState');

	CharTemplate.strBehaviorTree="FacelessCivRoot";
	CharTemplate.strPanicBT = "";

	// Drop a faceless corpse on death
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'Faceless_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	CharTemplate.bShouldCreateDifficultyVariants = false;

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Civilian;
	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator';

	return CharTemplate;
}

// Proxy unit for rebels acting as soldiers in special mission types
static function X2CharacterTemplate CreateRebelSoldierProxy(optional name TemplateName = 'RebelSoldierProxy')
{
	local X2CharacterTemplate CharTemplate;
	
	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.UnitSize = 1;
	CharTemplate.BehaviorClass = class'XGAIBehavior';
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bAppearanceDefinesPawn = true;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bIsAlien = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = true;
	CharTemplate.bCanTakeCover = true;
	CharTemplate.bDisplayUIUnitFlag= true;
    CharTemplate.strIntroMatineeSlotPrefix="Char";
    CharTemplate.strLoadingMatineeSlotPrefix="Soldier";

    CharTemplate.DefaultSoldierClass = 'LWS_RebelSoldier';
	CharTemplate.DefaultLoadout = 'RebelSoldier';
	CharTemplate.RequiredLoadout = '';

    CharTemplate.strPawnArchetypes.AddItem("GameUnit_XComSoldier.ARC_Soldier_M");
    CharTemplate.strPawnArchetypes.AddItem("GameUnit_XComSoldier.ARC_Soldier_F");

    CharTemplate.Abilities.AddItem('Evac');
	CharTemplate.Abilities.AddItem('Panicked');
	CharTemplate.Abilities.AddItem('HunkerDown');
	CharTemplate.Abilities.AddItem('Loot');

	CharTemplate.strPanicBT = "";

	CharTemplate.bShouldCreateDifficultyVariants = false;

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Civilian;
	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator';

	return CharTemplate;
}

// Proxy unit for rebels acting as soldiers in special mission types (level 2 rebels)
static function X2CharacterTemplate CreateRebelSoldierProxyM2(optional name TemplateName = 'RebelSoldierProxyM2')
{
	local X2CharacterTemplate CharTemplate;
	
	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.UnitSize = 1;
	CharTemplate.BehaviorClass = class'XGAIBehavior';
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bAppearanceDefinesPawn = true;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bIsAlien = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = true;
	CharTemplate.bCanTakeCover = true;
	CharTemplate.bDisplayUIUnitFlag= true;
    CharTemplate.strIntroMatineeSlotPrefix="Char";
    CharTemplate.strLoadingMatineeSlotPrefix="Soldier";

    CharTemplate.DefaultSoldierClass = 'LWS_RebelSoldier';
	CharTemplate.DefaultLoadout = 'RebelSoldier';
	CharTemplate.RequiredLoadout = '';

    CharTemplate.strPawnArchetypes.AddItem("GameUnit_XComSoldier.ARC_Soldier_M");
    CharTemplate.strPawnArchetypes.AddItem("GameUnit_XComSoldier.ARC_Soldier_F");

    CharTemplate.Abilities.AddItem('Evac');
	CharTemplate.Abilities.AddItem('Panicked');
	CharTemplate.Abilities.AddItem('HunkerDown');
	CharTemplate.Abilities.AddItem('Loot');

	CharTemplate.strPanicBT = "";

	CharTemplate.bShouldCreateDifficultyVariants = false;

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Civilian;
	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator';

	return CharTemplate;
}

// Proxy unit for rebels acting as soldiers in special mission types (level 3 rebels)
static function X2CharacterTemplate CreateRebelSoldierProxyM3(optional name TemplateName = 'RebelSoldierProxyM3')
{
	local X2CharacterTemplate CharTemplate;
	
	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.UnitSize = 1;
	CharTemplate.BehaviorClass = class'XGAIBehavior';
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bAppearanceDefinesPawn = true;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bIsAlien = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = true;
	CharTemplate.bCanTakeCover = true;
	CharTemplate.bDisplayUIUnitFlag= true;
    CharTemplate.strIntroMatineeSlotPrefix="Char";
    CharTemplate.strLoadingMatineeSlotPrefix="Soldier";

    CharTemplate.DefaultSoldierClass = 'LWS_RebelSoldier';
	CharTemplate.DefaultLoadout = 'RebelSoldier';
	CharTemplate.RequiredLoadout = '';

    CharTemplate.strPawnArchetypes.AddItem("GameUnit_XComSoldier.ARC_Soldier_M");
    CharTemplate.strPawnArchetypes.AddItem("GameUnit_XComSoldier.ARC_Soldier_F");

    CharTemplate.Abilities.AddItem('Evac');
	CharTemplate.Abilities.AddItem('Panicked');
	CharTemplate.Abilities.AddItem('HunkerDown');
	CharTemplate.Abilities.AddItem('Loot');

	CharTemplate.strPanicBT = "";

	CharTemplate.bShouldCreateDifficultyVariants = false;

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Civilian;
	CharTemplate.CharacterGeneratorClass = class'XGCharacterGenerator';

	return CharTemplate;
}


static function X2CharacterTemplate CreateResistanceMEC()
{
    local X2CharacterTemplate CharTemplate;
    
    `CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'ResistanceMEC');
    CharTemplate.DefaultLoadout='ResistanceMecM1_Loadout';
    CharTemplate.strPawnArchetypes.AddItem("LWResistanceMEC.Archetypes.GameUnit_ResistanceMecM1");
    CharTemplate.UnitSize = 1;

    // Traversal Rules
    CharTemplate.bCanUse_eTraversal_Normal = true;
    CharTemplate.bCanUse_eTraversal_ClimbOver = true;
    CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
    CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
    CharTemplate.bCanUse_eTraversal_DropDown = true;
    CharTemplate.bCanUse_eTraversal_Grapple = false;
    CharTemplate.bCanUse_eTraversal_Landing = true;
    CharTemplate.bCanUse_eTraversal_BreakWindow = true;
    CharTemplate.bCanUse_eTraversal_KickDoor = true;
    CharTemplate.bCanUse_eTraversal_JumpUp = true;
    CharTemplate.bCanUse_eTraversal_WallClimb = false;
    CharTemplate.bCanUse_eTraversal_BreakWall = false;
    CharTemplate.bAppearanceDefinesPawn = false; 
    CharTemplate.bCanTakeCover = false;

    CharTemplate.bIsAlien = false;
    CharTemplate.bIsAdvent = false;
    CharTemplate.bIsCivilian = false;
    CharTemplate.bIsPsionic = false;
    CharTemplate.bIsRobotic = true;
    CharTemplate.bIsSoldier = false;

    CharTemplate.bCanBeTerrorist = false;
    CharTemplate.bCanBeCriticallyWounded = false;
    CharTemplate.bIsAfraidOfFire = false;

    CharTemplate.Abilities.AddItem('RobotImmunities');
	CharTemplate.Abilities.AddItem('Evac');

    CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_robot_icon";
    CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

    return CharTemplate;
}

