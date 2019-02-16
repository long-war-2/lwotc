// Notes on CreateStateObject, AddStateObject and ModifyStateObject
// The first two shouldn't be used anymore, but are still fully functional
// ModifyStateObject reduces the number of bugs that can be written
// however, for the sake of keeping this a version for both, I'm not going to change it for WotC
class robojumper_UISquadSelect extends UISquadSelect;

// scroll is amount of slots
var float fScroll; // fInterpCurr
var float fInterpCurrTime; // [0, INTERP_TIME]
var float fInterpStart, fInterpGoal;
var float INTERP_TIME;


struct SquadSelectInterpKeyframe
{
	var vector Location;
	var rotator Rotation;
};

var array<SquadSelectInterpKeyframe> Keyframes;

struct GremlinStruct
{
	var XComUnitPawn GremlinPawn;
	var vector LocOffset;
};

var array<GremlinStruct> GremlinPawns;
var Matrix TransformMatrix;
///////////////////////////////////////////
var bool bUpperView;
var string UIDisplayCam_Overview;
///////////////////////////////////////////
var SimpleShapeManager m_ShapeMgr;
///////////////////////////////////////////    
var UIPanel CurrentlyNavigatingPanel;                               
var robojumper_UIList_SquadEditor SquadList;
var robojumper_UIMouseGuard_SquadSelect MouseGuard;
var int iDefSlotY;
///////////////////////////////////////////
var bool bInfiniteScrollingDisallowed;
///////////////////////////////////////////
var localized string strSwitchPerspective;
var localized string strSwitchPerspectiveTooltip;
var localized string strCycleLists;

var localized string strUnequipSquad, strUnequipBarracks; // nav help
var localized string strUnequipSquadTooltip, strUnequipBarracksTooltip; // nav help tooltip
var localized string strUnequipSquadConfirm, strUnequipBarracksConfirm; // dialogue box title
var localized string strUnequipSquadWarning, strUnequipBarracksWarning; // dialogue box text
///////////////////////////////////////////
var bool bSkipFinalMissionCutscenes;
///////////////////////////////////////////
var bool bSkipDirty;
var bool bInstantLineupUI;

/*
// Example code, will take out later
var UIList TestList1;
var UIList TestList2;
var UIButton TestButton3;
*/

