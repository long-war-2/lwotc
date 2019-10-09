//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_LW_GTS_OfficerStaffSlot.uc
//  AUTHOR:  Amineri
//  PURPOSE: This adds templates and updates OTS Facility Template 
//				Adds officer staffslot and upgrade to OTS to allow officer training
//---------------------------------------------------------------------------------------
class X2StrategyElement_LW_OTS_OfficerStaffSlot extends X2StrategyElement_DefaultStaffSlots config(LW_OfficerPack);

var config int OTS_OFFICERTRAININGUPGRADE_UNLOCKRANK;
var config int OTS_OFFICERTRAININGUPGRADESECONDSLOT_UNLOCKRANK;

//var localized string strOTSLocationDisplayString;

//---------------------------------------------------------------------------------------
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	`LWTrace("  >> X2StrategyElement_LW_OTS_OfficerStaffSlot.CreateTemplates()");
	
	Templates.AddItem(CreateOfficerSlotTemplate());  // add StaffSlot
	Templates.AddItem(CreateOTS_OfficerTrainingUpgradeTemplate());	//add facility upgrade to unlock slot
	Templates.AddItem(CreateOTS_OfficerTrainingSecondSlotUpgradeTemplate());	//add facility upgrade to unlock second slot

	return Templates;
}

// officer training slot definition
static function X2DataTemplate CreateOfficerSlotTemplate()
{
	local X2StaffSlotTemplate Template;

	Template = CreateStaffSlotTemplate('OTSOfficerSlot');
	Template.bSoldierSlot = true;
	Template.bRequireConfirmToEmpty = true;
	Template.FillFn = FillOTSOfficerSlot;
	Template.EmptyFn = class'X2StrategyElement_DefaultStaffSlots'.static.EmptySlotDefault;
	Template.EmptyStopProjectFn = EmptyStopProjectOTSSoldierSlot;
	Template.ShouldDisplayToDoWarningFn = ShouldDisplayOTSOfficerToDoWarning;
	Template.GetContributionFromSkillFn = class'X2StrategyElement_DefaultStaffSlots'.static.GetContributionDefault;
	Template.GetAvengerBonusAmountFn = class'X2StrategyElement_DefaultStaffSlots'.static.GetAvengerBonusDefault;
	Template.GetNameDisplayStringFn = class'X2StrategyElement_DefaultStaffSlots'.static.GetNameDisplayStringDefault;
	Template.GetSkillDisplayStringFn = GetOTSSkillDisplayString;
	Template.GetBonusDisplayStringFn = GetOTSBonusDisplayString;
	//Template.GetLocationDisplayStringFn = GetOTSLocationDisplayString;
	Template.GetLocationDisplayStringFn = class'X2StrategyElement_DefaultStaffSlots'.static.GetLocationDisplayStringDefault;
	Template.IsUnitValidForSlotFn = IsUnitValidForOTSOfficerSlot;
	Template.IsStaffSlotBusyFn = class'X2StrategyElement_DefaultStaffSlots'.static.IsStaffSlotBusyDefault;
	Template.MatineeSlotName = "Officer";

	return Template;
}

//---------------------------------------------------------------------------------------
// OTS Facility UPGRADE
//---------------------------------------------------------------------------------------
static function X2DataTemplate CreateOTS_OfficerTrainingUpgradeTemplate()
{
	local X2FacilityUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2FacilityUpgradeTemplate', Template, 'OTS_LWOfficerTrainingUpgrade');
	//Template.MapName = "";
	Template.PointsToComplete = 0;
	Template.MaxBuild = 1;
	Template.iPower = -1;
	Template.UpkeepCost = 10;
	Template.strImage = "img:///UILibrary_StrategyImages.FacilityIcons.ChooseFacility_GuerrilaTacticsSchool";
	Template.OnUpgradeAddedFn = OTS_LWOfficerTrainingUpgradeAdded;

	// Requirements
	Template.Requirements.RequiredHighestSoldierRank = default.OTS_OFFICERTRAININGUPGRADE_UNLOCKRANK;
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;
	
	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 125;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateOTS_OfficerTrainingSecondSlotUpgradeTemplate()
{
	local X2FacilityUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2FacilityUpgradeTemplate', Template, 'OTS_LWOfficerTrainingUpgrade_SecondSlot');
	//Template.MapName = "";
	Template.PointsToComplete = 0;
	Template.MaxBuild = 1;
	Template.iPower = -1;
	Template.UpkeepCost = 10;
	Template.strImage = "img:///UILibrary_StrategyImages.FacilityIcons.ChooseFacility_GuerrilaTacticsSchool";
	Template.OnUpgradeAddedFn = OTS_LWOfficerTrainingUpgradeAdded;

	// Requirements
	Template.Requirements.RequiredHighestSoldierRank = default.OTS_OFFICERTRAININGUPGRADESECONDSLOT_UNLOCKRANK;
	Template.Requirements.bVisibleIfSoldierRankGatesNotMet = true;
	
	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 200;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function OTS_LWOfficerTrainingUpgradeAdded(XComGameState NewGameState, XComGameState_FacilityUpgrade Upgrade, XComGameState_FacilityXCom Facility)
{
	Facility.PowerOutput += Upgrade.GetMyTemplate().iPower;
	Facility.UpkeepCost += Upgrade.GetMyTemplate().UpkeepCost;
	Facility.UnlockStaffSlot(NewGameState);
}

static function bool IsGTSProjectActive(StateObjectReference FacilityRef)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_FacilityXCom FacilityState;
	local XComGameState_StaffSlot StaffSlot;
	local XComGameState_HeadquartersProjectTrainRookie RookieProject;
	local int i;

	History = `XCOMHISTORY;
	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
	FacilityState = XComGameState_FacilityXCom(History.GetGameStateForObjectID(FacilityRef.ObjectID));

	for (i = 0; i < FacilityState.StaffSlots.Length; i++)
	{
		StaffSlot = FacilityState.GetStaffSlot(i);
		if (StaffSlot.IsSlotFilled())
		{
			RookieProject = XComHQ.GetTrainRookieProject(StaffSlot.GetAssignedStaffRef());
			if (RookieProject != none)
			{
				return true;
			}
		}
	}
	return false;
}

