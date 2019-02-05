//---------------------------------------------------------------------------------------
//  FILE:    UIAfterAction_LW
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: This file extends the post-mission squad view to support larger squads.
//--------------------------------------------------------------------------------------- 

class UIAfterAction_LW extends UIAfterAction config(LW_Toolbox);

//`include(LW_Overhaul\Src\LW_Overhaul.uci)

var bool m_bBackRowActive;
var UIList m_kSlotList2;
var string UIDisplayCam_Back;			//Name of the point that the camera rests at to display back row soldiers
var config float CameraTransitionTime;

// Constructor
simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	super(UIScreen).InitScreen(InitController, InitMovie, InitName);

	//do this to mask NavHelp buttons when running a SimCombat/Autoresolve mission
	`HQPRES.m_kAvengerHUD.NavHelp.ClearButtonHelp();

	Navigator.HorizontalNavigation = true;
	Navigator.LoopSelection = true;

	// get existing states
	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();

	m_kMissionInfo = Spawn(class'UISquadSelectMissionInfo', self).InitMissionInfo();

	CreatePanels();
	UpdateData();
	UpdateMissionInfo();

	//Delay by a slight amount to let pawns configure. Otherwise they will have Giraffe heads.
	SetTimer(0.2f, false, nameof(StartPostMissionCinematic));

	//SoldierPicture_Head_Armory

	`HQPRES.CAMLookAtNamedLocation(UIDisplayCam_WalkUpStart, 0.0f);
	XComHeadquartersController(`HQPRES.Owner).SetInputState('None');

	// Show header with "After Action" text
	`HQPRES.m_kAvengerHUD.FacilityHeader.SetText(class'UIFacility'.default.m_strAvengerLocationName, m_strAfterActionReport);
	`HQPRES.m_kAvengerHUD.FacilityHeader.Hide();
}

simulated function CreatePanels()
{
	local int i, listX, listWidth, listItemPadding;

	//create front row panels
	listWidth = 0;
	listItemPadding = 6;
	for (i = 0; i < Min(6, XComHQ.Squad.Length); ++i)
	{
		if (XComHQ.Squad[i].ObjectID > 0)
			listWidth += (class'UISquadSelect_ListItem'.default.width + listItemPadding);
	}
	listX = Clamp((Movie.UI_RES_X / 2) - (listWidth / 2), 100, Movie.UI_RES_X / 2);

	m_kSlotList = Spawn(class'UIList', self);
	m_kSlotList.InitList('', listX, -390, Movie.UI_RES_X, 310, true).AnchorBottomLeft();
	m_kSlotList.itemPadding = listItemPadding;

	// WOTC DEBUGGING:
	`Log("After action: squad size = " $ XComHQ.Squad.Length);
	// END

	//create back row panels
	if(XComHQ.Squad.Length > 6)
	{
		listWidth = 0;
		listItemPadding = 6;
		for (i = 6; i < XComHQ.Squad.Length; ++i)
		{
			if (XComHQ.Squad[i].ObjectID > 0)
				listWidth += (class'UISquadSelect_ListItem'.default.width + listItemPadding);
		}
		listX = Clamp((Movie.UI_RES_X / 2) - (listWidth / 2), 100, Movie.UI_RES_X / 2);

		m_kSlotList2 = Spawn(class'UIList', self);
		m_kSlotList2.InitList('', listX, -390, Movie.UI_RES_X, 310, true).AnchorBottomLeft();
		m_kSlotList2.itemPadding = listItemPadding;

		m_kSlotList2.Hide(); // hidden initially
	}
}

