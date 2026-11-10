class X2AbilityToHitCalc_StatCheck_DamageTag extends X2AbilityToHitCalc_StatCheck;

var ECharStatType DefenderStat;
var name AttackerDamageTag;

function int GetAttackValue(XComGameState_Ability kAbility, StateObjectReference TargetRef)
{
    local XComGameState_Item        SourceWeapon;
    local XComGameState_BaseObject  TargetObject;
    local WeaponDamageValue         DamageValue;

    SourceWeapon = kAbility.GetSourceWeapon();
    if (SourceWeapon != none && AttackerDamageTag != '')
    {
        TargetObject = `XCOMHISTORY.GetGameStateForObjectID(TargetRef.ObjectID);
        SourceWeapon.GetWeaponDamageValue(TargetObject, AttackerDamageTag, DamageValue);
    }

    return DamageValue.Damage;
}

function int GetDefendValue(XComGameState_Ability kAbility, StateObjectReference TargetRef)
{
    local XComGameState_Unit TargetState;

    TargetState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(TargetRef.ObjectID));
    return TargetState.GetCurrentStat(DefenderStat);
}

function string GetAttackString() { return ""; }
function string GetDefendString() { return class'X2TacticalGameRulesetDataStructures'.default.m_aCharStatLabels[DefenderStat]; }

DefaultProperties
{
    DefenderStat = eStat_Will
}