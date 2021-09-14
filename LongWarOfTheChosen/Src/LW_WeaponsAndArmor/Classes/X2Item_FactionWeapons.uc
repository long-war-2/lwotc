// This is an Unreal Script
class X2Item_FactionWeapons extends X2Item config(GameData_WeaponData);

/******************************************************************
**
**  XPAC WEAPON STATS
**
******************************************************************/

var config array<int> SKIRMISHER_SMG_RANGE;
var config array<int> TEMPLAR_PISTOL_RANGE;

var config WeaponDamageValue BULLPUP_LASER_BASEDAMAGE;
var config int BULLPUP_LASER_AIM;
var config int BULLPUP_LASER_CRITCHANCE;
var config int BULLPUP_LASER_ICLIPSIZE;
var config int BULLPUP_LASER_ISOUNDRANGE;
var config int BULLPUP_LASER_IENVIRONMENTDAMAGE;
var config int BULLPUP_LASER_ISUPPLIES;
var config int BULLPUP_LASER_TRADINGPOSTVALUE;
var config int BULLPUP_LASER_IPOINTS;
var config string Bullpup_Laser_ImagePath;
var config array<int> SKIRMISHER_LASER_RANGE;


var config WeaponDamageValue BULLPUP_COIL_BASEDAMAGE;
var config int BULLPUP_COIL_AIM;
var config int BULLPUP_COIL_CRITCHANCE;
var config int BULLPUP_COIL_ICLIPSIZE;
var config int BULLPUP_COIL_ISOUNDRANGE;
var config int BULLPUP_COIL_IENVIRONMENTDAMAGE;
var config int BULLPUP_COIL_ISUPPLIES;
var config int BULLPUP_COIL_TRADINGPOSTVALUE;
var config int BULLPUP_COIL_IPOINTS;
var config array<int> SKIRMISHER_COIL_RANGE;
var config string Bullpup_Coil_ImagePath;

var config WeaponDamageValue VEKTOR_LASER_BASEDAMAGE;
var config int VEKTOR_LASER_AIM;
var config int VEKTOR_LASER_CRITCHANCE;
var config int VEKTOR_LASER_ICLIPSIZE;
var config int VEKTOR_LASER_ISOUNDRANGE;
var config int VEKTOR_LASER_IENVIRONMENTDAMAGE;
var config int VEKTOR_LASER_ISUPPLIES;
var config int VEKTOR_LASER_TRADINGPOSTVALUE;
var config int VEKTOR_LASER_IPOINTS;
var config string Vektor_Laser_ImagePath;
var config array<int> VEKTOR_LASER_RANGE;


var config WeaponDamageValue VEKTOR_COIL_BASEDAMAGE;
var config int VEKTOR_COIL_AIM;
var config int VEKTOR_COIL_CRITCHANCE;
var config int VEKTOR_COIL_ICLIPSIZE;
var config int VEKTOR_COIL_ISOUNDRANGE;
var config int VEKTOR_COIL_IENVIRONMENTDAMAGE;
var config int VEKTOR_COIL_ISUPPLIES;
var config int VEKTOR_COIL_TRADINGPOSTVALUE;
var config int VEKTOR_COIL_IPOINTS;
var config array<int> VEKTOR_COIL_RANGE;
var config string Vektor_Coil_ImagePath;


var config WeaponDamageValue SIDEARM_LASER_BASEDAMAGE;
var config int SIDEARM_LASER_AIM;
var config int SIDEARM_LASER_CRITCHANCE;
var config int SIDEARM_LASER_ICLIPSIZE;
var config int SIDEARM_LASER_ISOUNDRANGE;
var config int SIDEARM_LASER_IENVIRONMENTDAMAGE;

