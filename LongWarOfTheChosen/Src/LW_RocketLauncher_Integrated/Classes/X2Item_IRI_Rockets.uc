class X2Item_IRI_Rockets extends X2Item;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(Create_NuclearMaterial());
	
	/*
	//Templates.AddItem(Create_Rocket_Standard());
	//Templates.AddItem(Create_Rocket_Plasma());
	//Templates.AddItem(Create_Rocket_Elerium());

	//Templates.AddItem(Create_Rocket_Standard_Pair());
	//Templates.AddItem(Create_Rocket_Plasma_Pair());
	//Templates.AddItem(Create_Rocket_Elerium_Pair());
	
	Templates.AddItem(Create_Rocket_Shredder());
	Templates.AddItem(Create_Rocket_Acid());

	Templates.AddItem(Create_Rocket_Flechette());
	Templates.AddItem(Create_Rocket_WhitePh());

	Templates.AddItem(Create_Rocket_Napalm());
	Templates.AddItem(Create_Rocket_Thermobaric());

	Templates.AddItem(Create_Rocket_Concussive());
	Templates.AddItem(Create_Rocket_Cryo());
	
	Templates.AddItem(Create_Rocket_Lockon());
	Templates.AddItem(Create_Rocket_Javelin());

	Templates.AddItem(Create_Rocket_APFSDS());
	Templates.AddItem(Create_Rocket_PlasmaEjector());

	Templates.AddItem(Create_Rocket_Nuke());
	Templates.AddItem(Create_Rocket_BlackHole());*/
	
	return Templates;
}

static function X2DataTemplate Create_NuclearMaterial()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'IRI_NuclearMaterial');

	Template.ItemCat = 'resource';
	Template.strImage = "img:///IRI_RocketNuke.UI.Inv_Nuclear_Material";

	Template.HideInInventory = false;
	Template.HideInLootRecovered = false;

	Template.TradingPostValue = 250;

	return Template;
}


static function X2DataTemplate Create_Rocket_Standard()
{
	local X2RocketTemplate Template;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
	local X2Effect_Knockback KnockbackEffect;

	`CREATE_X2TEMPLATE(class'X2RocketTemplate', Template, 'IRI_Rocket_Standard');

	Template.strImage = "img:///IRI_RocketLaunchers.UI.Inv_Rocket_Standard";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.iRange = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RANGE + 10;
	Template.iRadius = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RADIUS + 1;

	Template.BaseDamage = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_BASEDAMAGE;
	Template.iSoundRange = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_TRADINGPOSTVALUE;
	Template.iClipSize = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ICLIPSIZE;
	Template.DamageTypeTemplateName = 'Explosion';
	Template.Tier = 0;

	Template.Abilities.AddItem('GrenadeFuse');
	Template.Abilities.AddItem('IRI_FireRocket');
	//Template.Abilities.AddItem('IRI_RocketMobilityPenalty');
	//Template.Abilities.AddItem('IRI_GiveRocket');

	Template.MobilityPenalty = 1.0f;

	Template.GameArchetype = "IRI_RocketLaunchers.Archetypes.WP_Rocket_Standard";

	Template.iPhysicsImpulse = 10;
	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);

	//Template.HideIfResearched = 'PlasmaGrenade';
	Template.OnThrowBarkSoundCue = 'RocketLauncher';

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.ThrownGrenadeEffects.AddItem(KnockbackEffect);

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RADIUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_BASEDAMAGE.Shred);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, , -Template.MobilityPenalty);

	Template.PairedTemplateName = 'IRI_Rocket_Standard_Pair';

	return Template;
}

static function X2DataTemplate Create_Rocket_Standard_Pair()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'IRI_Rocket_Standard_Pair');

	Template.GameArchetype = "IRI_RocketLaunchers.Archetypes.WP_Rocket_Standard";
	Template.ItemCat = 'cosmetic_rocket';
	Template.WeaponCat = 'rocket';

	return Template;
}
static function X2DataTemplate Create_Rocket_Plasma()
{
	local X2RocketTemplate Template;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
	local X2Effect_Knockback KnockbackEffect;

	`CREATE_X2TEMPLATE(class'X2RocketTemplate', Template, 'IRI_Rocket_Plasma');

	Template.strImage = "img:///IRI_RocketLaunchers.UI.Inv_Rocket_Plasma";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.iRange = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RANGE + 10;
	Template.iRadius = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RADIUS + 2;

	Template.BaseDamage = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_BASEDAMAGE;
	Template.iSoundRange = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_TRADINGPOSTVALUE;
	Template.iClipSize = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ICLIPSIZE;
	Template.DamageTypeTemplateName = 'Explosion';
	Template.Tier = 1;

	Template.Abilities.AddItem('GrenadeFuse');
	Template.Abilities.AddItem('IRI_FireRocket');
	//Template.Abilities.AddItem('IRI_DisplayRocket');
	//Template.Abilities.AddItem('IRI_RocketMobilityPenalty');
	//Template.Abilities.AddItem('IRI_GiveRocket');

	Template.MobilityPenalty = 1.0f;
	//Template.CustomID = 7;

	Template.GameArchetype = "IRI_RocketLaunchers.Archetypes.WP_Rocket_Plasma";

	Template.iPhysicsImpulse = 10;
	//Template.StowedLocation = eSlot_None;
	//Template.StowedLocation = eSlot_RearBackPack;
	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);
	//Template.LaunchedGrenadeEffects.AddItem(WeaponDamageEffect);

	//Template.HideIfResearched = 'PlasmaGrenade';
	Template.OnThrowBarkSoundCue = 'RocketLauncher';
	//Template.OnThrowBarkSoundCue = 'ThrowGrenade';

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.ThrownGrenadeEffects.AddItem(KnockbackEffect);
	//Template.LaunchedGrenadeEffects.AddItem(KnockbackEffect);

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RADIUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_BASEDAMAGE.Shred);

	Template.PairedTemplateName = 'IRI_Rocket_Plasma_Pair';

	return Template;
}

static function X2DataTemplate Create_Rocket_Plasma_Pair()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'IRI_Rocket_Plasma_Pair');
	
	Template.GameArchetype = "IRI_RocketLaunchers.Archetypes.WP_Rocket_Plasma";
	Template.ItemCat = 'cosmetic_rocket';
	Template.WeaponCat = 'rocket';

	return Template;
}

