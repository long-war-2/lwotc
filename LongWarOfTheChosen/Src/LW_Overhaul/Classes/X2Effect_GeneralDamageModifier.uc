class X2Effect_GeneralDamageModifier extends X2Effect_Persistent;

var  float DamageModifier;
var name AbilityTemplate;
function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
    local float ExtraDamage;

	ExtraDamage = 0.0;
    if(AbilityState.GetMyTemplateName() == AbilityTemplate||AbilityState.GetMyTemplateName() == 'AllAbilities')
    {
		if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
		{
			ExtraDamage = CurrentDamage * DamageModifier;
		}
    }
    return int(ExtraDamage);
}


defaultproperties
{
  AbilityTemplate="AllAbilities"
}