var config WeaponDamageValue SIDEARM_COIL_BASEDAMAGE;
var config int SIDEARM_COIL_AIM;
var config int SIDEARM_COIL_CRITCHANCE;
var config int SIDEARM_COIL_ICLIPSIZE;
var config int SIDEARM_COIL_ISOUNDRANGE;
var config int SIDEARM_COIL_IENVIRONMENTDAMAGE;


var config WeaponDamageValue WRISTBLADE_LASER_BASEDAMAGE;
var config int WRISTBLADE_LASER_AIM;
var config int WRISTBLADE_LASER_CRITCHANCE;
var config int WRISTBLADE_LASER_ISOUNDRANGE;
var config int WRISTBLADE_LASER_IENVIRONMENTDAMAGE;

var config WeaponDamageValue WRISTBLADE_COIL_BASEDAMAGE;
var config int WRISTBLADE_COIL_AIM;
var config int WRISTBLADE_COIL_CRITCHANCE;
var config int WRISTBLADE_COIL_ISOUNDRANGE;
var config int WRISTBLADE_COIL_IENVIRONMENTDAMAGE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;


	Weapons.AddItem(CreateTemplate_Bullpup_Laser());
	Weapons.AddItem(CreateBullpup_Coil_Template());
	Weapons.AddItem(CreateVektor_Laser());
	Weapons.AddItem(CreateVektor_Coil());

	Weapons.AddItem(CreateTemplate_Sidearm_Laser());
	Weapons.AddItem(CreateTemplate_Sidearm_Coil());

	Weapons.AddItem(CreateTemplate_Sidearm_Laser_Schematic());
	Weapons.AddItem(CreateTemplate_Sidearm_Coil_Schematic());


	Weapons.AddItem(CreateTemplate_WristBlade_Laser());
	Weapons.AddItem(CreateTemplate_WristBlade_Coil());

	return Weapons;
}

static function X2DataTemplate CreateTemplate_Bullpup_Laser()
{
	local X2WeaponTemplate Template;
	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Bullpup_LS');

	Template.WeaponCat = 'bullpup';
	Template.WeaponTech = 'laser_lw'; 
	Template.ItemCat = 'weapon';
	Template.strImage = "img:///" $ default.Bullpup_Laser_ImagePath; 
	Template.WeaponPanelImage = "_BeamShotgun";                       // used by the UI. Probably determines iconview of the weapon.
	Template.EquipSound = "Beam_Weapon_Equip";
	Template.Tier = 3;

	Template.RangeAccuracy = default.SKIRMISHER_SMG_RANGE;
	Template.BaseDamage = default.BULLPUP_LASER_BASEDAMAGE;
	Template.Aim = default.BULLPUP_LASER_AIM;
	Template.CritChance = default.BULLPUP_LASER_CRITCHANCE;
	Template.iClipSize = default.BULLPUP_LASER_ICLIPSIZE;
	Template.iSoundRange = default.BULLPUP_LASER_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.BULLPUP_LASER_IENVIRONMENTDAMAGE;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Bullpup_CV_StatBonus');
	Template.SetUIStatMarkup("Mobility", eStat_Mobility, class'X2Ability_FactionWeaponAbilities'.default.BULLPUP_CONVENTIONAL_MOBILITY_BONUS);

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWSMG_LS.Archetype.WP_SMG_LS";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';


	Template.CreatorTemplateName = 'Bullpup_LS_Schematic'; // The schematic which creates this item

	Template.iPhysicsImpulse = 5;
	Template.StartingItem = false;
	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Projectile_BeamXCom';  

	return Template;
}

