//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_LWSquadManager.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: This singleton object manages persistent squad information for the mod
//---------------------------------------------------------------------------------------
class XComGameState_LWSquadManager extends XComGameState_BaseObject config(LW_InfiltrationSettings);

var transient StateObjectReference LaunchingMissionSquad;

var int MaxSquads; // Maximum number of squads allowed currently -- UNUSED
var array<StateObjectReference> Squads;   //the squads currently defined

var bool bNeedsAttention;

var config int MAX_SQUAD_SIZE;
var config int MAX_FIRST_MISSION_SQUAD_SIZE;
var config array<name> NonInfiltrationMissions;
var config MissionIntroDefinition InfiltrationMissionIntroDefinition;

// The name of the sub-menu for resistance management
const nmSquadManagementSubMenu = 'LW_SquadManagementMenu';

var localized string LabelBarracks_SquadManagement;
var localized string TooltipBarracks_SquadManagement;

static function XComGameState_LWSquadManager GetSquadManager(optional bool AllowNULL = false)
{
	return XComGameState_LWSquadManager(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_LWSquadManager', AllowNULL));
}

static function CreateSquadManager(optional XComGameState StartState)
{
	local XComGameState_LWSquadManager SquadMgr;
	local XComGameState NewGameState;

	//first check that there isn't already a singleton instance of the squad manager
	if(GetSquadManager(true) != none)
		return;

	if(StartState != none)
	{
		SquadMgr = XComGameState_LWSquadManager(StartState.CreateNewStateObject(class'XComGameState_LWSquadManager'));
	}
	else
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Creating LW Squad Manager Singleton");
		SquadMgr = XComGameState_LWSquadManager(NewGameState.CreateNewStateObject(class'XComGameState_LWSquadManager'));
	}
	SquadMgr.InitSquadManagerListeners();
}

// add the first mission squad to the StartState
static function CreateFirstMissionSquad(XComGameState StartState)
{
	local XComGameState_LWPersistentSquad NewSquad;
	local XComGameState_LWSquadManager StartSquadMgr;
	local XComGameState_HeadquartersXCom StartXComHQ;
	local XComGameState_MissionSite StartMission;

	foreach StartState.IterateByClassType(class'XComGameState_LWSquadManager', StartSquadMgr)
	{
		break;
	}
	foreach StartState.IterateByClassType(class'XComGameState_HeadquartersXCom', StartXComHQ)
	{
		break;
	}
	foreach StartState.IterateByClassType(class'XComGameState_MissionSite', StartMission)
	{
		break;
	}

	if (StartSquadMgr == none || StartXComHQ == none || StartMission == none)
	{
		return;
	}
	StartXComHQ.MissionRef = StartMission.GetReference();

	//create the first mission squad state
	NewSquad = XComGameState_LWPersistentSquad(StartState.CreateNewStateObject(class'XComGameState_LWPersistentSquad'));

	StartSquadMgr.Squads.AddItem(NewSquad.GetReference());

	NewSquad.InitSquad(, false);
	NewSquad.SquadSoldiersOnMission = StartXComHQ.Squad;
	NewSquad.SquadSoldiers = StartXComHQ.Squad;
	NewSquad.CurrentMission = StartXComHQ.MissionRef;
	NewSquad.bOnMission = true;
	NewSquad.CurrentInfiltration = 1.0;
	NewSquad.CurrentEnemyAlertnessModifier = 0;
}

// After beginning a game, set up the squad management interface.
function SetupSquadManagerInterface()
{
    EnableSquadManagementMenu();
}

