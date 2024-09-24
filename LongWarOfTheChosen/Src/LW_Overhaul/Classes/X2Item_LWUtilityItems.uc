class X2Item_LWUtilityItems extends X2Item config(LW_Overhaul);

var config int SHREDDER_ROUNDS_SHRED;

var config int STILETTO_DMGMOD;
var config int STILETTO_ALIEN_DMG;

var config int NEEDLE_DMGMOD;
var config int NEEDLE_ADVENT_DMG;

var config int REDSCREEN_HACK_DEFENSE_CHANGE;

var config int FLECHETTE_DMGMOD;
var config int FLECHETTE_BONUS_DMG;

var config int NEUROWHIP_PSI_BONUS;
var config int NEUROWHIP_WILL_MALUS;



static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Items;

	`LWTrace("  >> X2Item_LWUtilityItems.CreateTemplates()");
	

    Items.AddItem(CreateCeramicPlating());
	Items.AddItem(CreateAlloyPlating());
	Items.AddItem(CreateCarapacePlating());
	Items.AddItem(CreateChitinPlating());
	Items.AddItem(CreateChameleonSuit());

	Items.AddItem(CreateStilettoRounds());
	Items.AddItem(CreateFalconRounds());
	Items.AddItem(CreateFlechetteRounds());
	Items.AddItem(CreateRedScreenRounds());
	Items.AddItem(CreateNeedleRounds());

	Items.AddItem(CreateHighPressureTanks());
	Items.AddItem(CreateExtraRocket());

	Items.AddItem(CreateGhostGrenade());

	Items.AddItem(CreateNeurowhip());

	Items.AddItem(CreateShapedCharge());

	Items.AddItem(CreateScoutScanner());

	return Items;
}



static function X2DataTemplate CreateCeramicPlating()
{
	local X2EquipmentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'CeramicPlating');
	Template.ItemCat = 'plating';
	Template.InventorySlot = eInvSlot_Utility;
	Template.strImage = "img:///UILibrary_LWOTC.InventoryArt.Inv_Flame_Sealant_512";
	Template.EquipSound = "StrategyUI_Vest_Equip";

	Template.Tier = 0;

	Template.StartingItem = true;
	Template.CanBeBuilt = false;

	Template.Abilities.AddItem('Ceramic_Plating_Ability');

	return Template;
}

static function X2DataTemplate CreateAlloyPlating()
{
	local X2EquipmentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'AlloyPlating');
	Template.ItemCat = 'plating';
	Template.InventorySlot = eInvSlot_Utility;
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Nano_Fiber_Sark";
	Template.EquipSound = "StrategyUI_Vest_Equip";

	Template.Tier = 1;
	Template.StartingItem = false;
	Template.CanBeBuilt = true;

	Template.Abilities.AddItem('Alloy_Plating_Ability');

	return Template;
}

static function X2DataTemplate CreateCarapacePlating()
{
	local X2EquipmentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'CarapacePlating');
	Template.ItemCat = 'plating';
	Template.InventorySlot = eInvSlot_Utility;
	Template.strImage = "img:///UILibrary_LWOTC.InventoryArt.Inv_Power_Armor512";
	Template.EquipSound = "StrategyUI_Vest_Equip";

	Template.Tier = 3;
	Template.StartingItem = false;
	Template.CanBeBuilt = true;

	Template.Abilities.AddItem('Carapace_Plating_Ability');

	return Template;
}


static function X2DataTemplate CreateChitinPlating()
{
	local X2EquipmentTemplate Template; 

	`CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'ChitinPlating');
	Template.ItemCat = 'plating';
	Template.InventorySlot = eInvSlot_Utility;
	Template.strImage = "img:///UILibrary_LWOTC.InventoryArt.Inv_Heat_Absorption_512";
	Template.EquipSound = "StrategyUI_Vest_Equip";

	Template.Tier = 2;
	Template.StartingItem = false;
	Template.CanBeBuilt = true;

	Template.Abilities.AddItem('Chitin_Plating_Ability');

	return Template;
}

