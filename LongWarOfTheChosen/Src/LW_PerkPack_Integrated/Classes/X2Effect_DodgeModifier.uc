class X2Effect_DodgeModifier extends XMBEffect_ConditionalBonus config(LW_SoldierSkills);

var() int DodgeReductionBonus;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ShotInfo;
	local int DodgeReduction;

	if (AbilityState.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef)
	{
		DodgeReduction = Min(DodgeReductionBonus, Target.GetCurrentStat(eStat_Dodge));

		ShotInfo.ModType = eHit_Graze;
		ShotInfo.Reason = FriendlyName;
		ShotInfo.Value = -1 * DodgeReduction;
		ShotModifiers.AddItem(ShotInfo);
	}
}

defaultproperties
{
	DuplicateResponse=eDupe_Allow
	EffectName="DodgeModifier"
}
