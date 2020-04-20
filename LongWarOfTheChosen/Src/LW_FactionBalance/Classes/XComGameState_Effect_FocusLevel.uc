//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_Effect_FocusLevel
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Stores a base focus level for effects that need to keep track of it
//           between save game loads.
//---------------------------------------------------------------------------------------

class XComGameState_Effect_FocusLevel extends XComGameState_Effect;

var int FocusLevel;

function SetFocusLevel(int NewFocusLevel, optional array<StatChange> FocusStatChanges, optional XComGameState_Unit TargetUnit, optional XComGameState NewGameState)
{
	FocusLevel = NewFocusLevel;
	StatChanges = FocusStatChanges;
}
