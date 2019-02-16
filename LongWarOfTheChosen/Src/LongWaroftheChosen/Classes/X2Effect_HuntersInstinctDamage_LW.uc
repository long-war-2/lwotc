class X2Effect_HuntersInstinctDamage_LW extends X2Effect_HuntersInstinctDamage;

//Overwrites GADM to add CurrentDamage > 0 modifier so flashbangs don't get bonus

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Unit TargetUnit;
	local GameRulesCache_VisibilityInfo VisInfo;
	local bool DamagingAttack;
	local X2AbilityToHitCalc_StandardAim StandardHit;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;

	TargetUnit = XComGameState_Unit(TargetDamageable);
	DamagingAttack = (X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate()).BaseDamage.Damage > 0 || X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate()).BaseDamage.PlusOne > 0);

	if (X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate()).WeaponCat == 'grenade')
	{
		return 0;
	}
	if (AbilityState.GetMyTemplateName() == 'LWRocketLauncher' || AbilityState.GetMyTemplateName() == 'LWBlasterLauncher' || AbilityState.GetMyTemplateName() == 'MicroMissiles')
	{
		return 0;
	}
	WeaponDamageEffect = X2Effect_ApplyWeaponDamage(class'X2Effect'.static.GetX2Effect(AppliedData.EffectRef));
	if (WeaponDamageEffect != none)
	{
		if (WeaponDamageEffect.bIgnoreBaseDamage)
		{
			return 0;
		}
	}

	StandardHit = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
	if(StandardHit != none && StandardHit.bIndirectFire)
	{
		return 0;
	}
	if (!AbilityState.IsMeleeAbility() && TargetUnit != None && class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))
	{
		if (`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(Attacker.ObjectID, TargetUnit.ObjectID, VisInfo))
		{
			if (Attacker.CanFlank() && TargetUnit.GetMyTemplate().bCanTakeCover && (VisInfo.TargetCover == CT_None || TargetUnit.GetCurrentStat(eStat_AlertLevel) == 0) && DamagingAttack)
			{
				return BonusDamage;
			}
		}
	}
	return 0;
}

DefaultProperties
{
	DuplicateResponse = eDupe_Ignore
}
