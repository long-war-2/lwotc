//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_ShellDifficulty
//  AUTHOR:  Amineri / Pavonis Interactive, Peter Ledbrook (LWOTC)
//
//  PURPOSE: Detects whether there are incompatible LWS mods when starting a new game.
//           Also loads saved second wave options and applies them to the screen so
//           players don't have to change the second wave options every new campaign.
//--------------------------------------------------------------------------------------- 

class UIScreenListener_ShellDifficulty extends UIScreenListener config(LW_Overhaul);

var config array<name> IntegratedMods;

var localized string strIncompatibleModsTitle;
var localized string strIncompatibleModsText;
var localized array<string> Credits;

event OnInit(UIScreen Screen)
{
	local UIShellDifficultySW ShellDifficultyUI;
	local SecondWavePersistentData SWPersistentData;
	local SecondWavePersistentDataDefaults SWPersistentDataDefaults;
	local int i, OptionIndex;
	local bool UseDefaultOption;

	ShellDifficultyUI = UIShellDifficultySW(Screen);
	if (ShellDifficultyUI == none && UILoadGame(Screen) == none)
		return;

	// check for any duplicates of standalone mods that have been integrated into overhaul mod
	CheckForDuplicateLWSMods(Screen);

	UIShellDifficulty(Screen).ForceTutorialOff();

	// Don't do the rest of the initialisation if this is the UILoadGame screen
	if (ShellDifficultyUI == none)
		return;

	// Initialise second wave options with and saved settings
	SWPersistentData = new class'SecondWavePersistentData';
	SWPersistentDataDefaults = new class'SecondWavePersistentDataDefaults';
	for (i = 0; i < ShellDifficultyUI.SecondWaveOptionsReal.Length; i++)
	{
		// Find the saved value for this second wave option. If there is
		// no saved value, fall back to the configured default value if
		// it exists.
		UseDefaultOption = false;
		OptionIndex = SWPersistentData.SecondWaveOptionList.Find('ID', ShellDifficultyUI.SecondWaveOptionsReal[i].OptionData.ID);
		if (OptionIndex == INDEX_NONE)
		{
			OptionIndex = SWPersistentDataDefaults.SecondWaveOptionList.Find('ID', ShellDifficultyUI.SecondWaveOptionsReal[i].OptionData.ID);
			UseDefaultOption = true;
		}

		if (OptionIndex != INDEX_NONE)
		{
			if (UseDefaultOption)
			{
				UIMechaListItem(ShellDifficultyUI.m_SecondWaveList.GetItem(i)).Checkbox.SetChecked(SWPersistentDataDefaults.SecondWaveOptionList[OptionIndex].IsChecked);
			}
			else
			{
				UIMechaListItem(ShellDifficultyUI.m_SecondWaveList.GetItem(i)).Checkbox.SetChecked(SWPersistentData.SecondWaveOptionList[OptionIndex].IsChecked);
			}
		}

		// Disable Precision Explosives second wave option
		if (ShellDifficultyUI.SecondWaveOptionsReal[i].OptionData.ID == 'ExplosiveFalloff')
		{
			UIMechaListItem(ShellDifficultyUI.m_SecondWaveList.GetItem(i)).Checkbox.SetChecked(false);
			UIMechaListItem(ShellDifficultyUI.m_SecondWaveList.GetItem(i)).SetDisabled(true, class'UIListener_CampaignStartMenu'.default.strDisabledPrecisionExplosivesTooltip);
		}
	}

	// If a valid difficulty has been saved, pre select that
	if (SWPersistentData.IsDifficultySet && SWPersistentData.Difficulty >= 0 &&
		SWPersistentData.Difficulty < `MAX_DIFFICULTY_INDEX)
	{
		for (i = 0; i < `MAX_DIFFICULTY_INDEX; i++)
		{
			switch (i)
			{
			case 0:
				ShellDifficultyUI.m_DifficultyRookieMechaItem.Checkbox.SetChecked(SWPersistentData.Difficulty == i);
				break;
			case 1:
				ShellDifficultyUI.m_DifficultyVeteranMechaItem.Checkbox.SetChecked(SWPersistentData.Difficulty == i);
				break;
			case 2:
				ShellDifficultyUI.m_DifficultyCommanderMechaItem.Checkbox.SetChecked(SWPersistentData.Difficulty == i);
				break;
			case 3:
				ShellDifficultyUI.m_DifficultyLegendMechaItem.Checkbox.SetChecked(SWPersistentData.Difficulty == i);
				break;
			}
		}
	}

	// Apply the remembered setting for Disable Beginner VO
	ShellDifficultyUI.m_FirstTimeVOMechaItem.Checkbox.SetChecked(SWPersistentData.DisableBeginnerVO);

	// Disable credits for now. LWOTC TODO: Consider adding a button or something rather than
	// overlapping screen real estate.
	// if (UIShellDifficulty(Screen) != none)
	// {
		// AddLogoAndCredits(Screen);
	// }
}

