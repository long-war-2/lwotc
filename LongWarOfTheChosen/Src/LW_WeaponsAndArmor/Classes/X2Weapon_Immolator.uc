class X2Weapon_Immolator extends X2Item config(GameData_WeaponData);

var config WeaponDamageValue T0_FlameTHROWER_DAMAGE, CV_FlameTHROWER_DAMAGE, MG_FlameTHROWER_DAMAGE, BM_FlameTHROWER_DAMAGE;
var config array<WeaponDamageValue> Flamethrower_SkillDamage_T0, Flamethrower_SkillDamage_CV, Flamethrower_SkillDamage_MG, Flamethrower_SkillDamage_BM;
var config int FLAMETHROWER_IENVIRONMENTDAMAGE, FLAMETHROWER_ISOUNDRANGE, FLAMETHROWER_RANGE, FLAMETHROWER_RADIUS, FLAMETHROWER_ICLIPSIZE, MG_FLAMETHROWER_ICLIPSIZE, BM_FLAMETHROWER_ICLIPSIZE;
var config int Burn_Dmg_CV, Burn_Spread_CV, Upgrades_CV, Burn_Dmg_MG, Burn_Spread_MG, Upgrades_MG, Burn_Dmg_BM, Burn_Spread_BM, Upgrades_BM;
var config float FlameTHROWER_TILE_COVERAGE_PERCENT;
var config array<int> Flamethrower_rangemod;

var config int FireCanister_Buy, FireCanister_Sell, FireCanister_Alloy, FireCanister_Corpses;
var config int AcidCanister_Buy, AcidCanister_Sell, AcidCanister_Alloy, AcidCanister_Corpses;
var config int IceCanister_Buy, IceCanister_Sell, IceCanister_Alloy, IceCanister_Elerium;
var config int PoisonCanister_Buy, PoisonCanister_Sell, PoisonCanister_Alloy, PoisonCanister_Corpses;
var config int MedicCanister_Buy, MedicCanister_Sell, MedicCanister_Alloy, MedicCanister_Elerium;
var config int BluescreenCanister_Buy, BluescreenCanister_Sell, BluescreenCanister_Alloy, BluescreenCanister_Corpses;
var config int CurseCanister_Buy, CurseCanister_Sell, CurseCanister_Elerium, CurseCanister_Corpses;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Ammo;

	Ammo.AddItem(CreateTemplate_Immolator_T0());
	Ammo.AddItem(CreateTemplate_Immolator_CV());
	Ammo.AddItem(CreateTemplate_Immolator_MG());
	Ammo.AddItem(CreateTemplate_Immolator_BM());

	Ammo.AddItem(FireCanister());
	Ammo.AddItem(PoisonCanister());
	Ammo.AddItem(SmokeCanister());
	Ammo.AddItem(CurseCanister());
	Ammo.AddItem(AcidCanister());
	Ammo.AddItem(IceCanister());
	Ammo.AddItem(BluescreenCanister());
	Ammo.AddItem(BlastCanister());
	Ammo.AddItem(MedicCanister());
		
	return Ammo;
}
// **************************************************************************
// ***                   Immolator					                      ***
// **************************************************************************

static function X2DataTemplate CreateTemplate_Immolator_T0()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'LWImmolator_T0');
	
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lwchemthrower';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///IRIStolenFlamer_LW.UI.Flamethrower_TLE";
	Template.EquipSound = "Conventional_Weapon_Equip";
	Template.Tier = 0;

	Template.RangeAccuracy = default.Flamethrower_rangemod;
	Template.BaseDamage = default.T0_FlameTHROWER_DAMAGE;
	Template.ExtraDamage = default.Flamethrower_SkillDamage_T0;
	Template.iSoundRange = default.FLAMETHROWER_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.FLAMETHROWER_IENVIRONMENTDAMAGE;
	Template.iClipSize = default.FLAMETHROWER_ICLIPSIZE;
	Template.iRange = default.FLAMETHROWER_RANGE;
	Template.iRadius = default.FLAMETHROWER_RADIUS;
	Template.fCoverage = default.FlameTHROWER_TILE_COVERAGE_PERCENT;
	Template.BaseDamage.DamageType = 'Fire';
	
	Template.InfiniteAmmo = false;
	Template.PointsToComplete = 0;
	Template.DamageTypeTemplateName = 'Fire';
	Template.iTypicalActionCost = 2;
	Template.NumUpgradeSlots=default.Upgrades_CV;
	Template.iPhysicsImpulse = 5;
	//Template.bIsLargeWeapon = true;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	
	Template.GameArchetype ="IRIStolenFlamer_LW.Archetypes.WP_StolenFlamer";
	Template.bMergeAmmo = true;
	Template.bCanBeDodged = false;

	Template.Abilities.AddItem('MZFireThrower');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('MZFireThrowerOverwatchShot');
	
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	Template.StartingItem = true;

	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Cannon';

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , default.FLAMETHROWER_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , default.FLAMETHROWER_RADIUS);

	Template.BonusWeaponEffects.AddItem(class'X2StatusEffects'.static.CreateBurningStatusEffect(default.Burn_Dmg_CV, default.Burn_Spread_CV));

	return Template;
}


