class X2EventListener_Soldiers extends X2EventListener;

var localized string OnLiaisonDuty;
var localized string OnInfiltrationMission;
var localized string UnitAlreadyInSquad;
var localized string UnitInSquad;
var localized string RankTooLow;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateUtilityItemListeners());
	Templates.AddItem(CreateStatusListeners());

	return Templates;
}

////////////////
/// Strategy ///
////////////////

static function CHEventListenerTemplate CreateUtilityItemListeners()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'SoldierUtilityItems');
	Template.AddCHEvent('OverrideItemUnequipBehavior', OnOverrideItemUnequipBehavior, ELD_Immediate);
	Template.AddCHEvent('OverrideItemMinEquipped', OnOverrideItemMinEquipped, ELD_Immediate);
	Template.RegisterInStrategy = true;

	return Template;
}

static function CHEventListenerTemplate CreateStatusListeners()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'SoldierStatus');
	Template.AddCHEvent('CustomizeStatusStringsSeparate', OnCustomizeStatusStringsSeparate, ELD_Immediate);
	Template.RegisterInStrategy = true;

	return Template;
}

// allows overriding of unequipping items, allowing even infinite utility slot items to be unequipped
static protected function EventListenerReturn OnOverrideItemUnequipBehavior(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple			OverrideTuple;
	local XComGameState_Item	ItemState;
	local X2EquipmentTemplate	EquipmentTemplate;

	`LWTRACE("OverrideItemUnequipBehavior : Starting listener.");
	OverrideTuple = XComLWTuple(EventData);
	if(OverrideTuple == none)
	{
		`REDSCREEN("OverrideItemUnequipBehavior event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}
	`LWTRACE("OverrideItemUnequipBehavior : Parsed XComLWTuple.");

	ItemState = XComGameState_Item(EventSource);
	if(ItemState == none)
	{
		`REDSCREEN("OverrideItemUnequipBehavior event triggered with invalid source data.");
		return ELR_NoInterrupt;
	}
	`LWTRACE("OverrideItemUnequipBehavior : EventSource valid.");

	if(OverrideTuple.Id != 'OverrideItemUnequipBehavior')
		return ELR_NoInterrupt;

	//check if item is a utility slot item
	EquipmentTemplate = X2EquipmentTemplate(ItemState.GetMyTemplate());
	if(EquipmentTemplate != none)
	{
		if(EquipmentTemplate.InventorySlot == eInvSlot_Utility)
		{
			OverrideTuple.Data[0].i = eCHSUB_AllowEmpty;  // item can be unequipped
		}
	}

	return ELR_NoInterrupt;
}

// Allows for completely empty utility slots for soldiers
static protected function EventListenerReturn OnOverrideItemMinEquipped(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple			OverrideTuple;
	local XComGameState_Unit	UnitState;
	local X2EquipmentTemplate	EquipmentTemplate;

	`LWTRACE("OverrideItemMinEquipped : Starting listener.");
	OverrideTuple = XComLWTuple(EventData);
	if (OverrideTuple == none)
	{
		`REDSCREEN("OverrideItemMinEquipped event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}
	`LWTRACE("OverrideItemMinEquipped : Parsed XComLWTuple.");

	UnitState = XComGameState_Unit(EventSource);
	if (UnitState == none)
	{
		`REDSCREEN("OverrideItemMinEquipped event triggered with invalid source data.");
		return ELR_NoInterrupt;
	}
	`LWTRACE("OverrideItemMinEquipped : EventSource valid.");

	if (OverrideTuple.Id != 'OverrideItemMinEquipped')
	{
		return ELR_NoInterrupt;
	}

	switch (OverrideTuple.Data[1].i)
	{
		case eInvSlot_Utility:
		case eInvSlot_GrenadePocket:
			OverrideTuple.Data[0].i = 0;
			break;
			
		default:
			break;
	}

	return ELR_NoInterrupt;
}

// Sets the status string for liaisons and soldiers on missions.
static protected function EventListenerReturn OnCustomizeStatusStringsSeparate(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple				OverrideTuple;
	local XComGameState_Unit		UnitState;
    local XComGameState_WorldRegion	WorldRegion;
	local XComGameState_LWPersistentSquad Squad;
	local XComGameState_LWSquadManager SquadMgr;

	OverrideTuple = XComLWTuple(EventData);
	if (OverrideTuple == none)
	{
		`REDSCREEN("CustomizeStatusStringsSeparate event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}

	UnitState = XComGameState_Unit(EventSource);
	if (UnitState == none)
	{
		`REDSCREEN("CustomizeStatusStringsSeparate event triggered with invalid source data.");
		return ELR_NoInterrupt;
	}

	if (OverrideTuple.Id != 'CustomizeStatusStringsSeparate')
	{
		return ELR_NoInterrupt;
	}

	
	if (class'LWDLCHelpers'.static.IsUnitOnMission(UnitState))
	{
		// Check if the unit is a liaison or a soldier on a mission.
		if (`LWOUTPOSTMGR.IsUnitAHavenLiaison(UnitState.GetReference()))
		{
			WorldRegion = `LWOUTPOSTMGR.GetRegionForLiaison(UnitState.GetReference());
			SetTupleData(OverrideTuple, default.OnLiaisonDuty @ "-" @ WorldRegion.GetDisplayName(), "", 0);
		}
		else if (`LWSQUADMGR.UnitIsOnMission(UnitState.GetReference()))
		{
			SetTupleData(OverrideTuple, default.OnInfiltrationMission, "", 0);
		}
	}
	else if (GetScreenOrChild('UIPersonnel_SquadBarracks') == none)
	{
		SquadMgr = `LWSQUADMGR;
		if (`XCOMHQ.IsUnitInSquad(UnitState.GetReference()) && GetScreenOrChild('UISquadSelect') != none)
		{
			SetTupleData(OverrideTuple, class'UIUtilities_Strategy'.default.m_strOnMissionStatus, "", 0);
			// TextState = eUIState_Highlight;
		}
		else if (SquadMgr != none && SquadMgr.UnitIsInAnySquad(UnitState.GetReference(), Squad))
		{
			if (SquadMgr.LaunchingMissionSquad.ObjectID != Squad.ObjectID)
			{
				if (UnitState.GetStatus() != eStatus_Healing && UnitState.GetStatus() != eStatus_Training)
				{
					if (GetScreenOrChild('UISquadSelect') != none)
					{
						SetTupleData(OverrideTuple, default.UnitAlreadyInSquad, "", 0);
						// TextState = eUIState_Warning;
					}
					else if (GetScreenOrChild('UIPersonnel_Liaison') != none)
					{
						SetTupleData(OverrideTuple, default.UnitInSquad, "", 0);
						// TextState = eUIState_Warning;
					}
				}
			}
		}
		else if (UnitState.GetRank() < class'XComGameState_LWOutpost'.default.REQUIRED_RANK_FOR_LIAISON_DUTY)
		{
			if (GetScreenOrChild('UIPersonnel_Liaison') != none)
			{
				SetTupleData(OverrideTuple, default.RankTooLow, "", 0);
				// TextState = eUIState_Bad;
			}
		}
	}

	return ELR_NoInterrupt;
}

static private function UIScreen GetScreenOrChild(name ScreenType)
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

static private function SetTupleData(XComLWTuple Tuple, string Status, string TimeLabel, int TimeValue)
{
	Tuple.Data[0].b = true;
	Tuple.Data[1].s = Status;
	Tuple.Data[2].s = TimeLabel;
	Tuple.Data[3].i = TimeValue;
}