//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_Effect_AirController.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Extended game state information for Air Controller ability
//---------------------------------------------------------------------------------------
class XComGameState_Effect_AirController extends XComGameState_Effect;

// Adjust the number of turns it takes for the evac zone to appear
// once it's placed
static function EventListenerReturn OnPlacedDelayedEvacZone(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local LWTuple EvacDelayTuple;

	EvacDelayTuple = LWTuple(EventData);
	if(EvacDelayTuple == none)
		return ELR_NoInterrupt;

	if(EvacDelayTuple.Id != 'DelayedEvacTurns')
		return ELR_NoInterrupt;

	if(EvacDelayTuple.Data[0].Kind != LWTVInt)
		return ELR_NoInterrupt;

	if(EvacDelayTuple.Data[0].i > 0)
		EvacDelayTuple.Data[0].i -= class'X2Ability_OfficerAbilitySet'.default.AIR_CONTROLLER_EVAC_TURN_REDUCTION;

	return ELR_NoInterrupt;
}