static function X2DataTemplate CreateTemplate_Immolator_CV()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'LWImmolator_CV');
	
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lwchemthrower';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///IRIClausImmolator.UI.Flamethrower_CV";
	Template.EquipSound = "Conventional_Weapon_Equip";
	Template.Tier = 0;

	Template.RangeAccuracy = default.Flamethrower_rangemod;
	Template.BaseDamage = default.CV_FlameTHROWER_DAMAGE;
	Template.ExtraDamage = default.Flamethrower_SkillDamage_CV;
	Template.iSoundRange = default.FLAMETHROWER_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.FLAMETHROWER_IENVIRONMENTDAMAGE;
	Template.iClipSize = default.FLAMETHROWER_ICLIPSIZE;
	Template.iRange = default.FLAMETHROWER_RANGE;
	Template.iRadius = default.FLAMETHROWER_RADIUS;
	Template.fCoverage = default.FlameTHROWER_TILE_COVERAGE_PERCENT;
	Template.BaseDamage.DamageType = 'Fire';
	
	Template.InfiniteAmmo = false;
	Template.PointsToComplete = 0;
	Template.DamageTypeTemplateName = 'Fire';
	Template.iTypicalActionCost = 2;
	Template.NumUpgradeSlots=default.Upgrades_CV;
	Template.iPhysicsImpulse = 5;
	//Template.bIsLargeWeapon = true;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	
	Template.GameArchetype ="IRIClausImmolator.Archetypes.WP_Immolator_CV_Arsenal";
	Template.bMergeAmmo = true;
	Template.bCanBeDodged = false;

	Template.Abilities.AddItem('MZFireThrower');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('MZFireThrowerOverwatchShot');
	
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	Template.StartingItem = true;

	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Cannon';

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , default.FLAMETHROWER_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , default.FLAMETHROWER_RADIUS);

	Template.BonusWeaponEffects.AddItem(class'X2StatusEffects'.static.CreateBurningStatusEffect(default.Burn_Dmg_CV, default.Burn_Spread_CV));

	return Template;
}

static function X2DataTemplate CreateTemplate_Immolator_MG()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'LWImmolator_MG');
	
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lwchemthrower';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///IRIClausImmolator.UI.Flamethrower_MG";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier=3;

	Template.RangeAccuracy = default.Flamethrower_rangemod;
	Template.BaseDamage = default.MG_FlameTHROWER_DAMAGE;
	Template.ExtraDamage = default.Flamethrower_SkillDamage_MG;
	Template.iSoundRange = default.FLAMETHROWER_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.FLAMETHROWER_IENVIRONMENTDAMAGE;
	Template.iClipSize = default.MG_FLAMETHROWER_ICLIPSIZE;
	Template.iRange = default.FLAMETHROWER_RANGE;
	Template.iRadius = default.FLAMETHROWER_RADIUS;
	Template.fCoverage = default.FlameTHROWER_TILE_COVERAGE_PERCENT;
	Template.BaseDamage.DamageType = 'Fire';
	
	Template.InfiniteAmmo = false;
	Template.PointsToComplete = 0;
	Template.DamageTypeTemplateName = 'Fire';
	Template.iTypicalActionCost = 2;
	Template.NumUpgradeSlots=default.Upgrades_MG;
	Template.iPhysicsImpulse = 5;
	//Template.bIsLargeWeapon = true;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	
	Template.GameArchetype = "IRIClausImmolator.Archetypes.WP_Immolator_MG_Arsenal";
	Template.bMergeAmmo = true;
	Template.bCanBeDodged = false;

	Template.Abilities.AddItem('MZFireThrower');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('MZFireThrowerOverwatchShot');

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Cannon';

	Template.CreatorTemplateName = 'Cannon_MG_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'LWImmolator_CV'; // Which item this will be upgraded from

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , default.FLAMETHROWER_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , default.FLAMETHROWER_RADIUS);

	Template.BonusWeaponEffects.AddItem(class'X2StatusEffects'.static.CreateBurningStatusEffect(default.Burn_Dmg_MG, default.Burn_Spread_MG));

	return Template;
}

