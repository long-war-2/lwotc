//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_Effect_EffectCounter.uc
//  AUTHOR:  John Lumpkin / Amineri (Pavonis Interactive)
//  PURPOSE: This is a component extension for Effect GameStates, counting the number of
//		times an effect is triggered. Can be used to restrict passive abilities to once 
//		per turn.
//---------------------------------------------------------------------------------------

class XComGameState_Effect_EffectCounter extends XComGameState_BaseObject;

`include(LW_PerkPack_Integrated\LW_PerkPack.uci)

var int uses;

function XComGameState_Effect_EffectCounter InitComponent()
{
	uses = 0;
	return self;
}

function XComGameState_Effect GetOwningEffect()
{
	return XComGameState_Effect(`XCOMHISTORY.GetGameStateForObjectID(OwningObjectId));
}

simulated function XComGameState.EventListenerReturn ResetUses(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameState								NewGameState;
	local XComGameState_Effect_EffectCounter		ThisEffect;
	
	`PPTRACE ("Resetting LR Uses 1" @ string (uses));
	if(uses != 0)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Update: Reset Effect Counter");
		ThisEffect=XComGameState_Effect_EffectCounter(NewGameState.CreateStateObject(Class,ObjectID));
		`PPTRACE ("Resetting LR uses 2" @ string (thiseffect.uses));
		ThisEffect.uses = 0;
		NewGameState.AddStateObject(ThisEffect);
		`TACTICALRULES.SubmitGameState(NewGameState);    

	}
	return ELR_NoInterrupt;
}

simulated function XComGameState.EventListenerReturn IncrementUses(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameState								NewGameState;
	local XComGameState_Effect_EffectCounter		ThisEffect;
	
	`PPTRACE ("INCREMENT USES FIRED");
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Update: Increment Effect Counter");
	ThisEffect=XComGameState_Effect_EffectCounter(NewGameState.CreateStateObject(Class,ObjectID));
	ThisEffect.uses += 1;
	`PPTRACE (EventID $ ": Incremented to" @ string (Thiseffect.uses));
	NewGameState.AddStateObject(ThisEffect);
	`TACTICALRULES.SubmitGameState(NewGameState);	
	return ELR_NoInterrupt;
}


