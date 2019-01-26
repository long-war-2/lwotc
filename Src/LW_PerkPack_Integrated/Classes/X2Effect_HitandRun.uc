//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_HitAndRun
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Hit and Run effect to grant free action
//---------------------------------------------------------------------------------------

class X2Effect_HitandRun extends X2Effect_Persistent config (LW_SoldierSkills);

var bool HITANDRUN_FULLACTION;
var config array<name> HNR_ABILITYNAMES;
var config int HNR_USES_PER_TURN;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager			EventMgr;
	local XComGameState_Unit		UnitState;
	local Object					EffectObj;

	EventMgr = `XEVENTMGR;
	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	EventMgr.RegisterForEvent(EffectObj, 'HitandRun', EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted, , UnitState);
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local XComGameStateHistory					History;
	local XComGameState_Unit					TargetUnit;
	local XComGameState_Ability					AbilityState;
	local GameRulesCache_VisibilityInfo			VisInfo;
	local int									iUsesThisTurn;
	local UnitValue								HnRUsesThisTurn;

	//  if under the effect of Serial, let that handle restoring the full action cost - will this work?
	if (SourceUnit.IsUnitAffectedByEffectName(class'X2Effect_Serial'.default.EffectName))
		return false;

	if (PreCostActionPoints.Find('RunAndGun') != -1)
		return false;

	SourceUnit.GetUnitValue ('HitandRunUses', HnRUsesThisTurn);
	iUsesThisTurn = int(HnRUsesThisTurn.fValue);

	if (iUsesThisTurn >= default.HNR_USES_PER_TURN)
		return false;


	//  match the weapon associated with Hit and Run to the attacking weapon
	if (kAbility.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef)
	{
		History = `XCOMHISTORY;
		TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
		if (!AbilityState.IsMeleeAbility() && TargetUnit != none)
		{
			if(X2TacticalGameRuleset(XComGameInfo(class'Engine'.static.GetCurrentWorldInfo().Game).GameRuleset).VisibilityMgr.GetVisibilityInfo(SourceUnit.ObjectID, TargetUnit.ObjectID, VisInfo))
			{
				if (TargetUnit.IsEnemyUnit(SourceUnit) && SourceUnit.CanFlank() && TargetUnit.GetMyTemplate().bCanTakeCover && (VisInfo.TargetCover == CT_None || TargetUnit.GetCurrentStat(eStat_AlertLevel) == 0))
				{
					if (default.HNR_ABILITYNAMES.Find(kAbility.GetMyTemplateName()) != -1)
					{
						if (SourceUnit.NumActionPoints() < 2 && PreCostActionPoints.Length > 0)
						{
							AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
							if (AbilityState != none)
							{
								SourceUnit.SetUnitFloatValue ('HitandRunUses', iUsesThisTurn + 1.0, eCleanup_BeginTurn);
								if (!HITANDRUN_FULLACTION)
								{
									SourceUnit.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.MoveActionPoint);
								}
								else
								{
									SourceUnit.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
								}
								`XEVENTMGR.TriggerEvent('HitandRun', AbilityState, SourceUnit, NewGameState);
							}
						}
					}
				}
			}
		}
	}
	return false;
}
