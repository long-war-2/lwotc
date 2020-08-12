
//---------------------------------------------------------------------------------------
//  FILE:   X2Effect_ReturnFireAOE.uc
//  AUTHOR:  Favid
//  PURPOSE: Used to trigger whenever your ally gets attacked
//---------------------------------------------------------------------------------------
class X2Effect_ReturnFireAOE extends X2Effect_Persistent;

var name AbilityToActivate;         //  ability to activate when the covering fire check is matched
var name GrantActionPoint;          //  action point to give the shooter when covering fire check is matched
var int MaxPointsPerTurn;           //  max times per turn the action point can be granted
var bool bPreEmptiveFire;           //  if true, the reaction fire will happen prior to the attacker's shot; otherwise it will happen after
var bool bOnlyDuringEnemyTurn;      //  only activate the ability during the enemy turn (e.g. prevent return fire during the sharpshooter's own turn)
var bool bUseMultiTargets;          //  initiate AbilityToActivate against yourself and look for multi targets to hit, instead of direct retaliation
var bool bOnlyWhenAttackMisses;		//  Only activate the ability if the attack missed
var bool bSelfTargeting;			//  The ability being activated targets the covering unit (self)
var float RequiredAllyRange;        //  The targeted ally must be within this range from the owner of this effect. Value of 0 ignores this.
var bool bAllowSelf;                //  If true, return fire will activate if you are targeted; if false, the target must be an ally

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;

	EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', ReturnFireAOECheck, ELD_OnStateSubmitted,,,, EffectObj);
}

