//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_HeadquartersProjectTrainLWOfficer.uc
//  AUTHOR:  Amineri
//  PURPOSE: This object represents the instance data for an XCom HQ train officer project, LW version
//           This has to extend the TrainRookie project so that certain hard-coded functions will recognize the training project
//---------------------------------------------------------------------------------------
class XComGameState_HeadquartersProjectTrainLWOfficer extends XComGameState_HeadquartersProjectTrainRookie config (LW_OfficerPack);

//var() name NewClassName; // the name of the class the rookie will eventually be promoted to
var name AbilityName;	// name of the ability being trained
var int NewRank;		// the new officer rank to be achieved

//---------------------------------------------------------------------------------------
// Call when you start a new project, NewGameState should be none if not coming from tactical
function SetProjectFocus(StateObjectReference FocusRef, optional XComGameState NewGameState, optional StateObjectReference AuxRef)
{
	local XComGameStateHistory History;
	local XComGameState_GameTime TimeState;
	local XComGameState_Unit UnitState;

	History = `XCOMHISTORY;
	ProjectFocus = FocusRef; // Unit
	AuxilaryReference = AuxRef; // Facility
	
	ProjectPointsRemaining = CalculatePointsToTrain();
	InitialProjectPoints = ProjectPointsRemaining;

	UnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ProjectFocus.ObjectID));
	//UnitState.PsiTrainingRankReset();
	UnitState.SetStatus(eStatus_Training);

	UpdateWorkPerHour(NewGameState);
	TimeState = XComGameState_GameTime(History.GetSingleGameStateObjectForClass(class'XComGameState_GameTime'));
	StartDateTime = TimeState.CurrentTime;

	if (`STRATEGYRULES != none)
	{
		if (class'X2StrategyGameRulesetDataStructures'.static.LessThan(TimeState.CurrentTime, `STRATEGYRULES.GameTime))
		{
			StartDateTime = `STRATEGYRULES.GameTime;
		}
	}
	
	if (MakingProgress())
	{
		SetProjectedCompletionDateTime(StartDateTime);
	}
	else
	{
		// Set completion time to unreachable future
		CompletionDateTime.m_iYear = 9999;
	}
}

//---------------------------------------------------------------------------------------
function int CalculatePointsToTrain()
{
	Local int TrainingTime;
	local XComGameState_Unit UnitState;
	
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ProjectFocus.ObjectID));
	TrainingTime = int(class'LWOfficerUtilities'.static.GetOfficerTrainingDays(NewRank) * 24.0);

	if (UnitState.HasSoldierAbility('QuickStudy'))
		TrainingTime /= 2;

	return TrainingTime;
}

//---------------------------------------------------------------------------------------
function int CalculateWorkPerHour(optional XComGameState StartState = none, optional bool bAssumeActive = false)
{
	return 1;
}

function string GetTrainingAbilityFriendlyName()
{
	return class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(AbilityName).LocFriendlyName;
}

function name GetTrainingAbilityName()
{
	return AbilityName;
}

