class X2Item_Resources_AlienPack extends X2Item;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Resources;

	Resources.AddItem(CreateDroneCorpse());
	Resources.AddItem(CreateBlutonCorpse());
	return Resources;
}

static function X2DataTemplate CreateDroneCorpse()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'CorpseDrone');

	Template.strImage = "img:///UILibrary_LWAlienPack.LW_Corpse_Drone";
	Template.ItemCat = 'resource';
	Template.TradingPostValue = 2;
	Template.MaxQuantity = 1;
	Template.LeavesExplosiveRemains = true;

	return Template;
}

static function X2DataTemplate CreateBlutonCorpse()
{
	local X2ItemTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ItemTemplate', Template, 'CorpseMutonElite');

	Template.strImage = "img:///UILibrary_LWAlienPack.LW_Corpse_Bluton";
	Template.ItemCat = 'resource';
	Template.TradingPostValue = 6;
	Template.MaxQuantity = 1;
	Template.LeavesExplosiveRemains = true;

	return Template;
}