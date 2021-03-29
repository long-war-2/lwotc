class X2Effect_MovingTarget_LW extends X2Effect_Persistent config (LW_SoldierSkills);

var config int MT_DEFENSE;
var config int MT_DODGE;

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ShotInfo;

	//if (Target.IsImpaired(false) || Target.IsBurning() || Target.IsPanicked())
	//	return;

	if (X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc) != none)
	{
		if (X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc).bReactionFire)
		{

			ShotInfo.ModType = eHit_Success;
			ShotInfo.Reason = FriendlyName;
			ShotInfo.Value = -default.MT_DEFENSE;
			ShotModifiers.AddItem(ShotInfo);

            ShotInfo.ModType = eHit_Graze;
			ShotInfo.Reason = FriendlyName;
			ShotInfo.Value = default.MT_DODGE;
			ShotModifiers.AddItem(ShotInfo);
		}
	}
}
