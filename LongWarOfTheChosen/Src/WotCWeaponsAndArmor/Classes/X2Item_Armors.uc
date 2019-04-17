// This is an Unreal Script
class X2Item_Armors extends X2Item;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Armors;

	Armors.AddItem(CreatePlatedReaperArmor());
	Armors.AddItem(CreatePoweredReaperArmor());

	Armors.AddItem(CreatePlatedTemplarArmor());
	Armors.AddItem(CreatePoweredTemplarArmor());

	Armors.AddItem(CreatePlatedSkirmisherArmor());
	Armors.AddItem(CreatePoweredSkirmisherArmor());


	return Armors;
}

static function X2DataTemplate CreatePlatedReaperArmor()
{
	local X2ArmorTemplate Template;
	local ArtifactCost Artifacts;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2ArmorTemplate', Template, 'PlatedReaperArmor');
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_HORArmorPlat";
	Template.ItemCat = 'armor';
	Template.bAddsUtilitySlot = false;
	Template.StartingItem = false;
	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;
	Template.TradingPostValue = 20;
	Template.PointsToComplete = 0;
	Template.Abilities.AddItem('MediumPlatedArmorStats');
	Template.ArmorTechCat = 'plated';
	Template.ArmorCat = 'reaper';
	Template.Tier = 1;
	Template.AkAudioSoldierArmorSwitch = 'Predator';
	Template.EquipNarrative = "X2NarrativeMoments.Strategy.CIN_ArmorIntro_PlatedMedium";
	Template.EquipSound = "StrategyUI_Armor_Equip_Plated";

    Template.Requirements.RequiredTechs.AddItem('PlatedArmor');

	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, class'X2Ability_ItemGrantedAbilitySet'.default.MEDIUM_PLATED_HEALTH_BONUS, true);

	// Cost
    Resources.ItemTemplateName = 'Supplies';
    Resources.Quantity = 30;
    Template.Cost.ResourceCosts.AddItem(Resources);

    Resources.ItemTemplateName = 'AlienAlloy';
    Resources.Quantity = 5;
    Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreatePoweredReaperArmor()
{
	local X2ArmorTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2ArmorTemplate', Template, 'PoweredReaperArmor');
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_HORArmorPowr";
	Template.ItemCat = 'armor';
	Template.bAddsUtilitySlot = false;
	Template.StartingItem = false;
	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;
	Template.TradingPostValue = 60;
	Template.PointsToComplete = 0;
	Template.Abilities.AddItem('MediumPoweredArmorStats');
	Template.ArmorTechCat = 'powered';
	Template.ArmorCat = 'reaper';
	Template.Tier = 3;
	Template.AkAudioSoldierArmorSwitch = 'Warden';
	Template.EquipNarrative = "X2NarrativeMoments.Strategy.CIN_ArmorIntro_PoweredMedium";
	Template.EquipSound = "StrategyUI_Armor_Equip_Powered";

	Template.Requirements.RequiredTechs.AddItem('PoweredArmor');

	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, class'X2Ability_ItemGrantedAbilitySet'.default.MEDIUM_POWERED_HEALTH_BONUS, true);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ArmorLabel, eStat_ArmorMitigation, class'X2Ability_ItemGrantedAbilitySet'.default.MEDIUM_POWERED_MITIGATION_AMOUNT);

	// Cost
    Resources.ItemTemplateName = 'Supplies';
    Resources.Quantity = 80;
    Template.Cost.ResourceCosts.AddItem(Resources);

    Resources.ItemTemplateName = 'AlienAlloy';
    Resources.Quantity = 10;
    Template.Cost.ResourceCosts.AddItem(Resources);

    Resources.ItemTemplateName = 'EleriumDust';
    Resources.Quantity = 10;
    Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreatePlatedSkirmisherArmor()
{
	local X2ArmorTemplate Template;
	local ArtifactCost Artifacts;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2ArmorTemplate', Template, 'PlatedSkirmisherArmor');
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_HORArmorPlat";
	Template.ItemCat = 'armor';
	Template.bAddsUtilitySlot = false;
	Template.StartingItem = false;
	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;
	Template.TradingPostValue = 20;
	Template.PointsToComplete = 0;
	Template.Abilities.AddItem('MediumPlatedArmorStats');
	Template.ArmorTechCat = 'plated';
	Template.ArmorCat = 'skirmisher';
	Template.Tier = 1;
	Template.AkAudioSoldierArmorSwitch = 'Predator';
	Template.EquipNarrative = "X2NarrativeMoments.Strategy.CIN_ArmorIntro_PlatedMedium";
	Template.EquipSound = "StrategyUI_Armor_Equip_Plated";

    Template.Requirements.RequiredTechs.AddItem('PlatedArmor');

	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, class'X2Ability_ItemGrantedAbilitySet'.default.MEDIUM_PLATED_HEALTH_BONUS, true);

	// Cost
    Resources.ItemTemplateName = 'Supplies';
    Resources.Quantity = 30;
    Template.Cost.ResourceCosts.AddItem(Resources);

    Resources.ItemTemplateName = 'AlienAlloy';
    Resources.Quantity = 5;
    Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreatePoweredSkirmisherArmor()
{
	local X2ArmorTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2ArmorTemplate', Template, 'PoweredSkirmisherArmor');
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_HORArmorPowr";
	Template.ItemCat = 'armor';
	Template.bAddsUtilitySlot = false;
	Template.StartingItem = false;
	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;
	Template.TradingPostValue = 60;
	Template.PointsToComplete = 0;
	Template.Abilities.AddItem('MediumPoweredArmorStats');
	Template.ArmorTechCat = 'powered';
	Template.ArmorCat = 'skirmisher';
	Template.Tier = 3;
	Template.AkAudioSoldierArmorSwitch = 'Warden';
	Template.EquipNarrative = "X2NarrativeMoments.Strategy.CIN_ArmorIntro_PoweredMedium";
	Template.EquipSound = "StrategyUI_Armor_Equip_Powered";

	Template.Requirements.RequiredTechs.AddItem('PoweredArmor');

	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, class'X2Ability_ItemGrantedAbilitySet'.default.MEDIUM_POWERED_HEALTH_BONUS, true);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ArmorLabel, eStat_ArmorMitigation, class'X2Ability_ItemGrantedAbilitySet'.default.MEDIUM_POWERED_MITIGATION_AMOUNT);

	// Cost
    Resources.ItemTemplateName = 'Supplies';
    Resources.Quantity = 80;
    Template.Cost.ResourceCosts.AddItem(Resources);

    Resources.ItemTemplateName = 'AlienAlloy';
    Resources.Quantity = 10;
    Template.Cost.ResourceCosts.AddItem(Resources);

    Resources.ItemTemplateName = 'EleriumDust';
    Resources.Quantity = 10;
    Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreatePlatedTemplarArmor()
{
	local X2ArmorTemplate Template;
	local ArtifactCost Artifacts;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2ArmorTemplate', Template, 'PlatedTemplarArmor');
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_HORArmorPlat";
	Template.ItemCat = 'armor';
	Template.bAddsUtilitySlot = false;
	Template.StartingItem = false;
	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;
	Template.TradingPostValue = 20;
	Template.PointsToComplete = 0;
	Template.Abilities.AddItem('MediumPlatedArmorStats');
	Template.ArmorTechCat = 'plated';
	Template.ArmorCat = 'templar';
	Template.Tier = 1;
	Template.AkAudioSoldierArmorSwitch = 'Predator';
	Template.EquipNarrative = "X2NarrativeMoments.Strategy.CIN_ArmorIntro_PlatedMedium";
	Template.EquipSound = "StrategyUI_Armor_Equip_Plated";

    Template.Requirements.RequiredTechs.AddItem('PlatedArmor');

	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, class'X2Ability_ItemGrantedAbilitySet'.default.MEDIUM_PLATED_HEALTH_BONUS, true);

	// Cost
    Resources.ItemTemplateName = 'Supplies';
    Resources.Quantity = 30;
    Template.Cost.ResourceCosts.AddItem(Resources);

    Resources.ItemTemplateName = 'AlienAlloy';
    Resources.Quantity = 5;
    Template.Cost.ResourceCosts.AddItem(Resources);
    
	return Template;
}

