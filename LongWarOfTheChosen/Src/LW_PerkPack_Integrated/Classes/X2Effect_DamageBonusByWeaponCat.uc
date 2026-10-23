class X2Effect_DamageBonusByWeaponCat extends X2Effect_Persistent;

struct DamageBonusByWeaponCat
{
    var name WeaponCat;
    var int DamageBonus;
};

var array<DamageBonusByWeaponCat> DamageBonuses;

function AddDamageBonus(name WeaponCat, int DamageBonus)
{
    local DamageBonusByWeaponCat NewBonus;

    NewBonus.WeaponCat = WeaponCat;
    NewBonus.DamageBonus = DamageBonus;

    DamageBonuses.AddItem(NewBonus);
}

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState) 
{
    local XComGameState_Item SourceWeapon;
    local int Index;

    if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
    {
        if (CurrentDamage > 0)
        {
            SourceWeapon = AbilityState.GetSourceWeapon();

            if (SourceWeapon != none)
            {
                Index = DamageBonuses.Find('WeaponCat', SourceWeapon.GetWeaponCategory());
                if (Index != INDEX_NONE)
                {
                    return DamageBonuses[Index].DamageBonus;
                }

            }
        }
    }

    return 0;
}