static function X2DataTemplate CreateBullpup_Coil_Template()
{
	local X2WeaponTemplate Template;	
	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Bullpup_CG');

	Template.WeaponCat = 'bullpup';
	Template.WeaponTech = 'coilgun_lw';
	Template.ItemCat = 'weapon';
	Template.strImage ="img:///" $ default.BullPup_Coil_ImagePath;
	Template.WeaponPanelImage = "";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 4;

	Template.RangeAccuracy = default.SKIRMISHER_SMG_RANGE;
	Template.BaseDamage = default.BULLPUP_COIL_BASEDAMAGE;
	Template.Aim = default.BULLPUP_COIL_AIM;
	Template.CritChance = default.BULLPUP_COIL_CRITCHANCE;
	Template.iClipSize = default.BULLPUP_COIL_ICLIPSIZE;
	Template.iSoundRange = default.BULLPUP_COIL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.BULLPUP_COIL_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 3;

	Template.GameArchetype = "IRI_Bullpup_CG.Archetypes.WP_Bullpup_CG";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Shotgun';


	Template.CreatorTemplateName = 'Bullpup_CG_Schematic'; // The schematic which creates this item

	Template.iPhysicsImpulse = 5;
	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('CoilgunBonusShredAbility');
	Template.Requirements.RequiredTechs.AddItem('Coilguns');

	Template.Abilities.AddItem('Bullpup_CV_StatBonus');
	Template.SetUIStatMarkup("Mobility", eStat_Mobility, class'X2Ability_FactionWeaponAbilities'.default.BULLPUP_CONVENTIONAL_MOBILITY_BONUS);

	Template.iPhysicsImpulse = 5;
	Template.StartingItem = false;
	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	return Template;
}

static function X2DataTemplate CreateVektorCrossbow_CV()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'CrossbowVektor_CV');
	Template.WeaponPanelImage = "_ConventionalSniperRifle";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'vektor_rifle';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///CrossbowVektor.Inv_CrossbowVektor";
	Template.EquipSound = "Conventional_Weapon_Equip";
	Template.Tier = 0;

	Template.RangeAccuracy = class'X2Item_XpackWeapons'.default.VEKTOR_CONVENTIONAL_RANGE;
	Template.BaseDamage = class'X2Item_XpackWeapons'.default.VEKTORRIFLE_CONVENTIONAL_BASEDAMAGE;
	Template.Aim = class'X2Item_XpackWeapons'.default.VEKTORRIFLE_CONVENTIONAL_AIM;
	Template.CritChance = class'X2Item_XpackWeapons'.default.VEKTORRIFLE_CONVENTIONAL_CRITCHANCE;
	Template.iClipSize = class'X2Item_XpackWeapons'.default.VEKTORRIFLE_CONVENTIONAL_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_XpackWeapons'.default.VEKTORRIFLE_CONVENTIONAL_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_XpackWeapons'.default.VEKTORRIFLE_CONVENTIONAL_IENVIRONMENTDAMAGE;
	Template.NumUpgradeSlots = 3;
	Template.iTypicalActionCost = 2;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "CrossbowVektor.WP_CrossbowVektor_CV";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Sniper';

	Template.iPhysicsImpulse = 5;

	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.fKnockbackDamageAmount = 5.0f;
	Template.fKnockbackDamageRadius = 0.0f;

	Template.DamageTypeTemplateName = 'Projectile_Conventional';

	return Template;
}



static function X2DataTemplate CreateVektor_Laser()
{
	local X2WeaponTemplate Template;
	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'VektorRifle_LS');

	Template.WeaponCat = 'vektor_rifle';
	Template.WeaponTech = 'laser_lw'; 
	Template.ItemCat = 'weapon';
	Template.strImage = "img:///" $ default.Vektor_Laser_ImagePath; 
	Template.WeaponPanelImage = "_BeamSniperRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.EquipSound = "Beam_Weapon_Equip";
	Template.Tier = 3;

	Template.RangeAccuracy = default.VEKTOR_LASER_RANGE;
	Template.BaseDamage = default.VEKTOR_LASER_BASEDAMAGE;
	Template.Aim = default.VEKTOR_LASER_AIM;
	Template.CritChance = default.VEKTOR_LASER_CRITCHANCE;
	Template.iClipSize = default.VEKTOR_LASER_ICLIPSIZE;
	Template.iSoundRange = default.VEKTOR_LASER_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.VEKTOR_LASER_IENVIRONMENTDAMAGE;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LW_StrikeRifle.Archetypes.WP_DMR_LS";

	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Sniper';
	Template.CreatorTemplateName = 'VektorRifle_LS_Schematic'; // The schematic which creates this item

	Template.iPhysicsImpulse = 5;
	Template.StartingItem = false;
	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Projectile_BeamXCom';  

	return Template;
}

