//--------------------------------------------------------------------------------------- 
//  FILE:    X2Item_LWAlienweapons.uc
//  AUTHOR:	 Amineri / John Lumpkin (Pavonis Interactive)
//  PURPOSE: Defines news weapon for ADVENT/alien forces
//--------------------------------------------------------------------------------------- 
class X2Item_LWAlienWeapons extends X2Item config(GameData_WeaponData);

var config WeaponDamageValue MutonM2_LW_GRENADE_BASEDAMAGE;
var config WeaponDamageValue MutonM2_LW_WPN_BASEDAMAGE;
var config WeaponDamageValue MutonM2_LW_MELEEATTACK_BASEDAMAGE;
var config int MutonM2_LW_IDEALRANGE;
var config int MutonM2_LW_GRENADE_iENVIRONMENTDAMAGE;
var config int MutonM2_LW_GRENADE_iRANGE;
var config int MutonM2_LW_GRENADE_iRADIUS;

var config WeaponDamageValue MutonM3_LW_GRENADE_BASEDAMAGE;
var config WeaponDamageValue MutonM3_LW_WPN_BASEDAMAGE;
var config WeaponDamageValue MutonM3_LW_MELEEATTACK_BASEDAMAGE;
var config int MutonM3_LW_IDEALRANGE;
var config int MutonM3_LW_WPN_ICLIPSIZE;

var config int MutonM3_LW_GRENADE_iENVIRONMENTDAMAGE;
var config int MutonM3_LW_GRENADE_iRANGE;
var config int MutonM3_LW_GRENADE_iRADIUS;

var config WeaponDamageValue VIPERM2_WPN_BASEDAMAGE;
var config WeaponDamageValue VIPERM3_WPN_BASEDAMAGE;

var config WeaponDamageValue NAJA_WPN_BASEDAMAGE;
var config WeaponDamageValue NAJAM2_WPN_BASEDAMAGE;
var config WeaponDamageValue NAJAM3_WPN_BASEDAMAGE;
var config int NAJA_WPN_ICLIPSIZE;
var config int NAJA_IDEALRANGE;

var config WeaponDamageValue SIDEWINDER_WPN_BASEDAMAGE;
var config WeaponDamageValue SIDEWINDERM2_WPN_BASEDAMAGE;
var config WeaponDamageValue SIDEWINDERM3_WPN_BASEDAMAGE;
var config int SIDEWINDER_WPN_ICLIPSIZE;
var config int SIDEWINDER_IDEALRANGE;

var config int ADVSENTRY_IDEALRANGE;
var config WeaponDamageValue AdvSentryM1_WPN_BASEDAMAGE;
var config WeaponDamageValue AdvSentryM2_WPN_BASEDAMAGE;
var config WeaponDamageValue AdvSentryM3_WPN_BASEDAMAGE;

var config int ADVGRENADIER_FLASHBANGGRENADE_RANGE;
var config int ADVGRENADIER_FLASHBANGGRENADE_RADIUS;
var config int ADVGRENADIER_FLASHBANGGRENADE_IENVIRONMENTDAMAGE;
var config int ADVGRENADIER_FLASHBANGGRENADE_ICLIPSIZE;

var config WeaponDamageValue ADVGRENADIER_FIREGRENADE_BASEDAMAGE;
var config int ADVGRENADIER_FIREGRENADE_RANGE;
var config int ADVGRENADIER_FIREGRENADE_RADIUS;
var config int ADVGRENADIER_FIREGRENADE_COVERAGE;
var config int ADVGRENADIER_FIREGRENADE_ISOUNDRANGE;
var config int ADVGRENADIER_FIREBOMB_IENVIRONMENTDAMAGE;
var config int ADVGRENADIER_FIREBOMB_ICLIPSIZE;

var config WeaponDamageValue ADVGRENADIER_ACIDGRENADE_BASEDAMAGE;
var config int ADVGRENADIER_ACIDGRENADE_RANGE;
var config int ADVGRENADIER_ACIDGRENADE_RADIUS;
var config int ADVGRENADIER_ACIDGRENADE_COVERAGE;
var config int ADVGRENADIER_ACIDGRENADE_ISOUNDRANGE;
var config int ADVGRENADIER_ACIDGRENADE_IENVIRONMENTDAMAGE;
var config int ADVGRENADIER_ACIDGRENADE_ICLIPSIZE;

var config int ADVGRENADIER_IDEALRANGE;

var config WeaponDamageValue ADVROCKETEERM1_ROCKETEERLAUNCHER_BASEDAMAGE;
var config int ADVROCKETEERM1_ROCKETEERLAUNCHER_ISOUNDRANGE;
var config int ADVROCKETEERM1_ROCKETEERLAUNCHER_IENVIRONMENTDAMAGE;
var config int ADVROCKETEERM1_ROCKETEERLAUNCHER_CLIPSIZE;
var config int ADVROCKETEERM1_ROCKETEERLAUNCHER_RANGE;
var config int ADVROCKETEERM1_ROCKETEERLAUNCHER_RADIUS;
var config int ADVROCKETEERM1_IDEALRANGE;

var config WeaponDamageValue ADVGUNNER_WPN_BASEDAMAGE;
var config WeaponDamageValue ADVGUNNERM2_WPN_BASEDAMAGE;
var config WeaponDamageValue ADVGUNNERM3_WPN_BASEDAMAGE;
var config int ADVGUNNER_IDEALRANGE;
var config int ADVGUNNER_WPN_CLIPSIZE;

