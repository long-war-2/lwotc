//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_DLC2_HideSpecialTurnOverlay.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Replacement for DLC2 TurnStartRemoveActionPoints to preserve removal of overlay
//---------------------------------------------------------------------------------------

class X2Effect_DLC2_HideSpecialTurnOverlay extends X2Effect_Persistent;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager EventMgr;
    local Object EffectObj;
    local XComGameState_Unit UnitState;

    EventMgr = `XEVENTMGR;
    EffectObj = EffectGameState;
    UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
    EventMgr.RegisterForEvent(EffectObj, 'ExhaustedActionPoints', ExhaustedActionCheck, ELD_OnVisualizationBlockCompleted,, UnitState);
    EventMgr.RegisterForEvent(EffectObj, 'NoActionPointsAvailable', ExhaustedActionCheck, ELD_OnVisualizationBlockCompleted,, UnitState);
    EventMgr.RegisterForEvent(EffectObj, 'UnitDied', ExhaustedActionCheck, ELD_OnVisualizationBlockCompleted,, UnitState);
}

static function EventListenerReturn ExhaustedActionCheck(
		Object EventData,
		Object EventSource,
		XComGameState GameState,
		name EventID,
		Object CallbackData)
{
    `PRES.UIHideSpecialTurnOverlay();
    return ELR_NoInterrupt;
}