//---------------------------------------------------------------------------------------
// Second slot helper functions
static function FillOTSOfficerSlot(XComGameState NewGameState, StateObjectReference SlotRef, StaffUnitInfo UnitInfo, optional bool bTemporary = false)
{
	local XComGameState_Unit NewUnitState;
	//local XComGameState_Unit_LWOfficer OfficerState;
	local XComGameState_StaffSlot NewSlotState;
	local XComGameState_HeadquartersXCom NewXComHQ;
	local XComGameState_HeadquartersProjectTrainLWOfficer ProjectState;
	local StateObjectReference EmptyRef;
	local int SquadIndex;

	class'X2StrategyElement_DefaultStaffSlots'.static.FillSlot(NewGameState, SlotRef, UnitInfo, NewSlotState, NewUnitState);
	NewXComHQ = class'X2StrategyElement_DefaultStaffSlots'.static.GetNewXComHQState(NewGameState);
	//OfficerState = class'LWOfficerUtilities'.static.GetOfficerComponent(NewUnitState);

	ProjectState = XComGameState_HeadquartersProjectTrainLWOfficer(NewGameState.CreateStateObject(class'XComGameState_HeadquartersProjectTrainLWOfficer'));
	NewGameState.AddStateObject(ProjectState);
	ProjectState.SetProjectFocus(UnitInfo.UnitRef, NewGameState, NewSlotState.Facility);

	NewUnitState.SetStatus(eStatus_Training);
	NewXComHQ.Projects.AddItem(ProjectState.GetReference());
	
	// If the unit undergoing training is in the squad, remove them
	SquadIndex = NewXComHQ.Squad.Find('ObjectID', UnitInfo.UnitRef.ObjectID);
	if (SquadIndex != INDEX_NONE)
	{
		// Remove their gear, excepting super soldiers
		if(!NewUnitState.bIsSuperSoldier && !class'UISquadSelect'.default.NoStripOnTraining)
		{
			NewUnitState.MakeItemsAvailable(NewGameState, false);
		}

		// Remove them from the squad
		NewXComHQ.Squad[SquadIndex] = EmptyRef;
	}
}

