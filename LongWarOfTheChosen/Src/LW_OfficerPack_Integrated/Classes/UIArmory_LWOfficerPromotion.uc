//---------------------------------------------------------------------------------------
//  FILE:    UIArmory_LWOfficerPromotion 
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Tweaked ability selection UI for LW officer system
//--------------------------------------------------------------------------------------- 

class UIArmory_LWOfficerPromotion extends UIArmory_Promotion config(LW_OfficerPack);

var config bool ALWAYSSHOW;
var config bool ALLOWTRAININGINARMORY;
var config bool INSTANTTRAINING;

var UIButton LeadershipButton;

var localized string strLeadershipButton;
var localized string strLeadershipDialogueTitle;
var localized string strLeadershipDialogueData;

// KDM : -1 = unset, 0 = false, 1 = true
var int AbilityInfoTipIsShowing, SelectAbilityTipIsShowing;

simulated function InitPromotion(StateObjectReference UnitRef, optional bool bInstantTransition)
{
	// If the AfterAction screen is running, let it position the camera
	AfterActionScreen = UIAfterAction(Movie.Stack.GetScreen(class'UIAfterAction'));
	if (AfterActionScreen != none)
	{
		bAfterActionPromotion = true;
		PawnLocationTag = AfterActionScreen.GetPawnLocationTag(UnitRef);
		CameraTag = AfterActionScreen.GetPromotionBlueprintTag(UnitRef);
		DisplayTag = name(AfterActionScreen.GetPromotionBlueprintTag(UnitRef));
	}
	else
	{
		CameraTag = GetPromotionBlueprintTag(UnitRef);
		DisplayTag = name(GetPromotionBlueprintTag(UnitRef));
	}
	
	// Don't show nav help during tutorial, or during the After Action sequence.
	bUseNavHelp = class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('T0_M2_WelcomeToArmory') || Movie.Pres.ScreenStack.IsInStack(class'UIAfterAction');

	super(UIArmory).InitArmory(UnitRef,,,,,, bInstantTransition);

	List = Spawn(class'UIList', self);
	List.bAutosizeItems = false;
	List.bStickyHighlight = false;
	List.OnSelectionChanged = PreviewRow;
	List.InitList('', 58, 170, 630, 700);
	
	LeadershipButton = Spawn(class'UIButton', self);
	// KDM : Make the Leadership button a hotlink when using a controller.
	LeadershipButton.InitButton(, strLeadershipButton, ViewLeadershipStats, eUIButtonStyle_HOTLINK_BUTTON);
	// KDM : Add the gamepad icon, right stick click, when a controller is in use.
	LeadershipButton.SetGamepadIcon(class'UIUtilities_Input'.const.ICON_RSCLICK_R3);
	LeadershipButton.SetPosition(58, 971);

	// KDM : Set up the navigator; ClassRowItem is not used for officers, so we can safely ignore it.
	Navigator.Clear();
	Navigator.LoopSelection = false;
	Navigator.AddControl(List);
	Navigator.SetSelected(List);

	PopulateData();

	MC.FunctionVoid("animateIn");
}

