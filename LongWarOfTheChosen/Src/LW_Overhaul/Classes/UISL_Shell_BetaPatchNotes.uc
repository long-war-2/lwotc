//---------------------------------------------------------------------------------------
//  FILE:   UISL Shell LWoTCVersion.uc                                    
//           
//	ORIGINAL CREATED BY SHIREMCT
//	BEGIN EDITS BY RUSTYDIOS    	    21/02/21	03:00
//	LAST EDITED BY RUSTYDIOS    	    30/04/23	21:00
//  MODIFIED FOR LWOTC BY TEDSTER       17/10/23    19:00 
// 
//		!!	DONT FORGET TO ACTUALLY UPDATE THE CONFIG NUMBER ON UPDATES	!!
//	EACH MOD SHOULD HAVE UNIQUE CLASS_NAME AND CONFIG FILE
//	ALSO A LOCALIZATION\MODNAME.INT WITH THE STRINGS UNDER THE HEADER [CLASS_NAME]
//
//---------------------------------------------------------------------------------------

class UISL_Shell_BetaPatchNotes extends UIScreenListener config(LWoTC_Version);

var config int			iVERSION;
var int					iVersion_Installed;

var localized string	strMessage_Title, strMessage_Header, strMessage_Body, strDismiss_Button;

var UIBGBox 		WarningBkgGrnd_LWoTC;
var UIPanel 		WarningPanel_LWoTC;
var UIImage			WarningImage_LWoTC;
var UIX2PanelHeader WarningTitle_LWoTC;
var UITextContainer WarningHeader_LWoTC, WarningBody_LWoTC;
var UIButton		DismissButton_LWoTC;

event OnInit(UIScreen Screen)
{
	// DO WE CREATE THIS OR NOT, YES TO FIRST WARNING = 0, YES TO TESTING = -1, YES TO EACH UPDATE = NEW > OLD
	if(ShouldShowWarningMsg())
	{
		CreatePanel_ConfigWarning_LWoTC(Screen);
	}

	return;
}

