// Shamelessly stolen from the LW MECs as SPARKs mod for WOTC
class X2Effect_CollateralDamage extends X2Effect_ApplyWeaponDamage config (Game_CharacterSkills);

var config float BONUS_MULT;
var config float MIN_BONUS;

var bool AllowArmor;
var bool AddBonus;

simulated function int CalculateDamageAmount(const out EffectAppliedData ApplyEffectParameters, out int ArmorMitigation, out int NewRupture, out int NewShred, out array<Name> AppliedDamageTypes, out int bAmmoIgnoresShields, out int bFullyImmune, out array<DamageModifierInfo> SpecialDamageMessages, optional XComGameState NewGameState)
{
	local int TotalDamage, WeaponDamage, DamageSpread, CritDamage, EffectDmg;

	local XComGameStateHistory History;
	local XComGameState_Unit kSourceUnit, TargetUnit;
	local XComGameState_Item kSourceItem;
	local Damageable kTarget;
	local XComGameState_Ability kAbility;
	local WeaponDamageValue BaseDamageValue;
	local int ArmorPiercing;
	local XComGameState_Effect EffectState;
	local StateObjectReference EffectRef;
	local X2Effect_Persistent EffectTemplate;

	ArmorMitigation = 0;
	NewRupture = 0;
	NewShred = BaseDamageValue.Shred;
	bAmmoIgnoresShields =	AllowArmor ? 0:  1;

	History = `XCOMHISTORY;
	kSourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));	
	kTarget = Damageable(History.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	kSourceItem = XComGameState_Item(History.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));	
	kAbility = XComGameState_Ability(History.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));	

	if (kSourceItem != none)
	{
		`log("Attacker ID:" @ kSourceUnit.ObjectID @ "With Item ID:" @ kSourceItem.ObjectID @ "Target ID:" @ ApplyEffectParameters.TargetStateObjectRef.ObjectID, true, 'XCom_HitRolls');
		if (!bIgnoreBaseDamage)
		{
			kSourceItem.GetBaseWeaponDamageValue(XComGameState_BaseObject(kTarget), BaseDamageValue);

			ModifyDamageValue(BaseDamageValue, kTarget, AppliedDamageTypes);
		}
	}

	WeaponDamage = BaseDamageValue.Damage;
	DamageSpread = BaseDamageValue.Spread;
	CritDamage = BaseDamageValue.Crit;
	NewRupture = 0;
	NewShred = BaseDamageValue.Shred;

	if (DamageSpread > 0)
	{
		WeaponDamage += DamageSpread;                          //  set to max damage based on spread
		WeaponDamage -= `SYNC_RAND(DamageSpread * 2 + 1);      //  multiply spread by 2 to get full range off base damage, add 1 as rand returns 0:x-1, not 0:x
	}
	`log("Damage with spread:" @ WeaponDamage, true, 'XCom_HitRolls');
	if (PlusOneDamage(BaseDamageValue.PlusOne))
	{
		WeaponDamage++;
		`log("Rolled for PlusOne off BaseDamage, succeeded. Damage:" @ WeaponDamage, true, 'XCom_HitRolls');
	}

	if (ApplyEffectParameters.AbilityResultContext.HitResult == eHit_Crit)
	{
		WeaponDamage += CritDamage;
		`log("CRIT! Adjusted damage:" @ WeaponDamage, true, 'XCom_HitRolls');
	}
	else if (ApplyEffectParameters.AbilityResultContext.HitResult == eHit_Graze)
	{
		WeaponDamage *= GRAZE_DMG_MULT;
		`log("GRAZE! Adjusted damage:" @ WeaponDamage, true, 'XCom_HitRolls');
	}

	if( AddBonus && kSourceUnit != none)
	{
		//  Allow attacker effects to modify damage output before applying final bonuses and reductions
		foreach kSourceUnit.AffectedByEffects(EffectRef)
		{
			EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
			EffectTemplate = EffectState.GetX2Effect();
			EffectDmg = EffectTemplate.GetAttackingDamageModifier(EffectState, kSourceUnit, kTarget, kAbility, ApplyEffectParameters, WeaponDamage, NewGameState);
			if (EffectDmg != 0)
			{
				WeaponDamage += EffectDmg;
				`log("Attacker effect" @ EffectTemplate.EffectName @ "adjusting damage by" @ EffectDmg $ ", new damage:" @ WeaponDamage, true, 'XCom_HitRolls');				
			}
		}

		//  If this is a unit, apply any effects that modify damage
		TargetUnit = XComGameState_Unit(kTarget);
		if (TargetUnit != none)
		{
			foreach TargetUnit.AffectedByEffects(EffectRef)
			{
				EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
				EffectTemplate = EffectState.GetX2Effect();
				EffectDmg = EffectTemplate.GetDefendingDamageModifier(EffectState, kSourceUnit, kTarget, kAbility, ApplyEffectParameters, WeaponDamage, self);
				if (EffectDmg != 0)
				{
					WeaponDamage += EffectDmg;
					`log("Defender effect" @ EffectTemplate.EffectName @ "adjusting damage by" @ EffectDmg $ ", new damage:" @ WeaponDamage, true, 'XCom_HitRolls');				
				}
			}
		}
	}

	TotalDamage = WeaponDamage * BONUS_MULT;

	if (TotalDamage < MIN_BONUS)
	{
		// Do not allow the damage reduction to invert the damage amount (i.e. heal instead of hurt, or vice-versa).
		TotalDamage = MIN_BONUS;
	}

	
	if (kTarget != none && AllowArmor)
	{
		ArmorMitigation = kTarget.GetArmorMitigation(ApplyEffectParameters.AbilityResultContext.ArmorMitigation);
		if (ArmorMitigation != 0)
		{
			ArmorPiercing += kSourceUnit.GetCurrentStat(eStat_ArmorPiercing);				
			`log("Armor mitigation! Target armor mitigation value:" @ ArmorMitigation @ "Attacker armor piercing value:" @ ArmorPiercing, true, 'XCom_HitRolls');
			ArmorMitigation -= ArmorPiercing;				
			if (ArmorMitigation < 0)
				ArmorMitigation = 0;
			if (ArmorMitigation >= WeaponDamage)
				ArmorMitigation = WeaponDamage - 1;
			if (ArmorMitigation < 0)    //  WeaponDamage could have been 0
				ArmorMitigation = 0;    
			`log("  Final mitigation value:" @ ArmorMitigation, true, 'XCom_HitRolls');
		}
	}
	else
	{
		ArmorMitigation = 0;    
	}

	return TotalDamage;
}

simulated function GetDamagePreview(StateObjectReference TargetRef, XComGameState_Ability AbilityState, bool bAsPrimaryTarget, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
	local XComGameStateHistory History;
	local XComGameState_Unit TargetUnit, SourceUnit;
	local XComGameState_Item SourceWeapon;
	local WeaponDamageValue BaseDamageValue;
	local X2Condition ConditionIter;
	local name AvailableCode;
	local name DamageType;
	local array<Name> AppliedDamageTypes;
	local bool bDoesDamageIgnoreShields;
	local StateObjectReference EffectRef;
	local XComGameState_Effect EffectState;
	local X2Effect_Persistent EffectTemplate;
	local int EffectDmg;
	local EffectAppliedData TestEffectParams;
	//local DamageModifierInfo DamageModInfo;

	MinDamagePreview = BaseDamageValue;
	MaxDamagePreview = BaseDamageValue;
	bDoesDamageIgnoreShields = false;

	if (!bApplyOnHit)
		return;

	History = `XCOMHISTORY;

	SourceWeapon = AbilityState.GetSourceWeapon();

	TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(TargetRef.ObjectID));
	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));

	if (TargetUnit != None)
	{
		foreach TargetConditions(ConditionIter)
		{
			AvailableCode = ConditionIter.AbilityMeetsCondition(AbilityState, TargetUnit);
			if (AvailableCode != 'AA_Success')
				return;
			AvailableCode = ConditionIter.MeetsCondition(TargetUnit);
			if (AvailableCode != 'AA_Success')
				return;
			AvailableCode = ConditionIter.MeetsConditionWithSource(TargetUnit, SourceUnit);
			if (AvailableCode != 'AA_Success')
				return;
		}
		foreach DamageTypes(DamageType)
		{
			if (TargetUnit.IsImmuneToDamage(DamageType))
				return;
		}
	}

	if (SourceWeapon != None)
	{
		SourceWeapon.GetBaseWeaponDamageValue(TargetUnit, BaseDamageValue);
		ModifyDamageValue(BaseDamageValue, TargetUnit, AppliedDamageTypes);
	}

	MinDamagePreview.Damage = BaseDamageValue.Damage - BaseDamageValue.Spread;

	MaxDamagePreview.Damage = BaseDamageValue.Damage + BaseDamageValue.Spread;

	MinDamagePreview.Pierce = AllowArmor ? 0 : 1000;
	MaxDamagePreview.Pierce = AllowArmor ? 0 : 1000;
	
	MinDamagePreview.Shred = BaseDamageValue.Shred;
	MaxDamagePreview.Shred = BaseDamageValue.Shred;

	MinDamagePreview.Rupture = 0;
	MaxDamagePreview.Rupture = 0;

	if (BaseDamageValue.PlusOne > 0)
		MaxDamagePreview.Damage++;

	if (AddBonus)
	{
		TestEffectParams.AbilityInputContext.AbilityRef = AbilityState.GetReference();
		TestEffectParams.AbilityInputContext.AbilityTemplateName = AbilityState.GetMyTemplateName();
		TestEffectParams.ItemStateObjectRef = AbilityState.SourceWeapon;
		TestEffectParams.AbilityStateObjectRef = AbilityState.GetReference();
		TestEffectParams.SourceStateObjectRef = SourceUnit.GetReference();
		TestEffectParams.PlayerStateObjectRef = SourceUnit.ControllingPlayer;
		TestEffectParams.TargetStateObjectRef = TargetRef;
		foreach SourceUnit.AffectedByEffects(EffectRef)
		{
			EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
			EffectTemplate = EffectState.GetX2Effect();

			EffectDmg = EffectTemplate.GetAttackingDamageModifier(EffectState, SourceUnit, Damageable(TargetUnit), AbilityState, TestEffectParams, MinDamagePreview.Damage);
			MinDamagePreview.Damage += EffectDmg;
			EffectDmg = EffectTemplate.GetAttackingDamageModifier(EffectState, SourceUnit, Damageable(TargetUnit), AbilityState, TestEffectParams, MaxDamagePreview.Damage);
			MaxDamagePreview.Damage += EffectDmg;
		}
		if (TargetUnit != none)
		{
			foreach TargetUnit.AffectedByEffects(EffectRef)
			{
				EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
				EffectTemplate = EffectState.GetX2Effect();
				EffectDmg = EffectTemplate.GetDefendingDamageModifier(EffectState, SourceUnit, Damageable(TargetUnit), AbilityState, TestEffectParams, MinDamagePreview.Damage, self);
				MinDamagePreview.Damage += EffectDmg;
				EffectDmg = EffectTemplate.GetDefendingDamageModifier(EffectState, SourceUnit, Damageable(TargetUnit), AbilityState, TestEffectParams, MaxDamagePreview.Damage, self);
				MaxDamagePreview.Damage += EffectDmg;
			}
		}
	}

	MinDamagePreview.Damage = max(MinDamagePreview.Damage * BONUS_MULT, MIN_BONUS);

	MaxDamagePreview.Damage = max(MaxDamagePreview.Damage * BONUS_MULT, MIN_BONUS);

	if (!bDoesDamageIgnoreShields)
		AllowsShield += MaxDamagePreview.Damage;
}

