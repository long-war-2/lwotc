//---------------------------------------------------------------------------------------
//  FILE:    UIAdventOperations_LW.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Displays dark events as a list rather than cards so that large numbers of
//           dark events are manageable in the UI.
//
// This is a modified copy of the base game's UIAdventOperations combined with code
// from the original LW2's UIScreenListener_AdventOperations.
//---------------------------------------------------------------------------------------
class UIAdventOperations_LW extends UIAdventOperations;

simulated function BuildScreen( optional bool bAnimateIn = false )
{
	local XComGameState_HeadquartersAlien AlienHQ;
	local int NumEvents;

	MC.FunctionVoid("HideAllCards");

	BuildTitlePanel();

	AlienHQ = class'UIUtilities_Strategy'.static.GetAlienHQ();
	ActiveDarkEvents = AlienHQ.ActiveDarkEvents;
	ChosenDarkEvents = AlienHQ.ChosenDarkEvents;
	
	ActiveDarkEvents.Sort(ActiveDarkEventSort);
    
	if (!bShowActiveEvents)
	{
		NumEvents = UpdateDarkEventList();
		BuildDarkEventPanel(0, false);
	}
	else if (!bResistanceReport)
	{
		NumEvents = UpdateDarkEventList();      
		BuildDarkEventPanel(0, true);
	}
	else
	{
		// Close this screen if it's the resistance report and there are no
		// pending dark events.
		NumEvents = ChosenDarkEvents.Length;
		if (NumEvents == 0)
		{
			CloseScreen();
		}
	}

	// This fixes the alignment of the displayed card and makes it independent of how
	// many active or pending dark events there are.
	MC.FunctionNum("SetNumCards", 3);
	RefreshNav();

	// KDM : Previously, the flash call to AnimateIn had been commented out by Long War; however,
	// this created a situation in which 2 flash elements, bottomShadow and hexBackground, were never
	// made visible on the Dark Events screen.
	if (bAnimateIn)
	{ 
		MC.FunctionVoid("AnimateIn");
	}
}

