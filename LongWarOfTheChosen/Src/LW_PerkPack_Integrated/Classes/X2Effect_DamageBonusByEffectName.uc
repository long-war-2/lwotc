class X2Effect_DamageBonusByEffectName extends X2Effect_Persistent;

struct DamageBonusByEffectName
{
    var name RequiredEffect;
    var int DamageBonus;
};

var array<DamageBonusByEffectName> DamageBonuses;
var bool bMatchSourceWeapon;

function AddDamageBonus(name RequiredEffect, int DamageBonus)
{
    local DamageBonusByEffectName NewBonus;

    NewBonus.RequiredEffect = RequiredEffect;
    NewBonus.DamageBonus = DamageBonus;

    DamageBonuses.AddItem(NewBonus);
}

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState) 
{
    local XComGameStateHistory              History;
    local XComGameStateContext_TickEffect   Context;
    local XComGameState_Effect              TickedEffectState;
    local X2Effect_Persistent               TickedEffect;
    local int                               Index;

    if (CurrentDamage <= 0)
        return 0;

    if (AppliedData.EffectRef.ApplyOnTickIndex == INDEX_NONE)
        return 0;

    if (NewGameState == none)
        return 0;

    Context = XComGameStateContext_TickEffect(NewGameState.GetContext());
    if (Context == none)
        return 0;

    History = `XCOMHISTORY;

    TickedEffectState = XComGameState_Effect(NewGameState.GetGameStateForObjectID(Context.TickedEffect.ObjectID));
    if (TickedEffectState == none)
        TickedEffectState = XComGameState_Effect(History.GetGameStateForObjectID(Context.TickedEffect.ObjectID));

    if (TickedEffectState == none)
        return 0;

    if (bMatchSourceWeapon && EffectState.ApplyEffectParameters.ItemStateObjectRef != TickedEffectState.ApplyEffectParameters.ItemStateObjectRef)
        return 0;

    TickedEffect = TickedEffectState.GetX2Effect();
    Index = DamageBonuses.Find('RequiredEffect', TickedEffect.EffectName);
    if (Index != INDEX_NONE)
    {
        return DamageBonuses[Index].DamageBonus;
    }

    return 0;
}