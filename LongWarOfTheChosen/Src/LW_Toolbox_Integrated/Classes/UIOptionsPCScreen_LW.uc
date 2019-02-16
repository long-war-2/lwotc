//--------------------------------------------------------------------------------------- 
//  FILE:    UIOptionsPCScreen_LW
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Extends Options screen to allow mods to add configuration tabs
//--------------------------------------------------------------------------------------- 

class UIOptionsPCScreen_LW extends UIOptionsPCScreen dependson(UIDialogueBox) config(LW_Toolbox);

//

var UIList TabList;
var int FontSize, TabHeight;
var array<XComGameState_LWModOptions> ButtonToModStateMapping;

var config int TabListPadding;

var UIButton ResetModOptionsButton;
var localized string m_strResetCurrentModOption;


var XComGameState_LWToolboxOptions ToolboxOptions;
var config bool TestingTooltips;

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	super.InitScreen(InitController, InitMovie, InitName);		

	TabList = Spawn(class'UIList', self);
	TabList.InitList(, 93, 160, 185, 525, false, false);
	TabList.bIsNavigable = false; // only allow keyboard/gamepad navigation on options, not on tabs
	TabList.itemPadding = default.TabListPadding;

	ButtonToModStateMapping.Length = 0;
}

simulated function RefreshData()
{
	local int ButtonIdx;
	//local UIListItemString Item; 
	local bool                  bIsConsole; //Used to hide some options if only PC or only console
	local string                strGraphics;
	local XComGameStateHistory History;
	local XComGameState_CampaignSettings CampaignSettingsStateObject;
	local int ComponentObjectID;
	local XComGameState_LWModOptions ModSettingsComponent;
	local XComGameState UpdateState;

	History = `XCOMHISTORY;

	CampaignSettingsStateObject = XComGameState_CampaignSettings(History.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings', true));

	ButtonToModStateMapping.Add(5);

	if(!TestingTooltips && CampaignSettingsStateObject == none)
	{
		super.RefreshData();
		return;
	}
	else
	{
		bIsConsole = WorldInfo.IsConsoleBuild(); 

		strGraphics = bIsConsole ? "" : default.m_strTabGraphics;

		AS_SetTitle(default.m_strTitle);	

		//clear existing hard-coded 5 tabs
		AS_SetTabData("", "", "", "", "");

		TabList.SetSelectedNavigation();
		TabList.Navigator.LoopSelection = true;

		AddListItem(m_strTabAudio);
		AddListItem(m_strTabVideo);
		AddListItem(strGraphics);
		AddListItem(m_strTabGameplay);
		AddListItem(m_strTabInterface);

		ButtonIdx=5;

		if(TestingTooltips)  // this is some code to force ToolboxOptions to display in the MainMenu, although it can't save any options
		{
			UpdateState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Adding Mod Options Component");
			ToolboxOptions = XComGameState_LWToolboxOptions(UpdateState.CreateStateObject(class'XComGameState_LWToolboxOptions'));
			ToolboxOptions.InitComponent(class'XComGameState_LWToolboxOptions');
			UpdateState.AddStateObject(ToolboxOptions);
			History.AddGameStateToHistory(UpdateState);

			RegisterUI(ButtonIdx++, ToolboxOptions);
			AddListItem(ToolboxOptions.GetTabText());
			ToolboxOptions.InitModOptions();
		}
		else
		{
			foreach CampaignSettingsStateObject.ComponentObjectIds(ComponentObjectID)
			{
				ModSettingsComponent = XComGameState_LWModOptions(History.GetGameStateForObjectID(ComponentObjectID));
				if(ModSettingsComponent != none)
				{
					RegisterUI(ButtonIdx++, ModSettingsComponent);
					AddListItem(ModSettingsComponent.GetTabText());
					ModSettingsComponent.InitModOptions();
					`LOG("UIOptionsPCScreen_LW: Registering" @ ModSettingsComponent.GetTabText(),, 'LW_Toolbox');
				}
			}
		}

		Show();
	}
	return;
}

simulated public function UpdateNavHelp ( bool bWipeButtons = false )
{
	super.UpdateNavHelp (bWipeButtons);

	if(ResetModOptionsButton == none )
	{
		ResetModOptionsButton = Spawn(class'UIButton', self);
		ResetModOptionsButton.InitButton(, m_strResetCurrentModOption, ResetCurrentModOptions);
		ResetModOptionsButton.SetPosition(690, 800); //Relative to this screen panel
		ResetModOptionsButton.Hide();
	}

}

simulated function AddListItem(string text)
{
	local UIListItemString Item; 
	
	Item = UIListItemString(TabList.CreateItem()).InitListItem(class'UIUtilities_Text'.static.GetSizedText(text, FontSize));
	//Item.SetHeight(TabHeight);
	Item.ButtonBG.OnClickedDelegate = OnTabButtonCallback;
}

