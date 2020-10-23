//---------------------------------------------------------------------------------------
//  FILE:    UIAlert_LWOfficerTrainingComplete.uc 
//  AUTHOR:  Amineri
//  PURPOSE: Customized UI Alert for Officer training 
//---------------------------------------------------------------------------------------
class UIAlert_LWOfficerTrainingComplete extends UIAlert;

// Override for UIAlert child to trigger specific Alert built in this class
simulated function BuildAlert()
{
	BindLibraryItem();
	BuildOfficerTrainingCompleteAlert();
}

// New Alert building function
simulated function BuildOfficerTrainingCompleteAlert()
{
	local string AbilityIcon, AbilityName, AbilityDescription, ClassIcon, ClassName, RankName;
	local X2AbilityTemplate TrainedAbilityTemplate;
	local X2AbilityTemplateManager AbilityTemplateManager;
	local XComGameState_ResistanceFaction FactionState;
	local XComGameState_Unit UnitState;
	local XComGameState_Unit_LWOfficer OfficerState;
	
	if (LibraryPanel == none)
	{
		`RedScreen("UI Problem with the alerts! Couldn't find LibraryPanel for current eAlertType: " $ eAlertName);
		return;
	}

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(class'X2StrategyGameRulesetDataStructures'.static.GetDynamicIntProperty(DisplayPropertySet, 'UnitRef')));
	OfficerState =  class'LWOfficerUtilities'.static.GetOfficerComponent(UnitState);

	ClassName = "";
	ClassIcon = class'LWOfficerUtilities'.static.GetRankIcon(OfficerState.GetOfficerRank());
	RankName = Caps(class'LWOfficerUtilities'.static.GetLWOfficerRankName(OfficerState.GetOfficerRank()));
	
	FactionState = UnitState.GetResistanceFaction();
	
	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	TrainedAbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(OfficerState.LastAbilityTrainedName);

	// Ability Name
	AbilityName = TrainedAbilityTemplate.LocFriendlyName != "" ? TrainedAbilityTemplate.LocFriendlyName : ("Missing 'LocFriendlyName' for ability '" $ TrainedAbilityTemplate.DataName $ "'");

	// Ability Description
	AbilityDescription = TrainedAbilityTemplate.HasLongDescription() ? TrainedAbilityTemplate.GetMyLongDescription() : ("Missing 'LocLongDescription' for ability " $ TrainedAbilityTemplate.DataName $ "'");
	AbilityIcon = TrainedAbilityTemplate.IconImage;

	`Log("Attempting to generate alert panel for " $ UnitState.GetName(eNameType_FullNick) $ " - " $ RankName $ ", " $ OfficerState.LastAbilityTrainedName);
	`Log("Ability = " $ AbilityName $ ", Class Icon = " $ ClassIcon $ ", Ability Description = " $ AbilityDescription);
	
	// Send over to flash
	LibraryPanel.MC.BeginFunctionOp("UpdateData");
	LibraryPanel.MC.QueueString(m_strTrainingCompleteLabel);
	LibraryPanel.MC.QueueString(""); 
	LibraryPanel.MC.QueueString(ClassIcon);
	LibraryPanel.MC.QueueString(RankName);
	LibraryPanel.MC.QueueString(UnitState.GetName(eNameType_FullNick));
	LibraryPanel.MC.QueueString(ClassName);
	LibraryPanel.MC.QueueString(AbilityIcon);
	LibraryPanel.MC.QueueString(m_strNewAbilityLabel);
	LibraryPanel.MC.QueueString(AbilityName);
	LibraryPanel.MC.QueueString(AbilityDescription);
	LibraryPanel.MC.QueueString(m_strViewSoldier);
	LibraryPanel.MC.QueueString(m_strCarryOn);
	LibraryPanel.MC.EndOp();
	GetOrStartWaitingForStaffImage();  // WOTC: Moved from 2nd QueueString to here for unknown reasons.
	
	// KDM : The call to OnTrainingButtonRealized() places the buttons on top of each other in terms of X.
	// 1.] Controller code places the buttons above/below each other in terms of Y; therefore, this is ok.
	// 2.] Mouse & keyboard code places the buttons at the same Y location; therefore, they will overlap one another.
	// The solution for mouse & keyboard users is to simply ignore this code and let ActionScript place them correctly.
	if (`ISCONTROLLERACTIVE)
	{
		Button1.OnSizeRealized = OnTrainingButtonRealized;
		Button2.OnSizeRealized = OnTrainingButtonRealized;
	}

	// Hide "View Soldier" button if player is on top of avenger, prevents ui state stack issues
	if (Movie.Pres.ScreenStack.IsInStack(class'UIArmory_LWOfficerPromotion'))
	{
		Button1.Hide();
		Button1.DisableNavigation();
	}
	
	if (FactionState != none)
	{
		SetFactionIcon(FactionState.GetFactionIcon());
	}
}

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	if (!CheckInputIsReleaseOrDirectionRepeat(cmd, arg))
	{
		return false;
	}

	// KDM : OnUnrealCommand() was not set up properly for this particular alert, which uses eAlertName == 'eAlert_TrainingComplete';
	// previously, both the A button and the B button called OnCancelClicked().
	if ((cmd == class'UIUtilities_Input'.const.FXS_BUTTON_A) && Button1.bIsVisible)
	{
		// KDM : Views the soldier via the officer promotion screen.
		OnConfirmClicked(none);
		return true;
	}
	else if ((cmd == class'UIUtilities_Input'.const.FXS_BUTTON_B) && Button2.bIsVisible)
	{
		// KDM : Closes the screen.
		OnCancelClicked(none);
		return true;
	}

	return super.OnUnrealCommand(cmd, arg);
}