static function X2DataTemplate Create_Rocket_Elerium()
{
	local X2RocketTemplate Template;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
	local X2Effect_Knockback KnockbackEffect;

	`CREATE_X2TEMPLATE(class'X2RocketTemplate', Template, 'IRI_Rocket_Elerium');

	Template.strImage = "img:///IRI_RocketLaunchers.UI.Inv_Rocket_Elerium";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.iRange = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RANGE + 10;
	Template.iRadius = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RADIUS + 3;

	Template.BaseDamage = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_BASEDAMAGE;
	Template.iSoundRange = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_TRADINGPOSTVALUE;
	Template.iClipSize = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ICLIPSIZE;
	Template.DamageTypeTemplateName = 'Explosion';
	Template.Tier = 3;

	Template.Abilities.AddItem('GrenadeFuse');
	Template.Abilities.AddItem('IRI_FireRocket');
	//Template.Abilities.AddItem('IRI_DisplayRocket');
	Template.Abilities.AddItem('IRI_MobilityPenalty');
	//Template.Abilities.AddItem('IRI_GiveRocket');

	Template.MobilityPenalty = 1.0f;
	//Template.CustomID = 8;

	Template.GameArchetype = "IRI_RocketLaunchers.Archetypes.WP_Rocket_Elerium";

	Template.iPhysicsImpulse = 10;
	//Template.StowedLocation = eSlot_None;
	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);
	//Template.LaunchedGrenadeEffects.AddItem(WeaponDamageEffect);

	//Template.HideIfResearched = 'PlasmaGrenade';
	Template.OnThrowBarkSoundCue = 'RocketLauncher';
	//Template.OnThrowBarkSoundCue = 'ThrowGrenade';

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.ThrownGrenadeEffects.AddItem(KnockbackEffect);
	//Template.LaunchedGrenadeEffects.AddItem(KnockbackEffect);

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RADIUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_BASEDAMAGE.Shred);

	Template.PairedTemplateName = 'IRI_Rocket_Elerium_Pair';

	return Template;
}

static function X2DataTemplate Create_Rocket_Elerium_Pair()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'IRI_Rocket_Elerium_Pair');

	Template.GameArchetype = "IRI_RocketLaunchers.Archetypes.WP_Rocket_Elerium";
	Template.ItemCat = 'cosmetic_rocket';
	Template.WeaponCat = 'rocket';

	return Template;
}

static function X2DataTemplate Create_Rocket_Shredder()
{
	local X2RocketTemplate Template;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
	local X2Effect_Knockback KnockbackEffect;

	`CREATE_X2TEMPLATE(class'X2RocketTemplate', Template, 'IRI_Rocket_Shredder');

	Template.strImage = "img:///IRI_RocketLaunchers.UI.Inv_Rocket_Shredder";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.iRange = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RANGE + 10;
	Template.iRadius = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RADIUS + 1;

	Template.BaseDamage = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_BASEDAMAGE;
	Template.iSoundRange = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_TRADINGPOSTVALUE;
	Template.iClipSize = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ICLIPSIZE;
	Template.DamageTypeTemplateName = 'Explosion';
	Template.Tier = 0;

	Template.Abilities.AddItem('GrenadeFuse');
	Template.Abilities.AddItem('IRI_FireRocket');
	Template.Abilities.AddItem('IRI_DisplayRocket');
	Template.Abilities.AddItem('IRI_MobilityPenalty');
	//Template.Abilities.AddItem('IRI_GiveRocket');

	Template.MobilityPenalty = 1.0f;
	//Template.CustomID = 3;

	Template.GameArchetype = "IRI_RocketLaunchers.Archetypes.WP_Rocket_Shredder";

	Template.iPhysicsImpulse = 10;
	//Template.StowedLocation = eSlot_None;
	//Template.StowedLocation = eSlot_RearBackPack;
	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	WeaponDamageEffect.EffectDamageValue.Rupture = 3;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);
	//Template.LaunchedGrenadeEffects.AddItem(WeaponDamageEffect);

	//Template.HideIfResearched = 'PlasmaGrenade';
	Template.OnThrowBarkSoundCue = 'RocketLauncher';
	//Template.OnThrowBarkSoundCue = 'ThrowGrenade';

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.ThrownGrenadeEffects.AddItem(KnockbackEffect);
	//Template.LaunchedGrenadeEffects.AddItem(KnockbackEffect);

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RADIUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_BASEDAMAGE.Shred);

	return Template;
}

static function X2DataTemplate Create_Rocket_Acid()
{
	local X2RocketTemplate Template;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
	local X2Effect_Knockback KnockbackEffect;

	`CREATE_X2TEMPLATE(class'X2RocketTemplate', Template, 'IRI_Rocket_Acid');

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Frag_Grenade";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.iRange = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RANGE + 10;
	Template.iRadius = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RADIUS + 2;

	Template.BaseDamage = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_BASEDAMAGE;
	Template.iSoundRange = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_TRADINGPOSTVALUE;
	Template.iClipSize = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ICLIPSIZE;
	Template.DamageTypeTemplateName = 'Explosion';
	Template.Tier = 0;

	Template.Abilities.AddItem('GrenadeFuse');
	Template.Abilities.AddItem('IRI_FireRocket');
	Template.Abilities.AddItem('IRI_DisplayRocket');
	Template.Abilities.AddItem('IRI_MobilityPenalty');
	//Template.Abilities.AddItem('IRI_GiveRocket');

	Template.MobilityPenalty = 1.0f;
	//Template.CustomID = 3;

	Template.GameArchetype = "IRI_RocketLaunchers.Archetypes.WP_Rocket_Acid";

	Template.iPhysicsImpulse = 10;
	//Template.StowedLocation = eSlot_None;
	//Template.StowedLocation = eSlot_RearBackPack;
	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	WeaponDamageEffect.EffectDamageValue.Rupture = 3;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);
	//Template.LaunchedGrenadeEffects.AddItem(WeaponDamageEffect);

	Template.ThrownGrenadeEffects.AddItem(class'X2StatusEffects'.static.CreateAcidBurningStatusEffect(2,1));
	Template.ThrownGrenadeEffects.AddItem(new class'X2Effect_ApplyAcidToWorld');
	//Template.HideIfResearched = 'PlasmaGrenade';
	Template.OnThrowBarkSoundCue = 'RocketLauncher';
	//Template.OnThrowBarkSoundCue = 'ThrowGrenade';

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.ThrownGrenadeEffects.AddItem(KnockbackEffect);
	//Template.LaunchedGrenadeEffects.AddItem(KnockbackEffect);

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RADIUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_BASEDAMAGE.Shred);

	return Template;
}

static function X2DataTemplate Create_Rocket_Flechette()
{
	local X2RocketTemplate Template;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
	local X2Effect_Knockback KnockbackEffect;

	`CREATE_X2TEMPLATE(class'X2RocketTemplate', Template, 'IRI_Rocket_Flechette');

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Frag_Grenade";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.iRange = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RANGE + 10;
	Template.iRadius = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RADIUS + 2;

	Template.BaseDamage = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_BASEDAMAGE;
	Template.iSoundRange = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_TRADINGPOSTVALUE;
	Template.iClipSize = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ICLIPSIZE;
	Template.DamageTypeTemplateName = 'Explosion';
	Template.Tier = 0;

	Template.Abilities.AddItem('GrenadeFuse');
	Template.Abilities.AddItem('IRI_FireRocket');
	Template.Abilities.AddItem('IRI_DisplayRocket');
	Template.Abilities.AddItem('IRI_MobilityPenalty');
	//Template.Abilities.AddItem('IRI_GiveRocket');

	Template.MobilityPenalty = 1.0f;

	Template.GameArchetype = "IRI_RocketLaunchers.Archetypes.WP_Rocket_Flechette";

	Template.iPhysicsImpulse = 10;
	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	//Template.bIgnoreRadialBlockingCover = false;	//what does it do?

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);

	Template.OnThrowBarkSoundCue = 'RocketLauncher';

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.ThrownGrenadeEffects.AddItem(KnockbackEffect);

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RADIUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_BASEDAMAGE.Shred);

	return Template;
}

