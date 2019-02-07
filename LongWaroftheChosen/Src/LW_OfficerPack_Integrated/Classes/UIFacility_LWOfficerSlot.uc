//---------------------------------------------------------------------------------------
//  FILE:    UIFacility_LWOfficerSlot.uc
//  AUTHOR:  Amineri
//           
//  PURPOSE: Reworked UIFacility_StaffSlot for officer functionality
//---------------------------------------------------------------------------------------

class UIFacility_LWOfficerSlot extends UIFacility_StaffSlot
	dependson(UIPersonnel);

var localized string m_strTrainOfficerDialogTitle;
var localized string m_strTrainOfficerDialogText;
var localized string m_strStopTrainOfficerDialogTitle;
var localized string m_strStopTrainOfficerDialogText;

//-----------------------------------------------------------------------------
simulated function OnClickStaffSlot(UIPanel kControl, int cmd)
{
	local XComGameState_StaffSlot StaffSlot;
	local XComGameState_Unit UnitState;
	//local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_HeadquartersProjectTrainLWOfficer TrainProject;
	local string StopTrainingText;

	StaffSlot = XComGameState_StaffSlot(`XCOMHISTORY.GetGameStateForObjectID(StaffSlotRef.ObjectID));

	switch (cmd)
	{
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_DOUBLE_UP:
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_UP_DELAYED:
		if (StaffSlot.IsLocked())
		{
			ShowUpgradeFacility();
		}
		else if (StaffSlot.IsSlotEmpty())
		{
			//StaffContainer.ShowDropDown(self);
			OnOfficerTrainSelected();
		}
		else // Ask the user to confirm that they want to empty the slot and stop training
		{
			//XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
			UnitState = StaffSlot.GetAssignedStaff();
			TrainProject = class'X2StrategyElement_LW_OTS_OfficerStaffSlot'.static.GetLWOfficerTrainProject(UnitState.GetReference(), StaffSlot);

			StopTrainingText = m_strStopTrainOfficerDialogText;
			StopTrainingText = Repl(StopTrainingText, "%UNITNAME", UnitState.GetName(eNameType_RankFull));
			StopTrainingText = Repl(StopTrainingText, "%CLASSNAME", TrainProject.GetTrainingAbilityFriendlyName());

			ConfirmEmptyProjectSlotPopup(m_strStopTrainOfficerDialogTitle, StopTrainingText);
		}
		break;
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT:
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_RELEASE_OUTSIDE:
		if(!StaffSlot.IsLocked())
		{
			StaffContainer.HideDropDown(self);
		}
		break;
	}
}

simulated function QueueDropDownDisplay()
{
	OnClickStaffSlot(none, class'UIUtilities_Input'.const.FXS_L_MOUSE_DOUBLE_UP);
	//m_QueuedDropDown = true;
}

simulated function OnOfficerTrainSelected()
{
	//local XGParamTag LocTag;
	local TDialogueBoxData DialogData;
	//local XComGameState_Unit Unit;
	//local UICallbackData_StateObjectReference CallbackData;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_CampaignSettings Settings;
	local name FlagName;
	local XComGameState NewGameState;

	FlagName = 'LWOfficerPack_WarningPlayed';

	XComHQ = `XCOMHQ;
	Settings = XComGameState_CampaignSettings(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings'));
	if (!Settings.bSuppressFirstTimeNarrative && XComHQ.SeenClassMovies.Find(FlagName) == INDEX_NONE)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState ("Update Officer Training Warning Flag");
		XComHQ = XComGameState_HeadquartersXCom (NewGameState.CreateStateObject (class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
		NewGameState.AddStateObject (XComHQ);
		XComHQ.SeenClassMovies.AddItem(FlagName);
		`GAMERULES.SubmitGameState (NewGameState);

		DialogData.fnCallbackEx = TrainOfficerDialogCallback;
		DialogData.eType = eDialog_Alert;
		DialogData.strTitle = m_strTrainOfficerDialogTitle;
		DialogData.strText = m_strTrainOfficerDialogText;
		DialogData.strAccept = class'UIUtilities_Text'.default.m_strGenericYes;
		DialogData.strCancel = class'UIUtilities_Text'.default.m_strGenericNo;

		Movie.Pres.UIRaiseDialog(DialogData);
	}
	else
	{
		// go directly to soldier list and bypass warning
		TrainOfficerDialogCallback('eUIAction_Accept', none);
	}
}

simulated function OnPersonnelSelected(StaffUnitInfo UnitInfo)
{
	local XGParamTag LocTag;
	local TDialogueBoxData DialogData;
	local XComGameState_Unit Unit;
	local UICallbackData_StateObjectReference CallbackData;

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitInfo.UnitRef.ObjectID));

	LocTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	LocTag.StrValue0 = Unit.GetName(eNameType_RankFull);

	CallbackData = new class'UICallbackData_StateObjectReference';
	CallbackData.ObjectRef = Unit.GetReference();
	DialogData.xUserData = CallbackData;
	DialogData.fnCallbackEx = TrainOfficerDialogCallback;

	DialogData.eType = eDialog_Alert;
	DialogData.strTitle = m_strTrainOfficerDialogTitle;
	DialogData.strText = `XEXPAND.ExpandString(m_strTrainOfficerDialogText);
	DialogData.strAccept = class'UIUtilities_Text'.default.m_strGenericYes;
	DialogData.strCancel = class'UIUtilities_Text'.default.m_strGenericNo;

	Movie.Pres.UIRaiseDialog(DialogData);
}

simulated function TrainOfficerDialogCallback(Name eAction, UICallbackData xUserData)
{
	local UIPersonnel_LWOfficer kPersonnelList;
	local XComHQPresentationLayer HQPres;
	//local UICallbackData_StateObjectReference CallbackData;
	local XComGameState_StaffSlot StaffSlotState;
	
	//CallbackData = UICallbackData_StateObjectReference(xUserData);
	
	if (eAction == 'eUIAction_Accept')
	{
		HQPres = `HQPRES;
		StaffSlotState = XComGameState_StaffSlot(`XCOMHISTORY.GetGameStateForObjectID(StaffSlotRef.ObjectID));

		//Don't allow clicking of Personnel List is active or if staffslot is filled
		if(HQPres.ScreenStack.IsNotInStack(class'UIPersonnel') && !StaffSlotState.IsSlotFilled())
		{
			kPersonnelList = Spawn( class'UIPersonnel_LWOfficer', HQPres);
			kPersonnelList.m_eListType = eUIPersonnel_Soldiers;
			kPersonnelList.onSelectedDelegate = OnSoldierSelected;
			kPersonnelList.m_bRemoveWhenUnitSelected = true;
			kPersonnelList.SlotRef = StaffSlotRef;
			HQPres.ScreenStack.Push( kPersonnelList );
		}
	}
}

simulated function OnSoldierSelected(StateObjectReference _UnitRef)
{
	local UIArmory_LWOfficerPromotion OfficerScreen;
	local XComHQPresentationLayer HQPres;

	HQPres = `HQPRES;
	OfficerScreen = UIArmory_LWOfficerPromotion(HQPres.ScreenStack.Push(HQPres.Spawn(class'UIArmory_LWOfficerPromotion', HQPres), HQPres.Get3DMovie()));
	OfficerScreen.InitPromotion(_UnitRef, false);
	OfficerScreen.CreateSoldierPawn();
}


//==============================================================================

defaultproperties
{
	width = 370;
	height = 65;
}
