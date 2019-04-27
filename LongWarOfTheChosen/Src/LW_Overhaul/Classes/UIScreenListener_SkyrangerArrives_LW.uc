//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener
//  AUTHOR:  Amineri / Pavonis Interactive
//
//  PURPOSE: Provides functionality for launching infiltration missions after skyranger arrival
//--------------------------------------------------------------------------------------- 

class UIScreenListener_SkyrangerArrives_LW extends UIScreenListener;

var localized string strLaunchInfiltration;
var localized string strAbortInfiltration;
var localized string strContinueInfiltration;

event OnInit(UIScreen Screen)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_LWSquadManager SquadMgr;
	local XComGameState_LWPersistentSquad Squad;
	local UISkyrangerArrives SkyrangerArrives;


	if(!Screen.IsA('UISkyrangerArrives')) return;

	SkyrangerArrives = UISkyrangerArrives(Screen);
	if(SkyrangerArrives == none) return;

	XComHQ = `XCOMHQ;
	SquadMgr = `LWSQUADMGR;

	if(SquadMgr.IsValidInfiltrationMission(XComHQ.SelectedDestination))
	{
		InstallInputHandler(true);
		
		Squad = SquadMgr.GetSquadOnMission(XComHQ.SelectedDestination);
		if (Squad != none) // there was a squad so we are aborting
		{
			if (Squad.bCannotCancelAbort)
			{
				OnAbortInfiltration(SkyrangerArrives.Button1);
			}
			else
			{
				SkyrangerArrives.Button1.OnClickedDelegate = OnAbortInfiltration;
				SkyrangerArrives.Button1.SetText(strAbortInfiltration);
				SkyrangerArrives.Button2.OnClickedDelegate = OnContinueInfiltration;
				SkyrangerArrives.Button2.SetText(strContinueInfiltration);
			}
		}
		else  // no current squad, so are starting infiltration
		{
			SkyrangerArrives.Button1.OnClickedDelegate = OnLaunchInfiltration;
			SkyrangerArrives.Button1.SetText(strLaunchInfiltration);

			PlaySkyrangerArrivesNarrativeMoment();
		}
	}
	else // not an infiltration
	{
		PlaySkyrangerArrivesNarrativeMoment();
	}
}

event OnReceiveFocus(UIScreen Screen)
{
	InstallInputHandler();
}

event OnLoseFocus(UIScreen Screen)
{
	`SCREENSTACK.UnsubscribeFromOnInput(ChangeEnterBehavior);
}

event OnRemoved(UIScreen Screen)
{
	`SCREENSTACK.UnsubscribeFromOnInput(ChangeEnterBehavior);
}