var config int AdvMECArcher_IdealRange;
var config WeaponDamageValue AdvMECArcher_Wpn_BaseDamage;
var config int AdvMECArcher_Wpn_Clipsize;
var config int AdvMECArcher_Wpn_EnvironmentDamage;
var config WeaponDamageValue AdvMECArcher_MicroMissiles_BaseDamage;
var config int AdvMECArcher_MicroMissiles_Clipsize;
var config int AdvMECArcher_MicroMissiles_EnvironmentDamage;
var config int AdvMECArcher_Micromissiles_Range;

var config WeaponDamageValue LWDRONEM1_DRONEWEAPON_BASEDAMAGE;
var config WeaponDamageValue LWDRONEM2_DRONEWEAPON_BASEDAMAGE;

var config int LWDRONE_DRONEWEAPON_ISOUNDRANGE;
var config int LWDRONE_DRONEWEAPON_IENVIRONMENTDAMAGE;
var config int LWDRONE_DRONEWEAPON_RANGE;

var config WeaponDamageValue LWDRONEM1_DRONEREPAIRWEAPON_BASEDAMAGE;
var config WeaponDamageValue LWDRONEM2_DRONEREPAIRWEAPON_BASEDAMAGE;

var config int LWDRONE_DRONEREPAIRWEAPON_ISOUNDRANGE;
var config int LWDRONE_DRONEREPAIRWEAPON_IENVIRONMENTDAMAGE;
var config int LWDRONE_DRONEREPAIRWEAPON_RANGE;

var config int LWDRONE_IDEALRANGE;

var config int ADVVANGUARD_IDEALRANGE;
var config int VANGUARD_ASSAULTRIFLE_ICLIPSIZE;

