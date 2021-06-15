class X2Effect_Formidable extends X2Effect_BonusArmor;

var float ExplosiveDamageReduction;
var int Armor_Mitigation;

function int GetArmorChance(XComGameState_Effect EffectState, XComGameState_Unit UnitState) { return 100; }
function int GetArmorMitigation(XComGameState_Effect EffectState, XComGameState_Unit UnitState) { return Armor_Mitigation; }

function float GetPostDefaultDefendingDamageModifier_CH(
	XComGameState_Effect EffectState,
	XComGameState_Unit Attacker,
	XComGameState_Unit Target,
	XComGameState_Ability AbilityState,
	const out EffectAppliedData AppliedData,
	float CurrentDamage,
	X2Effect_ApplyWeaponDamage WeaponDamageEffect,
	XComGameState NewGameState)
{
	local float DamageMod;
	local bool Explosives;
	local XComGameState_Item SourceWeapon;
	local X2WeaponTemplate WeaponTemplate;

	DamageMod = 0;
	SourceWeapon = AbilityState.GetSourceWeapon();
	if (SourceWeapon != none)
		WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());

	Explosives = false;
	if (WeaponDamageEffect.bExplosiveDamage)
		Explosives = true;
	if (WeaponDamageEffect.EffectDamageValue.DamageType == 'Explosion')
		Explosives = true;
	if (WeaponDamageEffect.DamageTypes.Find('Explosion') != -1)
		Explosives = true;
	if (WeaponDamageEffect.EffectDamageValue.DamageType == 'BlazingPinions')
		Explosives = true;
	if (WeaponDamageEffect.DamageTypes.Find('BlazingPinions') != -1)
		Explosives = true;
	if (WeaponTemplate != none && WeaponTemplate.DamageTypeTemplateName == 'Explosion')
		Explosives = true;
	if (WeaponTemplate != none && WeaponTemplate.DamageTypeTemplateName == 'BlazingPinions')
		Explosives = true;

	if (Explosives)
	{
		DamageMod = -CurrentDamage * ExplosiveDamageReduction;
	}

	return DamageMod;
}
