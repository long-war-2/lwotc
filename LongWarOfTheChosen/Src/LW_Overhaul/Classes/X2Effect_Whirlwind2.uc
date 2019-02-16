//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_Whirlwind2
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Grants move action after melee hit
//--------------------------------------------------------------------------------------- 

class X2Effect_Whirlwind2 extends X2Effect_Persistent;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager			EventMgr;
	local XComGameState_Unit		UnitState;
	local Object					EffectObj;

	EventMgr = `XEVENTMGR;
	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	EventMgr.RegisterForEvent(EffectObj, 'Whirlwind2', EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted, , UnitState);
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local XComGameState_Unit					TargetUnit;
	local XComGameState_Ability					AbilityState;
	local int									iUsesThisTurn;
	local UnitValue								WWUsesThisTurn;

	//`LOG ("Starting WW check");

	//  if under the effect of Serial, let that handle restoring the full action cost - will this work?
	if (SourceUnit.IsUnitAffectedByEffectName(class'X2Effect_Serial'.default.EffectName))
		return false;

	if (SourceUnit.IsUnitAffectedByEffectName(class'X2Effect_Reaper'.default.EffectName))
		return false;

	SourceUnit.GetUnitValue ('Whirlwind2Uses', WWUsesThisTurn);
	iUsesThisTurn = int(WWUsesThisTurn.fValue);

	if (iUsesThisTurn >= 1)
		return false;

	//`LOG ("WW check 2");

	//  match the weapon associated with WW to the attacking weapon
	if (true) //kAbility.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef)
	{
		//`LOG ("WW check 3");
		TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
		AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));

		//`LOG (kAbility.GetMyTemplateName()); // the active ability
		//`LOG (AbilityState.GetMyTemplateName()); //the WhirlwindAbility

		if (TargetUnit != none && TargetUnit.IsEnemyUnit(SourceUnit))
		{
			//`LOG ("WW check 4");
			if (kAbility.IsMeleeAbility() && class'XComGameStateContext_Ability'.static.IsHitResultHit(AbilityContext.ResultContext.HitResult))
			{
				//`LOG ("WW check 5");
				if (PreCostActionPoints.Length > 0)
				{
					//`LOG ("WW check pass");
					SourceUnit.SetUnitFloatValue ('Whirlwind2Uses', iUsesThisTurn + 1.0, eCleanup_BeginTurn);
					SourceUnit.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.MoveActionPoint);						
					`XEVENTMGR.TriggerEvent('Whirlwind2', AbilityState, SourceUnit, NewGameState);
				}
			}
		}
	}
	return false;
}