static function X2DataTemplate CreateVektor_Coil()
{
	local X2WeaponTemplate Template;
	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'VektorRifle_CG');

	Template.WeaponCat = 'vektor_rifle';
	Template.WeaponTech = 'coilgun_lw';
	Template.ItemCat = 'weapon';
	Template.strImage ="img:///" $ default.Vektor_Coil_ImagePath;
	Template.WeaponPanelImage = "_MagneticSniperRifle";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 4;

	Template.RangeAccuracy = default.VEKTOR_COIL_RANGE;
	Template.BaseDamage = default.VEKTOR_COIL_BASEDAMAGE;
	Template.Aim = default.VEKTOR_COIL_AIM;
	Template.CritChance = default.VEKTOR_COIL_CRITCHANCE;
	Template.iClipSize = default.VEKTOR_COIL_ICLIPSIZE;
	Template.iSoundRange = default.VEKTOR_COIL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.VEKTOR_COIL_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 3;

	Template.GameArchetype = "LW_StrikeRifle.Archetypes.WP_DMR_CG";

	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Sniper';

	Template.CreatorTemplateName = 'VEKTOR_CG_Schematic'; // The schematic which creates this item



	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('CoilgunBonusShredAbility');

	Template.iPhysicsImpulse = 5;
	Template.StartingItem = false;
	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	return Template;
}



static function X2DataTemplate CreateTemplate_Sidearm_Laser()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Sidearm_LS');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'sidearm';
	Template.WeaponTech = 'laser_lw';
//BEGIN AUTOGENERATED CODE: Template Overrides 'Sidearm_MG'
	Template.strImage = "img:///IRI_AutoPistol_LS.UI.Sidearm_LS_Inv";
//END AUTOGENERATED CODE: Template Overrides 'Sidearm_MG'
	Template.EquipSound = "Secondary_Weapon_Equip_Beam";
	Template.Tier = 3;

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_MAGNETIC_RANGE;
	Template.BaseDamage = default.SIDEARM_LASER_BASEDAMAGE;
	Template.Aim = default.SIDEARM_LASER_AIM;
	Template.CritChance = default.SIDEARM_LASER_CRITCHANCE;
	Template.iClipSize = default.SIDEARM_LASER_ICLIPSIZE;
	Template.iSoundRange = default.SIDEARM_LASER_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SIDEARM_LASER_IENVIRONMENTDAMAGE;

//	Template.UIArmoryCameraPointTag = "UIPawnLocation_WeaponUpgrade_Shotgun";
	Template.NumUpgradeSlots = 0;

	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	Template.InfiniteAmmo = true;

	Template.InventorySlot = eInvSlot_Pistol;
	Template.Abilities.AddItem('PistolStandardShot');
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotBeam');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "IRI_AutoPistol_CG.Archetypes.WP_AutoPistol_LS";

	Template.iPhysicsImpulse = 5;

	Template.CreatorTemplateName = 'Sidearm_LS_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'Sidearm_CV'; // Which item this will be upgraded from

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_BeamXCom';

	Template.bHideClipSizeStat = true;

	return Template;
}


static function X2DataTemplate CreateTemplate_Sidearm_Laser_Schematic()
{
	local X2SchematicTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'Sidearm_LS_Schematic');

	Template.ItemCat = 'weapon';
//BEGIN AUTOGENERATED CODE: Template Overrides 'Sidearm_MG_Schematic'
	Template.strImage = "img:///IRI_AutoPistol_LS.UI.laser-sidearm-schematic";
