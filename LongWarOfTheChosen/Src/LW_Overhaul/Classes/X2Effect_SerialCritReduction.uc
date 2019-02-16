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
    if(SourceWeapon != none)
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

	Attacker.GetUnitValue ('SerialKills', UnitVal);

	if (Damage_Falloff)
	{
		return -int(UnitVal.fValue);
	}
	return 0;
}