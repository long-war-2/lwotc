//---------------------------------------------------------------------------------------
//  FILE:    X2Item_LWGauntlet2.uc
//  AUTHOR:  Merist / Original code by Amineri (Pavonis Interactive)
//  PURPOSE: New setup for Techincal's Gauntlet weapons 
//---------------------------------------------------------------------------------------
class X2Item_LWGauntlet2 extends X2Item_LWGauntlet config(GameData_WeaponData);

var config name RocketLauncher_WeaponCat;
var config name Flamethrower_WeaponCat;
var config EInventorySlot Flamethrower_InventorySlot;

var config int Gauntlet_Secondary_CONVENTIONAL_ICLIPSIZE;
var config int Gauntlet_Secondary_MAG_ICLIPSIZE;
var config int Gauntlet_Secondary_BEAM_ICLIPSIZE;

var localized string Flamethrower_NapalmXLabel;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(RocketLauncher_Conventional());
    Templates.AddItem(RocketLauncher_Magnetic());
    Templates.AddItem(RocketLauncher_Beam());

    Templates.AddItem(Flamethrower_Conventional());
    Templates.AddItem(Flamethrower_Magnetic());
    Templates.AddItem(Flamethrower_Beam());

    return Templates;
}

static function X2WeaponTemplate RocketLauncher_Conventional(name DataName = 'LWGauntlet_CV')
{
    local X2PairedWeaponTemplate    Template;

    `CREATE_X2TEMPLATE(class'X2PairedWeaponTemplate', Template, DataName);

    Template.ItemCat = 'weapon';
    Template.WeaponCat = default.RocketLauncher_WeaponCat;
    Template.WeaponTech = 'conventional';
    Template.strImage = default.Gauntlet_CV_UIImage;
    Template.EquipSound = "Secondary_Weapon_Equip_Conventional";
    Template.WeaponPanelImage = "_ConventionalRifle";
    Template.Tier = 0;

    Template.PairedSlot = default.Flamethrower_InventorySlot;
    Template.PairedTemplateName = 'LWGauntlet_Flamethrower_CV';

    Template.BaseDamage = default.Gauntlet_Primary_CONVENTIONAL_BASEDAMAGE;
    Template.ExtraDamage = default.Gauntlet_Primary_CONVENTIONAL_EXTRADAMAGE;
    Template.iEnvironmentDamage = default.Gauntlet_Primary_CONVENTIONAL_IENVIRONMENTDAMAGE;
    Template.DamageTypeTemplateName = 'Explosion';

    if (default.Gauntlet_Primary_CONVENTIONAL_ICLIPSIZE > 0)
    {
        Template.iClipSize = default.Gauntlet_Primary_CONVENTIONAL_ICLIPSIZE;
        Template.InfiniteAmmo = false;
    }
    else
    {
        Template.iClipSize = 99;
        Template.InfiniteAmmo = true;
        Template.bHideClipSizeStat = true;
    }
    Template.bMergeAmmo = true;

    Template.iRange = default.Gauntlet_Primary_CONVENTIONAL_RANGE;
    Template.iRadius = default.Gauntlet_Primary_CONVENTIONAL_RADIUS;
    Template.iSoundRange = default.Gauntlet_Primary_CONVENTIONAL_ISOUNDRANGE;
    Template.bSoundOriginatesFromOwnerLocation = false;

    Template.iPhysicsImpulse = 5;

    Template.InventorySlot = eInvSlot_SecondaryWeapon;
    Template.StowedLocation = eSlot_HeavyWeapon;

    Template.GameArchetype = "LWGauntletWOTC.Archetypes.WP_Gauntlet_RocketLauncher_CV";

    Template.Abilities.AddItem('LWRocketLauncher');
    Template.Abilities.AddItem('RocketFuse');
    Template.Abilities.AddItem('LWFlamethrower_Dummy');

    Template.PointsToComplete = 0;
    Template.TradingPostValue = 0;

    Template.CanBeBuilt = false;
    Template.StartingItem = true;
    Template.bInfiniteItem = true;

    Template.SetUIStatMarkup(default.PrimaryRangeLabel,, default.Gauntlet_Primary_CONVENTIONAL_RANGE);
    Template.SetUIStatMarkup(default.PrimaryRadiusLabel,, default.Gauntlet_Primary_CONVENTIONAL_RADIUS);
    Template.SetUIStatMarkup(default.SecondaryRangeLabel, , default.Gauntlet_Secondary_CONVENTIONAL_RANGE);
    Template.SetUIStatMarkup(default.SecondaryRadiusLabel, , default.Gauntlet_Secondary_CONVENTIONAL_RADIUS);
    if (default.Flamethrower_NapalmXLabel != "")
    {
        Template.SetUIStatMarkup(default.Flamethrower_NapalmXLabel,, GetNapalmXMarkupValue(default.Gauntlet_Primary_CONVENTIONAL_EXTRADAMAGE),,, "%");
    }

    return Template;
}

static function X2WeaponTemplate RocketLauncher_Magnetic(name DataName = 'LWGauntlet_MG')
{
    local X2PairedWeaponTemplate    Template;

    `CREATE_X2TEMPLATE(class'X2PairedWeaponTemplate', Template, DataName);

    Template.ItemCat = 'weapon';
    Template.WeaponCat = default.RocketLauncher_WeaponCat;
    Template.WeaponTech = 'magnetic';
    Template.strImage = default.Gauntlet_MG_UIImage;
    Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";
    Template.WeaponPanelImage = "_ConventionalRifle";
    Template.Tier = 2;

    Template.PairedSlot = default.Flamethrower_InventorySlot;
    Template.PairedTemplateName = 'LWGauntlet_Flamethrower_MG';

    Template.BaseDamage = default.Gauntlet_Primary_MAG_BASEDAMAGE;
    Template.ExtraDamage = default.Gauntlet_Primary_MAG_EXTRADAMAGE;
    Template.iEnvironmentDamage = default.Gauntlet_Primary_MAG_IENVIRONMENTDAMAGE;
    Template.DamageTypeTemplateName = 'Explosion';

    if (default.Gauntlet_Primary_MAG_ICLIPSIZE > 0)
    {
        Template.iClipSize = default.Gauntlet_Primary_MAG_ICLIPSIZE;
        Template.InfiniteAmmo = false;
    }
    else
    {
        Template.iClipSize = 99;
        Template.InfiniteAmmo = true;
        Template.bHideClipSizeStat = true;
    }
    Template.bMergeAmmo = true;

    Template.iRange = default.Gauntlet_Primary_MAG_RANGE;
    Template.iRadius = default.Gauntlet_Primary_MAG_RADIUS;
    Template.iSoundRange = default.Gauntlet_Primary_MAG_ISOUNDRANGE;
    Template.bSoundOriginatesFromOwnerLocation = false;

    Template.iPhysicsImpulse = 5;

    Template.InventorySlot = eInvSlot_SecondaryWeapon;
    Template.StowedLocation = eSlot_HeavyWeapon;

    Template.GameArchetype = "LWGauntletWOTC.Archetypes.WP_Gauntlet_RocketLauncher_MG";

    Template.Abilities.AddItem('LWRocketLauncher');
    Template.Abilities.AddItem('RocketFuse');
    Template.Abilities.AddItem('LWFlamethrower_Dummy');

    Template.CanBeBuilt = true;
    Template.StartingItem = false;
    Template.bInfiniteItem = false;

    Template.SetUIStatMarkup(default.PrimaryRangeLabel, , default.Gauntlet_Primary_MAG_RANGE);
    Template.SetUIStatMarkup(default.PrimaryRadiusLabel, , default.Gauntlet_Primary_MAG_RADIUS);
    Template.SetUIStatMarkup(default.SecondaryRangeLabel, , default.Gauntlet_Secondary_MAG_RANGE);
    Template.SetUIStatMarkup(default.SecondaryRadiusLabel, , default.Gauntlet_Secondary_MAG_RADIUS);
    if (default.Flamethrower_NapalmXLabel != "")
    {
        Template.SetUIStatMarkup(default.Flamethrower_NapalmXLabel,, GetNapalmXMarkupValue(default.Gauntlet_Primary_MAG_EXTRADAMAGE),,, "%");
    }

    return Template;
}

