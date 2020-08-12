//---------------------------------------------------------------------------------------
//  FILE:   X2Effect_Ruthless.uc
//  AUTHOR:  BStar
//  PURPOSE: Action refund on killing impaired with sawed-offs.
//---------------------------------------------------------------------------------------
class X2Effect_Ruthless extends X2Effect_Persistent;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	EventMgr.RegisterForEvent(EffectObj, 'Ruthless', EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted, , UnitState);
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local XComGameStateHistory History;
	local XComGameState_Unit TargetUnit;//, PrevTargetUnit;
	local X2EventManager EventMgr;
	local XComGameState_Ability AbilityState;

	//  if under the effect of Serial, let that handle restoring the full action cost
	if (SourceUnit.IsUnitAffectedByEffectName(class'X2Effect_Serial'.default.EffectName))
		return false;

	//  match the weapon associated with Ruthless to the attacking weapon
	if (kAbility.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef)
	{
		History = `XCOMHISTORY;
		
		//  check for a direct kill shot
		TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
		if (TargetUnit != None)
		{	
			// CHECK IF STUNNED WORKS NOW
			if (TargetUnit.IsPanicked() || TargetUnit.IsDisoriented() || TargetUnit.IsDazed())
			{
				`LOG("SUCCESS: X2Condition_UnitAffectedByImpairingEffect: TargetUnit " @ TargetUnit.GetFullName() @ "is disoriented or otherwise impaired.", true, 'Ruthless');
				
				// PrevTargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(TargetUnit.ObjectID)); // get the most recent version from the history rather than our modified (attacked) version
				if (TargetUnit.IsDead())
				{				
					AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
					if (AbilityState != none)
					{
						SourceUnit.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);

						EventMgr = `XEVENTMGR;
						EventMgr.TriggerEvent('Ruthless', AbilityState, SourceUnit, NewGameState);

						return true;
					}
				}
			}
		}
	}	
	return false;
}