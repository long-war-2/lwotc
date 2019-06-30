//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_AirController.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//	PURPOSE: Registers listener for AirController
//---------------------------------------------------------------------------------------
class X2Effect_AirController extends X2Effect_Persistent;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMan;
	local Object EffectObj;

	EventMan = `XEVENTMGR;
	EffectObj = EffectGameState;
	EventMan.RegisterForEvent(EffectObj, 'GetEvacPlacementDelay', XComGameState_Effect_AirController(EffectGameState).OnPlacedDelayedEvacZone, ELD_Immediate);
}

DefaultProperties
{
	DuplicateResponse=eDupe_Ignore 
	GameStateEffectClass=class'XComGameState_Effect_AirController'
	EffectName="AirControllerEffect"
}
