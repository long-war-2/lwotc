class X2Rocket_Napalm_T3 extends X2Item config(Rockets);

var name TemplateName;
var config bool CREATE_ROCKET;

var localized string WildfireEffectName;
var localized string WildfireEffectDescription;

var config int BURN_DAMAGE;
var config int BURN_DAMAGE_SPREAD;
var config int BURN_DAMAGE_SPREAD_CHANCE;
var config int WILDFIRE_DURATION_TURNS;

var config float ROCKET_FIRE_CHANCE_LEVEL_1;
var config float ROCKET_FIRE_CHANCE_LEVEL_2;
var config float ROCKET_FIRE_CHANCE_LEVEL_3;

var config bool FORCE_ENEMIES_TO_MOVE;
var config int REACTION_FIRE_BONUS_AIM;

var config WeaponDamageValue BaseDamage;
var config int iEnvironmentDamage;
var config int iClipSize;
var config int iSoundRange;
var config int Range;
var config int Radius;
var config int MOBILITY_PENALTY;

var config bool REQUIRE_ARMING;
var config int TYPICAL_ACTION_COST;

var config string Image;
var config string GAME_ARCHETYPE;

var config name WEAPON_TECH;
var config int Tier;

var config array<name> COMPATIBLE_LAUNCHERS;

var config bool STARTING_ITEM;
var config bool INFINITE_ITEM;
var config name CREATOR_TEMPLATE_NAME;
var config name HIDE_IF_TECH_RESEARCHED;
var config name HIDE_IF_ITEM_PURCHASED;
var config name BASE_ITEM;
var config bool CAN_BE_BUILT;
var config array<name> REQUIRED_TECHS;
var config array<name> REWARD_DECKS;
var config array<name> RESOURCE_COST_TYPE;
var config array<int> RESOURCE_COST_QUANTITY;
var config int BLACKMARKET_VALUE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	if (default.CREATE_ROCKET)
	{
		Templates.AddItem(Create_Rocket_Main());
		Templates.AddItem(Create_Rocket_Pair());
	}
	return Templates;
}


