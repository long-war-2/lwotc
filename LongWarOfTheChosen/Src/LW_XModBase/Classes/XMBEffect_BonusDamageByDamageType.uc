//---------------------------------------------------------------------------------------
//  FILE:    BonusDamageByDamageType.uc
//  AUTHOR:  xylthixlm
//
//  Adds bonus damage to damaging effects with a certain damage type or types. This
//  counts both effects which actually deal that damage type, and things like grenades
//  and ammo which actually do generic damage but apply a typed damage-over-time effect.
//
//  EXAMPLES
//
//  The following examples in Examples.uc use this class:
//
//  Pyromaniac
//
//  INSTALLATION
//
//  Install the XModBase core as described in readme.txt. Copy this file, and any files 
//  listed as dependencies, into your mod's Classes/ folder. You may edit this file.
//
//  DEPENDENCIES
//
//  None.
//---------------------------------------------------------------------------------------
class XMBEffect_BonusDamageByDamageType extends X2Effect_Persistent config(GameData_SoldierSkills);


//////////////////////
// Bonus properties //
//////////////////////

var int DamageBonus;						// The amount of damage to add per instance of damage.


//////////////////////////
// Condition properties //
//////////////////////////

var array<name> RequiredDamageTypes;		// Damage types which will have the bonus damage applied.



////////////////////////////
// Overrideable functions //
////////////////////////////

function int GetDamageBonus(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	return DamageBonus;
}


////////////////////
// Implementation //
////////////////////

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local array<name> AppliedDamageTypes;
	local name DamageType;
	local X2Effect_ApplyWeaponDamage ApplyDamageEffect;
	local XComGameStateHistory History;
	local XComGameState_Item WeaponState, AmmoState;
	local X2AbilityTemplate Ability;
	local array<X2Effect> WeaponEffects;
	local X2Effect Effect;
	local X2Effect_Persistent PersistentEffect;

	if (!class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
		return 0;

	History = `XCOMHISTORY;

	Ability = AbilityState.GetMyTemplate();

	if (Ability.bUseThrownGrenadeEffects)
	{
		WeaponState = XComGameState_Item(History.GetGameStateForObjectID(AppliedData.ItemStateObjectRef.ObjectID));
		if (WeaponState != none)
			WeaponEffects = X2GrenadeTemplate(WeaponState.GetMyTemplate()).ThrownGrenadeEffects;
	}
	else if (Ability.bUseLaunchedGrenadeEffects)
	{
		WeaponState = AbilityState.GetSourceAmmo();
		if (WeaponState != none)
			WeaponEffects = X2GrenadeTemplate(WeaponState.GetMyTemplate()).LaunchedGrenadeEffects;
	}
	else if (Ability.bAllowAmmoEffects)
	{
		WeaponState = XComGameState_Item(History.GetGameStateForObjectID(AppliedData.ItemStateObjectRef.ObjectID));
		if (WeaponState != none && WeaponState.HasLoadedAmmo())
		{
			AmmoState = XComGameState_Item(History.GetGameStateForObjectID(WeaponState.LoadedAmmo.ObjectID));
			WeaponEffects = X2AmmoTemplate(AmmoState.GetMyTemplate()).TargetEffects;
		}
	}

	// Grenades and special ammo don't actually deal elemental damage. Check for the damage over time.
	foreach WeaponEffects(Effect)
	{
		PersistentEffect = X2Effect_Persistent(Effect);
		if (PersistentEffect != none && PersistentEffect.ApplyOnTick.Length > 0)
		{
			ApplyDamageEffect = X2Effect_ApplyWeaponDamage(PersistentEffect.ApplyOnTick[0]);
			if (ApplyDamageEffect != none)
			{ 
				DamageType = ApplyDamageEffect.EffectDamageValue.DamageType;
				if (RequiredDamageTypes.Find(DamageType) != INDEX_NONE && !TargetDamageable.IsImmuneToDamage(DamageType))
					return GetDamageBonus(EffectState, Attacker, TargetDamageable, AbilityState, AppliedData, CurrentDamage, NewGameState);
			}
		}
	}

	// Check for effects that actually deal elemental damage. This includes damage over time on-tick effects.
	ApplyDamageEffect = X2Effect_ApplyWeaponDamage(class'X2Effect'.static.GetX2Effect(AppliedData.EffectRef));
	if (ApplyDamageEffect != none)
	{
		ApplyDamageEffect.GetEffectDamageTypes(NewGameState, AppliedData, AppliedDamageTypes);

		foreach AppliedDamageTypes(DamageType)
		{
			if (RequiredDamageTypes.Find(DamageType) != INDEX_NONE && !TargetDamageable.IsImmuneToDamage(DamageType))
			{
				return GetDamageBonus(EffectState, Attacker, TargetDamageable, AbilityState, AppliedData, CurrentDamage, NewGameState);
			}
		}
	}

	return 0;
}
