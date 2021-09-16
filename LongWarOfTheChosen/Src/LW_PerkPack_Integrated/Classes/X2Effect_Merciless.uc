//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_HitAndRun
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Hit and Run effect to grant free action
//---------------------------------------------------------------------------------------

class X2Effect_Merciless extends X2Effect_Persistent config (LW_SoldierSkills);

var int MERCILESS_USES_PER_TURN;
var name MercilessUsesName; //Prevents multiple hit and run like abilities from having the same activation ID
var config array<Name> MERCILESS_ABILITYNAMES;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager			EventMgr;
	local XComGameState_Unit		UnitState;
	local Object					EffectObj;

	EventMgr = `XEVENTMGR;
	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	EventMgr.RegisterForEvent(EffectObj, 'Merciless', EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted, , UnitState);
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local XComGameStateHistory					History;
	local XComGameState_Unit					TargetUnit;
	local XComGameState_Ability					AbilityState;
	local GameRulesCache_VisibilityInfo			VisInfo;
	local int									iUsesThisTurn;
	local UnitValue								MercilessUsesThisTurn, CEUsesThisTurn;
	local int i;
	//  if under the effect of Serial, let that handle restoring the full action cost - will this work?
	if (SourceUnit.IsUnitAffectedByEffectName(class'X2Effect_Serial'.default.EffectName))
		return false;

	if (PreCostActionPoints.Find('RunAndGun') != -1)
		return false;

	// Don't proc on a Skirmisher interrupt turn (for example with Battle Lord)
	if (class'Helpers_LW'.static.IsUnitInterruptingEnemyTurn(SourceUnit))
		return false;

	SourceUnit.GetUnitValue (MercilessUsesName, MercilessUsesThisTurn);
	iUsesThisTurn = int(MercilessUsesThisTurn.fValue);

	if (iUsesThisTurn >= MERCILESS_USES_PER_TURN)
		return false;


	SourceUnit.GetUnitValue ('CloseEncountersUses', CEUsesThisTurn);
	iUsesThisTurn = int(CEUsesThisTurn.fValue);

	if (iUsesThisTurn >= 1)
		return false;

	//  match the weapon associated with Merciless to the attacking weapon
	if (kAbility.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef)
	{
		History = `XCOMHISTORY;
		TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
		if (!AbilityState.IsMeleeAbility() && TargetUnit != none)
		{
			if(X2TacticalGameRuleset(XComGameInfo(class'Engine'.static.GetCurrentWorldInfo().Game).GameRuleset).VisibilityMgr.GetVisibilityInfo(SourceUnit.ObjectID, TargetUnit.ObjectID, VisInfo))
			{
				if (TargetUnit.IsDisoriented() || TargetUnit.IsStunned() || TargetUnit.IsPanicked())
				{
					if (default.MERCILESS_ABILITYNAMES.Find(kAbility.GetMyTemplateName()) != -1)
					{

						AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
						if (AbilityState != none)
						{
							for (i = 0; i < PreCostActionPoints.Length; i++)
							{
								SourceUnit.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
							}
							SourceUnit.SetUnitFloatValue (MercilessUsesName, iUsesThisTurn + 1.0, eCleanup_BeginTurn);
							
							`XEVENTMGR.TriggerEvent('Merciless', AbilityState, SourceUnit, NewGameState);
						}
						
					}
				}
			}
		}
	}
	return false;
}
defaultproperties
{
	MercilessUsesName = HitandRunUses
	MERCILESS_USES_PER_TURN = 1
}