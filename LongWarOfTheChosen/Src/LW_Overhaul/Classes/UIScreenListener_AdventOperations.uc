//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_AdventOperations.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//
//  PURPOSE: Adds capability to display a list of DarkEvent items when there are more than 3 dark events
//--------------------------------------------------------------------------------------- 

class UIScreenListener_AdventOperations extends UIScreenListener;

// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
	RefreshScreen(Screen);
}

event OnReceiveFocus(UIScreen Screen)
{
	RefreshScreen(Screen);
}

simulated function RefreshScreen (UIScreen Screen)
{
	local UIAdventOperations AOScreen;

	AOScreen = UIAdventOperations(Screen);
	if (AOScreen == none)
		return;

	if (AOScreen.bResistanceReport)
	{
		if (AOScreen.ChosenDarkEvents.length == 0)
		{
			AOScreen.CloseScreen();
		}
	}
	AOScreen.MC.FunctionVoid("HideAllCards");
	UpdateArrays(AOScreen);
	UpdateDarkEventList(AOScreen);
	SetDisplayedCard(AOScreen, 0);
}

simulated function UpdateArrays(UIAdventOperations AOScreen)
{
	local XComGameState_HeadquartersAlien AlienHQ;

	AlienHQ = class'UIUtilities_Strategy'.static.GetAlienHQ();
	AOScreen.ActiveDarkEvents = AlienHQ.ActiveDarkEvents;
	AOScreen.ChosenDarkEvents = AlienHQ.ChosenDarkEvents;
}

simulated function SetDisplayedCard(UIAdventOperations AOScreen, int Index)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_DarkEvent DarkEventState;
	local array<StrategyCostScalar> CostScalars;
	local bool bCanAfford, bActiveDarkEvent;
	local UIButton RevealButton;

	local string StatusLabel, Quote, QuoteAuthor, UnlockButtonLabel; 
	
	bActiveDarkEvent = AOScreen.bShowActiveEvents;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	CostScalars.Length = 0;

	if(bActiveDarkEvent)
	{
		DarkEventState = XComGameState_DarkEvent(History.GetGameStateForObjectID(AOScreen.ActiveDarkEvents[Index].ObjectID));
	}
	else
	{
		DarkEventState = XComGameState_DarkEvent(History.GetGameStateForObjectID(AOScreen.ChosenDarkEvents[Index].ObjectID));
	}
	
	if(DarkEventState == none)
		return;

	RevealButton = UIButton(AOScreen.GetChildByName('RevealButton_LW', false));
	if (RevealButton != none) 
	{ 
		RevealButton.Hide();
	}

	if(DarkEventState.bSecretEvent) 
	{
		UnlockButtonLabel = AOScreen.m_strReveal;
		bCanAfford = XComHQ.CanAffordAllStrategyCosts(DarkEventState.RevealCost, CostScalars);

		AOScreen.MC.BeginFunctionOp("UpdateDarkEventCardLocked");
		AOScreen.MC.QueueNumber(0);
		AOScreen.MC.QueueString(DarkEventState.GetDisplayName());
		AOScreen.MC.QueueString(bCanAfford ? AOScreen.m_strUnlockButton : "");
		AOScreen.MC.QueueString(DarkEventState.GetCost());
		//AOScreen.MC.QueueString(bCanAfford ? UnlockButtonLabel : "");
		AOScreen.MC.QueueString(""); // always hide the Flash reveal button, and build our own to control the callback -- TTP 401/ID 1005
		AOScreen.MC.EndOp();

		if (bCanAfford) // create own controlled button if we can reveal -- TTP 401/ID 1005
		{
			if (RevealButton == none)
			{
				RevealButton = AOScreen.Spawn(class'UIButton', AOScreen);
				RevealButton.InitButton('RevealButton_LW', UnlockButtonLabel);
				RevealButton.SetResizeToText(false);
				RevealButton.SetWidth(133);
				RevealButton.SetPosition(470, 855);
				RevealButton.OnClickedDelegate = OnRevealClicked;
			}
			else
			{
				RevealButton.Show();
			}
		}
		else
		{
		}
	}
	else
	{
		if( bActiveDarkEvent )
			StatusLabel = AOScreen.m_strActive;
		else
			StatusLabel = AOScreen.m_strPreparing;

		Quote = DarkEventState.GetQuote();
		QuoteAuthor = DarkEventState.GetQuoteAuthor();

		AOScreen.MC.BeginFunctionOp("UpdateDarkEventCard");
		AOScreen.MC.QueueNumber(0);
		AOScreen.MC.QueueString(DarkEventState.GetDisplayName());
		AOScreen.MC.QueueString(AOScreen.m_strStatusLabel);
		AOScreen.MC.QueueString(StatusLabel);
		AOScreen.MC.QueueString(DarkEventState.GetImage());
		AOScreen.MC.QueueString(DarkEventState.GetSummary());
		AOScreen.MC.QueueString(Quote);
		AOScreen.MC.QueueString(QuoteAuthor);
		AOScreen.MC.EndOp();
	}
	AOScreen.MC.FunctionNum("SetNumCards", 3);
}