static function EmptyStopProjectOTSSoldierSlot(StateObjectReference SlotRef)
{
	//local XComGameState_Unit Unit;
	//local XComGameState_Unit_LWOfficer OfficerState;
	local HeadquartersOrderInputContext OrderInput;
	local XComGameState_StaffSlot SlotState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_HeadquartersProjectTrainLWOfficer TrainOfficerProject;

	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
	SlotState = XComGameState_StaffSlot(`XCOMHISTORY.GetGameStateForObjectID(SlotRef.ObjectID));

	TrainOfficerProject = XComGameState_HeadquartersProjectTrainLWOfficer(XComHQ.GetTrainRookieProject(SlotState.GetAssignedStaffRef()));
	if (TrainOfficerProject != none)
	{		
		OrderInput.OrderType = eHeadquartersOrderType_CancelTrainRookie;
		OrderInput.AcquireObjectReference = TrainOfficerProject.GetReference();

		class'XComGameStateContext_HeadquartersOrder'.static.IssueHeadquartersOrder(OrderInput);
	}
}

static function bool ShouldDisplayOTSOfficerToDoWarning(StateObjectReference SlotRef)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_StaffSlot SlotState;
	local StaffUnitInfo UnitInfo;
	local int i;

	History = `XCOMHISTORY;
	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
	SlotState = XComGameState_StaffSlot(History.GetGameStateForObjectID(SlotRef.ObjectID));

	for (i = 0; i < XComHQ.Crew.Length; i++)
	{
		UnitInfo.UnitRef = XComHQ.Crew[i];

		if (IsUnitValidForOTSOfficerSlot(SlotState, UnitInfo))
		{
			return true;
		}
	}

	return false;
}

static function bool IsUnitValidForOTSOfficerSlot(XComGameState_StaffSlot SlotState, StaffUnitInfo UnitInfo)
{
	local XComGameState_Unit Unit;
	local XComGameState_Unit_LWOfficer OfficerState;
	local bool AtMaxOfficerRank;
	local bool HasEligibleRegularRank;
	local int CurrentOfficerRank;

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitInfo.UnitRef.ObjectID));
	OfficerState = class'LWOfficerUtilities'.static.GetOfficerComponent(Unit);

	AtMaxOfficerRank = ((OfficerState != none) && (OfficerState.GetOfficerRank() >= class'LWOfficerUtilities'.default.MaxOfficerRank));
	//`log("LW Officer Pack, SlotTesting: AtMaxOfficerRank=" $ AtMaxOfficerRank);
	if (OfficerState == none) 
	{
		CurrentOfficerRank = 0;
	} else {
		CurrentOfficerRank = OfficerState.GetOfficerRank();
	}
	if (CurrentOfficerRank < class'LWOfficerUtilities'.default.MaxOfficerRank)
		HasEligibleRegularRank = Unit.GetRank() >= class'LWOfficerUtilities'.static.GetRequiredRegularRank(CurrentOfficerRank + 1);
	else
		HasEligibleRegularRank = false;
	//`log("LW Officer Pack, SlotTesting: HasEligibleRegularRank=" $ HasEligibleRegularRank $ ", Rank=" $ Unit.GetRank() $ ", ReqRank=" $ class'LWOfficerUtilities'.static.GetRequiredRegularRank(CurrentOfficerRank + 1));
	
	`log("LW Officer Pack, SlotTesting: IsPsiTraining=" $ string(Unit.IsPsiTraining()));

	if (Unit.IsSoldier()
		&& !Unit.IsInjured()
		&& !Unit.IsTraining()
		&& !Unit.IsPsiTraining()
		&& !Unit.IsPsiAbilityTraining()
		&& !Unit.CanRankUpSoldier()
		&& !AtMaxOfficerRank
		&& HasEligibleRegularRank
		&& Unit.GetStatus() != eStatus_CovertAction // don't use DLC helpers here since sparks can't train as officers
		&& Unit.GetSoldierClassTemplate() != none && Unit.GetSoldierClassTemplate().DataName != 'Spark')
	{
		return true;
	}

	return false;
}

static function string GetOTSSkillDisplayString(XComGameState_StaffSlot SlotState)
{
	return "";
}

static function string GetOTSBonusDisplayString(XComGameState_StaffSlot SlotState, optional bool bPreview)
{
	local XComGameState_HeadquartersProjectTrainLWOfficer TrainProject;
	local string Contribution;

	if (SlotState.IsSlotFilled())
	{
		TrainProject = GetLWOfficerTrainProject(SlotState.GetAssignedStaffRef(), SlotState);
		Contribution = Caps(TrainProject.GetTrainingAbilityFriendlyName());
	}

	return class'X2StrategyElement_DefaultStaffSlots'.static.GetBonusDisplayString(SlotState, "%SKILL", Contribution);
}

//static function string GetOTSLocationDisplayString(XComGameState_StaffSlot SlotState)
//{
	////local XComGameState_HeadquartersXCom XComHQ;
	//local XComGameState_Unit UnitState;
	//local XComGameState_HeadquartersProjectTrainLWOfficer TrainProject;
	//local string LocationStr;
	//local XGParamTag LocTag;
//
	//UnitState = SlotState.GetAssignedStaff();
	//TrainProject = GetLWOfficerTrainProject(UnitState.GetReference(), SlotState);
//
	//LocTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	//LocTag.StrValue0 = TrainProject.GetTrainingAbilityFriendlyName();
	//LocationStr = `XEXPAND.ExpandString(default.strOTSLocationDisplayString);
	//
	//return LocationStr;
//}

static function XComGameState_HeadquartersProjectTrainLWOfficer GetLWOfficerTrainProject(StateObjectReference UnitRef, XComGameState_StaffSlot SlotState)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_HeadquartersProjectTrainLWOfficer TrainProject;
	local int idx;

	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
	for (idx = 0; idx < XComHQ.Projects.Length; idx++)
	{
		TrainProject = XComGameState_HeadquartersProjectTrainLWOfficer(`XCOMHISTORY.GetGameStateForObjectID(XComHQ.Projects[idx].ObjectID));

		if (TrainProject != none)
		{
			if (SlotState.GetAssignedStaffRef() == TrainProject.ProjectFocus)
			{
				return TrainProject;
			}
		}
	}
}

DefaultProperties
{
	bShouldCreateDifficultyVariants = true
}