static function X2DataTemplate Create_Rocket_Main()
{
	local X2RocketTemplate 				Template;
	local X2Effect_ApplyWeaponDamage	WeaponDamageEffect;
	local X2Effect_Knockback			KnockbackEffect;
	local X2Effect_Burning				BurnEffect;
	local ArtifactCost					Resources;
	local X2Effect_ApplyFireToWorld		FireEffect;
	local X2Effect_Wildfire			WildFireEffect;
	local X2Effect_LW2WotC_FallBack		FallBackEffect;
	local X2Condition_UnitProperty		UnitPropertyCondition;
	local int i;
	
	`CREATE_X2TEMPLATE(class'X2RocketTemplate', Template, default.TemplateName);

	Template.strImage = default.IMAGE;
	Template.EquipSound = "StrategyUI_Heavy_Weapon_Equip";

	Template.AddAbilityIconOverride('IRI_FireRocket', "img:///IRI_RocketLaunchers.UI.Fire_Napalm");
	Template.AddAbilityIconOverride('IRI_FireRocket_Spark', "img:///IRI_RocketLaunchers.UI.Fire_Napalm");
	Template.AddAbilityIconOverride('IRI_GiveRocket', "img:///IRI_RocketLaunchers.UI.Give_Napalm");
	Template.AddAbilityIconOverride('IRI_ArmRocket', "img:///IRI_RocketLaunchers.UI.Arm_Napalm");
	
	Template.WeaponTech = default.WEAPON_TECH;
	Template.Tier = default.TIER;

	Template.COMPATIBLE_LAUNCHERS = default.COMPATIBLE_LAUNCHERS;

	Template.RequireArming = default.REQUIRE_ARMING;
	Template.iTypicalActionCost = default.TYPICAL_ACTION_COST;
	
	Template.GameArchetype = default.GAME_ARCHETYPE;
	Template.BaseDamage = default.BASEDAMAGE;
	Template.iEnvironmentDamage = default.IENVIRONMENTDAMAGE;
	Template.iRange = default.RANGE;
	Template.iRadius = default.RADIUS;
	Template.iSoundRange = default.ISOUNDRANGE;
	Template.iClipSize = default.ICLIPSIZE;
	if (Template.iClipSize <= 1) Template.bHideClipSizeStat = true;
	Template.MobilityPenalty = default.MOBILITY_PENALTY;
	
	Template.CanBeBuilt = default.CAN_BE_BUILT;
	Template.bInfiniteItem = default.INFINITE_ITEM;
	Template.StartingItem = default.STARTING_ITEM;
	
	Template.CreatorTemplateName = default.CREATOR_TEMPLATE_NAME;
	Template.BaseItem = default.BASE_ITEM;
	
	Template.RewardDecks = default.REWARD_DECKS;
	Template.HideIfResearched = default.HIDE_IF_TECH_RESEARCHED;
	Template.HideIfPurchased = default.HIDE_IF_ITEM_PURCHASED;
	
	if (!Template.bInfiniteItem)
	{
		Template.TradingPostValue = default.BLACKMARKET_VALUE;
		
		if (Template.CanBeBuilt)
		{
			Template.Requirements.RequiredTechs = default.REQUIRED_TECHS;
			
			for (i = 0; i < default.RESOURCE_COST_TYPE.Length; i++)
			{
				if (default.RESOURCE_COST_QUANTITY[i] > 0)
				{
					Resources.ItemTemplateName = default.RESOURCE_COST_TYPE[i];
					Resources.Quantity = default.RESOURCE_COST_QUANTITY[i];
					Template.Cost.ResourceCosts.AddItem(Resources);
				}
			}
		}
	}
	
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);
	
	FireEffect = new class'X2Effect_ApplyFireToWorld';
	FireEffect.bUseFireChanceLevel = true;
	FireEffect.FireChance_Level1 = default.ROCKET_FIRE_CHANCE_LEVEL_1;
	FireEffect.FireChance_Level2 = default.ROCKET_FIRE_CHANCE_LEVEL_2;
	FireEffect.FireChance_Level3 = default.ROCKET_FIRE_CHANCE_LEVEL_3;
	Template.ThrownGrenadeEffects.AddItem(FireEffect);

	if (default.FORCE_ENEMIES_TO_MOVE)
	{
		FallBackEffect = new class'X2Effect_LW2WotC_FallBack';
		FallBackEffect.BehaviorTree = 'FlushRoot_IRIROCK';

		//	excludes dead by default, excludes robotic - let them terminator walk out of that fire
		UnitPropertyCondition = new class'X2Condition_UnitProperty';
		UnitPropertyCondition.ExcludeFriendlyToSource = true;
		UnitPropertyCondition.ExcludeRobotic = true;
		FallBackEffect.TargetConditions.AddItem(UnitPropertyCondition);

		Template.ThrownGrenadeEffects.AddItem(FallBackEffect);
	}
	WildFireEffect = new class'X2Effect_Wildfire';
	WildFireEffect.SetDisplayInfo(ePerkBuff_Penalty, default.WildfireEffectName, default.WildfireEffectDescription, "img:///UILibrary_PerkIcons.UIPerk_flamethrower", true, "img:///UILibrary_Common.status_burning");
	WildFireEffect.BuildPersistentEffect(default.WILDFIRE_DURATION_TURNS, , false, , eGameRule_PlayerTurnBegin); //enemy player turn begin
	WildFireEffect.EffectName = 'IRI_Effect_Wildfire';

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.ExcludeRobotic = false;
	WildFireEffect.TargetConditions.AddItem(UnitPropertyCondition);

	Template.ThrownGrenadeEffects.AddItem(WildFireEffect);

	BurnEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(default.BURN_DAMAGE, default.BURN_DAMAGE_SPREAD);
	//BurnEffect.BuildPersistentEffect(10,, false,,eGameRule_PlayerTurnBegin); 
	BurnEffect.EffectTickedFn = class'X2Rocket_Napalm'.static.BurningTicked;
	Template.ThrownGrenadeEffects.AddItem(BurnEffect);

	//Template.OnThrowBarkSoundCue = 'Flamethrower';
	Template.OnThrowBarkSoundCue = 'RocketLauncher';

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.ThrownGrenadeEffects.AddItem(KnockbackEffect);
	
	Template.DamageTypeTemplateName = Template.BaseDamage.DamageType;

	Template.Abilities.AddItem('GrenadeFuse');
	Template.Abilities.AddItem('IRI_FireRocket');
	Template.Abilities.AddItem('IRI_RocketMobilityPenalty');
	//Template.Abilities.AddItem('IRI_GiveRocket');
	Template.Abilities.AddItem('IRI_AggregateRocketAmmo');
	Template.Abilities.AddItem('IRI_ArmRocket');
	Template.Abilities.AddItem('IRI_DisarmRocket');

	Template.iPhysicsImpulse = 10;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel,, default.RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel,, default.RADIUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel,, default.BASEDAMAGE.Shred);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, Template.MobilityPenalty);

	Template.PairedTemplateName = name(default.TemplateName $ "_Pair");

	return Template;
}

static function X2DataTemplate Create_Rocket_Pair()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, name(default.TemplateName $ "_Pair"));

	Template.GameArchetype = default.GAME_ARCHETYPE;
	
	Template.ItemCat = 'cosmetic_rocket';
	Template.WeaponCat = 'rocket';

	return Template;
}

defaultproperties
{
	TemplateName = "IRI_X2Rocket_Napalm_T3"
}