static function X2WeaponTemplate RocketLauncher_Beam(name DataName = 'LWGauntlet_BM')
{
    local X2PairedWeaponTemplate    Template;

    `CREATE_X2TEMPLATE(class'X2PairedWeaponTemplate', Template, DataName);

    Template.ItemCat = 'weapon';
    Template.WeaponCat = default.RocketLauncher_WeaponCat;
    Template.WeaponTech = 'beam';
    Template.strImage = default.Gauntlet_BM_UIImage;
    Template.EquipSound = "Secondary_Weapon_Equip_Beam";
    Template.WeaponPanelImage = "_ConventionalRifle";
    Template.Tier = 4;

    Template.PairedSlot = default.Flamethrower_InventorySlot;
    Template.PairedTemplateName = 'LWGauntlet_Flamethrower_BM';

    Template.BaseDamage = default.Gauntlet_Primary_BEAM_BASEDAMAGE;
    Template.ExtraDamage = default.Gauntlet_Primary_BEAM_EXTRADAMAGE;
    Template.iEnvironmentDamage = default.Gauntlet_Primary_BEAM_IENVIRONMENTDAMAGE;
    Template.DamageTypeTemplateName = 'Explosion';

    if (default.Gauntlet_Primary_BEAM_ICLIPSIZE > 0)
    {
        Template.iClipSize = default.Gauntlet_Primary_BEAM_ICLIPSIZE;
        Template.InfiniteAmmo = false;
    }
    else
    {
        Template.iClipSize = 99;
        Template.InfiniteAmmo = true;
        Template.bHideClipSizeStat = true;
    }
    Template.bMergeAmmo = true;

    Template.iRange = default.Gauntlet_Primary_BEAM_RANGE;
    Template.iRadius = default.Gauntlet_Primary_BEAM_RADIUS;
    Template.iSoundRange = default.Gauntlet_Secondary_BEAM_ISOUNDRANGE;
    Template.bSoundOriginatesFromOwnerLocation = false;

    Template.iPhysicsImpulse = 5;

    Template.InventorySlot = eInvSlot_SecondaryWeapon;
    Template.StowedLocation = eSlot_HeavyWeapon;

    Template.GameArchetype = "LWGauntletWOTC.Archetypes.WP_Gauntlet_BlasterLauncher_BM";

    Template.Abilities.AddItem('LWBlasterLauncher');
    Template.Abilities.AddItem('RocketFuse');
    Template.Abilities.AddItem('LWFlamethrower_Dummy');

    Template.CanBeBuilt = true;
    Template.StartingItem = false;
    Template.bInfiniteItem = false;

    Template.SetUIStatMarkup(default.PrimaryRangeLabel, , default.Gauntlet_Primary_BEAM_RANGE);
    Template.SetUIStatMarkup(default.PrimaryRadiusLabel, , default.Gauntlet_Primary_BEAM_RADIUS);
    Template.SetUIStatMarkup(default.SecondaryRangeLabel, , default.Gauntlet_Secondary_BEAM_RANGE);
    Template.SetUIStatMarkup(default.SecondaryRadiusLabel, , default.Gauntlet_Secondary_BEAM_RADIUS);
    if (default.Flamethrower_NapalmXLabel != "")
    {
        Template.SetUIStatMarkup(default.Flamethrower_NapalmXLabel,, GetNapalmXMarkupValue(default.Gauntlet_Primary_BEAM_EXTRADAMAGE),,, "%");
    }

    return Template;
}

static function X2WeaponTemplate Flamethrower_Conventional(name DataName = 'LWGauntlet_Flamethrower_CV')
{
    local X2WeaponTemplate Template;

    `CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, DataName);

    Template.ItemCat = 'weapon';
    Template.WeaponCat = default.Flamethrower_WeaponCat;
    Template.WeaponTech = 'conventional';
    Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_FlameThrower";
    Template.EquipSound = "Secondary_Weapon_Equip_Conventional";
    Template.WeaponPanelImage = "_ConventionalRifle";
    Template.Tier = 0;

    Template.BaseDamage = default.Gauntlet_Secondary_CONVENTIONAL_BASEDAMAGE;
    Template.ExtraDamage = default.Gauntlet_Primary_CONVENTIONAL_EXTRADAMAGE;
    Template.iEnvironmentDamage = default.Gauntlet_Secondary_CONVENTIONAL_IENVIRONMENTDAMAGE;
    Template.DamageTypeTemplateName = 'Fire';

    if (default.Gauntlet_Secondary_CONVENTIONAL_ICLIPSIZE > 0)
    {
        Template.iClipSize = default.Gauntlet_Secondary_CONVENTIONAL_ICLIPSIZE;
        Template.InfiniteAmmo = false;
    }
    else
    {
        Template.iClipSize = 99;
        Template.InfiniteAmmo = true;
        Template.bHideClipSizeStat = true;
    }
    Template.bMergeAmmo = true;

    Template.iRange = default.Gauntlet_Secondary_CONVENTIONAL_RANGE;
    Template.iRadius = default.Gauntlet_Secondary_CONVENTIONAL_RADIUS;
    Template.iSoundRange = default.Gauntlet_Secondary_CONVENTIONAL_ISOUNDRANGE;
    Template.bSoundOriginatesFromOwnerLocation = true;

    Template.iPhysicsImpulse = 5;

    Template.InventorySlot = default.Flamethrower_InventorySlot;
    Template.StowedLocation = eSlot_HeavyWeapon;

    Template.GameArchetype = "LWGauntletWOTC.Archetypes.WP_Gauntlet_Flamethrower_CV";

    Template.Abilities.AddItem('LWFlamethrower');

    Template.PointsToComplete = 0;
    Template.TradingPostValue = 0;

    Template.CanBeBuilt = false;
    Template.StartingItem = false;
    Template.bInfiniteItem = true;

    Template.SetUIStatMarkup(default.SecondaryRangeLabel, , default.Gauntlet_Secondary_CONVENTIONAL_RANGE);
    Template.SetUIStatMarkup(default.SecondaryRadiusLabel, , default.Gauntlet_Secondary_CONVENTIONAL_RADIUS);
    if (default.Flamethrower_NapalmXLabel != "")
    {
        Template.SetUIStatMarkup(default.Flamethrower_NapalmXLabel,, GetNapalmXMarkupValue(default.Gauntlet_Primary_CONVENTIONAL_EXTRADAMAGE),,, "%");
    }

    return Template;
}

