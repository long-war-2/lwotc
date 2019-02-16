//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_DefaultStaffSlots_LW.uc
//  AUTHOR:  tracktwo / Pavonis Interactive
//  PURPOSE: New staff slot templates for LW Overhaul
//---------------------------------------------------------------------------------------

class X2StrategyElement_DefaultStaffSlots_LW extends X2StrategyElement;

var localized string m_strLiaisonLocation;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> StaffSlots;

	`LWTrace("  >> X2StrategyElement_DefaultStaffSlots_LW.CreateTemplates()");
	
    StaffSlots.AddItem(CreateOutpostStaffSlot());
    //StaffSlots.AddItem(CreateOutpostScientistStaffSlot());

	// This is bad organization; these are really facility upgrades but I didn't want to make a new class
	StaffSlots.AddItem(CreateLaboratory_AdditionalResearchStation2Template());
	StaffSlots.AddItem(CreateLaboratory_AdditionalResearchStation3Template());

    return StaffSlots;
}

static function X2DataTemplate CreateOutpostStaffSlot()
{
    local X2StaffSlotTemplate Template;

    `CREATE_X2TEMPLATE(class'X2StaffSlotTemplate', Template, 'LWOutpostStaffSlot');

    Template.bSoldierSlot = true;
    Template.bEngineerSlot = true;
    Template.bScientistSlot = true;
    Template.bHideStaffSlot = true;
	Template.FillFn = FillOutpostLiaison;
	Template.EmptyFn = EmptyOutpostLiaison;
	Template.GetContributionFromSkillFn = class'X2StrategyElement_DefaultStaffSlots'.static.GetContributionDefault;
	Template.GetAvengerBonusAmountFn = class'X2StrategyElement_DefaultStaffSlots'.static.GetAvengerBonusDefault;
	Template.GetNameDisplayStringFn = class'X2StrategyElement_DefaultStaffSlots'.static.GetNameDisplayStringDefault;
	Template.GetSkillDisplayStringFn = class'X2StrategyElement_DefaultStaffSlots'.static.GetSkillDisplayStringDefault;
	Template.GetBonusDisplayStringFn = class'X2StrategyElement_DefaultStaffSlots'.static.GetBonusDisplayStringDefault;
	Template.GetLocationDisplayStringFn = GetOutpostLiaisonLocationDisplayString;
	Template.IsUnitValidForSlotFn = class'X2StrategyElement_DefaultStaffSlots'.static.IsUnitValidForSlotDefault;
	Template.IsStaffSlotBusyFn = class'X2StrategyElement_DefaultStaffSlots'.static.IsStaffSlotBusyDefault;
    Template.CanStaffBeMovedFn = CanLiaisonBeMoved;

    return Template;
}

static function FillOutpostLiaison(XComGameState NewGameState, StateObjectReference SlotRef, StaffUnitInfo UnitInfo, optional bool bTemporary = false)
{
    local XComGameState_Unit Unit;

    // Use the basic fill routine to do the assignment to the unit
    class'X2StrategyElement_DefaultStaffSlots'.static.FillSlotDefault(NewGameState, SlotRef, UnitInfo);

    Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitInfo.UnitRef.ObjectID));

    // if this is a soldier, we also need to set their current state to 'OnMission'.
    if (Unit.IsSoldier())
    {
        Unit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', Unit.ObjectID));
        NewGameState.AddStateObject(Unit);
        class'LWDLCHelpers'.static.SetOnMissionStatus(Unit, NewGameState);
    }
}

static function EmptyOutpostLiaison(XComGameState NewGameState, StateObjectReference SlotRef)
{
    local XComGameState_Unit Unit;
    local XComGameState_StaffSlot NewStaffSlot;

    // Use the basic fill routine to do the emptying. Be sure to get back any updated unit state object for the unit that just
    // vacated.
    class'X2StrategyElement_DefaultStaffSlots'.static.EmptySlot(NewGameState, SlotRef, NewStaffSlot, Unit);

    // If this is a soldier, we also need to set their current state to 'Active'.
    if (Unit != none && Unit.IsSoldier())
    {
        Unit.SetStatus(eStatus_Active);
    }
}

