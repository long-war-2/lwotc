///---------------------------------------------------------------------------------------
//  FILE:    X2Effect_EmergencyLifeSupport.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Implements EmergencyLifeSupport, auto-succeeds at first bleedout roll
//           each mission and increases the bleedout duration
//--------------------------------------------------------------------------------------- 
class X2Effect_EmergencyLifeSupport extends X2Effect_Persistent config(LW_SoldierSkills);

`include(LW_PerkPack_Integrated\LW_PerkPack.uci)

var protectedwrite name ELSActivate;
var protectedwrite name ELSDeathUsed;
var protectedwrite name ELSStabilizeUsed;

var int MaxActivations;
var int BonusBleedOutTurns;
var config int EMERGENCY_LIFE_SUPPORT_BONUS_BLEEDINGOUT_TURNS;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager EventMgr;
    local Object EffectObj;
    local XComGameState_Unit EffectTargetUnit;

    EventMgr = `XEVENTMGR;
    EffectObj = EffectGameState;
    EffectTargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    EventMgr.RegisterForEvent(EffectObj, 'UnitBleedingOut', OnUnitBleedingOut, ELD_OnStateSubmitted,, EffectTargetUnit,, EffectObj);
}

static function EventListenerReturn OnUnitBleedingOut(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameState_Unit    UnitState;
    local XComGameState_Effect  EffectState, BleedOutEffectState;
    local X2Effect_EmergencyLifeSupport Effect;
    local XComGameState         NewGameState;
    local UnitValue             ELSValue;

    UnitState = XComGameState_Unit(EventData);
    EffectState = XComGameState_Effect(CallbackData);

    if (UnitState != none && EffectState != none)
    {
        Effect = X2Effect_EmergencyLifeSupport(EffectState.GetX2Effect());
        if (Effect != none)
        {
            if (UnitState.GetUnitValue(Effect.ELSActivate, ELSValue) && ELSValue.fValue > 0)
            {
                if (UnitState.IsBleedingOut())
                {
                    BleedOutEffectState = UnitState.GetUnitAffectedByEffectState(class'X2StatusEffects'.default.BleedingOutName);
                    if (BleedOutEffectState != none)
                    {
                        NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("EmergencyLifeSupport");

                        `PPDEBUG("EmergencyLifeSupport: Triggered, setting unit value.");
                        UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(UnitState.Class, UnitState.ObjectID));
                        UnitState.GetUnitValue(Effect.ELSDeathUsed, ELSValue);
                        UnitState.SetUnitFloatValue(Effect.ELSDeathUsed, ELSValue.fValue + 1, eCleanup_BeginTactical);
                        if (ELSValue.fValue + 1 >= Effect.MaxActivations)
                        {
                            UnitState.ClearUnitValue(Effect.ELSActivate);
                        }

                        BleedOutEffectState = XComGameState_Effect(NewGameState.ModifyStateObject(BleedOutEffectState.Class, BleedOutEffectState.ObjectID));
                        BleedOutEffectState.iTurnsRemaining += Effect.BonusBleedOutTurns;

                        `TACTICALRULES.SubmitGameState(NewGameState);
                    }
                }
            }
        }
    }

    return ELR_NoInterrupt;
}

function bool ForcesBleedout(XComGameState NewGameState, XComGameState_Unit UnitState, XComGameState_Effect EffectState)
{
    local UnitValue ELSValue;

    `PPDEBUG("EmergencyLifeSupport: Starting ForcesBleedout Check.");

    if (UnitState.GetUnitValue(ELSDeathUsed, ELSValue) && ELSValue.fValue >= MaxActivations)
    {
        `PPDEBUG("EmergencyLifeSupport: Already used, failing.");
        return false;
    }

    UnitState.SetUnitFloatValue(ELSActivate, 1, eCleanup_BeginTactical);

    return true;
}

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
    local UnitValue ELSValue;

    TargetUnit.GetUnitValue(ELSDeathUsed, ELSValue);
    if (ELSValue.fValue < MaxActivations)
    {
        return true;
    }

    return false;
}

defaultproperties
{
    EffectName = "EmergencyLifeSupport"
    ELSActivate = "EmergencyLifeSupportActived"
    ELSDeathUsed = "EmergencyLifeSupportDeathUsed"
    ELSStabilizeUsed = "EmergencyLifeSupportStabilizeUsed"

    MaxActivations = 1
}