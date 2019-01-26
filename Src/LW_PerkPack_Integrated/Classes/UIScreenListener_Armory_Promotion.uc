//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_Armory_Promotion.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//
//  PURPOSE: Listens for the original UI and kills/replaces it if needed
//--------------------------------------------------------------------------------------- 

class UIScreenListener_Armory_Promotion extends UIScreenListener;

// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
	local XComHQPresentationLayer HQPres;
	local UIArmory_LWExpandedPromotion ExpandedScreen;
	local UIAfterAction AfterActionScreen;
	local StateObjectReference UnitRef;
	local bool bShownClassPopup;
	local UIAlert Alert;
	local XComGameState NewGameState;
	local XComGameState_Unit UnitState;

	`Log("PerkPack: Initializing UIScreenListener_Armory_Promotion");

	if(class'UIArmory_MainMenu_LW'.default.bUse2WideAbilityTree || class'XComGameState_LWPerkPackOptions'.static.IsBaseGamePerkUIEnabled())
		return;

	UnitRef = UIArmory_Promotion(Screen).GetUnitRef();
	HQPres = `HQPRES;
	//see if there was a soldier trained alert, and save it off if there was
	Alert = UIAlert(HQPres.Screenstack.GetScreen(class'UIAlert'));
	if(Alert != none && Alert.eAlertName == 'eAlert_SoldierPromoted')
	{
		bShownClassPopup = true;
	
		// Flag the new class popup as having been seen, so we don't generate a second one when creating the replacement UIPromotion
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Unit Promotion Callback");
		UnitState = XComGameState_Unit(NewGameState.CreateStateObject(
			class'XComGameState_Unit',
			class'X2StrategyGameRulesetDataStructures'.static.GetDynamicIntProperty(Alert.DisplayPropertySet, 'UnitRef')));
		NewGameState.AddStateObject(UnitState);
		UnitState.bNeedsNewClassPopup = false;
		`GAMERULES.SubmitGameState(NewGameState);
	}
	// pop off the old (2-wide) ability UI and create a new instance of the (3-wide) ability UI
	HQPres.Screenstack.Pop(Screen);
	ExpandedScreen = UIArmory_LWExpandedPromotion(HQPres.ScreenStack.Push(HQPres.Spawn(class'UIArmory_LWExpandedPromotion', HQPres), HQPres.Get3DMovie()));
	ExpandedScreen.InitPromotion(UnitRef, false);
	// check to see if we are in AfterAction and need to move the pawns, since they are reset when the old UIPromotion is destroyed
	AfterActionScreen = UIAfterAction(GetScreen('UIAfterAction'));
	if(AfterActionScreen != none)
	{
		MoveAfterActionPawns(UnitRef, AfterActionScreen);
	}
	// move the Promote Alert to the top of the stack
	if(bShownClassPopup) 
	{
		HQPres.ScreenStack.MoveToTopOfStack(class'UIAlert');
	}
}

function MoveAfterActionPawns(StateObjectReference UnitBeingPromoted, UIAfterAction AfterAction)
{
	local int i;
	local XComUnitPawn UnitPawn, GremlinPawn;
	local PointInSpace PlacementActor;
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = AfterAction.XComHQ;
	for(i = 0; i < XComHQ.Squad.Length; ++i)
	{
		if(XComHQ.Squad[i] == UnitBeingPromoted)
			continue;

		PlacementActor = AfterAction.GetPlacementActor(name(AfterAction.m_strPawnLocationSlideawayIdentifier$i));
		UnitPawn = AfterAction.UnitPawns[i];

		if(UnitPawn != none && PlacementActor != none)
		{
			UnitPawn.SetLocation(PlacementActor.Location);
			GremlinPawn = `HQPRES.GetUIPawnMgr().GetCosmeticPawn(eInvSlot_SecondaryWeapon, UnitPawn.ObjectID);
			if(GremlinPawn != none)
				GremlinPawn.SetLocation(PlacementActor.Location);
		}
	}
}

simulated function UIScreen GetScreen(name TestScreenClass )
{
	local UIScreenStack ScreenStack;
	local int Index;

	ScreenStack = `SCREENSTACK;
	for(Index = 0; Index < ScreenStack.Screens.Length;  ++Index)
	{
		if(ScreenStack.Screens[Index].IsA(TestScreenClass))
			return ScreenStack.Screens[Index];
	}
	return none; 
}

//This event is triggered after a screen receives focus
//event OnReceiveFocus(UIScreen Screen);

// This event is triggered after a screen loses focus
//event OnLoseFocus(UIScreen Screen);


// This event is triggered when a screen is removed
//event OnRemoved(UIScreen Screen);

defaultproperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = UIArmory_Promotion;
}