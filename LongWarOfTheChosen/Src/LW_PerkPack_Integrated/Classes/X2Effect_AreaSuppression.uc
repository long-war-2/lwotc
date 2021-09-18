///---------------------------------------------------------------------------------------
//  FILE:    X2Effect_AreaSuppression
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Implements AoE Damage immunities for Bastion, based on Solace ability
//---------------------------------------------------------------------------------------
class X2Effect_AreaSuppression extends X2Effect_Suppression config(LW_SoldierSkills);

//`include(LW_PerkPack_Integrated\LW_PerkPack.uci)

// prevent doubling up if unit is both suppressed and area suppressed, since regular suppression doesn't stack with itself
function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	if(Target.IsUnitAffectedByEffectName(class'X2Effect_Suppression'.default.EffectName))
		return;

	super.GetToHitModifiers(EffectState, Attacker, Target, AbilityState, ToHitType, bMelee, bFlanking, bIndirectFire, ShotModifiers);
}


//handle switching the suppression target if there is an other remaining suppression target
simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameState_Unit SourceState, TargetState;
	local StateObjectReference NullRef;

	TargetState = FindNewAreaSuppressionTarget(NewGameState, RemovedEffectState, SourceState);
	if (TargetState != none && SourceState != none)
	{
		SourceState.m_MultiTurnTargetRef = TargetState.GetReference();
	}
	else
	{
		SourceState.m_MultiTurnTargetRef = NullRef;
	}

	super(X2Effect_Persistent).OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);
}

// new helper function to figure out a new primary suppression target to switch to
simulated function XComGameState_Unit FindNewAreaSuppressionTarget(XComGameState NewGameState, XComGameState_Effect RemovedEffect, out XComGameState_Unit SourceState)
{
	local XComGameStateHistory History;
	local XComGameState_Unit TargetState;
	local name TestEffectName;
	local int count;
	local XComGameState_Effect EffectState;

	History = `XCOMHISTORY;

	SourceState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(RemovedEffect.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	if(SourceState == none)
	{
		SourceState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', RemovedEffect.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
		NewGameState.AddStateObject(SourceState);
	}
	if (ShouldRemoveAreaSuppression(SourceState, NewGameState))
		return none;

	if(SourceState != none)
	{
		foreach SourceState.AppliedEffectNames(TestEffectName, count)
		{
			if(TestEffectName == default.EffectName)
			{
				EffectState = XComGameState_Effect(History.GetGameStateForObjectID( SourceState.AppliedEffects[ count ].ObjectID ) );
				if (EffectState.ObjectID != RemovedEffect.ObjectID) // can't switch to the effect being removed
				{
					TargetState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
					if(TargetState == none)
					{
						TargetState = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
					}
					`LOG("X2Effect_AreaSuppression: Found EffectGameState affecting " $ TargetState.GetFullName() $ ", Alive=" $ TargetState.IsAlive());
					if(TargetState != none && TargetState.IsAlive())
					{
						return TargetState;
					}
				}
			}
		}
	}
	return none;
}

simulated function bool UpdateVisualizedSuppressionTarget(XComGameState NewGameState, XComGameState_Effect RemovedEffect)
{
	local XComGameState_Unit SourceState, TargetState;
	local XGUnit SourceUnit, TargetUnit;

	TargetState = FindNewAreaSuppressionTarget(NewGameState, RemovedEffect, SourceState);
	if (TargetState != none && SourceState != none)
	{
		SourceUnit = XGUnit(SourceState.GetVisualizer());
		if(SourceUnit.m_kForceConstantCombatTarget != none)
		{
			// remove the marking on the old target, so it doesn't disable the suppression state in the XGUnit.OnDeath
			SourceUnit.m_kForceConstantCombatTarget.m_kConstantCombatUnitTargetingMe = none;
		}
		TargetUnit = XGUnit(TargetState.GetVisualizer());
					
		SourceUnit.ConstantCombatSuppressArea(false);
		SourceUnit.ConstantCombatSuppress(true, TargetUnit);
		SourceUnit.IdleStateMachine.CheckForStanceUpdate();
		return true;
	}
	else
	{
		return false;
	}
}

// add check to attempt to switch visualiation targets instead of just ending suppression
simulated function AddX2ActionsForVisualization_RemovedSource(XComGameState VisualizeGameState, out VisualizationActionMetadata BuildTrack, const name EffectApplyResult, XComGameState_Effect RemovedEffect)
{
	if(UpdateVisualizedSuppressionTarget(VisualizeGameState, RemovedEffect))
		return;

	super.AddX2ActionsForVisualization_RemovedSource(VisualizeGameState, BuildTrack, EffectApplyResult, RemovedEffect);
}

// add check to attempt to switch visualiation targets instead of just ending suppression
simulated function CleansedAreaSuppressionVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata BuildTrack, const name EffectApplyResult, XComGameState_Effect RemovedEffect)
{
	local XComGameStateHistory History;

	if(UpdateVisualizedSuppressionTarget(VisualizeGameState, RemovedEffect))
		return;

	History = `XCOMHISTORY;

	BuildTrack.VisualizeActor = History.GetVisualizer(RemovedEffect.ApplyEffectParameters.SourceStateObjectRef.ObjectID);
	History.GetCurrentAndPreviousGameStatesForObjectID(RemovedEffect.ApplyEffectParameters.SourceStateObjectRef.ObjectID, BuildTrack.StateObject_OldState, BuildTrack.StateObject_NewState, eReturnType_Reference, VisualizeGameState.HistoryIndex);
	if (BuildTrack.StateObject_NewState == none)
	BuildTrack.StateObject_NewState = BuildTrack.StateObject_OldState;
	
	class'X2Action_StopSuppression'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext(), false, BuildTrack.LastActionAdded);
	
	// WOTC: I'm not sure this ever did anything. I can't see where m_SuppressionAbilityContext
	// is set to anything other than None.
	// UnitState = XComGameState_Unit(History.GetGameStateForObjectID(RemovedEffect.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	// Action = X2Action_EnterCover(class'X2Action_EnterCover'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext(), false, BuildTrack.LastActionAdded));
	// Action.AbilityContext = UnitState.m_SuppressionAbilityContext;
}

// this is only for removing from OTHER targets than the one being shot at
static function bool ShouldRemoveAreaSuppression(XComGameState_Unit SourceUnit, optional XComGameState NewGameState, optional bool bBeforeAmmoReduction = false)
{
	local bool bShouldRemove;
	local XComGameState_Item WeaponState;

	bShouldRemove = false;
	if (SourceUnit != none)
	{
		//check remaining ammo
		WeaponState = SourceUnit.GetItemInSlot(eInvSlot_PrimaryWeapon, NewGameState);
		if (WeaponState != none)
		{
			if (bBeforeAmmoReduction)
			{
				if (WeaponState.Ammo <= (2 * class'X2Ability_PerkPackAbilitySet'.default.AREA_SUPPRESSION_SHOT_AMMO_COST) - 1)
					bShouldRemove = true;
			}
			else if (WeaponState.Ammo < (2 * class'X2Ability_PerkPackAbilitySet'.default.AREA_SUPPRESSION_SHOT_AMMO_COST) - 1)
			{
				bShouldRemove = true;
			}
		}
		if(SourceUnit.IsImpaired() || SourceUnit.AffectedByEffectNames.Find(class'X2StatusEffects_LW'.default.LWBurningName) != -1)
		{
			bShouldRemove = true;
		}
	}

	return bShouldRemove;
}

DefaultProperties
{
	EffectName="AreaSuppression"
}