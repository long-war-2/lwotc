//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_Effect_AirController.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//	PURPOSE: Extended game state information for Air Controller ability
//---------------------------------------------------------------------------------------
class XComGameState_Effect_AirController extends XComGameState_Effect;

// WOTC TODO: Check why this exists as well as the one in XComGameState_LWListenerManager
static function EventListenerReturn OnPlacedDelayedEvacZone(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComLWTuple EvacDelayTuple;

	EvacDelayTuple = XComLWTuple(EventData);
	if(EvacDelayTuple == none)
		return ELR_NoInterrupt;

	if(EvacDelayTuple.Id != 'DelayedEvacTurns')
		return ELR_NoInterrupt;

	if(EvacDelayTuple.Data[0].Kind != XComLWTVInt)
		return ELR_NoInterrupt;

	if(EvacDelayTuple.Data[0].i > 0)
		EvacDelayTuple.Data[0].i -= class'X2Ability_OfficerAbilitySet'.default.AIR_CONTROLLER_EVAC_TURN_REDUCTION;

	return ELR_NoInterrupt;
}