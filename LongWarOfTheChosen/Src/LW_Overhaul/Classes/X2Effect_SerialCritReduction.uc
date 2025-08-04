class X2Effect_SerialCritReduction extends X2Effect_Persistent;

var int CritReductionPerKill;
var int AimReductionPerKill;
var bool Damage_Falloff;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo ModInfo;
    local XComGameState_Item SourceWeapon;
    local UnitValue UnitVal;
	local int CritReduction, AimReduction;

	Attacker.GetUnitValue ('SerialKills', UnitVal);
	CritReduction = CritReductionPerKill * UnitVal.fValue;
	AimReduction = AimReductionPerKill * UnitVal.fValue;

    SourceWeapon = AbilityState.GetSourceWeapon();
    if(SourceWeapon != none && SourceWeapon.ObjectID == Attacker.GetPrimaryWeapon().ObjectID)
    {
        ModInfo.ModType = eHit_Crit;
        ModInfo.Reason = FriendlyName;
        ModInfo.Value = -CritReduction;
        ShotModifiers.AddItem(ModInfo);

		ModInfo.ModType = eHit_Success;
        ModInfo.Reason = FriendlyName;
        ModInfo.Value = -AimReduction;
        ShotModifiers.AddItem(ModInfo);
    }
}


function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local UnitValue UnitVal;

    // Short circuit if no hit
    if (!class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult) || CurrentDamage == 0)
		return 0;

    // Only apply to primary weapon
    if (AbilityState.SourceWeapon.ObjectID != Attacker.GetPrimaryWeapon().ObjectID)
		return 0;

	if (Damage_Falloff)
	{
        Attacker.GetUnitValue ('SerialKills', UnitVal);
        return max(-int(UnitVal.fValue), (-CurrentDamage + 1));
	}
	return 0;
}