// Enable the Squad Manager menu
function EnableSquadManagementMenu(optional bool forceAlert = false)
{
    local string AlertIcon;
    local UIAvengerShortcutSubMenuItem SubMenu;
    local UIAvengerShortcuts Shortcuts;

    if (NeedsAttention() || forceAlert)
    {
        AlertIcon = class'UIUtilities_Text'.static.InjectImage(class'UIUtilities_Image'.const.HTML_AttentionIcon, 20, 20, 0) $" ";
    }

    ShortCuts = `HQPRES.m_kAvengerHUD.Shortcuts;

    if (ShortCuts.FindSubMenu(eUIAvengerShortcutCat_Barracks, nmSquadManagementSubMenu, SubMenu))
    {
        // It already exists: just update the label to adjust the alert state (if necessary).
        SubMenu.Message.Label = AlertIcon $ LabelBarracks_SquadManagement;
        Shortcuts.UpdateSubMenu(eUIAvengerShortcutCat_Barracks, SubMenu);
    }
    else
    {
        SubMenu.Id = nmSquadManagementSubMenu;
        SubMenu.Message.Label = AlertIcon $ LabelBarracks_SquadManagement;
        SubMenu.Message.Description = TooltipBarracks_SquadManagement;
        SubMenu.Message.Urgency = eUIAvengerShortcutMsgUrgency_Low;
        SubMenu.Message.OnItemClicked = GoToSquadManagement;
        Shortcuts.AddSubMenu(eUIAvengerShortcutCat_Barracks, SubMenu);
    }
}

simulated function GoToSquadManagement(optional StateObjectReference Facility)
{
    local XComHQPresentationLayer HQPres;
    local UIAvengerShortcutSubMenuItem SubMenu;
    local UIAvengerShortcuts Shortcuts;
	local UIPersonnel_SquadBarracks kPersonnelList;

    HQPres = `HQPRES;

    // Set the squad manager game state as not needing attention.
    SetSquadMgrNeedsAttention(false);

    // Clear the attention label from the submenu item.
    ShortCuts = HQPres.m_kAvengerHUD.Shortcuts;
    Shortcuts.FindSubMenu(eUIAvengerShortcutCat_Barracks, nmSquadManagementSubMenu, SubMenu);
    SubMenu.Message.Label = LabelBarracks_SquadManagement;
    Shortcuts.UpdateSubMenu(eUIAvengerShortcutCat_Barracks, SubMenu);

	// KDM : If the 'Squad Management' Avenger button is clicked and neither the Squad Management screen,
	// nor the controller-capable Squad Management screen is on the screen stack, then push the Squad
	// Management screen onto the stack.
	if (HQPres.ScreenStack.IsNotInStack(class'UIPersonnel_SquadBarracks') &&
		!class'Helpers_LW'.static.ControllerCapableSquadBarracksIsOnStack())
	{
		kPersonnelList = HQPres.Spawn(class'UIPersonnel_SquadBarracks', HQPres);
		kPersonnelList.onSelectedDelegate = OnPersonnelSelected;
		HQPres.ScreenStack.Push(kPersonnelList);
	}
}

simulated function OnPersonnelSelected(StateObjectReference selectedUnitRef)
{
	//add any logic here for selecting someone in the squad barracks
}

function SetSquadMgrNeedsAttention(bool Enable)
{
    local XComGameState NewGameState;
    local XComGameState_FacilityXCom BarracksFacility;
    local XComGameState_LWSquadManager NewManager;
    
    if (Enable != NeedsAttention())
    {
        // Set the rebel outpost manager as needing attention (or not)
        NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Set squad manager needs attention");
        NewManager = XComGameState_LWSquadManager(NewGameState.CreateStateObject(class'XComGameState_LWSquadManager', self.ObjectID));
        NewGameState.AddStateObject(NewManager);
        if (Enable)
        {
            NewManager.SetNeedsAttention();
        }
        else
        {
            NewManager.ClearNeedsAttention();
        }

        // And update the CIC state to also require attention if necessary.
        // We don't need to clear it as clearing happens automatically when the 
        // facility is selected.
        BarracksFacility = `XCOMHQ.GetFacilityByName('Hangar');
        if (Enable && !BarracksFacility.NeedsAttention())
        {
            BarracksFacility = XComGameState_FacilityXCom(NewGameState.CreateStateObject(class'XComGameState_FacilityXCom', BarracksFacility.ObjectID));
            BarracksFacility.TriggerNeedsAttention();
            NewGameState.AddStateObject(BarracksFacility);
        }

        `XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
    }
}

function bool NeedsAttention()
{
    return bNeedsAttention;
}

function SetNeedsAttention()
{
    bNeedsAttention = true;
}

function ClearNeedsAttention()
{
    bNeedsAttention = false;
}

