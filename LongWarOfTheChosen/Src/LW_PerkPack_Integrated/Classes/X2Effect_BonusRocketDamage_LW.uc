// Tedster - class to give bonus rocket damage

class X2Effect_BonusRocketDamage_LW extends X2Effect_Persistent;

var int BonusDmg;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState) 
{
    `LWTrace("LW X2Effect_BonusRocketDamage_LW GetAttackingDamageModifier checked");
	if (!class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult) || CurrentDamage == 0)
		return 0;

    if(AbilityState.GetMyTemplateName() == 'LWRocketLauncher' || AbilityState.GetMyTemplateName() == 'LWBlasterLauncher' )
    {
        return BonusDmg;
    }

	return 0; 
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
	bDisplayInSpecialDamageMessageUI = true
}
