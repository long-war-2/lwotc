class LW2_UISquadIconSelectionScreen extends UIScreen config(LW2SquadIcons);

// reference to the screen that actually contains the squad (personnel)
// neede for cbs
var UIPersonnel_SquadBarracks BelowScreen;

var UIPanel m_kContainer;
var UIX2PanelHeader m_kTitleHeader;
var UIBGBox m_kBG;

var LW2_UIImageSelector ImageSelector;

var config int iWidth, iHeight;

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{

	local float initX, initY;
	local float initWidth, initHeight;
	
	super.InitScreen(InitController, InitMovie, InitName);

	initX = (1920 - iWidth) / 2;
	initY = (1080 - iHeight) / 2;
	initWidth = iWidth;
	initHeight = iHeight;
	
	m_kContainer = Spawn(class'UIPanel', self);
	m_kContainer.InitPanel('');
	m_kContainer.SetPosition(initX, initY);
	m_kContainer.SetSize(initWidth, initHeight);

	m_kBG = Spawn(class'UIBGBox', m_kContainer);
	m_kBG.LibID = class'UIUtilities_Controls'.const.MC_X2Background;
	m_kBG.InitBG('', 0, 0, m_kContainer.Width, m_kContainer.Height);
	m_kBG.DisableNavigation();

	m_kTitleHeader = Spawn(class'UIX2PanelHeader', m_kContainer);
	m_kTitleHeader.InitPanelHeader('', "Select Squad Image", "");
	m_kTitleHeader.SetHeaderWidth(m_kContainer.width - 20);
	m_kTitleHeader.SetPosition(10, 20);

	ImageSelector = Spawn(class'LW2_UIImageSelector', m_kContainer);
	ImageSelector.InitImageSelector(, 0, 70, m_kContainer.Width - 10, m_kContainer.height - 80, BelowScreen.SquadImagePaths, , SetSquadImage, BelowScreen.SquadImagePaths.Find(BelowScreen.GetCurrentSquad().SquadImagePath));
}

function SetSquadImage(int iImageIndex)
{
	local XComGameState NewGameState;
	local XComGameState_LWPersistentSquad Squad; 

	Squad = BelowScreen.GetCurrentSquad();


	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Change Squad ImagePath");
	Squad = XComGameState_LWPersistentSquad(NewGameState.CreateStateObject(class'XComGameState_LWPersistentSquad', Squad.ObjectID));
	Squad.SquadImagePath = BelowScreen.SquadImagePaths[iImageIndex];
	NewGameState.AddStateObject(Squad);
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

	BelowScreen.UpdateSquadHeader();
	BelowScreen.UpdateSquadList();

	OnCancel();
} 


simulated function bool OnUnrealCommand(int cmd, int arg)
{
	local bool bHandled;

	// Only pay attention to presses or repeats; ignoring other input types
	// NOTE: Ensure repeats only occur with arrow keys
	if ( !CheckInputIsReleaseOrDirectionRepeat(cmd, arg) )
		return false;

	bHandled = true;
	switch( cmd )
	{
		case class'UIUtilities_Input'.const.FXS_BUTTON_B:
		case class'UIUtilities_Input'.const.FXS_KEY_ESCAPE:
		case class'UIUtilities_Input'.const.FXS_R_MOUSE_DOWN:
			OnCancel();
			break;
		default:
			bHandled = false;
			break;
	}

	return bHandled || super.OnUnrealCommand(cmd, arg);
}

simulated function OnCancel()
{
	BelowScreen.bHideOnLoseFocus = true;
	CloseScreen();
}


defaultproperties
{
	bConsumeMouseEvents = true
	InputState = eInputState_Consume;
}