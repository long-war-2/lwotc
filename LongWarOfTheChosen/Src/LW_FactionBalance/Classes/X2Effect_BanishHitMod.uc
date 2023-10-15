//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_BanishHitMod
//  AUTHOR:  Grobobobo
//  PURPOSE: Gives a stacking -15 aim debuff to banish for each shot taken
//---------------------------------------------------------------------------------------

class X2Effect_BanishHitMod extends X2Effect_Persistent config (LW_FactionBalance);

var config int BANISH_INITIAL_HIT_MOD;
var config int BANISH_HIT_MOD;
var config int BANISH_DMG_MOD;
var config int THEBANISHER_HIT_BUFF;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo ShotInfo;
    local UnitValue UnitValue;
	//if (Attacker.IsImpaired(false) || Attacker.IsBurning())
//		return;

	if (AbilityState.GetMyTemplateName() == 'SoulReaperContinue' && AbilityState.GetMyTemplateName() == 'SoulReaper')
	{

		Attacker.GetUnitValue(class'X2LWModTemplate_ReaperAbilities'.default.BanishFiredTimes, UnitValue);

		ShotInfo.ModType = eHit_Success;
		ShotInfo.Reason = FriendlyName;
		ShotInfo.Value = default.BANISH_HIT_MOD * UnitValue.fValue + default.BANISH_INITIAL_HIT_MOD;
		
		if(Attacker.HasAbilityFromAnySource('TheBanisher_LW'))
		{
			ShotInfo.Value = (default.BANISH_HIT_MOD + THEBANISHER_HIT_BUFF) * UnitValue.fValue + default.BANISH_INITIAL_HIT_MOD;
		}
		ShotModifiers.AddItem(ShotInfo);
	}
}

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local int DamageModifier;
	local UnitValue UnitValue;

	Attacker.GetUnitValue(class'X2LWModTemplate_ReaperAbilities'.default.BanishFiredTimes, UnitValue);

	DamageModifier = UnitValue.fValue * default.BANISH_DMG_MOD;

	return max(DamageModifier, (-CurrentDamage + 1)); // cap at 1 dmg
}