function int NumSquadsOnAnyMission()
{
	local XComGameState_LWPersistentSquad Squad;
	local int idx;
	local int NumMissions;

	for (idx = 0; idx < Squads.Length; idx++)
	{
		Squad = GetSquad(idx);
		if (Squad.bOnMission && Squad.CurrentMission.ObjectID > 0)
			NumMissions++;
	}
	return NumMissions;
}

//gets the squad assigned to a given mission -- may be none if mission is not being pursued
function XComGameState_LWPersistentSquad GetSquadOnMission(StateObjectReference MissionRef)
{
	local XComGameState_LWPersistentSquad Squad;
	local int idx;
	local XComGameStateHistory History;

	if(MissionRef.ObjectID == 0) return none;

	History = `XCOMHISTORY;
	for(idx = 0; idx < Squads.Length; idx++)
	{
		Squad = XComGameState_LWPersistentSquad(History.GetGameStateForObjectID(Squads[idx].ObjectID));
		if(Squad != none && Squad.CurrentMission.ObjectID == MissionRef.ObjectID)
			return Squad;
	}
	return none;
}

function StateObjectReference GetBestSquad()
{
	local array<XComGameState_LWPersistentSquad> PossibleSquads;
	local XComGameState_LWPersistentSquad Squad;
	local int idx;
	local StateObjectReference NullRef;

	for (idx = 0; idx < Squads.Length; idx++)
	{
		Squad = GetSquad(idx);
		if (!Squad.bOnMission && Squad.CurrentMission.ObjectID == 0)
		{
			PossibleSquads.AddItem(Squad);
		} 
	}

	if (PossibleSquads.Length > 0)
		return PossibleSquads[`SYNC_RAND(PossibleSquads.Length)].GetReference();
	else
		return NullRef;
}

