//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_LastShotBreakdown.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Used to record shot breakdowns in game state to make sure that
//           the flyovers containing shot breakdowns have accurate information.
//---------------------------------------------------------------------------------------

class XComGameState_LastShotBreakdown extends XComGameState_BaseObject;

var ShotBreakdown ShotBreakdown;

defaultproperties
{
	bTacticalTransient=true;
}
