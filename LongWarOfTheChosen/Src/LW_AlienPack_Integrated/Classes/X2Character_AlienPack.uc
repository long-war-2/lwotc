//--------------------------------------------------------------------------------------- 
//  FILE:    X2Character_AlienPack
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Configured character templates for all AlienPack aliens
//--------------------------------------------------------------------------------------- 
class X2Character_AlienPack extends X2Character config(LW_AlienPack);

//struct AIJobInfo_Addition
//{
	//var Name JobName;						// Name of this job.
	//var Name Preceding;						// Name of unit before current in the list, if any
	//var Name Succeeding;					// Name of unit after current in the list, if any
	//var int DefaultPosition;				// Default index to insert at if cannot find based on name
//};

//var config array<AIJobInfo_Addition> JobListingAdditions; // Definition of qualifications for each job for this new character

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	`LWTrace("  >> X2Character_AlienPack.CreateTemplates()");
	
	Templates.AddItem(CreateTemplate_MutonCenturion('MutonM2_LW'));
	Templates.AddItem(CreateTemplate_MutonCenturion('MutonM3_LW'));
	Templates.AddItem(CreateTemplate_MutonElite_LW('MutonM4_LW'));
	Templates.AddItem(CreateTemplate_MutonElite_LW('MutonM5_LW'));

	Templates.AddItem(CreateTemplate_Naja('NajaM1'));
	Templates.AddItem(CreateTemplate_Naja('NajaM2'));
	Templates.AddItem(CreateTemplate_Naja('NajaM3'));

	Templates.AddItem(CreateTemplate_Sidewinder('SidewinderM1'));
	Templates.AddItem(CreateTemplate_Sidewinder('SidewinderM2'));
	Templates.AddItem(CreateTemplate_Sidewinder('SidewinderM3'));
	Templates.AddItem(CreateTemplate_Sidewinder('SidewinderM4'));
	Templates.AddItem(CreateTemplate_Sidewinder('SidewinderM5'));

	Templates.AddItem(CreateTemplate_Viper_LW('ViperM2_LW'));
	Templates.AddItem(CreateTemplate_Viper_LW('ViperM3_LW'));
	Templates.AddItem(CreateTemplate_Viper_LW('ViperM4_LW'));
	Templates.AddItem(CreateTemplate_Viper_LW('ViperM5_LW'));

	Templates.AddItem(CreateTemplate_Archon_LW('ArchonM2_LW'));
	Templates.AddItem(CreateTemplate_Archon_LW('ArchonM3_LW'));
	//Templates.AddItem(CreateTemplate_Archon_LW('ArchonM4_LW'));

	Templates.AddItem(CreateTemplate_Sectoid('SectoidM2_LW'));

	Templates.AddItem(CreateTemplate_Sectoid_LW('SectoidM3_LW'));
	Templates.AddItem(CreateTemplate_Sectoid_LW('SectoidM4_LW'));
	Templates.AddItem(CreateTemplate_Sectoid_LW('SectoidM5_LW'));

	Templates.AddItem(CreateTemplate_AdvGunner('AdvGunnerM1'));
	Templates.AddItem(CreateTemplate_AdvGunner('AdvGunnerM2'));
	Templates.AddItem(CreateTemplate_AdvGunner('AdvGunnerM3'));
	Templates.AddItem(CreateTemplate_AdvGunner('AdvGunnerM4'));
	Templates.AddItem(CreateTemplate_AdvGunner('AdvGunnerM5'));

	Templates.AddItem(CreateTemplate_AdvSentry('AdvSentryM1'));
	Templates.AddItem(CreateTemplate_AdvSentry('AdvSentryM2'));
	Templates.AddItem(CreateTemplate_AdvSentry('AdvSentryM3'));
	Templates.AddItem(CreateTemplate_AdvSentry('AdvSentryM4'));
	Templates.AddItem(CreateTemplate_AdvSentry('AdvSentryM5'));

	Templates.AddItem(CreateTemplate_AdvGrenadier('AdvGrenadierM1'));
	Templates.AddItem(CreateTemplate_AdvGrenadier('AdvGrenadierM2'));
	Templates.AddItem(CreateTemplate_AdvGrenadier('AdvGrenadierM3'));

	Templates.AddItem(CreateTemplate_AdvRocketeer('AdvRocketeerM1'));
	Templates.AddItem(CreateTemplate_AdvRocketeer('AdvRocketeerM2'));
	Templates.AddItem(CreateTemplate_AdvRocketeer('AdvRocketeerM3'));
	
	Templates.AddItem(CreateTemplate_AdvMec_LW('AdvMec_M3_LW'));
	Templates.AddItem(CreateTemplate_AdvMec_LW('AdvMec_M4_LW'));
	Templates.AddItem(CreateTemplate_AdvMec_LW('AdvMec_M5_LW'));

	Templates.AddItem(CreateTemplate_AdvMECArcher('AdvMECArcherM1'));
	Templates.AddItem(CreateTemplate_AdvMECArcher('AdvMECArcherM2'));

	Templates.AddItem(CreateTemplate_Drone('LWDroneM1'));
	Templates.AddItem(CreateTemplate_Drone('LWDroneM2'));
	Templates.AddItem(CreateTemplate_Drone('LWDroneM3'));
	Templates.AddItem(CreateTemplate_Drone('LWDroneM4'));
	Templates.AddItem(CreateTemplate_Drone('LWDroneM5'));

	Templates.AddItem(CreateTemplate_Chryssalid('Chryssalid'));
	Templates.AddItem(CreateTemplate_Chryssalid('ChryssalidM2'));
	Templates.AddItem(CreateTemplate_Chryssalid('ChryssalidM3'));
	Templates.AddItem(CreateTemplate_Chryssalid('ChryssalidM4'));

	Templates.AddItem(CreateTemplate_Andromedon('AndromedonM2'));
	Templates.AddItem(CreateTemplate_Andromedon('AndromedonM2'));
	Templates.AddItem(CreateTemplate_AndromedonRobot('AndromedonRobotM2'));
	Templates.AddItem(CreateTemplate_AndromedonRobot('AndromedonRobotM3'));

	Templates.AddItem(CreateTemplate_Spectre('SpectreM3'));
	Templates.AddItem(class'X2Character_DefaultCharacters'.static.CreateTemplate_ShadowbindUnit('ShadowbindUnitM3'));

	Templates.AddItem(class'X2Character_DefaultCharacters'.static.CreateTemplate_PsiZombie('PsiZombieM2'));
	Templates.AddItem(class'X2Character_DefaultCharacters'.static.CreateTemplate_PsiZombie('PsiZombieM3'));
	Templates.AddItem(class'X2Character_DefaultCharacters'.static.CreateTemplate_PsiZombie('PsiZombieM4'));
	Templates.AddItem(class'X2Character_DefaultCharacters'.static.CreateTemplate_PsiZombie('PsiZombieM5'));

	Templates.AddItem(CreateTemplate_PsiZombieHuman('PsiZombieHumanM2'));
	Templates.AddItem(CreateTemplate_PsiZombieHuman('PsiZombieHumanM3'));
	Templates.AddItem(CreateTemplate_PsiZombieHuman('PsiZombieHumanM4'));
	Templates.AddItem(CreateTemplate_PsiZombieHuman('PsiZombieHumanM5'));

	Templates.AddItem(CreateTemplate_Sectopod('SectopodM2'));
	Templates.AddItem(CreateTemplate_Sectopod('SectopodM3'));

	Templates.AddItem(CreateTemplate_Gatekeeper('GatekeeperM2'));
	Templates.AddItem(CreateTemplate_Gatekeeper('GatekeeperM3'));

	Templates.Additem(CreateTemplate_ChryssalidSoldier());
	Templates.AddItem(CreateTemplate_HiveQueen());
	
	Templates.AddItem(CreateTemplate_AdvGeneric('AdvTrooperM4'));
	Templates.AddItem(CreateTemplate_AdvGeneric('AdvTrooperM5'));

	Templates.AddItem(CreateTemplate_AdvGeneric('AdvCaptainM4'));
	Templates.AddItem(CreateTemplate_AdvGeneric('AdvCaptainM5'));

	Templates.AddItem(CreateTemplate_Berserker('BerserkerM2'));
	Templates.AddItem(CreateTemplate_Berserker('BerserkerM3'));
	Templates.AddItem(CreateTemplate_Berserker('BerserkerM4'));

	Templates.AddItem(CreateTemplate_AdvShieldBearer('AdvShieldBearerM4'));
	Templates.AddItem(CreateTemplate_AdvShieldBearer('AdvShieldBearerM5'));

	Templates.AddItem(CreateTemplate_AdvStunLancer('AdvStunLancerM4'));
	Templates.AddItem(CreateTemplate_AdvStunLancer('AdvStunLancerM5'));
	Templates.AddItem(CreateTemplate_AdvPriest('AdvPriestM4'));
	Templates.AddItem(CreateTemplate_AdvPriest('AdvPriestM5'));

	Templates.AddItem(CreateTemplate_AdvPurifier('AdvPurifierM4'));
	Templates.AddItem(CreateTemplate_AdvPurifier('AdvPurifierM5'));

	
	
	
	Templates.AddItem(CreateTemplate_AdvGeneric('AdvGeneralM1_LW'));
	Templates.AddItem(CreateTemplate_AdvGeneric('AdvGeneralM2_LW'));

	Templates.AddItem(CreateTemplate_AdvGeneric('AdvSergeantM1'));
	Templates.AddItem(CreateTemplate_AdvGeneric('AdvSergeantM2'));
	Templates.AddItem(CreateTemplate_AdvGeneric('AdvCommando'));
	Templates.AddItem(CreateTemplate_AdvGeneric('AdvShockTroop'));
	Templates.AddItem(CreateTemplate_AdvGeneric('AdvScout'));
	Templates.AddItem(CreateTemplate_AdvGeneric('AdvVanguard'));


	
	return Templates;
}

static function X2CharacterTemplate CreateTemplate_MutonCenturion(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);

	Loot.ForceLevel = 0;
	if (TemplateName == 'MutonM2_LW')
	{
		CharTemplate.DefaultLoadout='MutonM2_LW_Loadout';
		Loot.LootTableName = 'GenericMidAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericMidAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}
	if (TemplateName == 'MutonM3_LW')
	{
		CharTemplate.DefaultLoadout='MutonM3_LW_Loadout';
		Loot.LootTableName = 'GenericMidAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericMidAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}

	CharTemplate.CharacterGroupName = 'Muton';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("LWMutonM2.ARC_GameUnit_MutonM2"); 
	Loot.ForceLevel=0;
	Loot.LootTableName='Muton_BaseLoot'; 
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	//CharTemplate.strMatineePackage = "CIN_Muton"; 
	CharTemplate.strMatineePackages.AddItem("CIN_Muton"); //update with new cinematic?

	CharTemplate.UnitSize = 1;
	// Traversal Rules -- same as base Muton
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
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.Abilities.AddItem('CounterattackPreparation');
	CharTemplate.Abilities.AddItem('CounterattackDescription');
	//CharTemplate.Abilities.AddItem('WarCry');
	//CharTemplate.Abilities.AddItem('Beastmaster_LW');
	// WOTC abilities
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;
	//CharTemplate.strBehaviorTree = "MutonM2_LWRoot";  // new config behavior tree parsing means we could use the group instead

	//probably keep cinematic intro, since it's a lot of work to create a new one -- alternatively no cinematic intro for tier 2
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_Muton');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}


static function X2CharacterTemplate CreateTemplate_MutonM2_Dummy()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'MutonM2');
	CharTemplate.CharacterGroupName = 'Muton';
	CharTemplate.DefaultLoadout='MutonM2_LW_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("LWMutonM2.ARC_GameUnit_MutonM2"); 
	Loot.ForceLevel=0;
	Loot.LootTableName='Muton_BaseLoot'; 
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'GenericMidAlienLoot_LW'; 
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);

	Loot.LootTableName = 'GenericMidAlienVultureLoot_LW';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	//CharTemplate.strMatineePackage = "CIN_Muton"; 
	CharTemplate.strMatineePackages.AddItem("CIN_Muton"); //update with new cinematic?

	CharTemplate.UnitSize = 1;
	// Traversal Rules -- same as base Muton
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
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.Abilities.AddItem('CounterattackPreparation');
	CharTemplate.Abilities.AddItem('CounterattackDescription');
	CharTemplate.Abilities.AddItem('WarCry');
	//CharTemplate.Abilities.AddItem('Beastmaster_LW');
	// WOTC abilities
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;
	CharTemplate.strBehaviorTree = "MutonM2_LWRoot";  // new config behavior tree parsing means we could use the group instead

	//probably keep cinematic intro, since it's a lot of work to create a new one -- alternatively no cinematic intro for tier 2
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_Muton');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_MutonElite_LW(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'Muton';
	CharTemplate.DefaultLoadout='MutonM3_LW_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("LWMutonM3.Archetypes.ARC_GameUnit_MutonM3"); // SCRUBBED AFTER S&R

	Loot.ForceLevel=0;
	Loot.LootTableName='MutonM3_BaseLoot';  
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'MutonM3_TimedLoot';  
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);

	Loot.LootTableName = 'MutonM3_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);


	if (TemplateName == 'MutonM4_LW')
	{
		CharTemplate.DefaultLoadout='Muton4_LW_Loadout';
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}
	if (TemplateName == 'MutonM5_LW')
	{
		CharTemplate.DefaultLoadout='MutonM5_LW_Loadout';
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}


	CharTemplate.strMatineePackages.AddItem("CIN_Muton");

	CharTemplate.UnitSize = 1;
	// Traversal Rules -- same as base Muton
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
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.Abilities.AddItem('CounterattackPreparation');
	CharTemplate.Abilities.AddItem('CounterattackDescription');
	CharTemplate.Abilities.AddItem('WarCry');
	//CharTemplate.Abilities.AddItem('Beastmaster_LW');

	//CharTemplate.Abilities.AddItem('TacticalSense');
	CharTemplate.Abilities.AddItem('PersonalShield');
	// WOTC abilities
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	// LightEmUp: Weapon Template

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;
	CharTemplate.strBehaviorTree = "MutonM3_LWRoot"; // new config behavior tree parsing means we could use the group instead

	//probably keep cinematic intro, since it's a lot of work to create a new one -- alternatively no cinematic intro for tier 3
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_Muton');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_Naja(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'Viper';

	if (TemplateName == 'NajaM1')
		CharTemplate.DefaultLoadout='NajaM1_Loadout';
	if (TemplateName == 'NajaM2')
		CharTemplate.DefaultLoadout='NajaM2_Loadout';
	if (TemplateName == 'NajaM3')
		CharTemplate.DefaultLoadout='NajaM3_Loadout';

	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("LWNaja.Archetypes.ARC_GameUnit_Naja_F"); 
	CharTemplate.strPawnArchetypes.AddItem("LWNaja.Archetypes.ARC_GameUnit_Naja_M"); 
	Loot.ForceLevel=0;
	Loot.LootTableName='Viper_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	if (TemplateName == 'NajaM1')
	{
		Loot.LootTableName = 'Viper_TimedLoot';
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'Viper_VultureLoot';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}
	if (TemplateName == 'NajaM2')
	{
		Loot.LootTableName = 'GenericMidAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericMidAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}
	if (TemplateName == 'NajaM3')
	{
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}


	CharTemplate.strMatineePackages.AddItem("CIN_Viper");
	CharTemplate.strMatineePackages.AddItem("CIN_AdventMEC");
	//CharTemplate.strTargetingMatineePrefix = "CIN_AdventMEC_FF_StartPos";

	CharTemplate.UnitSize = 1;
	// Traversal Rules
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
	CharTemplate.bCanUse_eTraversal_WallClimb = true; // WALL CLIMB!
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.ImmuneTypes.AddItem('Poison');

	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.Abilities.AddItem('FireControl25');
	// WOTC abilities
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.Abilities.AddItem('Squadsight'); //character perk
	if (TemplateName == 'NajaM2' || TemplateName == 'NajaM3')
	{
		//reserved for future use
	}
	if (TemplateName == 'NajaM3')
	{
		CharTemplate.Abilities.AddItem('DepthPerception'); //character perk
	}

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;
	CharTemplate.strScamperBT = "ScamperRoot_Naja";

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Tygan_AlienSightings_Viper');
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_Viper');

	CharTemplate.strBehaviorTree = "LWNajaRoot"; // new config behavior tree parsing means we could use the group instead

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_Sidewinder(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'Viper';

	Loot.ForceLevel = 0;
	if (TemplateName == 'SidewinderM1')
	{
		CharTemplate.DefaultLoadout='SidewinderM1_Loadout';
		Loot.LootTableName = 'Viper_TimedLoot';
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'Viper_VultureLoot';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}

	if (TemplateName == 'SidewinderM2')
	{
		CharTemplate.DefaultLoadout='SidewinderM2_Loadout';
		Loot.LootTableName = 'GenericEarlyAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericEarlyAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}
	if (TemplateName == 'SidewinderM3')
	{
		CharTemplate.DefaultLoadout='SidewinderM3_Loadout';
		Loot.LootTableName = 'GenericMidAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericMidAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}
	if (TemplateName == 'SidewinderM4')
	{
		CharTemplate.DefaultLoadout='SidewinderM4_Loadout';
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	}
	if (TemplateName == 'SidewinderM5')
	{
		CharTemplate.DefaultLoadout='SidewinderM5_Loadout';
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}

	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("LWSidewinder.Archetypes.ARC_GameUnit_Sidewinder_M"); 
	CharTemplate.strPawnArchetypes.AddItem("LWSidewinder.Archetypes.ARC_GameUnit_Sidewinder_F"); 
	Loot.ForceLevel=0;
	Loot.LootTableName='Viper_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);


	CharTemplate.strMatineePackages.AddItem("CIN_Viper");
	CharTemplate.strMatineePackages.AddItem("CIN_AdventMEC");
	//CharTemplate.strTargetingMatineePrefix = "CIN_AdventMEC_FF_StartPos";

	CharTemplate.UnitSize = 1;
	// Traversal Rules
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
	CharTemplate.bCanUse_eTraversal_WallClimb = true;  // let the mambas go everywhere
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.ImmuneTypes.AddItem('Poison');

	CharTemplate.bAllowSpawnFromATT = false;

	switch(TemplateName)
	{
		case 'SidewinderM1':
		case 'SidewinderM2':
		case 'SidewinderM3':
			CharTemplate.strBehaviorTree = "LWSidewinderHitAndRunRoot"; // new config behavior tree parsing means we could use the group instead
		default:
	}
	
	CharTemplate.Abilities.AddItem('HitandSlither');
	CharTemplate.Abilities.AddItem('MovingTarget_LW');

/*
	switch(TemplateName)
	{
		case 'SidewinderM3':
			CharTemplate.Abilities.AddItem('Infighter');
		case 'SidewinderM2':
		case 'SidewinderM1':
			CharTemplate.Abilities.AddItem('Shadowstep');
		default:
		break;
	}
		*/
	// WOTC abilities
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Tygan_AlienSightings_Viper');
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_Viper');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}


static function X2CharacterTemplate CreateTemplate_Archon_LW(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);


	Loot.ForceLevel = 0;
	if (TemplateName == 'ArchonM2_LW')
	{
		CharTemplate.DefaultLoadout='ArchonM2_LW_Loadout';
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	
	}
	if (TemplateName == 'ArchonM3_LW')
	{
		CharTemplate.DefaultLoadout='ArchonM3_LW_Loadout';
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}


	CharTemplate.CharacterGroupName = 'Archon';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Archon.ARC_GameUnit_Archon");
	Loot.ForceLevel=0;
	Loot.LootTableName='Archon_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot

	CharTemplate.strMatineePackages.AddItem("CIN_Archon");
	CharTemplate.strMatineePackages.AddItem("CIN_AdventMEC");
	CharTemplate.strTargetingMatineePrefix = "CIN_AdventMEC_FF_StartPos";

	CharTemplate.UnitSize = 1;
	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = false;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = false;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_DropDown = false;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bCanUse_eTraversal_Launch = true;
	CharTemplate.bCanUse_eTraversal_Flying = true;
	CharTemplate.bCanUse_eTraversal_Land = true;
	CharTemplate.bAppearanceDefinesPawn = false;
	CharTemplate.bCanTakeCover = false;

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;
	
	CharTemplate.strScamperBT = "ScamperRoot_NoCover";

	CharTemplate.Abilities.AddItem('FrenzyDamageListener');
	CharTemplate.Abilities.AddItem('BlazingPinionsStage1');
	//CharTemplate.Abilities.AddItem('LightningReflexes_LW');
	// WOTC abilities
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.Enemy_Sighted_Archon');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_Sectoid_LW(name TemplateName)  // I have big brains
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'Sectoid';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("LWSectoidM2.Archetypes.ARC_GameUnit_SectoidM2"); //SCRUBBED AFTER S&R
	
	Loot.ForceLevel=0;
	Loot.LootTableName='Sectoid_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);
	// Timed Loot

	Loot.ForceLevel = 0;
	if (TemplateName == 'SectoidM3_LW')
	{
		CharTemplate.DefaultLoadout='SectoidM3_LW_Loadout';
		Loot.LootTableName = 'GenericMidAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericMidAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	
	}
	if (TemplateName == 'SectoidM4_LW')
	{
		CharTemplate.DefaultLoadout='SectoidM4_LW_Loadout';
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}
	if (TemplateName == 'SectoidM5_LW')
	{
		CharTemplate.DefaultLoadout='SectoidM5_LW_Loadout';
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}



	CharTemplate.strMatineePackages.AddItem("CIN_Sectoid");

	CharTemplate.UnitSize = 1;
	// Traversal Rules
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
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = true;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.bAllowSpawnFromATT = false;

	//DelayedPsiExplosion does nothing, except moving camera to pointlessly show 
	//the corpse of Sectoid Commander one turn after his death.
	//SectoidDeathOverride is apparently to be used if DelayedPsiExplosion were to work.
	
	//CharTemplate.Abilities.AddItem('DelayedPsiExplosion');
	CharTemplate.Abilities.AddItem('KillSiredZombies');
	//CharTemplate.Abilities.AddItem('SectoidDeathOverride');  // A: Not sure what this does, but it sounds cool

	CharTemplate.Abilities.AddItem('MassMindspin');
	CharTemplate.Abilities.AddItem('MassReanimation_LW');
	// WOTC abilities
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	// OTHERS?

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strBehaviorTree = "SectoidM2_LWRoot"; // new config behavior tree parsing means we could use the group instead

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Tygan_AlienSightings_Sectoid');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_Viper_LW(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'Viper';


	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Viper.ARC_GameUnit_Viper");
	Loot.ForceLevel=0;
	Loot.LootTableName='Viper_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot	
	if (TemplateName == 'ViperM2_LW')
	{
		CharTemplate.DefaultLoadout='ViperM2_LW_Loadout';

		Loot.LootTableName = 'GenericEarlyAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericEarlyAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
		CharTemplate.Abilities.AddItem('BindM2Damage');		
	}
	if (TemplateName == 'ViperM3_LW')
	{
		CharTemplate.DefaultLoadout='ViperM3_LW_Loadout';

		Loot.LootTableName = 'GenericMidAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericMidAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
		CharTemplate.Abilities.AddItem('BindM3Damage');		
	}
	if (TemplateName == 'ViperM4_LW')
	{
		CharTemplate.DefaultLoadout='ViperM4_LW_Loadout';

		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
		CharTemplate.Abilities.AddItem('BindM4Damage');		
	}
	if (TemplateName == 'ViperM5_LW')
	{
		CharTemplate.DefaultLoadout='ViperM5_LW_Loadout';

		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
		CharTemplate.Abilities.AddItem('BindM5Damage');
	}
	


	CharTemplate.strMatineePackages.AddItem("CIN_Viper");
	CharTemplate.strMatineePackages.AddItem("CIN_AdventMEC");
	CharTemplate.strTargetingMatineePrefix = "CIN_AdventMEC_FF_StartPos";

	CharTemplate.UnitSize = 1;
	// Traversal Rules
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
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.ImmuneTypes.AddItem('Poison');

	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.Abilities.AddItem('Bind');
	// WOTC abilities
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	
	//if (TemplateName == 'ViperM3_LW')
	//{
	//	CharTemplate.Abilities.AddItem('LightningReflexes_LW');
	//}

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Tygan_AlienSightings_Viper');
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_Viper');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}


static function X2CharacterTemplate CreateTemplate_AdvGunner(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'AdventTrooper'; 
	if (TemplateName == 'AdvGunnerM2')
		CharTemplate.DefaultLoadout='AdvGunnerM2_Loadout';
	if (TemplateName == 'AdvGunnerM3')
		CharTemplate.DefaultLoadout='AdvGunnerM3_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	//CharTemplate.strPawnArchetypes.AddItem("LWAdvGunner.Archetypes.ARC_GameUnit_AdvGunnerM1_M"); 
	//CharTemplate.strPawnArchetypes.AddItem("LWAdvGunner.Archetypes.ARC_GameUnit_AdvGunnerM1_F"); 
	//CharTemplate.strPawnArchetypes.AddItem("XAdventTrooper.Archetypes.GameUnit_AdvSoldier_F"); 
	CharTemplate.strPawnArchetypes.AddItem("XAdventTrooper.Archetypes.GameUnit_AdvSoldier_M"); 

	Loot.ForceLevel=0;

	if (TemplateName == 'AdvGunnerM1')
	{
		CharTemplate.DefaultLoadout='AdvGunnerM1_Loadout';
		Loot.LootTableName = 'GenericEarlyAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericEarlyAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}
		if (TemplateName == 'AdvGunnerM2')
	{
		CharTemplate.DefaultLoadout='AdvGunnerM2_Loadout';
		Loot.LootTableName = 'GenericEarlyAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericEarlyAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}
		if (TemplateName == 'AdvGunnerM3')
	{
		CharTemplate.DefaultLoadout='AdvGunnerM3_Loadout';
		Loot.LootTableName = 'GenericMidAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericMidAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}
	if (TemplateName == 'AdvGunnerM4')
	{
		CharTemplate.DefaultLoadout='AdvGunnerM4_Loadout';
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}
	if (TemplateName == 'AdvGunnerM5')
	{
		CharTemplate.DefaultLoadout='AdvGunnerM4_Loadout';
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}

	Loot.LootTableName='AdvTrooperM1_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);



	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_Trooper";
	CharTemplate.GetRevealMatineePrefixFn = class'X2Character_DefaultCharacters'.static.GetAdventMatineePrefix;

	CharTemplate.UnitSize = 1;
	// Traversal Rules
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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;
	CharTemplate.bAppearanceDefinesPawn = false;
	
	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.Abilities.AddItem('HunkerDown');
	// WOTC abilities
	CharTemplate.Abilities.AddItem('DarkEventAbility_SealedArmor');
	CharTemplate.Abilities.AddItem('DarkEventAbility_UndyingLoyalty');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Counterattack');

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.bAllowSpawnFromATT = true;

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strBehaviorTree = "LWAdventGunnerRoot"; // new config behavior tree parsing means we could use the group instead

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvSentry(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'AdventTrooper';  

	CharTemplate.BehaviorClass=class'XGAIBehavior';
	//CharTemplate.strPawnArchetypes.AddItem("LWAdvSentry.Archetypes.ARC_GameUnit_AdvSentryM1_M");
	//CharTemplate.strPawnArchetypes.AddItem("LWAdvSentry.Archetypes.ARC_GameUnit_AdvSentryM1_F");
	CharTemplate.strPawnArchetypes.AddItem("XAdventTrooper.Archetypes.GameUnit_AdvSoldier_M"); 
	Loot.ForceLevel=0;

	if (TemplateName == 'AdvSentryM1')
	{
		CharTemplate.DefaultLoadout='AdvSentryM1_Loadout';
		Loot.LootTableName = 'GenericEarlyAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericEarlyAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}
	if (TemplateName == 'AdvSentryM2')
	{
		CharTemplate.DefaultLoadout='AdvSentryM2_Loadout';
		Loot.LootTableName = 'GenericEarlyAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericEarlyAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}
	if (TemplateName == 'AdvSentryM3')
	{
		CharTemplate.DefaultLoadout='AdvSentryM3_Loadout';
		Loot.LootTableName = 'GenericMidAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericMidAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}
	if (TemplateName == 'AdvSentryM4')
	{
		CharTemplate.DefaultLoadout='AdvSentryM4_Loadout';
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}
	if (TemplateName == 'AdvSentryM5')
	{
		CharTemplate.DefaultLoadout='AdvSentryM5_Loadout';
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}

	//base loot
	Loot.LootTableName='AdvTrooperM1_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);



	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_Trooper";
	CharTemplate.GetRevealMatineePrefixFn = class'X2Character_DefaultCharacters'.static.GetAdventMatineePrefix;

	CharTemplate.UnitSize = 1;

	// Traversal Rules
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
	CharTemplate.bAppearanceDefinesPawn = false;   
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;
	
	CharTemplate.bAllowSpawnFromATT = true;

	CharTemplate.Abilities.AddItem('ReadyForAnything');
	CharTemplate.Abilities.AddItem('HunkerDown');
	// WOTC abilities
	CharTemplate.Abilities.AddItem('DarkEventAbility_SealedArmor');
	CharTemplate.Abilities.AddItem('DarkEventAbility_UndyingLoyalty');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Counterattack');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvTrooperM1');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strBehaviorTree = "LWAdventSentryRoot"; // new config behavior tree parsing means we could use the group instead

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvGrenadier(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'AdventTrooper'; 
	
	if (TemplateName == 'AdvGrenadierM1')
		CharTemplate.DefaultLoadout='AdvGrenadierM1_Loadout';
	if (TemplateName == 'AdvGrenadierM2')
		CharTemplate.DefaultLoadout='AdvGrenadierM2_Loadout';
	if (TemplateName == 'AdvGrenadierM3')
		CharTemplate.DefaultLoadout='AdvGrenadierM3_Loadout';

	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("XAdventTrooper.Archetypes.GameUnit_AdvSoldier_M"); 

	Loot.ForceLevel=0;
	if (TemplateName == 'AdvGrenadierM1')
		Loot.LootTableName='AdvTrooperM1_BaseLoot';
	if (TemplateName == 'AdvGrenadierM2')
		Loot.LootTableName='AdvTrooperM2_BaseLoot';
	if (TemplateName == 'AdvGrenadierM3')
		Loot.LootTableName='AdvTrooperM3_BaseLoot';

	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	if (TemplateName == 'AdvGrenadierM1')
		Loot.LootTableName='AdvTrooperM1_TimedLoot';
	if (TemplateName == 'AdvGrenadierM2')
		Loot.LootTableName='AdvTrooperM2_TimedLoot';
	if (TemplateName == 'AdvGrenadierM3')
		Loot.LootTableName='AdvTrooperM3_TimedLoot';

	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	if (TemplateName == 'AdvGrenadierM1')
		Loot.LootTableName='AdvTrooperM1_VultureLoot';
	if (TemplateName == 'AdvGrenadierM2')
		Loot.LootTableName='AdvTrooperM2_VultureLoot';
	if (TemplateName == 'AdvGrenadierM3')
		Loot.LootTableName='AdvTrooperM3_VultureLoot';

	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_Trooper";
	CharTemplate.GetRevealMatineePrefixFn = class'X2Character_DefaultCharacters'.static.GetAdventMatineePrefix;

	CharTemplate.UnitSize = 1;

	// Traversal Rules
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
	CharTemplate.bAppearanceDefinesPawn = false;   
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.bAllowSpawnFromATT = true;

    CharTemplate.Abilities.AddItem('HunkerDown');
	// WOTC abilities
	CharTemplate.Abilities.AddItem('DarkEventAbility_SealedArmor');
	CharTemplate.Abilities.AddItem('DarkEventAbility_UndyingLoyalty');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Counterattack');

	if (TemplateName == 'AdvGrenadierM3')
	{
		CharTemplate.Abilities.AddItem('Salvo');
		CharTemplate.Abilities.AddItem('BiggestBooms_LW');
	}

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvTrooperM1');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strBehaviorTree = "LWAdventGrenadierRoot"; // new config behavior tree parsing means we could use the group instead

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;
	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvRocketeer(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'AdventTrooper'; 
	CharTemplate.DefaultLoadout=name(TemplateName $ "_Loadout"); //'AdvRocketeerM1_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	//CharTemplate.strPawnArchetypes.AddItem("LWAdvRocketeer.Archetypes.ARC_GameUnit_AdvRocketeerM1_M");
	//CharTemplate.strPawnArchetypes.AddItem("LWAdvRocketeer.Archetypes.ARC_GameUnit_AdvRocketeerM1_F");
	CharTemplate.strPawnArchetypes.AddItem("XAdventTrooper.Archetypes.GameUnit_AdvSoldier_M"); 
	Loot.ForceLevel=0;
	if (TemplateName == 'AdvRocketeerM1')
		Loot.LootTableName='AdvTrooperM1_BaseLoot';
	if (TemplateName == 'AdvRocketeerM2')
		Loot.LootTableName='AdvTrooperM2_BaseLoot';
	if (TemplateName == 'AdvRocketeerM3')
		Loot.LootTableName='AdvTrooperM3_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	if (TemplateName == 'AdvRocketeerM1')
		Loot.LootTableName='AdvTrooperM1_TimedLoot';
	if (TemplateName == 'AdvRocketeerM2')
		Loot.LootTableName='AdvTrooperM2_TimedLoot';
	if (TemplateName == 'AdvRocketeerM3')
		Loot.LootTableName='AdvTrooperM3_TimedLoot';

	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);

	if (TemplateName == 'AdvRocketeerM1')
		Loot.LootTableName='AdvTrooperM1_VultureLoot';
	if (TemplateName == 'AdvRocketeerM2')
		Loot.LootTableName='AdvTrooperM2_VultureLoot';
	if (TemplateName == 'AdvRocketeerM3')
		Loot.LootTableName='AdvTrooperM3_VultureLoot';

	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_Trooper";
	CharTemplate.GetRevealMatineePrefixFn = class'X2Character_DefaultCharacters'.static.GetAdventMatineePrefix;

	CharTemplate.UnitSize = 1;

	// Traversal Rules
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
	CharTemplate.bAppearanceDefinesPawn = false;   
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bAllowSpawnFromATT = true;
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.Abilities.AddItem('HunkerDown');
	// WOTC abilities
	CharTemplate.Abilities.AddItem('DarkEventAbility_SealedArmor');
	CharTemplate.Abilities.AddItem('DarkEventAbility_UndyingLoyalty');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Counterattack');

	if (TemplateName == 'AdvRocketeerM3')
		CharTemplate.Abilities.AddItem('BiggestBooms_LW');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvTrooperM1');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strBehaviorTree = "LWAdventRocketeerRoot"; // new config behavior tree parsing means we could use the group instead

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvMec_LW(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'AdventMEC';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("XComAlienPawn'LWAdvMec.Archetypes.GameUnit_AdvMEC_M3'");

	if (TemplateName == 'AdvMEC_M3_LW')
	{
		CharTemplate.DefaultLoadout='AdvMEC_M3_Loadout';
		Loot.LootTableName = 'GenericMidAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericMidAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}

	if (TemplateName == 'AdvMEC_M4_LW')
	{
		CharTemplate.DefaultLoadout='AdvMEC_M4_Loadout';
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}
	if (TemplateName == 'AdvMEC_M5_LW')
	{
		CharTemplate.DefaultLoadout='AdvMEC_M5_Loadout';
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}
	CharTemplate.strMatineePackages.AddItem("CIN_AdventMEC");
	CharTemplate.strTargetingMatineePrefix = "CIN_AdventMEC_FF_StartPos";

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
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = true;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bAllowSpawnFromATT = true;
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bFacesAwayFromPod = true;

	//CharTemplate.strScamperBT = "ScamperRoot_NoCover";
	CharTemplate.strScamperBT = "ScamperRoot_Overwatch";

	CharTemplate.Abilities.AddItem('RobotImmunities');
	//CharTemplate.Abilities.AddItem('DamageControl');
	// WOTC abilities
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_robot_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvMECArcher(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'AdventMEC';
	CharTemplate.DefaultLoadout='AdvMECArcher_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("LWAdvMecArcher.Archetypes.ARC_GameUnit_AdvMECArcher");
	Loot.ForceLevel=0;
	Loot.LootTableName='AdvMEC_M2_BaseLoot';  
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvMEC_M2_TimedLoot'; 
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'AdvMEC_M2_VultureLoot';  
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_AdventMEC");
	CharTemplate.strTargetingMatineePrefix = "CIN_AdventMEC_FF_StartPos";

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
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = true;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bAllowSpawnFromATT = true;
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bFacesAwayFromPod = true;

	//CharTemplate.strScamperBT = "ScamperRoot_NoCover";
	CharTemplate.strScamperBT = "ScamperRoot_Overwatch";

	CharTemplate.Abilities.AddItem('RobotImmunities');
	// WOTC abilities
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	if (TemplateName == 'AdvMecArcherM2')
		CharTemplate.Abilities.AddItem('BiggestBooms_LW');

	CharTemplate.strBehaviorTree = "LWAdventMECArcherRoot"; // new config behavior tree parsing means we could use the group instead

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_robot_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

simulated function string GetAdventMatineePrefix(XComGameState_Unit UnitState)
{
	if(UnitState.kAppearance.iGender == eGender_Male)
	{
		return UnitState.GetMyTemplate().RevealMatineePrefix $ "_Male";
	}
	else
	{
		return UnitState.GetMyTemplate().RevealMatineePrefix $ "_Female";
	}
}

static function X2CharacterTemplate CreateTemplate_Drone(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'AdventDrone';
	CharTemplate.BehaviorClass=class'XGAIBehavior';


	Loot.ForceLevel=0;
	Loot.LootTableName='LWDroneM1_BaseLoot';			// Both leave a drone corpse
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	if (TemplateName == 'LWDroneM1')
	{
		CharTemplate.strPawnArchetypes.AddItem("LWDrone.Archetypes.ARC_GameUnit_DroneM1"); 
		CharTemplate.DefaultLoadout='LWDroneM1_Loadout';
		Loot.LootTableName = 'GenericEarlyAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericEarlyAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}
	if (TemplateName == 'LWDroneM2')
	{
		CharTemplate.strPawnArchetypes.AddItem("LWDrone.Archetypes.ARC_GameUnit_DroneM1"); 
		CharTemplate.DefaultLoadout='LWDroneM2_Loadout';
		Loot.LootTableName = 'GenericEarlyAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericEarlyAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}
	if (TemplateName == 'LWDroneM3')
	{
		CharTemplate.strPawnArchetypes.AddItem("LWDrone.Archetypes.ARC_GameUnit_DroneM3"); 
		CharTemplate.DefaultLoadout='LWDroneM3_Loadout';
		Loot.LootTableName = 'GenericMidAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericMidAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}
	if (TemplateName == 'LWDroneM4')
	{
		CharTemplate.strPawnArchetypes.AddItem("LWDrone.Archetypes.ARC_GameUnit_DroneM3"); 
		CharTemplate.DefaultLoadout='LWDroneM4_Loadout';
		Loot.LootTableName = 'GenericEarlyAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericEarlyAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}
	if (TemplateName == 'LWDroneM4')
	{
		CharTemplate.strPawnArchetypes.AddItem("LWDrone.Archetypes.ARC_GameUnit_DroneM3"); 
		CharTemplate.DefaultLoadout='LWDroneM5_Loadout';
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}


	//NEW CINEMATIC?

	CharTemplate.UnitSize = 1;

	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = false;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = false;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_DropDown = false;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bCanUse_eTraversal_Launch = true;
	CharTemplate.bCanUse_eTraversal_Flying = true;
	CharTemplate.bCanUse_eTraversal_Land = true;
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bCanTakeCover = false;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = true;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = false;

	CharTemplate.bAllowSpawnFromATT = false;  // If true, this unit can be spawned from an Advent Troop Transport
	CharTemplate.bWeakAgainstTechLikeRobot = true;

	CharTemplate.Abilities.AddItem('LWDroneMeleeStun');
	CharTemplate.Abilities.AddItem('RobotImmunities');
	// WOTC abilities
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	//CharTemplate.Abilities.AddItem('FireOnDeath');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;
	CharTemplate.strBehaviorTree = "LWDroneRoot"; // new config behavior tree parsing means we could use the group instead
	CharTemplate.strScamperBT = "ScamperRoot_NoCover";

	//TODO: (ID 507) investigate possibilities for adding first-sighting narrative moment for new unit
	//CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_Muton');

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_robot_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;  

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_ChryssalidSoldier()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'ChryssalidSoldier');
	CharTemplate.CharacterGroupName = 'Chryssalid';
	CharTemplate.DefaultLoadout='Chryssalid_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("LWHiveQueen.Archetypes.ARC_GameUnit_ChryssalidM2");
	Loot.ForceLevel=0;
	Loot.LootTableName='Chryssalid_BaseLoot';  
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	//Loot.ForceLevel = 0;
	//Loot.LootTableName = 'Chryssalid_TimedLoot';
	//CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	//Loot.LootTableName = 'Chryssalid_VultureLoot';
	//CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Chryssalid");

	CharTemplate.UnitSize = 2;
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

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bIsMeleeOnly = true;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;
	CharTemplate.strScamperBT = "ChryssalidScamperRoot";

	CharTemplate.Abilities.AddItem('ChryssalidSlash');
	CharTemplate.Abilities.AddItem('ChryssalidBurrow'); // REMOVE?
	CharTemplate.Abilities.AddItem('ChyssalidPoison');
	CharTemplate.Abilities.AddItem('ChryssalidImmunities');
	CharTemplate.Abilities.AddItem('ChryssalidSoldierSlash');
	CharTemplate.Abilities.AddItem('LightningReflexes_LW');
	// WOTC abilities
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_Cryssalid');

	CharTemplate.strBehaviorTree = "LWHiveQueenRoot"; // new config behavior tree parsing means we could use the group instead

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_HiveQueen()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'HiveQueen');
	CharTemplate.CharacterGroupName = 'Chryssalid';
	CharTemplate.DefaultLoadout='Chryssalid_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("LWHiveQueen.Archetypes.ARC_GameUnit_ChryssalidM3");
	Loot.ForceLevel=0;
	Loot.LootTableName='Chryssalid_BaseLoot';  
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	//Loot.ForceLevel = 0;
	//Loot.LootTableName = 'Chryssalid_TimedLoot';
	//CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	//Loot.LootTableName = 'Chryssalid_VultureLoot';
	//CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Chryssalid");

	CharTemplate.UnitSize = 3; // really, truly big
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

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bIsMeleeOnly = true;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;
	CharTemplate.strScamperBT = "ChryssalidScamperRoot";

	CharTemplate.Abilities.AddItem('ChryssalidSlash');
	CharTemplate.Abilities.AddItem('ChryssalidBurrow'); // REMOVE?
	CharTemplate.Abilities.AddItem('ChyssalidPoison');
	CharTemplate.Abilities.AddItem('ChryssalidImmunities');
	CharTemplate.Abilities.AddItem('HiveQueenSlash');
	// WOTC abilities
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_Cryssalid');

	CharTemplate.strBehaviorTree = "LWHiveQueenRoot"; // new config behavior tree parsing means we could use the group instead

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvGeneric(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference LootBase, LootTimed, LootVulture;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	
	CharTemplate.strPawnArchetypes.AddItem("XAdventTrooper.Archetypes.GameUnit_AdvSoldier_M"); 

	// Some of these may be overidden on case-by-case basis
	CharTemplate.CharacterGroupName = 'AdventTrooper'; 
	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_Trooper";
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvTrooperM1');
    CharTemplate.BehaviorClass = class'XGAIBehavior';

	LootBase.ForceLevel = 0;
	LootTimed.ForceLevel = 0;
	LootVulture.ForceLevel = 0;

	// FOrmat for custom AIs
	//CharTemplate.strBehaviorTree = "LWAdventSentryRoot"; // new config behavior tree parsing means we could use the group instead

	CharTemplate.Abilities.AddItem('HunkerDown');
	// WOTC abilities
	CharTemplate.Abilities.AddItem('DarkEventAbility_SealedArmor');
	CharTemplate.Abilities.AddItem('DarkEventAbility_UndyingLoyalty');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Counterattack');

	switch (TemplateName)
	{
		case 'AdvSergeantM1':
			CharTemplate.DefaultLoadout='AdvSergeantM1_Loadout';
			LootBase.LootTableName='AdvTrooperM2_BaseLoot';
			LootTimed.LootTableName='AdvTrooperM2_TimedLoot';
			LootVulture.LootTableName='AdvTrooperM2_VultureLoot';
			CharTemplate.Abilities.AddItem('TacticalSense');
			break;

		case 'AdvSergeantM2':
			CharTemplate.DefaultLoadout='AdvSergeantM2_Loadout';
			LootBase.LootTableName='AdvTrooperM3_BaseLoot';
			LootTimed.LootTableName='AdvTrooperM3_TimedLoot';
			LootVulture.LootTableName='AdvTrooperM3_VultureLoot';
			CharTemplate.Abilities.AddItem('TacticalSense');
			CharTemplate.Abilities.AddItem('LockedOn');				// Weapon?
			break;

		case 'AdvGeneralM1_LW':
			CharTemplate.CharacterGroupName = 'AdventCaptain';
			CharTemplate.DefaultLoadout='AdvGeneralM1_LW_Loadout';
			LootBase.LootTableName='AdvCaptainM3_BaseLoot';
			LootTimed.LootTableName='AdvCaptainM3_TimedLoot';
			LootVulture.LootTableName='AdvCaptainM3_VultureLoot';
			CharTemplate.Abilities.AddItem('MarkTarget');
			CharTemplate.Abilities.AddItem('TacticalSense');
			CharTemplate.Abilities.AddItem('ReadyForAnything');
			CharTemplate.Abilities.AddItem('Defilade');
			CharTemplate.Abilities.AddItem('FireDiscipline');
			CharTemplate.RevealMatineePrefix = "CIN_Advent_Captain";
			CharTemplate.SightedNarrativeMoments.length = 0;
			CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvCaptainM1');
			break;

			case 'AdvCaptainM4':
			CharTemplate.CharacterGroupName = 'AdventCaptain';
			CharTemplate.DefaultLoadout='AdvGeneralM1_LW_Loadout';
			LootBase.LootTableName='AdvCaptainM3_BaseLoot';
			LootTimed.LootTableName='GenericLateAlienLoot_LW';
			LootVulture.LootTableName='GenericLateAlienVultureLoot_LW';
			CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvCaptain.ARC_GameUnit_AdvCaptainM3_M");
			CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvCaptain.ARC_GameUnit_AdvCaptainM3_F");		
			CharTemplate.Abilities.AddItem('MarkTarget');
			CharTemplate.Abilities.AddItem('Defilade');
			CharTemplate.RevealMatineePrefix = "CIN_Advent_Captain";
			CharTemplate.SightedNarrativeMoments.length = 0;
			CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvCaptainM1');
			break;
			case 'AdvCaptainM5':
			CharTemplate.CharacterGroupName = 'AdventCaptain';
			CharTemplate.DefaultLoadout='AdvGeneralM1_LW_Loadout';
			LootBase.LootTableName='AdvCaptainM3_BaseLoot';
			LootTimed.LootTableName='GenericLateAlienLoot_LW';
			LootVulture.LootTableName='GenericLateAlienVultureLoot_LW';
			CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvCaptain.ARC_GameUnit_AdvCaptainM3_M");
			CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvCaptain.ARC_GameUnit_AdvCaptainM3_F");		
			CharTemplate.Abilities.AddItem('MarkTarget');
			CharTemplate.Abilities.AddItem('Defilade');
			CharTemplate.RevealMatineePrefix = "CIN_Advent_Captain";
			CharTemplate.SightedNarrativeMoments.length = 0;
			CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvCaptainM1');
			break;
		case 'AdvGeneralM2_LW':
			CharTemplate.CharacterGroupName='AdventCaptain';
			CharTemplate.DefaultLoadout='AdvGeneralM2_LW_Loadout';
			LootBase.LootTableName='AdvCaptainM3_BaseLoot';
			LootTimed.LootTableName='AdvCaptainM3_TimedLoot';
			LootVulture.LootTableName='AdvCaptainM3_VultureLoot';
			CharTemplate.Abilities.AddItem('MarkTarget');
			CharTemplate.Abilities.AddItem('TacticalSense');
			CharTemplate.Abilities.AddItem('ReadyForAnything');
			CharTemplate.Abilities.AddItem('Defilade');
			CharTemplate.Abilities.AddItem('FireDiscipline');
			CharTemplate.RevealMatineePrefix = "CIN_Advent_Captain";
			CharTemplate.SightedNarrativeMoments.length = 0;
			CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_AdvCaptainM1');
			break;

		case 'AdvScout':
			CharTemplate.DefaultLoadout='AdvScout_Loadout';
			LootBase.LootTableName='AdvTrooperM1_BaseLoot';
			LootTimed.LootTableName='AdvTrooperM1_TimedLoot';
			LootVulture.LootTableName='AdvTrooperM1_VultureLoot';
			CharTemplate.Abilities.AddItem('Shadowstep');
			CharTemplate.Abilities.AddItem('LoneWolf');
			break;

		case 'AdvVanguard':
			CharTemplate.DefaultLoadout='AdvVanguard_Loadout';
			LootBase.LootTableName='AdvTrooperM2_BaseLoot';
			LootTimed.LootTableName='AdvTrooperM2_TimedLoot';
			LootVulture.LootTableName='AdvTrooperM2_VultureLoot';
			CharTemplate.Abilities.AddItem('CloseCombatSpecialist');	// weapon?
			CharTemplate.Abilities.AddItem('CloseAndPersonal');			// weapon?
			CharTemplate.Abilities.AddItem('WillToSurvive');
			// Run and Gun, SUppression
			break;

		case 'AdvCommando':
			CharTemplate.DefaultLoadout='AdvCommando_Loadout';		// sword?
			LootBase.LootTableName='AdvTrooperM3_BaseLoot';
			LootTimed.LootTableName='AdvTrooperM3_TimedLoot';
			LootVulture.LootTableName='AdvTrooperM3_VultureLoot';
			CharTemplate.Abilities.AddItem('Shadowstep');
			CharTemplate.Abilities.AddItem('Evasive');
			CharTemplate.Abilities.AddItem('LowProfile');
			CharTemplate.Abilities.AddItem('HardTarget');
			CharTemplate.Abilities.AddItem('LoneWolf');
			break;

		case 'AdvShockTroop':
			CharTemplate.DefaultLoadout='AdvShockTroop_Loadout';
			LootBase.LootTableName='AdvTrooperM2_BaseLoot';
			LootTimed.LootTableName='AdvTrooperM2_TimedLoot';
			LootVulture.LootTableName='AdvTrooperM2_VultureLoot';
			CharTemplate.Abilities.AddItem('Aggression');
			CharTemplate.Abilities.AddItem('BringEmOn');
			CharTemplate.Abilities.AddItem('Executioner_LW');
			break;

		case 'AdvTrooperM4':
			CharTemplate.DefaultLoadout='AdvTrooperM4_Loadout';
			LootBase.LootTableName='AdvTrooperM1_BaseLoot';
			LootTimed.LootTableName='GenericLateAlienLoot_LW';
			LootVulture.LootTableName='GenericLateAlienVultureLoot_LW';
			CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvTrooper.ARC_GameUnit_AdvTrooperM1_M");
			CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvTrooper.ARC_GameUnit_AdvTrooperM1_F");
				
			break;
		case 'AdvTrooperM5':
			CharTemplate.DefaultLoadout='AdvTrooperM5_Loadout';
			LootBase.LootTableName='AdvTrooperM1_BaseLoot';
			LootTimed.LootTableName='GenericLateAlienLoot_LW';
			LootVulture.LootTableName='GenericLateAlienVultureLoot_LW';
			break;
		default:
			break;
	}

	CharTemplate.Loot.LootReferences.AddItem(LootBase);
	CharTemplate.TimedLoot.LootReferences.AddItem(LootTimed);
	CharTemplate.VultureLoot.LootReferences.AddItem(LootVulture);
	
	CharTemplate.GetRevealMatineePrefixFn = class'X2Character_DefaultCharacters'.static.GetAdventMatineePrefix;
	CharTemplate.UnitSize = 1;
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
	CharTemplate.bAppearanceDefinesPawn = false;   
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;
	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.bAllowSpawnFromATT = true;
	
	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

//For Vanilla Sectoid appearance
static function X2CharacterTemplate CreateTemplate_Sectoid(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'Sectoid';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Sectoid.ARC_GameUnit_Sectoid");
	Loot.ForceLevel=0;
	Loot.LootTableName='Sectoid_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	if (TemplateName == 'SectoidM2_LW')
	{
		CharTemplate.DefaultLoadout='SectoidM2_LW_Loadout';
		Loot.LootTableName = 'GenericEarlyAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericEarlyAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}

	CharTemplate.strMatineePackages.AddItem("CIN_Sectoid");

	CharTemplate.UnitSize = 1;
	// Traversal Rules
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
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = true;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.bAllowSpawnFromATT = false;

	//CharTemplate.Abilities.AddItem('VulnerabilityMelee');
	CharTemplate.Abilities.AddItem('Mindspin');
	//CharTemplate.Abilities.AddItem('DelayedPsiExplosion');
	CharTemplate.Abilities.AddItem('PsiReanimation');
	CharTemplate.Abilities.AddItem('KillSiredZombies');
	//CharTemplate.Abilities.AddItem('SectoidDeathOverride');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Tygan_AlienSightings_Sectoid');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;
	CharTemplate.AcquiredPhobiaTemplate = 'FearOfSectoids';

	return CharTemplate;
}



static function X2CharacterTemplate CreateTemplate_Chryssalid(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'Chryssalid';
	CharTemplate.DefaultLoadout='Chryssalid_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Chryssalid.ARC_GameUnit_Chryssalid");
	Loot.ForceLevel=0;
	Loot.LootTableName='Chryssalid_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	if (TemplateName == 'Chryssalid')
	{
		CharTemplate.DefaultLoadout='Chryssalid_Loadout';
		Loot.LootTableName = 'GenericEarlyAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericEarlyAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
		CharTemplate.Abilities.AddItem('ChryssalidSlash');
	}
	if (TemplateName == 'ChryssalidM2')
	{
		CharTemplate.DefaultLoadout='ChryssalidM2_Loadout';
		Loot.LootTableName = 'GenericMidAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericMidAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
		CharTemplate.Abilities.AddItem('ChryssalidSlashM2');

	}
	if (TemplateName == 'ChryssalidM3')
	{
		CharTemplate.DefaultLoadout='ChryssalidM3_Loadout';
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
		CharTemplate.Abilities.AddItem('ChryssalidSlashM3');
	}
	if (TemplateName == 'ChryssalidM4')
	{
		CharTemplate.DefaultLoadout='ChryssalidM4_Loadout';
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
		CharTemplate.Abilities.AddItem('ChryssalidSlashM4');
	}
	CharTemplate.strMatineePackages.AddItem("CIN_Chryssalid");

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

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bIsMeleeOnly = true;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;
	CharTemplate.strScamperBT = "ChryssalidScamperRoot";

	//CharTemplate.Abilities.AddItem('ChryssalidBurrow');
	CharTemplate.Abilities.AddItem('ChyssalidPoison');
	CharTemplate.Abilities.AddItem('ChryssalidImmunities');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_Cryssalid');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}


static function X2CharacterTemplate CreateTemplate_Andromedon(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'Andromedon';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Andromedon.ARC_GameUnit_Andromedon");
	Loot.ForceLevel=0;

	if (TemplateName == 'Andromedon')
	{
		CharTemplate.DefaultLoadout='Andromedon_Loadout';
		Loot.LootTableName = 'GenericMidAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericMidAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}
	if (TemplateName == 'AndromedonM2')
	{
		CharTemplate.DefaultLoadout='AndromedonM2_Loadout';
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}
	if (TemplateName == 'AndromedonM3')
	{
		CharTemplate.DefaultLoadout='AndromedonM3_Loadout';
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}


	CharTemplate.strMatineePackages.AddItem("CIN_Andromedon");
	CharTemplate.strMatineePackages.AddItem("CIN_Muton");
	CharTemplate.strTargetingMatineePrefix = "CIN_Muton_FF_StartPos";

	CharTemplate.UnitSize = 1;
	// Traversal Rules
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
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = false;

	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.Abilities.AddItem('SwitchToRobot');
	CharTemplate.Abilities.AddItem('AndromedonImmunities');
	CharTemplate.Abilities.AddItem('BigDamnPunch');
	CharTemplate.Abilities.AddItem('WallBreaking');
	CharTemplate.Abilities.AddItem('WallSmash');
	CharTemplate.Abilities.AddItem('RobotBattlesuit');
	//CharTemplate.Abilities.AddItem('ShellLauncher');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_Andromedon');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AndromedonRobot(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'AndromedonRobot';
	CharTemplate.DefaultLoadout='AndromedonRobot_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Andromedon.ARC_GameUnit_Andromedon_Robot_Suit");
	Loot.ForceLevel=0;
	Loot.LootTableName='AndromedonRobot_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	//Loot.ForceLevel = 0;
	//Loot.LootTableName = 'AndromedonRobot_TimedLoot';
	//CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	//Loot.LootTableName = 'AndromedonRobot_VultureLoot';
	//CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Andromedon");
	CharTemplate.strMatineePackages.AddItem("CIN_Muton");
	CharTemplate.strTargetingMatineePrefix = "CIN_Muton_FF_StartPos";

	CharTemplate.UnitSize = 1;
	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = false;
	CharTemplate.bCanUse_eTraversal_KickDoor = false;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bCanTakeCover = false;

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = true;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = false;
	
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.Abilities.AddItem('AndromedonRobotImmunities');
	CharTemplate.Abilities.AddItem('BigDamnPunch');
	CharTemplate.Abilities.AddItem('AndromedonRobotAcidTrail');
	CharTemplate.Abilities.AddItem('WallBreaking');
	CharTemplate.Abilities.AddItem('WallSmash');
	CharTemplate.Abilities.AddItem('RobotReboot');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.strScamperBT = "ScamperRoot_NoCover";

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_First_Andromedon_Battlesuit');
	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_robot_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}


static function X2CharacterTemplate CreateTemplate_Sectopod(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'Sectopod';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Sectopod.ARC_GameUnit_Sectopod");
	Loot.ForceLevel=0;
	Loot.LootTableName='Sectopod_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);


	if (TemplateName == 'SectopodM2')
	{
		CharTemplate.DefaultLoadout='SectopodM2_Loadout';
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}
	if (TemplateName == 'SectopodM3')
	{
		CharTemplate.DefaultLoadout='SectopodM3_Loadout';
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}

	CharTemplate.strMatineePackages.AddItem("CIN_Sectopod");
	CharTemplate.strTargetingMatineePrefix = "CIN_Sectopod_FF_StartPos";

	CharTemplate.UnitSize = 2;
	CharTemplate.UnitHeight = 4;

	CharTemplate.KillContribution = 2.0;

	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = false;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = false;
	CharTemplate.bCanUse_eTraversal_KickDoor = false;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bCanTakeCover = false;
	CharTemplate.bSkipDefaultAbilities = true;

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = true;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bAllowRushCam = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = false;
	//CharTemplate.AcquiredPhobiaTemplate = 'FearOfMecs';

	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strScamperBT = "ScamperRoot_NoCover";

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Shen_AlienSightings_Sectopod');

	CharTemplate.ImmuneTypes.AddItem('Fire');

	CharTemplate.Abilities.AddItem('StandardMove');
	CharTemplate.Abilities.AddItem('SectopodHigh');
	CharTemplate.Abilities.AddItem('SectopodLow');
	CharTemplate.Abilities.AddItem('SectopodLightningField');
	CharTemplate.Abilities.AddItem('DeathExplosion');
	CharTemplate.Abilities.AddItem('SectopodInitialState');
	CharTemplate.Abilities.AddItem('SectopodNewTeamState');

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_robot_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_Gatekeeper(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'Gatekeeper';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Gatekeeper.ARC_GameUnit_Gatekeeper");
	Loot.ForceLevel=0;
	Loot.LootTableName='Gatekeeper_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	if (TemplateName == 'GatekeeperM2')
	{
		CharTemplate.DefaultLoadout='GatekeeperM2_Loadout';
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}
	if (TemplateName == 'GatekeeperM3')
	{
		CharTemplate.DefaultLoadout='GatekeeperM3_Loadout';
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}


	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'Gatekeeper_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'Gatekeeper_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Gatekeeper");
	CharTemplate.GetRevealMatineePrefixFn = class'X2Character_DefaultCharacters'.static.GetGateKeeperRevealMatineePrefix;
	CharTemplate.strTargetingMatineePrefix = "CIN_Gatekeeper_FF_StartPos";	

	CharTemplate.UnitSize = 2;

	CharTemplate.KillContribution = 2.0;

	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = false;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = false;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_DropDown = false;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = false;
	CharTemplate.bCanUse_eTraversal_KickDoor = false;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bCanUse_eTraversal_Launch = true;
	CharTemplate.bCanUse_eTraversal_Flying = true;
	CharTemplate.bCanUse_eTraversal_Land = true;
	CharTemplate.MaxFlightPitchDegrees = 0;
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bCanTakeCover = false;

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = true;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bAllowRushCam = false;
	CharTemplate.bWeakAgainstTechLikeRobot = true;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.bAllowSpawnFromATT = false;
	CharTemplate.bImmueToFalling = true;

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strScamperBT = "ScamperRoot_NoCover";

	CharTemplate.Abilities.AddItem('GatekeeperInitialState');  // Sets initial closed effect on Gatekeeper.
	CharTemplate.Abilities.AddItem('Retract');
	CharTemplate.Abilities.AddItem('AnimaInversion');
	CharTemplate.Abilities.AddItem('AnimaConsume');
	CharTemplate.Abilities.AddItem('AnimaGate');
	CharTemplate.Abilities.AddItem('DeathExplosion');
	CharTemplate.Abilities.AddItem('KillSiredZombies');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Shen_AlienSightings_Gatekeeper');

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_robot_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}


static function X2CharacterTemplate CreateTemplate_Spectre(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'Spectre';
	CharTemplate.BehaviorClass = class'XGAIBehavior';	

	// Auto-Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'Spectre_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	if (TemplateName == 'SpectreM3')
	{
		CharTemplate.DefaultLoadout = 'SpectreM3_Loadout';
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}
	if (TemplateName == 'SpectreM4')
	{
		CharTemplate.DefaultLoadout = 'SpectreM4_Loadout';
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}
	CharTemplate.UnitSize = 1;

	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;

//BEGIN AUTOGENERATED CODE: Template Overrides 'SpectreM2'
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Spectre.ARC_GameUnit_SpectreM2");
	CharTemplate.bCanUse_eTraversal_ClimbOver = false;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = false;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_DropDown = false;
	CharTemplate.bCanUse_eTraversal_Launch = true;
	CharTemplate.bCanUse_eTraversal_Flying = true;
	CharTemplate.bCanUse_eTraversal_Land = true;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.strMatineePackages[0] = "CIN_XP_Spectre";
	CharTemplate.strIntroMatineeSlotPrefix = "CIN_Spectre_Reveal";
//END AUTOGENERATED CODE: Template Overrides 'SpectreM2'

	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bAppearanceDefinesPawn = false;
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;
	CharTemplate.MaxFlightPitchDegrees = 0;

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsHumanoid = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bWeakAgainstTechLikeRobot = true;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.Abilities.AddItem('SpectreMoveBegin');
	CharTemplate.Abilities.AddItem('Vanish');
	CharTemplate.Abilities.AddItem('LightningReflexes');
	CharTemplate.Abilities.AddItem('ShadowbindM2');
	//CharTemplate.Abilities.AddItem('ShadowboundLink');
	CharTemplate.Abilities.AddItem('KillShadowboundLinkedUnits');
	
	CharTemplate.ImmuneTypes.AddItem('Mental');
	CharTemplate.ImmuneTypes.AddItem('Fire');
	CharTemplate.ImmuneTypes.AddItem('Poison');
	CharTemplate.ImmuneTypes.AddItem(class'X2Item_DefaultDamageTypes'.default.ParthenogenicPoisonType);
	CharTemplate.ImmuneTypes.AddItem('Acid');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_TYG_T_First_Seen_Spectre_M1');

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_PsiZombieHuman(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	CharTemplate = class'X2Character_DefaultCharacters'.static.CreateTemplate_PsiZombie(TemplateName);
	CharTemplate.strPawnArchetypes.Length = 0;
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Zombie.ARC_GameUnit_Zombie_Human_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Zombie.ARC_GameUnit_Zombie_Human_F");

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}


static function X2CharacterTemplate CreateTemplate_Berserker(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'Berserker';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_Berserker.ARC_GameUnit_Berserker");
	Loot.ForceLevel=0;
	Loot.LootTableName='Berserker_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	//Loot.ForceLevel = 0;
	//Loot.LootTableName = 'Berserker_TimedLoot';
	//CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	//Loot.LootTableName = 'Berserker_VultureLoot';
	//CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	if (TemplateName == 'BerserkerM2')
	{
		CharTemplate.DefaultLoadout='BerserkerM2_Loadout';
		Loot.LootTableName = 'GenericMidAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
		CharTemplate.Abilities.AddItem('DevastatingPunch');
	}
	if (TemplateName == 'BerserkerM3')
	{
		CharTemplate.DefaultLoadout = 'BerserkerM3_Loadout';
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
		CharTemplate.Abilities.AddItem('DevastatingPunch');
	}
	if (TemplateName == 'BerserkerM4')
	{
		CharTemplate.DefaultLoadout = 'BerserkerM4_Loadout';
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
		CharTemplate.Abilities.AddItem('DevastatingPunch');
	}


	CharTemplate.strMatineePackages.AddItem("CIN_Berserker");

	CharTemplate.UnitSize = 1;
	CharTemplate.UnitHeight = 3; //One unit taller than normal
	// Traversal Rules
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
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bCanTakeCover = false;

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bIsMeleeOnly = true;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.AcquiredPhobiaTemplate = 'FearOfMutons';

	CharTemplate.bAllowSpawnFromATT = false;
	CharTemplate.bAllowRushCam = false;

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;
	CharTemplate.strScamperBT = "ScamperRoot_MeleeNoCover";

	CharTemplate.Abilities.AddItem('TriggerRageDamageListener');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_Berserker');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvStunLancer(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'AdventStunLancer';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvStunLancer.ARC_GameUnit_AdvStunLancerM3_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvStunLancer.ARC_GameUnit_AdvStunLancerM3_F");
	Loot.ForceLevel=0;
	Loot.LootTableName='AdvStunLancerM3_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	if (TemplateName == 'AdvStunLancerM4')
	{
		CharTemplate.DefaultLoadout='AdvStunLancerM4_Loadout';
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}
	if (TemplateName == 'AdvStunLancerM5')
	{
		CharTemplate.DefaultLoadout='AdvStunLancerM5_Loadout';
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_StunLancer";
	CharTemplate.GetRevealMatineePrefixFn = class'X2Character_DefaultCharacters'.static.GetAdventMatineePrefix;

	CharTemplate.UnitSize = 1;

	// Traversal Rules
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
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.AcquiredPhobiaTemplate = 'FearOfStunLancers';

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.T_Central_AlienSightings_AdvStunLancerM3');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	CharTemplate.Abilities.AddItem('AdventStilettoRounds');
	CharTemplate.Abilities.AddItem('DarkEventAbility_BendingReed');
	CharTemplate.Abilities.AddItem('DarkEventAbility_SealedArmor');
	CharTemplate.Abilities.AddItem('DarkEventAbility_UndyingLoyalty');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Counterattack');

	return CharTemplate;
}


static function X2CharacterTemplate CreateTemplate_AdvShieldBearer(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'AdventShieldBearer';
	CharTemplate.DefaultLoadout='AdvShieldBearerM3_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	Loot.ForceLevel=0;
	Loot.LootTableName='AdvShieldBearerM3_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvShieldBearer.ARC_GameUnit_AdvShieldBearerM3_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvShieldBearer.ARC_GameUnit_AdvShieldBearerM3_F");	

	if (TemplateName == 'AdvShieldBearerM4')
	{
		CharTemplate.DefaultLoadout='AdvShieldBearerM4_Loadout';
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
		CharTemplate.Abilities.AddItem('EnergyShieldMk4');
	
	}
	if (TemplateName == 'AdvShieldBearerM5')
	{
		CharTemplate.DefaultLoadout='AdvShieldBearerM5_Loadout';
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
		CharTemplate.Abilities.AddItem('EnergyShieldMk5');
	}

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_ShieldBearer";
	CharTemplate.GetRevealMatineePrefixFn = class'X2Character_DefaultCharacters'.static.GetAdventMatineePrefix;

	CharTemplate.UnitSize = 1;

	// Traversal Rules
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
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.Abilities.AddItem('AdventStilettoRounds');
	CharTemplate.Abilities.AddItem('DarkEventAbility_SealedArmor');
	CharTemplate.Abilities.AddItem('DarkEventAbility_UndyingLoyalty');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Counterattack');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.T_Central_AlienSightings_AdvShieldBearerM3');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

	static function X2CharacterTemplate CreateTemplate_AdvPriest(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'AdventPriest';
	CharTemplate.BehaviorClass = class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvPriest.ARC_GameUnit_AdvPriestM3_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvPriest.ARC_GameUnit_AdvPriestM3_F");

	// Auto-Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvPriestM3_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	if (TemplateName == 'AdvPriestM4')
	{
		CharTemplate.DefaultLoadout = 'AdvPriestM4_Loadout';
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}
	if (TemplateName == 'AdvPriestM5')
	{
		CharTemplate.DefaultLoadout = 'AdvPriestM5_Loadout';
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}


	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.strMatineePackages.AddItem("CIN_Soldier");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_Priest";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

	CharTemplate.UnitSize = 1;

	// Traversal Rules
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
	CharTemplate.bAppearanceDefinesPawn = false;
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = true;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = false;
	
	CharTemplate.Abilities.AddItem('Sustain');
	CharTemplate.Abilities.AddItem('AdventStilettoRounds');
	CharTemplate.Abilities.AddItem('DarkEventAbility_ReturnFire');
	CharTemplate.Abilities.AddItem('DarkEventAbility_SealedArmor');
	CharTemplate.Abilities.AddItem('DarkEventAbility_UndyingLoyalty');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Counterattack');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_TYG_T_First_Seen_Adv_Priest_M1');

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}

	static function X2CharacterTemplate CreateTemplate_AdvPurifier(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'AdventPurifier';
	CharTemplate.BehaviorClass = class'XGAIBehavior';
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvPurifier.ARC_GameUnit_AdvPurifierM3_M");
	CharTemplate.strPawnArchetypes.AddItem("GameUnit_AdvPurifier.ARC_GameUnit_AdvPurifierM3_F");

	// Auto-Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'AdvPurifierM3_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);


	if (TemplateName == 'AdvPurifierM4')
	{
		CharTemplate.DefaultLoadout = 'AdvPurifierM4_Loadout';
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}
	if (TemplateName == 'AdvPurifierM5')
	{
		CharTemplate.DefaultLoadout = 'AdvPurifierM5_Loadout';
		Loot.LootTableName = 'GenericLateAlienLoot_LW'; 
		CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
		Loot.LootTableName = 'GenericLateAlienVultureLoot_LW';
		CharTemplate.VultureLoot.LootReferences.AddItem(Loot);
	}

	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.strMatineePackages.AddItem("CIN_XP_Advent");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_Purifier";
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

	CharTemplate.UnitSize = 1;
	
	// Traversal Rules
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
	CharTemplate.bAppearanceDefinesPawn = false;
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = false;

	CharTemplate.Abilities.AddItem('PurifierInit');
	CharTemplate.Abilities.AddItem('DarkEventAbility_SealedArmor');
	CharTemplate.Abilities.AddItem('DarkEventAbility_UndyingLoyalty');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'XPACK_NarrativeMoments.X2_XP_CEN_T_First_Seen_Adv_Purifier_M1');

	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	return CharTemplate;
}