simulated function RegisterUI(int idx,  XComGameState_LWModOptions ModSettingsComponent)
{
	ButtonToModStateMapping[idx] = ModSettingsComponent;
}

simulated function OnTabButtonCallback(UIButton kButton)
{
	local int idx;

	idx = TabList.GetItemIndex(kButton);
	SetSelectedTab(idx);
}

simulated function string GetTabText(int Index)
{
	local string returnString;

	switch(Index)
	{
	case 0:
		returnString = m_strTabAudio;
		break;
	case 1:
		returnString = m_strTabVideo;
		break;
	case 2:
		returnString = m_strTabGraphics;
		break;
	case 3:
		returnString = m_strTabGameplay;
		break;
	case 4:
		returnString = m_strTabInterface;
		break;
	default:
		if(Index > 4 && Index < ButtonToModStateMapping.Length)
		{
			returnString = ButtonToModStateMapping[Index].GetTabText();
		}
		else
		{
			returnString = "";
		}
		break;
	}
	return returnString;
}

simulated function SetSelectedTab(int iSelect, bool bForce = false)
{
	local int PreviousTabValue;
	PreviousTabValue = m_iCurrentTab;

	// hack no graphics on PC
	//if ( WorldInfo.IsConsoleBuild() )
	//{
		//if ( iSelect == 1 && m_iCurrentTab == 0 )
			//iSelect = 2;
		//else if ( iSelect == 1 && m_iCurrentTab == 2 )
			//iSelect = 0;
	//}

	//dont go to the same tab youve already selected
	if(m_iCurrentTab == iSelect && !bForce)
	{
		Movie.Pres.PlayUISound(eSUISound_MenuClickNegative);
		return;
	}

	m_iCurrentTab = iSelect; 

	// Wrap the ends
	if( m_iCurrentTab < 0 ) m_iCurrentTab = ButtonToModStateMapping.Length - 1;
	if( m_iCurrentTab > ButtonToModStateMapping.Length - 1 ) m_iCurrentTab = 0;

	//Clear the tooltips when switching tabs, else the previous tab tooltips may leak as cached data over on to the new tooltips. 
	Movie.Pres.m_kTooltipMgr.RemoveTooltipByTarget(string(MCPath), true);

	if(PreviousTabValue != m_iCurrentTab)
	{
		UnSelectTabByIndex(PreviousTabValue);
	}

	UpdateTabMechaItems();

	if( !`ISCONTROLLERACTIVE )
		List.Navigator.SetSelected(m_arrMechaItems[0]);

	if( bInputReceived == true )
	{
		Movie.Pres.PlayUISound(eSUISound_MenuSelect);
	}
	AttentionType = COAT_CATEGORIES;
	AS_SetTitle(m_strTitle $ ":" @ GetTabText(m_iCurrentTab));	
}

//LWS Override to disable controller spinner
function SetInterfaceTabSelected()
{
	local GFxObject InterfaceTabMC;
	//	local int i;
	local string strGameClassName;
	local bool bInShell;

	strGameClassName = String(WorldInfo.GRI.GameClass.name);
	bInShell = (strGameClassName == "XComShell");

	InterfaceTabMC = Movie.GetVariableObject(MCPath$".TabGroup.Tab4");
	if(InterfaceTabMC != none)
		InterfaceTabMC.ActionScriptVoid("select");
		
	ResetMechaListItems();

	// Key Bindings screen
	m_arrMechaItems[ePCTabInterface_KeyBindings].UpdateDataButton(m_strInterfaceLabel_KeyBindings, m_strInterfaceLabel_BindingsButton, OpenKeyBindingsScreen);
	m_arrMechaItems[ePCTabInterface_KeyBindings].BG.SetTooltipText(m_strInterfaceLabel_KeyBindings_Desc, , , 10, , , , 0.0f);
	m_arrMechaItems[ePCTabInterface_KeyBindings].SetDisabled(!m_kProfileSettings.Data.IsMouseActive());

	// Subtitles: -------------------------------------------
	m_arrMechaItems[ePCTabInterface_Subtitles].UpdateDataCheckbox(m_strInterfaceLabel_ShowSubtitles, "", m_kProfileSettings.Data.m_bSubtitles, UpdateSubtitles);
	m_arrMechaItems[ePCTabInterface_Subtitles].BG.SetTooltipText(m_strInterfaceLabel_ShowSubtitles_Desc, , , 10, , , , 0.0f);

	/* //TODO: enable these once integrated from controller. bsteiner 
	m_arrMechaItems[ePCTabInterface_AbilityGrid].UpdateDataCheckbox(m_strInterfaceLabel_AbilityGrid, "", m_kProfileSettings.Data.m_bAbilityGrid, UpdateAbilityGrid);
	m_arrMechaItems[ePCTabInterface_AbilityGrid].BG.SetTooltipText(m_strInterfaceLabel_AbilityGrid_Desc,,, 10,,,, 0.0f);
	if (`PRES.m_eUIMode == eUIMode_Tactical)
	{
		m_arrMechaItems[ePCTabInterface_AbilityGrid].SetDisabled(true);
		m_arrMechaItems[ePCTabInterface_AbilityGrid].BG.SetTooltipText(m_strInterfaceLabel_AbilityGridDisabled_Desc,,, 10,,,, 0.0f);
	}
*/
	m_arrMechaItems[ePCTabInterface_GeoscapeSpeed].UpdateDataSlider(m_strInterfaceLabel_GeoscapeSpeed, "", m_kProfileSettings.Data.m_GeoscapeSpeed,, UpdateGeoscapeSpeed);
	m_arrMechaItems[ePCTabInterface_GeoscapeSpeed].BG.SetTooltipText(m_strInterfaceLabel_GeoscapeSpeed_Desc,,, 10,,,, 0.0f);

	
	// Edge scrolling: -------------------------------------
	m_arrMechaItems[ePCTabInterface_EdgeScroll].UpdateDataSlider(m_strInterfaceLabel_EdgescrollSpeed, "", m_kProfileSettings.Data.m_fScrollSpeed, , UpdateEdgeScroll);
	m_arrMechaItems[ePCTabInterface_EdgeScroll].BG.SetTooltipText(m_strInterfaceLabel_EdgescrollSpeed_Desc, , , 10, , , , 0.0f);
	m_arrMechaItems[ePCTabInterface_EdgeScroll].SetDisabled(WorldInfo.IsConsoleBuild());

	// Input Device: --------------------------------------------
	m_arrMechaItems[ePCTabInterface_InputDevice].UpdateDataSpinner(m_strInterfaceLabel_InputDevice, GetInputDeviceLabel(),  UpdateInputDevice_CycleSpinner);
	m_arrMechaItems[ePCTabInterface_InputDevice].BG.SetTooltipText(m_strInterfaceLabel_InputDevice_Desc, , , 10, , , , 0.0f);

	//-------------------------------------------------------

/*	m_arrMechaItems[ePCTabInterface_KeyBindings].EnableNavigation();
	m_arrMechaItems[ePCTabInterface_Subtitles].EnableNavigation();
	m_arrMechaItems[ePCTabInterface_AbilityGrid].EnableNavigation();
	m_arrMechaItems[ePCTabInterface_GeoscapeSpeed].EnableNavigation();
	m_arrMechaItems[ePCTabInterface_EdgeScroll].EnableNavigation();
	m_arrMechaItems[ePCTabInterface_InputDevice].EnableNavigation();


	for( i = ePCTabInterface_Max; i < NUM_LISTITEMS; i++)
	{
		m_arrMechaItems[i].Hide();
		m_arrMechaItems[i].DisableNavigation();
	}*/

	RenableMechaListItems(ePCTabInterface_Max);

	m_arrMechaItems[ePCTabInterface_InputDevice].SetDisabled(true);

	if( !bInShell  ) 
	{
	//	m_arrMechaItems[ePCTabInterface_InputDevice].SetDisabled(!bInShell, m_strInterfaceLabel_InputDevice_ChangeInShell);
	}
}

