//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_FacilityUpgrade_LWOfficerPack.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//
//  PURPOSE: Fixed display defects in OTS facility upgrade
//--------------------------------------------------------------------------------------- 

class UIScreenListener_FacilityUpgrade_LWOfficerPack extends UIScreenListener;

var string PathToParentScreen;
//var UIFacilityUpgrade ParentScreen;

// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
	local string strTitle;
	local UIText TextComponent;
	local UIFacilityUpgrade_ListItem ListItem;
	local UIFacilityUpgrade ParentScreen;

	ParentScreen = UIFacilityUpgrade(Screen);

	PathToParentScreen = PathName(ParentScreen);

	// only update OTS
	if (ParentScreen.GetFacility().GetMyTemplateName() == 'OfficerTrainingSchool')
	{
		// reduce size of title text from 50 to 46 so it doesn't extend off edge
		strTitle =  `XEXPAND.ExpandString(ParentScreen.m_strTitle);
		TextComponent = GetTextChild();
		TextComponent.SetTitle(class'UIUtilities_Text'.static.GetColoredText(strTitle, EUIState_Normal, 46));

		ParentScreen.m_kList.OnSelectionChanged = RefreshInfoPanel; 

		ListItem = UIFacilityUpgrade_ListItem(ParentScreen.m_kList.GetItem(0));
		UpdateListItemData(ListItem);
		PopulateUpgradeCard(ListItem.UpgradeTemplate, ListItem.FacilityRef);
	}

}

private function UIFacilityUpgrade GetParentScreen()
{   
    local UIFacilityUpgrade ParentScreen;

    if (PathToParentScreen != "")
    {
        ParentScreen = UIFacilityUpgrade(FindObject(PathToParentScreen, class'UIFacilityUpgrade'));
        if (ParentScreen != none)
        {
            return ParentScreen;
        }
    }

    ParentScreen = UIFacilityUpgrade(FindObject(PathToParentScreen, class'UIFacilityUpgrade'));
    return ParentScreen;
}


// This event is triggered after a screen receives focus
event OnReceiveFocus(UIScreen Screen)
{
	local string strTitle;
	local UIText TextComponent;
	local UIFacilityUpgrade_ListItem ListItem;

	local UIFacilityUpgrade ParentScreen;
	ParentScreen = GetParentScreen();

	// only update OTS
	if (ParentScreen.GetFacility().GetMyTemplateName() == 'OfficerTrainingSchool')
	{
		// reduce size of title text from 50 to 46 so it doesn't extend off edge
		strTitle =  `XEXPAND.ExpandString(ParentScreen.m_strTitle);
		TextComponent = GetTextChild();
		TextComponent.SetTitle(class'UIUtilities_Text'.static.GetColoredText(strTitle, EUIState_Normal, 46));

		ParentScreen.m_kList.OnSelectionChanged = RefreshInfoPanel; 

		ListItem = UIFacilityUpgrade_ListItem(ParentScreen.m_kList.GetItem(0));
		UpdateListItemData(ListItem);
		PopulateUpgradeCard(ListItem.UpgradeTemplate, ListItem.FacilityRef);
	}
}

// This event is triggered after a screen loses focus
//event OnLoseFocus(UIScreen Screen);

// This event is triggered when a screen is removed
event OnRemoved(UIScreen Screen)
{
	//clear reference to UIScreen so it can be garbage collected
	PathToParentScreen = "";
}

function UIText GetTextChild()
{
	local array<UIPanel> TextChildren;
	local UIFacilityUpgrade ParentScreen;

	ParentScreen = GetParentScreen();

	ParentScreen.m_kContainer.GetChildrenOfType(class'UIText', TextChildren);
	return UIText(TextChildren[0]);
}

