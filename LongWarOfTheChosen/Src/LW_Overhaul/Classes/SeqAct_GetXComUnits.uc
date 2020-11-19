//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_GetXComUnits.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Outputs all the units on XCOM's team to a Game State List, while
//           allowing for filtering of units based on whether they are in the
//           XCOM squad or not.
//---------------------------------------------------------------------------------------
class SeqAct_GetXComUnits extends SequenceAction;

var protected SeqVar_GameStateList FoundUnits; 

var() bool bIncludeSquad;
var() bool bIncludeNonSquad;
var() bool bRequireSoldier;

event Activated()
{
    local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit UnitToFilter;
	local StateObjectReference UnitRef;
	local bool bInSquad, bUnitsWereFound;

	local XGPlayer RequestedPlayer;
	local array<XComGameState_Unit> Units;

    XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	RequestedPlayer = GetPlayer();
	RequestedPlayer.GetUnits(Units);

	// Bind the internal list to the SeqVar plugged into the node
	foreach LinkedVariables(class'SeqVar_GameStateList', FoundUnits, "Game State List")
	{
		break;
	}

	// Walk through the units we found and filter valid units onto the SeqVar unit list
	foreach Units(UnitToFilter)
	{
		if (UnitToFilter!= none)
		{
            bInSquad = XComHQ.Squad.Find('ObjectID', UnitToFilter.ObjectID) != INDEX_NONE;
			if (((bInSquad && bIncludeSquad) || (!bInSquad && bIncludeNonSquad)) && (!bRequireSoldier || UnitToFilter.IsSoldier()))
			{
				`Log("SeqAct_GetXComUnits: Found unit " @ UnitToFilter);
				UnitRef.ObjectID = UnitToFilter.ObjectID;
				bUnitsWereFound = true;
				FoundUnits.GameStates.AddItem(UnitRef);
			}
		}
	}

	if (!bUnitsWereFound)
	{
		`Redscreen("SeqAct_GetXComUnits: Could not find any units on team XCOM.  Check for proper usage of this node.");		
	}
}

function protected XGPlayer GetPlayer()
{
	local XComTacticalGRI TacticalGRI;
	local XGBattle_SP Battle;

	TacticalGRI = `TACTICALGRI;
	Battle = (TacticalGRI != none)? XGBattle_SP(TacticalGRI.m_kBattle) : none;
	if (Battle != none)
		return Battle.GetHumanPlayer();

	return none;
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

defaultproperties
{
	ObjCategory="Unit"
	ObjName="Get XCOM Units"

	bIncludeSquad=true
	bIncludeNonSquad=true
	bRequireSoldier=true

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	VariableLinks.Empty;
	VariableLinks(0)=(ExpectedType=class'SeqVar_GameStateList',LinkDesc="Game State List", bWriteable=true, MinVars=1, MaxVars=1)
}