static function X2DataTemplate Create_Rocket_WhitePh()
{
	local X2RocketTemplate				Template;
	local X2Effect_ApplyWeaponDamage	WeaponDamageEffect;
	local X2Effect_Knockback			KnockbackEffect;
	//local X2Effect_ApplyFireToWorld		FireEffect;
	local X2Effect_ApplyPoisonToWorld	PoisonEffect;

	`CREATE_X2TEMPLATE(class'X2RocketTemplate', Template, 'IRI_Rocket_WhitePh');

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Frag_Grenade";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.iRange = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RANGE + 10;
	Template.iRadius = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RADIUS + 3;

	Template.BaseDamage = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_BASEDAMAGE;
	Template.iSoundRange = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_TRADINGPOSTVALUE;
	Template.iClipSize = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ICLIPSIZE;
	Template.DamageTypeTemplateName = 'Explosion';
	Template.Tier = 0;

	Template.Abilities.AddItem('GrenadeFuse');
	Template.Abilities.AddItem('IRI_FireRocket');
	Template.Abilities.AddItem('IRI_DisplayRocket');
	Template.Abilities.AddItem('IRI_MobilityPenalty');
	//Template.Abilities.AddItem('IRI_GiveRocket');

	Template.MobilityPenalty = 1.0f;

	Template.GameArchetype = "IRI_RocketLaunchers.Archetypes.WP_Rocket_WhitePh";

	Template.iPhysicsImpulse = 10;
	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);

	/*
	FireEffect = new class'X2Effect_ApplyFireToWorld';
	FireEffect.bUseFireChanceLevel = true;
	FireEffect.FireChance_Level1 = 0.10f;
	FireEffect.FireChance_Level2 = 0;
	FireEffect.FireChance_Level3 = 0;
	Template.ThrownGrenadeEffects.AddItem(FireEffect);*/
	Template.ThrownGrenadeEffects.AddItem(class'X2StatusEffects'.static.CreateBurningStatusEffect(2, 1));

	PoisonEffect = new class'X2Effect_ApplyPoisonToWorld';
	Template.ThrownGrenadeEffects.AddItem(PoisonEffect);
	Template.ThrownGrenadeEffects.AddItem(class'X2StatusEffects'.static.CreatePoisonedStatusEffect());

	Template.OnThrowBarkSoundCue = 'RocketLauncher';

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.ThrownGrenadeEffects.AddItem(KnockbackEffect);
	
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RADIUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_BASEDAMAGE.Shred);

	return Template;
}

static function X2DataTemplate Create_Rocket_Napalm()
{
	local X2RocketTemplate				Template;
	local X2Effect_ApplyWeaponDamage	WeaponDamageEffect;
	//local X2Effect_Knockback			KnockbackEffect;

	`CREATE_X2TEMPLATE(class'X2RocketTemplate', Template, 'IRI_Rocket_Napalm');

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Frag_Grenade";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.iRange = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RANGE + 10;
	Template.iRadius = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RADIUS + 1;

	Template.BaseDamage = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_BASEDAMAGE;
	//MOLOTOV_BASEDAMAGE=(Damage=2, Spread = 1, PlusOne = 0, Crit = 0, Pierce = 1, Shred=0, Tag = "", DamageType="Fire")
	Template.iSoundRange = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_TRADINGPOSTVALUE;
	Template.iClipSize = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ICLIPSIZE;
	Template.DamageTypeTemplateName = 'Explosion';
	Template.Tier = 0;

	Template.Abilities.AddItem('GrenadeFuse');
	Template.Abilities.AddItem('IRI_FireRocket');
	Template.Abilities.AddItem('IRI_DisplayRocket');
	Template.Abilities.AddItem('IRI_MobilityPenalty');
	//Template.Abilities.AddItem('IRI_GiveRocket');

	Template.MobilityPenalty = 1.0f;

	Template.GameArchetype = "IRI_RocketLaunchers.Archetypes.WP_Rocket_Napalm";

	Template.iPhysicsImpulse = 10;
	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;

	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);
	Template.ThrownGrenadeEffects.AddItem(new class'X2Effect_ApplyFireToWorld');
	Template.ThrownGrenadeEffects.AddItem(class'X2StatusEffects'.static.CreateBurningStatusEffect(2, 1));

	Template.OnThrowBarkSoundCue = 'RocketLauncher';

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RADIUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_BASEDAMAGE.Shred);

	return Template;
}