static function X2DataTemplate CreateTemplate_Immolator_BM()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'LWImmolator_BM');
	
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lwchemthrower';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///IRIClausImmolator.UI.Flamethrower_BM";
	Template.EquipSound = "Beam_Weapon_Equip";
	Template.Tier = 5;

	Template.RangeAccuracy = default.Flamethrower_rangemod;
	Template.BaseDamage = default.BM_FlameTHROWER_DAMAGE;
	Template.ExtraDamage = default.Flamethrower_SkillDamage_BM;
	Template.iSoundRange = default.FLAMETHROWER_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.FLAMETHROWER_IENVIRONMENTDAMAGE;
	Template.iClipSize = default.BM_FLAMETHROWER_ICLIPSIZE;
	Template.iRange = default.FLAMETHROWER_RANGE;
	Template.iRadius = default.FLAMETHROWER_RADIUS;
	Template.fCoverage = default.FlameTHROWER_TILE_COVERAGE_PERCENT;
	Template.BaseDamage.DamageType = 'Fire';
	
	Template.InfiniteAmmo = false;
	Template.PointsToComplete = 0;
	Template.DamageTypeTemplateName = 'Fire';
	Template.iTypicalActionCost = 2;
	Template.NumUpgradeSlots=default.Upgrades_BM;
	Template.iPhysicsImpulse = 5;
	//Template.bIsLargeWeapon = true;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	
	Template.GameArchetype = "IRIClausImmolator.Archetypes.WP_Immolator_BM_Arsenal";
	Template.bMergeAmmo = true;
	Template.bCanBeDodged = false;

	Template.Abilities.AddItem('MZFireThrower');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('MZFireThrowerOverwatchShot');

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Cannon';

	Template.CreatorTemplateName = 'Cannon_BM_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'LWImmolator_MG'; // Which item this will be upgraded from

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , default.FLAMETHROWER_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , default.FLAMETHROWER_RADIUS);

	Template.BonusWeaponEffects.AddItem(class'X2StatusEffects'.static.CreateBurningStatusEffect(default.Burn_Dmg_BM, default.Burn_Spread_BM));

	return Template;
}


// **************************************************************************
// ***                  Canisters					                      ***
// *************************************************************************

static function X2WeaponTemplate FireCanister()
{
	local X2WeaponTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'LWFireCanister');

	Template.strImage = "img:///UILibrary_LWImmolator.icon_Flame";
	Template.EquipSound = "StrategyUI_Grenade_Equip";

	Template.GameArchetype = "WP_XCOMCanisterMKII.Archetype.WP_FireCanister";

	Template.Abilities.AddItem('LWFireCanister');
	Template.Abilities.AddItem('LWMatchingCanisterPassive');
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lwcanister';
	Template.WeaponTech = 'magnetic';
	Template.InventorySlot = eInvSlot_Pistol;
	Template.Tier = 2;
	Template.DamageTypeTemplateName = 'Fire';

	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Cannon';

	Template.PointsToComplete = 0;
	Template.TradingPostValue = default.FireCanister_Sell;
	Template.CanBeBuilt = true;

	//Template.bShouldCreateDifficultyVariants = true;

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventPurifier');
	Template.RewardDecks.AddItem('ExperimentalChemCanister');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.FireCanister_Buy;
	Template.Cost.ResourceCosts.AddItem(Resources);
	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = default.FireCanister_Alloy;
	Template.Cost.ResourceCosts.AddItem(Resources);
	Resources.ItemTemplateName = 'CorpseAdventPurifier';
	Resources.Quantity = default.FireCanister_Corpses;
	Template.Cost.ResourceCosts.AddItem(Resources);
	
	return Template;
}

static function X2WeaponTemplate PoisonCanister()
{
	local X2WeaponTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'LWPoisonCanister');

	Template.strImage = "img:///UILibrary_LWImmolator.icon_Poison";
	Template.EquipSound = "StrategyUI_Grenade_Equip";

	Template.GameArchetype = "WP_XCOMCanisterMKII.Archetype.WP_PoisonCanister";

	Template.Abilities.AddItem('LWPoisonCanister');
	Template.Abilities.AddItem('LWMatchingCanisterPassive');
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lwcanister';
	Template.WeaponTech = 'magnetic';
	Template.InventorySlot = eInvSlot_Pistol;
	Template.Tier = 2;
	Template.DamageTypeTemplateName = 'Poison';

	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Cannon';

	Template.PointsToComplete = 0;
	Template.TradingPostValue = default.PoisonCanister_Sell;
	Template.CanBeBuilt = true;

	//Template.bShouldCreateDifficultyVariants = true;

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyViper');
	Template.RewardDecks.AddItem('ExperimentalChemCanister');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.PoisonCanister_Buy;
	Template.Cost.ResourceCosts.AddItem(Resources);
	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = default.PoisonCanister_Alloy;
	Template.Cost.ResourceCosts.AddItem(Resources);
	Resources.ItemTemplateName = 'CorpseViper';
	Resources.Quantity = default.PoisonCanister_Corpses;
	Template.Cost.ResourceCosts.AddItem(Resources);
	
	return Template;
}

