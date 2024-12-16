//---------------------------------------------------------------------------------------
//  FILE:    UIInventory_VIPListItem.uc
//  AUTHOR:  tracktwo / LWS
//  PURPOSE: A list item for VIPs in the post-mission loot screen. Built on top of UIInventory_ListItem
//           and the corresponding underlying flash, the only difference is re-using the "quantity" field
//           to display text.
//---------------------------------------------------------------------------------------

class UIInventory_VIPListItem extends UIInventory_ListItem;

var String VIPName;
var String VIPStatus;

simulated function InitVIPListItem(String n, String s)
{
    VIPName = n;
    VIPStatus = s;
	InitListItem();

	//Create all of the children before realizing, to be sure they can receive info. 
	RealizeDisabledState();
	RealizeBadState();
	RealizeAttentionState();
	RealizeGoodState();
}

simulated function PopulateData(optional bool bRealizeDisabled)
{
    MC.BeginFunctionOp("populateData");
    MC.QueueString(VIPName);
    MC.QueueString(VIPStatus);
    MC.EndOp();
}
