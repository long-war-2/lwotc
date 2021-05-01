//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_ShieldWall.uc
//  AUTHOR:  Grobobobo
//	CREDITS: Musashi
//  PURPOSE: an Item set for the ballistic shields.
//---------------------------------------------------------------------------------------
class X2Item_Shields_LW extends X2Item config(GameData_WeaponData);

var config WeaponDamageValue SHIELD_CV_BASEDAMAGE;
var config WeaponDamageValue SHIELD_MG_BASEDAMAGE;
var config WeaponDamageValue SHIELD_BM_BASEDAMAGE;

var config array<name> SHIELD_CV_ABILITIES;
var config array<name> SHIELD_MG_ABILITIES;
var config array<name> SHIELD_BM_ABILITIES;

var config int SHIELD_CV_AIM;
var config int SHIELD_CV_CRITCHANCE;
var config int SHIELD_CV_ISOUNDRANGE;
var config int SHIELD_CV_IENVIRONMENTDAMAGE;
var config int SHIELD_CV_NUM_UPGRADE_SLOTS;

var config int SHIELD_MG_AIM;
var config int SHIELD_MG_CRITCHANCE;
var config int SHIELD_MG_ISOUNDRANGE;
var config int SHIELD_MG_IENVIRONMENTDAMAGE;
var config int SHIELD_MG_NUM_UPGRADE_SLOTS;

var config int SHIELD_BM_AIM;
var config int SHIELD_BM_CRITCHANCE;
var config int SHIELD_BM_ISOUNDRANGE;
var config int SHIELD_BM_IENVIRONMENTDAMAGE;
var config int SHIELD_BM_NUM_UPGRADE_SLOTS;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;

	Weapons.AddItem(BallisticShield_CV());
	Weapons.AddItem(BallisticShield_MG());
	Weapons.AddItem(BallisticShield_BM());

	return Weapons;
}

static function X2WeaponTemplate BallisticShield_CV()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'TemplarBallisticShield_CV');
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'shield';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///WoTC_Shield_UI_LW.Inv_Ballistic_Shield";
	Template.EquipSound = "StrategyUI_Heavy_Weapon_Equip";

	Template.BaseDamage = default.SHIELD_CV_BASEDAMAGE;
	Template.Aim = 0;
	Template.CritChance = default.SHIELD_CV_CRITCHANCE;
	Template.iSoundRange = default.SHIELD_CV_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SHIELD_CV_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = default.SHIELD_CV_NUM_UPGRADE_SLOTS;
	Template.iClipSize = 0;
	Template.iRange = 0;
	Template.iRadius = 1;
	Template.GameArchetype = "WoTC_Ballistic_Shield_LW.Archetype.WP_Ballistic_Shield";
	Template.Tier = -1;
	
	Template.PointsToComplete = 20;
	Template.TradingPostValue = 0;
	
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_HeavyWeapon;
	Template.bMergeAmmo = true;
	Template.DamageTypeTemplateName = 'Melee';

	AddAbilities(Template, default.SHIELD_CV_ABILITIES);

	//Template.BonusWeaponEffects.AddItem(class'X2StatusEffects'.static.CreateDisorientedStatusEffect(true, , false));
	
	Template.SetUIStatMarkup(class'XLocalizedData'.default.AimLabel,, default.SHIELD_CV_AIM,,, "%");
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_ShieldAbilitySet'.default.SHIELD_MOBILITY_PENALTY);

	Template.CanBeBuilt = false;
	Template.StartingItem = true;
	Template.bInfiniteItem = true;

	return Template;
}

static function X2DataTemplate BallisticShield_MG()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'TemplarBallisticShield_MG');
	Template.WeaponPanelImage = "_Sword";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'shield';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///WoTC_Shield_UI_LW.Inv_Plated_Shield";
	Template.EquipSound = "StrategyUI_Heavy_Weapon_Equip";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_HeavyWeapon;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WoTC_Plated_Shield_LW.Archetype.WP_Plated_Shield";
	Template.Tier = -2;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = default.SHIELD_MG_NUM_UPGRADE_SLOTS;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = default.SHIELD_MG_BASEDAMAGE;
	Template.Aim = 0;
	Template.CritChance = default.SHIELD_MG_CRITCHANCE;
	Template.iSoundRange = default.SHIELD_MG_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SHIELD_MG_IENVIRONMENTDAMAGE;
	Template.BaseDamage.DamageType='Melee';

	AddAbilities(Template, default.SHIELD_MG_ABILITIES);

	//Template.BonusWeaponEffects.AddItem(class'X2StatusEffects'.static.CreateDisorientedStatusEffect(true, , false));

	//Template.CreatorTemplateName = 'MediumPlatedArmor_Schematic'; // The schematic which creates this item
	//Template.BaseItem = 'BallisticShield_CV'; // Which item this will be upgraded from
	
	Template.SetUIStatMarkup(class'XLocalizedData'.default.AimLabel,, default.SHIELD_MG_AIM,,, "%");
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_ShieldAbilitySet'.default.SHIELD_MOBILITY_PENALTY);

	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;

	Template.DamageTypeTemplateName = 'Melee';
	
	return Template;
}

static function X2DataTemplate BallisticShield_BM()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'TemplarBallisticShield_BM');
	Template.WeaponPanelImage = "_Sword";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'shield';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///WoTC_Shield_UI_LW.Inv_Powered_Shield";
	Template.EquipSound = "StrategyUI_Heavy_Weapon_Equip";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_HeavyWeapon;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WoTC_Powered_Shield_LW.Archetype.WP_Powered_Shield";
	Template.Tier = -3;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = default.SHIELD_BM_NUM_UPGRADE_SLOTS;;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = default.SHIELD_BM_BASEDAMAGE;
	Template.Aim = 0;
	Template.CritChance = default.SHIELD_BM_CRITCHANCE;
	Template.iSoundRange = default.SHIELD_BM_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SHIELD_BM_IENVIRONMENTDAMAGE;
	Template.BaseDamage.DamageType='Melee';

	AddAbilities(Template, default.SHIELD_BM_ABILITIES);

	//Template.BonusWeaponEffects.AddItem(class'X2StatusEffects'.static.CreateDisorientedStatusEffect(true, , false));
	
	Template.SetUIStatMarkup(class'XLocalizedData'.default.AimLabel,, default.SHIELD_BM_AIM,,, "%");
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_ShieldAbilitySet'.default.SHIELD_MOBILITY_PENALTY);

	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;
	
	Template.DamageTypeTemplateName = 'Melee';
	
	return Template;
}

static function AddAbilities(out X2WeaponTemplate Template, array<name> Abilities)
{
	local name Ability;
	foreach Abilities(Ability)
	{
		if (Template.Abilities.Find(Ability) == INDEX_NONE)
		{
			Template.Abilities.AddItem(Ability);
		}
	}
}