simulated function bool CanUnitEnterOTSTraining(XComGameState_Unit Unit)
{
	local StaffUnitInfo UnitInfo;
	local XComGameState_StaffSlot StaffSlotState;

	UnitInfo.UnitRef = Unit.GetReference();

	if (`SCREENSTACK.IsInStack(class'UIFacility_Academy'))
	{
		return true;
	}
	StaffSlotState = GetEmptyOfficerTrainingStaffSlot();
	if (StaffSlotState != none && 
		class'X2StrategyElement_LW_OTS_OfficerStaffSlot'.static.IsUnitValidForOTSOfficerSlot(StaffSlotState, UnitInfo)) 
	{
		return true;
	}

	return false;
}

simulated function PopulateData()
{
	local bool bHasAbility1, bHasAbility2, DisplayOnly;
	local int i, MaxRank, RankToPromote, SelectionIndex;
	local string AbilityIcon1, AbilityIcon2, AbilityName1, AbilityName2, HeaderString;
	local UIArmory_LWOfficerPromotionItem Item;
	local X2AbilityTemplate AbilityTemplate1, AbilityTemplate2;
	local X2AbilityTemplateManager AbilityTemplateManager;
	local XComGameState_Unit Unit;
	local XComGameState_Unit_LWOfficer OfficerState;
	
	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	Unit = GetUnit();
	DisplayOnly = !CanUnitEnterOTSTraining(Unit);
	MaxRank = class'LWOfficerUtilities'.static.GetMaxRank();
	SelectionIndex = INDEX_NONE;

	if (default.ALLOWTRAININGINARMORY)
	{
		DisplayOnly = false;
	}

	// Differentiate header based on whether we are in the Armory or the OTS Facility.
	if (DisplayOnly)
	{
		HeaderString = m_strAbilityHeader;
	} 
	else
	{
		HeaderString = m_strSelectAbility;
	}

	// Clear left and right ability titles
	AS_SetTitle("", HeaderString, "", "", "");

	// Init but then hide the first row, since it's set up for both class and single ability
	if (ClassRowItem == none)
	{
		ClassRowItem = Spawn(class'UIArmory_PromotionItem', self);
		ClassRowItem.MCName = 'classRow';
		ClassRowItem.InitPromotionItem(0);
	}
	ClassRowItem.Hide();

	// Core, non-selectable, officer abilities are shown as the list's 1st row; these are "Leadership" and "Command".
	Item = UIArmory_LWOfficerPromotionItem(List.GetItem(0));
	if (Item == none)
	{
		Item = UIArmory_LWOfficerPromotionItem(List.CreateItem(class'UIArmory_LWOfficerPromotionItem'));
		Item.InitPromotionItem(0);
	}

	Item.Rank = 1;
	Item.SetRankData(class'LWOfficerUtilities'.static.GetRankIcon(1), Caps(class'LWOfficerUtilities'.static.GetLWOfficerRankName(1)));
	
	AbilityTemplate1 = AbilityTemplateManager.FindAbilityTemplate(class'LWOfficerUtilities'.default.OfficerAbilityTree[0].AbilityName);
	AbilityName1 = Caps(AbilityTemplate1.LocFriendlyName);
	AbilityIcon1 = AbilityTemplate1.IconImage;
	Item.AbilityName1 = AbilityTemplate1.DataName;
	
	AbilityTemplate2 = AbilityTemplateManager.FindAbilityTemplate(class'LWOfficerUtilities'.default.OfficerAbilityTree[1].AbilityName);
	AbilityName2 = Caps(AbilityTemplate2.LocFriendlyName);
	AbilityIcon2 = AbilityTemplate2.IconImage;
	Item.AbilityName2 = AbilityTemplate2.DataName;
	
	Item.SetAbilityData(AbilityIcon1, AbilityName1, AbilityIcon2, AbilityName2);
	Item.SetEquippedAbilities(true, true);
	Item.SetPromote(false);
	Item.SetDisabled(false);
	Item.RealizeVisuals();
		
	// Show the rest of the officer rows; these will have the officer's selectable abilities.
	for (i = 1; i <= MaxRank; ++i)
	{
		Item = UIArmory_LWOfficerPromotionItem(List.GetItem(i));
		if (Item == none)
		{
			Item = UIArmory_LWOfficerPromotionItem(List.CreateItem(class'UIArmory_LWOfficerPromotionItem'));
			Item.InitPromotionItem(i);
		}
		
		Item.Rank = i;
		Item.SetRankData(class'LWOfficerUtilities'.static.GetRankIcon(Item.Rank), Caps(class'LWOfficerUtilities'.static.GetLWOfficerRankName(Item.Rank)));

		AbilityTemplate1 = AbilityTemplateManager.FindAbilityTemplate(class'LWOfficerUtilities'.static.GetAbilityName(Item.Rank, 0));
		AbilityTemplate2 = AbilityTemplateManager.FindAbilityTemplate(class'LWOfficerUtilities'.static.GetAbilityName(Item.Rank, 1));
		
		OfficerState = class'LWOfficerUtilities'.static.GetOfficerComponent(Unit);
		if (OfficerState != none)
		{
			// KDM : Determines if the officer already has either of these abilities.
			bHasAbility1 = OfficerState.HasOfficerAbility(AbilityTemplate1.DataName);
			bHasAbility2 = OfficerState.HasOfficerAbility(AbilityTemplate2.DataName);
		}
		
		// KDM : Determines which row of officer abilites is the current promotion row.
		if (DisplayOnly)
		{
			RankToPromote = -1;
		} 
		else if (OfficerState == none) 
		{
			RankToPromote = 1;
		}
		else
		{
			RankToPromote = OfficerState.GetOfficerRank() + 1;
		}

		// Left side ability
		if (AbilityTemplate1 != none)
		{
			Item.AbilityName1 = AbilityTemplate1.DataName;
			// KDM : Determines whether we show the ability name and icon, or an unknown ability name and icon.
			if (default.ALWAYSSHOW || class'XComGameState_LWPerkPackOptions'.static.IsViewLockedStatsEnabled() || Item.Rank <= OfficerState.GetOfficerRank() || 
				(!DisplayOnly && Item.Rank == RankToPromote))
			{
				AbilityName1 = Caps(AbilityTemplate1.LocFriendlyName);
				AbilityIcon1 = AbilityTemplate1.IconImage;
			} 
			else
			{
				AbilityName1 = class'UIUtilities_Text'.static.GetColoredText(m_strAbilityLockedTitle, eUIState_Disabled);
				AbilityIcon1 = class'UIUtilities_Image'.const.UnknownAbilityIcon;
			}
		}

		// Right side ability
		if (AbilityTemplate2 != none)
		{
			Item.AbilityName2 = AbilityTemplate2.DataName;
			// KDM : Determines whether we show the ability name and icon, or an unknown ability name and icon.
			if (default.ALWAYSSHOW || class'XComGameState_LWPerkPackOptions'.static.IsViewLockedStatsEnabled()  || Item.Rank <= OfficerState.GetOfficerRank() || 
				(!DisplayOnly && Item.Rank == RankToPromote))
			{
				AbilityName2 = Caps(AbilityTemplate2.LocFriendlyName);
				AbilityIcon2 = AbilityTemplate2.IconImage;
			}
			else
			{
				AbilityName2 = class'UIUtilities_Text'.static.GetColoredText(m_strAbilityLockedTitle, eUIState_Disabled);
				AbilityIcon2 = class'UIUtilities_Image'.const.UnknownAbilityIcon;
			}
		}

		Item.SetAbilityData(AbilityIcon1, AbilityName1, AbilityIcon2, AbilityName2);
		Item.SetEquippedAbilities(bHasAbility1, bHasAbility2);

		// KDM : If this is the promotion row, highlight it as such; this row will also be given initial focus.
		if (Item.Rank == RankToPromote)
		{
			Item.SetPromote(true);
			SelectionIndex = i;
		}
		else
		{
			Item.SetPromote(false);
		}

		if ((Item.Rank <= OfficerState.GetOfficerRank()) || (Item.Rank == RankToPromote) || default.ALWAYSSHOW || 
			class'XComGameState_LWPerkPackOptions'.static.IsViewLockedStatsEnabled())
		{
			Item.SetDisabled(false);
		}
		else
		{
			Item.SetDisabled(true);
		}

		Item.RealizeVisuals();
	}

	// Update ability summary at the bottom
	PopulateAbilitySummary(Unit);

	// KDM : If there was no promotion row, select the highest ranking row the officer has attained.
	if (SelectionIndex == INDEX_NONE)
	{
		SelectionIndex = OfficerState.GetOfficerRank();
	}
	
	// KDM : Whenever list selection is changed, PreviewRow() is called, due to the setting of OnSelectionChanged within InitPromotion().
	// The parameter, bForce, is set to true so that PreviewRow() is called regardless of the list's previously selected index.
	// This matters when the next/previous soldier button is clicked, with the 2 soldiers having the same rank and, thus, SelectionIndex.
	List.SetSelectedIndex(SelectionIndex, true);

	UpdateNavHelp();
}

simulated function PopulateAbilitySummary(XComGameState_Unit Unit)
{
	local int i, Index;
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityTemplateManager AbilityTemplateManager;
	local XComGameState_Unit_LWOfficer OfficerState;

	`Log("Populating ability summary for " $ Unit.GetName(eNameType_Full));

	Movie.Pres.m_kTooltipMgr.RemoveTooltipsByPartialPath(string(MCPath) $ ".abilitySummaryList");

	OfficerState = class'LWOfficerUtilities'.static.GetOfficerComponent(Unit);
	if (OfficerState == none || OfficerState.GetOfficerRank() == 0)
	{
		MC.FunctionVoid("hideAbilityList");
		return;
	}

	MC.FunctionString("setSummaryTitle", class'UIScreenListener_Armory_Promotion_LWOfficerPack'.default.strOfficerMenuOption);

	// Populate ability list (multiple param function call: image then title then description)
	MC.BeginFunctionOp("setAbilitySummaryList");

	Index = 0;

	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	`Log("Soldier has " $ OfficerState.OfficerAbilities.Length $ " officer abilities");
	for (i = 0; i < OfficerState.OfficerAbilities.Length; ++i)
	{
		AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(OfficerState.OfficerAbilities[i].AbilityType.AbilityName);
		if (AbilityTemplate != none && !AbilityTemplate.bDontDisplayInAbilitySummary)
		{
			`Log("Adding " $ AbilityTemplate.DataName $ " to the summary");
			class'UIUtilities_Strategy'.static.AddAbilityToSummary(self, AbilityTemplate, Index++, Unit, none);
		}
	}

	MC.EndOp();
}

