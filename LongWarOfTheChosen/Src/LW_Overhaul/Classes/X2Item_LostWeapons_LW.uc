class X2Item_LostWeapons_LW extends X2Item config(GameData_WeaponData);

var config WeaponDamageValue THELOST_TIER4_MELEEATTACK_BASEDAMAGE;

var config WeaponDamageValue THELOST_DASHER_TIER1_MELEEATTACK_BASEDAMAGE;
var config WeaponDamageValue THELOST_DASHER_TIER2_MELEEATTACK_BASEDAMAGE;
var config WeaponDamageValue THELOST_DASHER_TIER3_MELEEATTACK_BASEDAMAGE;
var config WeaponDamageValue THELOST_DASHER_TIER4_MELEEATTACK_BASEDAMAGE;

var config WeaponDamageValue THELOST_GRAPPLER_TIER1_MELEEATTACK_BASEDAMAGE;
var config WeaponDamageValue THELOST_GRAPPLER_TIER2_MELEEATTACK_BASEDAMAGE;
var config WeaponDamageValue THELOST_GRAPPLER_TIER3_MELEEATTACK_BASEDAMAGE;
var config WeaponDamageValue THELOST_GRAPPLER_TIER4_MELEEATTACK_BASEDAMAGE;

var config WeaponDamageValue THELOST_BRUTE_TIER1_MELEEATTACK_BASEDAMAGE;
var config WeaponDamageValue THELOST_BRUTE_TIER2_MELEEATTACK_BASEDAMAGE;
var config WeaponDamageValue THELOST_BRUTE_TIER3_MELEEATTACK_BASEDAMAGE;
var config WeaponDamageValue THELOST_BRUTE_TIER4_MELEEATTACK_BASEDAMAGE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;

	Weapons.AddItem(CreateTemplate_TheLost_MeleeAttack('TheLostTier4_MeleeAttack', default.THELOST_TIER4_MELEEATTACK_BASEDAMAGE));

	Weapons.AddItem(CreateTemplate_TheLost_MeleeAttack('TheLostDasherTier1_MeleeAttack', default.THELOST_DASHER_TIER1_MELEEATTACK_BASEDAMAGE));
	Weapons.AddItem(CreateTemplate_TheLost_MeleeAttack('TheLostDasherTier2_MeleeAttack', default.THELOST_DASHER_TIER2_MELEEATTACK_BASEDAMAGE));
	Weapons.AddItem(CreateTemplate_TheLost_MeleeAttack('TheLostDasherTier3_MeleeAttack', default.THELOST_DASHER_TIER3_MELEEATTACK_BASEDAMAGE));
	Weapons.AddItem(CreateTemplate_TheLost_MeleeAttack('TheLostDasherTier4_MeleeAttack', default.THELOST_DASHER_TIER4_MELEEATTACK_BASEDAMAGE));
    
	Weapons.AddItem(CreateTemplate_TheLostGrappler_MeleeAttack('TheLostGrapplerTier1_MeleeAttack', default.THELOST_GRAPPLER_TIER1_MELEEATTACK_BASEDAMAGE));
	Weapons.AddItem(CreateTemplate_TheLostGrappler_MeleeAttack('TheLostGrapplerTier2_MeleeAttack', default.THELOST_GRAPPLER_TIER2_MELEEATTACK_BASEDAMAGE));
	Weapons.AddItem(CreateTemplate_TheLostGrappler_MeleeAttack('TheLostGrapplerTier3_MeleeAttack', default.THELOST_GRAPPLER_TIER3_MELEEATTACK_BASEDAMAGE));
	Weapons.AddItem(CreateTemplate_TheLostGrappler_MeleeAttack('TheLostGrapplerTier4_MeleeAttack', default.THELOST_GRAPPLER_TIER4_MELEEATTACK_BASEDAMAGE));

	Weapons.AddItem(CreateTemplate_TheLost_MeleeAttack('TheLostBruteTier1_MeleeAttack', default.THELOST_BRUTE_TIER1_MELEEATTACK_BASEDAMAGE));
	Weapons.AddItem(CreateTemplate_TheLost_MeleeAttack('TheLostBruteTier2_MeleeAttack', default.THELOST_BRUTE_TIER2_MELEEATTACK_BASEDAMAGE));
	Weapons.AddItem(CreateTemplate_TheLost_MeleeAttack('TheLostBruteTier3_MeleeAttack', default.THELOST_BRUTE_TIER3_MELEEATTACK_BASEDAMAGE));
	Weapons.AddItem(CreateTemplate_TheLost_MeleeAttack('TheLostBruteTier4_MeleeAttack', default.THELOST_BRUTE_TIER4_MELEEATTACK_BASEDAMAGE));
    
	Weapons.AddItem(CreateBruteAcid_WPN());

	return Weapons;
}
    

static function X2DataTemplate CreateTemplate_TheLost_MeleeAttack(name WeaponTemplateName, WeaponDamageValue WeaponBaseDamage)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, WeaponTemplateName);

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'melee';
	Template.WeaponTech = 'alien';
	Template.strImage = "img:///UILibrary_PerkIcons.UIPerk_muton_punch";
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.StowedLocation = eSlot_RightHand;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Zombiefist.WP_Zombiefist";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.iRange = 2;
	Template.iRadius = 1;
	Template.NumUpgradeSlots = 2;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;
	Template.iIdealRange = 1;

	Template.BaseDamage = WeaponBaseDamage;
	Template.BaseDamage.DamageType = 'Melee';
	Template.iSoundRange = 2;
	Template.iEnvironmentDamage = 10;

	//Build Data
	Template.StartingItem = false;
	Template.CanBeBuilt = false;

	Template.bDisplayWeaponAndAmmo = false;

	Template.Abilities.AddItem('LostAttack');

	return Template;
}

static function X2DataTemplate CreateTemplate_TheLostGrappler_MeleeAttack(name WeaponTemplateName, WeaponDamageValue WeaponBaseDamage)
{
    local X2WeaponTemplate Template;

    Template = X2WeaponTemplate(CreateTemplate_TheLost_MeleeAttack(WeaponTemplateName, WeaponBaseDamage));
    Template.Abilities.AddItem('LostBladestorm');

    return Template;
}

static function X2DataTemplate CreateBruteAcid_WPN()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'BruteAcid_WPN');

	Template.ItemCat = 'defense';
	Template.WeaponCat = 'utility';
	Template.strImage = "img:///UILibrary_StrategyImages.InventoryIcons.Inv_SmokeGrenade";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.GameArchetype = "WP_Grenade_Acid.WP_Grenade_Acid";
	Template.CanBeBuilt = false;	

	//Template.iRange = 14;
	Template.iRadius = 3;
	Template.iClipSize = 1;
	Template.InfiniteAmmo = true;

	Template.iSoundRange = 6;
	Template.bSoundOriginatesFromOwnerLocation = true;

	Template.BaseDamage.DamageType = 'Acid';

	Template.InventorySlot = eInvSlot_Utility;
	Template.StowedLocation = eSlot_None;
	Template.Abilities.AddItem('BruteAcid');

	return Template;
}
