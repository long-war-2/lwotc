//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_AlienCustomizationManager.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: This singleton object manages alien Customization settings
//           LWOTC: This job is now done by X2EventListener_AlienCustomization. Only
//           keeping this because it will be in the save files of existing campaigns
//           and profile.bin.
//---------------------------------------------------------------------------------------
class XComGameState_AlienCustomizationManager extends XComGameState_BaseObject config(LW_AlienVariations);

static function XComGameState_AlienCustomizationManager GetAlienCustomizationManager(optional bool AllowNULL = false)
{
	// Kept for backwards compatibility only
	return none;
}

static function XComGameState_AlienCustomizationManager CreateAlienCustomizationManager(optional XComGameState StartState)
{
	// Kept for backwards compatibility only
	return none;
}

simulated function RegisterListeners()
{
	// Kept for backwards compatibility only
}

// loops over alien units and tweaks Customization
function EventListenerReturn OnUnitBeginPlay(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	// Implementation moved to X2EventListener_AlienCustomization
	return ELR_NoInterrupt;
}
