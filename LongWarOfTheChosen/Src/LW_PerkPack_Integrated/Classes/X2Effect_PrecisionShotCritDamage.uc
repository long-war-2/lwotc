class X2Effect_PrecisionShotCritDamage extends X2Effect_Persistent config(LW_SoldierSkills);

var config float PRECISION_SHOT_CRIT_DAMAGE_MODIFIER;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
    local float ExtraDamage;
	
    if(AbilityState.GetMyTemplateName() == 'PrecisionShot')
    {
		//`LOG ("Checking PS");
		if(AppliedData.AbilityResultContext.HitResult == eHit_Crit)
		{
			ExtraDamage = Max (1, (float(CurrentDamage) * default.PRECISION_SHOT_CRIT_DAMAGE_MODIFIER));
			//`LOG ("Precision Shot Current/Extra Damage" @ CurrentDamage @ ExtraDamage);
		}
    }
    return ExtraDamage;
}