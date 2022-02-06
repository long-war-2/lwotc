class X2Item_ChosenWeapons extends X2Item_XpackWeapons config (GameData_WeaponData);


var config WeaponDamageValue CHOSENRIFLE_T5_BASEDAMAGE;

var config int CHOSENRIFLE_T5_AIM;
var config int CHOSENRIFLE_T5_CRITCHANCE;
var config int CHOSENRIFLE_T5_ICLIPSIZE;
var config int CHOSENRIFLE_T5_ISOUNDRANGE;
var config int CHOSENRIFLE_T5_IENVIRONMENTDAMAGE;

var config WeaponDamageValue CHOSENSWORD_T5_BASEDAMAGE;
var config array <WeaponDamageValue> CHOSENSWORD_T5_EXTRADAMAGE;

var config int CHOSENSWORD_T5_AIM;
var config int CHOSENSWORD_T5_CRITCHANCE;
var config int CHOSENSWORD_T5_ISOUNDRANGE;
var config int CHOSENSWORD_T5_IENVIRONMENTDAMAGE;

var config WeaponDamageValue CHOSENSHOTGUN_T5_BASEDAMAGE;

var config int CHOSENSHOTGUN_T5_AIM;
var config int CHOSENSHOTGUN_T5_CRITCHANCE;
var config int CHOSENSHOTGUN_T5_ICLIPSIZE;
var config int CHOSENSHOTGUN_T5_ISOUNDRANGE;
var config int CHOSENSHOTGUN_T5_IENVIRONMENTDAMAGE;

var config WeaponDamageValue CHOSENSNIPERRIFLE_T5_BASEDAMAGE;

var config int CHOSENSNIPERRIFLE_T5_AIM;
var config int CHOSENSNIPERRIFLE_T5_CRITCHANCE;
var config int CHOSENSNIPERRIFLE_T5_ICLIPSIZE;
var config int CHOSENSNIPERRIFLE_T5_ISOUNDRANGE;
var config int CHOSENSNIPERRIFLE_T5_IENVIRONMENTDAMAGE;

var config WeaponDamageValue CHOSENSNIPERPISTOL_T5_BASEDAMAGE;

var config int CHOSENSNIPERPISTOL_T5_AIM;
var config int CHOSENSNIPERPISTOL_T5_CRITCHANCE;
var config int CHOSENSNIPERPISTOL_T5_ICLIPSIZE;
var config int CHOSENSNIPERPISTOL_T5_ISOUNDRANGE;
var config int CHOSENSNIPERPISTOL_T5_IENVIRONMENTDAMAGE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;


    Weapons.AddItem(CreateTemplate_ChosenRifle_T5());
    Weapons.AddItem(CreateTemplate_WarlockM5_PsiWeapon());

    Weapons.AddItem(CreateTemplate_ChosenShotgun_T5());
	Weapons.AddItem(CreateTemplate_ChosenSword_T5());

	Weapons.AddItem(CreateTemplate_ChosenSniperRifle_T5());
	Weapons.AddItem(CreateTemplate_ChosenSniperPistol_T5());


    return Weapons;


}
static function X2DataTemplate CreateTemplate_ChosenRifle_T5()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'ChosenRifle_T5');
	Template.WeaponPanelImage = "_BeamRifle";                       // used by the UI. Probably determines iconview of the weapon.

	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'beam';
	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_Common.UI_BeamAssaultRifle.BeamAssaultRifle_Base";
	Template.EquipSound = "Beam_Weapon_Equip";
	Template.Tier = 5;

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.MEDIUM_BEAM_RANGE;
	Template.BaseDamage = default.CHOSENRIFLE_T5_BASEDAMAGE;
	Template.Aim = default.CHOSENRIFLE_T5_AIM;
	Template.CritChance = default.CHOSENRIFLE_T5_CRITCHANCE;
	Template.iClipSize = default.CHOSENRIFLE_T5_ICLIPSIZE;
	Template.iSoundRange = default.CHOSENRIFLE_T5_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.CHOSENRIFLE_T5_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 2;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	Template.GameArchetype = "WP_ChosenAssaultRifle.WP_ChosenAssaultRifle_T4";

	Template.iPhysicsImpulse = 5;
	Template.DamageTypeTemplateName = 'Projectile_MagAdvent';

	return Template;
}

static function X2DataTemplate CreateTemplate_WarlockM5_PsiWeapon()
{
	local X2WeaponTemplate Template;

	Template = X2WeaponTemplate(CreateTemplate_Warlock_PsiWeapon('WarlockM5_PsiWeapon'));

	return Template;
}