simulated function UpdateData()
{
	local bool bMakePawns;
	local int SlotIndex;	//Index into the list of places where a soldier can stand in the after action scene, from left to right
	local int SquadIndex;	//Index into the HQ's squad array, containing references to unit state objects
	local int ListItemIndex;//Index into the array of list items the player can interact with to view soldier status and promote
	local UIAfterAction_ListItem ListItem;	

	bMakePawns = UnitPawns.Length == 0;//We only need to create pawns if we have never had them before	

	//front row
	ListItemIndex = 0;
	for (SlotIndex = 0; SlotIndex < SlotListOrder.Length; ++SlotIndex)
	{
		SquadIndex = SlotListOrder[SlotIndex];
		if (XComHQ.Squad[SquadIndex].ObjectID > 0)
		{
			if (bMakePawns)
			{
				if (ShowPawn(XComHQ.Squad[SquadIndex]))
				{
					UnitPawns[SquadIndex] = CreatePawn(XComHQ.Squad[SquadIndex], SquadIndex, false);
					UnitPawns[SquadIndex].SetVisible(false);
					UnitPawnsCinematic[SquadIndex] = CreatePawn(XComHQ.Squad[SquadIndex], SquadIndex, true);
				}
			}

			if (m_kSlotList.itemCount > ListItemIndex)
			{
				ListItem = UIAfterAction_ListItem(m_kSlotList.GetItem(ListItemIndex));
			}
			else
			{
				ListItem = UIAfterAction_ListItem(m_kSlotList.CreateItem(class'UIAfterAction_ListItem')).InitListItem();
			}

			ListItem.UpdateData(XComHQ.Squad[SquadIndex]);

			++ListItemIndex;
		}
	}

	//back row
	ListItemIndex = 0;
	for (SlotIndex = 0; SlotIndex < SlotListOrder.Length; ++SlotIndex)
	{
		SquadIndex = 6 + SlotListOrder[SlotIndex];
		if (SquadIndex < XComHQ.Squad.Length)
		{	
			if (XComHQ.Squad[SquadIndex].ObjectID > 0)
			{
				if (bMakePawns)
				{
					if (ShowPawn(XComHQ.Squad[SquadIndex]))
					{
						UnitPawns[SquadIndex] = CreatePawn(XComHQ.Squad[SquadIndex], SquadIndex, false);
						UnitPawns[SquadIndex].SetVisible(false);
						UnitPawnsCinematic[SquadIndex] = CreatePawn(XComHQ.Squad[SquadIndex], SquadIndex, true);
					}
				}

				if (m_kSlotList2.itemCount > ListItemIndex)
				{
					ListItem = UIAfterAction_ListItem(m_kSlotList2.GetItem(ListItemIndex));
				}
				else
				{
					ListItem = UIAfterAction_ListItem(m_kSlotList2.CreateItem(class'UIAfterAction_ListItem')).InitListItem();
				}

				ListItem.UpdateData(XComHQ.Squad[SquadIndex]);

				++ListItemIndex;
			}
		}
	}

}

simulated function UpdateNavHelp()
{
	local UINavigationHelp NavHelp;
	NavHelp = `HQPRES.m_kAvengerHUD.NavHelp;
	NavHelp.ClearButtonHelp();
	NavHelp.AddContinueButton(OnContinue);
	if(m_bBackRowActive)
	{
		NavHelp.AddBackButton(OnBack);
	}
}

simulated function OnContinue()
{		
	local bool HasBackRowSoldiers;
	local int idx;

	class'XComGameStateContext_StrategyGameRule'.static.RemoveInvalidSoldiersFromSquad();

	HasBackRowSoldiers = false;
	if (XComHQ.Squad.Length > 6)
	{
		for (idx = 6; idx < XComHQ.Squad.Length; idx++)
		{
			if (XComHQ.Squad[idx].ObjectID > 0)
			{
				HasBackRowSoldiers = true;
				break;
			}
		}
	}

	if(m_bBackRowActive || !HasBackRowSoldiers)
	{
		//terminate
		UpdateState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("After Action");
		`XEVENTMGR.TriggerEvent('PostAfterAction',,,UpdateState);
		`GAMERULES.SubmitGameState(UpdateState);

		`GAME.GetGeoscape().m_kBase.SetAvengerCapVisibility(false);

		CloseScreen();

		`HQPRES.UIInventory_LootRecovered();
	}
	else
	{
		//`LOG("UIAfterAction_LW: Shifting camera to back row");
		m_bBackRowActive = true;
		UpdateNavHelp();
		m_kSlotList.Hide();
		m_kSlotList2.Show();
		`HQPRES.CAMLookAtNamedLocation(UIDisplayCam_Back, CameraTransitionTime);
	}

}

simulated function OnBack()
{	
	m_bBackRowActive = false;
	UpdateNavHelp();
	m_kSlotList2.Hide();
	m_kSlotList.Show();
	`HQPRES.CAMLookAtNamedLocation(UIDisplayCam_Default, CameraTransitionTime);
	
}

