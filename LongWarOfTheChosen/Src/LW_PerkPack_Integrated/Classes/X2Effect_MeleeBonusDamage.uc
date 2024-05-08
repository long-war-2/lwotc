class X2Effect_MeleeBonusDamage extends X2Effect_Persistent;

var int BonusDamageFlat;
var float BonusDamageMultiplier;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState) 
{ 
	if(AbilityState.GetMyTemplate().IsMelee())
	{
		return CurrentDamage * BonusDamageMultiplier + BonusDamageFlat;
	}
	return 0; 
}