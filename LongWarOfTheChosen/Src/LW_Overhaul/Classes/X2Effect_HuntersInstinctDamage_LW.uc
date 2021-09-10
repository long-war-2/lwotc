class X2Effect_HuntersInstinctDamage_LW extends X2Effect_HuntersInstinctDamage;

//Overwrites GADM to add CurrentDamage > 0 modifier so flashbangs don't get bonus
var float HUNTERS_INSTINCT_DAMAGE_PCT;
function float GetPostDefaultDefendingDamageModifier_CH(
	XComGameState_Effect EffectState,
	XComGameState_Unit SourceUnit,
	XComGameState_Unit TargetUnit,
	XComGameState_Ability AbilityState,
	const out EffectAppliedData ApplyEffectParameters,
	float WeaponDamage,
	X2Effect_ApplyWeaponDamage WeaponDamageEffect,
	XComGameState NewGameState)
{
	local GameRulesCache_VisibilityInfo VisInfo;
	local bool DamagingAttack;
	local X2AbilityToHitCalc_StandardAim StandardHit;

	DamagingAttack = (X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate()).BaseDamage.Damage > 0 || X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate()).BaseDamage.PlusOne > 0);

	if (X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate()).WeaponCat == 'grenade')
	{
		return 0;
	}
	if (AbilityState.GetMyTemplateName() == 'LWRocketLauncher' || AbilityState.GetMyTemplateName() == 'LWBlasterLauncher' || AbilityState.GetMyTemplateName() == 'MicroMissiles')
	{
		return 0;
	}
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
	if (!AbilityState.IsMeleeAbility() && TargetUnit != None && class'XComGameStateContext_Ability'.static.IsHitResultHit(ApplyEffectParameters.AbilityResultContext.HitResult))
	{
		if (`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(SourceUnit.ObjectID, TargetUnit.ObjectID, VisInfo))
		{
			if (SourceUnit.CanFlank() && TargetUnit.GetMyTemplate().bCanTakeCover && (VisInfo.TargetCover == CT_None || TargetUnit.GetCurrentStat(eStat_AlertLevel) == 0 && TargetUnit.GetTeam() != eTeam_XCom) && DamagingAttack)
			{
				return WeaponDamage * default.HUNTERS_INSTINCT_DAMAGE_PCT;
			}
		}
	}
	return 0;
}

DefaultProperties
{
	DuplicateResponse = eDupe_Ignore
}
