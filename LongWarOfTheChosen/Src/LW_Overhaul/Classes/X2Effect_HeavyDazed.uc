class X2Effect_Heavydazed extends X2Effect_Stunned
	config(GameData_SoldierSkills);

var config array<name> DAZE_REMOVE_EFFECTS_TARGET;

static function X2Effect CreateDazedRemoveEffects()
{
	local X2Effect_RemoveEffectsByDamageType RemoveEffects;

	RemoveEffects = new class'X2Effect_RemoveEffectsByDamageType';

	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.PanickedName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.StunnedName);
	RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.DazedName);

	return RemoveEffects;
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameState_Unit UnitState;

	super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if (UnitState != none)
	{
		UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(UnitState.Class, UnitState.ObjectID));

		UnitState.StunnedActionPoints = 0;
		// Only return one action point
		if( UnitState.StunnedThisTurn > 0 )
		{
			UnitState.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
		}
		UnitState.StunnedThisTurn = 0;
	}
}

simulated function AddX2ActionsForVisualization_Removed(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult, XComGameState_Effect RemovedEffect)
{
	local X2Action_PersistentEffect PersistentEffectAction;
	local XComGameStateVisualizationMgr VisMgr;
	local array<X2Action> VisNodes;
	local int i;

	VisMgr = `XCOMVISUALIZATIONMGR;

	super.AddX2ActionsForVisualization_Removed(VisualizeGameState, ActionMetadata, EffectApplyResult, RemovedEffect);

	VisMgr.GetNodesOfType(VisMgr.BuildVisTree, class'X2Action_PersistentEffect', VisNodes, ActionMetadata.VisualizeActor);

	for (i = 0; i < VisNodes.Length; ++i)
	{
		PersistentEffectAction = X2Action_PersistentEffect(VisNodes[i]);
		if (PersistentEffectAction != none && PersistentEffectAction.IdleAnimName == '')
		{
			PersistentEffectAction.AddInputEvent('Visualizer_AbilityHit');
			break;
		}
	}
	
}

function bool ProvidesDamageImmunity(XComGameState_Effect EffectState, name DamageType)
{
	return (DamageType == 'stun'||DamageType == 'Mental');
}

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local XComGameState_Unit UnitState;
	local X2EventManager EventMan;
	local Object EffectObj;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	EventMan = `XEVENTMGR;

	EffectObj = EffectGameState;
	EventMan.RegisterForEvent(EffectObj, 'UnitDazed', class'XComGameState_Effect'.static.AffectedByDaze_Listener, ELD_OnStateSubmitted, , UnitState);
}

defaultproperties
{
	CustomIdleOverrideAnim="HL_DazedIdle"
	StunStartAnimName="HL_DazedStart"
	StunStopAnimName="HL_DazedStop"
	StunnedTriggerName="UnitDazed"

	Begin Object Class=X2Condition_UnitProperty Name=UnitPropertyCondition
		ExcludeTurret=true
		ExcludeDead=true
		FailOnNonUnits=true
		RequireUnitSelectedFromHQ=true
	End Object

	TargetConditions.Add(UnitPropertyCondition)
}