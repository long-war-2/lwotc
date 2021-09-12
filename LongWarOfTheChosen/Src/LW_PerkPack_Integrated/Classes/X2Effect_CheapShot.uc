//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_CheapShot
//  AUTHOR:  Grobobobo
//  PURPOSE: Cheap shot effect to grant free action
//---------------------------------------------------------------------------------------

class X2Effect_CheapShot extends X2Effect_Persistent;

var bool CHEAPSHOT_FULLACTION;
var array<name> CHEAPSHOT_ABILITYNAMES;
var int CHEAPSHOT_USES_PER_TURN;
var name CheapshotUsesName; //Prevents multiple hit and run like abilities from having the same activation ID

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager			EventMgr;
	local XComGameState_Unit		UnitState;
	local Object					EffectObj;

	EventMgr = `XEVENTMGR;
	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	EventMgr.RegisterForEvent(EffectObj, 'CheapShot', EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted, , UnitState);
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local XComGameStateHistory					History;
	local XComGameState_Unit					TargetUnit;
	local XComGameState_Ability					AbilityState;
	local GameRulesCache_VisibilityInfo			VisInfo;
	local int									iUsesThisTurn;
	local UnitValue								CheapShotUsesThisTurn, CEUsesThisTurn;
	//  if under the effect of Serial, let that handle restoring the full action cost - will this work?
	if (SourceUnit.IsUnitAffectedByEffectName(class'X2Effect_Serial'.default.EffectName))
		return false;

	if (PreCostActionPoints.Find('RunAndGun') != -1)
		return false;

	// Don't proc on a Skirmisher interrupt turn (for example with Battle Lord)
	if (class'Helpers_LW'.static.IsUnitInterruptingEnemyTurn(SourceUnit))
		return false;

	SourceUnit.GetUnitValue (CheapShotUsesName, CheapShotUsesThisTurn);
	iUsesThisTurn = int(CheapShotUsesThisTurn.fValue);

	if (iUsesThisTurn >= CHEAPSHOT_USES_PER_TURN)
		return false;


	SourceUnit.GetUnitValue ('CloseEncountersUses', CEUsesThisTurn);
	iUsesThisTurn = int(CEUsesThisTurn.fValue);

	if (iUsesThisTurn >= 1)
		return false;

	//  match the weapon associated with Cheap Shot to the attacking weapon
	if (kAbility.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef)
	{
		History = `XCOMHISTORY;
		TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
		if (!AbilityState.IsMeleeAbility() && TargetUnit != none)
		{
			if(X2TacticalGameRuleset(XComGameInfo(class'Engine'.static.GetCurrentWorldInfo().Game).GameRuleset).VisibilityMgr.GetVisibilityInfo(SourceUnit.ObjectID, TargetUnit.ObjectID, VisInfo))
			{
				if (ShouldActivateEffect(EffectState, TargetUnit, kAbility))
				{
					if (CHEAPSHOT_ABILITYNAMES.Find(kAbility.GetMyTemplateName()) != -1)
					{
						if (SourceUnit.NumActionPoints() < 2 && PreCostActionPoints.Length > 0)
						{
							AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
							if (AbilityState != none)
							{
								SourceUnit.SetUnitFloatValue (CheapShotUsesName, iUsesThisTurn + 1.0, eCleanup_BeginTurn);
								if (!CHEAPSHOT_FULLACTION)
								{
									SourceUnit.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.MoveActionPoint);
								}
								else
								{
									SourceUnit.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
								}
								`XEVENTMGR.TriggerEvent('CheapShot', AbilityState, SourceUnit, NewGameState);
							}
						}
					}
				}
			}
		}
	}
	return false;
}


 private function bool ShouldActivateEffect(XComGameState_Effect EffectState, XComGameState_Unit Target, XComGameState_Ability AbilityState)
{
	local UnitValue DamageUnitValue;

	Target.GetUnitValue('DamageThisTurn', DamageUnitValue);
	return DamageUnitValue.fValue > 0;

}
defaultproperties
{
	CheapShotUsesName = CheapShotUses
    CHEAPSHOT_USES_PER_TURN = 1
}