class X2Effect_HairTrigger extends X2Effect_Persistent;

var int To_Hit_Modifier;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local XComGameState_Item				SourceWeapon;
    local ShotModifierInfo					ShotInfo;
	local X2AbilityToHitCalc_StandardAim	StandardToHit;

	SourceWeapon = AbilityState.GetSourceWeapon();
	if(SourceWeapon != none && SourceWeapon.ObjectID == EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID)
	{
        StandardToHit = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
		if (StandardToHit != none)
		{
			if (StandardToHit.bReactionFire)
			{
				ShotInfo.ModType = eHit_Success;
				ShotInfo.Reason = FriendlyName;
				ShotInfo.Value = To_Hit_Modifier;
				ShotModifiers.AddItem(ShotInfo);
			}
		}
	}
}

