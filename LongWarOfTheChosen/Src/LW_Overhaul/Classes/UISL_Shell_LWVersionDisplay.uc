class UISL_Shell_LWVersionDisplay extends UIScreenListener;

event OnInit(UIScreen Screen)
{
	if(UIShell(Screen) == none)  // this captures UIShell and UIFinalShell
		return;

    ShowLWVersion(UIShell(Screen));
}

event OnReceiveFocus(UIScreen Screen)
{
	if(UIShell(Screen) == none)   // this captures UIShell and UIFinalShell
		return;

	ShowLWVersion(UIShell(Screen));
}

function ShowLWVersion(UIShell ShellScreen)
{
    local UIText VersionText;

    local string VersionTextString;

    `LWTrace("Show LW version init");

    VersionText = UIText(ShellScreen.GetChildByName('theLWVersionText', false));
	if (VersionText == none)
	{
        `LWTrace("VersionText panel init");
        VersionText = ShellScreen.Spawn(class'UIText', ShellScreen);
	    VersionText.InitText('theLWVersionText');
	
	    VersionText.AnchorBottomLeft();
	    VersionText.SetY(-25);
    }
    
    VersionTextString = "LWOTC" @ class'LWVersion'.static.GetVersionString();

    `LWTrace("Version Text string:" @VersionTextString);

    if (`ISCONTROLLERACTIVE)
	{
		VersionText.SetHTMLText(class'UIUtilities_Text'.static.InjectImage(class'UIUtilities_Input'.static.GetGamepadIconPrefix() 
								$ class'UIUtilities_Input'.const.ICON_RSCLICK_R3, 20, 20, -10) 
								@ VersionTextString, OnTextSizeRealized);
	}
	else
	{
        `LWTrace("VersionText SetHTMLText");
		VersionText.SetHTMLText(VersionTextString, OnTextSizeRealized);
	}


}

// Borrowed from CHL
function OnTextSizeRealized()
{
	local UIText VersionText;
	local UIShell ShellScreen;

	ShellScreen = UIShell(`SCREENSTACK.GetFirstInstanceOf(class'UIShell'));
	VersionText = UIText(ShellScreen.GetChildByName('theLWVersionText'));
	VersionText.SetX(5);
	// this makes the ticker shorter -- if the text gets long enough to interfere, it will automatically scroll
	ShellScreen.TickerText.SetWidth(ShellScreen.Movie.m_v2ScaledFullscreenDimension.X - VersionText.Width - 20);

}

defaultProperties
{
	ScreenClass = none
}
