//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_Alert.uc
//  AUTHOR:  tracktwo (Pavonis Interactive)
//  PURPOSE: Customize alert dialogs:
//              - Disable "Return to HQ" button on POI complete alerts
//				- Map "Return to HQ" button after collecting supply drop to go to Black Market instead
//---------------------------------------------------------------------------------------

class UIScreenListener_Alert extends UIScreenListener config(LW_Overhaul);

var const localized String m_strNewRebelsAvailableTitle;
var const localized String m_strNewRebelsAvailable;
var localized string m_strHelpBMGoodsDescription;

var localized string m_strInvasionTitle;
var localized string m_strInvasionLabel;
var localized string m_strInvasionBody;
var localized string m_strInvasionFlare;
var localized string m_strInvasionConfirm;
var config string m_strInvasionImage;

var localized string m_strRepeatResearch;
var float RepeatButtonX, RepeatButtonY, RepeatButtonAnimateY;
var float RepeatButtonAnimateDelay;

var delegate<X2StrategyGameRulesetDataStructures.AlertCallback> DLC2AlertCallback;

event OnInit(UIScreen Screen)
{
    local UIAlert Alert;
	local TAlertHelpInfo Info;
	local XComGameState_MissionSite MissionState;


    Alert = UIAlert(Screen);
	if (Alert == none) { return; } // this allows the class to handle child UIAlert classes from DLC

    switch(Alert.eAlertName)
    {
        // Hide the "Return to Resistance HQ" button on POI complete and
        // supply drop complete dialogs.
        case 'eAlert_ScanComplete':
        case 'eAlert_ResourceCacheComplete':
            Alert.Button2.Hide();
            Alert.Button1.SetText(class'UIAlert'.default.m_strAccept);
            break;

        // New staff dialogs may need to be updated to show info about rebel
        // units.
        case 'eAlert_NewStaffAvailableSmall':
        case 'eAlert_NewStaffAvailable':
            UpdateNewStaffDialog(Alert);
            break;
		case 'eAlert_HelpResHQGoods':
			// WOTC TODO: check that this works, since I have no idea
			Alert.DisplayPropertySet.CallbackFunction = NewBlackMarketGoodsAvailableCB;

			Info.strTitle = Alert.m_strHelpResHQGoodsTitle;
			Info.strHeader = Alert.m_strHelpResHQGoodsHeader;
			Info.strDescription = m_strHelpBMGoodsDescription;
			Info.strImage = Alert.m_strHelpResHQGoodsImage;
			Info.strConfirm = Alert.m_strRecruitNewStaff;
			Info.strCarryOn = Alert.m_strIgnore;

			Alert.BuildHelpAlert(Info);
			break;
		case 'eAlert_Retaliation':
			MissionState = XComGameState_MissionSite(`DYNAMIC_ALERT_PROP(Alert, 'MissionRef'));
			if (MissionState.GeneratedMission.Mission.sType == "Invasion_LW")
			{
				// Send over to flash
				Alert.LibraryPanel.MC.BeginFunctionOp("UpdateRetaliationSplash");
				Alert.LibraryPanel.MC.QueueString(m_strInvasionTitle);
				Alert.LibraryPanel.MC.QueueString(m_strInvasionLabel);
				Alert.LibraryPanel.MC.QueueString(m_strInvasionBody);
				Alert.LibraryPanel.MC.QueueString(m_strInvasionFlare);
				Alert.LibraryPanel.MC.QueueString(m_strInvasionImage);
				Alert.LibraryPanel.MC.QueueString(m_strInvasionConfirm);
				Alert.LibraryPanel.MC.QueueString(Alert.m_strIgnore);
				Alert.LibraryPanel.MC.EndOp();
			}	
			break;
		case 'eAlert_ResearchComplete':
			// Add an additional button to allow repeating the current research if it is a render project, and possible to repeat
			AddRepeatResearchButton(Alert);
			break;
        default:
            break;
    }
	if (Alert.IsA('UIAlert_DLC_Day60')) // TODO : ID 1610 - issues with displaying weapon popups in UISquadSelect
	{
		// WOTC TODO: Work out if this is still needed (for alien nest squad select?) and if so,
		// whether a better workaround can be used.
		// // the objective and fnCallback conditions are workarounds because we can't access the eAlert_Day60 field
		// if (!class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('DLC_HunterWeaponsReceived'))
		// {
			// HQPres = `HQPres;
			// testCallback1 = HQPres.POICompleteCB;
			// testCallback2 = HQPres.POIAlertCB;
			// if (Alert.fnCallback != testCallback1 && Alert.fnCallback != testCallback2 && Alert.fnCallback != none)
			// {
				// DLC2AlertCallback = Alert.fnCallback;
				// Alert.fnCallback = DLC2ExtendedCB;
			// }
		// }
	}
}

simulated function DLC2ExtendedCB(Name eAction, out DynamicPropertySet AlertData, optional bool bInstant = false)
{
    local XComGameState NewGameState;
    //local X2ItemTemplateManager ItemTemplateMgr;
	//local XComHQPresentationLayer HQPres;
	
	DLC2AlertCallback(eAction, AlertData, bInstant);
	if (eAction != 'eUIAction_Accept')
	{
		if (!class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('DLC_HunterWeaponsReceived'))
		{
			// added so that weapon popups will always occurs for theWeaponsAvailable
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Trigger Event: Hunter Weapons Viewed");
			`XEVENTMGR.TriggerEvent ('HunterWeaponsViewed'); 
			`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

			//HQPres = `HQPRES;
			//ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
			//HQPres.UIItemReceived(ItemTemplateMgr.FindItemTemplate('Frostbomb'));
			//HQPres.UIItemReceived(ItemTemplateMgr.FindItemTemplate('AlienHunterAxe_CV'));
			//HQPres.UIItemReceived(ItemTemplateMgr.FindItemTemplate('AlienHunterPistol_CV'));
			//HQPres.UIItemReceived(ItemTemplateMgr.FindItemTemplate('HunterRifle_CV_Schematic'));
		}
	}
}




simulated function NewBlackMarketGoodsAvailableCB(Name eAction, out DynamicPropertySet AlertData, optional bool bInstant = false)
{
	local XComGameState_BlackMarket BlackMarket;

	if (eAction == 'eUIAction_Accept')
	{
		BlackMarket = XComGameState_BlackMarket(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BlackMarket'));
		`XCOMHQ.SetPendingPointOfTravel(BlackMarket);

		if (`GAME.GetGeoscape().IsScanning())
			`HQPRES.StrategyMap2D.ToggleScan();
	}
}

simulated function UpdateNewStaffDialog(UIAlert Alert)
{
	local XComGameState_Unit UnitState;
    local String StaffBonusStr;
    local String StaffAvailableTitle;
    local String StaffAvailableStr;
    local String UnitTypeIcon;
    local XComGameState_WorldRegion Region;

	UnitState = XComGameState_Unit(`DYNAMIC_ALERT_PROP(Alert, 'UnitRef'));

    if( Alert.LibraryPanel == none )
	{
		`RedScreen("UI Problem with the alerts! Couldn't find LibraryPanel for current eAlertType: " $ Alert.eAlertName);
		return;
	}

    if (UnitState.GetMyTemplateName() == 'Rebel' || UnitState.GetMyTemplateName() == 'FacelessRebel')
    {
        
        UnitTypeIcon = class 'UIUtilities_Image'.const.EventQueue_Resistance;
        StaffAvailableTitle = m_strNewRebelsAvailableTitle;
        StaffAvailableStr = UnitState.GetFullName();
        StaffBonusStr = m_strNewRebelsAvailable;
        Region = `LWOUTPOSTMGR.GetRegionForRebel(`DYNAMIC_ALERT_PROP(Alert, 'UnitRef').GetReference());
        StaffBonusStr = Repl(StaffBonusStr, "%REGION", Region.GetDisplayName());

		Alert.LibraryPanel.MC.BeginFunctionOp("UpdateData");
		Alert.LibraryPanel.MC.QueueString(class'UIAlert'.default.m_strAttentionCommander);
		Alert.LibraryPanel.MC.QueueString(StaffAvailableTitle);
		Alert.LibraryPanel.MC.QueueString(UnitTypeIcon);
		Alert.LibraryPanel.MC.QueueString(StaffAvailableStr);
		Alert.LibraryPanel.MC.QueueString(StaffBonusStr);	
		Alert.LibraryPanel.MC.QueueString(Alert.GetOrStartWaitingForStaffImage());
		Alert.LibraryPanel.MC.QueueString(class'UIAlert'.default.m_strAccept);
		Alert.LibraryPanel.MC.EndOp();
    }
}

simulated function AddRepeatResearchButton(UIAlert Alert)
{
	local XComGameState_Tech TechState;
	local UIButton RepeatResearchButton;

	TechState = XComGameState_Tech(`DYNAMIC_ALERT_PROP(Alert, 'TechRef'));
	if (TechState != none && TechState.GetMyTemplate().bRepeatable)
	{
		if (!TechState.GetMyTemplate().bRepeatable) { return; }
		if (!`XCOMHQ.IsTechAvailableForResearch (TechState.GetReference())) { return; }

		RepeatResearchButton = Alert.Spawn (class'UIButton', Alert);
		RepeatResearchButton.bAnimateOnInit = false;
		RepeatResearchButton.OnSizeRealized = OnButtonSizeRealized;
		RepeatResearchButton.OnInitDelegates.AddItem (OnButtonInit);
		RepeatResearchButton.InitButton('RepeatResearchButton_LW', m_strRepeatResearch, OnRepeatResearch).SetPosition(RepeatButtonX, RepeatButtonY-RepeatButtonAnimateY).SetWidth(190);
	}
}

simulated function OnButtonInit(UIPanel Panel)
{
	Panel.AnimateIn(RepeatButtonAnimateDelay);
	Panel.AnimateY(RepeatButtonY, , RepeatButtonAnimateDelay);
}

simulated function OnButtonSizeRealized()
{
	local UIAlert Alert;
	local UIButton RepeatResearchButton;

	Alert = UIAlert(GetScreenOrChild('UIAlert'));
	if (Alert == none) { return; }
	RepeatResearchButton = UIButton(Alert.GetChildByName('RepeatResearchButton_LW'));
	if (RepeatResearchButton == none) { return; }

	RepeatResearchButton.SetX(RepeatButtonX-RepeatResearchButton.Width / 2.0);
}

// callback from clicking the Repeat Research button
function OnRepeatResearch(UIButton Button)
{
	local UIAlert Alert;
	local XComGameState_Tech TechState;

	Alert = UIAlert(GetScreenOrChild('UIAlert'));
	if (Alert == none) { return; }
	
	TechState = XComGameState_Tech(`DYNAMIC_ALERT_PROP(Alert, 'TechRef'));

	`XCOMHQ.SetNewResearchProject (TechState.GetReference());

	Alert.CloseScreen();
}

static function UIScreen GetScreenOrChild(name ScreenType)
{
	local UIScreenStack ScreenStack;
	local int Index;
	ScreenStack = `SCREENSTACK;
	for( Index = 0; Index < ScreenStack.Screens.Length;  ++Index)
	{
		if(ScreenStack.Screens[Index].IsA(ScreenType))
			return ScreenStack.Screens[Index];
	}
	return none; 
}

defaultproperties
{
    ScreenClass=none
	RepeatButtonX=949.5
	RepeatButtonY=715.5  // use 725.0 to align more exactly
	RepeatButtonAnimateY=8.0
	RepeatButtonAnimateDelay=1.5
}