function AddLogoAndCredits(UIScreen Screen)
{
	local UIImage LongWar2Image;
	local UIImage PavonisImage;
	local UITextContainer CreditsText;
	//local UIVerticalScrollingText2 CreditsText2;
	local string CreditsString, CreditsLine;

    LongWar2Image = Screen.Spawn(class'UIImage', Screen);
	LongWar2Image.bAnimateOnInit = false;
	LongWar2Image.InitImage('LongWar2ShellImage', "img:///UILibrary_LW_Overhaul.longwar_fin_white");
    LongWar2Image.SetPosition(-436, -103);
    LongWar2Image.SetScale(0.818);

    PavonisImage = Screen.Spawn(class'UIImage', Screen);
	PavonisImage.bAnimateOnInit = false;
	PavonisImage.InitImage('PavonisShellImage', "img:///UILibrary_LW_Overhaul.512pxPavonisLogofinalmerged");
    PavonisImage.SetPosition(-461, 510);
    PavonisImage.SetScale(0.5);

	CreditsString = "";

	CreditsString $= "v" $ string (Class'LWVersion'.default.MajorVersion) $ "." $ string (Class'LWVersion'.default.MinorVersion) $ "\n";

	foreach default.Credits(CreditsLine)
	{
		CreditsString $= CreditsLine $ "\n";
	}

	CreditsText	 = Screen.Spawn(class'UITextContainer', Screen);	
	CreditsText.bAnimateOnInit = false;
	CreditsText.InitTextContainer( , "", 1050, 250, 618-70, 258, true, , true);
	CreditsText.SetHTMLText(class'UIUtilities_Text'.static.GetColoredText(CreditsString, eUIState_Normal,,"CENTER"));
	CreditsText.bg.SetAlpha(75);

	//CreditsText2 = Screen.Spawn(class'UIVerticalScrollingText2', Screen);	
	//CreditsText2.bAnimateOnInit = false;
	//CreditsText2.InitVerticalScrollingText( , "", -283+70, 510, 618-70, 258, true);
	//CreditsText2.SetHTMLText(class'UIUtilities_Text'.static.GetColoredText(CreditsString, eUIState_Normal,,"CENTER"));
	//CreditsText2.bg.SetAlpha(75);

}

function CheckForDuplicateLWSMods(UIScreen Screen)
{
	local array<X2DownloadableContentInfo> DLCInfos;
	local name DLCName;
	local int i;
	local string DuplicateMods;
	local TDialogueBoxData DialogData;
	local UIScreenStack ScreenStack;

	DLCInfos = `ONLINEEVENTMGR.GetDLCInfos(false);
	for(i = 0; i < DLCInfos.Length; ++i)
	{
		DLCName = name(DLCInfos[i].DLCIdentifier);
		if (default.IntegratedMods.Find(DLCName) != -1)
		{
			if (DuplicateMods != "")
				DuplicateMods $= ", ";

			DuplicateMods $= DLCInfos[i].DLCIdentifier;
		}
	}
	if (DuplicateMods != "")
	{
		DialogData.eType = eDialog_Warning;
		DialogData.strTitle = strIncompatibleModsTitle;
		DialogData.strText = Repl(strIncompatibleModsText, "%modnames%", DuplicateMods);
		DialogData.strCancel = class'UIUtilities_Text'.default.m_strGenericOK;
		Screen.Movie.Pres.UIRaiseDialog(DialogData);
	}

	ScreenStack = `SCREENSTACK;
	ScreenStack.PrintScreenStack();
}

defaultProperties
{
    ScreenClass = none
}
