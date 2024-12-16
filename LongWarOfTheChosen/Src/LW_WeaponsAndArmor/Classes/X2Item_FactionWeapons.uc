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

var config WeaponDamageValue CASTERGAUNTLET_CONVENTIONAL_BASEDAMAGE;
var config array<WeaponDamageValue> CASTERGAUNTLET_CONVENTIONAL_EXTRADAMAGE;
var config WeaponDamageValue CASTERGAUNTLET_MAGNETIC_BASEDAMAGE;
var config array<WeaponDamageValue> CASTERGAUNTLET_MAGNETIC_EXTRADAMAGE;
var config WeaponDamageValue CASTERGAUNTLET_BEAM_BASEDAMAGE;
var config array<WeaponDamageValue> CASTERGAUNTLET_BEAM_EXTRADAMAGE;

var config int CASTERGAUNTLET_CONVENTIONAL_AIM;
var config int CASTERGAUNTLET_CONVENTIONAL_CRITCHANCE;
var config int CASTERGAUNTLET_CONVENTIONAL_ISOUNDRANGE;
var config int CASTERGAUNTLET_CONVENTIONAL_IENVIRONMENTDAMAGE;

var config int CASTERGAUNTLET_MAGNETIC_AIM;
var config int CASTERGAUNTLET_MAGNETIC_CRITCHANCE;
var config int CASTERGAUNTLET_MAGNETIC_ISOUNDRANGE;
var config int CASTERGAUNTLET_MAGNETIC_IENVIRONMENTDAMAGE;

