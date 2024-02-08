// Code borrowed from Strip Weapon Upgrades and modified

class UISL_PullAdvisors extends UIScreenListener;

var localized string m_strPullHavenAdvisors;
var localized string m_strPullHavenAdvisorsTooltip;

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
		NavHelp = `HQPRES.m_kAvengerHUD.NavHelp;
		if(NavHelp.m_arrButtonClickDelegates.Length > 0 && NavHelp.m_arrButtonClickDelegates.Find(OnPullHavenAdvisors) == INDEX_NONE)
		{
			NavHelp.AddCenterHelp(m_strPullHavenAdvisors,, OnPullHavenAdvisors, false, m_strPullHavenAdvisorsTooltip);
		}
		Screen.SetTimer(0.6f, false, nameof(AddHelp), self);
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

}