//---------------------------------------------------------------------------------------
// Remove the project
function OnProjectCompleted()
{
	local XComGameStateHistory History;
	local XComHeadquartersCheatManager CheatMgr;
	local XComGameState_HeadquartersXCom XComHQ, NewXComHQ;
	local XComGameState_Unit Unit;
	local XComGameState_Unit UpdatedUnit;
	local XComGameState_Unit_LWOfficer OfficerState;
	local XComGameState UpdateState;
	local XComGameStateContext_ChangeContainer ChangeContainer;
	local SoldierClassAbilityType Ability;
	local ClassAgnosticAbility NewOfficerAbility, CommandBonusRangeAbility;
	local XComGameState_HeadquartersProjectTrainLWOfficer ProjectState;
	local XComGameState_StaffSlot StaffSlotState;

	Ability.AbilityName = AbilityName;
	Ability.ApplyToWeaponSlot = eInvSlot_Unknown;
	Ability.UtilityCat = '';
	NewOfficerAbility.AbilityType = Ability;
	NewOfficerAbility.iRank = NewRank;
	NewOfficerAbility.bUnlocked = true;

	History = `XCOMHISTORY;
	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ProjectFocus.ObjectID));
	
	ChangeContainer = class'XComGameStateContext_ChangeContainer'.static.CreateEmptyChangeContainer("LW Officer Training Complete");
	UpdateState = History.CreateNewGameState(true, ChangeContainer);
	UpdatedUnit = XComGameState_Unit(UpdateState.CreateStateObject(class'XComGameState_Unit', Unit.ObjectID));

	OfficerState = class'LWOfficerUtilities'.static.GetOfficerComponent(Unit);
	OfficerState = XComGameState_Unit_LWOfficer(UpdateState.CreateStateObject(class'XComGameState_Unit_LWOfficer', OfficerState.ObjectID));

	OfficerState.SetOfficerRank(NewRank);
	
	UpdatedUnit = class'LWOfficerUtilities'.static.AddInitialAbilities(UpdatedUnit, OfficerState, UpdateState);

	OfficerState.LastAbilityTrainedName = OfficerState.AbilityTrainingName;
	//OfficerState.SetRankTraining(-1, '');
	//UpdatedUnit.AWCAbilities.AddItem(NewOfficerAbility);
	OfficerState.OfficerAbilities.AddItem(NewOfficerAbility);

	// Remove the previous command range buff ability if there is one and attach
	// the new one.
	if (NewRank > 1)
	{
		foreach OfficerState.OfficerAbilities(CommandBonusRangeAbility)
		{
			if (CommandBonusRangeAbility.AbilityType.AbilityName == class'LWOfficerUtilities'.static.GetCommandRangeAbilityName(NewRank - 1))
			{
				OfficerState.OfficerAbilities.RemoveItem(CommandBonusRangeAbility);
			}
		}
	}
	OfficerState.OfficerAbilities.AddItem(CreateCommandBonusRangeAbility(NewRank));

	UpdatedUnit.SetStatus(eStatus_Active);

	//ProjectState = XComGameState_HeadquartersProjectTrainLWOfficer(`XCOMHISTORY.GetGameStateForObjectID(ProjectRef.ObjectID));
	ProjectState = XComGameState_HeadquartersProjectTrainLWOfficer(`XCOMHISTORY.GetGameStateForObjectID(GetReference().ObjectID));
	if (ProjectState != none)
	{
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
		if (XComHQ != none)
		{
			NewXComHQ = XComGameState_HeadquartersXCom(UpdateState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
			UpdateState.AddStateObject(NewXComHQ);
			NewXComHQ.Projects.RemoveItem(ProjectState.GetReference());
			UpdateState.RemoveStateObject(ProjectState.ObjectID);
		}


		// Remove the soldier from the staff slot
		StaffSlotState = UpdatedUnit.GetStaffSlot();
		if (StaffSlotState != none)
		{
			StaffSlotState.EmptySlot(UpdateState);
		}
	}

	UpdateState.AddStateObject(UpdatedUnit);
	UpdateState.AddStateObject(OfficerState);
	UpdateState.AddStateObject(ProjectState);
	`GAMERULES.SubmitGameState(UpdateState);

	CheatMgr = XComHeadquartersCheatManager(class'WorldInfo'.static.GetWorldInfo().GetALocalPlayerController().CheatManager);
	if (CheatMgr == none || !CheatMgr.bGamesComDemo)
	{
		UITrainingComplete(ProjectFocus);
	}
}

