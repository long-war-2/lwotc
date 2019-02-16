class X2StrategyElement_AcademyUnlocks_LW extends X2StrategyElement config(LW_Overhaul);

var config int OFFICER_RANK_FOR_INFILTRATION_1;
var config int OFFICER_RANK_FOR_INFILTRATION_2;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	`LWTrace("  >> X2StrategyElement_AcademyUnlocks_LW.CreateTemplates()");
	
	Templates.AddItem(CreateInfiltration1Unlock());
	Templates.AddItem(CreateInfiltration2Unlock());
	return Templates;
}

static function X2SoldierUnlockTemplate CreateInfiltration1Unlock()
{
	local X2SoldierUnlockTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SoldierUnlockTemplate', Template, 'Infiltration1Unlock');
	
	Template.bAllClasses = true;
	Template.strImage = "img:///UILibrary_StrategyImages.GTS.GTS_SquadSize1";
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;
	Template.Requirements.SpecialRequirementsFn=Infiltration1UnlockFn;

	Resources.ItemTemplateName = 'Supplies';
    Resources.Quantity = 75;
    Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}


static function X2SoldierUnlockTemplate CreateInfiltration2Unlock()
{
	local X2SoldierUnlockTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SoldierUnlockTemplate', Template, 'Infiltration2Unlock');
	
	Template.bAllClasses = true;
	Template.strImage = "img:///UILibrary_StrategyImages.GTS.GTS_SquadSize2";
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;
		
	Template.Requirements.SpecialRequirementsFn=Infiltration2UnlockFn;

	Resources.ItemTemplateName = 'Supplies';
    Resources.Quantity = 75;
    Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

function bool Infiltration1UnlockFn()
{
	if (class'LWOfficerUtilities'.static.GetHighestOfficerRank() >= default.OFFICER_RANK_FOR_INFILTRATION_1)
		return true;
	return false;
}

function bool Infiltration2UnlockFn()
{
	if (class'LWOfficerUtilities'.static.GetHighestOfficerRank() >= default.OFFICER_RANK_FOR_INFILTRATION_2)
		return true;
	return false;
}