var config WeaponDamageValue AdvSergeantM1_WPN_BASEDAMAGE;
var config WeaponDamageValue AdvSergeantM2_WPN_BASEDAMAGE;
var config WeaponDamageValue AdvShockTroop_WPN_BASEDAMAGE;
var config WeaponDamageValue AdvCommando_WPN_BASEDAMAGE;
var config WeaponDamageValue AdvVanguard_WPN_BASEDAMAGE;
var config WeaponDamageValue AdvScout_WPN_BASEDAMAGE;
var config WeaponDamageValue AdvGeneralM1_WPN_BASEDAMAGE;
var config WeaponDamageValue AdvGeneralM2_WPN_BASEDAMAGE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	`LWTrace("  >> X2Item_LWAlienWeapons.CreateTemplates()");
	
	Templates.AddItem(CreateMutonM2_LWGrenade());
	Templates.AddItem(CreateTemplate_MutonM2_LW_WPN());
	Templates.AddItem(CreateTemplate_MutonM2_LW_MeleeAttack());

	Templates.AddItem(CreateMutonM3_LWGrenade());
	Templates.AddItem(CreateTemplate_MutonM3_LW_WPN());
	
	Templates.AddItem(CreateTemplate_Naja_WPN('NajaM1_WPN'));
	Templates.AddItem(CreateTemplate_Naja_WPN('NajaM2_WPN'));
	Templates.AddItem(CreateTemplate_Naja_WPN('NajaM3_WPN'));

	Templates.AddItem(CreateTemplate_Sidewinder_WPN('SidewinderM1_WPN'));
	Templates.AddItem(CreateTemplate_Sidewinder_WPN('SidewinderM2_WPN'));
	Templates.AddItem(CreateTemplate_Sidewinder_WPN('SidewinderM3_WPN'));

	Templates.AddItem(CreateTemplate_ViperMX_WPN('ViperM2_LW_WPN'));
	Templates.AddItem(CreateTemplate_ViperMX_WPN('ViperM3_LW_WPN'));

	Templates.AddItem(CreateTemplate_AdvGunner_WPN('AdvGunnerM1_WPN'));
	Templates.AddItem(CreateTemplate_AdvGunner_WPN('AdvGunnerM2_WPN'));
	Templates.AddItem(CreateTemplate_AdvGunner_WPN('AdvGunnerM3_WPN'));
	
	Templates.AddItem(CreateTemplate_AdvSentry_WPN('AdvSentryM1_WPN'));
	Templates.AddItem(CreateTemplate_AdvSentry_WPN('AdvSentryM2_WPN'));
	Templates.AddItem(CreateTemplate_AdvSentry_WPN('AdvSentryM3_WPN'));

	Templates.AddItem(CreateTemplate_AdvGrenadier_GrenadeLauncher('AdvGrenadierM1_GrenadeLauncher'));
	Templates.AddItem(CreateTemplate_AdvGrenadier_GrenadeLauncher('AdvGrenadierM2_GrenadeLauncher'));
	Templates.AddItem(CreateTemplate_AdvGrenadier_GrenadeLauncher('AdvGrenadierM3_GrenadeLauncher'));

	Templates.AddItem(CreateTemplate_AdvGrenadier_Flashbang());
	Templates.AddItem(CreateTemplate_AdvGrenadier_FireGrenade());
	Templates.AddItem(CreateTemplate_AdvGrenadier_AcidGrenade());

	Templates.AddItem(CreateHeavyPoweredArmor());
	Templates.AddItem(CreateTemplate_AdvRocketeerM1_RocketLauncher());

	Templates.AddItem(CreateTemplate_AdvMECArcher_WPN());
	Templates.AddItem(CreateTemplate_AdvMECArcher_Shoulder_WPN());

	Templates.AddItem(CreateTemplate_LWDrone_WPN('LWDroneM1_WPN'));
	Templates.AddItem(CreateTemplate_LWDrone_WPN('LWDroneM2_WPN'));
	
	Templates.AddItem(CreateTemplate_LWDroneRepair_WPN('LWDroneRepairM1_WPN'));
	Templates.AddItem(CreateTemplate_LWDroneRepair_WPN('LWDroneRepairM2_WPN'));

	Templates.AddItem(CreateTemplate_AdvElite_WPN('AdvVanguard_WPN'));
	Templates.AddItem(CreateTemplate_AdvElite_WPN('AdvShockTroop_WPN'));
	Templates.AddItem(CreateTemplate_AdvElite_WPN('AdvSergeantM1_WPN'));
	Templates.AddItem(CreateTemplate_AdvElite_WPN('AdvSergeantM2_WPN'));
	Templates.AddItem(CreateTemplate_AdvElite_WPN('AdvScout_WPN'));
	Templates.AddItem(CreateTemplate_AdvElite_WPN('AdvCommando_WPN'));
	Templates.AddItem(CreateTemplate_AdvElite_WPN('AdvGeneralM1_WPN'));
	Templates.AddItem(CreateTemplate_AdvElite_WPN('AdvGeneralM2_WPN'));

	return Templates;
}


static function X2DataTemplate CreateTemplate_MutonM2_LW_WPN()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'MutonM2_LW_WPN');
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.MutonRifle";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.MutonM2_LW_WPN_BASEDAMAGE;
	Template.iClipSize = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.MutonM2_LW_IDEALRANGE;

	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('Suppression');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Execute');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Muton_Rifle.WP_MutonRifle";  // re-use base-game Muton Rifle art assets

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	return Template;
}

static function X2DataTemplate CreateTemplate_MutonM2_LW_MeleeAttack()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'MutonM2_LW_MeleeAttack');
	
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'baton';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.Sword";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Muton_Bayonet.WP_MutonBayonet"; // re-use base game art assets for melee weapon
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.Aim = class'X2Item_DefaultWeapons'.default.GENERIC_MELEE_ACCURACY;

	Template.iRange = 0;
	Template.iRadius = 1;
	Template.NumUpgradeSlots = 2;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;
	Template.iIdealRange = 1;

	Template.BaseDamage = default.MutonM2_LW_MELEEATTACK_BASEDAMAGE;
	Template.BaseDamage.DamageType='Melee';
	Template.iSoundRange = 2;
	Template.iEnvironmentDamage = 10;

	//Build Data
	Template.StartingItem = false;
	Template.CanBeBuilt = false;

	Template.Abilities.AddItem('Bayonet');
	Template.Abilities.AddItem('BayonetCharge');
	Template.Abilities.AddItem('CounterattackBayonet');

	return Template;
}


static function X2DataTemplate CreateMutonM2_LWGrenade()
{
	local X2GrenadeTemplate Template;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;

	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, 'MutonM2_LWGrenade');

	Template.strImage = "img:///UILibrary_StrategyImages.InventoryIcons.Inv_AlienGrenade";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.BaseDamage = default.MutonM2_LW_GRENADE_BASEDAMAGE;
	Template.iEnvironmentDamage = default.MutonM2_LW_GRENADE_iENVIRONMENTDAMAGE;
	Template.iRange = default.MutonM2_LW_GRENADE_iRANGE;
	Template.iRadius = default.MutonM2_LW_GRENADE_iRADIUS;
	Template.iClipSize = 1;
	Template.iSoundRange = class'X2Item_DefaultGrenades'.default.GRENADE_SOUND_RANGE;
	Template.DamageTypeTemplateName = 'Explosion';
	
	Template.Abilities.AddItem('ThrowGrenade');
	Template.Abilities.AddItem('GrenadeFuse');

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);
	Template.LaunchedGrenadeEffects.AddItem(WeaponDamageEffect);
	
	Template.GameArchetype = "WP_Grenade_Alien.WP_Grenade_Alien";

	Template.iPhysicsImpulse = 10;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 50;

	return Template;
}

// Muton Elite Gear

static function X2DataTemplate CreateTemplate_MutonM3_LW_WPN()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'MutonM3_LW_WPN');
	
	Template.WeaponPanelImage = "_BeamCannon";
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'cannon';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///UILibrary_Common.UI_BeamCannon.BeamCannon_Base";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.MutonM3_LW_WPN_BASEDAMAGE;
	Template.iClipSize = default.MutonM3_LW_WPN_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.LMG_BEAM_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.LMG_BEAM_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.MutonM3_LW_IDEALRANGE;

	Template.DamageTypeTemplateName = 'Projectile_BeamXCom';
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	//Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('Suppression');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Execute');

	Template.Abilities.AddItem('LightEmUp');

 	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWMutonM3Rifle.Archetypes.WP_MutonM3Rifle_Base";  // upscaled, recolored beam cannon

	Template.AddDefaultAttachment('Mag', "LWMutonM3Rifle.Meshes.SK_MutonM3Rifle_Mag",, "img:///UILibrary_Common.UI_BeamCannon.BeamCannon_MagA");
    Template.AddDefaultAttachment('Core', "LWMutonM3Rifle.Meshes.SK_MutonM3Rifle_Core",, "img:///UILibrary_Common.UI_BeamCannon.BeamCannon_CoreA");
    Template.AddDefaultAttachment('Core_Center', "LWMutonM3Rifle.Meshes.SK_MutonM3Rifle_Core_Center");
    Template.AddDefaultAttachment('HeatSink', "LWMutonM3Rifle.Meshes.SK_MutonM3Rifle_HeatSink",, "img:///UILibrary_Common.UI_BeamCannon.BeamCannon_HeatsinkA");
    Template.AddDefaultAttachment('Suppressor', "LWMutonM3Rifle.Meshes.SK_MutonM3Rifle_Suppressor",, "img:///UILibrary_Common.UI_BeamCannon.BeamCannon_SupressorA");

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	return Template;
}

static function X2DataTemplate CreateMutonM3_LWGrenade()
{
	local X2GrenadeTemplate Template;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;

	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, 'MutonM3_LWGrenade');

	Template.strImage = "img:///UILibrary_StrategyImages.InventoryIcons.Inv_AlienGrenade";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.BaseDamage = default.MutonM3_LW_GRENADE_BASEDAMAGE;
	Template.iEnvironmentDamage = default.MutonM3_LW_GRENADE_iENVIRONMENTDAMAGE;
	Template.iRange = default.MutonM3_LW_GRENADE_iRANGE;
	Template.iRadius = default.MutonM3_LW_GRENADE_iRADIUS;
	Template.iClipSize = 1;
	Template.iSoundRange = class'X2Item_DefaultGrenades'.default.GRENADE_SOUND_RANGE;
	Template.DamageTypeTemplateName = 'Explosion';
	
	Template.Abilities.AddItem('ThrowGrenade');
	Template.Abilities.AddItem('GrenadeFuse');

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);
	Template.LaunchedGrenadeEffects.AddItem(WeaponDamageEffect);
	
	Template.GameArchetype = "WP_Grenade_Alien.WP_Grenade_Alien";

	Template.iPhysicsImpulse = 10;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 50;

	return Template;
}


static function X2DataTemplate CreateTemplate_Naja_WPN(name TemplateName)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);
	
	Template.WeaponPanelImage = "_ConventionalRifle";                  
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'sniper_rifle';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_Base";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.LONG_BEAM_RANGE;

	if (TemplateName == 'NajaM1_WPN')
		Template.BaseDamage = default.NAJA_WPN_BASEDAMAGE;
	if (TemplateName == 'NajaM2_WPN')
		Template.BaseDamage = default.NAJAM2_WPN_BASEDAMAGE;
	if (TemplateName == 'NajaM3_WPN')
		Template.BaseDamage = default.NAJAM3_WPN_BASEDAMAGE;

	Template.iClipSize = default.NAJA_WPN_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.NAJA_IDEALRANGE;

	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('SniperStandardFire');
	Template.Abilities.AddItem('SniperRifleOverwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	//Issue #162, Naja should not be able to move and shoot so made rifle shot cost 2 AP.
	Template.iTypicalActionCost = 2;

	if (TemplateName == 'NajaM1_WPN' || TemplateName == 'NajaM2_WPN' || TemplateName == 'NajaM3_WPN')
	{
		Template.Abilities.AddItem('DamnGoodGround');
	}
	if (TemplateName == 'NajaM2_WPN' || TemplateName == 'NajaM3_WPN')
	{
		Template.Abilities.AddItem('Executioner_LW'); //weapon perk
		Template.Abilities.AddItem('LongWatch'); // weapon perk
	}
	if (TemplateName == 'NajaM3_WPN')
	{
		//Template.Abilities.AddItem('DeathfromAbove_LW');
	}

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "NajaRifle.WP_NajaRifle"; 

	//Template.AddDefaultAttachment('Optic', "BeamSniper.Meshes.SM_BeamSniper_OpticA", , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_OpticA");
	Template.AddDefaultAttachment('Mag', "NajaRifle.Meshes.SM_BeamSniper_MagB", , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_MagB");
	//Template.AddDefaultAttachment('Suppressor', "BeamSniper.Meshes.SM_BeamSniper_SuppressorA", , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_SupressorA");
	Template.AddDefaultAttachment('Core', "NajaRifle.Meshes.SM_NajaRifle_CoreB", , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_CoreB");
	Template.AddDefaultAttachment('HeatSink', "NajaRifle.Meshes.SM_BeamSniper_HeatSinkA", , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_HeatsinkA");
	Template.AddDefaultAttachment('Autoloader', "NajaRifle.Meshes.SM_BeamSniper_MagC", , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_AutoLoader");

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	return Template;
}

static function X2DataTemplate CreateTemplate_Sidewinder_WPN(name TemplateName)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'smg';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///LWSidewinderSMG.Textures.LWBeamSMG_Common"; 
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_CONVENTIONAL_RANGE;
	
	if (TemplateName == 'SidewinderM1_WPN')
		Template.BaseDamage = default.SIDEWINDER_WPN_BASEDAMAGE;
	if (TemplateName == 'SidewinderM2_WPN')
		Template.BaseDamage = default.SIDEWINDERM2_WPN_BASEDAMAGE;
	if (TemplateName == 'SidewinderM3_WPN')
		Template.BaseDamage = default.SIDEWINDERM3_WPN_BASEDAMAGE;

	Template.iClipSize = default.SIDEWINDER_WPN_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.SIDEWINDER_IDEALRANGE;

	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	if (TemplateName == 'SidewinderM1_WPN' || TemplateName == 'SidewinderM2_WPN' || TemplateName == 'SidewinderM3_WPN')
	{
		//future use
	}
	if (TemplateName == 'SidewinderM2_WPN' || TemplateName == 'SidewinderM3_WPN')
	{	
		Template.Abilities.AddItem('HitandSlither');
	}
	if (TemplateName == 'SidewinderM3_WPN')
	{
		Template.Abilities.AddItem('HuntersInstinct');
	}
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWSidewinderSMG.Archetypes.WP_Sidewinder_SMG";  

	//Template.AddDefaultAttachment('Optic', "BeamSniper.Meshes.SM_BeamSniper_OpticA", , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_OpticA");
	Template.AddDefaultAttachment('Mag', "LWSidewinderSMG.Meshes.SM_BeamAssaultRifle_MagB");
	//Template.AddDefaultAttachment('Suppressor', "BeamSniper.Meshes.SM_BeamSniper_SuppressorA", , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_SupressorA");
	Template.AddDefaultAttachment('Core', "LWSidewinderSMG.Meshes.SK_LWBeamSMG_CoreA");
	//Template.AddDefaultAttachment('HeatSink', "NajaRifle.Meshes.SM_BeamSniper_HeatSinkA", , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_HeatsinkA");
	//Template.AddDefaultAttachment('Autoloader', "NajaRifle.Meshes.SM_BeamSniper_MagC", , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_AutoLoader");

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	return Template;
}

static function X2DataTemplate CreateTemplate_AdvGunner_WPN(name TemplateName)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'cannon';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.UI_MagCannon.MagCannon_Base";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;

	if (TemplateName == 'AdvGunnerM1_WPN')
		Template.BaseDamage = default.ADVGUNNER_WPN_BASEDAMAGE;
	if (TemplateName == 'AdvGunnerM2_WPN')
		Template.BaseDamage = default.ADVGUNNERM2_WPN_BASEDAMAGE;
	if (TemplateName == 'AdvGunnerM3_WPN')
		Template.BaseDamage = default.ADVGUNNERM3_WPN_BASEDAMAGE;

	Template.iClipSize = default.ADVGUNNER_WPN_CLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.LMG_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.LMG_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.ADVGUNNER_IDEALRANGE;

	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('AreaSuppression');

	if (TemplateName == 'AdvGunnerM2_WPN' || TemplateName == 'AdvGunnerM3_WPN')
	{
		Template.Abilities.AddItem('LockedOn');
	}
	if (TemplateName == 'AdvGunnerM3_WPN')
	{
		Template.Abilities.AddItem('TraverseFire');
		Template.Abilities.AddItem('CoveringFire');
	}
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWAdvGunner.Archetypes.WP_Cannon_MG";  

	Template.AddDefaultAttachment('Mag', "LWAdvGunner.Meshes.SK_MagCannon_Mag", , "img:///UILibrary_Common.UI_MagCannon.MagCannon_MagA");
	Template.AddDefaultAttachment('Reargrip',   "LWAdvGunner.Meshes.SM_MagCannon_Reargrip");
	Template.AddDefaultAttachment('Foregrip', "LWAdvGunner.Meshes.SM_MagCannon_Stock", , "img:///UILibrary_Common.UI_MagCannon.MagCannon_StockA");

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	return Template;
}


static function X2DataTemplate CreateTemplate_AdvSentry_WPN(name TemplateName)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);

	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventAssaultRifle";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
    Template.iClipSize = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ICLIPSIZE; 

    Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	if (TemplateName == 'AdvSentryM1_WPN')
		Template.BaseDamage = class'X2Item_DefaultWeapons'.default.AdvCaptainM1_WPN_BASEDAMAGE;
	if (TemplateName == 'AdvSentryM2_WPN')
		Template.BaseDamage = class'X2Item_DefaultWeapons'.default.AdvCaptainM2_WPN_BASEDAMAGE;
	if (TemplateName == 'AdvSentryM3_WPN')
		Template.BaseDamage = class'X2Item_DefaultWeapons'.default.AdvCaptainM3_WPN_BASEDAMAGE;

    Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
    Template.iIdealRange = default.ADVSENTRY_IDEALRANGE; //check this

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
		
	if (TemplateName == 'AdvSentryM2_WPN')
	{
		Template.Abilities.AddItem('CoolUnderPressure');
		Template.Abilities.AddItem('Sentinel');
		Template.Abilities.AddItem('CoveringFire');
	}

	if (TemplateName == 'AdvSentryM3_WPN')
	{
		Template.Abilities.AddItem('CoolUnderPressure');
		Template.Abilities.AddItem('Sentinel_LW');
		Template.Abilities.AddItem('CoveringFire');
	}

	Template.GameArchetype = "WP_AssaultRifle_MG.WP_AssaultRifle_MG_Advent";
	Template.iPhysicsImpulse = 5;
	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;
	Template.DamageTypeTemplateName = 'Projectile_MagAdvent';

	return Template;
}


static function X2DataTemplate CreateTemplate_AdvGrenadier_GrenadeLauncher(name TemplateName)
{
	local X2GrenadeLauncherTemplate Template;

	`CREATE_X2TEMPLATE(class'X2GrenadeLauncherTemplate', Template, TemplateName);

	Template.strImage = "img:///UILibrary_Common.MagSecondaryWeapons.MagLauncher";
	Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";

	Template.InventorySlot = eInvSlot_SecondaryWeapon;

	Template.iSoundRange = class'X2Item_DefaultGrenades'.default.ADVGRENADELAUNCHER_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultGrenades'.default.ADVGRENADELAUNCHER_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = 18;
	Template.iClipSize = class'X2Item_DefaultGrenades'.default.ADVGRENADELAUNCHER_ICLIPSIZE;
	Template.Tier = 1;
	Template.iIdealRange = default.ADVGRENADIER_IDEALRANGE;

	// REMOVED because this seems to rely on HasSoldierAbility, which doesn't work for advent/aliens
	//if (TemplateName == 'AdvGrenadeLauncherM1')
	//{
		//Template.IncreaseGrenadeRadius = default.ADVGRENADIERM1_GRENADELAUNCHER_RADIUSBONUS;
		//Template.IncreaseGrenadeRange = default.ADVGRENADIERM1_GRENADELAUNCHER_RANGEBONUS;
	//}
	//if (TemplateName == 'AdvGrenadeLauncherM2')
	//{
		//Template.IncreaseGrenadeRadius = default.ADVGRENADIERM2_GRENADELAUNCHER_RADIUSBONUS;
		//Template.IncreaseGrenadeRange = default.ADVGRENADIERM2_GRENADELAUNCHER_RANGEBONUS;
	//}
	//if (TemplateName == 'AdvGrenadeLauncherM3')
	//{
		//Template.IncreaseGrenadeRadius = default.ADVGRENADIERM3_GRENADELAUNCHER_RADIUSBONUS;
		//Template.IncreaseGrenadeRange = default.ADVGRENADIERM3_GRENADELAUNCHER_RANGEBONUS;
	//}

	//Template.Abilities.AddItem('LaunchGrenade');  // remove this to prevent a "null" LaunchGrenade ability which confuses the AI
	Template.Abilities.AddItem('AdventGrenadeLauncher');

	Template.GameArchetype = "AdvGrenadeLauncher.WP_AdvGrenadeLauncher";

	Template.CanBeBuilt = false;

	return Template;
}

