class X2Effect_ShieldWall extends X2Effect_GenerateCover;

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	//	Update unit's cover to low only if they are actually affected by the effect that grants low cover.
	if (UnitState != None && UnitState.IsUnitAffectedByEffectName('BallisticShield'))
	{
		UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(UnitState.Class, UnitState.ObjectID));
		UnitState.bGeneratesCover = true;
		UnitState.CoverForceFlag = CoverForce_Low;

		`XEVENTMGR.TriggerEvent('UnitCoverUpdated', UnitState, UnitState, NewGameState);
	}

	//super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);
}