simulated function OnReceiveFocus()
{
	super(UIScreen).OnReceiveFocus();
	UpdateNavHelp();
	UpdateData();
	if(m_bBackRowActive)
		`HQPRES.CAMLookAtNamedLocation(UIDisplayCam_Back, 0.0f);  
	else
		`HQPRES.CAMLookAtNamedLocation(UIDisplayCam_Default, 0.0f);
}

simulated function XComUnitPawn CreatePawn(StateObjectReference UnitRef, int index, bool bCinematic)
{
	local name LocationName;
	local PointInSpace PlacementActor;
	local XComGameState_Unit UnitState;
	local XComUnitPawn UnitPawn, GremlinPawn;
	local Vector ZeroVec;
	local Rotator ZeroRot;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitRef.ObjectID));

	if(!bCinematic)
	{
		LocationName = name(m_strPawnLocationIdentifier $ index);

		PlacementActor = GetPlacementActor(LocationName);

		UnitPawn = `HQPRES.GetUIPawnMgr().RequestPawnByState(self, UnitState, PlacementActor.Location, PlacementActor.Rotation);
		UnitPawn.GotoState('CharacterCustomization');

		UnitPawn.CreateVisualInventoryAttachments(`HQPRES.GetUIPawnMgr(), UnitState); // spawn weapons and other visible equipment

		GremlinPawn = `HQPRES.GetUIPawnMgr().GetCosmeticPawn(eInvSlot_SecondaryWeapon, UnitRef.ObjectID);
		if (GremlinPawn != none)
		{
			SetGremlinMatineeVariable(index, GremlinPawn);
			GremlinPawn.SetLocation(PlacementActor.Location);
			GremlinPawn.SetVisible(false);
		}
	}
	else
	{
		UnitPawn = UnitState.CreatePawn(self, ZeroVec, ZeroRot); //Create a throw-away pawn
		UnitPawn.CreateVisualInventoryAttachments(none, UnitState); // spawn weapons and other visible equipment
	}
		
	return UnitPawn;
}

simulated function OnPromote(StateObjectReference UnitRef)
{
	local XComGameState_Unit UnitState;
	local UIArmory_LWExpandedPromotion ExpandedScreen;
	local UIArmory_MainMenu ArmoryScreen;
	local XComHQPresentationLayer HQPres;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitRef.ObjectID));

	if (UnitState.IsPsiOperative())
	{
		//`HQPRES.UIArmory_Promotion(UnitRef); Turned this off because it has wonky left-right buttons at bottom
		return; // button does nothing
	}
	else
	{
		HQPres = `HQPRES;

		class'X2StrategyGameRulesetDataStructures'.static.PromoteSoldier(UnitRef);

		//Ami: open and then immediately close Armory MainMenu to make sure that the correct flash object is cached first - ID 1241 / TTP 516
		ArmoryScreen = UIArmory_MainMenu(HQPres.ScreenStack.Push(HQPres.Spawn(class'UIArmory_MainMenu', HQPres), HQPres.Get3DMovie()));
		ArmoryScreen.InitArmory(UnitRef, , , , , , true /* bInstant */);
		ArmoryScreen.CloseScreen();

		ExpandedScreen = UIArmory_LWExpandedPromotion(HQPres.ScreenStack.Push(HQPres.Spawn(class'UIArmory_LWExpandedPromotion', HQPres), HQPres.Get3DMovie()));
		ExpandedScreen.InitPromotion(UnitRef, false);

		`XEVENTMGR.TriggerEvent('OnUnitPromotion', UnitState, ExpandedScreen); // trigger for manual promotion events -- typically used for first-time promotion dialogue boxes, cinematics, etc
	}

	MovePawns_LW(UnitRef);
}