static function X2WeaponTemplate Flamethrower_Magnetic(name DataName = 'LWGauntlet_Flamethrower_MG')
{
    local X2WeaponTemplate Template;

    `CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, DataName);

    Template.ItemCat = 'weapon';
    Template.WeaponCat = default.Flamethrower_WeaponCat;
    Template.WeaponTech = 'magnetic';
    Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_FlameThrower";
    Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";
    Template.WeaponPanelImage = "_ConventionalRifle";
    Template.Tier = 2;

    Template.BaseDamage = default.Gauntlet_Secondary_MAG_BASEDAMAGE;
    Template.ExtraDamage = default.Gauntlet_Primary_MAG_EXTRADAMAGE;
    Template.iEnvironmentDamage = default.Gauntlet_Secondary_MAG_IENVIRONMENTDAMAGE;
    Template.DamageTypeTemplateName = 'Fire';

    if (default.Gauntlet_Secondary_MAG_ICLIPSIZE > 0)
    {
        Template.iClipSize = default.Gauntlet_Secondary_MAG_ICLIPSIZE;
        Template.InfiniteAmmo = false;
    }
    else
    {
        Template.iClipSize = 99;
        Template.InfiniteAmmo = true;
        Template.bHideClipSizeStat = true;
    }
    Template.bMergeAmmo = true;

    Template.iRange = default.Gauntlet_Secondary_MAG_RANGE;
    Template.iRadius = default.Gauntlet_Secondary_MAG_RADIUS;
    Template.iSoundRange = default.Gauntlet_Secondary_MAG_ISOUNDRANGE;
    Template.bSoundOriginatesFromOwnerLocation = true;

    Template.iPhysicsImpulse = 5;

    Template.InventorySlot = default.Flamethrower_InventorySlot;
    Template.StowedLocation = eSlot_HeavyWeapon;

    Template.GameArchetype = "LWGauntletWOTC.Archetypes.WP_Gauntlet_Flamethrower_MG";

    Template.Abilities.AddItem('LWFlamethrower');

    Template.PointsToComplete = 0;
    Template.TradingPostValue = 0;

    Template.CanBeBuilt = false;
    Template.StartingItem = false;
    Template.bInfiniteItem = true;

    Template.SetUIStatMarkup(default.SecondaryRangeLabel, , default.Gauntlet_Secondary_MAG_RANGE);
    Template.SetUIStatMarkup(default.SecondaryRadiusLabel, , default.Gauntlet_Secondary_MAG_RADIUS);
    if (default.Flamethrower_NapalmXLabel != "")
    {
        Template.SetUIStatMarkup(default.Flamethrower_NapalmXLabel,, GetNapalmXMarkupValue(default.Gauntlet_Primary_MAG_EXTRADAMAGE),,, "%");
    }

    return Template;
}

static function X2WeaponTemplate Flamethrower_Beam(name DataName = 'LWGauntlet_Flamethrower_BM')
{
    local X2WeaponTemplate Template;

    `CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, DataName);

    Template.ItemCat = 'weapon';
    Template.WeaponCat = default.Flamethrower_WeaponCat;
    Template.WeaponTech = 'beam';
    Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_FlameThrowerMK2";
    Template.EquipSound = "Secondary_Weapon_Equip_Beam";
    Template.WeaponPanelImage = "_ConventionalRifle";
    Template.Tier = 4;

    Template.BaseDamage = default.Gauntlet_Secondary_BEAM_BASEDAMAGE;
    Template.ExtraDamage = default.Gauntlet_Primary_BEAM_EXTRADAMAGE;
    Template.iEnvironmentDamage = default.Gauntlet_Secondary_BEAM_IENVIRONMENTDAMAGE;
    Template.DamageTypeTemplateName = 'Fire';

    if (default.Gauntlet_Secondary_BEAM_ICLIPSIZE > 0)
    {
        Template.iClipSize = default.Gauntlet_Secondary_BEAM_ICLIPSIZE;
        Template.InfiniteAmmo = false;
    }
    else
    {
        Template.iClipSize = 99;
        Template.InfiniteAmmo = true;
        Template.bHideClipSizeStat = true;
    }
    Template.bMergeAmmo = true;

    Template.iRange = default.Gauntlet_Secondary_BEAM_RANGE;
    Template.iRadius = default.Gauntlet_Secondary_BEAM_RADIUS;
    Template.iSoundRange = default.Gauntlet_Secondary_BEAM_ISOUNDRANGE;
    Template.bSoundOriginatesFromOwnerLocation = true;

    Template.iPhysicsImpulse = 5;

    Template.InventorySlot = default.Flamethrower_InventorySlot;
    Template.StowedLocation = eSlot_HeavyWeapon;

    Template.GameArchetype = "LWGauntletWOTC.Archetypes.WP_Gauntlet_Flamethrower_BM";

    Template.Abilities.AddItem('LWFlamethrower');

    Template.PointsToComplete = 0;
    Template.TradingPostValue = 0;

    Template.CanBeBuilt = false;
    Template.StartingItem = false;
    Template.bInfiniteItem = true;

    Template.SetUIStatMarkup(default.SecondaryRangeLabel, , default.Gauntlet_Secondary_BEAM_RANGE);
    Template.SetUIStatMarkup(default.SecondaryRadiusLabel, , default.Gauntlet_Secondary_BEAM_RADIUS);
    if (default.Flamethrower_NapalmXLabel != "")
    {
        Template.SetUIStatMarkup(default.Flamethrower_NapalmXLabel,, GetNapalmXMarkupValue(default.Gauntlet_Primary_BEAM_EXTRADAMAGE),,, "%");
    }

    return Template;
}

static function int GetNapalmXMarkupValue(array<WeaponDamageValue> ExtraDamage)
{
    local WeaponDamageValue DamageValue;
    local int Index;
    Index = ExtraDamage.Find('Tag', class'X2Ability_LW_TechnicalAbilitySet2'.default.NapalmXDamageTag);
    if (Index > 0)
    {
    	DamageValue = ExtraDamage[Index];
    }
    return DamageValue.Damage;
}