static function X2DataTemplate CreateChameleonSuit()
{
	local X2EquipmentTemplate Template; 

	`CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'ChameleonSuit');
	Template.ItemCat = 'defense';
	Template.InventorySlot = eInvSlot_Utility;
	Template.strImage = "img:///UILibrary_LWOTC.InventoryArt.Inv_Tarantula_Suit_512";
	Template.EquipSound = "StrategyUI_Vest_Equip";

	Template.Tier = 2;
	Template.StartingItem = false;
	Template.CanBeBuilt = true;

	//EFFECT IS CAPTURED IN INFILTRATION CODE

	return Template;
}

static function X2AmmoTemplate CreateStilettoRounds()
{
	local X2AmmoTemplate				Template;
	local WeaponDamageValue DamageValue;	

	`CREATE_X2TEMPLATE(class'X2AmmoTemplate', Template, 'StilettoRounds');
	Template.strImage = "img:///UILibrary_LWOTC.InventoryArt.Inv_Stiletto_Rounds_512";
	Template.EquipSound = "StrategyUI_Ammo_Equip";
	Template.Tier = 2;
	Template.InventorySlot = eInvSlot_Utility;
	Template.RewardDecks.AddItem('ExperimentalAmmoRewards');

	DamageValue.Damage = default.STILETTO_DMGMOD;
    DamageValue.DamageType = 'Stiletto';
    Template.AddAmmoDamageModifier(none, DamageValue);

	Template.StartingItem = false;
	Template.CanBeBuilt = true;

	Template.Abilities.AddItem('Stiletto_Rounds_Ability');

	//FX References
	//Template.GameArchetype = "Ammo_Stiletto.PJ_Stiletto"; // present, placeholder FX
	return Template;
}

static function X2DataTemplate CreateNeurowhip()
{
	local X2EquipmentTemplate Template; 

	`CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'Neurowhip');
	Template.ItemCat = 'psioffense';
	Template.InventorySlot = eInvSlot_Utility;
    Template.CanBeBuilt = true;
	Template.EquipSound = "StrategyUI_Mindshield_Equip";
	Template.strImage = "img:///UILibrary_LWOTC.InventoryArt.Inv_Neurowhip";
	Template.Abilities.AddItem('Neurowhip_Ability');

	Template.SetUIStatMarkup(class'XLocalizedData'.default.PsiOffenseLabel, eStat_PsiOffense, default.NEUROWHIP_PSI_BONUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.WillLabel, eStat_Will, -default.NEUROWHIP_WILL_MALUS);

	return Template;
}

// Shredder Rounds
static function X2AmmoTemplate CreateFalconRounds()
{
	local X2AmmoTemplate	Template;
	local WeaponDamageValue DamageValue;

	`CREATE_X2TEMPLATE(class'X2AmmoTemplate', Template, 'FalconRounds');
	Template.strImage = "img:///UILibrary_LWOTC.InventoryArt.Inv_Falcon_Rounds_512";
	Template.EquipSound = "StrategyUI_Ammo_Equip";
	Template.Tier = 2;
	Template.InventorySlot = eInvSlot_Utility;
	Template.RewardDecks.AddItem('ExperimentalAmmoRewards');

	Template.StartingItem = false;
	Template.CanBeBuilt = true;

	DamageValue.Shred = default.SHREDDER_ROUNDS_SHRED;
	Template.AddAmmoDamageModifier(none, DamageValue);

	Template.Abilities.AddItem('Shredder_Rounds_Ability');

	//FX References
	Template.GameArchetype = "Ammo_Falcon.PJ_Incendiary_Upgraded"; // Falcon missing, may need one of these for coilguns
	return Template;
}