function MovePawns_LW(StateObjectReference UnitBeingPromoted)
{
	local int i;
	local XComUnitPawn UnitPawn, GremlinPawn;
	local PointInSpace PlacementActor;
	//local StateObjectReference UnitBeingPromoted;

	//if(`SCREENSTACK.IsInStack(class'UIArmory_Promotion'))
		//UnitBeingPromoted = UIArmory_Promotion(`SCREENSTACK.GetScreen(class'UIArmory_Promotion')).UnitReference;
//
	//if(UnitBeingPromoted == none)  // handle case with PerkPack
	//{
//
	//}

	for(i = 0; i < XComHQ.Squad.Length; ++i)
	{
		if(XComHQ.Squad[i] == UnitBeingPromoted)
			continue;

		PlacementActor = GetPlacementActor(GetPawnLocationTag(XComHQ.Squad[i], m_strPawnLocationSlideawayIdentifier));
		UnitPawn = UnitPawns[i];

		if(UnitPawn != none && PlacementActor != none)
		{
			UnitPawn.SetLocation(PlacementActor.Location);
			GremlinPawn = `HQPRES.GetUIPawnMgr().GetCosmeticPawn(eInvSlot_SecondaryWeapon, UnitPawn.ObjectID);
			if(GremlinPawn != none)
				GremlinPawn.SetLocation(PlacementActor.Location);
		}
	}
}

simulated function PointInSpace GetPlacementActor(name PawnLocationTag)
{
	local Actor TmpActor;
	local array<Actor> Actors;
	local XComBlueprint Blueprint;
	local PointInSpace PlacementActor;

	foreach WorldInfo.AllActors(class'PointInSpace', PlacementActor)
	{
		if (PlacementActor != none && PlacementActor.Tag == PawnLocationTag)
			break;
	}

	if(PlacementActor == none)
	{
		foreach WorldInfo.AllActors(class'XComBlueprint', Blueprint)
		{
			if (Blueprint.Tag == PawnLocationTag)
			{
				Blueprint.GetLoadedLevelActors(Actors);
				foreach Actors(TmpActor)
				{
					PlacementActor = PointInSpace(TmpActor);
					if(PlacementActor != none)
					{
						break;
					}
				}
			}
		}
	}

	return PlacementActor;
}

DefaultProperties
{
	Package   = "/ package/gfxSquadList/SquadList";

	InputState = eInputState_Consume;
	bHideOnLoseFocus = true;
	bAutoSelectFirstNavigable = false;
	
	m_strPawnLocationIdentifier = "Blueprint_AfterAction_Promote";
	m_strPawnLocationSlideawayIdentifier = "UIPawnLocation_SlideAway_";

	UIDisplayCam_WalkUpStart = "Cam_AfterAction_Start"; //Starting point for the slow truck downward that the after action report camera plays
	UIDisplayCam_Default = "Cam_AfterAction_End"; //Name of the point that the camera rests at in the after action report
	UIDisplayCam_Back ="Cam_AfterAction_Back"; //Name of the point that the camera rests at when viewing back row
	UIBlueprint_Prefix = "Blueprint_AfterAction_Promote" //Prefix for the name of the point used for editing soldiers in-place on the avenger deck
	UIBlueprint_Prefix_Wounded = "Blueprint_AfterAction_PromoteWounded"
	//CameraTransitionTime = 0.5f;

	//Refer to the points / camera setup in CIN_PostMission1 to understand this array
	SlotListOrder[0] = 4
	SlotListOrder[1] = 2
	SlotListOrder[2] = 0
	SlotListOrder[3] = 1
	SlotListOrder[4] = 3
	SlotListOrder[5] = 5

}