// Constructor
simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	local XComGameState NewGameState;
	local GeneratedMissionData MissionData;
	local XComGameState_MissionSite MissionState;
	local int listX, maxListWidth;
	local X2SitRepTemplate SitRepTemplate;
	local XComNarrativeMoment SitRepNarrative;

	super(UIScreen).InitScreen(InitController, InitMovie, InitName);

	bInfiniteScrollingDisallowed = class'robojumper_SquadSelectConfig'.static.DisAllowInfiniteScrolling();

	m_kMissionInfo = Spawn(class'UISquadSelectMissionInfo', self).InitMissionInfo();
	m_kPawnMgr = Spawn(class'UIPawnMgr', Owner);
	m_ShapeMgr = Spawn(class'SimpleShapeManager');

	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
	MissionData = XComHQ.GetGeneratedMissionData(XComHQ.MissionRef.ObjectID);
	MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(XComHQ.MissionRef.ObjectID));

	SoldierSlotCount = class'X2StrategyGameRulesetDataStructures'.static.GetMaxSoldiersAllowedOnMission(MissionState);
	MaxDisplayedSlots = SoldierSlotCount;
	SquadCount = MissionData.Mission.SquadCount;
	SquadMinimums = MissionData.Mission.SquadSizeMin;

	if (SquadCount == 0)
	{
		SquadCount = 1;
	}

	while (SquadMinimums.Length < SquadCount) // fill in minimums that don't exist with minimum's of 1
	{
		SquadMinimums.AddItem( 1 );
	}

	// Check for a SITREP template, used for possible narrative line
	if (MissionData.SitReps.Length > 0)
	{
		SitRepTemplate = class'X2SitRepTemplateManager'.static.GetSitRepTemplateManager().FindSitRepTemplate(MissionData.SitReps[0]);
		
		if (SitRepTemplate.DataName == 'TheHorde')
		{
			// Do not trigger a skulljack event on these missions, since no ADVENT will spawn
			bBlockSkulljackEvent = true;
		}
	}

	// Enter Squad Select Event
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Enter Squad Select Event Hook");
	`XEVENTMGR.TriggerEvent('EnterSquadSelect', , , NewGameState);
	if (IsRecoveryBoostAvailable())
	{
		`XEVENTMGR.TriggerEvent('OnRecoveryBoostSquadSelect', , , NewGameState);
	}

	if (MissionData.Mission.MissionName == 'LostAndAbandonedA')
	{
		`XEVENTMGR.TriggerEvent('OnLostAndAbandonedSquadSelect', , , NewGameState);
	}
	else if (MissionData.Mission.MissionName == 'ChosenAvengerDefense')
	{
		`XEVENTMGR.TriggerEvent('OnAvengerAssaultSquadSelect', , , NewGameState);
	}
	else if (SitRepTemplate != none && SitRepTemplate.SquadSelectNarrative != "" && !MissionState.bHasPlayedSITREPNarrative)
	{
		SitRepNarrative = XComNarrativeMoment(`CONTENT.RequestGameArchetype(SitRepTemplate.SquadSelectNarrative));
		if (SitRepNarrative != None)
		{
			`HQPRES.UINarrative(SitRepNarrative);
		}

		MissionState = XComGameState_MissionSite(NewGameState.ModifyStateObject(class'XComGameState_MissionSite', MissionState.ObjectID));
		MissionState.bHasPlayedSITREPNarrative = true;
	}
	else if (AllowSquadSizeNarratives())
	{
		if (SoldierSlotCount <= 3)
		{
			`XEVENTMGR.TriggerEvent('OnSizeLimitedSquadSelect', , , NewGameState);
		}
		else if (SoldierSlotCount > 5 && SquadCount > 1)
		{
			`XEVENTMGR.TriggerEvent('OnSuperSizeSquadSelect', , , NewGameState);
		}
	}
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState); 
	
	// MAGICK!
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Squad size adjustment from mission parameters");
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	if (XComHQ.Squad.Length != SoldierSlotCount || XComHQ.AllSquads.Length > 0)
	{
		NewGameState.AddStateObject(XComHQ);
		if (XComHQ.Squad.Length > SoldierSlotCount && AllowCollapseSquad())
		{
			CollapseSquad(XComHQ);
		}
		XComHQ.Squad.Length = SoldierSlotCount;
		XComHQ.AllSquads.Length = 0;
	}
	// do it like LW2 because why not?
	`XEVENTMGR.TriggerEvent('OnUpdateSquadSelectSoldiers', XComHQ, XComHQ, NewGameState); // hook to allow mods to adjust who is in the squad
	if (NewGameState.GetNumGameStateObjects() > 0)
	{
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
	else
	{
		`XCOMHISTORY.CleanupPendingGameState(NewGameState);
	}
	
	maxListWidth = 6 * (class'robojumper_UISquadSelect_ListItem'.default.width + LIST_ITEM_PADDING) - LIST_ITEM_PADDING;
	// TODO: How does this interact with wide-screen?
	// HAX: always spawn it on the left, move it afterwards
	listX = (Movie.UI_RES_X / 2) - (maxListWidth / 2);
	SquadList = Spawn(class'robojumper_UIList_SquadEditor', self).InitSquadList('', listX, iDefSlotY, SoldierSlotCount, 6, class'robojumper_UISquadSelect_ListItem', LIST_ITEM_PADDING);
	SquadList.Tag = 'rjSquadSelect_Navigable';
	SquadList.GetScrollDelegate = GetScroll;
	SquadList.ScrollCallback = OnStickMouseScrollCB;
	SquadList.GetScrollGoalDelegate = GetScrollGoal;

	if (SoldierSlotCount < 6)
	{
		fScroll = -((6.0 - SoldierSlotCount) / 2.0);
		fInterpGoal = fScroll;
	}

	CurrentlyNavigatingPanel = SquadList;
	Navigator.SetSelected(SquadList);
	
	MouseGuard = robojumper_UIMouseGuard_SquadSelect(`SCREENSTACK.GetFirstInstanceOf(class'robojumper_UIMouseGuard_SquadSelect'));
	// for reasons I can't explain, 1.0 / 282 is ten times too fast
	MouseGuard.mouseMoveScalar = 0.3 / class'robojumper_UISquadSelect_ListItem'.default.width;
	MouseGuard.StickRotationMultiplier = 0.01;
	MouseGuard.ValueChangeCallback = OnStickMouseScrollCB;
	MouseGuard.StartUpdate();


	`XSTRATEGYSOUNDMGR.PlaySquadSelectMusic();

	bDisableEdit = class'XComGameState_HeadquartersXCom'.static.GetObjectiveStatus('T0_M3_WelcomeToHQ') == eObjectiveState_InProgress;
	bDisableDismiss = bDisableEdit; // disable both buttons for now
	bDisableLoadout = false;

	//Make sure the kismet variables are up to date
	WorldInfo.MyKismetVariableMgr.RebuildVariableMap();

	BuildWorldCoordinates();

	CreateOrUpdateLaunchButton();

	InitialSquadSetup();
	UpdateData();
	UpdateNavHelp();
	UpdateMissionInfo();
	UpdateSitRep();

	GetIntroAllowed();


/*
	// Example code, will take out later:
	// First things first, you need to mark it with a Tag of
	// 'rjSquadSelect_Navigable' but don't make it actually navigable
	// Second, you need to prepare it so that it's ready to navigate as
	// soon as it gets focus, but doesn't focus anything before that.
	// This is here achieved by manually setting the SelectedIndex
	// and making it not select any item automatically (bSelectFirstAvailable)
	TestList1 = Spawn(class'UIList', self);
	TestList1.Tag = 'rjSquadSelect_Navigable';
	TestList1.bIsNavigable = false;
	TestList1.bSelectFirstAvailable = false;
	TestList1.bStickyHighlight = false;
	TestList1.InitList('', 20, 10, 200, 400);
	TestList1.SelectedIndex = 0;
	TestList1.Navigator.SelectedIndex = 0;
	UIListItemString(TestList1.CreateItem()).InitListItem("1-1");
	UIListItemString(TestList1.CreateItem()).InitListItem("1-2");
	UIListItemString(TestList1.CreateItem()).InitListItem("1-3");
	UIListItemString(TestList1.CreateItem()).InitListItem("1-4");

	TestList2 = Spawn(class'UIList', self);
	TestList2.Tag = 'rjSquadSelect_Navigable';
	TestList2.bIsNavigable = false;
	TestList2.bSelectFirstAvailable = false;
	TestList2.bStickyHighlight = false;
	TestList2.InitList('', 240, 10, 200, 400);
	TestList2.SelectedIndex = 0;
	TestList2.Navigator.SelectedIndex = 0;
	UIListItemString(TestList2.CreateItem()).InitListItem("2-1");
	UIListItemString(TestList2.CreateItem()).InitListItem("2-2");
	UIListItemString(TestList2.CreateItem()).InitListItem("2-3");

	TestButton3 = Spawn(class'UIButton', self);
	TestButton3.Tag = 'rjSquadSelect_Navigable';
	TestButton3.bIsNavigable = false;
	TestButton3.InitButton('', "Test Button");
	TestButton3.SetPosition(460, 10);
*/

	if (MissionData.Mission.AllowDeployWoundedUnits)
	{
		`HQPRES.UIWoundedSoldiersAllowed();
	}
	// snap first to not mess up the first transition
	`HQPRES.CAMLookAtNamedLocation(UIDisplayCam_Overview, 0);
	SetTimer(0.1f, false, nameof(StartPreMissionCinematic));
	XComHeadquartersController(`HQPRES.Owner).SetInputState('None');
}

simulated function GetIntroAllowed()
{
	local XComLWTuple Tuple;

	Tuple = new class'XComLWTuple';
	Tuple.Id = 'rjSquadSelect_UseIntro';
	Tuple.Data.Add(1);
	Tuple.Data[0].kind = XComLWTVInt;
	Tuple.Data[0].i = class'robojumper_SquadSelectConfig'.static.SkipIntro() ? 1 : 0;

	`XEVENTMGR.TriggerEvent('rjSquadSelect_UseIntro', Tuple, Tuple, none);

	switch (Tuple.Data[0].i)
	{
		case 0:
			// Standard intro, do nothing
			break;
		case 1:
			bInstantLineupUI = true;
			break;
		default:
			`REDSCREEN("EVERYTHING'S GONE BAD! ONLY PASS 0, 1 TO rjSquadSelect_UseIntro!");
			// Fallback to standard
			break;
	}

}

simulated function StartPreMissionCinematic()
{
	super.StartPreMissionCinematic();

	// Skip the intro when desired
	// Note: the timer will only expire after this function returns. For now,
	// bIsFocused mirrors the check in super. Keep this code in sync!
	if (bIsFocused /* <==> !IsTimerActive(nameof(StartPreMissionCinematic))*/)
	{
		if (bInstantLineupUI)
		{
			// Set a very short timer to skip the intro camera matinee
			SetTimer(0.001f, false, nameof(FinishIntroCinematic));
		}
	}
}

simulated function FinishIntroCinematic()
{
	local array<SequenceObject> FoundMatinees;
	local SequenceObject MatineeObject;
	local SeqAct_Interp Matinee;
	local Sequence GameSeq;

	GameSeq = class'WorldInfo'.static.GetWorldInfo().GetGameSequence();
	GameSeq.FindSeqObjectsByClass(class'SeqAct_Interp', true, FoundMatinees);

	foreach FoundMatinees(MatineeObject)
	{	
		if(MatineeObject.ObjComment ~= "Soldier lineup camera")
		{
			Matinee = SeqAct_Interp(MatineeObject);
			SetFireEventsWhenJumpingForwards(Matinee.InterpData);
			if (Matinee.bIsPlaying)
			{
				// False -- do trigger the events!
				Matinee.SetPosition(Matinee.InterpData.InterpLength - 0.01f, false);
			}
		}
	}
}

simulated function SetFireEventsWhenJumpingForwards(InterpData Matinee)
{
	local int i, j;
	for (i = 0; i < Matinee.InterpGroups.Length; i++)
	{
		for (j = 0; j < Matinee.InterpGroups[i].InterpTracks.Length; j++)
		{
			if (InterpTrackEvent(Matinee.InterpGroups[i].InterpTracks[j]) != none)
			{
				InterpTrackEvent(Matinee.InterpGroups[i].InterpTracks[j]).bFireEventsWhenJumpingForwards = true;
			}
		}
	}
}

simulated function bool AllowSquadSizeNarratives()
{
	local XComLWTuple Tuple;

	Tuple = new class'XComLWTuple';
	Tuple.Id = 'rjSquadSelect_AllowSquadSizeNarratives';
	Tuple.Data.Add(1);
	Tuple.Data[0].kind = XComLWTVBool;
	Tuple.Data[0].b = true;

	`XEVENTMGR.TriggerEvent('rjSquadSelect_AllowSquadSizeNarratives', Tuple, Tuple, none);

	return Tuple.Data[0].b;
}

simulated function bool AllowAutoFilling()
{
	local XComLWTuple Tuple;

	Tuple = new class'XComLWTuple';
	Tuple.Id = 'rjSquadSelect_AllowAutoFilling';
	Tuple.Data.Add(1);
	Tuple.Data[0].kind = XComLWTVBool;
	Tuple.Data[0].b = true;

	`XEVENTMGR.TriggerEvent('rjSquadSelect_AllowAutoFilling', Tuple, Tuple, none);

	return Tuple.Data[0].b;
}

simulated function bool AllowCollapseSquad()
{
	local XComLWTuple Tuple;

	Tuple = new class'XComLWTuple';
	Tuple.Id = 'rjSquadSelect_AllowCollapseSquad';
	Tuple.Data.Add(1);
	Tuple.Data[0].kind = XComLWTVBool;
	Tuple.Data[0].b = true;

	`XEVENTMGR.TriggerEvent('rjSquadSelect_AllowCollapseSquad', Tuple, Tuple, none);

	return Tuple.Data[0].b;
}


function CreateOrUpdateLaunchButton()
{
	local string SingleLineLaunch;
	
	// TTP14257 - loc is locked down, so, I'm making the edit. No space in Japanese. -bsteiner 
	if( GetLanguage() == "JPN" )
		SingleLineLaunch = m_strNextSquadLine1 $ m_strNextSquadLine2;
	else 
		SingleLineLaunch = m_strNextSquadLine1 @ m_strNextSquadLine2;

	if(LaunchButton == none)
	{
		LaunchButton = Spawn(class'UILargeButton', self);
		LaunchButton.bAnimateOnInit = false;
	}

	if(XComHQ.AllSquads.Length < (SquadCount - 1))
	{
		if( `ISCONTROLLERACTIVE )
		{
			LaunchButton.InitLargeButton(,class'UIUtilities_Text'.static.InjectImage(
					class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_START, 26, 26, -10) @ SingleLineLaunch,, OnNextSquad);
		}
		else
		{
			LaunchButton.InitLargeButton(, m_strNextSquadLine2, m_strNextSquadLine1, OnNextSquad);
		}

		LaunchButton.SetDisabled(false); //bsg-hlee (05.12.17): The button should not be disabled if set to OnNextSquad function.
	}
	else
	{
		if( `ISCONTROLLERACTIVE )
		{
			LaunchButton.InitLargeButton(,class'UIUtilities_Text'.static.InjectImage(
					class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_START, 26, 26, -13) @ m_strLaunch @ m_strMission,, OnLaunchMission);
		}
		else
		{
			LaunchButton.InitLargeButton(, m_strMission, m_strLaunch, OnLaunchMission);
		}
	}

	LaunchButton.AnchorTopCenter();
	LaunchButton.DisableNavigation();
	LaunchButton.ShowBG(true);

	UpdateNavHelp();
}

// bsg-jrebar (5/16/17): Select First item and lose/gain focus on first list item
simulated function SelectFirstListItem()
{
	// Override, our navigation system is smarter than this
}
// bsg-jrebar (5/16/17): end

simulated function bool AllowScroll()
{
	return SoldierSlotCount > 6;
}

simulated function AddHiddenSoldiersToSquad(int NumSoldiersToAdd)
{
	// commented out -- we don't have any hidden soldiers. We always show all the slots
}

simulated function InitialSquadSetup()
{
	local XComGameStateHistory History;
	local int i;
	local XComGameState_Unit UnitState;
	local XComGameState_MissionSite MissionState;
	local GeneratedMissionData MissionData;
	local bool bAllowWoundedSoldiers;

	History = `XCOMHISTORY;

	// get existing states
	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();

	MissionData = XComHQ.GetGeneratedMissionData(XComHQ.MissionRef.ObjectID);
	bAllowWoundedSoldiers = MissionData.Mission.AllowDeployWoundedUnits;

	MissionState = XComGameState_MissionSite(History.GetGameStateForObjectID(XComHQ.MissionRef.ObjectID));
	bHasRankLimits = MissionState.HasRankLimits(MinRank, MaxRank);

	// create change states
	UpdateState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Fill Squad");
	XComHQ = XComGameState_HeadquartersXCom(UpdateState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	UpdateState.AddStateObject(XComHQ);
	// Remove tired soldiers from the squad, and remove soldiers that don't fit the rank limits (if they exist)
	for(i = 0; i < XComHQ.Squad.Length; i++)
	{
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(XComHQ.Squad[i].ObjectID));

		if(UnitState != none && (UnitState.GetMentalState() != eMentalState_Ready || 
			(bHasRankLimits && (UnitState.GetRank() < MinRank || UnitState.GetRank() > MaxRank))))
		{
			XComHQ.Squad[i].ObjectID = 0;
		}
	}

	if (class'robojumper_SquadSelectConfig'.static.ShouldAutoFillSquad() && AllowAutoFilling())
	{
		for(i = 0; i < SoldierSlotCount; i++)
		{
			if(XComHQ.Squad.Length == i || XComHQ.Squad[i].ObjectID == 0)
			{
				if(bHasRankLimits)
				{
					UnitState = XComHQ.GetBestDeployableSoldier(true, bAllowWoundedSoldiers, MinRank, MaxRank);
				}
				else
				{
					UnitState = XComHQ.GetBestDeployableSoldier(true, bAllowWoundedSoldiers);
				}

				if(UnitState != none)
					XComHQ.Squad[i] = UnitState.GetReference();
			}
		}
	}
	StoreGameStateChanges();

	TriggerEventsForWillStates();

	if (!bBlockSkulljackEvent)
	{
		SkulljackEvent();
	}
}

simulated function UpdateData(optional bool bFillSquad)
{
	local XComGameStateHistory History;
	local int i;
	local int SlotIndex;	//Index into the list of places where a soldier can stand in the after action scene, from left to right
	local int SquadIndex;	//Index into the HQ's squad array, containing references to unit state objects
	local int ListItemIndex;//Index into the array of list items the player can interact with to view soldier status and promote


	local robojumper_UISquadSelect_ListItem ListItem;
	local XComGameState_Unit UnitState;
	local XComGameState_MissionSite MissionState;
	local GeneratedMissionData MissionData;
	local bool bSpecialSoldierFound, bAllowWoundedSoldiers;
	local array<name> RequiredSpecialSoldiers;
	local int iMaxExtraHeight;

	History = `XCOMHISTORY;

	if (bFillSquad == true)
	{
		`REDSCREEN(default.Class $ ":" $ GetFuncName() $ " -- bFillSquad is deprecated, call SetupInitialSquad instead");
	}

	ClearPawns();

	// get existing states
	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();

	MissionData = XComHQ.GetGeneratedMissionData(XComHQ.MissionRef.ObjectID);
	bAllowWoundedSoldiers = MissionData.Mission.AllowDeployWoundedUnits;
	RequiredSpecialSoldiers = MissionData.Mission.SpecialSoldiers;

	MissionState = XComGameState_MissionSite(History.GetGameStateForObjectID(XComHQ.MissionRef.ObjectID));
	bHasRankLimits = MissionState.HasRankLimits(MinRank, MaxRank);
	// add a unit to the squad if there is one pending
	if (PendingSoldier.ObjectID > 0 && m_iSelectedSlot != -1)
		XComHQ.Squad[m_iSelectedSlot] = PendingSoldier;

	// if this mission requires special soldiers, check to see if they already exist in the squad
	if (RequiredSpecialSoldiers.Length > 0)
	{
		for (i = 0; i < RequiredSpecialSoldiers.Length; i++)
		{
			bSpecialSoldierFound = false;
			for (SquadIndex = 0; SquadIndex < XComHQ.Squad.Length; SquadIndex++)
			{
				UnitState = XComGameState_Unit(History.GetGameStateForObjectID(XComHQ.Squad[SquadIndex].ObjectID));
				if (UnitState != none && UnitState.GetMyTemplateName() == RequiredSpecialSoldiers[i])
				{
					bSpecialSoldierFound = true;
					break;
				}
			}

			if (!bSpecialSoldierFound)
				break; // If a special soldier is missing, break immediately and reset the squad
		}

		// If no special soldiers are found, clear the squad, search for them, and add them
		if (!bSpecialSoldierFound)
		{
			UpdateState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Add special soldier to squad");
			XComHQ = XComGameState_HeadquartersXCom(UpdateState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
			UpdateState.AddStateObject(XComHQ);
			XComHQ.Squad.Length = 0;

			foreach History.IterateByClassType(class'XComGameState_Unit', UnitState)
			{
				// If this unit is one of the required special soldiers, add them to the squad
				if (RequiredSpecialSoldiers.Find(UnitState.GetMyTemplateName()) != INDEX_NONE)
				{
					UnitState = XComGameState_Unit(UpdateState.CreateStateObject(class'XComGameState_Unit', UnitState.ObjectID));
					
					// safety catch: somehow Central has no appearance in the alien nest mission. Not sure why, no time to figure it out - dburchanowski
					if(UnitState.GetMyTemplate().bHasFullDefaultAppearance && UnitState.kAppearance.nmTorso == '')
					{
						`Redscreen("Special Soldier " $ UnitState.ObjectID $ " with template " $ UnitState.GetMyTemplateName() $ " has no appearance, restoring default!");
						UnitState.kAppearance = UnitState.GetMyTemplate().DefaultAppearance;
					}

					UpdateState.AddStateObject(UnitState);
					UnitState.ApplyBestGearLoadout(UpdateState); // Upgrade the special soldier to have the best possible gear
					
					if (XComHQ.Squad.Length < SoldierSlotCount) // Only add special soldiers up to the squad limit
					{
						XComHQ.Squad.AddItem(UnitState.GetReference());
					}
				}
			}

			StoreGameStateChanges();
		}
	}

	// This method iterates all soldier templates and empties their backpacks if they are not already empty
	BlastBackpacks();

	// Everyone have their Xpad?
	ValidateRequiredLoadouts();

	// Clear Utility Items from wounded soldiers inventory
	if (!bAllowWoundedSoldiers)
	{
		MakeWoundedSoldierItemsAvailable();
	}

	`XEVENTMGR.TriggerEvent('rjSquadSelect_UpdateData', none, none, none);

	// create change states
	CreatePendingStates();

	ListItemIndex = 0;
	iMaxExtraHeight = 0; 		                                                                                
	UnitPawns.Length = Max(SoldierSlotCount, UnitPawns.Length);
	for (SlotIndex = 0; SlotIndex < SoldierSlotCount; ++SlotIndex)
	{
		SquadIndex = SlotIndex;
		// We want the slots to match the visual order of the pawns in the slot list.
		ListItem = robojumper_UISquadSelect_ListItem(SquadList.GetItem(ListItemIndex));
		if (bDirty || (SquadIndex < XComHQ.Squad.length && XComHQ.Squad[SquadIndex].ObjectID > 0 && ListItem.bDirty))
		{

			if (UnitPawns[SquadIndex] != none)
			{
				// TODO: Can we reach this if XComHQ.Squad[SquadIndex].ObjectID == 0?
				//m_kPawnMgr.ReleaseCinematicPawn(self, UnitPawns[SquadIndex].ObjectID);
				m_kPawnMgr.ReleaseCinematicPawn(self, XComHQ.Squad[SquadIndex].ObjectID);
			}

			UnitPawns[SquadIndex] = CreatePawn(XComHQ.Squad[SquadIndex], SquadIndex);
		}

		if(bDirty || ListItem.bDirty)
		{
			if (SquadIndex < XComHQ.Squad.Length)
				UnitState = XComGameState_Unit(History.GetGameStateForObjectID(XComHQ.Squad[SquadIndex].ObjectID));
			else
				UnitState = none;

			if (RequiredSpecialSoldiers.Length > 0 && UnitState != none && RequiredSpecialSoldiers.Find(UnitState.GetMyTemplateName()) != INDEX_NONE)
				ListItem.UpdateData(SquadIndex, true, true, false, UnitState.GetSoldierClassTemplate().CannotEditSlots); // Disable customization or removing any special soldier required for the mission
			else
				ListItem.UpdateData(SquadIndex, bDisableEdit, bDisableDismiss, bDisableLoadout);
		}
		iMaxExtraHeight = Max(iMaxExtraHeight, ListItem.GetExtraHeight());
		++ListItemIndex;
	}
	UnitPawns.Length = SoldierSlotCount;
	SquadList.SetY(iDefSlotY - iMaxExtraHeight);
	StoreGameStateChanges();
	bDirty = false;

	if (MissionState.GetMissionSource().RequireLaunchMissionPopupFn != none && MissionState.GetMissionSource().RequireLaunchMissionPopupFn(MissionState))
	{
		// If the mission source requires a unique launch mission warning popup which has not yet been displayed, show it now
		if (!MissionState.bHasSeenLaunchMissionWarning)
		{
			`HQPRES.UILaunchMissionWarning(MissionState);
		}
	}
}


