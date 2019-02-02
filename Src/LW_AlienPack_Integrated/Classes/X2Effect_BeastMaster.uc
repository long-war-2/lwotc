//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_Beastmaster.uc
//  AUTHOR:	 John Lumpkin (Pavonis Interactive)
//  PURPOSE: Creates Beastmaster effect, which makes Centurions immune to damage from Berserkers
//--------------------------------------------------------------------------------------- 
class X2Effect_Beastmaster extends X2Effect_BonusArmor;

function int GetDefendingDamageModifier (
		XComGameState_Effect EffectState,
		XComGameState_Unit Attacker,
		Damageable TargetDamageable,
		XComGameState_Ability AbilityState,
		const out EffectAppliedData AppliedData,
		const int CurrentDamage,
		X2Effect_ApplyWeaponDamage WeaponDamageEffect,
		optional XComGameState NewGameState)
{
	local int	DamageMod;

	DamageMod = 0;
	if (Attacker.GetMyTemplate().CharacterGroupName == 'Berserker')
	{
		DamageMod = -CurrentDamage;
	}
	return DamageMod;
}