function UITrainingComplete(StateObjectReference UnitRef)
{
	local UIAlert_LWOfficerTrainingComplete Alert;
	local XComHQPresentationLayer HQPres;

	HQPres = `HQPres;
	`Log("Training complete for " $ UnitRef.ObjectID);

	Alert = HQPres.Spawn(class'UIAlert_LWOfficerTrainingComplete', HQPres);
	Alert.eAlertName = 'eAlert_TrainingComplete';
	//Alert.DisplayPropertySet.SecondaryRoutingKey = Alert.eAlertName;
	class'X2StrategyGameRulesetDataStructures'.static.AddDynamicIntProperty(Alert.DisplayPropertySet, 'UnitRef', UnitRef.ObjectID);
	Alert.DisplayPropertySet.CallbackFunction = TrainingCompleteCB;
	class'X2StrategyGameRulesetDataStructures'.static.AddDynamicStringProperty(Alert.DisplayPropertySet, 'SoundToPlay', "Geoscape_CrewMemberLevelledUp");
	HQPres.ScreenStack.Push(Alert);

}

simulated function TrainingCompleteCB(Name eAction, out DynamicPropertySet AlertData, optional bool bInstants = false)
{
	//local XComGameState NewGameState; 
	local XComHQPresentationLayer HQPres;
	local StateObjectReference UnitRef;

	HQPres = `HQPres;

	`Log("TrainingCompleteCB starting");
	
	//NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Unit Promotion");
	//`XEVENTMGR.TriggerEvent('UnitPromoted', , , NewGameState);
	//`GAMERULES.SubmitGameState(NewGameState);

	if (!HQPres.m_kAvengerHUD.Movie.Stack.HasInstanceOf(class'UIArmory_LWOfficerPromotion')) // If we are already in the promotion screen, just close this popup
	{
		
		if (eAction == 'eUIAction_Accept')
		{
			UnitRef.ObjectID = class'X2StrategyGameRulesetDataStructures'.static.GetDynamicIntProperty(AlertData, 'UnitRef');
			GoToArmoryLWOfficerPromotion(UnitRef, true);
		}
		else
		{
			`GAME.GetGeoscape().Resume();
		}
	}
}

simulated function GoToArmoryLWOfficerPromotion(StateObjectReference UnitRef, optional bool bInstantb = false)
{
	//local XComGameState_HeadquartersXCom XComHQ;
	//local XComGameState_FacilityXCom ArmoryState;
	local UIArmory_LWOfficerPromotion OfficerScreen;
	local XComHQPresentationLayer HQPres;

	HQPres = `HQPres;
	
	if (`GAME.GetGeoscape().IsScanning())
		HQPres.StrategyMap2D.ToggleScan();

	//call Armory_MainMenu to populate pawn data
	if(HQPres.ScreenStack.IsNotInStack(class'UIArmory_MainMenu'))
		UIArmory_MainMenu(HQPres.ScreenStack.Push(HQPres.Spawn(class'UIArmory_MainMenu', HQPres), HQPres.Get3DMovie())).InitArmory(UnitRef,,,,,, bInstant);


	OfficerScreen = UIArmory_LWOfficerPromotion(HQPres.ScreenStack.Push(HQPres.Spawn(class'UIArmory_LWOfficerPromotion', HQPres), HQPres.Get3DMovie()));
	OfficerScreen.InitPromotion(UnitRef, bInstant);
}

function string GetDisplayName()
{
	return "";
}

// Creates a command bonus range ability for the given rank. This is just a convenience
// for creating the ability and its ability type using the appropriate ability name for
// the rank.
function ClassAgnosticAbility CreateCommandBonusRangeAbility(int Rank)
{
	local SoldierClassAbilityType AbilityType;
	local ClassAgnosticAbility NewAbility;

	AbilityType.AbilityName = class'LWOfficerUtilities'.static.GetCommandRangeAbilityName(Rank);
	AbilityType.ApplyToWeaponSlot = eInvSlot_Unknown;
	AbilityType.UtilityCat = '';
	NewAbility.AbilityType = AbilityType;
	NewAbility.iRank = Rank;
	NewAbility.bUnlocked = true;

	return NewAbility;
}

//---------------------------------------------------------------------------------------
DefaultProperties
{
}