//END AUTOGENERATED CODE: Template Overrides 'Sidearm_MG_Schematic'
	Template.PointsToComplete = 0;
	Template.Tier = 1;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'Sidearm_LS';
	Template.HideIfPurchased = 'Sidearm_MG';

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('LaserWeapons');
	Template.Requirements.RequiredEngineeringScore = 5;
	//Template.Requirements.RequiredSoldierClass = 'Templar';
	//Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
    Resources.Quantity = 25;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
    Resources.Quantity = 2;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}


static function X2DataTemplate CreateTemplate_Sidearm_Coil()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Sidearm_CG');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'sidearm';
	Template.WeaponTech = 'coilgun_LW';
//BEGIN AUTOGENERATED CODE: Template Overrides 'Sidearm_MG'
	Template.strImage = "img:///IRI_AutoPistol_CG.UI.CoilAutopistol_base";
//END AUTOGENERATED CODE: Template Overrides 'Sidearm_MG'
	Template.EquipSound = "Secondary_Weapon_Equip_Beam";
	Template.Tier = 3;

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_MAGNETIC_RANGE;
	Template.BaseDamage = default.SIDEARM_COIL_BASEDAMAGE;
	Template.Aim = default.SIDEARM_COIL_AIM;
	Template.CritChance = default.SIDEARM_COIL_CRITCHANCE;
	Template.iClipSize = default.SIDEARM_COIL_ICLIPSIZE;
	Template.iSoundRange = default.SIDEARM_COIL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SIDEARM_COIL_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 0;
//	Template.UIArmoryCameraPointTag = "UIPawnLocation_WeaponUpgrade_Shotgun";

	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	Template.InfiniteAmmo = true;

	Template.InventorySlot = eInvSlot_Pistol;
	Template.Abilities.AddItem('PistolStandardShot');
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotMag');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "IRI_AutoPistol_CG.Archetypes.WP_AutoPistol_CG";

	Template.iPhysicsImpulse = 5;

	Template.CreatorTemplateName = 'Sidearm_CG_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'Sidearm_MG'; // Which item this will be upgraded from

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	Template.bHideClipSizeStat = true;

	return Template;
}


static function X2DataTemplate CreateTemplate_Sidearm_Coil_Schematic()
{
	local X2SchematicTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'Sidearm_CG_Schematic');

	Template.ItemCat = 'weapon';
//BEGIN AUTOGENERATED CODE: Template Overrides 'Sidearm_MG_Schematic'
	Template.strImage = "img:///IRI_AutoPistol_CG.UI.CoilAutopistol_schematic";
//END AUTOGENERATED CODE: Template Overrides 'Sidearm_MG_Schematic'
	Template.PointsToComplete = 0;
	Template.Tier = 1;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'Sidearm_CG';
	Template.HideIfPurchased = 'Sidearm_BM';

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('CoilGuns');
	Template.Requirements.RequiredEngineeringScore = 15;
	//Template.Requirements.RequiredSoldierClass = 'Templar';
	//Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
    Resources.Quantity = 25;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
    Resources.Quantity = 2;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}


