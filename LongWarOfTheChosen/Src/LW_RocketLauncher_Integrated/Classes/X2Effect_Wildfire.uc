class X2Effect_Wildfire extends X2Effect_Persistent;

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{	
	local X2AbilityToHitCalc_StandardAim AttackToHit;
	local ShotModifierInfo ModInfo;

	AttackToHit = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
	if (AttackToHit != none && AttackToHit.bReactionFire)
	{
		ModInfo.ModType = eHit_Success;
		ModInfo.Reason = FriendlyName;
		ModInfo.Value = class'X2Rocket_Napalm'.default.REACTION_FIRE_BONUS_AIM;
		ShotModifiers.AddItem(ModInfo);

	}
}