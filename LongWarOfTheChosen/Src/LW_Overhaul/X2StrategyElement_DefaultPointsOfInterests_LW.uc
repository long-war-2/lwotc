class X2StrategyElement_DefaultPointsOfInterests_LW extends X2StrategyElement config(LW_Overhaul);

var config int RESCARD_POI_MAX_CARDS_IN_HAND;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreatePOIResistanceCardTemplate());
	return Templates;
}


static function X2DataTemplate CreatePOIResistanceCardTemplate()
{
	local X2PointOfInterestTemplate Template;

	`CREATE_X2POINTOFINTEREST_TEMPLATE(Template, 'POI_ResistanceCard');

	//Template.IsRewardNeededFn = IsResistanceCardRewardNeeded;
	Template.CanAppearFn = CanResistanceCardPOIAppear;

	return Template;
}
// static function bool IsResistanceCardRewardNeeded(XComGameState_PointOfInterest POIState)
// {
// 	local XComGameState_HeadquartersXCom XComHQ;
// 	local TDateTime StartDateTime, CurrentTime;
// 	local int MinEngineers, NumEngineers, iMonthsPassed;

// 	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();

// 	StartDateTime = class'UIUtilities_Strategy'.static.GetResistanceHQ().StartTime;
// 	CurrentTime = class'XComGameState_GeoscapeEntity'.static.GetCurrentTime();
// 	iMonthsPassed = class'X2StrategyGameRulesetDataStructures'.static.DifferenceInMonths(CurrentTime, StartDateTime);

// 	// Calculate the minimum amount of scientists the player should have at this time
// 	if (iMonthsPassed > 0)
// 	{
// 		MinCards = `ScaleStrategyArrayFloat(XComHQ.StartingEngineerMinCap) + (`ScaleStrategyArrayFloat(XComHQ.EngineerMinCapIncrease) * iMonthsPassed);
// 		NumEngineers = XComHQ.GetNumberOfEngineers();
// 	}

// 	return (NumEngineers < MinEngineers);
// }
static function bool CanResistanceCardPOIAppear(XComGameState_PointOfInterest POIState)
{
//	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_HeadquartersResistance ResHQ;

	ResHQ = class'UIUtilities_Strategy'.static.GetResistanceHQ();
	if (ResHQ.GetHandCards().Length <= default.RESCARD_POI_MAX_CARDS_IN_HAND && `SecondWaveEnabled('DisableResistanceOrders'))
	{
		return false;
	}



	return true;
}

