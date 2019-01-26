//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_WalkFireDamage
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Applies %-based damage penalty when using Walk Fire
//--------------------------------------------------------------------------------------

class X2Effect_WalkFireDamage extends X2Effect_Persistent config(LW_SoldierSkills);

var config float WALK_FIRE_DAMAGE_MODIFIER;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
    local float ExtraDamage;

    if(AbilityState.GetMyTemplateName() == 'WalkFire')
    {
		if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
		{
			ExtraDamage = -1 * (float(CurrentDamage) * default.WALK_FIRE_DAMAGE_MODIFIER);
		}
    }
    return int(ExtraDamage);
}