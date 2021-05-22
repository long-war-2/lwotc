//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_ImpersonalEdge.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: On activation reduces shadow's cooldown by 1
//           
//---------------------------------------------------------------------------------------
class X2Effect_ImpersonalEdge extends X2Effect;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState;
	local XComGameState_Ability AbilityState;
	local int i;

	History = `XCOMHISTORY;
	UnitState = XComGameState_Unit(kNewTargetState);
	for (i = 0; i < UnitState.Abilities.Length; ++i)
	{
		AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(UnitState.Abilities[i].ObjectID));
		if (AbilityState != none && AbilityState.iCooldown > 0 && AbilityState.GetMyTemplateName() == 'Shadow')
		{
			AbilityState = XComGameState_Ability(NewGameState.ModifyStateObject(AbilityState.Class, AbilityState.ObjectID));
			AbilityState.iCooldown--;
		}
	}
}