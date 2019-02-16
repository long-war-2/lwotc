//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_IronCurtain
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Applies %-based damage penalty when using Iron Curtain
//--------------------------------------------------------------------------------------

class X2Effect_IronCurtain extends X2Effect_Persistent config(LW_SoldierSkills);

var config float IRON_CURTAIN_DAMAGE_MODIFIER;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
    local float ExtraDamage;

	ExtraDamage = 0.0;
    if(AbilityState.GetMyTemplateName() == 'IronCurtainShot')
    {
		if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
		{
			ExtraDamage = -1 * CurrentDamage * default.IRON_CURTAIN_DAMAGE_MODIFIER;
		}
    }
    return int(ExtraDamage);
}