static function EventListenerReturn ReturnFireAOECheck(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
    local XComGameState_Effect          EffectState;
	local XComGameState_Unit AttackingUnit, CoveringUnit, TargetUnit;
	local XComGameStateHistory History;
	local X2Effect_ReturnFireAOE CoveringFireEffect;
	local StateObjectReference AbilityRef;
	local XComGameState_Ability AbilityState;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState NewGameState;
    local UnitValue                     ActivationCounterValue;
	local name ErrorCode;

	//`LOG("=== ReturnFireAOECheck");

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if (AbilityContext != none)
	{
		//`LOG("=== ReturnFireAOECheck 1");
		History = `XCOMHISTORY;
	    EffectState = XComGameState_Effect(CallbackData);
        CoveringUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
		AttackingUnit = class'X2TacticalGameRulesetDataStructures'.static.GetAttackingUnitState(GameState);
        TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
		if (AttackingUnit != none && AttackingUnit.IsEnemyUnit(CoveringUnit))
		{
			//`LOG("=== ReturnFireAOECheck 2");
			CoveringFireEffect = X2Effect_ReturnFireAOE(EffectState.GetX2Effect());
			`assert(CoveringFireEffect != none);

			if (CoveringFireEffect.bOnlyDuringEnemyTurn)
			{
				//`LOG("=== ReturnFireAOECheck 3");
				//  make sure it's the enemy turn if required
				if (`TACTICALRULES.GetCachedUnitActionPlayerRef().ObjectID != AttackingUnit.ControllingPlayer.ObjectID)
				{
					return ELR_NoInterrupt;
					//`LOG("=== ReturnFireAOECheck 4");
				}
			}

			if (CoveringFireEffect.bPreEmptiveFire)
			{
				//`LOG("=== ReturnFireAOECheck 5");
				//  for pre emptive fire, only process during the interrupt step
				if (AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
				{
					//`LOG("=== ReturnFireAOECheck 6");
					return ELR_NoInterrupt;
				}
			}
			else
			{
				//`LOG("=== ReturnFireAOECheck 7");
				//  for non-pre emptive fire, don't process during the interrupt step
				if (AbilityContext.InterruptionStatus == eInterruptionStatus_Interrupt)
				{
					//`LOG("=== ReturnFireAOECheck 8");
					return ELR_NoInterrupt;
				}
			}

            if (CoveringFireEffect.RequiredAllyRange > 0)
            {
				//`LOG("=== ReturnFireAOECheck 9");
                // do nothing if the target unit is not within the required range of the covering unit
                if (!class'Helpers'.static.IsTileInRange(CoveringUnit.TileLocation, TargetUnit.TileLocation, CoveringFireEffect.RequiredAllyRange))
				{
					//`LOG("=== ReturnFireAOECheck 10");
					return ELR_NoInterrupt;
				}
            }

            if (!CoveringFireEffect.bAllowSelf)
            {
				//`LOG("=== ReturnFireAOECheck 11");
                if (CoveringUnit.ObjectID == TargetUnit.ObjectID)
				{
					//`LOG("=== ReturnFireAOECheck 12");
					return ELR_NoInterrupt;
				}
            }

			if (CoveringFireEffect.bOnlyWhenAttackMisses)
			{
				//`LOG("=== ReturnFireAOECheck 13");

				//  do nothing if the covering unit was not hit in the attack
				if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AbilityContext.ResultContext.HitResult))
				{
					//`LOG("=== ReturnFireAOECheck 14");
					return ELR_NoInterrupt;
				}
			}

			AbilityRef = CoveringUnit.FindAbility(CoveringFireEffect.AbilityToActivate);
			AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityRef.ObjectID));
			if (AbilityState != none)
			{
				//`LOG("=== ReturnFireAOECheck 15");
                CoveringUnit.GetUnitValue('ReturnFireAOE_GrantsThisTurn', ActivationCounterValue);

				if (CoveringFireEffect.GrantActionPoint != '' && (CoveringFireEffect.MaxPointsPerTurn > ActivationCounterValue.fValue || CoveringFireEffect.MaxPointsPerTurn <= 0))
				{
					//`LOG("=== ReturnFireAOECheck 16");
					NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));

			        CoveringUnit.SetUnitFloatValue ('ReturnFireAOE_GrantsThisTurn', ActivationCounterValue.fValue + 1, eCleanup_BeginTurn);

					CoveringUnit = XComGameState_Unit(NewGameState.ModifyStateObject(CoveringUnit.Class, CoveringUnit.ObjectID));
					CoveringUnit.ReserveActionPoints.AddItem(CoveringFireEffect.GrantActionPoint);

					ErrorCode = AbilityState.CanActivateAbilityForObserverEvent(AttackingUnit, CoveringUnit);
					if (ErrorCode != 'AA_Success')
					{
						//`LOG("=== ReturnFireAOECheck 17: " @ ErrorCode);
						History.CleanupPendingGameState(NewGameState);
					}
					else
					{
						//`LOG("=== ReturnFireAOECheck 18");
						`TACTICALRULES.SubmitGameState(NewGameState);

						if (CoveringFireEffect.bUseMultiTargets)
						{
							//`LOG("=== ReturnFireAOECheck 19");
							AbilityState.AbilityTriggerAgainstSingleTarget(CoveringUnit.GetReference(), true);
						}
						else
						{
							//`LOG("=== ReturnFireAOECheck 20");
							AbilityContext = class'XComGameStateContext_Ability'.static.BuildContextFromAbility(AbilityState, AttackingUnit.ObjectID);
							if( AbilityContext.Validate() )
							{
								//`LOG("=== ReturnFireAOECheck 21");
								`TACTICALRULES.SubmitGameStateContext(AbilityContext);
							}
						}
					}
				}
				else if (CoveringFireEffect.bSelfTargeting && AbilityState.CanActivateAbilityForObserverEvent(CoveringUnit) == 'AA_Success')
				{
					//`LOG("=== ReturnFireAOECheck 22");
					AbilityState.AbilityTriggerAgainstSingleTarget(CoveringUnit.GetReference(), CoveringFireEffect.bUseMultiTargets);
				}
				else if (AbilityState.CanActivateAbilityForObserverEvent(AttackingUnit) == 'AA_Success')
				{
					//`LOG("=== ReturnFireAOECheck 23");
					if (CoveringFireEffect.bUseMultiTargets)
					{
						//`LOG("=== ReturnFireAOECheck 24");
						AbilityState.AbilityTriggerAgainstSingleTarget(CoveringUnit.GetReference(), true);
					}
					else
					{
						//`LOG("=== ReturnFireAOECheck 25");
						AbilityContext = class'XComGameStateContext_Ability'.static.BuildContextFromAbility(AbilityState, AttackingUnit.ObjectID);
						if( AbilityContext.Validate() )
						{
							//`LOG("=== ReturnFireAOECheck 26");
							`TACTICALRULES.SubmitGameStateContext(AbilityContext);
						}
					}
				}
			}
		}
	}
	//`LOG("=== ReturnFireAOECheck 27");
	return ELR_NoInterrupt;
}

DefaultProperties
{
	EffectName = "ReturnFireAOE"
	DuplicateResponse = eDupe_Ignore
	AbilityToActivate = "PistolReturnFire"
	GrantActionPoint = "returnfire"
	MaxPointsPerTurn = 0
	bPreEmptiveFire = false
	bOnlyDuringEnemyTurn = true
	bOnlyWhenAttackMisses = false
	bSelfTargeting = false
    RequiredAllyRange = 0
    bAllowSelf = true
}