class X2Effect_ThermalShock extends X2Effect_Persistent config(GameData_WeaponData);

var int Bonus;
var config array<name> FireWeapons, IceWeapons;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{ 
	local XComGameState_Unit Target;
	local array<name> AppliedDamageTypes;
	local name DamageType;
	local X2Effect_ApplyWeaponDamage ApplyDamageEffect;

	Target = XComGameState_Unit(TargetDamageable);
	if ( Target == none ) { return 0; }

	if ( Target.IsBurning() || Target.IsImmuneToDamage('Fire'))
	{
		if (IceWeapons.Find(AbilityState.GetSourceWeapon().GetMyTemplateName()) != INDEX_NONE || IceWeapons.Find(AbilityState.GetSourceAmmo().GetMyTemplateName()) != INDEX_NONE )
		{
			return Bonus;
		}

		ApplyDamageEffect = X2Effect_ApplyWeaponDamage(class'X2Effect'.static.GetX2Effect(AppliedData.EffectRef));
		if (ApplyDamageEffect != none)
		{
			ApplyDamageEffect.GetEffectDamageTypes(NewGameState, AppliedData, AppliedDamageTypes);

			foreach AppliedDamageTypes(DamageType)
			{
				if (DamageType=='Frost' && !TargetDamageable.IsImmuneToDamage(DamageType))
				{
					return Bonus;
				}
			}
		}
	}

	if ( Target.IsUnitAffectedByEffectName('LWChill') || Target.IsFrozen() || Target.IsUnitAffectedByEffectName('Chilled') || Target.IsImmuneToDamage('Frost') )
	{
		if (FireWeapons.Find(AbilityState.GetSourceWeapon().GetMyTemplateName()) != INDEX_NONE || FireWeapons.Find(AbilityState.GetSourceAmmo().GetMyTemplateName()) != INDEX_NONE)
		{
			return Bonus;
		}

		ApplyDamageEffect = X2Effect_ApplyWeaponDamage(class'X2Effect'.static.GetX2Effect(AppliedData.EffectRef));
		if (ApplyDamageEffect != none)
		{
			ApplyDamageEffect.GetEffectDamageTypes(NewGameState, AppliedData, AppliedDamageTypes);

			foreach AppliedDamageTypes(DamageType)
			{
				if ((DamageType=='Fire' || DamageType=='Napalm' || DamageType=='BlazingPinions') && !TargetDamageable.IsImmuneToDamage(DamageType))
				{
					return Bonus;
				}
			}
		}
	}

	return 0;
}