// LWOTC: Override SkyrangerArrives screen's input handler so that
// enter, spacebar and controller A button all launch the infiltration
// (or abort it if there is a squad already there) rather than launch
// the mission immediately.
function InstallInputHandler(optional bool ForceInstall = false)
{
	if (ForceInstall || `LWSQUADMGR.IsValidInfiltrationMission(`XCOMHQ.SelectedDestination))
	{
		`SCREENSTACK.SubscribeToOnInput(ChangeEnterBehavior);
	}
}

simulated function PlaySkyrangerArrivesNarrativeMoment()
{
	local XComGameState_Objective ObjectiveState;

	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Objective', ObjectiveState)
	{
		if (ObjectiveState.GetMyTemplateName() == 'N_InDropPosition')
		{
			// WOTC TODO: This looks a bit hacky - check that it works
			ObjectiveState.OnNarrativeEventTrigger(none, none, none, 'OnSkyrangerArrives',none);
			break;
		}
	}
}

simulated function PlayAbortInfiltrationNarrativeMoment()
{
	local XComHQPresentationLayer HQPres;

	HQPres = `HQPRES;

	switch (`SYNC_RAND(4))
	{
		case 0:
			HQPres.UINarrative(XComNarrativeMoment'X2NarrativeMoments.T_EVAC_All_Out_Firebrand_02');
			break;
		case 1:
			HQPres.UINarrative(XComNarrativeMoment'X2NarrativeMoments.T_EVAC_All_Out_Firebrand_03');
			break;
		case 2:
			HQPres.UINarrative(XComNarrativeMoment'X2NarrativeMoments.T_EVAC_All_Out_Firebrand_04');
			break;
		case 3:
			HQPres.UINarrative(XComNarrativeMoment'X2NarrativeMoments.T_EVAC_All_Out_Firebrand_05');
			break;
		default:
			break;
	}
}

simulated function OnAbortInfiltration(UIButton Button)
{
	local UISkyrangerArrives SkyrangerArrives;
	local XComGameState_MissionSite SelectedDestinationMission;

	SelectedDestinationMission = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(`XCOMHQ.SelectedDestination.ObjectID));
	if (SelectedDestinationMission == none)
	{
		`REDSCREEN("Attempting to abort infiltration on non-mission entity");
		return;
	}
	`LWSQUADMGR.UpdateSquadPostMission(SelectedDestinationMission.GetReference());
	SelectedDestinationMission.InteractionComplete(true);

	SkyrangerArrives = UISkyrangerArrives(Button.GetParent(class'UISkyrangerArrives'));
	if (SkyrangerArrives != none)
	{
		SkyrangerArrives.CloseScreen();
	}
	else
	{
		`REDSCREEN("Unable to find UISkyrangerArrives to close when aborting infiltration");
	}
	PlayAbortInfiltrationNarrativeMoment();
}

simulated function OnContinueInfiltration(UIButton Button)
{
	local UISkyrangerArrives SkyrangerArrives;
	local XComGameState_MissionSite SelectedDestinationMission;

	SelectedDestinationMission = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(`XCOMHQ.SelectedDestination.ObjectID));
	if (SelectedDestinationMission == none)
	{
		`REDSCREEN("Attempting to continue infiltration on non-mission entity");
	}
	SelectedDestinationMission.InteractionComplete(true);

	SkyrangerArrives = UISkyrangerArrives(Button.GetParent(class'UISkyrangerArrives'));
	if (SkyrangerArrives != none)
	{
		SkyrangerArrives.CloseScreen();
	}
}

simulated function OnLaunchInfiltration(UIButton Button)
{
	local XComGameState NewGameState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_LWSquadManager SquadMgr, UpdatedSquadMgr;
	local XComGameState_LWPersistentSquad Squad;
	local StateObjectReference NullRef;
	local UISkyrangerArrives SkyrangerArrives;

	XComHQ = `XCOMHQ;
	SquadMgr = `LWSQUADMGR;

	if(SquadMgr.LaunchingMissionSquad.ObjectID > 0)
	{

		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Sending existing squad on infiltration mission");
		Squad = XComGameState_LWPersistentSquad(NewGameState.CreateStateObject(class'XComGameState_LWPersistentSquad', SquadMgr.LaunchingMissionSquad.ObjectID));
		NewGameState.AddStateObject(Squad);

		Squad.SquadSoldiersOnMission = XComHQ.Squad;
		Squad.InitInfiltration(NewGameState, XComHQ.MissionRef, 0.0);
		Squad.SetOnMissionSquadSoldierStatus(NewGameState);

		UpdatedSquadMgr = XComGameState_LWSquadManager(NewGameState.CreateStateObject(SquadMgr.Class, SquadMgr.ObjectID));
		NewGameState.AddStateObject(UpdatedSquadMgr);
		UpdatedSquadMgr.LaunchingMissionSquad = NullRef;

		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
	else // not persistent, create a new temporary squad for this mission
	{
		Squad = SquadMgr.AddSquad(XComHQ.Squad, XComHQ.MissionRef);
	}

	// skyranger flies back to avenger after dropping off to start infiltration
	SkyrangerArrives = UISkyrangerArrives(Button.GetParent(class'UISkyrangerArrives'));
	if (SkyrangerArrives != none)
		SkyrangerArrives.GetMission().InteractionComplete(true);

	SkyrangerArrives.CloseScreen();

	//cancel the squad deploying music
	`XSTRATEGYSOUNDMGR.PlayGeoscapeMusic();

	//clear the squad so it's not populated again for next mission
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Clearing existing squad from HQ");
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	XComHQ.Squad.Length = 0;
	NewGameState.AddStateObject(XComHQ);
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

}

// Overrides the Enter and Spacebar buttons and the controller's
// A button to launch infiltration. This is to get round some
// hard-coded logic in the base UIMission classes that bypass the
// button delegates.
function bool ChangeEnterBehavior(int iInput, int ActionMask)
{
	local UISkyrangerArrives SkyrangerArrives;
	
	if ((ActionMask & class'UIUtilities_Input'.const.FXS_ACTION_RELEASE) == 0)
	{
		return false;
	}
	
	SkyrangerArrives = UISkyrangerArrives(`SCREENSTACK.GetFirstInstanceOf(class'UISkyrangerArrives'));
	
	switch (iInput)
	{
	case class'UIUtilities_Input'.const.FXS_BUTTON_A:
	case class'UIUtilities_Input'.const.FXS_KEY_ENTER:
	case class'UIUtilities_Input'.const.FXS_KEY_SPACEBAR:
		// If there is a squad at the mission site, then they're already
		// infiltrating and we should abort the mission. Otherwise, launch
		// the mission.
		if (`LWSQUADMGR.GetSquadOnMission(`XCOMHQ.SelectedDestination) != none)
		{
			OnAbortInfiltration(SkyrangerArrives.Button1);
		}
		else {
			OnLaunchInfiltration(SkyrangerArrives.Button1);
		}
		return true;
		
	default: return false;
	}
}

defaultproperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = UISkyrangerArrives;
}