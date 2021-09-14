class X2Effect_NukeSpecialDeath extends X2Effect; //_Persistent;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local Damageable			Target;
	local XComGameState_Unit	TargetUnit;
	local XComGameState_Ability	kAbility;
	
	Target = Damageable(kNewTargetState);
	kAbility = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));

	//`LOG("OnEffectAdded for X2Effect_NukeSpecialDeath to: " @ XComGameState_Unit(kNewTargetState).GetFullName() @ Target != none,, 'IRIROCK');

	//	Apply damage effect only if the target is within Epicenter Radius
	if (Target != none && kAbility != none /*&& class'X2Effect_ApplyNukeEpicenterDamage'.static.IsTargetInRange(ApplyEffectParameters.AbilityInputContext.TargetLocations[0], Target, kAbility.GetAbilityRadius())*/)
	{
		//	If target is dead after Epicenter Damage goes through, mark it for disintegration
		TargetUnit = XComGameState_Unit(kNewTargetState);
		if (TargetUnit != none && TargetUnit.IsDead())
		{
			//`LOG("Unit is dead, marking for disintegration",, 'IRIROCK');
			TargetUnit.bSpecialDeathOccured = true;
			TargetUnit.SetUnitFloatValue('IRI_NukeEpicenterKill_Value', 1, eCleanup_BeginTactical);
		}
	}
}
/*
static function bool AllowOverrideActionDeath(VisualizationActionMetadata ActionMetadata, XComGameStateContext Context)
{
	local XComGameState_Unit	TargetUnit;

	TargetUnit = XComGameState_Unit(ActionMetadata.StateObject_NewState);

	if(TargetUnit != none && TargetUnit.bSpecialDeathOccured)
	{
		return true;
	}
	else
	{
		return false;
	}
}*/
/*
simulated function X2Action AddX2ActionsForVisualization_Death(out VisualizationActionMetadata ActionMetadata, XComGameStateContext Context)
{
	local X2Action				AddAction;
	local XComGameState_Unit	TargetUnit;

	TargetUnit = XComGameState_Unit(ActionMetadata.StateObject_NewState);

	if(TargetUnit != none && TargetUnit.bSpecialDeathOccured)
	{
		AddAction = class'X2Action'.static.CreateVisualizationActionClass(class'X2Action_NukeSpecialDeath', Context, ActionMetadata.VisualizeActor );
		class'X2Action'.static.AddActionToVisualizationTree(AddAction, ActionMetadata, Context, false, ActionMetadata.LastActionAdded);
	}

	return AddAction;
}*/

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, name EffectApplyResult)
{
	local XComGameState_Unit	TargetUnit;
	local UnitValue				UV;

	TargetUnit = XComGameState_Unit(ActionMetadata.StateObject_NewState);

	if(TargetUnit != none && TargetUnit.bSpecialDeathOccured && EffectApplyResult == 'AA_Success' && TargetUnit.GetUnitValue('IRI_NukeEpicenterKill_Value', UV))
	{
		//`LOG("Applying special death effect to unit: " @ TargetUnit.GetFullName(),, 'IRIVIZ');
		class'X2Action_RemoveUnit'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded);
	}
}