// Returns the number of events in the list (whether it's the active or pending one)
simulated function int UpdateDarkEventList()
{
	local UIList kDarkEventList;
	local int ArrLength, ListLength, idx, idx2;
	local UIDarkEventListItem ListItem;
	local array<StateObjectReference> arrDarkEvents;

	kDarkEventList = GetDarkEventListUI();

	if (bShowActiveEvents)
	{
		arrDarkEvents = ActiveDarkEvents;
	}
	else
	{
		arrDarkEvents = ChosenDarkEvents;
	}
	ArrLength = arrDarkEvents.Length;
	for (idx = 0; idx < ArrLength; idx ++)
	{
		ListItem = UIDarkEventListItem(kDarkEventList.GetItem(idx));
		if (ListItem == none)
		{
			ListItem = UIDarkEventListItem(kDarkEventList.CreateItem(class'UIDarkEventListItem'));
			ListItem.InitDarkEventListItem(arrDarkEvents[idx]);
		}
		ListItem.DarkEventRef = arrDarkEvents[idx];
		ListItem.Update();
		ListItem.Show();
	}
	// Remove any additional list items
	ListLength = kDarkEventList.GetItemCount();
	if (ListLength >= idx)
	{
		for (idx2 = idx; idx2 < ListLength; idx2++)
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
        
	return ArrLength;
}

static function int ActiveDarkEventSort(StateObjectReference DERefA, StateObjectReference DERefB)
{
	local XComGameStateHistory History;
	local XComGameState_DarkEvent DarkEventA, DarkEventB;

	History = `XCOMHISTORY;
	DarkEventA = XComGameState_DarkEvent(History.GetGameStateForObjectID(DERefA.ObjectID));
	DarkEventB = XComGameState_DarkEvent(History.GetGameStateForObjectID(DERefB.ObjectID));

	// 1) Sort by permanent/not permanent
	if (DarkEventA.GetMyTemplate().bInfiniteDuration && !DarkEventB.GetMyTemplate().bInfiniteDuration)
	{
		return 1;
	}
	else if (!DarkEventA.GetMyTemplate().bInfiniteDuration && DarkEventB.GetMyTemplate().bInfiniteDuration)
	{
		return -1;
	}
	// 2) Otherwise, leave the original order
	else return 0;
}

simulated function UIList GetDarkEventListUI()
{
	local UIList DarkEventList;

	DarkEventList = UIList(GetChildByName('DarkEventScrollableList_LW', false));
	if (DarkEventList != none)
	{
		return DarkEventList;
	}

	DarkEventList = Spawn(class'UIList', self);
	DarkEventList.MCName = 'DarkEventScrollableList_LW';
	DarkEventList.ItemPadding = 3;
	// KDM : Moved the list up, so it's in-line with the dark event card to its left.
	DarkEventList.InitList(, 757, 95, 800, 528, false /*not horizontal*/); 
	DarkEventList.bStickyHighlight = false;
	DarkEventList.SetSelectedIndex(0);
	DarkEventList.OnItemClicked = DarkEventListButtonCallback;

	return DarkEventList;
}

simulated function DarkEventListButtonCallback(UIList kList, int index)
{
	`LWTRACE("DarkEventListButtonCallback: index=" @ index);

	BuildDarkEventPanel(index, bShowActiveEvents);
}

simulated function BuildDarkEventPanel(int Index, bool bActiveDarkEvent)
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_DarkEvent DarkEventState;
	local array<StrategyCostScalar> CostScalars;
	local bool bCanAfford, bIsChosen;
	local StateObjectReference NoneRef;

	local string StatusLabel, Quote, QuoteAuthor, UnlockButtonLabel; 
	
	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	CostScalars.Length = 0;

	if (bActiveDarkEvent)
	{
		DarkEventState = XComGameState_DarkEvent(History.GetGameStateForObjectID(ActiveDarkEvents[Index].ObjectID));
		ActiveDarkEvents[Index] = DarkEventState.GetReference();
	}
	else
	{
		DarkEventState = XComGameState_DarkEvent(History.GetGameStateForObjectID(ALIENHQ().ChosenDarkEvents[Index].ObjectID));
		ChosenDarkEvents[Index] = DarkEventState.GetReference();
	}
	
	if (DarkEventState != none)
	{
		// Trigger Central VO narrative if this Dark Event was generated by a Favored Chosen
		if (DarkEventState.bChosenActionEvent)
		{
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Trigger Event: Favored Chosen Dark Event");
			`XEVENTMGR.TriggerEvent('FavoredChosenDarkEvent', , , NewGameState);
			`GAMERULES.SubmitGameState(NewGameState);
		}

		if (DarkEventState.bSecretEvent) 
		{
			if (`ISCONTROLLERACTIVE)
			{
				UnlockButtonLabel = class'UIUtilities_Text'.static.InjectImage(
					class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_X_SQUARE, 20, 20, -10) @ m_strReveal;
			}
			else
			{
				UnlockButtonLabel = m_strReveal;
				ChosenDarkEvents[Index] = DarkEventState.GetReference();
			}
			bCanAfford = XComHQ.CanAffordAllStrategyCosts(DarkEventState.RevealCost, CostScalars);

			MC.BeginFunctionOp("UpdateDarkEventCardLocked");
			// LWOTC: Always update the left most card as that's the only one we're displaying.
			MC.QueueNumber(0);
			MC.QueueString(DarkEventState.GetDisplayName());
			MC.QueueString(bCanAfford ? m_strUnlockButton : "");
			MC.QueueString(DarkEventState.GetCost());
			MC.QueueString(bCanAfford ? UnlockButtonLabel : "");
			MC.EndOp();
		}
		else
		{
			if (bActiveDarkEvent)
			{
				StatusLabel = m_strActive;
			}
			else
			{
				StatusLabel = m_strPreparing;
			}

			Quote = DarkEventState.GetQuote();
			QuoteAuthor = DarkEventState.GetQuoteAuthor();
			bIsChosen = DarkEventState.ChosenRef != NoneRef;

			MC.BeginFunctionOp("UpdateDarkEventCard");
			// LWOTC: Always update the left most card as that's the only one we're displaying.
			MC.QueueNumber(0);
			MC.QueueString(DarkEventState.GetDisplayName());
			MC.QueueString(m_strStatusLabel);
			MC.QueueString(StatusLabel);
			MC.QueueString(DarkEventState.GetImage());
			MC.QueueString(DarkEventState.GetSummary());
			MC.QueueString(Quote);
			MC.QueueString(QuoteAuthor);
			MC.QueueBoolean(bIsChosen);
			MC.EndOp();
		}
	}

	// This fixes the alignment of the displayed card and makes it independent of how
	// many active or pending dark events there are.
	MC.FunctionNum("SetNumCards", 3);
}

simulated function OnRevealClicked(int idx)
{
	local UIDarkEventListItem ListItem;
	local UIList DarkEventList;
	local XComHQPresentationLayer HQPres;

	HQPres = `HQPRES;

	DarkEventList = UIList(GetChildByName('DarkEventScrollableList_LW', false));
	if (DarkEventList == none)
	{
		return;
	}
    
	idx = DarkEventList.SelectedIndex;
	super.OnRevealClicked(idx);

	// Need this so that the corresponding list item updates as well.
	// It would be nicer to update the list item directly, but not sure
	// how to do that.
	ListItem = UIDarkEventListItem(DarkEventList.GetItem(idx));
	ListItem.DarkEventRef = ChosenDarkEvents[idx];
	ListItem.Update();
	ListItem.Show();

	// KDM : If a dark event has been revealed, intel has been used; therefore, update
	// the resource bar.
	HQPres.m_kAvengerHUD.UpdateResources();
}