static function X2WeaponTemplate SmokeCanister()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'LWSmokeCanister');

	Template.strImage = "img:///UILibrary_LWImmolator.icon_Smoke";
	Template.EquipSound = "StrategyUI_Grenade_Equip";

	Template.GameArchetype = "WP_XCOMCanisterMKII.Archetype.WP_WhiteCanister";

	Template.Abilities.AddItem('LWSmokeCanister');
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lwcanister';
	Template.WeaponTech = 'conventional';
	Template.InventorySlot = eInvSlot_Pistol;
	Template.Tier = 0;
	//Template.DamageTypeTemplateName = 'Poison';

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	Template.StartingItem = true;

	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Cannon';
	
	return Template;
}

static function X2WeaponTemplate AcidCanister()
{
	local X2WeaponTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'LWAcidCanister');

	Template.strImage = "img:///UILibrary_LWImmolator.icon_Acid";
	Template.EquipSound = "StrategyUI_Grenade_Equip";

	Template.GameArchetype = "WP_XCOMCanisterMKII.Archetype.WP_AcidCanister";

	Template.Abilities.AddItem('LWAcidCanister');
	Template.Abilities.AddItem('LWMatchingCanisterPassive');
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lwcanister';
	Template.WeaponTech = 'magnetic';
	Template.InventorySlot = eInvSlot_Pistol;
	Template.Tier = 2;
	Template.DamageTypeTemplateName = 'Acid';

	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Cannon';

	Template.PointsToComplete = 0;
	Template.TradingPostValue = default.AcidCanister_Sell;
	Template.CanBeBuilt = true;

	//Template.bShouldCreateDifficultyVariants = true;

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyChryssalid');
	Template.RewardDecks.AddItem('ExperimentalChemCanister');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.AcidCanister_Buy;
	Template.Cost.ResourceCosts.AddItem(Resources);
	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = default.AcidCanister_Alloy;
	Template.Cost.ResourceCosts.AddItem(Resources);
	Resources.ItemTemplateName = 'CorpseChryssalid';
	Resources.Quantity = default.AcidCanister_Corpses;
	Template.Cost.ResourceCosts.AddItem(Resources);
	
	return Template;
}

static function X2WeaponTemplate CurseCanister()
{
	local X2WeaponTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'LWCurseCanister');

	Template.strImage = "img:///UILibrary_LWImmolator.icon_Psionic";
	Template.EquipSound = "StrategyUI_Grenade_Equip";

	Template.GameArchetype = "WP_XCOMCanisterMKII.Archetype.WP_CurseCanister";

	Template.Abilities.AddItem('LWCurseCanister');
	Template.Abilities.AddItem('LWMatchingCanisterPassive');
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lwcanister';
	Template.WeaponTech = 'beam';
	Template.InventorySlot = eInvSlot_Pistol;
	Template.Tier = 4;
	Template.DamageTypeTemplateName = 'Psi';

	Template.PointsToComplete = 0;
	Template.TradingPostValue = default.CurseCanister_Sell;
	Template.CanBeBuilt = true;

	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Cannon';

	//Template.bShouldCreateDifficultyVariants = true;

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyGatekeeper');
	Template.RewardDecks.AddItem('ExperimentalChemCanister');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.CurseCanister_Buy;
	Template.Cost.ResourceCosts.AddItem(Resources);
	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = default.CurseCanister_Elerium;
	Template.Cost.ResourceCosts.AddItem(Resources);
	Resources.ItemTemplateName = 'CorpseGatekeeper';
	Resources.Quantity = default.CurseCanister_Corpses;
	Template.Cost.ResourceCosts.AddItem(Resources);
	
	return Template;
}

