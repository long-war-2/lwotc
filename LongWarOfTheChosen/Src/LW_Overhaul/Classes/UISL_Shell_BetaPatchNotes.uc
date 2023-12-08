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

var string PathToPanelLWoTC;


event OnInit(UIScreen Screen)
{
	local UIPanel		Screen_BetaNotes_LWoTC;
	// DO WE CREATE THIS OR NOT, YES TO FIRST WARNING = 0, YES TO TESTING = -1, YES TO EACH UPDATE = NEW > OLD
	if(ShouldShowWarningMsg())
	{
		Screen_BetaNotes_LWoTC = Screen.Spawn(class'UIPanel', Screen);
		PathToPanelLWoTC = PathName(Screen_BetaNotes_LWoTC);
		Screen_BetaNotes_LWoTC.InitPanel('BetaPatchNotesScreen_BetaNotes_LWoTC');
		Screen_BetaNotes_LWoTC.SetSize(1920, 1080);		
		Screen_BetaNotes_LWoTC.SetPosition(0, 0);			
		CreatePanel_ConfigWarning_BetaNotes_LWoTC(Screen_BetaNotes_LWoTC);
	}

	return;
}

simulated function  CreatePanel_ConfigWarning_BetaNotes_LWoTC(UIPanel Screen)
{
	local int X, Y, W, H;

	local UIBGBox 		WarningBkgGrnd_BetaNotes_LWoTC;
	local UIPanel 		WarningPanel_BetaNotes_LWoTC;
	local UIImage			WarningImage_BetaNotes_LWoTC;
	local UIX2PanelHeader WarningTitle_BetaNotes_LWoTC;
	local UITextContainer WarningHeader_BetaNotes_LWoTC, WarningBody_BetaNotes_LWoTC;
	local UIButton		DismissButton_BetaNotes_LWoTC;


 	// pos x, 	pos y , 	width, 		height
	X = 500;	Y = 300;	W = 800;	H = 420;

	// CREATE A PANEL WITH A BACKGROUND PANEL AND LITTLE IMAGE
	WarningBkgGrnd_BetaNotes_LWoTC = Screen.Spawn(class'UIBGBox', Screen);
	WarningBkgGrnd_BetaNotes_LWoTC.LibID = class'UIUtilities_Controls'.const.MC_X2Background;
	WarningBkgGrnd_BetaNotes_LWoTC.InitBG('ConfigPopup_BG_BetaNotes_LWoTC', X, Y, W, H);

	WarningPanel_BetaNotes_LWoTC = Screen.Spawn(class'UIPanel', Screen);
	WarningPanel_BetaNotes_LWoTC.InitPanel('ConfigPopup_BetaNotes_LWoTC');
	WarningPanel_BetaNotes_LWoTC.SetSize(WarningBkgGrnd_BetaNotes_LWoTC.Width, WarningBkgGrnd_BetaNotes_LWoTC.Height);		//800, 420
	WarningPanel_BetaNotes_LWoTC.SetPosition(WarningBkgGrnd_BetaNotes_LWoTC.X, WarningBkgGrnd_BetaNotes_LWoTC.Y);			//500, 300

	WarningImage_BetaNotes_LWoTC = Screen.Spawn(class'UIImage', Screen);
	WarningImage_BetaNotes_LWoTC.InitImage(, "img:///UILibrary_LWOTC.SampleSquadIcons.SquadIcon0");
	WarningImage_BetaNotes_LWoTC.SetScale(0.25);
	WarningImage_BetaNotes_LWoTC.SetPosition(WarningBkgGrnd_BetaNotes_LWoTC.X + WarningBkgGrnd_BetaNotes_LWoTC.Width - 90, WarningBkgGrnd_BetaNotes_LWoTC.Y + 20);

	// CREATE A TITLE, COOL ONE WITH THE HAZARD BAR
	WarningTitle_BetaNotes_LWoTC = Screen.Spawn(class'UIX2PanelHeader', WarningPanel_BetaNotes_LWoTC);
	WarningTitle_BetaNotes_LWoTC.InitPanelHeader('', class'UIUtilities_Text'.static.GetColoredText(strMessage_Title @ class'LWVersion'.static.GetShortVersionString(), eUIState_Bad, 32), "");	//red
    WarningTitle_BetaNotes_LWoTC.SetPosition(WarningTitle_BetaNotes_LWoTC.X + 10, WarningTitle_BetaNotes_LWoTC.Y + 10);		//510, 310
    WarningTitle_BetaNotes_LWoTC.SetHeaderWidth(WarningPanel_BetaNotes_LWoTC.Width - 20);					//780

	// CREATE A ONE LINE HEADER
	WarningHeader_BetaNotes_LWoTC = Screen.Spawn(class'UITextContainer', WarningPanel_BetaNotes_LWoTC);
	WarningHeader_BetaNotes_LWoTC.InitTextContainer();
	WarningHeader_BetaNotes_LWoTC.bAutoScroll = true;
	WarningHeader_BetaNotes_LWoTC.SetSize(WarningBkgGrnd_BetaNotes_LWoTC.Width - 40, 30); 					//760, 30
	WarningHeader_BetaNotes_LWoTC.SetPosition(WarningHeader_BetaNotes_LWoTC.X + 20, WarningHeader_BetaNotes_LWoTC.Y +60);	//520, 360

	WarningHeader_BetaNotes_LWoTC.Text.SetHTMLText( class'UIUtilities_Text'.static.StyleText(strMessage_Header, eUITextStyle_Tooltip_H1, eUIState_Warning2));	//orange
	
	// CREATE THE ACTUAL MESSAGE
	WarningBody_BetaNotes_LWoTC = Screen.Spawn(class'UITextContainer', WarningPanel_BetaNotes_LWoTC);
	WarningBody_BetaNotes_LWoTC.InitTextContainer();
	WarningBody_BetaNotes_LWoTC.bAutoScroll = true;
	WarningBody_BetaNotes_LWoTC.SetSize(WarningBkgGrnd_BetaNotes_LWoTC.Width - 40, WarningBkgGrnd_BetaNotes_LWoTC.Height - 150);	//760, 270
	WarningBody_BetaNotes_LWoTC.SetPosition(WarningBody_BetaNotes_LWoTC.X +20, WarningBody_BetaNotes_LWoTC.Y + 90);					//520, 390

	WarningBody_BetaNotes_LWoTC.Text.SetHTMLText( class'UIUtilities_Text'.static.StyleText(strMessage_Body, eUITextStyle_Tooltip_Body, eUIState_Normal));	//cyan
    WarningBody_BetaNotes_LWoTC.Text.SetHeight(WarningBody_BetaNotes_LWoTC.Text.Height * 3.0f);                   

	// CREATE A DISMISS BUTTON
	DismissButton_BetaNotes_LWoTC = Screen.Spawn(class'UIButton', WarningPanel_BetaNotes_LWoTC);
	DismissButton_BetaNotes_LWoTC.InitButton('DismissButton_BetaNotes_LWoTC', strDismiss_Button, DismissButton_BetaNotes_LWoTCHandler, );
	DismissButton_BetaNotes_LWoTC.SetSize(760, 30); 
	DismissButton_BetaNotes_LWoTC.SetResizeToText(true);
	DismissButton_BetaNotes_LWoTC.AnchorTopCenter();			//AUTO
	DismissButton_BetaNotes_LWoTC.OriginTopCenter();			//AUTO
	DismissButton_BetaNotes_LWoTC.SetPosition(DismissButton_BetaNotes_LWoTC.X - 60, WarningBkgGrnd_BetaNotes_LWoTC.Y +375);
}

// CLEAR EVERYTHING ON BUTTON PRESS
simulated function DismissButton_BetaNotes_LWoTCHandler(UIButton Button)
{
	local UIPanel Panel;
	Panel = UIPanel(FindObject(PathToPanelLWoTC, class'UIPanel'));
	Panel.Remove();
	PathToPanelLWoTC = "";
}

event OnRemoved(UIScreen Screen)
{
	PathToPanelLWoTC = "";
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
	iVersion_Installed = 16; // 16
}
