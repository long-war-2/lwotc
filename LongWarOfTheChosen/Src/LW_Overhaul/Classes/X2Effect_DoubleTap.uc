class X2Effect_DoubleTap extends X2Effect_Persistent config (LW_SoldierSkills);

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local Object EffectObj;
	local XComGameState_Unit UnitState;

	//`LOG ("DT Effect added");
	EffectObj = NewEffectState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(NewEffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	`XEVENTMGR.RegisterForEvent(EffectObj, 'DoubleTap', NewEffectState.TriggerAbilityFlyover, ELD_OnStateSubmitted, , UnitState);
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local XComGameState_Ability					AbilityState;

	AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
	//`LOG ("DT1:" @ AbilityState.GetMyTemplateName());
	if (AbilityState != none)
	{
		//`LOG ("DT2:" @ kAbility.GetMyTemplateName());
		if (kAbility.GetMyTemplateName() == 'DoubleTap2')
		{
			//`LOG ("DT3");
			SourceUnit.ActionPoints.AddItem(class'X2Ability_LW_SharpshooterAbilitySet'.default.DoubleTapActionPoint);
			SourceUnit.ActionPoints.AddItem(class'X2Ability_LW_SharpshooterAbilitySet'.default.DoubleTapActionPoint);
			`XEVENTMGR.TriggerEvent('DoubleTap', AbilityState, SourceUnit, NewGameState);
		}
	}
	return false;
}
