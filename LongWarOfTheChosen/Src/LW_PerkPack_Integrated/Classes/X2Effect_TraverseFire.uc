//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_TraverseFire
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Conditionally refunds actions for Traverse Fire
//--------------------------------------------------------------------------------------- 

class X2Effect_TraverseFire extends X2Effect_Persistent config (LW_SoldierSkills);

var config int TF_USES_PER_TURN;
var config array<name> TF_ABILITYNAMES;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	EventMgr.RegisterForEvent(EffectObj, 'PlayerTurnBegun', class'XComGameState_Effect_EffectCounter'.static.ResetUses, ELD_OnStateSubmitted,,,, EffectObj);
	EventMgr.RegisterForEvent(EffectObj, 'TraverseFire', EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted,, UnitState);
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
	CurrentTFCounter = XComGameState_Effect_EffectCounter(EffectState);

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
				UpdatedTFCounter = XComGameState_Effect_EffectCounter(NewGameState.ModifyStateObject(class'XComGameState_Effect_EffectCounter', CurrentTFCounter.ObjectID));
				SourceUnit.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.RunAndGunActionPoint);
				UpdatedTFCounter.uses += 1;
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
	GameStateEffectClass=class'XComGameState_Effect_EffectCounter';
}