simulated function UpdateTabMechaItems()
{
	local int NumModMechaItems;

	GPUAutoDetectButton.Hide();
	ResetModOptionsButton.Hide();

	if(m_iCurrentTab < 5)
	{
		switch(m_iCurrentTab)
		{
		case ePCTab_Video:
			SetVideoTabSelected();
			break;
		case ePCTab_Graphics:
			SetGraphicsTabSelected();
			UpdateNavHelp(true);
			GPUAutoDetectButton.Show();
			break;
		case ePCTab_Audio:
			SetAudioTabSelected();
			break;
		case ePCTab_Gameplay:
			SetGameplayTabSelected();
			break;
		case ePCTab_Interface:
			SetInterfaceTabSelected();
			break;
		}
	}
	else
	{
		ResetMechaListItems();
		NumModMechaItems = ButtonToModStateMapping[m_iCurrentTab].SetModOptionsEnabled(m_arrMechaItems);
		//`LOG("UIOptionsPCScreen_LW: Re-enabling" @ NumModMechaItems @ "mecha-items.",, 'LW_Toolbox');
		RenableMechaListItems(NumModMechaItems);
		if(ButtonToModStateMapping[m_iCurrentTab].CanResetModSettings())
			ResetModOptionsButton.Show();
	}
}

//simulated function bool OnUnrealCommand(int cmd, int ActionMask)
//{
	//if( !bIsInited || m_bSavingInProgress ) return true; 