static function String GetOutpostLiaisonLocationDisplayString(XComGameState_StaffSlot SlotState)
{
    local XComGameState_LWOutpost Outpost;
    local XComGameState_WorldRegion WorldRegion;
    local XComGameState_LWOutpostManager OutpostMgr;
    local XGParamTag LocTag;


    OutpostMgr = `LWOUTPOSTMGR;

    Outpost = OutpostMgr.GetOutpostForStaffSlot(SlotState.GetReference());
    WorldRegion = OutpostMgr.GetRegionForOutpost(Outpost);

    LocTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
    LocTag.StrValue0 = WorldRegion.GetDisplayName();
    return `XEXPAND.ExpandString(default.m_strLiaisonLocation);
}

static function bool CanLiaisonBeMoved(StateObjectReference StaffRef)
{
    local StateObjectReference LiaisonRef;
    local XComGameState_StaffSlot StaffSlot;
    local XComGameState_LWOutpostManager OutpostMgr;
    local XComGameState_WorldRegion WorldRegion;
    local XComGameState_LWOutpost Outpost;

    StaffSlot = XComGameState_StaffSlot(`XCOMHISTORY.GetGameStateForObjectID(StaffRef.ObjectID));
    if (StaffSlot.IsSlotEmpty())
    {
        return true;
    }

    OutpostMgr = `LWOUTPOSTMGR;
    LiaisonRef = StaffSlot.GetAssignedStaffRef();
    WorldRegion = OutpostMgr.GetRegionForLiaison(LiaisonRef);
    Outpost = OutpostMgr.GetOutpostForRegion(WorldRegion);
    return Outpost.CanLiaisonBeMoved();
}

static function X2DataTemplate CreateLaboratory_AdditionalResearchStation2Template()
{
    local X2FacilityUpgradeTemplate Template, DefaultTemplate;
	local X2StrategyElementTemplate StratTemplate;
    local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2FacilityUpgradeTemplate', Template, 'Laboratory_AdditionalResearchStation2');
    Template.PointsToComplete = 0;
    Template.MaxBuild = 1;
    Template.strImage = "img:///UILibrary_StrategyImages.FacilityIcons.ChooseFacility_Laboratory_AdditionalResearchStation";
    Template.OnUpgradeAddedFn = class'X2StrategyElement_DefaultFacilityUpgrades'.static.OnUpgradeAdded_UnlockStaffSlot;
    Template.iPower = -3;
    Template.UpkeepCost = 40;
    Resources.ItemTemplateName = 'Supplies';
    Resources.Quantity = 125;
    Template.Cost.ResourceCosts.AddItem(Resources);
	// WOTCO TODO: Move this out of CreateTemplates. Maybe into LWTemplateMods
	// StratTemplate = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager().FindStrategyElementTemplate('Laboratory_AdditionalResearchStation');
	DefaultTemplate = X2FacilityUpgradeTemplate(StratTemplate);
	Template.DisplayName = DefaultTemplate.default.DisplayName;
	Template.FacilityName = DefaultTemplate.default.FacilityName;
	Template.Summary = DefaultTemplate.default.Summary;
    return Template;
}

static function X2DataTemplate CreateLaboratory_AdditionalResearchStation3Template()
{
    local X2FacilityUpgradeTemplate Template, DefaultTemplate;
	local X2StrategyElementTemplate StratTemplate;
    local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2FacilityUpgradeTemplate', Template, 'Laboratory_AdditionalResearchStation3');
    Template.PointsToComplete = 0;
    Template.MaxBuild = 1;
    Template.strImage = "img:///UILibrary_StrategyImages.FacilityIcons.ChooseFacility_Laboratory_AdditionalResearchStation";
    Template.OnUpgradeAddedFn = class'X2StrategyElement_DefaultFacilityUpgrades'.static.OnUpgradeAdded_UnlockStaffSlot;
    Template.iPower = -3;
    Template.UpkeepCost = 40;
    Resources.ItemTemplateName = 'Supplies';
    Resources.Quantity = 125;
    Template.Cost.ResourceCosts.AddItem(Resources);
	// WOTCO TODO: Move this out of CreateTemplates. Maybe into LWTemplateMods
	// StratTemplate = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager().FindStrategyElementTemplate('Laboratory_AdditionalResearchStation');
	DefaultTemplate = X2FacilityUpgradeTemplate(StratTemplate);
	Template.DisplayName = DefaultTemplate.default.DisplayName;
	Template.FacilityName = DefaultTemplate.default.FacilityName;
	Template.Summary = DefaultTemplate.default.Summary;
    return Template;
}