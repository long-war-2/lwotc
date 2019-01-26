//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_Effect_SteadyWeaponListener.uc
//  AUTHOR:  John Lumpkin / Pavonis Interactive
//  PURPOSE: This is a component extension for Effect GameStates, which listens for events
//		that remove the SteadyWeapon bonus prematurely
//---------------------------------------------------------------------------------------

class XComGameState_Effect_SteadyWeaponListener extends XComGameState_Effect;

function XComGameState_Effect_SteadyWeaponListener InitComponent()
{	
	return self;
}

function XComGameState_Effect GetOwningEffect()
{
	return XComGameState_Effect(`XCOMHISTORY.GetGameStateForObjectID(OwningObjectId));
}

function XComGameState.EventListenerReturn SteadyWeaponActionListener(Object EventData, Object EventSource, XComGameState GameState, name EventID, Object CallbackData)
{
    local XComGameState_Ability AbilityState;
    local XComGameStateContext_EffectRemoved RemoveContext;
    local XComGameState NewGameState;
	local X2AbilityCost Cost;
	local bool CostlyAction;

    AbilityState = XComGameState_Ability(EventData);
	if (AbilityState != none)
	{
		foreach AbilityState.GetMyTemplate().AbilityCosts(Cost)
		{
			CostlyAction = false;
			if (Cost.IsA('X2AbilityCost_ActionPoints') && !X2AbilityCost_ActionPoints(Cost).bFreeCost)
				CostlyAction = true;
			if (Cost.IsA('X2AbilityCost_ReserveActionPoints') && !X2AbilityCost_ReserveActionPoints(Cost).bFreeCost)
				CostlyAction = true;
			if (Cost.IsA('X2AbilityCost_HeavyWeaponActionPoints') && !X2AbilityCost_HeavyWeaponActionPoints(Cost).bFreeCost)
				CostlyAction = true;
			if (Cost.IsA('X2AbilityCost_QuickdrawActionPoints') && !X2AbilityCost_QuickdrawActionPoints(Cost).bFreeCost)
				CostlyAction = true;
			if (AbilityState.GetMyTemplateName() == 'CloseCombatSpecialistAttack')
				CostlyAction = true;
			if (AbilityState.GetMyTemplateName() == 'BladestormAttack')
				CostlyAction = true;
			if (AbilityState.GetMyTemplateName() == 'LightningHands')
				CostlyAction = true;
			if(CostlyAction) 
			{
				if (AbilityState.GetMyTemplateName() == 'SteadyWeapon' || AbilityState.GetMyTemplateName() == 'Stock_LW_Bsc_Ability' ||  AbilityState.GetMyTemplateName() == 'Stock_LW_Adv_Ability' ||  AbilityState.GetMyTemplateName() == 'Stock_LW_Sup_Ability')
					return ELR_NoInterrupt;

				if (!GetOwningEffect().bRemoved)
				{								
					RemoveContext = class'XComGameStateContext_EffectRemoved'.static.CreateEffectRemovedContext(self);
					NewGameState = `XCOMHISTORY.CreateNewGameState(true, RemoveContext);
					GetOwningEffect().RemoveEffect(NewGameState, GameState);
					`TACTICALRULES.SubmitGameState(NewGameState);
					return ELR_NoInterrupt;
				}
			}
		}
	}
	return ELR_NoInterrupt;
}

function XComGameState.EventListenerReturn SteadyWeaponWoundListener(Object EventData, Object EventSource, XComGameState GameState, name EventID, Object CallbackData)
{
	local XComGameState_Ability AbilityState;
	local XComGameStateContext_EffectRemoved RemoveContext;
	local XComGameState NewGameState;

	AbilityState = XComGameState_Ability(EventData);
	if (AbilityState != none)
	{
		if (!GetOwningEffect().bRemoved)
		{
			RemoveContext = class'XComGameStateContext_EffectRemoved'.static.CreateEffectRemovedContext(self);
			NewGameState = `XCOMHISTORY.CreateNewGameState(true, RemoveContext);
			GetOwningEffect().RemoveEffect(NewGameState, GameState);
			`TACTICALRULES.SubmitGameState(NewGameState);
			return ELR_NoInterrupt;

		}
	}
	return ELR_NoInterrupt;
}