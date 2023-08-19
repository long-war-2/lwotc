//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_LWHoloTarget.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Basic LW version of holotargeting effect
//---------------------------------------------------------------------------------------
class X2Effect_LWHoloTarget extends X2Effect_Persistent config(LW_SoldierSkills);

var config int INDEPENDENT_TARGETING_NUM_BONUS_TURNS;
var config int HOLO_CV_AIM_BONUS;
var config int HOLO_MG_AIM_BONUS;
var config int HOLO_BM_AIM_BONUS;
var config int HDHOLO_CV_CRIT_BONUS;
var config int HDHOLO_MG_CRIT_BONUS;
var config int HDHOLO_BM_CRIT_BONUS;

var localized string HoloTargetEffectName;

//implements independent targeting
//simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
//{
//	local XComGameState_Unit		SourceUnit;
//	local XComGameStateHistory		History;
//
//	History = `XCOMHISTORY;
//	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(NewEffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
//	if(SourceUnit.FindAbility('IndependentTracking').ObjectID > 0)
//		NewEffectState.iTurnsRemaining += default.INDEPENDENT_TARGETING_NUM_BONUS_TURNS; 
//	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
//}

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local XComGameStateHistory		History;
	local ShotModifierInfo			ModInfo;
	local XComGameState_Item		SourceWeapon;
	local XComGameState_Unit		SourceUnit;
	local X2WeaponTemplate			WeaponTemplate;
	local int						Bonus;

	History = `XCOMHISTORY;
	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	SourceWeapon = XComGameState_Item(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID));
	if(SourceWeapon != none)
		WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
	if(WeaponTemplate != none && SourceUnit != none)
	{
		Bonus = default.HOLO_CV_AIM_BONUS;
		switch (WeaponTemplate.WeaponTech)
		{		
			case 'Conventional':	Bonus = default.HOLO_CV_AIM_BONUS; break;
			case 'Magnetic':		Bonus = default.HOLO_MG_AIM_BONUS; break;
			case 'Beam':			Bonus = default.HOLO_BM_AIM_BONUS; break;
			default: break;
		}

		ModInfo.ModType = eHit_Success;
		ModInfo.Reason = FriendlyName;
		ModInfo.Value = Bonus;
		ShotModifiers.AddItem(ModInfo);

		//`LOG("Holotargeting: HDHolo Source Unit = " $ SourceUnit.GetFullName());
		//implements HDHolo
		if (SourceUnit.FindAbility('HDHolo').ObjectID > 0)
		{
			Bonus = default.HDHOLO_CV_CRIT_BONUS;
			switch (WeaponTemplate.WeaponTech)
			{		
				case 'Conventional':	Bonus = default.HDHOLO_CV_CRIT_BONUS; break;
				case 'Magnetic':		Bonus = default.HDHOLO_MG_CRIT_BONUS; break;
				case 'Beam':			Bonus = default.HDHOLO_BM_CRIT_BONUS; break;
				default: break;
			}
			ModInfo.ModType = eHit_Crit;
			ModInfo.Reason = FriendlyName;
			ModInfo.Value = Bonus;
			ShotModifiers.AddItem(ModInfo);
		}
	}
}

function bool IsThisEffectBetterThanExistingEffect(const out XComGameState_Effect ExistingEffect)
{
	return true;
}

function bool HasOnlySingleTargetDamage(XComGameState_Ability AbilityState)
{
 local X2AbilityTemplate   AbilityTemplate;
 local X2Effect     AbilityEffect;
 local bool      bHasSingleTargetDamage, bHasMultiTargetDamage;

 if (AbilityState != none)
 {
  AbilityTemplate = AbilityState.GetMyTemplate();
  if (AbilityTemplate != none)
  {
   foreach AbilityTemplate.AbilityTargetEffects(AbilityEffect)
   {
    if (X2Effect_ApplyWeaponDamage(AbilityEffect) != none)
    {
     bHasSingleTargetDamage = true;
    }
   }
   foreach AbilityTemplate.AbilityMultiTargetEffects(AbilityEffect)
   {
    if (X2Effect_ApplyWeaponDamage(AbilityEffect) != none)
    {
     bHasMultiTargetDamage = true;
    }
   }
  }
 }
 return (bHasSingleTargetDamage && !bHasMultiTargetDamage);
}

//implements VitalPointTargeting
function int GetDefendingDamageModifier(
		XComGameState_Effect EffectState,
		XComGameState_Unit Attacker,
		Damageable TargetDamageable,
		XComGameState_Ability AbilityState,
		const out EffectAppliedData AppliedData,
		const int CurrentDamage,
		X2Effect_ApplyWeaponDamage WeaponDamageEffect,
		optional XComGameState NewGameState)
{
	local int DamageMod, iRoll;
	local XComGameStateHistory		History;
	local XComGameState_Item		SourceWeapon;
	local XComGameState_Unit		SourceUnit;
	local X2WeaponTemplate			WeaponTemplate;
	local bool DamagingAttack;

	History = `XCOMHISTORY;
	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	SourceWeapon = XComGameState_Item(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID)); // Holotargeter
	if(SourceWeapon != none)
		WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());

	DamagingAttack = (X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate()).BaseDamage.Damage > 0 || X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate()).BaseDamage.PlusOne > 0); // attacking weapon
	
	//`LOG ("VPT:" @ AbilityState.GetSourceWeapon().GetMyTemplate() @ CurrentDamage @ AppliedData.AbilityResultContext.CalculatedHitChance);
	
	if(WeaponTemplate != none && SourceUnit != none)
	{
		//`log ("VPT 2");
		//`LOG("Holotargeting: VitalPointTargeting Source Unit = " $ SourceUnit.GetFullName());
		if(SourceUnit.FindAbility('VitalPointTargeting').ObjectID > 0)
		{
			//`log ("VPT 3");
			if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult) && DamagingAttack)
			{
				//`log ("VPT 4" @ X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate()).BaseDamage.DamageType);
				if (HasOnlySingleTargetDamage (AbilityState) && X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate()).BaseDamage.DamageType == 'Melee' || instr (string (X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate()).BaseDamage.DamageType), "Projectile") != -1)
				{
					//`LOG ("VPT Pass: Applying Bonus Damage");
					DamageMod = WeaponTemplate.BaseDamage.Damage;
					if (WeaponTemplate.BaseDamage.PlusOne > 0)
					{
						//`LOG ("VPT Plus One check");
						iRoll = `SYNC_RAND(100);
						if (iRoll < WeaponTemplate.BaseDamage.PlusOne && AppliedData.AbilityResultContext.CalculatedHitChance > 0)
						{
							//`LOG ("VPT Plus One pass");
							DamageMod += 1;
						}
					}
				}
			}
		}
	}
	return DamageMod;
}

DefaultProperties
{
	EffectName = "LWHoloTarget"
	DuplicateResponse = eDupe_Refresh;
	bApplyOnHit = true;
	bApplyOnMiss = true;
}