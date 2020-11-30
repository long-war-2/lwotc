//---------------------------------------------------------------------------------------
//  FILE:	 UIScreenListener_RecruitSoldiers.uc
//  AUTHOR:	 KDM
//  PURPOSE: Pushes a Long War of the Chosen compatible recruit screen onto the screen stack
//	in place of the base recruit screen.
//--------------------------------------------------------------------------------------- 

class UIScreenListener_RecruitSoldiers extends UIScreenListener;

event OnInit(UIScreen Screen)
{
	local UIRecruitSoldiers_LWOTC RecruitScreen;
	local XComHQPresentationLayer HQPres;
	
	HQPres = `HQPRES;

	HQPres.ScreenStack.Pop(Screen);
	RecruitScreen = HQPres.Spawn(class'UIRecruitSoldiers_LWOTC', HQPres);
	HQPres.ScreenStack.Push(RecruitScreen);
}

defaultproperties
{ 
	// KDM : Only listen for the UIRecruitSoldiers screen.
	ScreenClass = class'UIRecruitSoldiers';
}