static function X2DataTemplate Create_Rocket_Thermobaric()
{
	local X2RocketTemplate				Template;
	local X2Effect_ApplyWeaponDamage	WeaponDamageEffect;
	//local X2Effect_Knockback			KnockbackEffect;

	`CREATE_X2TEMPLATE(class'X2RocketTemplate', Template, 'IRI_Rocket_Thermobaric');

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Frag_Grenade";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.iRange = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RANGE + 10;
	Template.iRadius = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RADIUS + 2;

	Template.BaseDamage = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_BASEDAMAGE;
	//MOLOTOV_BASEDAMAGE=(Damage=2, Spread = 1, PlusOne = 0, Crit = 0, Pierce = 1, Shred=0, Tag = "", DamageType="Fire")
	Template.iSoundRange = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_TRADINGPOSTVALUE;
	Template.iClipSize = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ICLIPSIZE;
	Template.DamageTypeTemplateName = 'Explosion';
	Template.Tier = 0;

	Template.Abilities.AddItem('GrenadeFuse');
	Template.Abilities.AddItem('IRI_FireRocket');
	Template.Abilities.AddItem('IRI_DisplayRocket');
	Template.Abilities.AddItem('IRI_MobilityPenalty');
	//Template.Abilities.AddItem('IRI_GiveRocket');

	Template.MobilityPenalty = 1.0f;

	Template.GameArchetype = "IRI_RocketLaunchers.Archetypes.WP_Rocket_Thermobaric";

	Template.iPhysicsImpulse = 10;
	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);
	Template.ThrownGrenadeEffects.AddItem(new class'X2Effect_ApplyFireToWorld');
	Template.ThrownGrenadeEffects.AddItem(class'X2StatusEffects'.static.CreateBurningStatusEffect(2, 1));

	Template.OnThrowBarkSoundCue = 'RocketLauncher';

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RADIUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_BASEDAMAGE.Shred);

	return Template;
}
static function X2DataTemplate Create_Rocket_Concussive()
{
	local X2RocketTemplate						Template;
	local X2Effect_ApplyWeaponDamage			WeaponDamageEffect;
	local X2Effect_Knockback					KnockbackEffect;
	//local X2Effect_ImmediateAbilityActivation	ImpairingAbilityEffect;

	`CREATE_X2TEMPLATE(class'X2RocketTemplate', Template, 'IRI_Rocket_Concussive');

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Frag_Grenade";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.iRange = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RANGE + 10;
	Template.iRadius = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RADIUS + 2;

	Template.BaseDamage = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_BASEDAMAGE;
	Template.iSoundRange = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_TRADINGPOSTVALUE;
	Template.iClipSize = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ICLIPSIZE;
	Template.DamageTypeTemplateName = 'Explosion';
	Template.Tier = 1;

	Template.Abilities.AddItem('GrenadeFuse');
	Template.Abilities.AddItem('IRI_FireRocket');
	Template.Abilities.AddItem('IRI_DisplayRocket');
	Template.Abilities.AddItem('IRI_MobilityPenalty');
	//Template.Abilities.AddItem('IRI_GiveRocket');

	Template.MobilityPenalty = 1.0f;
	//Template.CustomID = 7;

	Template.GameArchetype = "IRI_RocketLaunchers.Archetypes.WP_Rocket_Concussive";

	Template.iPhysicsImpulse = 10;
	//Template.StowedLocation = eSlot_None;
	//Template.StowedLocation = eSlot_RearBackPack;
	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.ThrownGrenadeEffects.AddItem(class'X2StatusEffects'.static.CreateDisorientedStatusEffect(, , false));
	Template.ThrownGrenadeEffects.AddItem(class'X2StatusEffects'.static.CreateStunnedStatusEffect(1, 100, false));
	Template.ThrownGrenadeEffects.AddItem(class'X2StatusEffects'.static.CreateUnconsciousStatusEffect());

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);
	//Template.LaunchedGrenadeEffects.AddItem(WeaponDamageEffect);

	//Template.HideIfResearched = 'PlasmaGrenade';
	Template.OnThrowBarkSoundCue = 'RocketLauncher';
	//Template.OnThrowBarkSoundCue = 'ThrowGrenade';

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.ThrownGrenadeEffects.AddItem(KnockbackEffect);
	//Template.LaunchedGrenadeEffects.AddItem(KnockbackEffect);

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RADIUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_BASEDAMAGE.Shred);

	return Template;
}

static function X2DataTemplate Create_Rocket_Cryo()
{
	local X2RocketTemplate						Template;
	local X2Effect_ApplyWeaponDamage			WeaponDamageEffect;
	local X2Effect_DLC_Day60Freeze				FreezeEffect;

	`CREATE_X2TEMPLATE(class'X2RocketTemplate', Template, 'IRI_Rocket_Cryo');

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Frag_Grenade";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.iRange = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RANGE + 10;
	Template.iRadius = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RADIUS + 2;
	//FROSTBOMB_BASEDAMAGE = (Damage = 0, Spread = 0, PlusOne = 0, Crit = 0, Pierce = 0, Shred=0, Tag = "", DamageType="Frost")
	Template.BaseDamage = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_BASEDAMAGE;
	Template.iSoundRange = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_TRADINGPOSTVALUE;
	Template.iClipSize = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ICLIPSIZE;
	Template.DamageTypeTemplateName = 'Explosion';
	Template.Tier = 1;

	Template.Abilities.AddItem('GrenadeFuse');
	Template.Abilities.AddItem('IRI_FireRocket');
	Template.Abilities.AddItem('IRI_DisplayRocket');
	Template.Abilities.AddItem('IRI_MobilityPenalty');
	//Template.Abilities.AddItem('IRI_GiveRocket');

	Template.MobilityPenalty = 1.0f;

	Template.GameArchetype = "IRI_RocketLaunchers.Archetypes.WP_Rocket_Cryo";

	Template.iPhysicsImpulse = 10;
	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	FreezeEffect = class'X2Effect_DLC_Day60Freeze'.static.CreateFreezeEffect(1, 3);
	FreezeEffect.bApplyRulerModifiers = true;
	Template.ThrownGrenadeEffects.AddItem(FreezeEffect);
	Template.ThrownGrenadeEffects.AddItem(class'X2Effect_DLC_Day60Freeze'.static.CreateFreezeRemoveEffects());

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);

	Template.OnThrowBarkSoundCue = 'RocketLauncher';

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RADIUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_BASEDAMAGE.Shred);

	return Template;
}

static function X2DataTemplate Create_Rocket_Lockon()
{
	local X2RocketTemplate Template;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
	local X2Effect_Knockback KnockbackEffect;

	`CREATE_X2TEMPLATE(class'X2RocketTemplate', Template, 'IRI_Rocket_Lockon');

	Template.strImage = "img:///IRI_RocketLaunchers.UI.Inv_Rocket_Lockon";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.iRange = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RANGE + 10;
	Template.iRadius = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RADIUS;

	Template.BaseDamage = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_BASEDAMAGE;
	Template.iSoundRange = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_TRADINGPOSTVALUE;
	Template.iClipSize = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ICLIPSIZE;
	Template.DamageTypeTemplateName = 'Explosion';
	Template.Tier = 0;

	Template.Abilities.AddItem('GrenadeFuse');
	Template.Abilities.AddItem('IRI_FireLockon');
	Template.Abilities.AddItem('IRI_DisplayRocket');
	Template.Abilities.AddItem('IRI_MobilityPenalty');
	//Template.Abilities.AddItem('IRI_GiveRocket');

	Template.MobilityPenalty = 1.0f;

	Template.GameArchetype = "IRI_RocketLaunchers.Archetypes.WP_Rocket_Lockon";

	Template.iPhysicsImpulse = 10;
	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);

	Template.OnThrowBarkSoundCue = 'RocketLauncher';

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.ThrownGrenadeEffects.AddItem(KnockbackEffect);

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RADIUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_BASEDAMAGE.Shred);

	return Template;
}

