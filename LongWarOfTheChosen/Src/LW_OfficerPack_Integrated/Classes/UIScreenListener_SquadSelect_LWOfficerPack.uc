//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_SquadSelect_LWOfficerPack
//  AUTHOR:  Amineri
//
//  PURPOSE: Adds limitations on squad composition w.r.t officer
//--------------------------------------------------------------------------------------- 

class UIScreenListener_SquadSelect_LWOfficerPack extends UIScreenListener;

//var UISquadSelect ParentScreen;

var localized string strAutoFillLabel;
var localized string strAutoFillTooltip;

// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
	local UISquadSelect SquadSelect;

	SquadSelect = UISquadSelect(Screen);
	if (SquadSelect == none)
		return;

	AddOfficerIcons(SquadSelect);

	//ClearAndRecreateSolderSlots(SquadSelect);
	//SquadSelect.UpdateData();
	//SquadSelect.SetTimer(2.5f, false, nameof(AddAutofillCenterHelp), self);
}

// This event is triggered after a screen receives focus
event OnReceiveFocus(UIScreen Screen)
{
	//AddAutofillCenterHelp();
	AddOfficerIcons(Screen);
}
// This event is triggered after a screen loses focus
//event OnLoseFocus(UIScreen Screen);

// This event is triggered when a screen is removed
//event OnRemoved(UIScreen Screen);

function AddOfficerIcons(UIScreen Screen) {

	local UISquadSelect SquadSelect;
    local UISquadSelect_ListItem ListItem;
	local int i;
	local XComGameState_Unit Unit;
	local XComGameStateHistory History;
	local UIIcon OfficerIcon;

	History = `XCOMHISTORY;

	SquadSelect = UISquadSelect(Screen);

	// create and hide icons for each slot
	for (i = 0; i < SquadSelect.m_kSlotList.ItemCount; ++i)
	{
		ListItem = UISquadSelect_ListItem(SquadSelect.m_kSlotList.GetItem(i));
		if(ListItem.GetChildByName('abilityIcon1MC', false) == none)
		{
			OfficerIcon = Screen.Spawn(class'UIIcon', ListItem.DynamicContainer);
			OfficerIcon.bAnimateOnInit = false;
			OfficerIcon.InitIcon('abilityIcon1MC', class'LWOfficerUtilities'.static.GetGenericIcon(), false, true, 18);
			OfficerIcon.OriginBottomRight();
			OfficerIcon.SetPosition(50.5, 265);
			OfficerIcon.Hide();
		}
	}

	// For each squad slot.
	for (i = 0; i < SquadSelect.m_kSlotList.ItemCount; ++i)
	{
		ListItem = UISquadSelect_ListItem(SquadSelect.m_kSlotList.GetItem(i));
		UIIcon(ListItem.GetChildByName('abilityIcon1MC')).Hide();
		if(ListItem.GetUnitRef().ObjectID > 0)
		{
			Unit = XComGameState_Unit(History.GetGameStateForObjectID(ListItem.GetUnitRef().ObjectID));
			if (class'LWOfficerUtilities'.static.IsOfficer(Unit))
				UIIcon(ListItem.GetChildByName('abilityIcon1MC')).Show();
		}
	}
}

//simulated function ClearAndRecreateSolderSlots(UISquadSelect SquadSelect)
//{
	//local int idx;
	//local UISquadSelect_ListItem_LWOfficerPack ListItem;
//
	//// clear soldiers auto-assigned by base-game in case it assigns 2 officers
	//for (idx = 0; idx < SquadSelect.GetTotalSlots(); idx++)
	//{
		//SquadSelect.m_iSelectedSlot = idx;
		//SquadSelect.ChangeSlot();
	//}
	//SquadSelect.UpdateData();
//
	////remove the UIListItems from the base game list
	//SquadSelect.m_kSlotList.ClearItems();
//
	////create new UIListItems from our own custom class
	//while( SquadSelect.m_kSlotList.itemCount < SquadSelect.GetTotalSlots() )
	//{
		//ListItem = UISquadSelect_ListItem_LWOfficerPack(SquadSelect.m_kSlotList.CreateItem(class'UISquadSelect_ListItem_LWOfficerPack'));
		//ListItem.InitPanel();
	//}
//}

simulated function AddAutofillCenterHelp()
{
	local UISquadSelect SquadSelect;
	local UIScreenStack ScreenStack;

	ScreenStack = `SCREENSTACK;
	SquadSelect = UISquadSelect(ScreenStack.GetScreen(class'UISquadSelect'));

	if(SquadSelect == none)
	{
		return;
	}

	SquadSelect.UpdateNavHelp();
	`HQPRES.m_kAvengerHUD.NavHelp.AddCenterHelp(strAutoFillLabel, "", OnAutoFillSquad, false, strAutoFillTooltip);
}

simulated function OnAutoFillSquad()
{
	//local int i, SoldierSlotCount;
	//local XComGameState_Unit UnitState;
	//local GeneratedMissionData MissionData;
	//local bool bAllowWoundedSoldiers, bAddedAnySoldiers;

	local UISquadSelect SquadSelect;
	local UIScreenStack ScreenStack;

	ScreenStack = `SCREENSTACK;
	SquadSelect = UISquadSelect(ScreenStack.GetScreen(class'UISquadSelect'));

	if(SquadSelect == none)
	{
		return;
	}

	AddOfficerIcons(SquadSelect);


	// get existing states
	//SquadSelect.XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
//
	//MissionData = SquadSelect.XComHQ.GetGeneratedMissionData(SquadSelect.XComHQ.MissionRef.ObjectID);
	//bAllowWoundedSoldiers = MissionData.Mission.AllowDeployWoundedUnits;
	//SoldierSlotCount = class'X2StrategyGameRulesetDataStructures'.static.GetMaxSoldiersAllowedOnMission(MissionData.Mission);
//
	//`Log("LW OfficerPack: Autofilling Squad, Max Size=" $ SquadSelect.GetTotalSlots());
//
	//for(i = 0; i < SoldierSlotCount; i++)
	//{
		//if(SquadSelect.XComHQ.Squad.Length == i || SquadSelect.XComHQ.Squad[i].ObjectID == 0)
		//{
			//UnitState = class'LWOfficerUtilities'.static.GetBestDeployableSoldier(SquadSelect.XComHQ, true, bAllowWoundedSoldiers);
//
			//if(UnitState != none)
			//{
				//bAddedAnySoldiers = true;
				//SquadSelect.m_iSelectedSlot = i;
				//SquadSelect.ChangeSlot(UnitState.GetReference());
			//}
		//}
	//}
	//if (bAddedAnySoldiers)
	//{
		//SquadSelect.UpdateData();
		//AddAutofillCenterHelp();
	//}
}

defaultproperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = none;
}