var config int CASTERGAUNTLET_BEAM_AIM;
var config int CASTERGAUNTLET_BEAM_CRITCHANCE;
var config int CASTERGAUNTLET_BEAM_ISOUNDRANGE;
var config int CASTERGAUNTLET_BEAM_IENVIRONMENTDAMAGE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;

	/*
	Weapons.AddItem(CreateTemplate_CasterGauntlet_Conventional());
	Weapons.AddItem(CreateTemplate_CasterGauntlet_Magnetic());
	Weapons.AddItem(CreateTemplate_CasterGauntlet_Beam());	
	Weapons.AddItem(CreateTemplate_CasterGauntletLeft_Conventional());
	Weapons.AddItem(CreateTemplate_CasterGauntletLeft_Magnetic());
	Weapons.AddItem(CreateTemplate_CasterGauntletLeft_Beam());
*/
	Weapons.AddItem(CreateTemplate_Bullpup_Laser());
	Weapons.AddItem(CreateBullpup_Coil_Template());
	Weapons.AddItem(CreateVektor_Laser());
	Weapons.AddItem(CreateVektor_Coil());

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
	Template.WeaponPanelImage = "_BeamRifle";                       // used by the UI. Probably determines iconview of the weapon.
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
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_FactionWeaponAbilities'.default.BULLPUP_CONVENTIONAL_MOBILITY_BONUS);

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "IRI_Bullpup_LS_LW.Archetypes.WP_Bullpup_LS";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';
	Template.AddDefaultAttachment('Mag', "IRI_Bullpup_LS_LW.Meshes.SM_Bullpup_LS_MagA", , "img:///IRI_Bullpup_LS_LW.UI.Laser-bullop-magazinepA");
	Template.AddDefaultAttachment('Stock', "IRI_Bullpup_LS_LW.Meshes.SM_Bullpup_LS_StockA", , "img:///IRI_Bullpup_LS_LW.UI.Laser-bullop-stockA"); // switching to use the shotgun-style stock to differentiate better from rifle
	Template.AddDefaultAttachment('Reargrip', "IRI_Bullpup_LS_LW.Meshes.SM_Bullpup_LS_ReargripA", , "img:///IRI_Bullpup_LS_LW.UI.Laser-bullop-triggerA");
	Template.AddDefaultAttachment('Foregrip', "IRI_Bullpup_LS_LW.Meshes.SM_Bullpup_LS_ForegripA", , "img:///IRI_Bullpup_LS_LW.UI.Laser-bullop-foregripA");
	//Template.AddDefaultAttachment('Optic', "LWSMG_LS.Meshes.SK_LaserSMG_Optic_A", , "img:///UILibrary_LW_LaserPack.LaserSMG__OpticA");  // no default optic
	Template.AddDefaultAttachment('Light', "LWAttachments_LS.Meshes.SK_Laser_Flashlight", , );


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

	Template.GameArchetype = "IRI_Bullpup_CG_LW.Archetypes.WP_Bullpup_CG";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';
	Template.AddDefaultAttachment('Mag', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_MagA");
	Template.AddDefaultAttachment('Optic', "IRI_Bullpup_CG_LW.Meshes.SM_Bullpup_CG_OpticA", , "img:///IRI_Bullpup_CG_LW.UI.coil_bullop_opticA");
	Template.AddDefaultAttachment('Reargrip', "LWAccessories_CG.Meshes.LW_Coil_ReargripA");
	Template.AddDefaultAttachment('Rail', "IRI_Bullpup_CG_LW.Meshes.SM_Bullpup_CG_Rail");
	Template.AddDefaultAttachment('Light', "ConvAttachments.Meshes.SM_ConvFlashLight"); //, , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_LightA");  // re-use common conventional flashlight


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
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_FactionWeaponAbilities'.default.BULLPUP_CONVENTIONAL_MOBILITY_BONUS);

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
	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Vektor_LS');

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
	Template.GameArchetype = "IRI_VektorRifle_LS_LW.Archetypes.WP_ReaperRifle_LS";
	Template.AddDefaultAttachment('Mag', "IRI_VektorRifle_LS_LW.Meshes.SM_VektorRifle_LS_MagA", ,"img:///IRI_VektorRifle_LS_LW.UI.Laser-magazineA");//, , "img:///UILibrary_LW_LaserPack.LaserRifle_MagA");
	Template.AddDefaultAttachment('Stock', "CnvReaperRifle.Meshes.SM_HOR_Cnv_ReaperRifle_StockA" ,, "img:///IRI_VektorRifle_LS_LW.UI.Laser-stockA");//, , "img:///UILibrary_LW_LaserPack.LaserRifle_StockA");
	Template.AddDefaultAttachment('Reargrip', "CnvReaperRifle.Meshes.SM_HOR_Cnv_ReaperRifle_ReargripA");//, , "img:///UILibrary_LW_LaserPack.LaserRifle_TriggerA");
	Template.AddDefaultAttachment('Foreguard', "IRI_VektorRifle_LS_LW.Meshes.SM_VektorRifle_LS_Foreguard");//, , "img:///UILibrary_LW_LaserPack.LaserRifle_ForegripA");
	Template.AddDefaultAttachment('Optic', "IRI_VektorRifle_LS_LW.Meshes.SM_VektorRifle_LS_ScopeA", , "img:///IRI_VektorRifle_LS_LW.UI.Laser-scopeA");//, , "img:///UILibrary_BRPack.Attach.BR_LS_OpticA");
	Template.AddDefaultAttachment('Light', "LWAttachments_LS.Meshes.SK_Laser_Flashlight");
	Template.AddDefaultAttachment('Trigger', "CnvReaperRifle.Meshes.SM_HOR_Cnv_ReaperRifle_TriggerA" ,, "img:///IRI_VektorRifle_LS_LW.UI.Laser-triggerA");

	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Sniper';
	Template.CreatorTemplateName = 'VEKTOR_LS_Schematic'; // The schematic which creates this item

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
	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Vektor_CG');

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

	Template.GameArchetype = "IRI_VektorRifle_CG_LW.Archetypes.WP_ReaperRifle_CG";
	Template.AddDefaultAttachment('Mag', "IRI_VektorRifle_CG_LW.Meshes.SM_Vektor_CG_MagA");//, , "img:///UILibrary_LWOTC.InventoryArt.CoilRifle_MagA");
	Template.AddDefaultAttachment('Stock', "BemReaperRifle.Meshes.SM_HOR_Bem_ReaperRifle_StockA");//, , "img:///UILibrary_LWOTC.InventoryArt.CoilRifle_StockA");
	Template.AddDefaultAttachment('Suppressor', "IRI_VektorRifle_CG_LW.Meshes.SM_Vektor_CG_SuppressorA");//, , "img:///UILibrary_LWOTC.InventoryArt.CoilRifle_ReargripA");
	Template.AddDefaultAttachment('Light', "ConvAttachments.Meshes.SM_ConvFlashLight"); //);//, , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_LightA");  // re-use common conventional flashlight
	Template.AddDefaultAttachment('Optic', "IRI_VektorRifle_CG_LW.Meshes.SM_Vektor_CG_OpticA");//, , "img:///UILibrary_LWOTC.InventoryArt.CoilSniperRifle_OpticA");
	Template.AddDefaultAttachment('Trigger', "CnvReaperRifle.Meshes.SM_HOR_Cnv_ReaperRifle_TriggerA");


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

static function X2DataTemplate CreateTemplate_CasterGauntlet_Conventional()
{
	local X2PairedWeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2PairedWeaponTemplate', Template, 'CasterGauntlet_CV');
	Template.WeaponPanelImage = "_Sword";                       // used by the UI. Probably determines iconview of the weapon.
	Template.PairedSlot = eInvSlot_TertiaryWeapon;
	Template.PairedTemplateName = 'CasterGauntletLeft_CV';

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'gauntlet';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_ConvTGauntlet";
	Template.EquipSound = "Sword_Equip_Conventional";
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	//Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_TemplarGauntlet.WP_TemplarGauntlet";
	Template.AltGameArchetype = "WP_TemplarGauntlet.WP_TemplarGauntlet_F";
	Template.GenderForAltArchetype = eGender_Female;
	Template.Tier = 0;
	Template.bUseArmorAppearance = true;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 0;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.Abilities.AddItem('MeditationPreparation');
	Template.Abilities.AddItem('Channel');

	Template.iRange = 0;
	Template.BaseDamage = default.CASTERGAUNTLET_CONVENTIONAL_BASEDAMAGE;
	Template.ExtraDamage = default.CASTERGAUNTLET_CONVENTIONAL_EXTRADAMAGE;
	Template.Aim = default.CASTERGAUNTLET_CONVENTIONAL_AIM;
	Template.CritChance = default.CASTERGAUNTLET_CONVENTIONAL_CRITCHANCE;
	Template.iSoundRange = default.CASTERGAUNTLET_CONVENTIONAL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.CASTERGAUNTLET_CONVENTIONAL_IENVIRONMENTDAMAGE;
	Template.BaseDamage.DamageType = 'Psi';

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Psi';

	return Template;
}

static function X2DataTemplate CreateTemplate_CasterGauntlet_Magnetic()
{
	local X2PairedWeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2PairedWeaponTemplate', Template, 'CasterGauntlet_MG');
	Template.WeaponPanelImage = "_Sword";                       // used by the UI. Probably determines iconview of the weapon.
	Template.PairedSlot = eInvSlot_TertiaryWeapon;
	Template.PairedTemplateName = 'CasterGauntletLeft_MG';

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'gauntlet';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_MagTGauntlet";
	Template.EquipSound = "Sword_Equip_Magnetic";
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	//Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_TemplarGauntlet.WP_TemplarGauntlet_MG";
	Template.AltGameArchetype = "WP_TemplarGauntlet.WP_TemplarGauntlet_F_MG";
	Template.GenderForAltArchetype = eGender_Female;
	Template.Tier = 3;
	Template.bUseArmorAppearance = true;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 0;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.Abilities.AddItem('DeepFocus');
	Template.Abilities.AddItem('MeditationPreparation');
	Template.Abilities.AddItem('Channel');

	Template.iRange = 0;
	Template.BaseDamage = default.CASTERGAUNTLET_MAGNETIC_BASEDAMAGE;
	Template.ExtraDamage = default.CASTERGAUNTLET_MAGNETIC_EXTRADAMAGE;
	Template.Aim = default.CASTERGAUNTLET_MAGNETIC_AIM;
	Template.CritChance = default.CASTERGAUNTLET_MAGNETIC_CRITCHANCE;
	Template.iSoundRange = default.CASTERGAUNTLET_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.CASTERGAUNTLET_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.BaseDamage.DamageType = 'Psi';

	//Template.CreatorTemplateName = 'CASTERGAUNTLET_MG_Schematic'; // The schematic which creates this item
	//Template.BaseItem = 'CASTERGAUNTLET_CV'; // Which item this will be upgraded from

	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Psi';

	return Template;
}

static function X2DataTemplate CreateTemplate_CasterGauntlet_Beam()
{
	local X2PairedWeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2PairedWeaponTemplate', Template, 'CasterGauntlet_BM');
	Template.WeaponPanelImage = "_Sword";                       // used by the UI. Probably determines iconview of the weapon.
	Template.PairedSlot = eInvSlot_TertiaryWeapon;
	Template.PairedTemplateName = 'CasterGauntletLeft_BM';

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'gauntlet';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_BeamTGauntlet";
	Template.EquipSound = "Sword_Equip_Beam";
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	//Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_TemplarGauntlet.WP_TemplarGauntlet_BM";
	Template.AltGameArchetype = "WP_TemplarGauntlet.WP_TemplarGauntlet_F_BM";
	Template.GenderForAltArchetype = eGender_Female;
	Template.Tier = 5;
	Template.bUseArmorAppearance = true;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 0;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.Abilities.AddItem('DeepFocus');
	Template.Abilities.AddItem('SupremeFocus');
	Template.Abilities.AddItem('MeditationPreparation');
	Template.Abilities.AddItem('Channel');

	Template.iRange = 0;
	Template.BaseDamage = default.CASTERGAUNTLET_BEAM_BASEDAMAGE;
	Template.ExtraDamage = default.CASTERGAUNTLET_BEAM_EXTRADAMAGE;
	Template.Aim = default.CASTERGAUNTLET_BEAM_AIM;
	Template.CritChance = default.CASTERGAUNTLET_BEAM_CRITCHANCE;
	Template.iSoundRange = default.CASTERGAUNTLET_BEAM_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.CASTERGAUNTLET_BEAM_IENVIRONMENTDAMAGE;
	Template.BaseDamage.DamageType = 'Psi';

	//Template.CreatorTemplateName = 'CASTERGAUNTLET_BM_Schematic'; // The schematic which creates this item
	//Template.BaseItem = 'CASTERGAUNTLET_MG'; // Which item this will be upgraded from

	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Psi';

	return Template;
}

static function X2DataTemplate CreateTemplate_CasterGauntletLeft_Conventional()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'CasterGauntletLeft_CV');
	Template.WeaponPanelImage = "_Sword";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'gauntlet';
	Template.WeaponTech = 'conventional';
