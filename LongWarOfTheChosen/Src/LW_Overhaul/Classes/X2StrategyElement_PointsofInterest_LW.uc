class X2StrategyElement_PointsofInterest_LW extends X2StrategyElement_DefaultPointsOfInterest;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

	`LWTrace("  >> X2StrategyElement_PointsofInterest_LW.CreateTemplates()");
	
	Templates.AddItem(CreateRebelsPOITemplate());
	Templates.AddItem(CreateResistanceMECPOITemplate());
	Templates.AddItem(CreateNewResourcesPOITemplate());
	Return Templates;
}

static function X2DataTemplate CreateRebelsPOITemplate()
{
    local X2PointOfInterestTemplate Template;

	`CREATE_X2POINTOFINTEREST_TEMPLATE(Template, 'POI_Rebels');
	Template.CanAppearFn = CanRebelPOIAppear;
	Template.IsRewardNeededFn = IsRebelRewardNeeded;
    return Template;
}

function bool CanRebelPOIAppear(XComGameState_PointOfInterest POIState)
{
    local XComGameState_WorldRegion RegionState, ActivityRegion;
    local XComGameState_LWOutpostManager OutpostManager;
    local XComGameState_LWOutpost Outpost;
	local XComGameState_LWAlienActivity ActivityState;

    RegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(POIState.ResistanceRegion.ObjectID));
	if (RegionState == none)
	{
		return false;
	}
    OutpostManager = class'XComGameState_LWOutpostManager'.static.GetOutpostManager();
    Outpost = OutpostManager.GetOutpostForRegion(RegionState);

	//Make sure this won't give us too many rebels	
	if (Outpost.Rebels.length > class'XComGameState_LWOutpost'.default.DEFAULT_OUTPOST_MAX_SIZE - POIState.GetMyTemplate().MaxRewardInstanceAmount[`STRATEGYDIFFICULTYSETTING])
		return false;

	//Make sure this isn't concurrent with a Political Prisoners mission, which could give us too many rebels
	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_LWAlienActivity', ActivityState)
	{
		ActivityRegion = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
		if (ActivityRegion != none && ActivityRegion == RegionState)
		{
			if (ActivityState.GetMyTemplateName() == class'X2StrategyElement_DefaultAlienActivities'.default.PoliticalPrisonersName)
				return false;
		}
	}
	return true;
}

function bool IsRebelRewardNeeded(XComGameState_PointOfInterest POIState)
{
	local XComGameState_WorldRegion RegionState;
    local XComGameState_LWOutpostManager OutpostManager;
    local XComGameState_LWOutpost Outpost;

	RegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(POIState.ResistanceRegion.ObjectID));
	if (RegionState == none)
	{
		return false;
	}

    OutpostManager = class'XComGameState_LWOutpostManager'.static.GetOutpostManager();
    Outpost = OutpostManager.GetOutpostForRegion(RegionState);

	if (Outpost.Rebels.length < 5)
		return true;
	return false;
}

static function X2DataTemplate CreateResistanceMECPOITemplate()
{
    local X2PointOfInterestTemplate Template;

	`CREATE_X2POINTOFINTEREST_TEMPLATE(Template, 'POI_ResistanceMEC');
	Template.IsRewardNeededFn = IsResistanceMECRewardNeeded;
    return Template;
}

function bool IsResistanceMECRewardNeeded(XComGameState_PointOfInterest POIState)
{
	local XComGameState_WorldRegion RegionState;
    local XComGameState_LWOutpostManager OutpostManager;
    local XComGameState_LWOutpost Outpost;

	RegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(POIState.ResistanceRegion.ObjectID));
	if (RegionState == none)
	{
		return false;
	}
	
	OutpostManager = class'XComGameState_LWOutpostManager'.static.GetOutpostManager();
    Outpost = OutpostManager.GetOutpostForRegion(RegionState);

	if (Outpost.ResistanceMecs.length < 1)
		return true;
	return false;
}

static function X2DataTemplate CreateNewResourcesPOITemplate()
{
    local X2PointOfInterestTemplate Template;

	`CREATE_X2POINTOFINTEREST_TEMPLATE(Template, 'POI_NewResources');
	Template.CanAppearFn = IsNewResourcesRewardNeeded;
	Template.IsRewardNeededFn = IsNewResourcesRewardNeeded;
    return Template;
}

function bool IsNewResourcesRewardNeeded(XComGameState_PointOfInterest POIState)
{
	local XComGameState_WorldRegion RegionState;
    local XComGameState_LWOutpostManager OutpostManager;
    local XComGameState_LWOutpost Outpost;

	RegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(POIState.ResistanceRegion.ObjectID));
	if (RegionState == none)
	{
		return false;
	}
	
	OutpostManager = class'XComGameState_LWOutpostManager'.static.GetOutpostManager();
    Outpost = OutpostManager.GetOutpostForRegion(RegionState);
	if (OutPost.SuppliesTaken > OutPost.SupplyCap * 1.5)
		return true;
	return false;
}