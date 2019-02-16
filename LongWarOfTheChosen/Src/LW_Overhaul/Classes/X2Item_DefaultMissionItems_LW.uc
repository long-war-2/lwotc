class X2Item_DefaultMissionItems_LW extends X2Item;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Items;

	`LWTrace("  >> X2Item_DefaultMissionItems_LW.CreateTemplates()");
	
	Items.AddItem(CreateSmashNGrabItem());

	return Items;
}

static function X2DataTemplate CreateSmashNGrabItem()
{
	local X2EquipmentTemplate Template;

	`CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'SmashNGrabQuestItem');

	Template.CanBeBuilt = false;
	Template.HideInInventory = true;
	Template.HideInLootRecovered = true;

	Template.InventorySlot = eInvSlot_Mission;
	Template.ItemCat = 'mission';

	return Template;
}
