//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_BanishHitMod
//  AUTHOR:  Grobobobo
//  PURPOSE: Gives a stacking -15 aim debuff to banish for each shot taken
//---------------------------------------------------------------------------------------

class X2Effect_BanishHitMod extends X2Effect_Persistent config (LW_FactionBalance);

var config int BANISH_HIT_MOD;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo ShotInfo;
    local UnitValue UnitValue;
	//if (Attacker.IsImpaired(false) || Attacker.IsBurning())
//		return;

	if (AbilityState.GetMyTemplateName() == 'SoulReaperContinue')
	{

        Attacker.GetUnitValue(class'X2LWModTemplate_ReaperAbilities'.default.BanishFiredTimes,UnitValue);

		ShotInfo.ModType = eHit_Success;
		ShotInfo.Reason = FriendlyName;
        ShotInfo.Value = default.BANISH_HIT_MOD * UnitValue.fValue;
		ShotModifiers.AddItem(ShotInfo);
	}
}