static function X2DataTemplate CreateTemplate_AdvGrenadier_Flashbang()
{
	local X2GrenadeTemplate Template;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;

	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, 'AdvGrenadierFlashbangGrenade');

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons..Inv_Flashbang_Grenade";
	Template.AddAbilityIconOverride('ThrowGrenade', "img:///UILibrary_PerkIcons.UIPerk_grenade_flash");
	Template.AddAbilityIconOverride('LaunchGrenade', "img:///UILibrary_PerkIcons.UIPerk_grenade_flash");
	Template.iRange = default.ADVGRENADIER_FLASHBANGGRENADE_RANGE;
	Template.iRadius = default.ADVGRENADIER_FLASHBANGGRENADE_RADIUS;
	
	Template.bFriendlyFire = false;
	Template.bFriendlyFireWarning = false;
	Template.Abilities.AddItem('ThrowGrenade');

	Template.ThrownGrenadeEffects.AddItem(class'X2StatusEffects'.static.CreateDisorientedStatusEffect());

	//We need to have an ApplyWeaponDamage for visualization, even if the grenade does 0 damage (makes the unit flinch, shows overwatch removal)
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);

	Template.LaunchedGrenadeEffects = Template.ThrownGrenadeEffects;
	
	Template.GameArchetype = "WP_Grenade_Flashbang.WP_Grenade_Flashbang";

	Template.iEnvironmentDamage = default.ADVGRENADIER_FLASHBANGGRENADE_IENVIRONMENTDAMAGE;
	Template.iClipSize = default.ADVGRENADIER_FLASHBANGGRENADE_ICLIPSIZE;

	return Template;
}

