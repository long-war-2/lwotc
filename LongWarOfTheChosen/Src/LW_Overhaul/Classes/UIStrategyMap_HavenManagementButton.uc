//---------------------------------------------------------------------------------------
//  AUTHOR:  Rai 
//  PURPOSE: New Geoscape button, positioned above the factions "triangle" at the bottom
//           to access the resistance outpost screen quickly from the geoscape
//---------------------------------------------------------------------------------------
//  Credit: Adapted from WOTCStrategyOverhaul Team's code for CI
//---------------------------------------------------------------------------------------

class UIStrategyMap_HavenManagementButton extends UIPanel;

var UIStrategyMap StrategyMap;

var UIPanel BG;
var UIText Label;
var UIImage ControllerIcon;
var UIImage ResistanceOutpost;

var protected float TimeSinceLastColourSwitch;
var protected bool bCurrentlyAttention;
var protected bool bFlashing;
var privatewrite string LabelText;

const NEW_ACTION_FLASH_DURATION = 1;

simulated function InitHMButton()
{
	InitPanel('HavenManagementButton');

	StrategyMap = UIStrategyMap(GetParent(class'UIStrategyMap', true));

	BG = Spawn(class'UIPanel', self);
	BG.InitPanel('BG', 'X2MenuBG');
	BG.AnchorBottomCenter();
	BG.SetWidth(140);
	BG.SetX(-(BG.Width / 2));
	BG.SetAlpha(80);

	// Rai - Add resistance outpost icon. Note that the extra space
	// added to the label prevents the icon from appearing twice.
	LabelText = class'UIUtilities_Text'.static.InjectImage("img:///UILibrary_StrategyImages.X2StrategyMap.MissionIcon_ResHQ", 32, 32, ) $ " ";
	
	Label = Spawn(class'UIText', self);
	Label.InitText('Label');
	Label.AnchorBottomCenter();
	Label.SetX(BG.X + 5);
	Label.SetWidth(BG.Width - 10);
	Label.OnTextSizeRealized = OnLabelSizeRealized;

	UpdateLabel();
	SubscribeToEvents();

	// PAL: I've enabled follow mouse for the tooltip because I can't get it to
	// position over the "button" otherwise.
	SetTooltipText(
		class'XComGameState_LWOutpostManager'.default.TooltipCQ_ResistanceManagement,
		class'XComGameState_LWOutpostManager'.default.LabelCQ_ResistanceManagement,
		,,,,, 0.5f);
}

simulated protected function RealizeLayout()
{
	BG.SetHeight(Max(50, Label.Height + 10));
	BG.SetY(-(133 + BG.Height));

	if (ControllerIcon != none)
	{
		ControllerIcon.SetY(BG.Y + (BG.Height - ControllerIcon.Height) / 2);
	}

	Label.SetY(BG.Y + 5);
}

simulated protected function UpdateLabel()
{
	local EUIState Colour;
	local int FontSize;

	Colour = bIsFocused ? eUIState_Header : eUIState_Normal;
	FontSize = bIsFocused ? 18 : 20;

	Label.SetCenteredText(class'UIUtilities_Text'.static.GetColoredText(
			class'UIUtilities_Text'.static.AddFontInfo(LabelText, Screen.bIsIn3D,,, FontSize),
			Colour));
}

simulated protected function OnLabelSizeRealized()
{
	RealizeLayout();
}

simulated function OnReceiveFocus()
{
	super.OnReceiveFocus();

	UpdateLabel();
}

simulated function OnLoseFocus()
{
	super.OnLoseFocus();

	UpdateLabel();
}

simulated function OnMouseEvent(int cmd, array<string> args)
{
	super.OnMouseEvent(cmd, args);

	switch (cmd)
	{
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_UP:
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_DOUBLE_UP:
		OnClicked();
		break;
	}
}

simulated protected function OnClicked()
{
	if (Movie.Pres.ScreenStack.GetCurrentScreen() != StrategyMap) return;
	if (StrategyMap.IsInFlightMode()) return;

	class'XComGameState_LWOutpostManager'.static.OpenResistanceManagementScreen();
	OnLoseFocus();
}

simulated event Removed()
{
	super.Removed();

	UnsubscribeFromAllEvents();
}

/////////////////////////////
/// Geoscape flight event ///
/////////////////////////////

simulated protected function SubscribeToEvents()
{
	local X2EventManager EventManager;
	local Object ThisObj;

	EventManager = `XEVENTMGR;
    ThisObj = self;

	EventManager.RegisterForEvent(ThisObj, 'GeoscapeFlightModeUpdate', OnGeoscapeFlightModeUpdate,, 99);
}

simulated protected function UnsubscribeFromAllEvents()
{
    local Object ThisObj;

    ThisObj = self;
    `XEVENTMGR.UnRegisterFromAllEvents(ThisObj);
}

simulated protected function EventListenerReturn OnGeoscapeFlightModeUpdate(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	SetVisible(!StrategyMap.IsInFlightMode());

	return ELR_NoInterrupt;
}

defaultproperties
{
	bIsNavigable = false;
	bProcessesMouseEvents = true;
}