//BEGIN AUTOGENERATED CODE: Template Overrides 'ShardGauntletLeft_CV'
	Template.strImage = "img:///UILibrary_Common.ConvSecondaryWeapons.Sword";
//END AUTOGENERATED CODE: Template Overrides 'ShardGauntletLeft_CV'
	Template.EquipSound = "Sword_Equip_Conventional";
	Template.InventorySlot = eInvSlot_TertiaryWeapon;
	//Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_TemplarGauntlet.WP_TemplarGauntletL";
	Template.AltGameArchetype = "WP_TemplarGauntlet.WP_TemplarGauntletL_F";
	Template.GenderForAltArchetype = eGender_Female;
	Template.Tier = 0;
	Template.bUseArmorAppearance = true;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 0;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = default.CASTERGAUNTLET_CONVENTIONAL_BASEDAMAGE;
	Template.ExtraDamage = default.CASTERGAUNTLET_CONVENTIONAL_EXTRADAMAGE;
	Template.Aim = default.CASTERGAUNTLET_CONVENTIONAL_AIM;
	Template.CritChance = default.CASTERGAUNTLET_CONVENTIONAL_CRITCHANCE;
	Template.iSoundRange = default.CASTERGAUNTLET_CONVENTIONAL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.CASTERGAUNTLET_CONVENTIONAL_IENVIRONMENTDAMAGE;
	Template.BaseDamage.DamageType = 'Melee';

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Melee';

	return Template;
}

