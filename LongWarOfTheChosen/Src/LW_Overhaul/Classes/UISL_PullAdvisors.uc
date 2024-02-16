// Code borrowed from Strip Weapon Upgrades and modified

class UISL_PullAdvisors extends UIScreenListener;

var localized string m_strPullHavenAdvisors;
var localized string m_strPullHavenAdvisorsTooltip;
var localized string m_StrHavenManagement;
var localized string m_StrHavenManagementTooltip;

event OnInit(UIScreen Screen)
{
	RefreshSS(Screen);
}

event OnReceiveFocus(UIScreen Screen)
{
	RefreshSS(Screen);
}

simulated function AddHelp()
{
	local UISquadSelect Screen;
	local UINavigationHelp NavHelp;

	Screen = UISquadSelect(`SCREENSTACK.GetCurrentScreen());

	if (Screen != none)
	{
		if(!screen.bNoCancel)
		{
			NavHelp = `HQPRES.m_kAvengerHUD.NavHelp;
			/*
			// Tedster - disable this button
			if(NavHelp.m_arrButtonClickDelegates.Length > 0 && NavHelp.m_arrButtonClickDelegates.Find(OnPullHavenAdvisors) == INDEX_NONE)
			{
				NavHelp.AddCenterHelp(m_strPullHavenAdvisors,, OnPullHavenAdvisors, false, m_strPullHavenAdvisorsTooltip);
			}
			*/
			if(NavHelp.m_arrButtonClickDelegates.Length > 0 && NavHelp.m_arrButtonClickDelegates.Find(OnResistanceManagementButton) == INDEX_NONE)
			{
				NavHelp.AddCenterHelp(m_StrHavenManagement,, OnResistanceManagementButton, false, m_StrHavenManagementTooltip);
			}
			Screen.SetTimer(0.6f, false, nameof(AddHelp), self);
		}
	}
}

simulated function RefreshSS(UIScreen Screen)
{
	local UISquadSelect SquadSelectScrn;

	SquadSelectScrn = UISquadSelect(Screen);

	if (SquadSelectScrn != none && (`XCOMHQ != none && `XCOMHQ.bReuseUpgrades))
	{
		AddHelp();
	}
}

simulated function OnPullHavenAdvisors()
{
    local XComGameState_LWOutpostManager OutpostManager;
    local XComGameState_LWOutpost OutpostState;
	local StateObjectReference OutpostRef, EmptyRef;
    local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_HeadquartersXCom XComHQ;

	History = `XCOMHISTORY;
    OutpostManager = class'XComGameState_LWOutpostManager'.static.GetOutpostManager();

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Removing liaisons from outposts.");

    foreach OutpostManager.Outposts (OutpostRef)
	{
		OutpostState = XComGameState_LWOutpost(History.GetGameStateForObjectID(OutpostRef.ObjectID));

		if(OutpostState != none)
		{
			if(OutpostState.CanLiaisonBeMoved())
			{
				OutpostState.SetLiaison(EmptyRef, NewGameState);
			}
		}
	}

	if( NewGameState.GetNumGameStateObjects() > 0 )
		`GAMERULES.SubmitGameState(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);

	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	XComHQ.HandlePowerOrStaffingChange();

}

simulated function OnResistanceManagementButton()
{
	local UIResistanceManagement_LW ResistanceOverviewScreen;
	local XComHQPresentationLayer HQPres;

	HQPres = `HQPRES;

	if (!HQPres.ScreenStack.HasInstanceOf(class'UIResistanceManagement_LW'))
	{
		ResistanceOverviewScreen = HQPres.Spawn(class'UIResistanceManagement_LW', HQPres);
		ResistanceOverviewScreen.EnableCameraPan = false;
		ResistanceOverviewScreen.bSquadSelect = true;
		HQPres.ScreenStack.Push(ResistanceOverviewScreen);
	}
}
