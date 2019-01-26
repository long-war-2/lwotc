//---------------------------------------------------------------------------------------
//  FILE:    X2Item_EvacFlare.uc
//  AUTHOR:  tracktwo / Pavonis Interactive
//  PURPOSE: Hidden item for throwing evac flares to spawn evac zones.
//---------------------------------------------------------------------------------------

class X2Item_EvacFlare extends X2Item config(LW_Overhaul);

var config const int EVACFLARE_RANGE;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(EvacFlare());
    return Templates;
}

static function X2WeaponTemplate EvacFlare()
{
    local X2WeaponTemplate Template;

    Template = new class'X2WeaponTemplate';

    `CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'EvacFlare');

    Template.ItemCat = 'tech';
    Template.WeaponCat = 'utility';
    Template.strImage = "img:///UILibrary_StrategyImages.InventoryIcons.Inv_SmokeGrenade";
    Template.EquipSound = "StrategyUI_Grenade_Equip";
    Template.GameArchetype = "LWEvacZone.WP_Grenade_EvacFlare";

    Template.CanBeBuilt = false;
    
    Template.iRange = default.EVACFLARE_RANGE;
    Template.iRadius = 3;
    Template.iClipSize = 1;
    Template.InfiniteAmmo = true;
    // Must be size 0 (like the XPad) to be auto-equipped by all soldiers in the default loadout.
    Template.iItemSize = 0;

    Template.iSoundRange = class'X2Item_DefaultGrenades'.default.GRENADE_SOUND_RANGE;
    Template.bSoundOriginatesFromOwnerLocation = false;

    Template.InventorySlot = eInvSlot_Utility;
    Template.StowedLocation = eSlot_None;
	// WOTC TODO: I've removed PlaceDelayedEvacZone so that vanilla missions with evac zones will
	// work properly. The proper solution is probably to make sure that those missions allow the
	// team to throw an evac or have a correctly working fixed evac zone.
    //Template.Abilities.AddItem('PlaceDelayedEvacZone');

    return Template;
}