simulated function OnLoseFocus()
{
	// KDM : We want the navigation help system to reload itself upon receiving focus.
	AbilityInfoTipIsShowing = -1;
	SelectAbilityTipIsShowing = -1;

	super.OnLoseFocus();

}

simulated function PreviewRow(UIList ContainerList, int ItemIndex)
{
	local bool DisplayOnly;
	local int i, Rank, EffectiveRank;
	local string TmpStr;
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityTemplateManager AbilityTemplateManager;
	local XComGameState_Unit Unit; 

	// KDM : EffectiveRank is the rank the officer actually is, while Rank is the rank associated with this particular list item row.
	
	Unit = GetUnit();
	DisplayOnly = !CanUnitEnterOTSTraining(Unit);

	if (ItemIndex == INDEX_NONE)
	{
		Rank = 1;
		return;
	}
	else
	{
		Rank = UIArmory_LWOfficerPromotionItem(List.GetItem(ItemIndex)).Rank;
	}

	MC.BeginFunctionOp("setAbilityPreview");

	if (class'LWOfficerUtilities'.static.GetOfficerComponent(Unit) != none)
	{
		EffectiveRank = class'LWOfficerUtilities'.static.GetOfficerComponent(Unit).GetOfficerRank();
	}
	else
	{
		EffectiveRank = 0;
	}

	if (!DisplayOnly)
	{
		EffectiveRank++;
	}

	// KDM : If the rank associated with this row is greater than the officer's actual rank show locked information and icons.
	// This, however, can be negated by ALWAYSSHOW and IsViewLockedStatsEnabled().
	if ((Rank > EffectiveRank) && !(default.ALWAYSSHOW || class'XComGameState_LWPerkPackOptions'.static.IsViewLockedStatsEnabled()))
	{
		for (i = 0; i < NUM_ABILITIES_PER_RANK; ++i)
		{
			MC.QueueString(class'UIUtilities_Image'.const.LockedAbilityIcon); // Icon
			MC.QueueString(class'UIUtilities_Text'.static.GetColoredText(m_strAbilityLockedTitle, eUIState_Disabled)); // Name
			MC.QueueString(class'UIUtilities_Text'.static.GetColoredText(m_strAbilityLockedDescription, eUIState_Disabled)); // Description
			MC.QueueBoolean(false); // IsClassIcon
		}
	}
	// KDM : We are looking at a row whose associated rank is less than, or equal to, the officer's actual rank.
	else
	{
		AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

		for (i = 0; i < NUM_ABILITIES_PER_RANK; ++i)
		{
			// KDM : The 1st row corresponds to the officer's core, non-selectable, abilities.
			if (ItemIndex == 0)
			{
				AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(class'LWOfficerUtilities'.static.GetAbilityName(0, i));
			}
			else
			{
				AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(class'LWOfficerUtilities'.static.GetAbilityName(Rank, i));
			}

			if (AbilityTemplate != none)
			{
				MC.QueueString(AbilityTemplate.IconImage); // Icon

				TmpStr = AbilityTemplate.LocFriendlyName != "" ? AbilityTemplate.LocFriendlyName : ("Missing 'LocFriendlyName' for " $ AbilityTemplate.DataName);
				MC.QueueString(Caps(TmpStr)); // Name

				TmpStr = AbilityTemplate.HasLongDescription() ? AbilityTemplate.GetMyLongDescription() : ("Missing 'LocLongDescription' for " $ AbilityTemplate.DataName);
				MC.QueueString(TmpStr); // Description
				MC.QueueBoolean(false); // IsClassIcon
			}
			else
			{
				MC.QueueString(""); // Icon
				MC.QueueString(string(class'LWOfficerUtilities'.static.GetAbilityName(Rank, i))); // Name
				MC.QueueString("Missing template for ability '" $ class'LWOfficerUtilities'.static.GetAbilityName(Rank, i) $ "'"); // Description
				MC.QueueBoolean(false); // IsClassIcon
			}
		}
	}

	MC.EndOp();

	if (`ISCONTROLLERACTIVE)
	{
		// KDM : When a new row is selected, preserve the ability selection; this means :
		// 1.] If the previous row's left ability was selected, select the left ability for the new row.
		// 2.] If the previous row's right ability was selected, select the right ability for the new row.
		UIArmory_LWOfficerPromotionItem(List.GetItem(ItemIndex)).SetSelectedAbility(SelectedAbilityIndex);

		// KDM : The navigation system should be updated because it might have changed. For example,
		// 1.] If a promotion row ability is selected, a "Select" tip needs to be displayed.
		// 2.] If an unhidden ability is selected, an "Ability Info" tip needs to be displayed.   
		UpdateNavHelp();
	}
}

simulated function ViewLeadershipStats(UIButton Button)
{
	local TDialogueBoxData DialogData;

	Movie.Pres.PlayUISound(eSUISound_MenuSelect);

	DialogData.eType = eDialog_Normal;
	DialogData.strTitle = strLeadershipDialogueTitle;
	DialogData.strText = GetFormattedLeadershipText();
	DialogData.strCancel = class'UIUtilities_Text'.default.m_strGenericOK;;
	Movie.Pres.UIRaiseDialog(DialogData);
}

simulated function string GetFormattedLeadershipText()
{
	local int idx, limit;
	local string OutString;
	local array<LeadershipEntry> LeadershipData;
	local LeadershipEntry Entry;
	local X2SoldierClassTemplate ClassTemplate;
	local XComGameState_Unit OfficerUnit, Unit;
	local XComGameState_Unit_LWOfficer OfficerState;
	local XComGameStateHistory History;
	
	OutString = "";
	OfficerUnit = GetUnit();
	if (OfficerUnit == none)
	{
		return Outstring;
	}
	OfficerState = class'LWOfficerUtilities'.static.GetOfficerComponent(OfficerUnit);
	if (OfficerState == none)
	{
		return Outstring;
	}

	LeadershipData = OfficerState.GetLeadershipData_MissionSorted();
	History = `XCOMHISTORY;

	Limit = 40;

	foreach LeaderShipData (Entry, idx)
	{
		// Limit to the top 40
		if (idx >= limit) 
		{
			break;
		}
		
		if (Entry.UnitRef.ObjectID == 0)
		{
			limit += 1; 
			continue;
		}
		
		Unit = XComGameState_Unit(History.GetGameStateForObjectID(Entry.UnitRef.ObjectID));
		if (Unit == none)
		{
			limit += 1;
			continue;
		}
		
		if (Unit.IsDead())
		{
			limit += 1;
			continue;
		}

		ClassTemplate = Unit.GetSoldierClassTemplate();
		if (ClassTemplate.DataName == 'LWS_RebelSoldier')
		{
			limit += 1;
			continue;
		}

		OutString $= Entry.SuccessfulMissionCount $ " : ";
		OutString $= Unit.GetName(eNameType_RankFull) $ " / ";
		Outstring $= ClassTemplate.DisplayName;
		Outstring $= "\n";
	}

	return OutString;
}

simulated function ConfirmAbilitySelection(int Rank, int Branch)
{
	local TDialogueBoxData DialogData;
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityTemplateManager AbilityTemplateManager;
	local XGParamTag LocTag;
	
	PendingRank = Rank;
	PendingBranch = Branch;

	Movie.Pres.PlayUISound(eSUISound_MenuSelect);

	DialogData.eType = eDialog_Alert;
	DialogData.bMuteAcceptSound = true;
	DialogData.strTitle = m_strConfirmAbilityTitle;
	DialogData.strAccept = class'UIUtilities_Text'.default.m_strGenericYes;
	DialogData.strCancel = class'UIUtilities_Text'.default.m_strGenericNO;
	DialogData.fnCallback = ConfirmAbilityCallback;
	
	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(class'LWOfficerUtilities'.static.GetAbilityName(PendingRank, PendingBranch));

	LocTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	LocTag.StrValue0 = AbilityTemplate.LocFriendlyName;
	DialogData.strText = `XEXPAND.ExpandString(m_strConfirmAbilityText);
	Movie.Pres.UIRaiseDialog(DialogData);

	// KDM : Follow the new WotC UIArmory_Promotion and update the navigation help system.
	UpdateNavHelp();
}

simulated function ConfirmAbilityCallback(Name Action)
{
	local XComGameStateHistory History;
	local XComGameState UpdateState;
	local XComGameState_Unit UpdatedUnit;
	local XComGameState_Unit Unit;
	local StaffUnitInfo UnitInfo;
	local XComGameStateContext_ChangeContainer ChangeContainer;
	local ClassAgnosticAbility NewOfficerAbility;
	local SoldierClassAbilityType Ability;
	local XComGameState_Unit_LWOfficer OfficerState;
	local int NewOfficerRank;
	local bool bTrainingSuccess;
	local XComGameState_HeadquartersProjectTrainLWOfficer TrainLWOfficerProject;
	local XComGameState_StaffSlot StaffSlotState;

	if (Action == 'eUIAction_Accept')
	{
		Unit = GetUnit();

		// Build ClassAgnosticAbility to allow instant training into Officer Ability
		Ability.AbilityName = class'LWOfficerUtilities'.static.GetAbilityName(PendingRank, PendingBranch);
		Ability.ApplyToWeaponSlot = eInvSlot_Unknown;
		Ability.UtilityCat = '';
		NewOfficerAbility.AbilityType = Ability;
		NewOfficerAbility.iRank = PendingRank;
		NewOfficerAbility.bUnlocked = true;

		// Build GameState change container
		History = `XCOMHISTORY;
		ChangeContainer = class'XComGameStateContext_ChangeContainer'.static.CreateEmptyChangeContainer("Staffing Train Officer Slot");
		UpdateState = History.CreateNewGameState(true, ChangeContainer);
		UpdatedUnit = XComGameState_Unit(UpdateState.CreateStateObject(class'XComGameState_Unit', GetUnit().ObjectID));

		// Try to retrieve new OfficerComponent from Unit -- note that it may not have been created for non-officers yet
		OfficerState = class'LWOfficerUtilities'.static.GetOfficerComponent(Unit);

		if (OfficerState == none) 
		{
			// First promotion, create component gamestate and attach it
			OfficerState = XComGameState_Unit_LWOfficer(UpdateState.CreateStateObject(class'XComGameState_Unit_LWOfficer'));
			OfficerState.InitComponent();
			if (default.INSTANTTRAINING) 
			{
				OfficerState.SetOfficerRank(1);
			}
			else
			{
				NewOfficerRank = 1;
			}
			UpdatedUnit.AddComponentObject(OfficerState);
		}
		else
		{
			// Subsequent promotion, update existing component gamestate
			NewOfficerRank = OfficerState.GetOfficerRank() + 1;
			OfficerState = XComGameState_Unit_LWOfficer(UpdateState.CreateStateObject(class'XComGameState_Unit_LWOfficer', OfficerState.ObjectID));
			if (default.INSTANTTRAINING) 
			{
				OfficerState.SetOfficerRank(NewOfficerRank);
			}
			else
			{	
			}
		}

		if (default.INSTANTTRAINING) 
		{
			`log("LW Officer Pack: Adding ability:" @ NewOfficerAbility.AbilityType.AbilityName);
			OfficerState.OfficerAbilities.AddItem(NewOfficerAbility);
			UpdatedUnit = class'LWOfficerUtilities'.static.AddInitialAbilities(UpdatedUnit, OfficerState, UpdateState);
			bTrainingSuccess = true;
		}
		else
		{
			bTrainingSuccess = OfficerState.SetRankTraining(NewOfficerRank, Ability.AbilityName);
		}

		if (!default.INSTANTTRAINING)
		{
			StaffSlotState = GetEmptyOfficerTrainingStaffSlot();
			if (StaffSlotState != none)
			{
				UnitInfo.UnitRef = UpdatedUnit.GetReference();
				// The Training project is started when the staff slot is filled
				StaffSlotState.FillSlot(UnitInfo, UpdateState); 
		
				// Find the new Training Project which was just created by filling the staff slot and set the rank and ability
				foreach UpdateState.IterateByClassType(class'XComGameState_HeadquartersProjectTrainLWOfficer', TrainLWOfficerProject)
				{
					// Handle possible cases of multiple officer training slots
					if (TrainLWOfficerProject.ProjectFocus.ObjectID == GetUnit().ObjectID) 
					{
						TrainLWOfficerProject.AbilityName = Ability.AbilityName;
						TrainLWOfficerProject.NewRank = NewOfficerRank;

						// Have to recompute time for project after rank is set in order to handle completion time based on rank
						TrainLWOfficerProject.ProjectPointsRemaining = TrainLWOfficerProject.CalculatePointsToTrain(); 
						TrainLWOfficerProject.InitialProjectPoints = TrainLWOfficerProject.CalculatePointsToTrain();
						TrainLWOfficerProject.SetProjectedCompletionDateTime(TrainLWOfficerProject.StartDateTime);
						break;
					}
				}
			}
			else
			{
				`Redscreen("LW Officer Pack : Failed to find StaffSlot in UIArmory_LWOfficerPromotion.ConfirmAbilityCallback");
				bTrainingSuccess = false;
			}
		}

		// Submit or clear update state based on success/failure
		if (bTrainingSuccess) 
		{
			UpdateState.AddStateObject(UpdatedUnit);
			UpdateState.AddStateObject(OfficerState);
			`GAMERULES.SubmitGameState(UpdateState);

			Header.PopulateData();
			PopulateData();
		}
		else 
		{
			History.CleanupPendingGameState(UpdateState);
		}
		Movie.Pres.PlayUISound(eSUISound_SoldierPromotion);
		Movie.Pres.ScreenStack.PopUntilClass(class'UIFacility_Academy', true);
	}
	else
	{
		Movie.Pres.PlayUISound(eSUISound_MenuClickNegative);
	}
}

simulated function XComGameState_StaffSlot GetEmptyOfficerTrainingStaffSlot()
{
	local UIScreenStack ScreenStack;
	local XComGameState_FacilityXCom FacilityState;
	local XComGameState_StaffSlot SlotState;
	local UIFacility_Academy AcademyUI;
	local UIScreen CurrScreen;
	local int idx;

	ScreenStack = Movie.Pres.ScreenStack;

	// Find the class UIFacilityAcademy that invoked this (just in case there's more than 1)
	AcademyUI = UIFacility_Academy(ScreenStack.GetScreen(class'UIFacility_Academy'));
	if (AcademyUI == none)
	{
		// Search for override classes
		foreach ScreenStack.Screens(CurrScreen)
		{
			AcademyUI = UIFacility_Academy(CurrScreen);
			if (AcademyUI != none)
			{
				break;
			}
		}
	}
	if (AcademyUI == none)
	{
		FacilityState = `XCOMHQ.GetFacilityByName('OfficerTrainingSchool');
	}
	else
	{
		FacilityState = AcademyUI.GetFacility();
	}

	for (idx = 0; idx < FacilityState.StaffSlots.Length; idx++)
	{
		SlotState = FacilityState.GetStaffSlot(idx);
		if (SlotState != none && SlotState.GetMyTemplateName() == 'OTSOfficerSlot' && SlotState.IsSlotEmpty() && !SlotState.bIsLocked)
		{
			return SlotState;
		}
	}
	return none;
}

