//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_Effect_EffectCounter.uc
//  AUTHOR:  John Lumpkin / Amineri (Pavonis Interactive)
//  PURPOSE: This is a component extension for Effect GameStates, counting the number of
//		times an effect is triggered. Can be used to restrict passive abilities to once 
//		per turn.
//---------------------------------------------------------------------------------------

class XComGameState_Effect_EffectCounter extends XComGameState_Effect;

`include(LW_PerkPack_Integrated\LW_PerkPack.uci)

var int uses;

static function EventListenerReturn ResetUses(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState								NewGameState;
	local XComGameState_Effect_EffectCounter		ThisEffect;

	ThisEffect = XComGameState_Effect_EffectCounter(CallbackData);
	if (ThisEffect == None)
	{
		// `REDSCREEN("Wrong callback data passed to XComGameState_Effect_EffectCounter.ResetUses()");
		return ELR_NoInterrupt;
	}
	
	`PPTRACE ("Resetting EffectCounter Uses 1" @ string (ThisEffect.uses));
	if (ThisEffect.uses != 0)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Update: Reset Effect Counter");
		ThisEffect = XComGameState_Effect_EffectCounter(NewGameState.ModifyStateObject(ThisEffect.Class, ThisEffect.ObjectID));
		`PPTRACE ("Resetting EffectCounter uses 2" @ string (ThisEffect.uses));
		ThisEffect.uses = 0;
		`TACTICALRULES.SubmitGameState(NewGameState);
	}
	return ELR_NoInterrupt;
}

static function EventListenerReturn IncrementUses(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState								NewGameState;
	local XComGameState_Effect_EffectCounter		ThisEffect;
	
	ThisEffect = XComGameState_Effect_EffectCounter(CallbackData);
	if (ThisEffect == None)
	{
		`REDSCREEN("Wrong callback data passed to XComGameState_Effect_EffectCounter.ResetUses()");
		return ELR_NoInterrupt;
	}
	
	`PPTRACE ("INCREMENT USES FIRED");
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Update: Increment Effect Counter");
	ThisEffect = XComGameState_Effect_EffectCounter(NewGameState.ModifyStateObject(ThisEffect.Class, ThisEffect.ObjectID));
	ThisEffect.uses += 1;
	`PPTRACE (EventID $ ": Incremented to" @ string (ThisEffect.uses));
	`TACTICALRULES.SubmitGameState(NewGameState);
	return ELR_NoInterrupt;
}

defaultproperties
{
	bTacticalTransient=true;
}
