//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_TraverseFire
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Conditionally refunds actions for Traverse Fire
//--------------------------------------------------------------------------------------- 

class X2Effect_TraverseFire extends X2Effect_Persistent config (LW_SoldierSkills);

var config int TF_USES_PER_TURN;
var config array<name> TF_ABILITYNAMES;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Effect_EffectCounter	TFEffectState;
	local X2EventManager						EventMgr;
	local Object								ListenerObj, EffectObj;
	local XComGameState_Unit					UnitState;

	EventMgr = `XEVENTMGR;
	EffectObj = NewEffectState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(NewEffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	if (GetTFCounter(NewEffectState) == none)
	{
		TFEffectState = XComGameState_Effect_EffectCounter(NewGameState.CreateStateObject(class'XComGameState_Effect_EffectCounter'));
		TFEffectState.InitComponent();
		NewEffectState.AddComponentObject(TFEffectState);
		NewGameState.AddStateObject(TFEffectState);
	}
	ListenerObj = TFEffectState;
	if (ListenerObj == none)
	{
		`Redscreen("TF: Failed to find TF Component when registering listener");
		return;
	}
    EventMgr.RegisterForEvent(ListenerObj, 'PlayerTurnBegun', TFEffectState.ResetUses, ELD_OnStateSubmitted);
	EventMgr.RegisterForEvent(EffectObj, 'TraverseFire', NewEffectState.TriggerAbilityFlyover, ELD_OnStateSubmitted, , UnitState);
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameState_BaseObject EffectComponent;
	local Object EffectComponentObj;
	
	super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);

	EffectComponent = GetTFCounter(RemovedEffectState);
	if (EffectComponent == none)
		return;

	EffectComponentObj = EffectComponent;
	`XEVENTMGR.UnRegisterFromAllEvents(EffectComponentObj);

	NewGameState.RemoveStateObject(EffectComponent.ObjectID);
}

static function XComGameState_Effect_EffectCounter GetTFCounter(XComGameState_Effect Effect)
{
	if (Effect != none) 
		return XComGameState_Effect_EffectCounter(Effect.FindComponentObject(class'XComGameState_Effect_EffectCounter'));
	return none;
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local XComGameState_Effect_EffectCounter	CurrentTFCounter, UpdatedTFCounter;
	local X2EventManager						EventMgr;
	local XComGameState_Ability					AbilityState;

	if (SourceUnit.IsUnitAffectedByEffectName(class'X2Effect_Serial'.default.EffectName))
		return false;
	if (SourceUnit.IsUnitAffectedByEffectName(class'X2Effect_DeathfromAbove'.default.EffectName))
		return false;	

	if (kAbility.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
		return false;
	CurrentTFCounter = GetTFCounter(EffectState);

	If (CurrentTFCounter != none)	 
	{
		if (CurrentTFCounter.uses >= default.TF_USES_PER_TURN)		
			return false;
	}
	if (XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID)) == none)
		return false;
	AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
	if (AbilityState != none)
	{
		if (default.TF_ABILITYNAMES.Find(kAbility.GetMyTemplateName()) != -1)
		{
			if (SourceUnit.NumActionPoints() == 0 && PreCostActionPoints.Length > 1)
			{
				UpdatedTFCounter = XComGameState_Effect_EffectCounter(NewGameState.CreateStateObject(class'XComGameState_Effect_EffectCounter', CurrentTFCounter.ObjectID));
				SourceUnit.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.RunandGunActionPoint);
				UpdatedTFCounter.uses += 1;
				NewGameState.AddStateObject(UpdatedTFCounter);
				NewGameState.AddStateObject(SourceUnit);
				EventMgr = `XEVENTMGR;
				EventMgr.TriggerEvent('TraverseFire', AbilityState, SourceUnit, NewGameState);
			}
		}
	}
	return false;
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
    EffectName="TraverseFire"
}