simulated function UpdateListItemData(UIFacilityUpgrade_ListItem ListItem)
{	
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_FacilityXCom FacilityState;
	local StrategyRequirement Requirement;
	local string StatusText;
	local bool CanBuild, HasPower;

	Requirement = ListItem.UpgradeTemplate.Requirements;

	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
	FacilityState = XComGameState_FacilityXCom(`XCOMHISTORY.GetGameStateForObjectID(ListItem.FacilityRef.ObjectID));

	ListItem.m_kName.SetText(Caps(ListItem.UpgradeTemplate.DisplayName));
	//m_kDescription.SetText(UpgradeTemplate.Summary);

	CanBuild = XComHQ.MeetsRequirmentsAndCanAffordCost(Requirement, ListItem.UpgradeTemplate.Cost, XComHQ.FacilityUpgradeCostScalars);
	
	if (ListItem.UpgradeTemplate.iPower >= 0 || FacilityState.GetRoom().HasShieldedPowerCoil())
		HasPower = true;
	else
		HasPower = ((XComHQ.GetPowerConsumed() - ListItem.UpgradeTemplate.iPower) <= XComHQ.GetPowerProduced());
	
	if (HasPower)
		StatusText = class'UIUtilities_Strategy'.static.GetStrategyCostString(ListItem.UpgradeTemplate.Cost, XComHQ.FacilityUpgradeCostScalars);
	else
		StatusText = class'UIUtilities_Text'.static.GetColoredText(ListItem.m_strNoPower, eUIState_Bad);

	StatusText $= "<font color='#546f6f'> | </font>"; //HTML Divider

	if (XComHQ.MeetsSoldierGates(Requirement.RequiredHighestSoldierRank, Requirement.RequiredSoldierClass, Requirement.RequiredSoldierRankClassCombo))
		StatusText $= class'UIUtilities_Text'.static.GetColoredText(class'UIUtilities_Strategy'.static.GetStrategyReqString(ListItem.UpgradeTemplate.Requirements), eUIState_Good);
	else 
		StatusText $= class'UIUtilities_Text'.static.GetColoredText(class'UIUtilities_Strategy'.static.GetStrategyReqString(ListItem.UpgradeTemplate.Requirements), eUIState_Bad);

	ListItem.m_kStatus.SetText(StatusText);

	if(!CanBuild || !HasPower)
	{
		ListItem.SetDisabled(true);
	}
	else
	{
		ListItem.SetDisabled(false);
	}
}

simulated function RefreshInfoPanel(UIList ContainerList, int ItemIndex)
{
	PopulateUpgradeCard(UIFacilityUpgrade_ListItem(ContainerList.GetItem(ItemIndex)).UpgradeTemplate, UIFacilityUpgrade(FindObject(PathToParentScreen, class'UIFacilityUpgrade')).FacilityRef);
}

simulated function PopulateUpgradeCard(X2FacilityUpgradeTemplate UpgradeTemplate, StateObjectReference FacilityRef)
{
	local XComGameState_FacilityXCom Facility;
	local string strDesc, strTitle, strRequirements, strImage, strUpkeep;

	local UIFacilityUpgrade ParentScreen;

	ParentScreen = GetParentScreen();

	if( UpgradeTemplate == None )
	{
		ParentScreen.ItemCard.Hide();
		return;
	}

	//ParentScreen.ItemCard.bWaitingForImageUpdate = false;

	Facility = XComGameState_FacilityXCom(`XCOMHISTORY.GetGameStateForObjectID(FacilityRef.ObjectID));
	
	strTitle = UpgradeTemplate.DisplayName;

	strDesc = UpgradeTemplate.Summary $"\n";

	strImage = UpgradeTemplate.strImage;

	strRequirements = class'UIUtilities_Strategy'.static.GetStrategyCostString(UpgradeTemplate.Cost, `XCOMHQ.FacilityUpgradeCostScalars);
	
	strRequirements $= "<font color='#546f6f'> | </font>"; //HTML Divider

	// Add Power requirement
	if (UpgradeTemplate.iPower >= 0) //Building a power generator upgrade
		strRequirements $= class'UIUtilities_Text'.static.InjectImage("power_icon") $ class'UIUtilities_Text'.static.GetColoredText(string(UpgradeTemplate.iPower), eUIState_Good);
	else if (Facility.GetRoom().HasShieldedPowerCoil()) // Or building upgrade on top of a power coil
		strRequirements $= class'UIUtilities_Text'.static.InjectImage("power_icon") $ class'UIUtilities_Text'.static.GetColoredText("0", eUIState_Good);
	else
		strRequirements $= class'UIUtilities_Text'.static.InjectImage("power_icon") $ class'UIUtilities_Text'.static.GetColoredText(string(int(Abs(UpgradeTemplate.iPower))), eUIState_Warning);
	
	strRequirements $= "<font color='#546f6f'> | </font>"; //HTML Divider

	//strRequirements $= class'UIUtilities_Strategy'.static.GetStrategyReqString(UpgradeTemplate.Requirements);
	if (`XCOMHQ.MeetsSoldierGates(UpgradeTemplate.Requirements.RequiredHighestSoldierRank, UpgradeTemplate.Requirements.RequiredSoldierClass, UpgradeTemplate.Requirements.RequiredSoldierRankClassCombo))
		strRequirements $= class'UIUtilities_Text'.static.GetColoredText(class'UIUtilities_Strategy'.static.GetStrategyReqString(UpgradeTemplate.Requirements), eUIState_Good);
	else 
		strRequirements $= class'UIUtilities_Text'.static.GetColoredText(class'UIUtilities_Strategy'.static.GetStrategyReqString(UpgradeTemplate.Requirements), eUIState_Bad);

	if (UpgradeTemplate.UpkeepCost > 0)
	{
		strUpkeep = ParentScreen.ItemCard.m_strUpkeepCostLabel @ class'UIUtilities_Strategy'.default.m_strCreditsPrefix $ UpgradeTemplate.UpkeepCost;
		strUpkeep = class'UIUtilities_Text'.static.GetColoredText(strUpkeep, eUIState_Warning);
		strDesc $= "\n" $ strUpkeep;
	}

	ParentScreen.ItemCard.PopulateData(strTitle, strDesc, strRequirements, strImage);
}

defaultproperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = UIFacilityUpgrade;
}