static function X2DataTemplate CreateTemplate_AdvGrenadier_FireGrenade()
{
	local X2GrenadeTemplate Template;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;

	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, 'AdvGrenadierFireGrenade');

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Firebomb";
	Template.AddAbilityIconOverride('ThrowGrenade', "img:///UILibrary_PerkIcons.UIPerk_grenade_firebomb");
	Template.AddAbilityIconOverride('LaunchGrenade', "img:///UILibrary_PerkIcons.UIPerk_grenade_firebomb");

	Template.BaseDamage = default.ADVGRENADIER_FIREGRENADE_BASEDAMAGE;
	Template.iRange = default.ADVGRENADIER_FIREGRENADE_RANGE;
	Template.iRadius = default.ADVGRENADIER_FIREGRENADE_RADIUS;
	Template.fCoverage = default.ADVGRENADIER_FIREGRENADE_COVERAGE;
	Template.iSoundRange = default.ADVGRENADIER_FIREGRENADE_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ADVGRENADIER_FIREBOMB_IENVIRONMENTDAMAGE;
	Template.iClipSize = default.ADVGRENADIER_FIREBOMB_ICLIPSIZE;
	Template.Tier = 1;

	Template.Abilities.AddItem('ThrowGrenade');
	Template.Abilities.AddItem('GrenadeFuse');

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);
	Template.ThrownGrenadeEffects.AddItem(new class'X2Effect_ApplyFireToWorld');
	Template.ThrownGrenadeEffects.AddItem(class'X2StatusEffects'.static.CreateBurningStatusEffect(2, 1));
	Template.LaunchedGrenadeEffects = Template.ThrownGrenadeEffects;
	
	Template.GameArchetype = "WP_Grenade_Fire.WP_Grenade_Fire";

	Template.iPhysicsImpulse = 10;

	return Template;
}

