//from NotSoLoneWolf
class X2StrategyElement_AcademyUnlocks_GrappleParkour extends X2StrategyElement_AcademyUnlocks config(AcademyUnlocks);

var config int PARKOUR_RANK;
var config int PARKOUR_COST;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
		
	Templates.AddItem(ParkourUnlock());

	return Templates;
}

// Making a template with the same name as a template from base XCOM 2 overwrites that template
// I've included this here so users can change the cost of the perk easily if they think its new ability is worth more or less
static function X2SoldierUnlockTemplate ParkourUnlock()
{
	local X2SoldierAbilityUnlockTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SoldierAbilityUnlockTemplate', Template, 'ParkourUnlock');
	Template.AllowedClasses.AddItem('Skirmisher');
	Template.AbilityName = 'Parkour';
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.GTS_Skirmisher";

	Template.Requirements.RequiredHighestSoldierRank = default.PARKOUR_RANK;
	Template.Requirements.RequiredSoldierClass = 'Skirmisher';
	Template.Requirements.RequiredSoldierRankClassCombo = true;
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;

	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.PARKOUR_COST;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}