static function X2DataTemplate CreateTemplate_CasterGauntletLeft_Magnetic()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'CasterGauntletLeft_MG');
	Template.WeaponPanelImage = "_Sword";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'gauntlet';
	Template.WeaponTech = 'magnetic';
//BEGIN AUTOGENERATED CODE: Template Overrides 'ShardGauntletLeft_MG'
	Template.strImage = "img:///UILibrary_Common.MagSecondaryWeapons.MagSword";
//END AUTOGENERATED CODE: Template Overrides 'ShardGauntletLeft_MG'
	Template.EquipSound = "Sword_Equip_Magnetic";
	Template.InventorySlot = eInvSlot_TertiaryWeapon;
	//Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_TemplarGauntlet.WP_TemplarGauntletL_MG";
	Template.AltGameArchetype = "WP_TemplarGauntlet.WP_TemplarGauntletL_F_MG";
	Template.GenderForAltArchetype = eGender_Female;
	Template.Tier = 3;
	Template.bUseArmorAppearance = true;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 0;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = default.CASTERGAUNTLET_MAGNETIC_BASEDAMAGE;
	Template.ExtraDamage = default.CASTERGAUNTLET_MAGNETIC_EXTRADAMAGE;
	Template.Aim = default.CASTERGAUNTLET_MAGNETIC_AIM;
	Template.CritChance = default.CASTERGAUNTLET_MAGNETIC_CRITCHANCE;
	Template.iSoundRange = default.CASTERGAUNTLET_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.CASTERGAUNTLET_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.BaseDamage.DamageType = 'Melee';

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Melee';

	return Template;
}

