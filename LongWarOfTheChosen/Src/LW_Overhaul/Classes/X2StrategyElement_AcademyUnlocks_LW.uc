class X2StrategyElement_AcademyUnlocks_LW extends X2StrategyElement config(LW_Overhaul);

var config int OFFICER_RANK_FOR_INFILTRATION_1;
var config int OFFICER_RANK_FOR_INFILTRATION_2;

var config int OFFICER_RANK_FOR_XTP_1;
var config int OFFICER_RANK_FOR_XTP_2;
var config int OFFICER_RANK_FOR_XTP_3;
var config int OFFICER_RANK_FOR_XTP_4;



static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	`LWTrace("  >> X2StrategyElement_AcademyUnlocks_LW.CreateTemplates()");
	
	Templates.AddItem(CreateInfiltration1Unlock());
	Templates.AddItem(CreateInfiltration2Unlock());
	Templates.AddItem(XTP1Unlock());
	Templates.AddItem(XTP2Unlock());
	Templates.AddItem(XTP3Unlock());
	Templates.AddItem(XTP4Unlock());
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


static function X2SoldierUnlockTemplate XTP1Unlock()
{
	local X2SoldierUnlockTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SoldierUnlockTemplate', Template, 'XTP1');
	
	Template.bAllClasses = true;
	Template.strImage = "img:///UILibrary_StrategyImages.GTS.GTS_SquadSize1";
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;
	Template.Requirements.SpecialRequirementsFn=XTP1UnlockFn;

	Resources.ItemTemplateName = 'Supplies';
    Resources.Quantity = 75;
    Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}


static function X2SoldierUnlockTemplate XTP2Unlock()
{
	local X2SoldierUnlockTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SoldierUnlockTemplate', Template, 'XTP2');
	
	Template.bAllClasses = true;
	Template.strImage = "img:///UILibrary_StrategyImages.GTS.GTS_SquadSize2";
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;
	Template.Requirements.SpecialRequirementsFn=XTP2UnlockFn;

	Resources.ItemTemplateName = 'Supplies';
    Resources.Quantity = 125;
    Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}


static function X2SoldierUnlockTemplate XTP3Unlock()
{
	local X2SoldierUnlockTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SoldierUnlockTemplate', Template, 'XTP3');
	
	Template.bAllClasses = true;
	Template.strImage = "img:///UILibrary_StrategyImages.GTS.GTS_SquadSize2";
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;
	Template.Requirements.SpecialRequirementsFn=XTP3UnlockFn;

	Resources.ItemTemplateName = 'Supplies';
    Resources.Quantity = 150;
    Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}


static function X2SoldierUnlockTemplate XTP4Unlock()
{
	local X2SoldierUnlockTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2SoldierUnlockTemplate', Template, 'XTP4');
	
	Template.bAllClasses = true;
	Template.strImage = "img:///UILibrary_StrategyImages.GTS.GTS_SquadSize2";
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;
	Template.Requirements.SpecialRequirementsFn=XTP4UnlockFn;

	Resources.ItemTemplateName = 'Supplies';
    Resources.Quantity = 175;
    Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}
function bool XTP1UnlockFn()
{
	if (class'LWOfficerUtilities'.static.GetHighestOfficerRank() >= default.OFFICER_RANK_FOR_XTP_1)
		return true;
	return false;
}

function bool XTP2UnlockFn()
{
	if (class'LWOfficerUtilities'.static.GetHighestOfficerRank() >= default.OFFICER_RANK_FOR_XTP_2)
		return true;
	return false;
}

function bool XTP3UnlockFn()
{
	if (class'LWOfficerUtilities'.static.GetHighestOfficerRank() >= default.OFFICER_RANK_FOR_XTP_3)
		return true;
	return false;
}

function bool XTP4UnlockFn()
{
	if (class'LWOfficerUtilities'.static.GetHighestOfficerRank() >= default.OFFICER_RANK_FOR_XTP_4)
		return true;
	return false;
}