//==============================================================================
// Soldier cycling
//==============================================================================

simulated function bool IsAllowedToCycleSoldiers()
{
	return true;
}

simulated static function bool CanCycleTo(XComGameState_Unit Soldier)
{
	return class'LWOfficerUtilities'.static.IsOfficer(Soldier);
}

simulated static function CycleToSoldier(StateObjectReference UnitRef)
{
	super(UIArmory).CycleToSoldier(UnitRef);
}

// KDM : Use UIArmory_Promotion --> UpdateNavHelp() as our code base since it has been updated for WotC.
simulated function UpdateNavHelp()
{
	local int i, AbilityInfoTipShouldShow, SelectAbilityTipShouldShow;
	local string PrevKey, NextKey;
	local XGParamTag LocTag;
	
	if (!bIsFocused)
	{
		return;
	}

	// KDM : -1 = unset, 0 = false, 1 = true
	AbilityInfoTipShouldShow = (!UIArmory_PromotionItem(List.GetSelectedItem()).bIsDisabled) ? 1 : 0;
	SelectAbilityTipShouldShow = (UIArmory_PromotionItem(List.GetSelectedItem()).bEligibleForPromotion) ? 1 : 0;

	// KDM : Whenever the promotion screen updates its navigation help system, the whole navigation help system flickers off then on; 
	// this is because it needs to be cleared, recreated, then re-shown. This is mainly an issue for controller users since, for them,
	// the navigation system has to refresh whenever a new row is selected, as well as whenever a new ability is selected. The reason is :
	// 1.] A 'Select' tip appears when a promotion eligible row is selected, and disappears otherwise.
	// 2.] An 'Ability Info' tip appears whenever an unhidden ability is selected, and disappears otherwise.
	//
	// The easiest solution is to only update the navigation help system when dynamic tips do, in fact, change.
	if (`ISCONTROLLERACTIVE && (AbilityInfoTipIsShowing == AbilityInfoTipShouldShow) && (SelectAbilityTipIsShowing == SelectAbilityTipShouldShow))
	{
		// KDM : The navigation help system has not changed so just get out.
		return;
	}
	else if (`ISCONTROLLERACTIVE && ((AbilityInfoTipIsShowing != AbilityInfoTipShouldShow) || (SelectAbilityTipIsShowing != SelectAbilityTipShouldShow)))
	{
		// KDM : The navigation help system has changed so let it on through.
		AbilityInfoTipIsShowing = AbilityInfoTipShouldShow;
		SelectAbilityTipIsShowing = SelectAbilityTipShouldShow;
	}
	
	NavHelp = `HQPRES.m_kAvengerHUD.NavHelp;

	NavHelp.ClearButtonHelp();
	
	// KDM : From what I can see, the officer promotion screen is not accessible via the post mission squad view, represented by UIAfterAction;
	// therefore, the corresponding code has been removed.

	NavHelp.AddBackButton(OnCancel);

	if (UIArmory_PromotionItem(List.GetSelectedItem()).bEligibleForPromotion)
	{
		NavHelp.AddSelectNavHelp();
	}

	if (XComHQPresentationLayer(Movie.Pres) != none)
	{
		LocTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
		LocTag.StrValue0 = Movie.Pres.m_kKeybindingData.GetKeyStringForAction(PC.PlayerInput, eTBC_PrevUnit);
		PrevKey = `XEXPAND.ExpandString(PrevSoldierKey);
		LocTag.StrValue0 = Movie.Pres.m_kKeybindingData.GetKeyStringForAction(PC.PlayerInput, eTBC_NextUnit);
		NextKey = `XEXPAND.ExpandString(NextSoldierKey);

		if (class'XComGameState_HeadquartersXCom'.static.GetObjectiveStatus('T0_M7_WelcomeToGeoscape') != eObjectiveState_InProgress &&
			RemoveMenuEvent == '' && NavigationBackEvent == '' && !`ScreenStack.IsInStack(class'UISquadSelect'))
		{
			NavHelp.AddGeoscapeButton();
		}

		if (Movie.IsMouseActive() && IsAllowedToCycleSoldiers() && class'UIUtilities_Strategy'.static.HasSoldiersToCycleThrough(UnitReference, CanCycleTo))
		{
			NavHelp.SetButtonType("XComButtonIconPC");
			i = eButtonIconPC_Prev_Soldier;
			NavHelp.AddCenterHelp( string(i), "", PrevSoldier, false, PrevKey);
			i = eButtonIconPC_Next_Soldier; 
			NavHelp.AddCenterHelp( string(i), "", NextSoldier, false, NextKey);
			NavHelp.SetButtonType("");
		}
	}

	// KDM : 'Make poster' help item has been removed.

	if (`ISCONTROLLERACTIVE)
	{
		if (!UIArmory_PromotionItem(List.GetSelectedItem()).bIsDisabled)
		{
			NavHelp.AddLeftHelp(m_strInfo, class'UIUtilities_Input'.static.GetGamepadIconPrefix() $class'UIUtilities_Input'.const.ICON_LSCLICK_L3);
		}

		if (IsAllowedToCycleSoldiers() && class'UIUtilities_Strategy'.static.HasSoldiersToCycleThrough(UnitReference, CanCycleTo))
		{
			NavHelp.AddCenterHelp(m_strTabNavHelp, class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_LBRB_L1R1);
		}

		NavHelp.AddCenterHelp(m_strRotateNavHelp, class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_RSTICK); 
	}

	// KDM : 'Go to Training Center' help item has been removed; might be ok to keep this one though. 

	NavHelp.Show();
}

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	local bool bHandled;
	
	if (!CheckInputIsReleaseOrDirectionRepeat(cmd, arg))
	{
		return false;
	}
	
	// KDM : Give the selected list item the first chance at the input.
	if (List.GetSelectedItem().OnUnrealCommand(cmd, arg))
	{
		UpdateNavHelp();
		return true;
	}

	bHandled = true;

	switch(cmd)
	{
		// KDM : Right stick click opens up the leadership screen for controller users.
		case class'UIUtilities_Input'.const.FXS_BUTTON_R3:
			if (LeadershipButton.bIsVisible)
			{
				ViewLeadershipStats(none);
			}
			break;
		
		case class'UIUtilities_Input'.const.FXS_MOUSE_5:
		case class'UIUtilities_Input'.const.FXS_KEY_TAB:
		case class'UIUtilities_Input'.const.FXS_BUTTON_RBUMPER:
		case class'UIUtilities_Input'.const.FXS_MOUSE_4:
		case class'UIUtilities_Input'.const.FXS_KEY_LEFT_SHIFT:
		case class'UIUtilities_Input'.const.FXS_BUTTON_LBUMPER:
			// Prevent switching soldiers during AfterAction promotion
			if (UIAfterAction(Movie.Stack.GetScreen(class'UIAfterAction')) == none)
			{
				bHandled = false;
			}
			break;
		
		case class'UIUtilities_Input'.const.FXS_BUTTON_B:
		case class'UIUtilities_Input'.const.FXS_KEY_ESCAPE:
		case class'UIUtilities_Input'.const.FXS_R_MOUSE_DOWN:
			OnCancel();
			break;
		
		// KDM : 'Make poster' case has been removed.

		// KDM : 'Go to Training Center' case has been removed.
		
		default:
			bHandled = false;
			break;
	}
	
	return bHandled || super(UIArmory).OnUnrealCommand(cmd, arg);
}

defaultproperties
{
	// KDM : Select the left ability on initialization.
	SelectedAbilityIndex = 0;

	AbilityInfoTipIsShowing = -1;
	SelectAbilityTipIsShowing = -1;
}