static function X2DataTemplate CreateTemplate_WristBlade_Laser()
{
	local X2PairedWeaponTemplate Template;
	local WeaponAttachment Attach;

	`CREATE_X2TEMPLATE(class'X2PairedWeaponTemplate', Template, 'WristBlade_LS');
	Template.WeaponPanelImage = "_Sword";                       // used by the UI. Probably determines iconview of the weapon.
	Template.PairedSlot = eInvSlot_TertiaryWeapon;
	Template.PairedTemplateName = 'WristBladeLeft_LS';

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'wristblade';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_MagSGauntlet";
	Template.EquipSound = "Sword_Equip_Magnetic";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	//Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_SkirmisherGauntlet.WP_SkirmisherGauntlet_MG";
	Template.AltGameArchetype = "WP_SkirmisherGauntlet.WP_SkirmisherGauntlet_F_MG";
	Template.GenderForAltArchetype = eGender_Female;
	Template.Tier = 3;
	Template.bUseArmorAppearance = true;

	Attach.AttachSocket = 'R_Claw';
	Attach.AttachMeshName = "SkirmisherGauntlet.Meshes.SM_SkirmisherGauntletR_Claw_M_MG";
	Attach.RequiredGender = eGender_Male;
	Attach.AttachToPawn = true;
	Template.DefaultAttachments.AddItem(Attach);

	Attach.AttachSocket = 'R_Claw';
	Attach.AttachMeshName = "SkirmisherGauntlet.Meshes.SM_SkirmisherGauntletR_Claw_F_MG";
	Attach.RequiredGender = eGender_Female;
	Attach.AttachToPawn = true;
	Template.DefaultAttachments.AddItem(Attach);

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 0;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = default.WRISTBLADE_LASER_BASEDAMAGE;
	Template.Aim = default.WRISTBLADE_LASER_AIM;
	Template.CritChance = default.WRISTBLADE_LASER_CRITCHANCE;
	Template.iSoundRange = default.WRISTBLADE_LASER_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.WRISTBLADE_LASER_IENVIRONMENTDAMAGE;
	Template.BaseDamage.DamageType = 'Melee';

	Template.CreatorTemplateName = 'WristBlade_LS_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'WristBlade_CV'; // Which item this will be upgraded from

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Melee';


	return Template;
}

	static function X2DataTemplate CreateTemplate_WristBlade_Coil()
{
	local X2PairedWeaponTemplate Template;
	local WeaponAttachment Attach;

	`CREATE_X2TEMPLATE(class'X2PairedWeaponTemplate', Template, 'WristBlade_CG');
	Template.WeaponPanelImage = "_Sword";                       // used by the UI. Probably determines iconview of the weapon.
	Template.PairedSlot = eInvSlot_TertiaryWeapon;
	Template.PairedTemplateName = 'WristBladeLeft_LS';

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'wristblade';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_MagSGauntlet";
	Template.EquipSound = "Sword_Equip_Magnetic";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	//Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_SkirmisherGauntlet.WP_SkirmisherGauntlet_MG";
	Template.AltGameArchetype = "WP_SkirmisherGauntlet.WP_SkirmisherGauntlet_F_MG";
	Template.GenderForAltArchetype = eGender_Female;
	Template.Tier = 3;
	Template.bUseArmorAppearance = true;

	Attach.AttachSocket = 'R_Claw';
	Attach.AttachMeshName = "SkirmisherGauntlet.Meshes.SM_SkirmisherGauntletR_Claw_M_MG";
	Attach.RequiredGender = eGender_Male;
	Attach.AttachToPawn = true;
	Template.DefaultAttachments.AddItem(Attach);

	Attach.AttachSocket = 'R_Claw';
	Attach.AttachMeshName = "SkirmisherGauntlet.Meshes.SM_SkirmisherGauntletR_Claw_F_MG";
	Attach.RequiredGender = eGender_Female;
	Attach.AttachToPawn = true;
	Template.DefaultAttachments.AddItem(Attach);

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 0;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = default.WRISTBLADE_COIL_BASEDAMAGE;
	Template.Aim = default.WRISTBLADE_COIL_AIM;
	Template.CritChance = default.WRISTBLADE_COIL_CRITCHANCE;
	Template.iSoundRange = default.WRISTBLADE_COIL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.WRISTBLADE_COIL_IENVIRONMENTDAMAGE;
	Template.BaseDamage.DamageType = 'Melee';

	Template.CreatorTemplateName = 'WristBlade_CG_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'WristBlade_MG'; // Which item this will be upgraded from

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Melee';


	return Template;
}
