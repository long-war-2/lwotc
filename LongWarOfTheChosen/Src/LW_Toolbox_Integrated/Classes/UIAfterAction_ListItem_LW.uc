// Borrowed code from Rusty to disable promote button

class UIAfterAction_ListItem_LW extends UIAfterAction_ListItem config (LW_Toolbox);

var config bool bDisablePromoteForRookie;

simulated function UpdateData(optional StateObjectReference UnitRef)
{
	local XComGameState_Unit Unit;

	super.UpdateData(UnitRef);

	//disable promote button for rookie units
	if (bDisablePromoteForRookie)
	{
		if (PromoteButton != none)
		{
			Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitRef.ObjectID));
		
			if ( Unit.GetRank() == 0 && Unit.CanRankUpSoldier() && Unit.IsAlive() )
			{
				PromoteButton.SetDisabled(true);
			}
		}
	}
}