static function X2DataTemplate Create_Rocket_Javelin()
{
	local X2RocketTemplate Template;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
	local X2Effect_Knockback KnockbackEffect;

	`CREATE_X2TEMPLATE(class'X2RocketTemplate', Template, 'IRI_Rocket_Javelin');

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Frag_Grenade";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.iRange = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RANGE + 10;
	Template.iRadius = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RADIUS + 1;

	Template.BaseDamage = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_BASEDAMAGE;
	Template.iSoundRange = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_TRADINGPOSTVALUE;
	Template.iClipSize = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ICLIPSIZE;
	Template.DamageTypeTemplateName = 'Explosion';
	Template.Tier = 0;

	Template.Abilities.AddItem('GrenadeFuse');
	Template.Abilities.AddItem('IRI_FireJavelin');
	Template.Abilities.AddItem('IRI_DisplayRocket');
	Template.Abilities.AddItem('IRI_MobilityPenalty');
	//Template.Abilities.AddItem('IRI_GiveRocket');

	/*	Template.WeaponPrecomputedPathData.InitialPathTime = 1.5;
	Template.WeaponPrecomputedPathData.MaxPathTime = 2.5;
	Template.WeaponPrecomputedPathData.MaxNumberOfBounces = 0;*/

	Template.WeaponPrecomputedPathData.InitialPathTime = 3.5;
	Template.WeaponPrecomputedPathData.MaxPathTime = 5.0;
	Template.WeaponPrecomputedPathData.MaxNumberOfBounces = 0;

	Template.MobilityPenalty = 1.0f;

	Template.GameArchetype = "IRI_RocketLaunchers.Archetypes.WP_Rocket_Javelin";

	Template.iPhysicsImpulse = 10;
	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);

	Template.OnThrowBarkSoundCue = 'RocketLauncher';

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.ThrownGrenadeEffects.AddItem(KnockbackEffect);

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RADIUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_BASEDAMAGE.Shred);

	return Template;
}

static function X2DataTemplate Create_Rocket_APFSDS()
{
	local X2RocketTemplate Template;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
	local X2Effect_Knockback KnockbackEffect;

	`CREATE_X2TEMPLATE(class'X2RocketTemplate', Template, 'IRI_Rocket_APFSDS');

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Frag_Grenade";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.iRange = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RANGE + 10;
	Template.iRadius = 1;

	Template.BaseDamage = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_BASEDAMAGE;
	Template.iSoundRange = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_TRADINGPOSTVALUE;
	Template.iClipSize = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ICLIPSIZE;
	Template.DamageTypeTemplateName = 'Explosion';
	Template.Tier = 0;

	Template.Abilities.AddItem('GrenadeFuse');
	Template.Abilities.AddItem('IRI_FireLockon');
	Template.Abilities.AddItem('IRI_DisplayRocket');
	Template.Abilities.AddItem('IRI_MobilityPenalty');
	//Template.Abilities.AddItem('IRI_GiveRocket');

	Template.MobilityPenalty = 1.0f;

	Template.GameArchetype = "IRI_RocketLaunchers.Archetypes.WP_Rocket_APFSDS";

	Template.iPhysicsImpulse = 10;
	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);

	Template.OnThrowBarkSoundCue = 'RocketLauncher';

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.ThrownGrenadeEffects.AddItem(KnockbackEffect);

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RADIUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_BASEDAMAGE.Shred);

	return Template;
}

static function X2DataTemplate Create_Rocket_PlasmaEjector()
{
	local X2RocketTemplate Template;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
	local X2Effect_Knockback KnockbackEffect;

	`CREATE_X2TEMPLATE(class'X2RocketTemplate', Template, 'IRI_Rocket_PlasmaEjector');

	Template.strImage = "img:///IRI_RocketLaunchers.UI.Inv_Plasma_Ejector";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.iRange = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RANGE + 10;
	Template.iRadius = 1;

	Template.BaseDamage = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_BASEDAMAGE;
	Template.iSoundRange = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_TRADINGPOSTVALUE;
	Template.iClipSize = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ICLIPSIZE;
	Template.DamageTypeTemplateName = 'Explosion';
	Template.Tier = 0;

	Template.Abilities.AddItem('GrenadeFuse');
	Template.Abilities.AddItem('IRI_FireLockon');
	Template.Abilities.AddItem('IRI_DisplayRocket');
	Template.Abilities.AddItem('IRI_MobilityPenalty');
	//Template.Abilities.AddItem('IRI_GiveRocket');

	Template.MobilityPenalty = 1.0f;

	Template.GameArchetype = "IRI_RocketLaunchers.Archetypes.WP_Rocket_PlasmaEjector";

	Template.iPhysicsImpulse = 10;
	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);

	Template.OnThrowBarkSoundCue = 'RocketLauncher';

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.ThrownGrenadeEffects.AddItem(KnockbackEffect);

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RADIUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_BASEDAMAGE.Shred);

	return Template;
}

static function X2DataTemplate Create_Rocket_BlackHole()
{
	local X2RocketTemplate Template;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
	local X2Effect_Knockback KnockbackEffect;

	`CREATE_X2TEMPLATE(class'X2RocketTemplate', Template, 'IRI_Rocket_BlackHole');

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Frag_Grenade";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.iRange = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RANGE + 10;
	Template.iRadius = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RADIUS + 3;

	Template.BaseDamage = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_BASEDAMAGE;
	Template.iSoundRange = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_TRADINGPOSTVALUE;
	Template.iClipSize = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ICLIPSIZE;
	Template.DamageTypeTemplateName = 'Explosion';
	Template.Tier = 0;

	Template.Abilities.AddItem('GrenadeFuse');
	Template.Abilities.AddItem('IRI_FireRocket');
	Template.Abilities.AddItem('IRI_DisplayRocket');
	Template.Abilities.AddItem('IRI_MobilityPenalty');
	//Template.Abilities.AddItem('IRI_GiveRocket');

	Template.MobilityPenalty = 1.0f;
	//Template.CustomID = 6;

	Template.GameArchetype = "IRI_RocketLaunchers.Archetypes.WP_Rocket_BlackHole";

	Template.iPhysicsImpulse = 10;
	//Template.StowedLocation = eSlot_None;
	//Template.StowedLocation = eSlot_RearBackPack;
	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	WeaponDamageEffect.EffectDamageValue.Rupture = 3;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);
	//Template.LaunchedGrenadeEffects.AddItem(WeaponDamageEffect);

	//Template.HideIfResearched = 'PlasmaGrenade';
	Template.OnThrowBarkSoundCue = 'RocketLauncher';
	//Template.OnThrowBarkSoundCue = 'ThrowGrenade';

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.ThrownGrenadeEffects.AddItem(KnockbackEffect);
	//Template.LaunchedGrenadeEffects.AddItem(KnockbackEffect);

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RADIUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_BASEDAMAGE.Shred);

	return Template;
}