static function X2DataTemplate CreateTemplate_AdvGrenadier_AcidGrenade()
{
	local X2GrenadeTemplate Template;
	local X2Effect_ApplyAcidToWorld WeaponEffect;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;

	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, 'AdvGrenadierAcidGrenade');

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Acid_Bomb";
	Template.AddAbilityIconOverride('ThrowGrenade', "img:///UILibrary_PerkIcons.UIPerk_grenade_acidbomb");
	Template.AddAbilityIconOverride('LaunchGrenade', "img:///UILibrary_PerkIcons.UIPerk_grenade_acidbomb");

	Template.BaseDamage = default.ADVGRENADIER_ACIDGRENADE_BASEDAMAGE;
	Template.iRange = default.ADVGRENADIER_ACIDGRENADE_RANGE;
	Template.iRadius = default.ADVGRENADIER_ACIDGRENADE_RADIUS;
	Template.fCoverage = default.ADVGRENADIER_ACIDGRENADE_COVERAGE;
	Template.iSoundRange = default.ADVGRENADIER_ACIDGRENADE_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ADVGRENADIER_ACIDGRENADE_IENVIRONMENTDAMAGE;
	Template.iClipSize = default.ADVGRENADIER_ACIDGRENADE_ICLIPSIZE;
	Template.Tier = 1;
	
	Template.Abilities.AddItem('ThrowGrenade');
	Template.Abilities.AddItem('GrenadeFuse');
	
	WeaponEffect = new class'X2Effect_ApplyAcidToWorld';	
	Template.ThrownGrenadeEffects.AddItem(WeaponEffect);
	Template.ThrownGrenadeEffects.AddItem(class'X2StatusEffects'.static.CreateAcidBurningStatusEffect(1,0));
	// immediate damage
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);

	Template.LaunchedGrenadeEffects = Template.ThrownGrenadeEffects;
	
	Template.GameArchetype = "WP_Grenade_Acid.WP_Grenade_Acid";

	return Template;
}

