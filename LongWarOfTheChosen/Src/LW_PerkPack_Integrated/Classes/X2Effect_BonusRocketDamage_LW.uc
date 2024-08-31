// Tedster - class to give bonus rocket damage
// This effect piggybacks on the Javelin Rockets config for abilities to give extra range.

class X2Effect_BonusRocketDamage_LW extends X2Effect_Persistent config(LW_SoldierSkills);

var config array<name> VALID_ABILITIES;

var int BonusDmg;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState) 
{
    `LWTrace("LW X2Effect_BonusRocketDamage_LW GetAttackingDamageModifier checked");
	if (!class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult) || CurrentDamage == 0)
		return 0;

    if(default.VALID_ABILITIES.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
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