static function X2DataTemplate Create_Rocket_Nuke()
{
	local X2RocketTemplate Template;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
	local X2Effect_Knockback KnockbackEffect;

	`CREATE_X2TEMPLATE(class'X2RocketTemplate', Template, 'IRI_Rocket_Nuke');

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Frag_Grenade";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.iRange = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RANGE + 10;
	Template.iRadius = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RADIUS + 8;

	Template.BaseDamage = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_BASEDAMAGE;
	Template.iSoundRange = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_TRADINGPOSTVALUE;
	Template.iClipSize = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ICLIPSIZE;
	Template.DamageTypeTemplateName = 'Explosion';
	Template.Tier = 0;

	Template.Abilities.AddItem('GrenadeFuse');
	Template.Abilities.AddItem('IRI_FireRocket');
	Template.Abilities.AddItem('IRI_DisplayRocket');
	Template.Abilities.AddItem('IRI_MobilityPenalty');
	//Template.Abilities.AddItem('IRI_GiveRocket');

	Template.MobilityPenalty = 1.0f;
	//Template.CustomID = 4;

	Template.GameArchetype = "IRI_RocketLaunchers.Archetypes.WP_Rocket_Nuke";

	Template.iPhysicsImpulse = 10;
	//Template.StowedLocation = eSlot_None;
	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);
	Template.ThrownGrenadeEffects.AddItem(new class'X2Effect_ApplyFireToWorld');
	Template.ThrownGrenadeEffects.AddItem(class'X2StatusEffects'.static.CreateBurningStatusEffect(2, 1));

	//Template.HideIfResearched = 'PlasmaGrenade';
	Template.OnThrowBarkSoundCue = 'RocketLauncher';
	//Template.OnThrowBarkSoundCue = 'ThrowGrenade';

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.ThrownGrenadeEffects.AddItem(KnockbackEffect);
	//Template.LaunchedGrenadeEffects.AddItem(KnockbackEffect);

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RADIUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel, , class'X2Item_DefaultGrenades'.default.FRAGGRENADE_BASEDAMAGE.Shred);

	return Template;
}


/*
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2AbilityTarget_IRI_Rocket		CursorTarget;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2Condition_AbilitySourceWeapon   GrenadeCondition;
	local X2Condition_IRI_HasOneAbilityFromList	HasAbilityCondition;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2Condition_UnitEffects			SuppressedCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IRI_FireRocketLauncher');

	//	Ability icon
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_firerocket";
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_AmmoCost');
	Template.HideErrors.AddItem('AA_AbilityUnavailable');

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_GRENADE_PRIORITY - 1;

	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;
	Template.bHideOnClassUnlock = true;

	Template.bUseAmmoAsChargesForHUD = true;
	Template.DamagePreviewFn = class'X2Ability_Grenades'.static.GrenadeDamagePreview;
	
	//	Ability costs
	AddTypicalAbilityCost(Template);

	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
		
	//	Targeting and Triggering
	Template.TargetingMethod = class'X2TargetingMethod_IRI_RocketLauncher';

	CursorTarget = new class'X2AbilityTarget_IRI_Rocket';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	//StandardAim.bGuaranteedHit = true;	//	not necessary wtih indirect hit
	StandardAim.bIndirectFire = true;
	Template.AbilityToHitCalc = StandardAim;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bUseWeaponRadius = true;
	RadiusMultiTarget.bUseWeaponBlockingCoverFlag = true;
	RadiusMultiTarget.fTargetRadius = - 24.0f * class'XComWorldData'.const.WORLD_UNITS_TO_METERS_MULTIPLIER;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	//	Shooter conditions
	//	Can be used only by soldiers that have the Heavy Armaments perk (dummy squaddie perk for technicals)
	HasAbilityCondition = new class'X2Condition_IRI_HasOneAbilityFromList';
	HasAbilityCondition.AbilityNames.AddItem('HeavyArmaments');
	//	ShockAndAwe is included into LW2 Secondary Weapons mod, it grants +1 Rockets (to 1 that's alreeady there by default).
	//	RPGO changes the default number of rockets to 0 and makes ShockAndAwe a starting Rocketeer perk.
	HasAbilityCondition.AbilityNames.AddItem('ShockAndAwe');
	Template.AbilityShooterConditions.AddItem(HasAbilityCondition);

	//	Cannot be used while suppressed
	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect('Suppression', 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect('LW2WotC_AreaSuppression', 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	//	Target conditions
	GrenadeCondition = new class'X2Condition_AbilitySourceWeapon';
	GrenadeCondition.CheckGrenadeFriendlyFire = true;
	Template.AbilityMultiTargetConditions.AddItem(GrenadeCondition);

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	//UnitPropertyCondition.ExcludeHostileToSource = false;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	//	Ability effects
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
    WeaponDamageEffect.bExplosiveDamage = true;
    Template.AddMultiTargetEffect(WeaponDamageEffect);

	Template.bRecordValidTiles = true;	//	Not sure what this does

	//	Visualization
	Template.ActivationSpeech = 'RocketLauncher';
	Template.CinescriptCameraType = "Iridar_Rocket";

	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.Hostility = eHostility_Offensive;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.HeavyWeaponLostSpawnIncreasePerUse;

	return Template;
}
*/
/*
{
	local X2AbilityTemplate						Template;	
	local X2Effect_IRI_RocketMobilityPenalty	MobilityDamageEffect;
	local X2AbilityTrigger_EventListener		Trigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IRI_RocketMobilityPenalty');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_reloadrocket";

	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;
	Template.bHideOnClassUnlock = true;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.EventID = 'PlayerTurnBegun';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.Filter = eFilter_None;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(Trigger);

	MobilityDamageEffect = new class 'X2Effect_IRI_RocketMobilityPenalty';
	MobilityDamageEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);
	MobilityDamageEffect.SetDisplayInfo(ePerkBuff_Passive,Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);
	MobilityDamageEffect.DuplicateResponse = eDupe_Ignore;
	MobilityDamageEffect.EffectName = 'IRI_RocketMobilityPenalty_Effect';
	Template.AddShooterEffect(MobilityDamageEffect);

	Template.bDisplayInUITacticalText = false;
	Template.bShowActivation = false;
	Template.bSkipFireAction = true;
	Template.bUniqueSource = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;	
}*/
//	projectile to rocket
/*
static function X2DataTemplate Create_IRI_FireRocket()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2Condition_AbilitySourceWeapon   GrenadeCondition, ProximityMineCondition;
	local X2Effect_ProximityMine            ProximityMineEffect;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;
	local X2Effect_Knockback				KnockbackEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IRI_FireRocket');

	Template.SoldierAbilityPurchasedFn = class'X2Ability_GrenadierAbilitySet'.static.GrenadePocketPurchased;
	
	//AmmoCost = new class'X2AbilityCost_Ammo';	
	//AmmoCost.iAmmo = 1;
	//AmmoCost.UseLoadedAmmo = true;
//	Template.AbilityCosts.AddItem(AmmoCost);
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('Salvo');
	Template.AbilityCosts.AddItem(ActionPointCost);



	//Template.iSoundRange = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ISOUNDRANGE;
	//Template.TradingPostValue = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_TRADINGPOSTVALUE;
	//Template.iClipSize = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_ICLIPSIZE;
//	Template.DamageTypeTemplateName = 'Explosion';
//	Template.Tier = 0;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
    WeaponDamageEffect.bExplosiveDamage = true;
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.EffectDamageValue = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_BASEDAMAGE;
	WeaponDamageEffect.EnvironmentalDamageAmount = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_IENVIRONMENTDAMAGE;
    Template.AddMultiTargetEffect(WeaponDamageEffect);

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddMultiTargetEffect(KnockbackEffect);
	
    // Cannot miss or crit
    StandardAim = new class'X2AbilityToHitCalc_StandardAim';
    StandardAim.bAllowCrit = false;
    StandardAim.bGuaranteedHit = true;
    Template.AbilityToHitCalc = StandardAim;
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = 30; // class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RANGE;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_RADIUS;
	RadiusMultiTarget.bUseWeaponBlockingCoverFlag = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	GrenadeCondition = new class'X2Condition_AbilitySourceWeapon';
	GrenadeCondition.CheckGrenadeFriendlyFire = true;
	Template.AbilityMultiTargetConditions.AddItem(GrenadeCondition);

	Template.AddShooterEffectExclusions();

	Template.bRecordValidTiles = true;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_AmmoCost');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_grenade_launcher";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_GRENADE_PRIORITY;
	//Template.bUseAmmoAsChargesForHUD = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	Template.ActivationSpeech = 'RocketLauncher';

	Template.DamagePreviewFn = class'X2Ability_Grenades'.static.GrenadeDamagePreview;
	Template.TargetingMethod = class'X2TargetingMethod_IRI_RocketLauncher';
	Template.CinescriptCameraType = "Grenadier_GrenadeLauncher";
	
	Template.Hostility = eHostility_Offensive;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.GrenadeLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;

	return Template;
}*/


/*
static function X2AbilityTemplate Create_IRI_FireLockon()
{
	local X2AbilityTemplate             Template;	
	local X2Condition_Visibility		TargetVisibilityCondition;
	local X2Effect_ApplyWeaponDamage	WeaponDamageEffect;
	local X2Effect_Knockback			KnockbackEffect;

	Template = Setup_FireRocketAbility('IRI_FireLockon');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_firerocket";

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
		
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bActAsSquadsight = true; //LOS + any squadmate can see the target, regardless of if the unit has Squadsight
	TargetVisibilityCondition.bRequireNotMatchCoverType = true;	//	enemies in high cover cannot be targeted
	TargetVisibilityCondition.TargetCover = CT_Standing;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	//Template.AbilityTargetConditions.AddItem(new class'X2Condition_IRI_HoloTarget');	//	only holotargeted enemies

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.AddTargetEffect(WeaponDamageEffect);	//	deals double damage to primary target, intentional

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddTargetEffect(KnockbackEffect);

	return Template;	
}

static function X2AbilityTemplate Create_IRI_FireJavelin()
{
	local X2AbilityTemplate             Template;	
	local X2Condition_Visibility		TargetVisibilityCondition;
	local X2Effect_ApplyWeaponDamage	WeaponDamageEffect;
	local X2Effect_Knockback			KnockbackEffect;

	Template = Setup_FireRocketAbility('IRI_FireJavelin');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_firerocket";

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
		
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bActAsSquadsight = true; //LOS + any squadmate can see the target, regardless of if the unit has Squadsight
	TargetVisibilityCondition.bRequireNotMatchCoverType = true;	//	enemies in high cover cannot be targeted
	TargetVisibilityCondition.TargetCover = CT_Standing;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	//Template.AbilityTargetConditions.AddItem(new class'X2Condition_IRI_HoloTarget');	//	only holotargeted enemies

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.AddTargetEffect(WeaponDamageEffect);	//	deals double damage to primary target, intentional

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddTargetEffect(KnockbackEffect);

	//Template.AddTargetEffect(new class'X2Effect_BlazingPinionViz');

	Template.ActionFireClass = class'X2Action_FireJavelin';

	return Template;	
}*/
/*
static function X2AbilityTemplate Create_IRI_FireJavelin()
{
	local X2AbilityTemplate             Template;	
	local X2Condition_Visibility		TargetVisibilityCondition;
	local X2Effect_ApplyWeaponDamage	WeaponDamageEffect;
	local X2Effect_Knockback			KnockbackEffect;
	local X2Condition_UnitProperty		UnitProperty;

	Template = Setup_FireRocketAbility('IRI_FireJavelin');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_firerocket";

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
		
	//TargetVisibilityCondition = new class'X2Condition_Visibility';
	//TargetVisibilityCondition.bActAsSquadsight = true; //LOS + any squadmate can see the target, regardless of if the unit has Squadsight
	//TargetVisibilityCondition.bRequireNotMatchCoverType = true;	//	enemies in high cover cannot be targeted
	//TargetVisibilityCondition.TargetCover = CT_Standing;
	//Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	Template.TargetingMethod = class'X2TargetingMethod_DLC_2ThrowAxe';

	UnitProperty = new class'X2Condition_UnitProperty';
	UnitProperty.HasClearanceToMaxZ = true;
	Template.AbilityShooterConditions.AddItem(UnitProperty);
	Template.AbilityTargetConditions.AddItem(UnitProperty);

	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	//Template.AbilityTargetConditions.AddItem(new class'X2Condition_IRI_HoloTarget');	//	only holotargeted enemies

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.AddTargetEffect(WeaponDamageEffect);	//	deals double damage to primary target, intentional

	
	

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddTargetEffect(KnockbackEffect);

	//Template.ModifyNewContextFn = BlazingPinionsStage2_ModifyActivatedAbilityContext;
	//Template.BuildNewGameStateFn = class'X2Ability_Archon'.static.BlazingPinionsStage2_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_Archon'.static.BlazingPinionsStage2_BuildVisualization;
	//Template.CinescriptCameraType = "Archon_BlazingPinions_Stage2";

	return Template;	
}*/

/*
static function X2AbilityTemplate Create_IRI_FireRocket2()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2Condition_UnitInventory         UnitInventoryCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IRI_FireRocket2');
	
	ActionPointCost = new class'X2AbilityCost_HeavyWeaponActionPoints';
	//Template.AbilityCosts.AddItem(ActionPointCost);

	Template.SoldierAbilityPurchasedFn = class'X2Ability_GrenadierAbilitySet'.static.GrenadePocketPurchased;
	
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardAim;

	Template.bUseThrownGrenadeEffects = true;
	//Template.bUseLaunchedGrenadeEffects = true;
	Template.bHideAmmoWeaponDuringFire = true; // hide the grenade

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bUseWeaponRadius = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

	Template.AddShooterEffectExclusions();

	UnitInventoryCondition = new class'X2Condition_UnitInventory';
	UnitInventoryCondition.RelevantSlot = eInvSlot_SecondaryWeapon;
	UnitInventoryCondition.RequireWeaponCategory = 'iri_rocket_launcher';
	Template.AbilityShooterConditions.AddItem(UnitInventoryCondition);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WeaponIncompatible');
	Template.HideErrors.AddItem('AA_CannotAfford_AmmoCost');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_firerocket";
	Template.bUseAmmoAsChargesForHUD = true;
	//Template.TargetingMethod = class'X2TargetingMethod_RocketLauncher';
	
	Template.TargetingMethod = class'X2TargetingMethod_IRI_RocketLauncher';

	Template.DamagePreviewFn = class'X2Ability_Grenades'.static.GrenadeDamagePreview;

	Template.ActivationSpeech = 'RocketLauncher';
	Template.CinescriptCameraType = "Grenadier_GrenadeLauncher";
	Template.CustomFireAnim = 'FF_IRI_FireRocketA';
	//Template.CinescriptCameraType = "Soldier_HeavyWeapons";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.HeavyWeaponLostSpawnIncreasePerUse;

	return Template;	
}*/

/*
static function X2AbilityTemplate Setup_FireRocketAbility(name TemplateName)
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	//local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2Condition_UnitInventory         UnitInventoryCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	
	//	Ability costs
	//Template.AbilityCosts.AddItem(new class'X2AbilityCost_HeavyWeaponActionPoints');

	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
		

	//StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	//StandardAim.bGuaranteedHit = true;
	//Template.AbilityToHitCalc = StandardAim;

	//	Targeting
	Template.AbilityToHitCalc = default.DeadEye;

	Template.bUseThrownGrenadeEffects = true;
	Template.bHideAmmoWeaponDuringFire = true; // not sure this is necessary

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bUseWeaponRadius = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	//	Shooter conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	UnitInventoryCondition = new class'X2Condition_UnitInventory';
	UnitInventoryCondition.RelevantSlot = eInvSlot_SecondaryWeapon;
	UnitInventoryCondition.RequireWeaponCategory = 'iri_rocket_launcher';
	Template.AbilityShooterConditions.AddItem(UnitInventoryCondition);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.bUseAmmoAsChargesForHUD = true;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WeaponIncompatible');
	Template.HideErrors.AddItem('AA_CannotAfford_AmmoCost');
	
	//Template.DamagePreviewFn = class'X2Ability_Grenades'.static.GrenadeDamagePreview;

	//	An extension of X2Action_Fire, picks different firing animations based on remaining ammo
	//Template.ActionFireClass = class'X2Action_IRI_FireRocket';	

	Template.ActivationSpeech = 'RocketLauncher';
	Template.CinescriptCameraType = "Grenadier_GrenadeLauncher";

	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.Hostility = eHostility_Offensive;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.HeavyWeaponLostSpawnIncreasePerUse;

	return Template;
}*/

/*
static function X2DataTemplate LaunchGrenade()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Radius       RadiusMultiTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2Condition_AbilitySourceWeapon   GrenadeCondition, ProximityMineCondition;
	local X2Effect_ProximityMine            ProximityMineEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LaunchGrenade');

	Template.SoldierAbilityPurchasedFn = class'X2Ability_GrenadierAbilitySet'.static.GrenadePocketPurchased;
	
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	AmmoCost.UseLoadedAmmo = true;
	Template.AbilityCosts.AddItem(AmmoCost);
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('Salvo');
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bIndirectFire = true;
	StandardAim.bAllowCrit = false;
	Template.AbilityToHitCalc = StandardAim;
	
	Template.bUseLaunchedGrenadeEffects = true;
	Template.bHideAmmoWeaponDuringFire = true; // hide the grenade
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bUseWeaponRadius = true;
	RadiusMultiTarget.bUseWeaponBlockingCoverFlag = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	GrenadeCondition = new class'X2Condition_AbilitySourceWeapon';
	GrenadeCondition.CheckGrenadeFriendlyFire = true;
	Template.AbilityMultiTargetConditions.AddItem(GrenadeCondition);

	Template.AddShooterEffectExclusions();

	Template.bRecordValidTiles = true;

	ProximityMineEffect = new class'X2Effect_ProximityMine';
	ProximityMineEffect.BuildPersistentEffect(1, true, false, false);
	ProximityMineCondition = new class'X2Condition_AbilitySourceWeapon';
	ProximityMineCondition.MatchGrenadeType = 'ProximityMine';
	ProximityMineEffect.TargetConditions.AddItem(ProximityMineCondition);
	Template.AddShooterEffect(ProximityMineEffect);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_AmmoCost');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_grenade_launcher";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_GRENADE_PRIORITY;
	Template.bUseAmmoAsChargesForHUD = true;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	// Scott W says a Launcher VO cue doesn't exist, so I should use this one.  mdomowicz 2015_08_24
	Template.ActivationSpeech = 'ThrowGrenade';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.DamagePreviewFn = GrenadeDamagePreview;
	Template.TargetingMethod = class'X2TargetingMethod_Grenade';
	Template.CinescriptCameraType = "Grenadier_GrenadeLauncher";

	// This action is considered 'hostile' and can be interrupted!
	Template.Hostility = eHostility_Offensive;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.GrenadeLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;

	return Template;
}*/
/*
static function DisplayRocket_BuildVisualization(XComGameState VisualizeGameState)
{	
	//local X2Action_PlayAnimation		PlayAnimation;
	local XComGameStateHistory			History;
	local XComGameStateContext_Ability	Context;
	local StateObjectReference			SourceUnitRef;
	local VisualizationActionMetadata	SourceUnitMetadata;
	//local X2Action_CameraLookAt			LookAtAction;
	local X2Action_IRI_DisplayRocket					FireAction;
	local X2Action_WaitForAbilityEffect WaitForEffectAction;

	History = `XCOMHISTORY;
	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	SourceUnitRef = Context.InputContext.SourceObject;

	SourceUnitMetadata.StateObject_OldState = History.GetGameStateForObjectID(SourceUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	SourceUnitMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(SourceUnitRef.ObjectID);
	SourceUnitMetadata.VisualizeActor = History.GetVisualizer(SourceUnitRef.ObjectID);


	//PlayAnimation = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(SourceUnitMetadata, Context));
	//PlayAnimation.Params.AnimName = 'FF_IRI_DisplayRocket';
	//PlayAnimation.Params.BlendTime = 0;

	FireAction = X2Action_IRI_DisplayRocket(class'X2Action_IRI_DisplayRocket'.static.AddToVisualizationTree(SourceUnitMetadata, Context));
	WaitForEffectAction = X2Action_WaitForAbilityEffect(class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(SourceUnitMetadata, Context, false, FireAction));
	//LookAtAction = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.AddToVisualizationTree(SourceUnitMetadata, Context, false, PlayAnimation));
	//LookAtAction.LookAtLocation = Context.InputContext.TargetLocations[0];
}
*/