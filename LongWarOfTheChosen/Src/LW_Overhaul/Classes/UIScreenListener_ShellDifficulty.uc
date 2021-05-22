//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_ShellDifficulty
//  AUTHOR:  Amineri / Pavonis Interactive
//
//  PURPOSE: Detects whether there are incompatible LWS mods when starting a new game
//--------------------------------------------------------------------------------------- 

class UIScreenListener_ShellDifficulty extends UIScreenListener config(LW_Overhaul);

var config array<name> IntegratedMods;

var localized string strIncompatibleModsTitle;
var localized string strIncompatibleModsText;
var localized array<string> Credits;

event OnInit(UIScreen Screen)
{
	if (UIShellDifficulty(Screen) == none && UILoadGame(Screen) == none)
		return;

	// check for any duplicates of standalone mods that have been integrated into overhaul mod
	CheckForDuplicateLWSMods(Screen);

	UIShellDifficulty(Screen).ForceTutorialOff();

	// Disable credits for now. LWOTC TODO: Consider adding a button or something rather than
	// overlapping screen real estate.
	// if (UIShellDifficulty(Screen) != none)
	// {
	// 	AddLogoAndCredits(Screen);
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