static function X2DataTemplate CreateTemplate_AdvRocketeerM1_RocketLauncher()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AdvRocketeerM1_RocketLauncher');
	Template.WeaponCat = 'heavy';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Rocket_Launcher";
	Template.EquipSound = "StrategyUI_Heavy_Weapon_Equip";

	Template.BaseDamage = default.ADVROCKETEERM1_ROCKETEERLAUNCHER_BASEDAMAGE;
	Template.iSoundRange = default.ADVROCKETEERM1_ROCKETEERLAUNCHER_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ADVROCKETEERM1_ROCKETEERLAUNCHER_IENVIRONMENTDAMAGE;
	Template.iClipSize = default.ADVROCKETEERM1_ROCKETEERLAUNCHER_CLIPSIZE;
	Template.iRange = default.ADVROCKETEERM1_ROCKETEERLAUNCHER_RANGE;
	Template.iRadius = default.ADVROCKETEERM1_ROCKETEERLAUNCHER_RADIUS;
	
	Template.InventorySlot = eInvSlot_HeavyWeapon;
	Template.StowedLocation = eSlot_HeavyWeapon;
	Template.GameArchetype = "WP_Heavy_RocketLauncher.WP_Heavy_RocketLauncher";
	//Template.GameArchetype = "WP_Heavy_RocketLauncher.WP_Heavy_RocketLauncher_Powered";
	Template.bMergeAmmo = true;
	Template.DamageTypeTemplateName = 'Explosion';

	Template.Abilities.AddItem('RocketLauncher');
	Template.Abilities.AddItem('RocketFuse');

	Template.CanBeBuilt = false;
		
	return Template;
}

static function X2DataTemplate CreateHeavyPoweredArmor()
{
	local X2ArmorTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ArmorTemplate', Template, 'AdvRocketeer_HeavyPoweredArmor');
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Marauder_Armor";
	Template.ItemCat = 'armor';
	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.TradingPostValue = 120;
	Template.PointsToComplete = 0;
	Template.bHeavyWeapon = true;

	Template.InventorySlot = eInvSlot_Armor;

	//Template.Abilities.AddItem('HeavyPoweredArmorStats');
	//Template.Abilities.AddItem('HighCoverGenerator');
	Template.ArmorTechCat = 'powered';
	Template.Tier = 4;
	Template.AkAudioSoldierArmorSwitch = 'WAR';
	Template.EquipNarrative = "X2NarrativeMoments.Strategy.CIN_ArmorIntro_PoweredHeavy";
	Template.EquipSound = "StrategyUI_Armor_Equip_Powered";

	//Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, class'X2Ability_ItemGrantedAbilitySet'.default.HEAVY_POWERED_HEALTH_BONUS, true);
	//Template.SetUIStatMarkup(class'XLocalizedData'.default.ArmorLabel, eStat_ArmorMitigation, class'X2Ability_ItemGrantedAbilitySet'.default.HEAVY_POWERED_MITIGATION_AMOUNT);
	
	return Template;
}



static function X2DataTemplate CreateTemplate_AdvMECArcher_WPN()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AdvMECArcher_WPN');
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventMecGun";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.ADVMECArcher_WPN_BASEDAMAGE;
	Template.iClipSize = default.AdvMECArcher_Wpn_Clipsize;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.AdvMECArcher_Wpn_EnvironmentDamage;
	Template.iIdealRange = default.ADVMECArcher_IDEALRANGE;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Suppression');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_AdvMec_Gun.WP_AdvMecGun"; 

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	Template.DamageTypeTemplateName = 'Projectile_MagAdvent';

	return Template;
}

static function X2DataTemplate CreateTemplate_AdvMECArcher_Shoulder_WPN()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AdvMECArcher_Shoulder_WPN');
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'shoulder_launcher';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventMecGun";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.AdvMECArcher_MicroMissiles_BaseDamage;
	Template.iClipSize = default.AdvMECArcher_MicroMissiles_Clipsize;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.AdvMECArcher_MicroMissiles_EnvironmentDamage;
	Template.iIdealRange = default.ADVMECArcher_IDEALRANGE;
	
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('MicroMissiles');
	Template.Abilities.AddItem('MicroMissileFuse');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWAdvMecArcher.Archetypes.WP_AdvMecBigLauncher"; 

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;
	Template.iRange = default.AdvMECArcher_Micromissiles_Range;


	// This controls how much arc this projectile may have and how many times it may bounce
	Template.WeaponPrecomputedPathData.InitialPathTime = 1.5;
	Template.WeaponPrecomputedPathData.MaxPathTime = 2.5;
	Template.WeaponPrecomputedPathData.MaxNumberOfBounces = 0;

	Template.DamageTypeTemplateName = 'Explosion';

	return Template;
}


