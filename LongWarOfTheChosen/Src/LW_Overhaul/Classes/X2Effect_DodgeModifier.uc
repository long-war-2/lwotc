class X2Effect_DodgeModifier extends X2Effect_Persistent config(LW_SoldierSkills);

var config int ANTIDODGE_BONUS;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local XComGameState_Item SourceWeapon;
	local ShotModifierInfo ShotInfo;
	local int DodgeReduction;

	SourceWeapon = AbilityState.GetSourceWeapon();
	if(SourceWeapon != none)
	{
			DodgeReduction = default.ANTIDODGE_BONUS;
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
