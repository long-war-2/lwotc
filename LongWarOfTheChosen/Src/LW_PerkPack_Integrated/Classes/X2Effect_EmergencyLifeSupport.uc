///---------------------------------------------------------------------------------------
//  FILE:    X2Effect_EmergencyLifeSupport.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Implements EmergencyLifeSupport, auto-succeeds at first bleedout roll
//           each mission and increases the bleedout duration
//--------------------------------------------------------------------------------------- 
class X2Effect_EmergencyLifeSupport extends X2Effect_Persistent config(LW_SoldierSkills);

`include(LW_PerkPack_Integrated\LW_PerkPack.uci)

var protectedwrite name ELSDeathUsed;
var protectedwrite name ELSStabilizeUsed;

var config int EMERGENCY_LIFE_SUPPORT_BONUS_BLEEDINGOUT_TURNS;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
    local X2EventManager EventMgr;
    local Object EffectObj;
    local XComGameState_Unit EffectTargetUnit;

    EventMgr = `XEVENTMGR;
    EffectObj = EffectGameState;
    EffectTargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    EventMgr.RegisterForEvent(EffectObj, 'UnitBleedingOut', OnUnitBleedingOut, ELD_OnStateSubmitted,, EffectTargetUnit);
}

static function EventListenerReturn OnUnitBleedingOut(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameState_Unit    UnitState;
    local XComGameState_Effect  BleedOutEffectState;
    local XComGameState         NewGameState;

    UnitState = XComGameState_Unit(EventData);

    if (UnitState.IsBleedingOut())
    {
        BleedOutEffectState = UnitState.GetUnitAffectedByEffectState(class'X2StatusEffects'.default.BleedingOutName);
        if (BleedOutEffectState != none)
        {
            NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
            BleedOutEffectState = XComGameState_Effect(NewGameState.ModifyStateObject(BleedOutEffectState.Class, BleedOutEffectState.ObjectID));
            BleedOutEffectState.iTurnsRemaining += default.EMERGENCY_LIFE_SUPPORT_BONUS_BLEEDINGOUT_TURNS;
            `TACTICALRULES.SubmitGameState(NewGameState);
        }
    }

    return ELR_NoInterrupt;
}

function bool ForcesBleedout(XComGameState NewGameState, XComGameState_Unit UnitState, XComGameState_Effect EffectState)
{
    local UnitValue ELSValue;

    `PPDEBUG("EmergencyLifeSupport: Starting ForcesBleedout Check.");

    if (UnitState.GetUnitValue(default.ELSDeathUsed, ELSValue))
    {
        if (ELSValue.fValue > 0)
        {
            `PPDEBUG("EmergencyLifeSupport: Already used, failing.");
            return false;
        }
    }

    `PPDEBUG("EmergencyLifeSupport: Triggered, setting unit value.");
    UnitState.SetUnitFloatValue(default.ELSDeathUsed, 1, eCleanup_BeginTactical);

    return true;
}

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
    local UnitValue ELSValue;

    // if (TargetUnit.GetUnitValue(default.ELSStabilizeUsed, ELSValue) && ELSValue.fValue == 0)
    // {
    //     return true;
    // }

    if (TargetUnit.GetUnitValue(default.ELSDeathUsed, ELSValue) && ELSValue.fValue == 0)
    {
        return true;
    }

    return false;
}

defaultproperties
{
    EffectName = "EmergencyLifeSupport"
    ELSDeathUsed = "EmergencyLifeSupportDeathUsed"
    ELSStabilizeUsed = "EmergencyLifeSupportStabilizeUsed"
}