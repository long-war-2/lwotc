//---------------------------------------------------------------------------------------
//  FILE:    X2Item_DenseSmokeGrenade.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Dense Smoke grenade items that get swapped in for regular, providing extra defense
//--------------------------------------------------------------------------------------- 
class X2Item_DenseSmokeGrenade extends X2Item config(LW_SoldierSkills);

var localized string DenseSmokeGrenadeEffectDisplayName;
var localized string DenseSmokeGrenadeEffectDisplayDesc;
var config int DENSESMOKEGRENADE_HITMOD;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Grenades;

	Grenades.AddItem(CreateDenseSmokeGrenade());
	Grenades.AddItem(CreateDenseSmokeGrenadeMk2());

	return Grenades;
}

static function X2Effect DenseSmokeGrenadeEffect()
{
	local X2Effect_DenseSmokeGrenade Effect;

	Effect = new class'X2Effect_DenseSmokeGrenade';
	//Must be at least as long as the duration of the smoke effect on the tiles. Will get "cut short" when the tile stops smoking or the unit moves. -btopp 2015-08-05
	Effect.BuildPersistentEffect(class'X2Effect_ApplyDenseSmokeGrenadeToWorld'.default.Duration + 1, false, false, false, eGameRule_PlayerTurnBegin);
	Effect.SetDisplayInfo(ePerkBuff_Bonus, default.DenseSmokeGrenadeEffectDisplayName, default.DenseSmokeGrenadeEffectDisplayDesc, "img:///UILibrary_PerkIcons.UIPerk_grenade_smoke");
	Effect.HitMod = default.DENSESMOKEGRENADE_HITMOD;
	Effect.DuplicateResponse = eDupe_Refresh;
	return Effect;
}

static function X2DataTemplate CreateDenseSmokeGrenade()
{
	local X2GrenadeTemplate Template;
	local X2Effect_ApplySmokeGrenadeToWorld WorldSmokeEffect;
	local X2Effect_ApplyDenseSmokeGrenadeToWorld WorldDenseSmokeEffect;
	//local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, 'DenseSmokeGrenade');

	Template.WeaponCat = 'utility';
	Template.ItemCat = 'utility';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Smoke_Grenade";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.AddAbilityIconOverride('ThrowGrenade', "img:///UILibrary_PerkIcons.UIPerk_grenade_smoke");
	Template.AddAbilityIconOverride('LaunchGrenade', "img:///UILibrary_PerkIcons.UIPerk_grenade_smoke");
	Template.iRange = class'X2Item_DefaultGrenades'.default.SMOKEGRENADE_RANGE;
	Template.iRadius = class'X2Item_DefaultGrenades'.default.SMOKEGRENADE_RADIUS;

	Template.iSoundRange = class'X2Item_DefaultGrenades'.default.SMOKEGRENADE_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultGrenades'.default.SMOKEGRENADE_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = 7;
	Template.PointsToComplete = class'X2Item_DefaultGrenades'.default.SMOKEGRENADE_IPOINTS;
	Template.iClipSize = class'X2Item_DefaultGrenades'.default.SMOKEGRENADE_ICLIPSIZE;
	Template.Tier = 0;

	Template.Abilities.AddItem('ThrowGrenade');
	Template.bFriendlyFireWarning = false;

	WorldSmokeEffect = new class'X2Effect_ApplySmokeGrenadeToWorld';	
	WorldDenseSmokeEffect = new class'X2Effect_ApplyDenseSmokeGrenadeToWorld';	
	Template.ThrownGrenadeEffects.AddItem(WorldSmokeEffect);
	Template.ThrownGrenadeEffects.AddItem(WorldDenseSmokeEffect);
	Template.ThrownGrenadeEffects.AddItem(class'X2Item_DefaultGrenades'.static.SmokeGrenadeEffect());
	Template.ThrownGrenadeEffects.AddItem(DenseSmokeGrenadeEffect());
	Template.LaunchedGrenadeEffects = Template.ThrownGrenadeEffects;

	Template.GameArchetype = "WP_Grenade_Smoke.WP_Grenade_Smoke";

	Template.CanBeBuilt = false;

	// Cost
	//Resources.ItemTemplateName = 'Supplies';
	//Resources.Quantity = 25;
	//Template.Cost.ResourceCosts.AddItem(Resources);
//
	//Template.HideIfResearched = 'AdvancedGrenades';

	// Soldier Bark
	Template.OnThrowBarkSoundCue = 'SmokeGrenade';

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , class'X2Item_DefaultGrenades'.default.SMOKEGRENADE_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , class'X2Item_DefaultGrenades'.default.SMOKEGRENADE_RADIUS);

	return Template;
}

