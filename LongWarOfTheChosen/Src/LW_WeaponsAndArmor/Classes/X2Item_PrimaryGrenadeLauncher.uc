// This is an Unreal Script
class X2Item_PrimaryGrenadeLauncher extends X2Item config(GameData_WeaponData);

var config int GRENADELAUNCHER_ISOUNDRANGE;
var config int GRENADELAUNCHER_IENVIRONMENTDAMAGE;
var config int GRENADELAUNCHER_ISUPPLIES;
var config int GRENADELAUNCHER_TRADINGPOSTVALUE;
var config int GRENADELAUNCHER_IPOINTS;
var config int GRENADELAUNCHER_ICLIPSIZE;
var config int GRENADELAUNCHER_RANGEBONUS;
var config int GRENADELAUNCHER_RADIUSBONUS;

var config int ADVGRENADELAUNCHER_ISOUNDRANGE;
var config int ADVGRENADELAUNCHER_IENVIRONMENTDAMAGE;
var config int ADVGRENADELAUNCHER_ISUPPLIES;
var config int ADVGRENADELAUNCHER_TRADINGPOSTVALUE;
var config int ADVGRENADELAUNCHER_IPOINTS;
var config int ADVGRENADELAUNCHER_ICLIPSIZE;
var config int ADVGRENADELAUNCHER_RANGEBONUS;
var config int ADVGRENADELAUNCHER_RADIUSBONUS;

var config int BEAMGRENADELAUNCHER_ISOUNDRANGE;
var config int BEAMGRENADELAUNCHER_IENVIRONMENTDAMAGE;
var config int BEAMGRENADELAUNCHER_ICLIPSIZE;
var config int BEAMGRENADELAUNCHER_RANGEBONUS;
var config int BEAMGRENADELAUNCHER_RADIUSBONUS;

var config bool FRAGLAUNCH_BEAMMODEL;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Grenades;

	Grenades.AddItem(CreatePrimaryGrenadeLauncher_CV());
	Grenades.AddItem(CreatePrimaryGrenadeLauncher_MG());
	Grenades.AddItem(CreatePrimaryGrenadeLauncher_BM());

	return Grenades;
}

static function X2GrenadeLauncherTemplate CreatePrimaryGrenadeLauncher_CV()
{
	local X2GrenadeLauncherTemplate Template;

	`CREATE_X2TEMPLATE(class'X2GrenadeLauncherTemplate', Template, 'PrimaryGrenadeLauncher_CV');

	Template.strImage = "img:///UILibrary_Common.ConvSecondaryWeapons.ConvGrenade";
	Template.EquipSound = "Secondary_Weapon_Equip_Conventional";

	Template.iSoundRange = default.GRENADELAUNCHER_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.GRENADELAUNCHER_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = default.GRENADELAUNCHER_TRADINGPOSTVALUE;
	Template.iClipSize = default.GRENADELAUNCHER_ICLIPSIZE;
	Template.Tier = 0;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.StowedLocation = eSlot_RightHand;
	

	Template.IncreaseGrenadeRadius = default.GRENADELAUNCHER_RADIUSBONUS;
	Template.IncreaseGrenadeRange = default.GRENADELAUNCHER_RANGEBONUS;

    Template.Abilities.AddItem('LaunchGrenade');
    Template.Abilities.AddItem('PrimaryGrenadeLauncher_CV');
	Template.GameArchetype = "GrimyClassAN_GrenadeLauncher.WP_GrenadeLauncher_CV";
	
	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.GrenadeRangeBonusLabel, , default.GRENADELAUNCHER_RANGEBONUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.GrenadeRadiusBonusLabel, , default.GRENADELAUNCHER_RADIUSBONUS);

	return Template;
}

static function X2GrenadeLauncherTemplate CreatePrimaryGrenadeLauncher_MG()
{
	local X2GrenadeLauncherTemplate Template;

	`CREATE_X2TEMPLATE(class'X2GrenadeLauncherTemplate', Template, 'PrimaryGrenadeLauncher_MG');

	Template.strImage = "img:///UILibrary_Common.MagSecondaryWeapons.MagLauncher";
	Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";

	Template.iSoundRange = default.ADVGRENADELAUNCHER_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ADVGRENADELAUNCHER_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = default.ADVGRENADELAUNCHER_TRADINGPOSTVALUE;
	Template.iClipSize = default.ADVGRENADELAUNCHER_ICLIPSIZE;
	Template.Tier = 2;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.StowedLocation = eSlot_RightHand;

	//Template.Abilities.AddItem('LaunchGrenade');
	//Template.Abilities.AddItem('PrimaryLoadGrenades');
	//Template.Abilities.AddItem('PrimaryLightOrdnance');

	Template.IncreaseGrenadeRadius = default.ADVGRENADELAUNCHER_RADIUSBONUS;
	Template.IncreaseGrenadeRange = default.ADVGRENADELAUNCHER_RANGEBONUS;

	Template.GameArchetype = "GrimyClassAN_GrenadeLauncher.WP_GrenadeLauncher_MG";

	Template.CreatorTemplateName = 'GrenadeLauncher_MG_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'MicroGrenadeLauncher_CV'; // Which item this will be upgraded from

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
    Template.Abilities.AddItem('LaunchGrenade');
    Template.Abilities.AddItem('PrimaryGrenadeLauncher_MG');

	Template.SetUIStatMarkup(class'XLocalizedData'.default.GrenadeRangeBonusLabel, , default.ADVGRENADELAUNCHER_RANGEBONUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.GrenadeRadiusBonusLabel, , default.ADVGRENADELAUNCHER_RADIUSBONUS);

	return Template;
}

static function X2GrenadeLauncherTemplate CreatePrimaryGrenadeLauncher_BM()
{
	local X2GrenadeLauncherTemplate Template;

	`CREATE_X2TEMPLATE(class'X2GrenadeLauncherTemplate', Template, 'PrimaryGrenadeLauncher_BM');

	Template.strImage = "img:///WP_BeamGrenadeLauncher.UI.BeamLauncher";
	Template.EquipSound = "Secondary_Weapon_Equip_Beam";

	Template.iSoundRange = default.BEAMGRENADELAUNCHER_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.BEAMGRENADELAUNCHER_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = 18;
	Template.iClipSize = default.BEAMGRENADELAUNCHER_ICLIPSIZE;
	Template.Tier = 4;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.StowedLocation = eSlot_RightHand;

	Template.IncreaseGrenadeRadius = default.BEAMGRENADELAUNCHER_RADIUSBONUS;
	Template.IncreaseGrenadeRange = default.BEAMGRENADELAUNCHER_RANGEBONUS;

	Template.GameArchetype = "GrimyClassAN_GrenadeLauncher.WP_GrenadeLauncher_BM";

	Template.CreatorTemplateName = 'GrenadeLauncher_BM_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'MicroGrenadeLauncher_MG'; // Which item this will be upgraded from

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
    Template.Abilities.AddItem('LaunchGrenade');
    Template.Abilities.AddItem('PrimaryGrenadeLauncher_BM');

	Template.SetUIStatMarkup(class'XLocalizedData'.default.GrenadeRangeBonusLabel, , default.BEAMGRENADELAUNCHER_RANGEBONUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.GrenadeRadiusBonusLabel, , default.BEAMGRENADELAUNCHER_RADIUSBONUS);

	return Template;
}