static function X2AmmoTemplate CreateFlechetteRounds()
{
	local X2AmmoTemplate				Template;
	local WeaponDamageValue				DamageValue;

	`CREATE_X2TEMPLATE(class'X2AmmoTemplate', Template, 'FlechetteRounds');
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Flechette_Rounds";
	Template.EquipSound = "StrategyUI_Ammo_Equip";
	Template.Tier = 2;
	Template.InventorySlot = eInvSlot_Utility;
	Template.RewardDecks.AddItem('ExperimentalAmmoRewards');

	Template.StartingItem = false;
	Template.CanBeBuilt = true;

	DamageValue.Damage = default.FLECHETTE_DMGMOD;
	DamageValue.DamageType = 'Flechette';
	Template.AddAmmoDamageModifier(none, DamageValue);

	Template.Abilities.AddItem('Flechette_Rounds_Ability');	

	Template.GameArchetype = "Ammo_Flechette.PJ_Flechette"; // present
	//FX References
	return Template;
}

static function X2AmmoTemplate CreateRedScreenRounds()
{
	local X2AmmoTemplate				Template;
	local X2Condition_UnitProperty		Condition_UnitProperty;
	local X2Effect_PersistentStatChange HackDefenseEffect;

	`CREATE_X2TEMPLATE(class'X2AmmoTemplate', Template, 'RedscreenRounds');
	Template.strImage = "img:///UILibrary_LWOTC.InventoryArt.Inv_Redscreen_Rounds_512";
	Template.EquipSound = "StrategyUI_Ammo_Equip";
	Template.Tier = 2;
	Template.InventorySlot = eInvSlot_Utility;
	Template.RewardDecks.AddItem('ExperimentalAmmoRewards');

	Template.StartingItem = false;
	Template.CanBeBuilt = true;

    Condition_UnitProperty = new class'X2Condition_UnitProperty';
    Condition_UnitProperty.ExcludeOrganic = true;
    Condition_UnitProperty.IncludeWeakAgainstTechLikeRobot = true;
    Condition_UnitProperty.TreatMindControlledSquadmateAsHostile = true;

	HackDefenseEffect = class'Helpers_LW'.static.CreateHackDefenseReductionStatusEffect(
		'Redscreen Hack Bonus',
		default.REDSCREEN_HACK_DEFENSE_CHANGE,
		Condition_UnitProperty);
	Template.TargetEffects.AddItem(HackDefenseEffect);

	Template.Abilities.AddItem('Redscreen_Rounds_Ability');

	//Template.GameArchetype = "Ammo_Redscreen.PJ_Redscreen"; //present, placeholder FX
	//FX References
	return Template;
}

