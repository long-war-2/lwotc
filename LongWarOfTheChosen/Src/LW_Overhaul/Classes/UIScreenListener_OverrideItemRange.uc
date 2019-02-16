//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_OverrideItemRange.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Uses new XComGame TriggerEvent to override logic to add items to inventory
//---------------------------------------------------------------------------------------

class UIScreenListener_OverrideItemRange extends UIScreenListener config(LW_Overhaul) deprecated;

var bool bCreated;

// DEPRECATED -- TEST ONLY
// actual usage is in various abilities

// This event is triggered after a screen is initialized
//event OnInit(UIScreen Screen)
//{
	//if(!bCreated)
	//{
		//InitListeners();
		//bCreated = true;
	//}
//}

function InitListeners()
{
	local X2EventManager EventMgr;
	local Object ThisObj;

	ThisObj = self;
	EventMgr = `XEVENTMGR;
	EventMgr.RegisterForEvent(ThisObj, 'OnGetItemRange', OnGetItemRange,,,,true);
}

function EventListenerReturn OnGetItemRange(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple				OverrideTuple;
	local XComGameState_Item		Item;
	local int						Range;  // in tiles -- either bonus or override
	local XComGameState_Ability		Ability;
	local bool						bOverride; // if true, replace the range, if false, just add to it

	OverrideTuple = XComLWTuple(EventData);
	if(OverrideTuple == none)
	{
		`REDSCREEN("OverrideGetPCSImage event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}
	//`LOG("OverrideTuple : Parsed XComLWTuple.");

	Item = XComGameState_Item(EventSource);
	if(Item == none)
		return ELR_NoInterrupt;
	//`LOG("OverrideTuple : EventSource valid.");

	if(OverrideTuple.Id != 'GetItemRange')
		return ELR_NoInterrupt;


	bOverride = OverrideTuple.Data[0].b;  // override? (true) or add? (false)
	bOverride = bOverride;
	Range = OverrideTuple.Data[1].i;  // override/bonus range
	Range = Range;
	Ability = XComGameState_Ability(OverrideTuple.Data[2].o);  // optional ability
	Ability = Ability;

	`LOG("OnGetItemRange : working!.");

	return ELR_NoInterrupt;
}

defaultproperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = UITacticalHUD;
}
