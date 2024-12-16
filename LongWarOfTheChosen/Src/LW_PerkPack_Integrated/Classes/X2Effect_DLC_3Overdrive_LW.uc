// author: Tedster

// version of Overdrive effect that limits it to its localization of Standard Shots

class X2Effect_DLC_3Overdrive_LW extends X2Effect_DLC_3Overdrive;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ShotInfo;
	local UnitValue OverdriveValue;
	local X2AbilityToHitCalc_StandardAim StandardHit;

	if (Attacker.HasSoldierAbility('AdaptiveAim'))
		return;

	StandardHit = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
	if(StandardHit != none && StandardHit.bIndirectFire) 
			return;

    if (AbilityState.SourceWeapon.ObjectID != Attacker.GetPrimaryWeapon().ObjectID)
		return;

	if (Attacker.GetUnitValue(default.OverdriveUnitValue, OverdriveValue))
	{
		ShotInfo.ModType = eHit_Success;
		ShotInfo.Reason = FriendlyName;
		ShotInfo.Value = OverdriveValue.fValue * default.ShotModifier;
		ShotModifiers.AddItem(ShotInfo);
	}
}