static function X2AmmoTemplate CreateNeedleRounds()
{
	local X2AmmoTemplate				Template;
	local X2Condition_UnitProperty		Condition;
	local WeaponDamageValue				DamageValue;

	`CREATE_X2TEMPLATE(class'X2AmmoTemplate', Template, 'NeedleRounds');
	Template.strImage = "img:///UILibrary_LWOTC.InventoryArt.Inv_Needle_Rounds_512";
	Template.EquipSound = "StrategyUI_Ammo_Equip";
	Template.Tier = 2;
	Template.InventorySlot = eInvSlot_Utility;
	Template.RewardDecks.AddItem('ExperimentalAmmoRewards');

	Template.StartingItem = false;
	Template.CanBeBuilt = true;

	DamageValue.Damage = default.NEEDLE_DMGMOD;
    DamageValue.DamageType = 'Needle';
    Template.AddAmmoDamageModifier(none, DamageValue);

	Condition = new class'X2Condition_UnitProperty';
	Condition.IsAdvent = true;
	Condition.ExcludeRobotic = true;
	Condition.ExcludeAlien = true;
	Condition.FailOnNonUnits = true;
	DamageValue.Damage = default.NEEDLE_ADVENT_DMG;
	Template.AddAmmoDamageModifier(Condition, DamageValue);

	Template.Abilities.AddItem('Needle_Rounds_Ability');

	//Template.GameArchetype = "Ammo_Needle.PJ_Needle"; // present, placeholder FX
	//FX References
	return Template;
}

static function X2DataTemplate CreateHighPressureTanks()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'HighPressureTanks');
	Template.WeaponCat = 'heavyammo';
	Template.ItemCat = 'weapon';
	Template.InventorySlot = eInvSlot_HeavyWeapon;
	Template.strImage = "img:///UILibrary_LWOTC.InventoryArt.Inv_HighPressureTanks"; 
	Template.EquipSound = "StrategyUI_Heavy_Weapon_Equip";
	//Template.Abilities.AddItem ('HighPressure');
	Template.CanBeBuilt = false;
	Template.StartingItem = true;
	Template.bInfiniteItem = true;
	Template.Tier = 0;

	return Template;
}

static function X2DataTemplate CreateExtraRocket()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'ExtraRocket');
	Template.WeaponCat = 'heavyammo';
	Template.ItemCat = 'weapon';
	Template.InventorySlot = eInvSlot_HeavyWeapon;
	Template.strImage = "img:///UILibrary_LWOTC.InventoryArt.Inv_ExtraRocket"; 
	Template.EquipSound = "StrategyUI_Heavy_Weapon_Equip";
	//Template.Abilities.AddItem ('ShockAndAwe');
	Template.CanBeBuilt = false;
	Template.StartingItem = true;
	Template.bInfiniteItem = true;
	Template.Tier = 0;
	return Template;
}


// Dummy item to fire for VanishingAct;
static function X2GrenadeTemplate CreateGhostGrenade()
{
	local X2GrenadeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, 'GhostGrenade_LW');

	Template.WeaponCat = 'Utility';
    Template.ItemCat = 'Utility';

	Template.iRange = class'X2Item_DefaultGrenades'.default.SMOKEGRENADE_RANGE;
    Template.iRadius = 0.75;
    Template.iSoundRange = class'X2Item_DefaultGrenades'.default.SMOKEGRENADE_ISOUNDRANGE;
    Template.iEnvironmentDamage = class'X2Item_DefaultGrenades'.default.SMOKEGRENADE_IENVIRONMENTDAMAGE;
	Template.iClipSize = 0;
	Template.Tier = 2;

	//Template.AddAbilityIconOverride('ThrowGrenade', "img:///UILibrary_PerkIcons.UIPerk_ghost");
    //Template.AddAbilityIconOverride('LaunchGrenade', "img:///UILibrary_PerkIcons.UIPerk_ghost");

	//Template.Abilities.AddItem('ThrowGrenade');
	Template.Abilities.AddItem('VanishingAct');

	//WeaponEffect = new class'X2Effect_ApplySmokeGrenadeToWorld';
	//Template.AddTargetEffect (WeaponEffect);

	//SmokeEffect = new class'X2Effect_SmokeGrenade';
	//SmokeEffect.BuildPersistentEffect(class'X2Effect_ApplySmokeGrenadeToWorld'.default.Duration + 1, false, false, false, eGameRule_PlayerTurnBegin);
    //SmokeEffect.SetDisplayInfo(1, class'X2Item_DefaultGrenades'.default.SmokeGrenadeEffectDisplayName, class'X2Item_DefaultGrenades'.default.SmokeGrenadeEffectDisplayDesc, "img:///UILibrary_PerkIcons.UIPerk_grenade_smoke");
    //SmokeEffect.HitMod = class'X2Item_DefaultGrenades'.default.SMOKEGRENADE_HITMOD;
    //SmokeEffect.DuplicateResponse = 1;
	//Template.AddTargetEffect (SmokeEffect);

	//StealthEffect = new class'X2Effect_RangerStealth';
    //StealthEffect.BuildPersistentEffect(1, true, true, false, 8);
    //StealthEffect.SetDisplayInfo(1, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true);
    //StealthEffect.bRemoveWhenTargetConcealmentBroken = true;
    //Template.AddTargetEffect(StealthEffect);
    //Template.AddTargetEffect(class'X2Effect_Spotted'.static.CreateUnspottedEffect());

	//Template.bFriendlyFireWarning = false;

    Template.GameArchetype = "WP_Grenade_Smoke.WP_Grenade_Smoke";
	Template.OnThrowBarkSoundCue = 'SmokeGrenade';

	Template.CanBeBuilt = false;

	return Template;
}


static function X2DataTemplate CreateShapedCharge()
{
	local X2GrenadeTemplate Template;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
    local X2Effect_Knockback KnockbackEffect;
	local X2Effect_TriggerEvent ShapedChargeUsedEffect;

	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, 'ShapedCharge');
	
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Power_Cell";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.AddAbilityIconOverride('ThrowGrenade', "img:///UILibrary_PerkIcons.UIPerk_item_x4");
    Template.AddAbilityIconOverride('LaunchGrenade', "img:///UILibrary_PerkIcons.UIPerk_item_x4");
	Template.iRange = class'X2Item_DefaultWeaponMods_LW'.default.SHAPEDCHARGE_RANGE;
    Template.iRadius = class'X2Item_DefaultWeaponMods_LW'.default.SHAPEDCHARGE_RADIUS;
    Template.BaseDamage = class'X2Item_DefaultWeaponMods_LW'.default.SHAPEDCHARGE_BASEDAMAGE;
    Template.iSoundRange = class'X2Item_DefaultWeaponMods_LW'.default.SHAPEDCHARGE_ISOUNDRANGE;
    Template.iEnvironmentDamage = class'X2Item_DefaultWeaponMods_LW'.default.SHAPEDCHARGE_IENVIRONMENTDAMAGE;
    Template.iClipSize = 1;

	Template.Abilities.AddItem('ThrowGrenade');
    Template.Abilities.AddItem('GrenadeFuse');
	//Template.Abilities.AddItem('ConsumeShapedCharge');

	Template.GameArchetype = "LW_ShapedCharge.LW_ShapedCharge";
	Template.DamageTypeTemplateName = 'Explosion';

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
    WeaponDamageEffect.bExplosiveDamage = true;
	Template.iPhysicsImpulse = 10;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);
    Template.LaunchedGrenadeEffects.AddItem(WeaponDamageEffect);

	KnockbackEffect = new class'X2Effect_Knockback';
    KnockbackEffect.KnockbackDistance = 4;
	Template.ThrownGrenadeEffects.AddItem(KnockbackEffect);
    Template.LaunchedGrenadeEffects.AddItem(KnockbackEffect);

	ShapedChargeUsedEffect = new class'X2Effect_TriggerEvent';
	ShapedChargeUsedEffect.TriggerEventName = 'ShapedChargeUsed';	
	Template.ThrownGrenadeEffects.AddItem(ShapedChargeUsedEffect);
    Template.LaunchedGrenadeEffects.AddItem(ShapedChargeUsedEffect);
    Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel,, class'X2Item_DefaultWeaponMods_LW'.default.SHAPEDCHARGE_RANGE);
    Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel,, class'X2Item_DefaultWeaponMods_LW'.default.SHAPEDCHARGE_RADIUS);

	return Template;
}

static function X2WeaponTemplate CreateScoutScanner()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'ScoutScanner_LW');

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Battle_Scanner";
	Template.EquipSound = "StrategyUI_Grenade_Equip";

	Template.GameArchetype = "WP_Grenade_BattleScanner.WP_Grenade_BattleScanner";
	Template.Abilities.AddItem('ScoutScanner_LW');
	Template.ItemCat = 'tech';
	Template.WeaponCat = 'utility';
	Template.WeaponTech = 'conventional';
	Template.InventorySlot = eInvSlot_Utility;
	Template.StowedLocation = eSlot_BeltHolster;
	Template.bMergeAmmo = true;
	Template.iClipSize = 1;
	Template.Tier = 1;

	Template.iRadius = class'X2Item_DefaultUtilityItems'.default.BATTLESCANNER_RADIUS;
	Template.iRange = class'X2Item_DefaultUtilityItems'.default.BATTLESCANNER_RANGE;

	Template.CanBeBuilt = false;

	Template.bShouldCreateDifficultyVariants = true;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , class'X2Item_DefaultUtilityItems'.default.BATTLESCANNER_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , class'X2Item_DefaultUtilityItems'.default.BATTLESCANNER_RADIUS);

	return Template;
}
