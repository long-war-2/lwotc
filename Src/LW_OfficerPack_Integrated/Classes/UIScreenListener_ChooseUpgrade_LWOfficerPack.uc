//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_ChooseUpgrade_LWOfficerPack.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//
//  PURPOSE: Fixed display defects in OTS facility upgrade
//--------------------------------------------------------------------------------------- 

class UIScreenListener_ChooseUpgrade_LWOfficerPack extends UIScreenListener;

var UIChooseUpgrade ParentScreen;

// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
	local XComGameState_FacilityXCom Facility;

	`Log("LW OfficerPack (ChooseUpgrade): Starting OnInit");

	ParentScreen = UIChooseUpgrade(Screen);
	Facility = XComGameState_FacilityXCom(`XCOMHISTORY.GetGameStateForObjectID(ParentScreen.m_FacilityRef.ObjectID));

	// only update OTS
	if (Facility.GetMyTemplateName() == 'OfficerTrainingSchool')
	{
		`Log("LW OfficerPack (ChooseUpgrade): Adjusting OfficerTrainingSchool");
		//reset the UpdateSelection delegate to local version
		ParentScreen.m_List.OnSelectionChanged = UpdateSelection;
		//force refresh of selection
		UpdateSelection(ParentScreen.m_List, 0);
		//ParentScreen.PopulateList();
	}
}

// This event is triggered when a screen is removed
event OnRemoved(UIScreen Screen)
{
	//clear reference to UIScreen so it can be garbage collected
	ParentScreen = none;
}

// Copied from UIChooseUpgrade.uc
simulated function UpdateSelection(UIList list, int itemIndex)
{
	local int power;
	local string Summary, Requirements, StratReqs, InsufficientResourcesWarning, DividerHTML, UpkeepCostStr;
	local bool HasPower, AlreadyUpgraded;

	DividerHTML = "<font color='#546f6f'> | </font>";
	
	ParentScreen.SelectedIndex = itemIndex;
	ParentScreen.m_selectedUpgrade = ParentScreen.m_arrUpgrades[ParentScreen.SelectedIndex];
	HasPower = ParentScreen.HasEnoughPower(ParentScreen.m_selectedUpgrade); 
	AlreadyUpgraded = ParentScreen.UpgradeAlreadyPerformed(ParentScreen.m_selectedUpgrade);

	// Supplies Requirement
	Requirements $= class'UIUtilities_Strategy'.static.GetStrategyCostString(ParentScreen.m_selectedUpgrade.Cost, `XCOMHQ.FacilityBuildCostScalars);

	// Power Requirement
	Requirements $= DividerHTML;
	power = ParentScreen.GetPowerRequirement(ParentScreen.m_selectedUpgrade);
	if (HasPower || AlreadyUpgraded)
	{
		if (power >= 0) //Building a power generator, or facility on top of a power coil
			Requirements $= class'UIUtilities_Text'.static.InjectImage("power_icon") $ class'UIUtilities_Text'.static.GetColoredText(string(power), eUIState_Good);
		else
			Requirements $= class'UIUtilities_Text'.static.InjectImage("power_icon") $ class'UIUtilities_Text'.static.GetColoredText(string(int(Abs(power))), eUIState_Warning);
	}
	else
	{
		Requirements $= class'UIUtilities_Text'.static.InjectImage("power_icon_warning") $ class'UIUtilities_Text'.static.GetColoredText(string(int(Abs(power))), eUIState_Warning);
	}
	
	// All other strategy requirements
	StratReqs = class'UIUtilities_Strategy'.static.GetStrategyReqString(ParentScreen.m_selectedUpgrade.Requirements);
	if (StratReqs != "")
	{
		Requirements $= DividerHTML;
		Requirements $= StratReqs;
	}

	if (!HasPower && !AlreadyUpgraded)
	{
		if (InsufficientResourcesWarning != "")
			InsufficientResourcesWarning $= ", ";

		InsufficientResourcesWarning @= class'UIUtilities_Text'.static.GetColoredText(ParentScreen.m_strInsufficientPowerWarning, eUIState_Bad);
	}
	

	Summary = ParentScreen.m_selectedUpgrade.Summary;

	if (ParentScreen.m_selectedUpgrade.UpkeepCost > 0)
	{
		UpkeepCostStr = ParentScreen.m_strUpkeepCostLabel @ class'UIUtilities_Strategy'.default.m_strCreditsPrefix $ ParentScreen.m_selectedUpgrade.UpkeepCost;
		UpkeepCostStr = class'UIUtilities_Text'.static.GetColoredText(UpkeepCostStr, eUIState_Warning);
		Summary $= "\n" $ UpkeepCostStr;
	}

	if(Summary == "")
		Summary = "Missing 'strSummary' for facility template '" $ ParentScreen.m_selectedUpgrade.DataName $ "'.";

	ParentScreen.AS_SetDescription(Summary, InsufficientResourcesWarning);
	ParentScreen.AS_SetResources(Requirements, "");
}

defaultproperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = UIChooseUpgrade;
}