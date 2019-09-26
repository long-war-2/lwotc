Class X2Effect_LightningReflexes_LW extends X2Effect_Persistent config (LW_SoldierSkills);

//`include(LW_PerkPack_Integrated\LW_PerkPack.uci)

var config int LR_LW_FIRST_SHOT_PENALTY;
var config int LR_LW_PENALTY_REDUCTION_PER_SHOT;
var config array<name> LR_REACTION_FIRE_ABILITYNAMES;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', IncomingReactionFireCheck, ELD_OnStateSubmitted,,,, EffectObj);
	EventMgr.RegisterForEvent(EffectObj, 'TriggerLRLWFlyover', EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted,, UnitState);
}

static function EventListenerReturn IncomingReactionFireCheck(Object EventData, Object EventSource, XComGameState GameState, name EventID, Object CallbackData)
{
	local XComGameState_Unit			AttackingUnit, DefendingUnit;
	local XComGameState_Ability			ActivatedAbilityState;
	local XComGameState_Ability			LightningReflexesAbilityState;
	local XComGameStateContext_Ability	AbilityContext;
	local XComGameState_Effect			EffectState;
	local UnitValue						LightningReflexesCounterValue;

	EffectState = XComGameState_Effect(CallbackData);
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	LightningReflexesAbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
	DefendingUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
	if (DefendingUnit != none)
	{
		if (DefendingUnit.HasSoldierAbility('LightningReflexes_LW') && !DefendingUnit.IsImpaired(false) && !DefendingUnit.IsBurning() && !DefendingUnit.IsPanicked())
		{
			AttackingUnit = class'X2TacticalGameRulesetDataStructures'.static.GetAttackingUnitState(GameState);
			if(AttackingUnit != none && AttackingUnit.IsEnemyUnit(DefendingUnit))
			{
				ActivatedAbilityState = XComGameState_Ability(EventData);
				if (ActivatedAbilityState != none)
				{		
					if (default.LR_REACTION_FIRE_ABILITYNAMES.Find(ActivatedAbilityState.GetMyTemplateName()) != -1)
					{
						// Update the Lightning Reflexes counter
						DefendingUnit.GetUnitValue('LW2WotC_LightningReflexes_Counter', LightningReflexesCounterValue);
						DefendingUnit.SetUnitFloatValue ('LW2WotC_LightningReflexes_Counter', LightningReflexesCounterValue.fValue + 1, eCleanup_BeginTurn);

						`PPTRACE ("IRFC HIT, TRIGGERING:" @ string(LightningReflexesCounterValue.fValue));

						// Send event to trigger the flyover, but only for the first shot
						if (LightningReflexesCounterValue.fValue == 0)
						{
							`XEVENTMGR.TriggerEvent('TriggerLRLWFlyover', LightningReflexesAbilityState, DefendingUnit, GameState);
						}
					}
				}
			}
		}	
	}
	return ELR_NoInterrupt;
}

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ShotInfo;
	local UnitValue LightningReflexesCounterValue;

	if (Target.IsImpaired(false) || Target.IsBurning() || Target.IsPanicked())
		return;

	`PPTRACE ("LRLW firing 1");
	if (X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc) != none)
	{
		`PPTRACE ("LRLW firing 2");
		if (X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc).bReactionFire)
		{
			Target.GetUnitValue('LW2WotC_LightningReflexes_Counter', LightningReflexesCounterValue);

			`PPTRACE ("LRLW firing 3");
			ShotInfo.ModType = eHit_Success;
			ShotInfo.Reason = FriendlyName;
			ShotInfo.Value = -(default.LR_LW_FIRST_SHOT_PENALTY-(clamp(LightningReflexesCounterValue.fValue * default.LR_LW_PENALTY_REDUCTION_PER_SHOT,0,default.LR_LW_FIRST_SHOT_PENALTY)));
			`PPTRACE("LRLW:"@ string(ShotInfo.Value)@"Uses:"@string(LightningReflexesCounterValue.fValue));
			ShotModifiers.AddItem(ShotInfo);
		}
	}
}
