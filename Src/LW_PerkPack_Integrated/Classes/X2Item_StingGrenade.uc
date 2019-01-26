//---------------------------------------------------------------------------------------
//  FILE:    X2Item_StingGrenade.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Sting Grenade that disorients and has a chance to stun
//--------------------------------------------------------------------------------------- 
class X2Item_StingGrenade extends X2Item config(LW_SoldierSkills);


var config int STING_GRENADE_STUN_CHANCE;
var config int STING_GRENADE_STUN_LEVEL;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Grenades;

	Grenades.AddItem( CreateStingGrenade());

	return Grenades;
}


static function X2DataTemplate CreateStingGrenade()
{
	local X2GrenadeTemplate				Template;
	local X2Effect_ApplyWeaponDamage	WeaponDamageEffect;
	local X2Effect_Stunned				StunnedEffect;
	local X2Condition_UnitProperty UnitCondition;
	//local ArtifactCost					Resources;

	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, 'StingGrenade');

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Flashbang_Grenade";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.AddAbilityIconOverride('ThrowGrenade', "img:///UILibrary_PerkIcons.UIPerk_grenade_flash");
	Template.AddAbilityIconOverride('LaunchGrenade', "img:///UILibrary_PerkIcons.UIPerk_grenade_flash");
	Template.iRange = class'X2Item_DefaultGrenades'.default.FLASHBANGGRENADE_RANGE;
	Template.iRadius = class'X2Item_DefaultGrenades'.default.FLASHBANGGRENADE_RADIUS;
	
	Template.bFriendlyFire = false;
	Template.bFriendlyFireWarning = false;
	Template.Abilities.AddItem('ThrowGrenade');

	Template.ThrownGrenadeEffects.AddItem(class'X2StatusEffects'.static.CreateDisorientedStatusEffect());

	//We need to have an ApplyWeaponDamage for visualization, even if the grenade does 0 damage (makes the unit flinch, shows overwatch removal)
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);

	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.ExcludeOrganic = false;
	UnitCondition.IncludeWeakAgainstTechLikeRobot = false;
	UnitCondition.ExcludeFriendlyToSource = false;

	StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(default.STING_GRENADE_STUN_LEVEL, default.STING_GRENADE_STUN_CHANCE);
	StunnedEffect.SetDisplayInfo(ePerkBuff_Penalty, class'X2StatusEffects'.default.StunnedFriendlyName, class'X2StatusEffects'.default.StunnedFriendlyDesc, "img:///UILibrary_PerkIcons.UIPerk_stun");
	StunnedEffect.TargetConditions.AddItem(UnitCondition);
	Template.ThrownGrenadeEffects.AddItem(StunnedEffect);

	Template.LaunchedGrenadeEffects = Template.ThrownGrenadeEffects;
	
	Template.GameArchetype = "WP_Grenade_Flashbang.WP_Grenade_Flashbang";

	Template.CanBeBuilt = false; // only granted via ability

	Template.iSoundRange = class'X2Item_DefaultGrenades'.default.FLASHBANGGRENADE_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultGrenades'.default.FLASHBANGGRENADE_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = 10;
	Template.PointsToComplete = class'X2Item_DefaultGrenades'.default.FLASHBANGGRENADE_IPOINTS;
	Template.iClipSize = class'X2Item_DefaultGrenades'.default.FLASHBANGGRENADE_ICLIPSIZE;
	Template.Tier = 0;

	// Soldier Bark
	Template.OnThrowBarkSoundCue = 'ThrowFlashbang';

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , class'X2Item_DefaultGrenades'.default.FLASHBANGGRENADE_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , class'X2Item_DefaultGrenades'.default.FLASHBANGGRENADE_RADIUS);

	return Template;
}