static function X2DataTemplate CreatePoweredTemplarArmor()
{
	local X2ArmorTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2ArmorTemplate', Template, 'PoweredTemplarArmor');
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_HORArmorPowr";
	Template.ItemCat = 'armor';
	Template.bAddsUtilitySlot = false;
	Template.StartingItem = false;
	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;
	Template.TradingPostValue = 60;
	Template.PointsToComplete = 0;
	Template.Abilities.AddItem('MediumPoweredArmorStats');
	Template.ArmorTechCat = 'powered';
	Template.ArmorCat = 'templar';
	Template.Tier = 3;
	Template.AkAudioSoldierArmorSwitch = 'Warden';
	Template.EquipNarrative = "X2NarrativeMoments.Strategy.CIN_ArmorIntro_PoweredMedium";
	Template.EquipSound = "StrategyUI_Armor_Equip_Powered";

	Template.Requirements.RequiredTechs.AddItem('PoweredArmor');

	Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, class'X2Ability_ItemGrantedAbilitySet'.default.MEDIUM_POWERED_HEALTH_BONUS, true);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ArmorLabel, eStat_ArmorMitigation, class'X2Ability_ItemGrantedAbilitySet'.default.MEDIUM_POWERED_MITIGATION_AMOUNT);

	// Cost
    Resources.ItemTemplateName = 'Supplies';
    Resources.Quantity = 80;
    Template.Cost.ResourceCosts.AddItem(Resources);

    Resources.ItemTemplateName = 'AlienAlloy';
    Resources.Quantity = 10;
    Template.Cost.ResourceCosts.AddItem(Resources);

    Resources.ItemTemplateName = 'EleriumDust';
    Resources.Quantity = 10;
    Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}