static function X2DataTemplate CreateTemplate_CasterGauntletLeft_Beam()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'CasterGauntletLeft_BM');
	Template.WeaponPanelImage = "_Sword";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'gauntlet';
	Template.WeaponTech = 'beam';
//BEGIN AUTOGENERATED CODE: Template Overrides 'ShardGauntletLeft_BM'
	Template.strImage = "img:///UILibrary_Common.BeamSecondaryWeapons.BeamSword";
//END AUTOGENERATED CODE: Template Overrides 'ShardGauntletLeft_BM'
	Template.EquipSound = "Sword_Equip_Beam";
	Template.InventorySlot = eInvSlot_TertiaryWeapon;
	//Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_TemplarGauntlet.WP_TemplarGauntletL_BM";
	Template.AltGameArchetype = "WP_TemplarGauntlet.WP_TemplarGauntletL_F_BM";
	Template.GenderForAltArchetype = eGender_Female;
	Template.Tier = 5;
	Template.bUseArmorAppearance = true;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 0;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = default.CASTERGAUNTLET_BEAM_BASEDAMAGE;
	Template.ExtraDamage = default.CASTERGAUNTLET_BEAM_EXTRADAMAGE;
	Template.Aim = default.CASTERGAUNTLET_BEAM_AIM;
	Template.CritChance = default.CASTERGAUNTLET_BEAM_CRITCHANCE;
	Template.iSoundRange = default.CASTERGAUNTLET_BEAM_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.CASTERGAUNTLET_BEAM_IENVIRONMENTDAMAGE;
	Template.BaseDamage.DamageType = 'Melee';

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Melee';

	return Template;
}
