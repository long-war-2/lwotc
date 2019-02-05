//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_LWToolboxPrototype.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: This is a share-able prototype of the component extension for CampaignSettings GameStates, containing 
//				additional data used for mod configuration, plus UI control code.
//---------------------------------------------------------------------------------------
class XComGameState_LWToolboxPrototype extends XComGameState_LWModOptions;

enum ERedFogHealingType
{
	eRFHealing_Undefined,
	eRFHealing_CurrentHP,
	eRFHealing_LowestHP,
	eRFHealing_AverageHP,
};

enum MissionMaxSoldiersOverrideType
{
	eMMSoldiers_None,
	eMMSoldiers_Fixed,
	eMMSoldiers_Ratio,
	eMMSoldiers_Additive,
	eMMSoldiers_Default,
};

//var delegate<GetBestDeployableSoldier> fnGetBestDeployableSoldier;
//var array< delegate<GetPersonnelStatus> > fnGetPersonnelStatusArray;

//delegate XComGameState_Unit GetBestDeployableSoldier(XComGameState_HeadquartersXCom XComHQ, optional bool bDontIncludeSquad=false, optional bool bAllowWoundedSoldiers = false);
//delegate bool GetPersonnelStatus(XComGameState_Unit Unit, out string Status, out string TimeLabel, out string TimeValue, optional int MyFontSize = -1);

static function XComGameState_LWToolboxPrototype GetToolboxPrototype();
static function SetMaxSquadSize(int NewSize);
static function OverrideRedFogHealingType(ERedFogHealingType NewType);
static function OverrideRedFogPenaltyType(EStatModOp NewType);
static function SetMissionMaxSoldiersOverride(name MissionName, MissionMaxSoldiersOverrideType Type, optional float Value = 1.0);

// ----------- TriggerEventCalls available -----------------------
// UIAfterAction_LW : `XEVENTMGR.TriggerEvent('PostAfterAction',,,UpdateState);
// UIPersonnel_SoldierListItem_LW : `XEVENTMGR.TriggerEvent('OnSoldierListItemUpdate_Start', self, self);		// trigger now to add background elements
// UIPersonnel_SoldierListItem_LW : `XEVENTMGR.TriggerEvent('OnSoldierListItemUpdate_End', self, self);			// trigger now to allow overlaying icons/text/etc on top of other stuff
// UIPersonnel_SoldierListItem_LW : `XEVENTMGR.TriggerEvent('OnSoldierListItemUpdate_Focussed', self, self);	// trigger now to allow updating on when item is focussed (e.g. changing text color)
// UIPersonnel_SquadSelect_LW: `XEVENTMGR.TriggerEvent('OnSoldierListItemUpdateDisabled', UnitItem, self);		// trigger now to allow overriding disabled status, and to add background elements
// UIRecruitmentListItem_LW : `XEVENTMGR.TriggerEvent('OnRecruitmentListItemInit', self, self);					// trigger now to allow overriding disabled status, and to add background elements
// UIRecruitmentListItem_LW : `XEVENTMGR.TriggerEvent('OnRecruitmentListItemUpdateFocus', self, self);			// trigger now to allow overriding disabled status, and to add background elements
// UISquadSelect_ListItem_LW : `XEVENTMGR.TriggerEvent('OnUpdateSquadSelect_ListItem', self, self);				// hook for mods to add extra things to the ItemList
// UISquadSelect_LW : `XEVENTMGR.TriggerEvent('EnterSquadSelect', , , NewGameState);							// Enter Squad Select Event
// UISquadSelect_LW : `XEVENTMGR.TriggerEvent('OnUpdateSquadSelectSoldiers', XComHQ, XComHQ, NewGameState);		// hook to allow mods to adjust who is in the squad
// UISquadSelect_LW : `XEVENTMGR.TriggerEvent('OnValidateDeployableSoldiers', DeployableSoldiersTuple, self);	// hook to restrict soldiers selected for auto-addition to squad
// X2StrategyElement_RandomizedSoldierRewards : `XEVENTMGR.TriggerEvent( 'SoldierCreatedEvent', NewUnitState, NewUnitState, NewGameState ); // trigger on creating new reward soldier
// X2StrategyElement_RandomizedSoldierRewards : `XEVENTMGR.TriggerEvent( 'RankUpEvent', NewUnitState, NewUnitState, NewGameState );  // trigger on rankups for new reward soldier

