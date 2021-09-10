class X2Rocket_WhitePh_T3 extends X2Item config(Rockets);

var name TemplateName;
var config bool CREATE_ROCKET;

var config WeaponDamageValue BaseDamage;

var config int POISONED_TURNS;
var config array<ECharStatType> POISONED_STAT_ADJUST;
var config array<int> POISONED_STAT_ADJUST_VALUE;
var config int POISONED_INITIAL_SHED;
var config int POISONED_PER_TURN_SHED;
var config int POISONED_DAMAGE;

var config int iEnvironmentDamage;
var config int ICLIPSIZE;
var config int iSoundRange;
var config int RANGE;
var config int Radius;
var config int MOBILITY_PENALTY;

var config string Image;
var config string GAME_ARCHETYPE;

var config name WEAPON_TECH;
var config int Tier;
var config array<name> COMPATIBLE_LAUNCHERS;

var config bool REQUIRE_ARMING;
var config int TYPICAL_ACTION_COST;

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

var config int FIRE_DAMAGE;
var config int FIRE_DAMAGE_SPREAD;


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
	local X2Effect_ApplyPoisonToWorld	PoisonEffect;
	local X2Effect_Burning				BurningEffect;
	local X2Effect_PersistentStatChange	PoisonedEffect;
	local ArtifactCost					Resources;
	local int i;
	
	`CREATE_X2TEMPLATE(class'X2RocketTemplate', Template, default.TemplateName);

	Template.AddAbilityIconOverride('IRI_FireRocket', "img:///IRI_RocketLaunchers.UI.Fire_Phosphorous");
	Template.AddAbilityIconOverride('IRI_FireRocket_Spark', "img:///IRI_RocketLaunchers.UI.Fire_Phosphorous");
	Template.AddAbilityIconOverride('IRI_GiveRocket', "img:///IRI_RocketLaunchers.UI.Give_Phosphorous");
	Template.AddAbilityIconOverride('IRI_ArmRocket', "img:///IRI_RocketLaunchers.UI.Arm_Phosphorous");

	Template.strImage = default.IMAGE;
	Template.EquipSound = "StrategyUI_Heavy_Weapon_Equip";
	
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
	
	Template.DamageTypeTemplateName = Template.BaseDamage.DamageType;
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	//WeaponDamageEffect.bApplyWorldEffectsForEachTargetLocation = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);

	Template.OnThrowBarkSoundCue = 'RocketLauncher';

	//	## POISON
	//	Poison World Effect
	
	PoisonEffect = new class'X2Effect_ApplyPoisonToWorld';
	PoisonEffect.PoisonParticleSystemFill_Name = "IRI_RocketLaunchers.PFX.Phosphorous_World_Persistent";
	Template.ThrownGrenadeEffects.AddItem(PoisonEffect);

	//	Poison Unit Effect
	PoisonedEffect = CreatePoisonedStatusEffect();
	PoisonedEffect.BuildPersistentEffect(5,, false,,eGameRule_PlayerTurnBegin);
	Template.ThrownGrenadeEffects.AddItem(PoisonedEffect);

	//	Fire Unit Effect
	BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(default.FIRE_DAMAGE, default.FIRE_DAMAGE_SPREAD);
	BurningEffect.BuildPersistentEffect(5,, false,,eGameRule_PlayerTurnBegin);
	Template.ThrownGrenadeEffects.AddItem(BurningEffect);

	Template.Abilities.AddItem('GrenadeFuse');
	Template.Abilities.AddItem('IRI_FireRocket');
	//Template.Abilities.AddItem('IRI_RocketMobilityPenalty');
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

static function X2Effect_PersistentStatChange CreatePoisonedStatusEffect()
{
	local X2Effect_PersistentStatChange     PersistentStatChangeEffect;
	local X2Effect_ApplyWeaponDamage              DamageEffect;
	local X2Condition_UnitProperty UnitPropCondition;
	local int i;

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.EffectName = class'X2StatusEffects'.default.PoisonedName;
	PersistentStatChangeEffect.DuplicateResponse = eDupe_Refresh;
	PersistentStatChangeEffect.BuildPersistentEffect(default.POISONED_TURNS,, false,,eGameRule_PlayerTurnBegin);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Penalty, class'X2StatusEffects'.default.PoisonedFriendlyName, class'X2StatusEffects'.default.PoisonedFriendlyDesc, "img:///UILibrary_PerkIcons.UIPerk_poisoned");

	for (i = 0; i < default.POISONED_STAT_ADJUST.Length; i++)
	{
		PersistentStatChangeEffect.AddPersistentStatChange(default.POISONED_STAT_ADJUST[i], default.POISONED_STAT_ADJUST_VALUE[i]);
	}
	
	PersistentStatChangeEffect.iInitialShedChance = default.POISONED_INITIAL_SHED;
	PersistentStatChangeEffect.iPerTurnShedChance = default.POISONED_PER_TURN_SHED;
	PersistentStatChangeEffect.VisualizationFn = class'X2StatusEffects'.static.PoisonedVisualization;
	PersistentStatChangeEffect.EffectTickedVisualizationFn = class'X2StatusEffects'.static.PoisonedVisualizationTicked;
	PersistentStatChangeEffect.EffectRemovedVisualizationFn = class'X2StatusEffects'.static.PoisonedVisualizationRemoved;
	PersistentStatChangeEffect.DamageTypes.AddItem('Poison');
	PersistentStatChangeEffect.bRemoveWhenTargetDies = true;
	PersistentStatChangeEffect.bCanTickEveryAction = true;
	PersistentStatChangeEffect.EffectAppliedEventName = 'PoisonedEffectAdded';
	PersistentStatChangeEffect.PersistentPerkName = class'X2StatusEffects'.default.PoisonEnteredPerk_Name;

	UnitPropCondition = new class'X2Condition_UnitProperty';
	UnitPropCondition.ExcludeFriendlyToSource = false;
	UnitPropCondition.ExcludeRobotic = true;
	PersistentStatChangeEffect.TargetConditions.AddItem(UnitPropCondition);

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.EffectDamageValue.Damage = default.POISONED_DAMAGE;
	DamageEffect.EffectDamageValue.DamageType = 'Poison';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTypes.AddItem('Poison');
	DamageEffect.bAllowFreeKill = false;
	DamageEffect.bIgnoreArmor = true;
	DamageEffect.bBypassShields = class'X2StatusEffects'.default.POISONED_IGNORES_SHIELDS; // Issue #89
	PersistentStatChangeEffect.ApplyOnTick.AddItem(DamageEffect);

	PersistentStatChangeEffect.EffectTickedFn = class'X2Rocket_WhitePh'.static.PoisonTicked;

	return PersistentStatChangeEffect;
}


defaultproperties
{
	TemplateName = "IRI_X2Rocket_WhitePh_T3"
}