//
	//bInputReceived = true;
	//// Ignore releases, only pay attention to presses.
	//if ( !CheckInputIsReleaseOrDirectionRepeat(cmd, ActionMask) )
		//return true; // Consume All Input!
//
	//switch(cmd)
	//{
		//case class'UIUtilities_Input'.const.FXS_BUTTON_X:
			//SaveAndExit(none);
			//break;
		//
		//case class'UIUtilities_Input'.const.FXS_BUTTON_B:
		//case class'UIUtilities_Input'.const.FXS_KEY_ESCAPE:
		//case class'UIUtilities_Input'.const.FXS_R_MOUSE_DOWN:
			//IgnoreChangesAndExit();
			//break;
//
		//case class'UIUtilities_Input'.const.FXS_BUTTON_Y:
			//ResetToDefaults();
			//break; 		
//
		//case class'UIUtilities_Input'.const.FXS_BUTTON_RTRIGGER:	
			//if( m_bAllowCredits )
				//Movie.Pres.UICredits( false );
			//break;
//
		//case class'UIUtilities_Input'.const.FXS_DPAD_UP:
		//case class'UIUtilities_Input'.const.FXS_ARROW_UP:
		//case class'UIUtilities_Input'.const.FXS_VIRTUAL_LSTICK_UP:
			//OnUDPadUp();
			//break;
//
		//case class'UIUtilities_Input'.const.FXS_DPAD_DOWN:
		//case class'UIUtilities_Input'.const.FXS_ARROW_DOWN:
		//case class'UIUtilities_Input'.const.FXS_VIRTUAL_LSTICK_DOWN:
			//OnUDPadDown();
			//break;
//
		//case class'UIUtilities_Input'.const.FXS_KEY_PAGEUP:
		//case class'UIUtilities_Input'.const.FXS_BUTTON_LBUMPER:
			//SetSelectedTab( m_iCurrentTab - 1);
			//break;
//
		//case class'UIUtilities_Input'.const.FXS_KEY_PAGEDN:
		//case class'UIUtilities_Input'.const.FXS_BUTTON_RBUMPER:
			//SetSelectedTab( m_iCurrentTab + 1 ); 
			//break;
//
		//default:
			//// Do not reset handled, consume input since this
			//// is the options menu which stops any other systems.
			//break;			
	//}
//
	//// Assume input is handled unless told otherwise (unlikely
	//// because this is the options menu; it handles alllllllll.)
	//return super(UIScreen).OnUnrealCommand(cmd, ActionMask);
//}

//helper function to see if any base-game OR mod options have been changed
simulated function bool HasAnyValueChanged()
{
	local XComGameState_LWModOptions ModOption;

	if(m_bAnyValueChanged)
		return true;

	foreach ButtonToModStateMapping(ModOption)
	{
		if(ModOption.HasAnyValueChanged())
			return true;
	}
	return false;
}

//override to allow checking if any mod options have been changed
simulated function IgnoreChangesAndExit()
{	
	local TDialogueBoxData kDialogData;

	if (HasAnyValueChanged() && `XENGINE.IsGPUAutoDetectRunning() == false)
	{
		kDialogData.strText = m_strIgnoreChangesDialogue;
		kDialogData.fnCallback = ConfirmUserWantsToIgnoreChanges; 
		kDialogData.strCancel = m_strIgnoreChangesCancel;
		kDialogData.strAccept = m_strIgnoreChangesConfirm;	

		XComPresentationLayerBase(Owner).UIRaiseDialog(kDialogData);
	}
	else
	{
		ExitScreen();
	}
}

//override to allow any mod options to revert settings
simulated function RestorePreviousProfileSettings()
{
	local XComGameState_LWModOptions ModOption;

	foreach ButtonToModStateMapping(ModOption)
	{
		ModOption.RestorePreviousModSettings();
	}
	super.RestorePreviousProfileSettings();
}

//override to allow mods to revert settings
simulated function ResetProfileSettings()
{
	local XComGameState_LWModOptions ModOption;

	foreach ButtonToModStateMapping(ModOption)
	{
		ModOption.ResetModSettings();
	}
	super.ResetProfileSettings();
}

//override to allow any mods to apply their changes on exit
simulated public function SaveAndExitFinal()
{
	local XComGameState_LWModOptions ModOption;

	foreach ButtonToModStateMapping(ModOption)
	{
		if(ModOption != none)
			ModOption.ApplyModSettings();
	}
	super.SaveAndExitFinal();
}

//new function to allow resetting just the current mod tab
simulated public function ResetCurrentModOptions(UIButton Button)
{
	if(m_iCurrentTab < 5)
		return;

	ButtonToModStateMapping[m_iCurrentTab].ResetModSettings();

	UpdateTabMechaItems();
}


defaultProperties
{
	FontSize = 20
	TabHeight = 40
}