simulated function OnRevealClicked(UIButton Button)
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_DarkEvent DarkEventState;
	local XComGameState_HeadquartersXCom XComHQ;
	local array<StrategyCostScalar> CostScalars;
	local bool bCanAfford;
	local UIAdventOperations AOScreen;
	local UIList DarkEventList;
	local int SelectedIdx;
	local UIButton RevealButton;

	AOScreen = GetAOScreen();
	if (AOScreen == none) { return; }
	DarkEventList = UIList(AOScreen.GetChildByName('DarkEventScrollableList_LW', false));
	if (DarkEventList == none) { return; }
	
	History = `XCOMHISTORY;

	SelectedIdx = DarkEventList.SelectedIndex;
	DarkEventState = XComGameState_DarkEvent(History.GetGameStateForObjectID(AOScreen.ChosenDarkEvents[SelectedIdx].ObjectID));
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	CostScalars.Length = 0;
	bCanAfford = XComHQ.CanAffordAllStrategyCosts(DarkEventState.RevealCost, CostScalars);

	if(DarkEventState != none && DarkEventState.bSecretEvent && bCanAfford)
	{
		AOScreen.PlaySFX("Geoscape_Reveal_Dark_Event");
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Reveal Dark Event");
		DarkEventState = XComGameState_DarkEvent(NewGameState.CreateStateObject(class'XComGameState_DarkEvent', DarkEventState.ObjectID));
		NewGameState.AddStateObject(DarkEventState);
		DarkEventState.RevealEvent(NewGameState);
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
		AOScreen.ChosenDarkEvents.Remove(SelectedIdx, 1);
		RevealButton = UIButton(AOScreen.GetChildByName('RevealButton_LW', false));
		if (RevealButton != none) 
		{
			//fix for ID 1598, stick Reveal button showing for non-hidden dark events
			RevealButton.Remove();
		}
		RefreshScreen(AOScreen);
	}
}

simulated function UIList GetDarkEventList(UIAdventOperations AOScreen)
{
	local UIList DarkEventList;

	DarkEventList = UIList(AOScreen.GetChildByName('DarkEventScrollableList_LW', false));
	if (DarkEventList != none) { return DarkEventList; }

	DarkEventList = AOScreen.Spawn(class'UIList', AOScreen);
	DarkEventList.MCName = 'DarkEventScrollableList_LW';
	DarkEventList.bIsNavigable = false;
	DarkEventList.ItemPadding = 3;
	DarkEventList.InitList(, 757, 409, 800, 528, false /*not horizontal*/); 
	DarkEventList.bStickyHighlight = false;
	DarkEventList.SetSelectedIndex(0);
	DarkEventList.OnItemClicked = DarkEventListButtonCallback;

	return DarkEventList;
}

simulated function DarkEventListButtonCallback( UIList kList, int index )
{
	local UIAdventOperations AOScreen;
	`LWTRACE("DarkEventListButtonCallback: index=" @ index);

	AOScreen = GetAOScreen();
	if (AOScreen == none) { return; }

	SetDisplayedCard(AOScreen, index);
}

simulated function UIAdventOperations GetAOScreen()
{
	local UIScreenStack ScreenStack;
	local int Index;
	ScreenStack = `SCREENSTACK;
	for( Index = 0; Index < ScreenStack.Screens.Length;  ++Index)
	{
		if(UIAdventOperations(ScreenStack.Screens[Index]) != none )
		{
			return UIAdventOperations(ScreenStack.Screens[Index]);
		}
	}
	return none; 
}

simulated function UpdateDarkEventList(UIAdventOperations AOScreen)
{
	local UIList kDarkEventList;
	local int ArrLength, ListLength, idx, idx2;
	local UIDarkEventListItem ListItem;
	local array<StateObjectReference> arrDarkEvents;

	kDarkEventList = GetDarkEventList(AOScreen);

	if (AOScreen.bShowActiveEvents)
	{
		arrDarkEvents = AOScreen.ActiveDarkEvents;
	}
	else
	{
		arrDarkEvents = AOScreen.ChosenDarkEvents;
	}
	ArrLength = arrDarkEvents.Length;
	for(idx = 0; idx < ArrLength; idx ++)
	{
		ListItem = UIDarkEventListItem(kDarkEventList.GetItem(idx));
		if(ListItem == none)
		{
			ListItem = UIDarkEventListItem(kDarkEventList.CreateItem(class'UIDarkEventListItem'));
			ListItem.InitDarkEventListItem(arrDarkEvents[idx]);
		}
		ListItem.DarkEventRef = arrDarkEvents[idx];
		ListItem.Update();
		ListItem.Show();
	}
	// remove any additional list items
	ListLength = kDarkEventList.GetItemCount();
	if(ListLength >= idx)
	{
		for(idx2 = idx; idx2 < ListLength; idx2++)
		{
			ListItem = UIDarkEventListItem(kDarkEventList.GetItem(idx));
			ListItem.Remove();
		}
	}
	if (ListLength > 0)
	{
		kDarkEventList.SetSelectedIndex(0);
		UIDarkEventListItem(kDarkEventList.GetItem(0)).OnReceiveFocus();
		UIDarkEventListItem(kDarkEventList.GetItem(0)).OnReceiveFocus();
	}
}

defaultproperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = UIAdventOperations;
}