simulated function  CreatePanel_ConfigWarning_LWoTC(UIScreen Screen)
{
	local int X, Y, W, H;

 	// pos x, 	pos y , 	width, 		height
	X = 500;	Y = 300;	W = 800;	H = 420;

	// CREATE A PANEL WITH A BACKGROUND PANEL AND LITTLE IMAGE
	WarningBkgGrnd_LWoTC = Screen.Spawn(class'UIBGBox', Screen);
	WarningBkgGrnd_LWoTC.LibID = class'UIUtilities_Controls'.const.MC_X2Background;
	WarningBkgGrnd_LWoTC.InitBG('ConfigPopup_BG_LWoTC', X, Y, W, H);

	WarningPanel_LWoTC = Screen.Spawn(class'UIPanel', Screen);
	WarningPanel_LWoTC.InitPanel('ConfigPopup_LWoTC');
	WarningPanel_LWoTC.SetSize(WarningBkgGrnd_LWoTC.Width, WarningBkgGrnd_LWoTC.Height);		//800, 420
	WarningPanel_LWoTC.SetPosition(WarningBkgGrnd_LWoTC.X, WarningBkgGrnd_LWoTC.Y);			//500, 300

	WarningImage_LWoTC = Screen.Spawn(class'UIImage', Screen);
	WarningImage_LWoTC.InitImage(, "img:///UILibrary_LWOTC.SampleSquadIcons.SquadIcon0");
	WarningImage_LWoTC.SetScale(0.25);
	WarningImage_LWoTC.SetPosition(WarningBkgGrnd_LWoTC.X + WarningBkgGrnd_LWoTC.Width - 90, WarningBkgGrnd_LWoTC.Y + 20);

	// CREATE A TITLE, COOL ONE WITH THE HAZARD BAR
	WarningTitle_LWoTC = Screen.Spawn(class'UIX2PanelHeader', WarningPanel_LWoTC);
	WarningTitle_LWoTC.InitPanelHeader('', class'UIUtilities_Text'.static.GetColoredText(strMessage_Title @ class'LWVersion'.static.GetShortVersionString(), eUIState_Bad, 32), "");	//red
    WarningTitle_LWoTC.SetPosition(WarningTitle_LWoTC.X + 10, WarningTitle_LWoTC.Y + 10);		//510, 310
    WarningTitle_LWoTC.SetHeaderWidth(WarningPanel_LWoTC.Width - 20);					//780

	// CREATE A ONE LINE HEADER
	WarningHeader_LWoTC = Screen.Spawn(class'UITextContainer', WarningPanel_LWoTC);
	WarningHeader_LWoTC.InitTextContainer();
	WarningHeader_LWoTC.bAutoScroll = true;
	WarningHeader_LWoTC.SetSize(WarningBkgGrnd_LWoTC.Width - 40, 30); 					//760, 30
	WarningHeader_LWoTC.SetPosition(WarningHeader_LWoTC.X + 20, WarningHeader_LWoTC.Y +60);	//520, 360

	WarningHeader_LWoTC.Text.SetHTMLText( class'UIUtilities_Text'.static.StyleText(strMessage_Header, eUITextStyle_Tooltip_H1, eUIState_Warning2));	//orange
	
	// CREATE THE ACTUAL MESSAGE
	WarningBody_LWoTC = Screen.Spawn(class'UITextContainer', WarningPanel_LWoTC);
	WarningBody_LWoTC.InitTextContainer();
	WarningBody_LWoTC.bAutoScroll = true;
	WarningBody_LWoTC.SetSize(WarningBkgGrnd_LWoTC.Width - 40, WarningBkgGrnd_LWoTC.Height - 150);	//760, 270
	WarningBody_LWoTC.SetPosition(WarningBody_LWoTC.X +20, WarningBody_LWoTC.Y + 90);					//520, 390

	WarningBody_LWoTC.Text.SetHTMLText( class'UIUtilities_Text'.static.StyleText(strMessage_Body, eUITextStyle_Tooltip_Body, eUIState_Normal));	//cyan
    WarningBody_LWoTC.Text.SetHeight(WarningBody_LWoTC.Text.Height * 3.0f);                   

	// CREATE A DISMISS BUTTON
	DismissButton_LWoTC = Screen.Spawn(class'UIButton', WarningPanel_LWoTC);
	DismissButton_LWoTC.InitButton('DismissButton_LWoTC', strDismiss_Button, DismissButton_LWoTCHandler, );
	DismissButton_LWoTC.SetSize(760, 30); 
	DismissButton_LWoTC.SetResizeToText(true);
	DismissButton_LWoTC.AnchorTopCenter();			//AUTO
	DismissButton_LWoTC.OriginTopCenter();			//AUTO
	DismissButton_LWoTC.SetPosition(DismissButton_LWoTC.X - 60, WarningBkgGrnd_LWoTC.Y +375);
}

// CLEAR EVERYTHING ON BUTTON PRESS
simulated function DismissButton_LWoTCHandler(UIButton Button)
{
	DismissButton_LWoTC.Remove();

	WarningBody_LWoTC.Remove();
	WarningHeader_LWoTC.Remove();
	WarningTitle_LWoTC.Remove();
	WarningImage_LWoTC.Remove();
	WarningPanel_LWoTC.Remove();
	WarningBkgGrnd_LWoTC.Remove();
}

// SHOULD WE DISPLAY THE POPUP BASED ON CONFIG NUMBER
static function bool ShouldShowWarningMsg()
{
	// Show it because the version number is set to negative (testing)... 
	if (default.iVersion_Installed <= -1)
	{	
		return true; 
	}

	// Show it this first time because it's the first version that establishes the version numbers
	if (default.iVERSION == 0 )
	{	
		default.iVersion = default.iVersion_Installed;
		StaticSaveConfig();
		return true; 
	}

	// Older version detected - Show update warning
	if (default.iVERSION < default.iVersion_Installed)
	{	
		default.iVersion = default.iVersion_Installed;
		StaticSaveConfig();
		return true;
	}

	// Same version, backup config save - Don't display
	default.iVersion = default.iVersion_Installed;
	StaticSaveConfig();
	return false;
}




// DONT FORGET TO ACTUALLY UPDATE THE CONFIG NUMBER ON UPDATES
// DO THIS IS ONLY ON THE FINAL SHELL - MAIN MENU SCREEN IN REVIEW MODE
defaultproperties
{
	ScreenClass = UIFinalShell;
	iVersion_Installed = 3;
}