static function X2WeaponTemplate IceCanister()
{
	local X2WeaponTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'LWIceCanister');

	Template.strImage = "img:///UILibrary_LWImmolator.icon_Frost";
	Template.EquipSound = "StrategyUI_Grenade_Equip";

	Template.GameArchetype = "WP_XCOMCanisterMKII.Archetype.WP_IceCanister";

	Template.Abilities.AddItem('LWIceCanister');
	Template.Abilities.AddItem('LWMatchingCanisterPassive');
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lwcanister';
	Template.WeaponTech = 'magnetic';
	Template.InventorySlot = eInvSlot_Pistol;
	Template.Tier = 2;
	Template.DamageTypeTemplateName = 'Frost';

	Template.PointsToComplete = 0;
	Template.TradingPostValue = default.IceCanister_Sell;
	Template.CanBeBuilt = false;

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('LWBitterFrostProtocolTech');

	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Cannon';

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.IceCanister_Buy;
	Template.Cost.ResourceCosts.AddItem(Resources);
	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = default.IceCanister_Alloy;
	Template.Cost.ResourceCosts.AddItem(Resources);
	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = default.IceCanister_Elerium;
	Template.Cost.ResourceCosts.AddItem(Resources);
	
	return Template;
}

static function X2WeaponTemplate BlastCanister()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'LWBlastCanister');

	Template.strImage = "img:///UILibrary_LWImmolator.icon_Blast";
	Template.EquipSound = "StrategyUI_Grenade_Equip";

	Template.GameArchetype = "WP_XCOMCanisterMKII.Archetype.WP_BlackCanister";

	Template.Abilities.AddItem('LWBlastCanister');
	Template.Abilities.AddItem('LWMatchingCanisterPassive');
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lwcanister';
	Template.WeaponTech = 'conventional';
	Template.InventorySlot = eInvSlot_Pistol;
	Template.Tier = 0;
	Template.DamageTypeTemplateName = 'Explosion';

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	Template.StartingItem = true;

	//Template.bShouldCreateDifficultyVariants = true;

	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Cannon';
	
	return Template;
}

static function X2WeaponTemplate BluescreenCanister()
{
	local X2WeaponTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'LWBluescreenCanister');

	Template.strImage = "img:///UILibrary_LWImmolator.icon_Electric";
	Template.EquipSound = "StrategyUI_Grenade_Equip";

	Template.GameArchetype = "WP_XCOMCanisterMKII.Archetype.WP_VoltCanister";

	Template.Abilities.AddItem('LWBluescreenCanister');
	Template.Abilities.AddItem('LWMatchingCanisterPassive');
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lwcanister';
	Template.WeaponTech = 'magnetic';
	Template.InventorySlot = eInvSlot_Pistol;
	Template.Tier = 2;
	Template.DamageTypeTemplateName = 'Electrical';

	Template.PointsToComplete = 0;
	Template.TradingPostValue = default.BluescreenCanister_Sell;
	Template.CanBeBuilt = true;

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('Bluescreen');
	Template.RewardDecks.AddItem('ExperimentalChemCanister');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.BluescreenCanister_Buy;
	Template.Cost.ResourceCosts.AddItem(Resources);
	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = default.BluescreenCanister_Alloy;
	Template.Cost.ResourceCosts.AddItem(Resources);
	Resources.ItemTemplateName = 'CorpseAdventMEC';
	Resources.Quantity = default.BluescreenCanister_Corpses;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Cannon';
	
	return Template;
}

static function X2WeaponTemplate MedicCanister()
{
	local X2WeaponTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'LWMedicCanister');

	Template.strImage = "img:///UILibrary_LWImmolator.icon_Medical";
	Template.EquipSound = "StrategyUI_Grenade_Equip";

	Template.GameArchetype = "WP_XCOMCanisterMKII.Archetype.WP_MedicCanister";

	Template.Abilities.AddItem('LWSmokeCanister');
	Template.Abilities.AddItem('LWMedicCanisterPassive');
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'lwcanister';
	Template.WeaponTech = 'magnetic';
	Template.InventorySlot = eInvSlot_Pistol;
	Template.Tier = 2;
	//Template.DamageTypeTemplateName = 'Poison';

	Template.PointsToComplete = 0;
	Template.TradingPostValue = default.MedicCanister_Sell;
	Template.CanBeBuilt = true;

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('BattlefieldMedicine');
	Template.RewardDecks.AddItem('ExperimentalChemCanister');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.MedicCanister_Buy;
	Template.Cost.ResourceCosts.AddItem(Resources);
	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = default.MedicCanister_Alloy;
	Template.Cost.ResourceCosts.AddItem(Resources);
	Resources.ItemTemplateName = 'EleriumDust';
	Resources.Quantity = default.MedicCanister_Elerium;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Cannon';
	
	return Template;
}