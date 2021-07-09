class UIShellDifficultySW extends UIShellDifficulty;

var array<SecondWaveOptionObject> SecondWaveOptionsReal;

simulated function OnSecondWaveDescritionUpdate(UIList ContainerList, int ItemIndex)
{
	if (ItemIndex < SecondWaveOptionsReal.Length && ItemIndex >= 0)
	{
		AS_SetAdvancedDescription(SecondWaveOptionsReal[ItemIndex].Tooltip);
	}
}

simulated function BuildMenu()
{
	local string strDifficultyTitle;
	local UIPanel LinkPanel;
	local UIMechaListItem LinkMechaList;
	local int OptionIndex;
	local XComGameStateHistory History;
	local XComGameState_CampaignSettings CampaignSettingsStateObject;
	local SecondWaveOptionObject SWOption;
	local UIShellDifficulty OrigDiffMenu;

	History = `XCOMHISTORY;

	CampaignSettingsStateObject = XComGameState_CampaignSettings(History.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings', true));

	// Title
	strDifficultyTitle = (m_bIsPlayingGame) ? m_strChangeDifficulty : m_strSelectDifficulty;
	
	AS_SetDifficultyMenu(
		strDifficultyTitle, 
		m_arrDifficultyTypeStrings[0],
		m_arrDifficultyTypeStrings[1],
		m_arrDifficultyTypeStrings[2],
		m_arrDifficultyTypeStrings[3],
		m_strDifficulty_SecondWaveButtonLabel,
		m_strDifficultyEnableTutorial,
		m_strDifficultySuppressFirstTimeNarrativeVO,
		class'UIOptionsPCScreen'.default.m_strInterfaceLabel_ShowSubtitles,
		GetDifficultyButtonText());

	if(Movie.Pres.m_eUIMode == eUIMode_Shell)
	{
		m_iSelectedDifficulty = 1; //Default to normal 
	}
	else
	{
		m_iSelectedDifficulty = `CAMPAIGNDIFFICULTYSETTING;  //Get the difficulty from the game
	}

	//////////////////
	// top panel
	LinkPanel = Spawn(class'UIPanel', self);
	LinkPanel.bAnimateOnInit = false;
	LinkPanel.bCascadeSelection = true;
	LinkPanel.bCascadeFocus = false;
	LinkPanel.InitPanel('topPanel');
	m_TopPanel = LinkPanel;

	m_DifficultyRookieMechaItem = Spawn(class'UIMechaListItem', LinkPanel);
	m_DifficultyRookieMechaItem.bAnimateOnInit = false;
	m_DifficultyRookieMechaItem.InitListItem('difficultyRookieButton');
	m_DifficultyRookieMechaItem.SetWidgetType(EUILineItemType_Checkbox);
	m_DifficultyRookieMechaItem.UpdateDataCheckbox(m_arrDifficultyTypeStrings[0], "", m_iSelectedDifficulty == 0, UpdateDifficulty, OnButtonDifficultyRookie);
	m_DifficultyRookieMechaItem.BG.SetTooltipText(m_arrDifficultyDescStrings[0], , , 10, , , , 0.0f);

	m_DifficultyVeteranMechaItem = Spawn(class'UIMechaListItem', LinkPanel);
	m_DifficultyVeteranMechaItem.bAnimateOnInit = false;
	m_DifficultyVeteranMechaItem.InitListItem('difficultyVeteranButton');
	m_DifficultyVeteranMechaItem.SetWidgetType(EUILineItemType_Checkbox);
	m_DifficultyVeteranMechaItem.UpdateDataCheckbox(m_arrDifficultyTypeStrings[1], "", m_iSelectedDifficulty == 1, UpdateDifficulty, OnButtonDifficultyVeteran);
	m_DifficultyVeteranMechaItem.BG.SetTooltipText(m_arrDifficultyDescStrings[1], , , 10, , , , 0.0f);

	m_DifficultyCommanderMechaItem = Spawn(class'UIMechaListItem', LinkPanel);
	m_DifficultyCommanderMechaItem.bAnimateOnInit = false;
	m_DifficultyCommanderMechaItem.InitListItem('difficultyCommanderButton');
	m_DifficultyCommanderMechaItem.SetWidgetType(EUILineItemType_Checkbox);
	m_DifficultyCommanderMechaItem.UpdateDataCheckbox(m_arrDifficultyTypeStrings[2], "", m_iSelectedDifficulty == 2, UpdateDifficulty, OnButtonDifficultyCommander);
	m_DifficultyCommanderMechaItem.BG.SetTooltipText(m_arrDifficultyDescStrings[2], , , 10, , , , 0.0f);

	m_DifficultyLegendMechaItem = Spawn(class'UIMechaListItem', LinkPanel);
	m_DifficultyLegendMechaItem.bAnimateOnInit = false;
	m_DifficultyLegendMechaItem.InitListItem('difficultyLegendButton');
	m_DifficultyLegendMechaItem.SetWidgetType(EUILineItemType_Checkbox);
	m_DifficultyLegendMechaItem.UpdateDataCheckbox(m_arrDifficultyTypeStrings[3], "", m_iSelectedDifficulty == 3, UpdateDifficulty, OnButtonDifficultyLegend);
	m_DifficultyLegendMechaItem.BG.SetTooltipText(m_arrDifficultyDescStrings[3], , , 10, , , , 0.0f);
	
	m_DifficultyLegendMechaItem.Checkbox.SetReadOnly(`REPLAY.bInTutorial);
	
	//////////////////
	// Second Wave panel
	LinkPanel = Spawn(class'UIPanel', self);
	LinkPanel.bAnimateOnInit = false;
	LinkPanel.bIsNavigable = false;
	LinkPanel.bCascadeSelection = true;
	LinkPanel.bCascadeFocus = false;
	LinkPanel.InitPanel('AdvancedOptions');
	LinkPanel.Hide();
	LinkPanel.MC.FunctionString("SetTitle", SecondWavePanelTitle);
	m_AdvancedOptions = LinkPanel;

	m_SecondWaveList = Spawn(class'UIList', LinkPanel);
	m_SecondWaveList.InitList('advancedListMC',,,846);
	//m_SecondWaveList.InitList('advancedListMC');
	m_SecondWaveList.Navigator.LoopSelection = false;
	m_SecondWaveList.Navigator.LoopOnReceiveFocus = true;
	m_SecondWaveList.OnItemClicked = OnSecondWaveOptionClicked;
	m_SecondWaveList.OnSelectionChanged = OnSecondWaveDescritionUpdate;

	`log("Actual Second wave length:" @ SecondWaveOptionsReal.Length,, 'SWSupport');

	OrigDiffMenu = UIShellDifficulty(class'Engine'.static.FindClassDefaultObject("XComGame.UIShellDifficulty"));

	for( OptionIndex = 0; OptionIndex < OrigDiffMenu.SecondWaveOptions.Length; ++OptionIndex )
	{
		SWOption = new(None, string(OrigDiffMenu.SecondWaveOptions[OptionIndex].ID)) class'SecondWaveOptionObject';
		SWOption.OptionData = OrigDiffMenu.SecondWaveOptions[OptionIndex];
		if (OptionIndex < OrigDiffMenu.SecondWaveDescriptions.Length)
		{
			SWOption.Description = OrigDiffMenu.SecondWaveDescriptions[OptionIndex];
			SWOption.Tooltip = OrigDiffMenu.SecondWaveTooltips[OptionIndex];
		}
		SecondWaveOptionsReal.InsertItem(OptionIndex, SWOption);
	}

	`log("New Second wave length:" @ SecondWaveOptionsReal.Length,, 'SWSupport');

	for( OptionIndex = 0; OptionIndex < SecondWaveOptionsReal.Length; ++OptionIndex )
	{
		LinkMechaList = Spawn(class'UIMechaListItem', m_SecondWaveList.ItemContainer);
		LinkMechaList.bAnimateOnInit = false;
		LinkMechaList.InitListItem();
		LinkMechaList.SetWidgetType(EUILineItemType_Checkbox);
		// bsg-jrebar (5/9/17): On controller, we do this by item, instead of by panel
		if(`ISCONTROLLERACTIVE)
			LinkMechaList.UpdateDataCheckbox(SecondWaveOptionsReal[OptionIndex].Description, "", CampaignSettingsStateObject.IsSecondWaveOptionEnabled(SecondWaveOptionsReal[OptionIndex].OptionData.ID), , OnAdvancedOptionsClicked);
		else
			LinkMechaList.UpdateDataCheckbox(SecondWaveOptionsReal[OptionIndex].Description, "", CampaignSettingsStateObject.IsSecondWaveOptionEnabled(SecondWaveOptionsReal[OptionIndex].OptionData.ID), );
		//bsg-jrebar (5/9/17): end
		
		// Set the checkbox ready only bool directly so that we still see the check mark box (actually, it's still enabled, but the m_SecondWaveList.OnItemClicked is what will toggle the checkbox
		// we disable the checkbox here so that we don't get double click feedback)
		LinkMechaList.Checkbox.bReadOnly = true;

		if (!SecondWaveOptionsReal[OptionIndex].CanChangeInCampaign && Movie.Pres.m_eUIMode != eUIMode_Shell)
		{
			LinkMechaList.SetDisabled(true, "Can't be changed in game");
		}
		else if (SecondWaveOptionsReal[OptionIndex].Disabled)
		{
			LinkMechaList.SetDisabled(true, "Disabled by config");
		}
	}

	//////////////////
	// bottom panel

	LinkPanel = Spawn(class'UIPanel', self);
	LinkPanel.bAnimateOnInit = false;
	LinkPanel.bCascadeSelection = true;
	LinkPanel.bCascadeFocus = false;
	LinkPanel.InitPanel('bottomPanel');
	m_BottomPanel = LinkPanel;

	m_SecondWaveButton = Spawn(class'UIMechaListItem', LinkPanel);
	m_SecondWaveButton.bAnimateOnInit = false;
	m_SecondWaveButton.InitListItem('difficultySecondWaveButton');
	m_SecondWaveButton.SetWidgetType(EUILineItemType_Description);
	m_SecondWaveButton.UpdateDataDescription(m_strDifficulty_SecondWaveButtonLabel,OnButtonSecondWave);
	m_SecondWaveButton.BG.SetTooltipText(m_strSecondWaveDesc, , , 10, , , , 0.0f); // We need a localized string setup for this

	//if( Movie.Pres.m_eUIMode != eUIMode_Shell )
		//m_SecondWaveButton.Hide();

	// this panel currently default to open:
	m_bSecondWaveOpen = true;
	CloseSecondWave();

	m_TutorialMechaItem = Spawn(class'UIMechaListItem', LinkPanel);
	m_TutorialMechaItem.bAnimateOnInit = false;
	m_TutorialMechaItem.InitListItem('difficultyTutorialButton');
	m_TutorialMechaItem.SetWidgetType(EUILineItemType_Checkbox);
	m_TutorialMechaItem.UpdateDataCheckbox(m_strDifficultyEnableTutorial, "", m_bControlledStart, ConfirmControlDialogue, OnClickedTutorial);
	m_TutorialMechaItem.Checkbox.SetReadOnly(m_bIsPlayingGame);
	m_TutorialMechaItem.BG.SetTooltipText(m_strDifficultyTutorialDesc, , , 10, , , , 0.0f);

	m_FirstTimeVOMechaItem = Spawn(class'UIMechaListItem', LinkPanel);
	m_FirstTimeVOMechaItem.bAnimateOnInit = false;
	m_FirstTimeVOMechaItem.InitListItem('difficultyReduceVOButton');
	m_FirstTimeVOMechaItem.SetWidgetType(EUILineItemType_Checkbox);
	m_FirstTimeVOMechaItem.UpdateDataCheckbox(m_strDifficultySuppressFirstTimeNarrativeVO, "", m_bSuppressFirstTimeNarrative, UpdateFirstTimeNarrative, OnClickFirstTimeVO);
	m_FirstTimeVOMechaItem.Checkbox.SetReadOnly(m_bIsPlayingGame);
	m_FirstTimeVOMechaItem.BG.SetTooltipText(m_strDifficultySuppressFirstTimeNarrativeVODesc, , , 10, , , , 0.0f);
	UpdateFirstTimeNarrative(m_FirstTimeVOMechaItem.Checkbox);
	
	m_SubtitlesMechaItem = Spawn(class'UIMechaListItem', LinkPanel);
	m_SubtitlesMechaItem.bAnimateOnInit = false;
	m_SubtitlesMechaItem.InitListItem('difficultySubtitlesButton');
	m_SubtitlesMechaItem.SetWidgetType(EUILineItemType_Checkbox);
	m_SubtitlesMechaItem.UpdateDataCheckbox(class'UIOptionsPCScreen'.default.m_strInterfaceLabel_ShowSubtitles, "", `XPROFILESETTINGS.Data.m_bSubtitles, UpdateSubtitles, OnClickSubtitles);
	m_SubtitlesMechaItem.BG.SetTooltipText(class'UIOptionsPCScreen'.default.m_strInterfaceLabel_ShowSubtitles_Desc, , , 10, , , , 0.0f);

	if(m_bIsPlayingGame)
	{
		// bsg-jrebar (4/26/17): Disable all nav and hide all buttons
		m_FirstTimeVOMechaItem.Hide();
		m_FirstTimeVOMechaItem.DisableNavigation();
		m_TutorialMechaItem.Hide();
		m_TutorialMechaItem.DisableNavigation();
		m_SubtitlesMechaItem.Hide();
		m_SubtitlesMechaItem.DisableNavigation();
		m_SecondWaveButton.DisableNavigation();
		m_BottomPanel.DisableNavigation();
		// bsg-jrebar (4/26/17): end
	}

	m_StartButton = Spawn(class'UILargeButton', LinkPanel);
	
	m_StartButton.InitLargeButton('difficultyLaunchButton', GetDifficultyButtonText(), "", UIIronMan);
	m_StartButton.DisableNavigation();

	RefreshDescInfo();
}

function array<name> GetSelectedSecondWaveOptionNames( )
{
	local int OptionIndex;
	local UICheckbox CheckedBox;
	local array<name> Options;

	for( OptionIndex = 0; OptionIndex < SecondWaveOptionsReal.Length; ++OptionIndex )
	{
		CheckedBox = UIMechaListItem(m_SecondWaveList.GetItem(OptionIndex)).Checkbox;
		if( CheckedBox.bChecked )
		{
			Options.AddItem( SecondWaveOptionsReal[OptionIndex].OptionData.ID );
		}
	}

	return Options;
}

function AddSecondWaveOptionsToCampaignSettings(XComGameState_CampaignSettings CampaignSettingsStateObject)
{
	local int OptionIndex;
	local UICheckbox CheckedBox;

	for( OptionIndex = 0; OptionIndex < SecondWaveOptionsReal.Length; ++OptionIndex )
	{
		CheckedBox = UIMechaListItem(m_SecondWaveList.GetItem(OptionIndex)).Checkbox;
		if( CheckedBox.bChecked )
		{
			CampaignSettingsStateObject.AddSecondWaveOption(SecondWaveOptionsReal[OptionIndex].OptionData.ID);
		}
		else
		{
			CampaignSettingsStateObject.RemoveSecondWaveOption(SecondWaveOptionsReal[OptionIndex].OptionData.ID);
		}
	}
}

function AddSecondWaveOptionsToOnlineEventManager(XComOnlineEventMgr EventManager)
{
	local int OptionIndex;
	local UICheckbox CheckedBox;
	local int RemoveIndex;

	for( OptionIndex = 0; OptionIndex < SecondWaveOptionsReal.Length; ++OptionIndex )
	{
		CheckedBox = UIMechaListItem(m_SecondWaveList.GetItem(OptionIndex)).Checkbox;
		if( CheckedBox.bChecked )
		{
			EventManager.CampaignSecondWaveOptions.AddItem(SecondWaveOptionsReal[OptionIndex].OptionData.ID);
		}
		else
		{
			RemoveIndex = EventManager.CampaignSecondWaveOptions.Find(SecondWaveOptionsReal[OptionIndex].OptionData.ID);
			if( RemoveIndex != INDEX_NONE )
			{
				EventManager.CampaignSecondWaveOptions.Remove(RemoveIndex, 1);
			}
		}
	}
}

simulated public function OnDifficultyConfirm(UIButton ButtonControl)
{
	local TDialogueBoxData kDialogData;
	local XComGameStateHistory History;
	local XComGameState StrategyStartState, NewGameState;
	local XComGameState_CampaignSettings CampaignSettingsStateObject;
	local XComGameState_Objective ObjectiveState;
	local XComOnlineEventMgr EventManager;
	local array<X2DownloadableContentInfo> DLCInfos;
	local bool EnableTutorial;
	local int idx;
	local int DifficultyToSet;
	local array<name> SWOptions;
	local float TacticalPercent, StrategyPercent, GameLengthPercent; 

	//BAIL if the save is in progress. 
	if(m_bSaveInProgress && Movie.Pres.m_kProgressDialogStatus == eProgressDialog_None)
	{
		WaitingForSaveToCompletepProgressDialog();
		return;
	}

	History = `XCOMHISTORY;
	EventManager = `ONLINEEVENTMGR;

	//This popup should only be triggered when you are in the shell == not playing the game, and difficulty set to less than classic. 
	if(!m_bIsPlayingGame && !m_bShowedFirstTimeTutorialNotice && !m_TutorialMechaItem.Checkbox.bChecked && !m_bIronmanFromShell  && m_iSelectedDifficulty < eDifficulty_Classic)
	{
		if(DevStrategyShell == none || !DevStrategyShell.m_bCheatStart)
		{
			PlaySound(SoundCue'SoundUI.HUDOnCue');

			kDialogData.eType = eDialog_Normal;
			kDialogData.strTitle = m_strFirstTimeTutorialTitle;
			kDialogData.strText = m_strFirstTimeTutorialBody;
			kDialogData.strAccept = m_strFirstTimeTutorialYes;
			kDialogData.strCancel = m_strFirstTimeTutorialNo;
			kDialogData.fnCallback = ConfirmFirstTimeTutorialCheckCallback;

			Movie.Pres.UIRaiseDialog(kDialogData);
			return;
		}
	}

	CampaignSettingsStateObject = XComGameState_CampaignSettings(History.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings', true));

	// Warn if the difficulty level is changing, that this could invalidate the ability to earn certain achievements.
	if(CampaignSettingsStateObject != none && m_bIsPlayingGame && !m_bShowedFirstTimeChangeDifficultyWarning &&
	   (CampaignSettingsStateObject.LowestDifficultySetting >= 2 && m_iSelectedDifficulty < 2)) // is Classic or will become Classic or higher difficulty (where achievements based on difficulty kick-in)
	{
		PlaySound(SoundCue'SoundUI.HUDOnCue');

		kDialogData.eType = eDialog_Warning;
		kDialogData.strTitle = m_strChangeDifficultySettingTitle;
		kDialogData.strText = m_strChangeDifficultySettingBody;
		kDialogData.strAccept = m_strChangeDifficultySettingYes;
		kDialogData.strCancel = m_strChangeDifficultySettingNo;
		kDialogData.fnCallback = ConfirmChangeDifficultySettingCallback;

		Movie.Pres.UIRaiseDialog(kDialogData);
		return;
	}

	DifficultyToSet = m_iSelectedDifficulty;

	Movie.Pres.PlayUISound(eSUISound_MenuSelect);

	TacticalPercent = DifficultyConfigurations[m_iSelectedDifficulty].TacticalDifficulty;
	StrategyPercent = DifficultyConfigurations[m_iSelectedDifficulty].StrategyDifficulty;
	GameLengthPercent = DifficultyConfigurations[m_iSelectedDifficulty].GameLength;

	if(m_bIsPlayingGame)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Changing User-Selected Difficulty to " $ m_iSelectedDifficulty);
		
		CampaignSettingsStateObject = XComGameState_CampaignSettings(History.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings'));
		CampaignSettingsStateObject = XComGameState_CampaignSettings(NewGameState.ModifyStateObject(class'XComGameState_CampaignSettings', CampaignSettingsStateObject.ObjectID));
		CampaignSettingsStateObject.SetDifficulty(
			m_iSelectedDifficulty, 
			TacticalPercent, 
			StrategyPercent, 
			GameLengthPercent, m_bIsPlayingGame);
		`XEVENTMGR.TriggerEvent('OnSecondWaveChanged', CampaignSettingsStateObject, self, NewGameState);
		AddSecondWaveOptionsToCampaignSettings(CampaignSettingsStateObject);

		`GAMERULES.SubmitGameState(NewGameState);
		
		// Perform any DLC-specific difficulty updates
		DLCInfos = EventManager.GetDLCInfos(false);
		for (idx = 0; idx < DLCInfos.Length; ++idx)
		{
			DLCInfos[idx].OnDifficultyChanged();
		}

		Movie.Stack.Pop(self);
	}
	else
	{
		EnableTutorial = m_iSelectedDifficulty < eDifficulty_Classic && m_bControlledStart;

		//If we are NOT going to do the tutorial, we setup our campaign starting state here. If the tutorial has been selected, we wait until it is done
		//to create the strategy start state.
		if(!EnableTutorial || (DevStrategyShell != none && DevStrategyShell.m_bSkipFirstTactical))
		{
			SWOptions = GetSelectedSecondWaveOptionNames( );

			//We're starting a new campaign, set it up
			StrategyStartState = class'XComGameStateContext_StrategyGameRule'.static.CreateStrategyGameStart(, 
																											 , 
																											 EnableTutorial, 
																											 (EnableTutorial || `XPROFILESETTINGS.Data.m_bXPackNarrative),
																											 m_bIntegratedDLC,
																											 m_iSelectedDifficulty, 
																											 TacticalPercent,
																											 StrategyPercent, 
																											 GameLengthPercent, 
																											 (!EnableTutorial && !`XPROFILESETTINGS.Data.m_bXPackNarrative && m_bSuppressFirstTimeNarrative),
																											 EnabledOptionalNarrativeDLC, 
																											 , 
																											 m_bIronmanFromShell,
																											 , 
																											 , 
																											 SWOptions);

			// The CampaignSettings are initialized in CreateStrategyGameStart, so we can pull it from the history here
			CampaignSettingsStateObject = XComGameState_CampaignSettings(History.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings'));

			//Since we just created the start state above, the settings object is still writable so just update it with the settings from the new campaign dialog
			CampaignSettingsStateObject.SetStartTime(StrategyStartState.TimeStamp);

			//See if we came from the dev strategy shell. If so, set the dev shell options...		
			if(DevStrategyShell != none)
			{
				CampaignSettingsStateObject.bCheatStart = DevStrategyShell.m_bCheatStart;
				CampaignSettingsStateObject.bSkipFirstTactical = DevStrategyShell.m_bSkipFirstTactical;
			}

			CampaignSettingsStateObject.SetDifficulty(m_iSelectedDifficulty, TacticalPercent, StrategyPercent, GameLengthPercent);
			CampaignSettingsStateObject.SetIronmanEnabled(m_bIronmanFromShell);

			// on Debug Strategy Start, disable the intro movies on the first objective
			if(CampaignSettingsStateObject.bCheatStart)
			{
				foreach StrategyStartState.IterateByClassType(class'XComGameState_Objective', ObjectiveState)
				{
					if(ObjectiveState.GetMyTemplateName() == 'T1_M0_FirstMission')
					{
						ObjectiveState.AlreadyPlayedNarratives.AddItem("X2NarrativeMoments.Strategy.GP_GameIntro");
						ObjectiveState.AlreadyPlayedNarratives.AddItem("X2NarrativeMoments.Strategy.GP_WelcomeToHQ");
						ObjectiveState.AlreadyPlayedNarratives.AddItem("X2NarrativeMoments.Strategy.GP_WelcomeToTheResistance");
					}
				}
			}
		}

		//Let the screen fade into the intro
		SetTimer(0.6f, false, nameof(StartIntroMovie));
		class'WorldInfo'.static.GetWorldInfo().GetALocalPlayerController().ClientSetCameraFade(true, MakeColor(0, 0, 0), vect2d(0, 1), 0.5);

		if(EnableTutorial && !((DevStrategyShell != none && DevStrategyShell.m_bSkipFirstTactical)))
		{
			//Controlled Start / Demo Direct
			`XCOMHISTORY.ResetHistory();
			EventManager.bTutorial = true;
			EventManager.bInitiateReplayAfterLoad = true;

			// Save campaign settings			
			EventManager.CampaignDifficultySetting = DifficultyToSet;
			EventManager.CampaignLowestDifficultySetting = DifficultyToSet;
			EventManager.CampaignTacticalDifficulty = TacticalPercent;
			EventManager.CampaignStrategyDifficulty = StrategyPercent;
			EventManager.CampaignGameLength = GameLengthPercent;
			EventManager.CampaignbIronmanEnabled = m_bIronmanFromShell;
			EventManager.CampaignbTutorialEnabled = true;
			EventManager.CampaignbXPackNarrativeEnabled = true; // Force XPack Narrative on if the player starts with the Tutorial
			EventManager.CampaignbIntegratedDLCEnabled = m_bIntegratedDLC;
			EventManager.CampaignbSuppressFirstTimeNarrative = false; // Do not allow beginner VO to be turned off in the tutorial
			EventManager.CampaignOptionalNarrativeDLC = EnabledOptionalNarrativeDLC;
			AddSecondWaveOptionsToOnlineEventManager(EventManager);

			for(idx = EventManager.GetNumDLC() - 1; idx >= 0; idx--)
			{
				EventManager.CampaignRequiredDLC.AddItem(EventManager.GetDLCNames(idx));
			}


			SetTimer(1.0f, false, nameof(LoadTutorialSave));
		}
		else
		{
			SetTimer(1.0f, false, nameof(DeferredConsoleCommand));
		}
	}
}