function XComGameState_LWPersistentSquad GetSquad(int idx)
{
	if(idx >=0 && idx < Squads.Length)
	{
		return XComGameState_LWPersistentSquad(`XCOMHISTORY.GetGameStateForObjectID(Squads[idx].ObjectID));
	}
	return none;
} 

function XComGameState_LWPersistentSquad GetSquadByName(string SquadName)
{
	local XComGameState_LWPersistentSquad Squad;
	local int idx;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;
	for(idx = 0; idx < Squads.Length; idx++)
	{
		Squad = XComGameState_LWPersistentSquad(History.GetGameStateForObjectID(Squads[idx].ObjectID));
		if(Squad.sSquadName == SquadName)
			return Squad;
	}
	return none;
}

// Return list of references to all soldiers assigned to any squad
function array<StateObjectReference> GetAssignedSoldiers()
{
	local array<StateObjectReference> UnitRefs;
	local XComGameState_LWPersistentSquad Squad;
	local int SquadIdx, UnitIdx;

	for(SquadIdx = 0; SquadIdx < Squads.Length; SquadIdx++)
	{
		Squad = GetSquad(SquadIdx);
		for(UnitIdx = 0; UnitIdx < Squad.SquadSoldiers.Length; UnitIdx++)
		{
			UnitRefs.AddItem(Squad.SquadSoldiers[UnitIdx]);
		}
		for(UnitIdx = 0; UnitIdx < Squad.SquadSoldiersOnMission.Length; UnitIdx++)
		{
			if (UnitRefs.Find('ObjectID', Squad.SquadSoldiersOnMission[UnitIdx].ObjectID) == -1)
				UnitRefs.AddItem(Squad.SquadSoldiersOnMission[UnitIdx]);
		}
	}
	return UnitRefs;
}

// Return list of references to all soldier NOT assigned to any squad
function array<StateObjectReference> GetUnassignedSoldiers()
{
	local XComGameState_HeadquartersXCom HQState;
	local array<StateObjectReference> AssignedRefs, UnassignedRefs;
	local array<XComGameState_Unit> Soldiers;
	local XComGameState_Unit Soldier;

	HQState = `XCOMHQ;
	Soldiers = HQState.GetSoldiers();
	AssignedRefs = GetAssignedSoldiers();
	foreach Soldiers(Soldier)
	{
		if(AssignedRefs.Find('ObjectID', Soldier.ObjectID) == -1)
		{
			UnassignedRefs.AddItem(Soldier.GetReference());
		}
	}
	return UnassignedRefs;
}

function bool UnitIsInAnySquad(StateObjectReference UnitRef, optional out XComGameState_LWPersistentSquad SquadState)
{
	local int idx;

	for(idx = 0; idx < Squads.Length; idx++)
	{
		SquadState = GetSquad(idx);
		if(SquadState.UnitIsInSquad(UnitRef))
			return true;
	}
	SquadState = none;
	return false;
}

function bool UnitIsOnMission(StateObjectReference UnitRef, optional out XComGameState_LWPersistentSquad SquadState)
{
	local int idx;

	for(idx = 0; idx < Squads.Length; idx++)
	{
		SquadState = GetSquad(idx);
		if(SquadState.UnitIsInSquadOnMission(UnitRef))
			return true;
	}
	SquadState = none;
	return false;
}

function RemoveSquad_Internal(int idx, XComGameState NewGameState)
{
	local XComGameState_LWSquadManager UpdatedSquadMgr;
	local XComGameState_LWPersistentSquad SquadState;

	UpdatedSquadMgr = XComGameState_LWSquadManager(NewGameState.CreateStateObject(Class, ObjectID));
	NewGameState.AddStateObject(UpdatedSquadMgr);
	if(idx >= 0 && idx < UpdatedSquadMgr.Squads.Length )
	{
		UpdatedSquadMgr.Squads.Remove(idx, 1);
	}

	SquadState = GetSquad(idx);
	NewGameState.RemoveStateObject(SquadState.ObjectID);
}

function RemoveSquad(int idx)
{
	local XComGameState NewGameState;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Removing Squad");
	RemoveSquad_Internal(idx, NewGameState);
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
}

function RemoveSquadByRef(StateObjectReference SquadRef)
{
	local int idx;

	idx = Squads.Find('ObjectID', SquadRef.ObjectID);
	if(idx != -1)
		RemoveSquad(idx);
}

function XComGameState_LWPersistentSquad AddSquad(optional array<StateObjectReference> Soldiers, optional StateObjectReference MissionRef, optional string SquadName="", optional bool Temp = true, optional float Infiltration=0)
{
	local XComGameState NewGameState;
	local XComGameState_LWPersistentSquad NewSquad;
	local XComGameState_LWSquadManager UpdatedSquadMgr;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Adding new preformed squad");
	NewSquad = XComGameState_LWPersistentSquad(NewGameState.CreateStateObject(class'XComGameState_LWPersistentSquad'));
	UpdatedSquadMgr = XComGameState_LWSquadManager(NewGameState.CreateStateObject(Class, ObjectID));

	NewSquad.InitSquad(SquadName, Temp);
	UpdatedSquadMgr.Squads.AddItem(NewSquad.GetReference());

	if(MissionRef.ObjectID > 0)
		NewSquad.SquadSoldiersOnMission = Soldiers;
	else
		NewSquad.SquadSoldiers = Soldiers;

	NewSquad.InitInfiltration(NewGameState, MissionRef, Infiltration);
	NewSquad.SetOnMissionSquadSoldierStatus(NewGameState);

	NewGameState.AddStateObject(NewSquad);
	NewGameState.AddStateObject(UpdatedSquadMgr);
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

	return NewSquad;
}

static function bool IsValidInfiltrationMission(StateObjectReference MissionRef)
{
	local GeneratedMissionData MissionData;

	MissionData = `XCOMHQ.GetGeneratedMissionData(MissionRef.ObjectID);

	return (default.NonInfiltrationMissions.Find(MissionData.Mission.MissionName) == -1);
}


//creates an empty squad at the given position with the given name
function XComGameState_LWPersistentSquad CreateEmptySquad(optional int idx = -1, optional string SquadName = "", optional XComGameState NewGameState, optional bool bTemporary)
{
	//local XComGameStateHistory History;
	//local XComGameState NewGameState;
	local XComGameState_LWPersistentSquad NewSquad;
	local XComGameState_LWSquadManager UpdatedSquadMgr;
	local bool bNeedsUpdate;

	//History = `XCOMHISTORY;
	bNeedsUpdate = NewGameState == none;
	if (bNeedsUpdate)
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Adding new empty squad");

	NewSquad = XComGameState_LWPersistentSquad(NewGameState.CreateStateObject(class'XComGameState_LWPersistentSquad'));
	UpdatedSquadMgr = XComGameState_LWSquadManager(NewGameState.CreateStateObject(Class, ObjectID));

	NewSquad.InitSquad(SquadName, bTemporary);
	if(idx <= 0 || idx >= Squads.Length)
		UpdatedSquadMgr.Squads.AddItem(NewSquad.GetReference());
	else
		UpdatedSquadMgr.Squads.InsertItem(idx, NewSquad.GetReference());

	NewGameState.AddStateObject(NewSquad);
	NewGameState.AddStateObject(UpdatedSquadMgr);
	if (bNeedsUpdate)
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

	return NewSquad;
}

function UpdateSquadPostMission(optional StateObjectReference MissionRef, optional bool bCompletedMission)
{
	//local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_LWPersistentSquad SquadState, UpdatedSquadState;
	local XComGameState UpdateState;
	local XComGameState_LWSquadManager UpdatedSquadMgr;
	local StateObjectReference NullRef;

	//History = `XCOMHISTORY;
	if (MissionRef.ObjectID == 0)
	{
		XComHQ = `XCOMHQ;
		MissionRef = XComHQ.MissionRef;
	}

	SquadState = GetSquadOnMission(MissionRef);
	if(SquadState == none)
	{
		`REDSCREEN("SquadManager : UpdateSquadPostMission called with no squad on mission");
		return;
	}
	UpdateState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Post Mission Persistent Squad Cleanup");

	UpdatedSquadMgr = XComGameState_LWSquadManager(UpdateState.CreateStateObject(Class, ObjectID));
	UpdateState.AddStateObject(UpdatedSquadMgr);

	UpdatedSquadState = XComGameState_LWPersistentSquad(UpdateState.CreateStateObject(SquadState.Class, SquadState.ObjectID));
	UpdateState.AddStateObject(UpdatedSquadState);

	if (bCompletedMission)
		UpdatedSquadState.iNumMissions += 1;

	UpdatedSquadMgr.LaunchingMissionSquad = NullRef;
	UpdatedSquadState.PostMissionRevertSoldierStatus(UpdateState, UpdatedSquadMgr);
	UpdatedSquadState.ClearMission();
	`XCOMGAME.GameRuleset.SubmitGameState(UpdateState);

	if(SquadState.bTemporary)
	{
		RemoveSquadByRef(SquadState.GetReference());
	}
}


//--------------- EVENT HANDLING ------------------

function InitSquadManagerListeners()
{
	local X2EventManager EventMgr;
	local Object ThisObj;

	class'XComGameState_LWToolboxPrototype'.static.SetMaxSquadSize(default.MAX_SQUAD_SIZE);

	ThisObj = self;
	EventMgr = `XEVENTMGR;
	EventMgr.UnregisterFromAllEvents(ThisObj); // clear all old listeners to clear out old stuff before re-registering

	EventMgr.RegisterForEvent(ThisObj, 'OnValidateDeployableSoldiers', ValidateDeployableSoldiersForSquads,,,,true);
	EventMgr.RegisterForEvent(ThisObj, 'OnSoldierListItemUpdateDisabled', SetDisabledSquadListItems,,,,true);  // hook to disable selecting soldiers if they are in another squad
	EventMgr.RegisterForEvent(ThisObj, 'OnUpdateSquadSelectSoldiers', ConfigureSquadOnEnterSquadSelect, ELD_Immediate,,,true); // hook to set initial squad/soldiers on entering squad select
	EventMgr.RegisterForEvent(ThisObj, 'OnDismissSoldier', DismissSoldierFromSquad, ELD_Immediate,,,true); // allow clearing of units from existing squads when dismissed

}

function EventListenerReturn ValidateDeployableSoldiersForSquads(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local int idx;
	local XComLWTuple DeployableSoldiers;
	local UISquadSelect SquadSelect;
	local XComGameState_Unit UnitState;
	local XComGameState_LWPersistentSquad CurrentSquad, TestUnitSquad;

	DeployableSoldiers = XComLWTuple(EventData);
	if(DeployableSoldiers == none)
	{
		`REDSCREEN("Validate Deployable Soldiers event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}
	SquadSelect = UISquadSelect(EventSource);
	if(SquadSelect == none)
	{
		`REDSCREEN("Validate Deployable Soldiers event triggered with invalid source data.");
		return ELR_NoInterrupt;
	}

	if(DeployableSoldiers.Id != 'DeployableSoldiers')
		return ELR_NoInterrupt;

	if(LaunchingMissionSquad.ObjectID > 0)
	{
		CurrentSquad = XComGameState_LWPersistentSquad(`XCOMHISTORY.GetGameStateForObjectID(LaunchingMissionSquad.ObjectID));
	}
	for(idx = DeployableSoldiers.Data.Length - 1; idx >= 0; idx--)
	{
		if(DeployableSoldiers.Data[idx].kind == XComLWTVObject)
		{
			UnitState = XComGameState_Unit(DeployableSoldiers.Data[idx].o);
			if(UnitState != none)
			{
				//disallow if actively on a mission
				if(class'LWDLCHelpers'.static.IsUnitOnMission(UnitState))
				{
					DeployableSoldiers.Data.Remove(idx, 1);
				}
				//disallow if unit is in a different squad
				if (UnitIsInAnySquad(UnitState.GetReference(), TestUnitSquad))
				{
					if (TestUnitSquad != none && TestUnitSquad.ObjectID != CurrentSquad.ObjectID)
					{
						DeployableSoldiers.Data.Remove(idx, 1);
					}
				}
			}
		}
	}
	return ELR_NoInterrupt;
}

function EventListenerReturn SetDisabledSquadListItems(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local UIPersonnel_ListItem ListItem;
	local XComGameState_LWPersistentSquad Squad;
    local XComGameState_Unit UnitState;
	local bool								bInSquadEdit;

	//only do this for squadselect
	if(GetSquadSelect() == none)
		return ELR_NoInterrupt;

	ListItem = UIPersonnel_ListItem(EventData);
	if(ListItem == none)
	{
		`REDSCREEN("Set Disabled Squad List Items event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}

	bInSquadEdit = `SCREENSTACK.IsInStack(class'UIPersonnel_SquadBarracks');

	if(ListItem.UnitRef.ObjectID > 0)
	{
		if (LaunchingMissionSquad.ObjectID > 0)
			Squad = XComGameState_LWPersistentSquad(`XCOMHISTORY.GetGameStateForObjectID(LaunchingMissionSquad.ObjectID));

        UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ListItem.UnitRef.ObjectID));
		if(bInSquadEdit && UnitIsInAnySquad(ListItem.UnitRef) && (Squad == none || !Squad.UnitIsInSquad(ListItem.UnitRef)))
		{
			ListItem.SetDisabled(true); // can now select soldiers from other squads, but will generate pop-up warning and remove them
		}
        else 
		if (class'LWDLCHelpers'.static.IsUnitOnMission(UnitState))
        {
		    ListItem.SetDisabled(true);
		}
            
	}
	return ELR_NoInterrupt;
}

//selects a squad that matches a persistent squad 
function EventListenerReturn ConfigureSquadOnEnterSquadSelect(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComGameStateHistory				History;
	local XComGameState_HeadquartersXCom	XComHQ, UpdatedXComHQ;
	local UISquadSelect						SquadSelect;
	local XComGameState_LWSquadManager		UpdatedSquadMgr;
	local StateObjectReference				SquadRef;
	local XComGameState_LWPersistentSquad	SquadState;
	local bool								bInSquadEdit;
	local XComGameState_MissionSite			MissionSite;
	local GeneratedMissionData				MissionData;
	local int								MaxSoldiersInSquad;

	`LWTRACE("ConfigureSquadOnEnterSquadSelect : Starting listener.");
	XComHQ = XComGameState_HeadquartersXCom(EventData);
	if(XComHQ == none)
	{
		`REDSCREEN("OnUpdateSquadSelectSoldiers event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}
	`LWTRACE("ConfigureSquadOnEnterSquadSelect : Parsed XComHQ.");

	SquadSelect = GetSquadSelect();
	if(SquadSelect == none)
	{
		`REDSCREEN("ConfigureSquadOnEnterSquadSelect event triggered with UISquadSelect not in screenstack.");
		return ELR_NoInterrupt;
	}
	`LWTRACE("ConfigureSquadOnEnterSquadSelect : RetrievedSquadSelect.");

	History = `XCOMHISTORY;

	bInSquadEdit = `SCREENSTACK.IsInStack(class'UIPersonnel_SquadBarracks');
	if (bInSquadEdit)
		return ELR_NoInterrupt;

	MissionSite = XComGameState_MissionSite(History.GetGameStateForObjectID(XComHQ.MissionRef.ObjectID));
	MissionData = MissionSite.GeneratedMission;

	if (LaunchingMissionSquad.ObjectID > 0)
		SquadRef = LaunchingMissionSquad;
	else	
		SquadRef = GetBestSquad();

	UpdatedSquadMgr = XComGameState_LWSquadManager(NewGameState.ModifyStateObject(Class, ObjectID));

	if(SquadRef.ObjectID > 0)
		SquadState = XComGameState_LWPersistentSquad(History.GetGameStateForObjectID(SquadRef.ObjectID));
	else
		SquadState = UpdatedSquadMgr.CreateEmptySquad(,, NewGamestate, true);  // create new, empty, temporary squad

	UpdatedSquadMgr.LaunchingMissionSquad = SquadState.GetReference();

	UpdatedXComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(XComHQ.Class, XComHQ.ObjectID));
	UpdatedXComHQ.Squad = SquadState.GetDeployableSoldierRefs(MissionData.Mission.AllowDeployWoundedUnits); 

	MaxSoldiersInSquad = class'Utilities_LW'.static.GetMaxSoldiersAllowedOnMission(MissionSite);
	if (UpdatedXComHQ.Squad.Length > MaxSoldiersInSquad)
		UpdatedXComHQ.Squad.Length = MaxSoldiersInSquad;

	//if (NewGameState.GetNumGameStateObjects() > 0)
		//`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	//else
		//History.CleanupPendingGameState(NewGameState);

	return ELR_NoInterrupt;
}

simulated function UISquadSelect GetSquadSelect()
{
	local UIScreenStack ScreenStack;
	local int Index;
	ScreenStack = `SCREENSTACK;
	for( Index = 0; Index < ScreenStack.Screens.Length;  ++Index)
	{
		if(UISquadSelect(ScreenStack.Screens[Index]) != none )
			return UISquadSelect(ScreenStack.Screens[Index]);
	}
	return none; 
}

function EventListenerReturn DismissSoldierFromSquad(Object EventData, Object EventSource, XComGameState GameState, Name InEventID, Object CallbackData)
{
	local XComGameState_Unit DismissedUnit;
	local UIArmory_MainMenu MainMenu;
	local StateObjectReference DismissedUnitRef;
	local XComGameState_LWPersistentSquad SquadState, UpdatedSquadState;
	local XComGameState NewGameState;
	local int idx;

	DismissedUnit = XComGameState_Unit(EventData);
	if(DismissedUnit == none)
	{
		`REDSCREEN("Dismiss Soldier From Squad listener triggered with invalid event data.");
		return ELR_NoInterrupt;
	}
	MainMenu = UIArmory_MainMenu(EventSource);
	if(MainMenu == none)
	{
		`REDSCREEN("Dismiss Soldier From Squad listener triggered with invalid source data.");
		return ELR_NoInterrupt;
	}

	DismissedUnitRef = DismissedUnit.GetReference();

	for(idx = 0; idx < Squads.Length; idx++)
	{
		SquadState = GetSquad(idx);
		if(SquadState.UnitIsInSquad(DismissedUnitRef))
		{
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Removing Dismissed Soldier from Squad");
			UpdatedSquadState = XComGameState_LWPersistentSquad(NewGameState.CreateStateObject(class'XComGameState_LWPersistentSquad', SquadState.ObjectID));
			NewGameState.AddStateObject(UpdatedSquadState);
			UpdatedSquadState.RemoveSoldier(DismissedUnitRef);
			`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
		}
	}

	return ELR_NoInterrupt;
}