// Overrides super: Cut some weird code.
simulated function ChangeSlot(optional StateObjectReference UnitRef)
{
	local StateObjectReference PrevUnitRef;
	local XComGameState_MissionSite MissionState;

	// Make sure we create the update state before changing XComHQ
	if(UpdateState == none)
		CreatePendingStates();

	PrevUnitRef = XComHQ.Squad[m_iSelectedSlot];

	// remove modifications to previous selected unit
	if(PrevUnitRef.ObjectID > 0)
	{
		m_kPawnMgr.ReleaseCinematicPawn(self, PrevUnitRef.ObjectID);
	}

	PendingSoldier = UnitRef;
	
	XComHQ.Squad[m_iSelectedSlot] = UnitRef;

	StoreGameStateChanges();

	MissionState = GetMissionState();
	if (MissionState.GetMissionSource().RequireLaunchMissionPopupFn != none && MissionState.GetMissionSource().RequireLaunchMissionPopupFn(MissionState))
	{
		// If the mission source requires a unique launch mission warning popup which has not yet been displayed, show it now
		if (!MissionState.bHasSeenLaunchMissionWarning)
		{
			`HQPRES.UILaunchMissionWarning(MissionState);
		}
	}

	bDirty = true;
	UpdateData();

	Movie.Pres.PlayUISound(eSUISound_MenuSelect); //bsg-crobinson (5.18.17): Add sound on select soldier
}




simulated function int GetTotalSlots()
{
	return SoldierSlotCount;
}


simulated function UpdateNavHelp()
{
	local UINavigationHelp NavHelp;
	local XComHeadquartersCheatManager CheatMgr;
	local string BoostTooltip;

	LaunchButton.SetDisabled(!CanLaunchMission());
	LaunchButton.SetTooltipText(GetTooltipText());
	Movie.Pres.m_kTooltipMgr.TextTooltip.SetUsePartialPath(LaunchButton.CachedTooltipId, true);

	if (`HQPRES != none)
	{
		NavHelp = `HQPRES.m_kAvengerHUD.NavHelp;
		CheatMgr = XComHeadquartersCheatManager(GetALocalPlayerController().CheatManager);
		NavHelp.ClearButtonHelp();

		// moved down (up in code) because it's a long string and shouldn't conflict with the list
		if (`ISCONTROLLERACTIVE)
		{
			NavHelp.AddLeftStackHelp(class'UIPauseMenu'.default.m_sControllerMap, class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_RSCLICK_R3);
			if (HasMultipleNavigables())
			{
				NavHelp.AddLeftStackHelp(default.strCycleLists, class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_BACK_SELECT);
			}
		}

		if (!bNoCancel || (XComHQ.AllSquads.Length > 0 && XComHQ.AllSquads.Length < (SquadCount)))
		{
			if (!NavHelp.bBackButton)
			{
				NavHelp.bBackButton = true;
				if (`ISCONTROLLERACTIVE)
				{
					NavHelp.AddLeftStackHelp(NavHelp.m_strBackButtonLabel, class'UIUtilities_Input'.static.GetBackButtonIcon(), CloseScreen);
				}
				else
				{
					NavHelp.SetButtonType("XComButtonIconPC");
					NavHelp.AddLeftStackHelp("4", "4", CloseScreen);
					NavHelp.SetButtonType("");
				}
			}
		}

		if (`ISCONTROLLERACTIVE)
		{
			NavHelp.AddLeftStackHelp(class'UIUtilities_Text'.default.m_strGenericSelect, class'UIUtilities_Input'.static.GetAdvanceButtonIcon());
			NavHelp.AddLeftStackHelp(class'UISquadSelect_ListItem'.default.m_strEdit, class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_X_SQUARE);
			NavHelp.AddLeftStackHelp(class'UISquadSelect_ListItem'.default.m_strDismiss, class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_Y_TRIANGLE);
		}

		if (CheatMgr == none || !CheatMgr.bGamesComDemo)
		{
			if (!`ISCONTROLLERACTIVE)
			{
				NavHelp.AddCenterHelp(class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(strUnequipSquad), class'UIUtilities_Input'.static.GetGamepadIconPrefix() $class'UIUtilities_Input'.const.ICON_LT_L2,
					OnUnequipSquad, false, strUnequipSquadTooltip);
				NavHelp.AddCenterHelp(class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(strUnequipBarracks), class'UIUtilities_Input'.static.GetGamepadIconPrefix() $class'UIUtilities_Input'.const.ICON_RT_R2,
					OnUnequipBarracks, false, strUnequipBarracksTooltip);
			}
			else
			{
				NavHelp.AddCenterHelp(class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(class'UIManageEquipmentMenu'.default.m_strTitleLabel), class'UIUtilities_Input'.const.ICON_LT_L2);
			}
		}

		if (class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('T0_M5_WelcomeToEngineering'))
		{
			NavHelp.AddCenterHelp(m_strBuildItems, class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_LB_L1, 
				OnBuildItems, false, m_strTooltipBuildItems);
		}

		// Add the button for the Recovery Booster if it is available	
		if(ShowRecoveryBoostButton())
		{
			// bsg-jrebar (5/3/17): Adding a button for the controls
			if (IsRecoveryBoostAvailable(BoostTooltip) || `ISCONTROLLERACTIVE)
				`HQPRES.m_kAvengerHUD.NavHelp.AddCenterHelp(m_strBoostSoldier, class'UIUtilities_Input'.const.ICON_RT_R2, OnBoostSoldier, false, BoostTooltip);
			else
				`HQPRES.m_kAvengerHUD.NavHelp.AddCenterHelp(m_strBoostSoldier, "", , true, BoostTooltip);
		}

		if (AllowScroll())
		{
			// todo
			NavHelp.AddCenterHelp(class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(strSwitchPerspective), class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_RB_R1, 
				SwitchPerspective, false, strSwitchPerspectiveTooltip);
		}
/*
		// Re-enabling this option for Steam builds to assist QA testing, TODO: disable this option before release
`if(`notdefined(FINAL_RELEASE))
		if (CheatMgr == none || !CheatMgr.bGamesComDemo)
		{
			NavHelp.AddCenterHelp("SIM COMBAT", class'UIUtilities_Input'.static.GetGamepadIconPrefix() $class'UIUtilities_Input'.const.ICON_BACK_SELECT,
				OnSimCombat, !CanLaunchMission(), GetTooltipText());
		}	
`endif
*/
		
		`XEVENTMGR.TriggerEvent('UISquadSelect_NavHelpUpdate', NavHelp, self, none);
	}
}

simulated function bool HasMultipleNavigables()
{
	local int i, count;
	count = 0;

	for (i = 0; i < ChildPanels.Length; i++)
	{
		if (InStr(ChildPanels[i].Tag, 'rjSquadSelect_Navigable', , true) != INDEX_NONE)
		{
			count += 1;
		}
	}
	return count > 1;
}

simulated function OnNextSquad(UIButton Button)
{
	if(CurrentSquadHasEnoughSoldiers())
		bDirty = true;
	super.OnNextSquad(Button);
}

simulated function CloseScreen()
{
	if (!bLaunched && XComHQ.AllSquads.Length > 0)
	{
		bDirty = true;
	}
//	super.CloseScreen();
	CloseScreenInternal();
}

// Copied from UISquadSelect:CloseScreen
simulated function CloseScreenInternal()
{
	local XComGameState_MissionSite MissionState;
	local XComLWTuple Tuple;

	MissionState = GetMissionState();
	
	if (bLaunched)
	{
		Tuple = new class'XComLWTuple';
		Tuple.Id = 'rjSquadSelect_UseCinematic';
		Tuple.Data.Add(1);
		Tuple.Data[0].kind = XComLWTVInt;
		Tuple.Data[0].i = MissionState.GetMissionSource().bRequiresSkyrangerTravel ? 0 : 1;

		`XEVENTMGR.TriggerEvent('rjSquadSelect_UseCinematic', Tuple, Tuple, none);

		switch (Tuple.Data[0].i)
		{
			case 0:
				// Standard departure, take-off
				`XCOMGRI.DoRemoteEvent('PreM_GoToDeparture');
				break;
			case 1:
				// Fade-out
				`XCOMGRI.DoRemoteEvent('PreM_GoToAvengerDefense');
				break;
			case 2:
				// Just cut away
				`XCOMGRI.DoRemoteEvent('PreM_Cancel');
				break;
			default:
				`REDSCREEN("EVERYTHING'S GONE BAD! ONLY PASS 0, 1, 2 TO rjSquadSelect_UseCinematic!");
				// Fallback to standard
				`XCOMGRI.DoRemoteEvent('PreM_GoToDeparture');
				break;
		}

		// We've been working on XComHQ.Squad directly, now move it to the XComHQ.AllSquads list.
		FinalizeReserveSquads();

		// Re-equip any gear which was stripped from soldiers not in the squad
		EquipStrippedSoldierGear();

		// Strategy map has its own button help
		`HQPRES.m_kAvengerHUD.NavHelp.ClearButtonHelp();
		Hide();

		if( `CHEATMGR.bShouldAutosaveBeforeEveryAction )
		{
			`AUTOSAVEMGR.DoAutosave(, true, true);
		}
	}
	else if (XComHQ.AllSquads.Length > 0)
	{
		// don't close the screen, just back out the most recent reserve squad
		if(UpdateState == none)
		{
			CreatePendingStates();
		}

		XComHQ.Squad = XComHQ.AllSquads[XComHQ.AllSquads.Length - 1].SquadMembers;
		XComHQ.AllSquads.Length = XComHQ.AllSquads.Length - 1;

		StoreGameStateChanges();

		UpdateData();
		CreateOrUpdateLaunchButton();
	}
	else
	{
		`XCOMGRI.DoRemoteEvent('PreM_Cancel');

		MissionState.ClearSpecialSoldiers();
		
		// Re-equip any gear which was stripped from soldiers not in the squad
		EquipStrippedSoldierGear();

		// Strategy map has its own button help
		`HQPRES.m_kAvengerHUD.NavHelp.ClearButtonHelp();
		Hide();
	}
}

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	local bool bHandled;

	if (!bIsVisible || !bReceivedWalkupEvent)
	{
		return true;
	}
	
	if (bLaunched)
	{
		return false;
	}

	if (IsTimerActive(nameof(GoToBuildItemScreen)))
	{
		return false;
	}

	if ( CurrentlyNavigatingPanel.OnUnrealCommand(cmd, arg) )
		return true;
		
	// Only pay attention to presses or repeats; ignoring other input types
	// NOTE: Ensure repeats only occur with arrow keys
	if ( !CheckInputIsReleaseOrDirectionRepeat(cmd, arg) )
		return false;

	bHandled = true;
	switch( cmd )
	{

		case class'UIUtilities_Input'.static.GetBackButtonInputCode():
		case class'UIUtilities_Input'.const.FXS_KEY_ESCAPE:
		case class'UIUtilities_Input'.const.FXS_R_MOUSE_DOWN:
			if(!bNoCancel || XComHQ.AllSquads.Length > 0)
			{
				CloseScreen();
				Movie.Pres.PlayUISound(eSUISound_MenuClose);
			}
			break;
		case class'UIUtilities_Input'.const.FXS_BUTTON_LTRIGGER:
			OnManageEquipmentPressed();
			break;
		case class'UIUtilities_Input'.const.FXS_BUTTON_RTRIGGER:
			OnBoostSoldier();
			break;
		case class'UIUtilities_Input'.const.FXS_BUTTON_LBUMPER:
			if (class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('T0_M5_WelcomeToEngineering'))
			{
				OnBuildItems();
			}
			break;

		case class'UIUtilities_Input'.const.FXS_BUTTON_RBUMPER:
			if (AllowScroll())
			{
				SwitchPerspective();
			}
			break;

		case class'UIUtilities_Input'.const.FXS_BUTTON_SELECT:
			OnCycleExtraPanels();
			break;
		case class'UIUtilities_Input'.const.FXS_BUTTON_R3:
			if (`ISCONTROLLERACTIVE)
			{
				`SCREENSTACK.Push(Spawn(class'robojumper_SquadSelectControllerMap', Movie.Pres));
				break;
			}

		case class'UIUtilities_Input'.const.FXS_BUTTON_START:
			if(XComHQ.AllSquads.Length < (SquadCount - 1))
			{
				OnNextSquad(LaunchButton);
			}
			else
			{
				OnLaunchMission(LaunchButton);
			}
			break;
		default:
			bHandled = false;
			break;
	}

	return bHandled || super(UIScreen).OnUnrealCommand(cmd, arg);
}

simulated function OnCycleExtraPanels()
{
	local int i;
	local UIPanel PrevPanel;

	PrevPanel = CurrentlyNavigatingPanel;

	for (i = (GetChildIndex(PrevPanel) + 1) % ChildPanels.Length;
			/*ChildPanels[i] != PrevPanel &&*/ InStr(ChildPanels[i].Tag, 'rjSquadSelect_Navigable', , true) == INDEX_NONE;
			i = (i + 1) % ChildPanels.Length)
	{
	}

	// Cycle panels
	if (ChildPanels[i] != PrevPanel)
	{
		PrevPanel.DisableNavigation();
		PrevPanel.OnLoseFocus();
		CurrentlyNavigatingPanel = ChildPanels[i];
		CurrentlyNavigatingPanel.EnableNavigation();
		Navigator.SetSelected(CurrentlyNavigatingPanel);
	}
}

simulated function OnUnequipSquad()
{
	local TDialogueBoxData DialogData;
	DialogData.eType = eDialog_Normal;
	DialogData.strTitle = class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(strUnequipSquadConfirm);
	DialogData.strText = strUnequipSquadWarning;
	DialogData.fnCallback = OnUnequipSquadDialogueCallback;
	DialogData.strAccept = class'UIDialogueBox'.default.m_strDefaultAcceptLabel;
	DialogData.strCancel = class'UIDialogueBox'.default.m_strDefaultCancelLabel;
	Movie.Pres.UIRaiseDialog(DialogData);
}
simulated function OnUnequipSquadDialogueCallback(name eAction)
{
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;
	local array<EInventorySlot> RelevantSlots;
	local array<EInventorySlot> SlotsToClear;
	local array<EInventorySlot> LockedSlots;
	local EInventorySlot LockedSlot;
	local array<XComGameState_Unit> Soldiers;
	local int idx;

	if(eAction == 'eUIAction_Accept')
	{
		History = `XCOMHISTORY;
		UpdateState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Unequip Squad");
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class' XComGameState_HeadquartersXCom'));
		XComHQ = XComGameState_HeadquartersXCom(UpdateState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
		UpdateState.AddStateObject(XComHQ);
		Soldiers = XComHQ.GetSoldiers(false	, true);

		RelevantSlots = GetRelevantSlots();

		for(idx = 0; idx < Soldiers.Length; idx++)
		{
			if (XComHQ.IsUnitInSquad(Soldiers[idx].GetReference()))
			{
				UnitState = XComGameState_Unit(UpdateState.CreateStateObject(class'XComGameState_Unit', Soldiers[idx].ObjectID));

				SlotsToClear = RelevantSlots;
				LockedSlots = UnitState.GetSoldierClassTemplate().CannotEditSlots;
				foreach LockedSlots(LockedSlot)
				{
					if (SlotsToClear.Find(LockedSlot) != INDEX_NONE)
					{
						SlotsToClear.RemoveItem(LockedSlot);
					}
				}

				UpdateState.AddStateObject(UnitState);
				UnitState.MakeItemsAvailable(UpdateState, false, SlotsToClear);
			}
		}

		`GAMERULES.SubmitGameState(UpdateState);
	}
	bDirty = true;
	UpdateData();
	UpdateNavHelp();
}



simulated function OnUnequipBarracks()
{
	local TDialogueBoxData DialogData;
	DialogData.eType = eDialog_Normal;
	DialogData.strTitle = class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(strUnequipBarracksConfirm);
	DialogData.strText = strUnequipBarracksWarning;
	DialogData.fnCallback = OnUnequipBarracksDialogueCallback;
	DialogData.strAccept = class'UIDialogueBox'.default.m_strDefaultAcceptLabel;
	DialogData.strCancel = class'UIDialogueBox'.default.m_strDefaultCancelLabel;
	Movie.Pres.UIRaiseDialog(DialogData);
}
simulated function OnUnequipBarracksDialogueCallback(name eAction)
{
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;
	local array<EInventorySlot> RelevantSlots;
	local array<EInventorySlot> SlotsToClear;
	local array<EInventorySlot> LockedSlots;
	local EInventorySlot LockedSlot;
	local array<XComGameState_Unit> Soldiers;
	local int idx;

	if(eAction == 'eUIAction_Accept')
	{
		History = `XCOMHISTORY;
		UpdateState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Unequip Barracks");
		XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class' XComGameState_HeadquartersXCom'));
		XComHQ = XComGameState_HeadquartersXCom(UpdateState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
		UpdateState.AddStateObject(XComHQ);
		Soldiers = XComHQ.GetSoldiers(true, true);

		RelevantSlots = GetRelevantSlots();

		for(idx = 0; idx < Soldiers.Length; idx++)
		{
				UnitState = XComGameState_Unit(UpdateState.CreateStateObject(class'XComGameState_Unit', Soldiers[idx].ObjectID));

				SlotsToClear = RelevantSlots;
				LockedSlots = UnitState.GetSoldierClassTemplate().CannotEditSlots;
				foreach LockedSlots(LockedSlot)
				{
					if (SlotsToClear.Find(LockedSlot) != INDEX_NONE)
					{
						SlotsToClear.RemoveItem(LockedSlot);
					}
				}

				UpdateState.AddStateObject(UnitState);
				UnitState.MakeItemsAvailable(UpdateState, false, SlotsToClear);
		}

		`GAMERULES.SubmitGameState(UpdateState);
	}
	UpdateNavHelp();
}

static function array<EInventorySlot> GetRelevantSlots()
{
	local array<EInventorySlot> RelevantSlots;

	if (class'robojumper_SquadSelectConfig'.static.IsCHHLMinVersionInstalled(1, 6))
	{
		class'CHItemSlot'.static.CollectSlots(class'CHItemSlot'.const.SLOT_ALL, RelevantSlots);
	}
	else
	{	
		RelevantSlots.AddItem(eInvSlot_Armor);
		RelevantSlots.AddItem(eInvSlot_PrimaryWeapon);
		RelevantSlots.AddItem(eInvSlot_SecondaryWeapon);
		RelevantSlots.AddItem(eInvSlot_HeavyWeapon);
		RelevantSlots.AddItem(eInvSlot_Utility);
		RelevantSlots.AddItem(eInvSlot_GrenadePocket);
		RelevantSlots.AddItem(eInvSlot_AmmoPocket);
	}

	return RelevantSlots;
}


event OnRemoteEvent(name RemoteEventName)
{
	super(UIScreen).OnRemoteEvent(RemoteEventName);

	// Only show screen if we're at the top of the state stack
	if(RemoteEventName == 'PreM_LineupUI' && (`SCREENSTACK.GetCurrentScreen() == self || `SCREENSTACK.GetCurrentScreen().IsA('UIAlert') || `SCREENSTACK.IsCurrentClass(class'UIRedScreen') || `SCREENSTACK.HasInstanceOf(class'UIProgressDialogue'))) //bsg-jneal (5.10.17): allow remote events to call through even with dialogues up)
	{
		ShowLineupUI();
	}
	else if(RemoteEventName == 'PreM_Exit')
	{
		GoToGeoscape();
	}
	else if(RemoteEventName == 'PreM_StartIdle' || RemoteEventName == 'PreM_SwitchToLineup')
	{
		GotoState('Cinematic_PawnsIdling');
	}
	else if(RemoteEventName == 'PreM_SwitchToSoldier')
	{
		GotoState('Cinematic_PawnsCustomization');
	}
	else if(RemoteEventName == 'PreM_StopIdle_S2')
	{
		GotoState('Cinematic_PawnsWalkingAway');    
	}		
	else if(RemoteEventName == 'PreM_CustomizeUI_Off')
	{
		UpdateData();
	}
}

function GoToGeoscape()
{	
	local StateObjectReference EmptyRef;
	local XComGameState_MissionSite MissionState;

	MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(XComHQ.MissionRef.ObjectID));

	if(bLaunched)
	{
		if(MissionState.GetMissionSource().DataName == 'MissionSource_Final' && !bSkipFinalMissionCutscenes)
		{
			`MAPS.AddStreamingMap("CIN_TP_Dark_Volunteer_pt2_Hallway_Narr", vect(0, 0, 0), Rot(0, 0, 0), true, false, true, OnVolunteerMatineeIsVisible);
			return;
		}
		else if(!MissionState.GetMissionSource().bRequiresSkyrangerTravel) //Some missions, like avenger defense, may not require the sky ranger to go anywhere
		{			
			MissionState.ConfirmMission();
		}
		else
		{
			MissionState.SquadSelectionCompleted();
		}
	}
	else
	{
		XComHQ.MissionRef = EmptyRef;
		MissionState.SquadSelectionCancelled();
		`XSTRATEGYSOUNDMGR.PlayGeoscapeMusic();
	}

	`XCOMGRI.DoRemoteEvent('CIN_UnhideArmoryStaff'); //Show the armory staff now that we are done

	Movie.Stack.Pop(self);
}


function ShowLineupUI()
{
	bReceivedWalkupEvent = true; 
	CheckForWalkupAlerts();

	// last chance
	SquadList.UpdateScroll();
	Show();
	UpdateNavHelp();

	SquadList.bInstantLineupUI = bInstantLineupUI;
	AnimateChildPanels();
}

function AnimateChildPanels()
{
	local int i;

	for (i = 0; i < ChildPanels.Length; i++)
	{
		// Screens own their recursive children. Explicitly check here!
		if (ChildPanels[i].ParentPanel == self)
		{
			ChildPanels[i].AnimateIn(0);
		}
	}
}

simulated function SnapCamera()
{
	MoveCamera(0);
}

simulated function MoveCamera(float fInterpTime)
{
	if (bUpperView)
		`HQPRES.CAMLookAtNamedLocation(UIDisplayCam_Overview, fInterpTime);
	else
		`HQPRES.CAMLookAtNamedLocation(UIDisplayCam, fInterpTime);
}

simulated function SwitchPerspective()
{
	bUpperView = !bUpperView;
	MoveCamera(`HQINTERPTIME / 2);
}

//During the after action report, the characters walk up to the camera - this state represents that time
state Cinematic_PawnsWalkingUp
{
	simulated event BeginState(name PreviousStateName)
	{
		StartPawnAnimation(bInstantLineupUI ? 'CharacterCustomization' : 'SquadLineup_Walkup', bInstantLineupUI ? 'Gremlin_Idle' : 'Gremlin_WalkUp');
	}
}

// our squad may have more soldiers than we can normally display but it may have empty entries
// collapse first
function CollapseSquad(XComGameState_HeadquartersXCom HQ)
{
	local int i;
	for (i = HQ.Squad.Length - 1; i >= 0; i--)
	{
		if (HQ.Squad[i].ObjectID <= 0)	
		{
			HQ.Squad.Remove(i, 1);
		}
	}
}



function vector WorldSpaceForEllipseAngle(float gamma)
{
	local vector EllipseVector, NewVector;

	EllipseVector.X = Cos(gamma);
	EllipseVector.Y = -Sin(gamma); // minus because reasons

	NewVector = TransformVector(TransformMatrix, EllipseVector);
	
	return NewVector;
}
// 1 = one item
simulated function OnStickMouseScrollCB(float fChange)
{
	if (AllowScroll())
	{
		LerpTo(fInterpGoal + fChange);
	}
}

simulated function float GetScroll()
{
	return fScroll;
}
simulated function float GetScrollGoal()
{
	return fInterpGoal;
}

simulated function float easeOutQuad(float t, float b, float c, float d)
{
	return (-c) * ((t/d) * ((t/d) - 2)) + b;
}

// not linear, whatever
simulated function LerpTo(float fGoal)
{
	if (bInfiniteScrollingDisallowed && AllowScroll())
	{
		fGoal = FClamp(fGoal, 0, SoldierSlotCount - 6);
	}
	fInterpStart = fScroll;
	fInterpGoal = fGoal;
	fInterpCurrTime = 0;
}

simulated function Tick(float fDeltaTime)
{
	super.Tick(fDeltaTime);
	if (fScroll ~= fInterpGoal)
		return;

	fInterpCurrTime += fDeltaTime;
	fInterpCurrTime = FClamp(fInterpCurrTime, 0.0, INTERP_TIME);

	fScroll = easeOutQuad(fInterpCurrTime, fInterpStart, fInterpGoal - fInterpStart, INTERP_TIME);

	UpdateScroll();
}

simulated function SquadSelectInterpKeyframe GetPosRotForIndex(int idx)
{
	local int a, b;
	local float f, fakeScroll;
	local SquadSelectInterpKeyframe RetKeyframe;
	fakeScroll = -fScroll;
	while (fakeScroll < 0)
	{
		fakeScroll += float(SoldierSlotCount);
	}

	a = (FFloor(fakeScroll) + idx) % Keyframes.Length;
	b = (FCeil(fakeScroll) + idx) % Keyframes.Length;
	f = fakeScroll - FFloor(fakeScroll);
	//RetKeyframe.Location = Keyframes[a].Location + (f * (Keyframes[b].Location - Keyframes[a].Location));
	//RetKeyframe.Rotation = Keyframes[a].Rotation + (f * (Keyframes[b].Rotation - Keyframes[a].Rotation));
	RetKeyframe.Location = VLerp(Keyframes[a].Location, Keyframes[b].Location, f);
	RetKeyframe.Rotation = RLerp(Keyframes[a].Rotation, Keyframes[b].Rotation, f, true);
	return RetKeyframe;
}

simulated function UpdateScroll()
{
	local int i;
	local vector NewLoc;
	local rotator NewRot;
	local SquadSelectInterpKeyframe Keyfr;
	if (bLaunched) return;

	for (i = 0; i < UnitPawns.Length; i++)
	{
		if (UnitPawns[i] == none) continue;
		Keyfr = GetPosRotForIndex(i);
		NewLoc = Keyfr.Location;
		NewRot = Keyfr.Rotation;

		UnitPawns[i].SetLocation(NewLoc);
		UnitPawns[i].SetRotation(NewRot);

		if (GremlinPawns[i].GremlinPawn != none)
		{
			GremlinPawns[i].GremlinPawn.SetLocation(NewLoc);
			GremlinPawns[i].GremlinPawn.SetRotation(NewRot);
		}
	}
	SquadList.UpdateScroll();
}

// Unused in vanilla, override for consistency though
simulated function int GetSlotIndexForUnit(StateObjectReference UnitRef)
{
	local int SlotIndex;	//Index into the list of places where a soldier can stand in the after action scene, from left to right
	local int SquadIndex;	//Index into the HQ's squad array, containing references to unit state objects

	for(SlotIndex = 0; SlotIndex < SoldierSlotCount; ++SlotIndex)
	{
		SquadIndex = SlotIndex;
		if(SquadIndex < XComHQ.Squad.Length)
		{
			if(XComHQ.Squad[SquadIndex].ObjectID == UnitRef.ObjectID)
				return SlotIndex;
		}
	}

	return -1;
}


simulated function BuildWorldCoordinates()
{
	local int i;
	local Actor Point;
	local SquadSelectInterpKeyframe NewKeyframe, EmptyKeyframe;
	local int ExtraSlots;
	local vector center, sPoint, mPoint;
//	local vector f1;
	
	local float lowerBound, upperBound;

	Keyframes.Length = 0;

	for (i = 0; i < SlotListOrder.Length; i++)
	{
		Point = class'robojumper_SquadSelect_WorldConfiguration'.static.GetTaggedActor(name(m_strPawnLocationIdentifier $ SlotListOrder[i]), class'PointInSpace');
		NewKeyframe = EmptyKeyframe;
		NewKeyframe.Location = Point.Location;
		NewKeyframe.Rotation = Point.Rotation;
		Keyframes.AddItem(NewKeyframe);
//		m_ShapeMgr.DrawSphere(NewKeyframe.Location, Vect(10, 10, 10), MakeLinearColor(1, 0, 0, 1), true);
	}
	ExtraSlots = SoldierSlotCount - 6;
	// don't do all that phish if we don't need it
	if (ExtraSlots <= 0)
	{
//		return;
	}
	// MOM, GET THE CAMERA
	class'robojumper_SquadSelect_WorldConfiguration'.static.GetTaggedActor(name(UIDisplayCam_Overview), class'CameraActor');
	// build the matrix that translates "ellipse space" into world space
	// as well as info about the ellipse
	center = class'robojumper_SquadSelect_WorldConfiguration'.static.GetTaggedActor('EllipseCenter', class'PointInSpace').Location;
//	f1 = class'robojumper_SquadSelect_WorldConfiguration'.static.GetTaggedActor('EllipseF1', class'PointInSpace').Location;
	sPoint = class'robojumper_SquadSelect_WorldConfiguration'.static.GetTaggedActor('EllipseS', class'PointInSpace').Location;
	mPoint = class'robojumper_SquadSelect_WorldConfiguration'.static.GetTaggedActor('EllipseM1', class'PointInSpace').Location;
/*	m_ShapeMgr.DrawSphere(center, Vect(5, 5, 5), MakeLinearColor(0, 0, 1, 1), true);
	m_ShapeMgr.DrawSphere(f1, Vect(5, 5, 5), MakeLinearColor(0, 0, 1, 1), true);
	m_ShapeMgr.DrawSphere(sPoint, Vect(5, 5, 5), MakeLinearColor(0, 0, 1, 1), true);
	m_ShapeMgr.DrawSphere(mPoint, Vect(5, 5, 5), MakeLinearColor(0, 0, 1, 1), true);
*/

	TransformMatrix.XPlane.X = center.X - mPoint.X;
	TransformMatrix.XPlane.Y = center.Y - mPoint.Y;
	TransformMatrix.YPlane.X = center.X - sPoint.X;
	TransformMatrix.YPlane.Y = center.Y - sPoint.Y;
	TransformMatrix.ZPlane.Z = 1;
	TransformMatrix.WPlane.X = center.X;
	TransformMatrix.WPlane.Y = center.Y;
	TransformMatrix.WPlane.Z = center.Z;
	TransformMatrix.WPlane.W = 1;

	// we place keyframes in regular intervals between [0, PI] on the ellipsis
	// if we are less than 6 additional soldiers, fill them up from the middle and don't make them entirely regular
	// if we are 6 or more, space them out
	if (ExtraSlots < 6)
	{
		lowerBound = (Pi / 2) - ((ExtraSlots - 1) * (Pi / 12));
		upperBound = (PI / 2) + ((ExtraSlots - 1) * (Pi / 12));
	}
	else
	{
		lowerBound = 0;
		upperBound = Pi;
	}
	
	for (i = SlotListOrder.Length; i < SoldierSlotCount; i++)
	{
		NewKeyframe = EmptyKeyframe;
		NewKeyframe.Location = WorldSpaceForEllipseAngle(Lerp(lowerBound, upperBound, float(i - SlotListOrder.Length) / Max(ExtraSlots - 1, 1)));
		NewKeyframe.Rotation = Keyframes[0].Rotation; // just use the same rotation
		Keyframes.AddItem(NewKeyframe);
//		m_ShapeMgr.DrawSphere(NewKeyframe.Location, Vect(10, 10, 10), MakeLinearColor(1, 0, 0, 1), true);
	}
/*
	// test the ellipsis
	for (i = 0; i < 360; i++)
	{
		m_ShapeMgr.DrawSphere(WorldSpaceForEllipseAngle(Lerp(0, 2 * Pi, float(i) / 360)), Vect(1, 1, 1), MakeLinearColor(0, float(i) / Max(360 - 1, 1), 0, 1), true);
	}
*/
}



// override -- use our attachment system
simulated function XComUnitPawn CreatePawn(StateObjectReference UnitRef, int index)
{
	local SquadSelectInterpKeyframe Keyfr;
	local XComGameState_Unit UnitState;
	local XComUnitPawn UnitPawn, GremlinPawn;
	local array<AnimSet> GremlinHQAnims;

	if (UnitRef.ObjectID <= 0) return none;

	Keyfr = GetPosRotForIndex(index);
	
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitRef.ObjectID));		
	UnitPawn = m_kPawnMgr.RequestCinematicPawn(self, UnitRef.ObjectID, Keyfr.Location, Keyfr.Rotation, /*name("Soldier"$(index + 1))*/'', '', true);

	                                                                
	UnitPawn.GotoState('CharacterCustomization');
	                                             
	UnitPawn.CreateVisualInventoryAttachments(m_kPawnMgr, UnitState, , , true); // spawn weapons and other visible equipment

	GremlinPawn = m_kPawnMgr.GetCosmeticPawn(eInvSlot_SecondaryWeapon, UnitRef.ObjectID);
	if (GremlinPawn != none)
	{
//		SetGremlinMatineeVariable(name("Gremlin"$(index + 1)), GremlinPawn);
		GremlinPawn.SetTickGroup(TG_PostAsyncWork);
		GremlinHQAnims.AddItem(AnimSet(`CONTENT.RequestGameArchetype("HQ_ANIM.Anims.AS_Gremlin")));
		GremlinPawn.XComAddAnimSetsExternal(GremlinHQAnims);
		GremlinPawn.GotoState('Gremlin_Idle');

	}
	GremlinPawns.Add(Max(index - GremlinPawns.Length + 1, 0));
	GremlinPawns[index].GremlinPawn = GremlinPawn;
	if (GremlinPawn != none)
	{
		GremlinPawns[index].LocOffset = GremlinPawn.Location - UnitPawn.Location;
	}
	// need to force an update for our newly created pawn so it gets moved to the right location
	SetTimer(0.001, false, nameof(UpdateScroll));
	return UnitPawn;
}

simulated function OnReceiveFocus()
{
	if (bSkipDirty)
	{
		bDirty = false;
		bSkipDirty = false;
	}
	else
	{
		MoveCamera(`HQINTERPTIME);
		MouseGuard.StartUpdate();
	}
	//Don't reset the camera during the launch sequence.
	//This case occurs, for example, when closing the "reconnect controller" dialog.
	//INS:
	if(bLaunched)
		return;

	super(UIScreen).OnReceiveFocus();
	// fix ported from WotC
	// When the screen gains focus in some rare case, NavHelp needs something inside it before it clears, otherwise the clear is ignored (for some reason)
	`HQPRES.m_kAvengerHUD.NavHelp.AddLeftHelp("");
	UpdateNavHelp();

	if(bDirty) 
	{
		UpdateData();
	}

}

simulated function OnLoseFocus()
{
	// always mark dirty unless the screen is just an alert -- this can happen with mission warning popups
	bDirty = true;
	
	super(UIScreen).OnLoseFocus();
	StoreGameStateChanges(); // need to save the state of the screen when we leave it

	`HQPRES.m_kAvengerHUD.NavHelp.ClearButtonHelp();

	MouseGuard.ClearUpdate();
	SetTimer(0.01, false, nameof(LostFocusWaitForStack), self);
}

// don't repopulate everything if it's just a mission warning, such as "allow wounded soldiers" etc.
simulated function LostFocusWaitForStack()
{
	if (`SCREENSTACK.GetCurrentScreen().IsA('UIAlert'))
		bSkipDirty = true;
}

defaultproperties
{
	INTERP_TIME=0.55
	// 1. we want a mouse guard, 2. of this class, 3. please let commands through
	bConsumeMouseEvents=true
	MouseGuardClass=class'robojumper_UIMouseGuard_SquadSelect'
	InputState=eInputState_Evaluate
	UIDisplayCam_Overview="PreM_UIDisplayCam_SquadSelect_Overview"
	iDefSlotY=1040
}