static function X2DataTemplate CreateTemplate_ChosenShotgun_T5()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'ChosenShotgun_T5');
	Template.WeaponPanelImage = "_BeamShotgun";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'shotgun';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///UILibrary_Common.UI_BeamShotgun.BeamShotgun_Base";
	Template.EquipSound = "Beam_Weapon_Equip";
	Template.Tier = 5;

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_BEAM_RANGE;
	Template.BaseDamage = default.CHOSENSHOTGUN_T5_BASEDAMAGE;
	Template.Aim = default.CHOSENSHOTGUN_T5_AIM;
	Template.CritChance = default.CHOSENSHOTGUN_T5_CRITCHANCE;
	Template.iClipSize = default.CHOSENSHOTGUN_T5_ICLIPSIZE;
	Template.iSoundRange = default.CHOSENSHOTGUN_T5_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.CHOSENSHOTGUN_T5_IENVIRONMENTDAMAGE;
	Template.NumUpgradeSlots = 0;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_ChosenShotgun.WP_ChosenShotgun_T4";

	Template.iPhysicsImpulse = 5;
	Template.fKnockbackDamageAmount = 10.0f;
	Template.fKnockbackDamageRadius = 16.0f;
	Template.DamageTypeTemplateName = 'Projectile_MagAdvent';

	return Template;
}

static function X2DataTemplate CreateTemplate_ChosenSword_T5()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'ChosenSword_T5');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'sword';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///UILibrary_Common.BeamSecondaryWeapons.BeamSword";
	Template.EquipSound = "Sword_Equip_Beam";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_ChosenSword.WP_ChosenSword_BM";
	Template.AddDefaultAttachment('R_Back', "BeamSword.Meshes.SM_BeamSword_Sheath", false);
	Template.Tier = 5;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 2;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = default.CHOSENSWORD_T5_BASEDAMAGE;
	Template.ExtraDamage = default.CHOSENSWORD_T5_EXTRADAMAGE;
	Template.Aim = default.CHOSENSWORD_T5_AIM;
	Template.CritChance = default.CHOSENSWORD_T5_CRITCHANCE;
	Template.iSoundRange = default.CHOSENSWORD_T5_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.CHOSENSWORD_T5_IENVIRONMENTDAMAGE;
	Template.BaseDamage.DamageType = 'Melee';
	
	Template.Abilities.AddItem('PartingSilk');

	Template.DamageTypeTemplateName = 'Melee';

	return Template;
}


	static function X2DataTemplate CreateTemplate_ChosenSniperRifle_T5()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'ChosenSniperRifle_T5');
	Template.WeaponPanelImage = "_BeamSniperRifle";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'sniper_rifle';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_Base";
	Template.EquipSound = "Beam_Weapon_Equip";
	Template.Tier = 5;

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.LONG_BEAM_RANGE;
	Template.BaseDamage = default.CHOSENSNIPERRIFLE_T5_BASEDAMAGE;
	Template.Aim = default.CHOSENSNIPERRIFLE_T5_AIM;
	Template.CritChance = default.CHOSENSNIPERRIFLE_T5_CRITCHANCE;
	Template.iClipSize = default.CHOSENSNIPERRIFLE_T5_ICLIPSIZE;
	Template.iSoundRange = default.CHOSENSNIPERRIFLE_T5_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.CHOSENSNIPERRIFLE_T5_IENVIRONMENTDAMAGE;
	Template.NumUpgradeSlots = 0;
	Template.iTypicalActionCost = 2;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('HunterRifleShot');
	Template.Abilities.AddItem('SniperRifleOverwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('TrackingShot');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_ChosenSniperRifle.WP_ChosenSniperRifle_T4";

	Template.iPhysicsImpulse = 5;
	Template.DamageTypeTemplateName = 'Projectile_MagAdvent';

	return Template;
}


	static function X2DataTemplate CreateTemplate_ChosenSniperPistol_T5()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'ChosenSniperPistol_T5');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///UILibrary_Common.BeamSecondaryWeapons.BeamPistol";
	Template.EquipSound = "Secondary_Weapon_Equip_Beam";
	Template.Tier = 3;

	Template.iRange = default.CHOSENSNIPERPISTOL_RANGE;
	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_MAGNETIC_RANGE;
	Template.BaseDamage = default.CHOSENSNIPERPISTOL_T5_BASEDAMAGE;
	Template.Aim = default.CHOSENSNIPERPISTOL_T5_AIM;
	Template.CritChance = default.CHOSENSNIPERPISTOL_T5_CRITCHANCE;
	Template.iClipSize = default.CHOSENSNIPERPISTOL_T5_ICLIPSIZE;
	Template.iSoundRange = default.CHOSENSNIPERPISTOL_T5_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.CHOSENSNIPERPISTOL_T5_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 0;

	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	Template.InfiniteAmmo = true;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('PistolStandardShot');
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotMagA');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_ChosenPistol.WP_ChosenPistol_T4";

	Template.iPhysicsImpulse = 5;
	Template.DamageTypeTemplateName = 'Projectile_MagAdvent';

	Template.bHideClipSizeStat = true;

	return Template;
}