simulated function OnSecondWaveOptionClicked(UIList ContainerList, int ItemIndex)
{
	local UICheckbox CheckedBox;
	local int i;

	if (UIMechaListItem(m_SecondWaveList.GetItem(ItemIndex)).bDisabled)
	{
		return;
	}

	CheckedBox = UIMechaListItem(m_SecondWaveList.GetItem(ItemIndex)).Checkbox;
	CheckedBox.SetChecked(!CheckedBox.bChecked);

	if (SecondWaveOptionsReal[ItemIndex].ExclusiveGroup == '' || !CheckedBox.bChecked)
	{
		return;
	}
	
	for ( i = 0; i < SecondWaveOptionsReal.Length; i++ )
	{
		if (i != ItemIndex && SecondWaveOptionsReal[ItemIndex].ExclusiveGroup == SecondWaveOptionsReal[i].ExclusiveGroup)
		{
			UIMechaListItem(m_SecondWaveList.GetItem(i)).Checkbox.SetChecked(false);
		}
	}
}

simulated function OnAdvancedOptionsClicked()
{
	local UIPanel CurrentSelection;
	local UIMechaListItem item;
	CurrentSelection = m_SecondWaveList.Navigator.GetSelected();

	item = UIMechaListItem(CurrentSelection);

	if (item.bDisabled)
		return;

	if(item != none)
	{
		item.Checkbox.SetChecked(!item.Checkbox.bChecked);
	}
}