static function X2DataTemplate CreateDenseSmokeGrenadeMk2()
{
	local X2GrenadeTemplate Template;
	local X2Effect_ApplySmokeGrenadeToWorld WorldSmokeEffect;
	local X2Effect_ApplyDenseSmokeGrenadeToWorld WorldDenseSmokeEffect;
	//local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, 'DenseSmokeGrenadeMk2');
	
	Template.WeaponCat = 'utility';
	Template.ItemCat = 'utility';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Smoke_GrenadeMK2";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.AddAbilityIconOverride('ThrowGrenade', "img:///UILibrary_PerkIcons.UIPerk_grenade_smoke");
	Template.AddAbilityIconOverride('LaunchGrenade', "img:///UILibrary_PerkIcons.UIPerk_grenade_smoke");
	Template.iRange =  class'X2Item_DefaultGrenades'.default.SMOKEGRENADEMK2_RANGE;
	Template.iRadius =  class'X2Item_DefaultGrenades'.default.SMOKEGRENADEMK2_RADIUS;

	Template.iSoundRange =  class'X2Item_DefaultGrenades'.default.SMOKEGRENADE_ISOUNDRANGE;
	Template.iEnvironmentDamage =  class'X2Item_DefaultGrenades'.default.SMOKEGRENADE_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = 10;
	Template.PointsToComplete =  class'X2Item_DefaultGrenades'.default.SMOKEGRENADE_IPOINTS;
	Template.iClipSize =  class'X2Item_DefaultGrenades'.default.SMOKEGRENADE_ICLIPSIZE;
	Template.Tier = 1;

	Template.Abilities.AddItem('ThrowGrenade');
	Template.bFriendlyFireWarning = false;

	WorldSmokeEffect = new class'X2Effect_ApplySmokeGrenadeToWorld';	
	WorldDenseSmokeEffect = new class'X2Effect_ApplyDenseSmokeGrenadeToWorld';	
	Template.ThrownGrenadeEffects.AddItem(WorldSmokeEffect);
	Template.ThrownGrenadeEffects.AddItem(WorldDenseSmokeEffect);
	Template.ThrownGrenadeEffects.AddItem(class'X2Item_DefaultGrenades'.static.SmokeGrenadeEffect());
	Template.ThrownGrenadeEffects.AddItem(DenseSmokeGrenadeEffect());
	Template.LaunchedGrenadeEffects = Template.ThrownGrenadeEffects;

	Template.GameArchetype = "WP_Grenade_Smoke.WP_Grenade_Smoke_Lv2";

	Template.CanBeBuilt = false;

	//Template.CreatorTemplateName = 'AdvancedGrenades'; // The schematic which creates this item
	//Template.BaseItem = 'SmokeGrenade'; // Which item this will be upgraded from
	
	// Cost
	//Resources.ItemTemplateName = 'Supplies';
	//Resources.Quantity = 50;
	//Template.Cost.ResourceCosts.AddItem(Resources);
//
	//Template.Requirements.RequiredTechs.AddItem('AdvancedGrenades');

	// Soldier Bark
	Template.OnThrowBarkSoundCue = 'SmokeGrenade';

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , class'X2Item_DefaultGrenades'.default.SMOKEGRENADEMK2_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , class'X2Item_DefaultGrenades'.default.SMOKEGRENADEMK2_RADIUS);

	return Template;
}