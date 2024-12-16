// Effect for ability that buffs Wraith and Justice hit chance.

class X2Effect_SkirmMeleeHitMod extends X2Effect_Persistent config(LW_FactionBalance);

var config int GRAPPLEEXPERT_HIT_MOD;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo ShotInfo;
	//if (Attacker.IsImpaired(false) || Attacker.IsBurning())
//		return;

	if (AbilityState.GetMyTemplateName() == 'SkirmisherVengeance' || AbilityState.GetMyTemplateName() == 'Justice' || AbilityState.GetMyTemplateName() == 'Whiplash')
	{
        ShotInfo.ModType = eHit_Success;
		ShotInfo.Reason = FriendlyName;
        ShotInfo.Value = GRAPPLEEXPERT_HIT_MOD;
        ShotModifiers.AddItem(ShotInfo);
    }
}