static function X2DataTemplate CreateTemplate_LWDrone_WPN(name TemplateName)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_LWAlienPack.LWAdventDrone_ArcWeapon";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	if(TemplateName == 'LWDroneM1_WPN')
		Template.BaseDamage = default.LWDRONEM1_DRONEWEAPON_BASEDAMAGE;
	if(TemplateName == 'LWDroneM2_WPN')
		Template.BaseDamage = default.LWDRONEM2_DRONEWEAPON_BASEDAMAGE;

	Template.iRange = default.LWDRONE_DRONEWEAPON_RANGE;
	Template.iSoundRange = default.LWDRONE_DRONEWEAPON_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.LWDRONE_DRONEWEAPON_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.LWDRONE_IDEALRANGE;

	Template.iClipSize = 99;
	Template.InfiniteAmmo = true;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('LWDroneShock');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWDroneWeapon.Archetypes.WP_DroneBeam";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	return Template;
}

static function X2DataTemplate CreateTemplate_LWDroneRepair_WPN(name TemplateName)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.GatekeeperEyeball"; 
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	if(TemplateName == 'LWDroneRepairM1_WPN')
		Template.BaseDamage = default.LWDRONEM1_DRONEREPAIRWEAPON_BASEDAMAGE;
	if(TemplateName == 'LWDroneRepairM2_WPN')
		Template.BaseDamage = default.LWDRONEM2_DRONEREPAIRWEAPON_BASEDAMAGE;

	Template.iRange = default.LWDRONE_DRONEREPAIRWEAPON_RANGE;
	Template.iSoundRange = default.LWDRONE_DRONEREPAIRWEAPON_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.LWDRONE_DRONEREPAIRWEAPON_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.LWDRONE_IDEALRANGE;

	Template.iClipSize = 99;
	Template.InfiniteAmmo = true;
	
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('LWDroneRepair');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWDroneWeapon.Archetypes.WP_DroneRepair";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	return Template;
}

static function X2DataTemplate CreateTemplate_ViperMX_WPN(name TemplateName)
{
    local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);
    Template.WeaponPanelImage = "_ConventionalRifle";
    Template.ItemCat = 'Weapon';
    Template.WeaponCat = 'rifle';
    Template.WeaponTech = 'beam';
    Template.strImage = "img:///UILibrary_Common.AlienWeapons.ViperRifle";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability
    Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	
	if (TemplateName == 'ViperM2_LW_WPN')
		Template.BaseDamage = default.VIPERM2_WPN_BASEDAMAGE;
	if (TemplateName == 'ViperM3_LW_WPN')
		Template.BaseDamage = default.VIPERM3_WPN_BASEDAMAGE;

	Template.iClipSize = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ICLIPSIZE;
    Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
    Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
    Template.iIdealRange = class'X2Item_DefaultWeapons'.default.VIPER_IDEALRANGE;
    Template.DamageTypeTemplateName = 'Heavy';
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
    Template.Abilities.AddItem('StandardShot');
    Template.Abilities.AddItem('overwatch');
    Template.Abilities.AddItem('OverwatchShot');
    Template.Abilities.AddItem('Reload');
    Template.Abilities.AddItem('HotLoadAmmo');
    Template.GameArchetype = "WP_Viper_Rifle.WP_ViperRifle";
    Template.iPhysicsImpulse = 5;
    Template.CanBeBuilt = false;
    Template.TradingPostValue = 30;
    return Template;
}

static function X2DataTemplate CreateTemplate_AdvElite_WPN(name TemplateName)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);

	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventAssaultRifle";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
    Template.iClipSize = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ICLIPSIZE; 

    Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	
	switch (TemplateName)
	{
		case 'AdvSergeantM1_WPN': Template.BaseDamage = default.AdvSergeantM1_WPN_BASEDAMAGE; break;
		case 'AdvSergeantM2_WPN': Template.BaseDamage = default.AdvSergeantM2_WPN_BASEDAMAGE;  break;
		case 'AdvShockTroop_WPN': Template.BaseDamage = default.AdvShockTroop_WPN_BASEDAMAGE;  break;
		case 'AdvCommando_WPN': Template.BaseDamage = default.AdvCommando_WPN_BASEDAMAGE; break;
		case 'AdvVanguard_WPN': Template.BaseDamage = default.AdvVanguard_WPN_BASEDAMAGE; 
		Template.Abilities.AddItem('CloseCombatSpecialist');
		Template.iClipSize = default.VANGUARD_ASSAULTRIFLE_ICLIPSIZE;
		break;
		case 'AdvScout_WPN': Template.BaseDamage = default.AdvScout_WPN_BASEDAMAGE; break;
		case 'AdvGeneralM1_WPN': Template.BaseDamage = default.AdvGeneralM1_WPN_BASEDAMAGE; break;
		case 'AdvGeneralM2_WPN': Template.BaseDamage = default.AdvGeneralM2_WPN_BASEDAMAGE; break;
		default: break;
	}

    Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
    Template.iIdealRange = default.ADVVANGUARD_IDEALRANGE; 

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	Template.GameArchetype = "WP_AssaultRifle_MG.WP_AssaultRifle_MG_Advent";
	Template.iPhysicsImpulse = 5;
	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;
	Template.DamageTypeTemplateName = 'Projectile_MagAdvent';

	return Template;
}
