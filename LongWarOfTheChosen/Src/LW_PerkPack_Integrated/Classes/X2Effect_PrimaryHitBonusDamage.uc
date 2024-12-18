class X2Effect_PrimaryHitBonusDamage extends X2Effect_Persistent;

var int BonusDmg;
var bool includepistols;
var bool includesos;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local X2WeaponTemplate WeaponTemplate;
    local X2AbilityToHitCalc_StandardAim StandardHit;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;

	if (class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult) && CurrentDamage > 0)
	{ 
		WeaponDamageEffect = X2Effect_ApplyWeaponDamage(class'X2Effect'.static.GetX2Effect(AppliedData.EffectRef));
		if (WeaponDamageEffect != none)
		{			
			if (WeaponDamageEffect.bIgnoreBaseDamage)
			{	
				return 0;		
			}
		}
		WeaponTemplate = X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate());
		if (WeaponTemplate.weaponcat == 'grenade')
		{
			return 0;
		}
		if (class'X2Effect_BonusRocketDamage_LW'.default.VALID_ABILITIES.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE || AbilityState.GetMyTemplateName() == 'MicroMissiles')
		{
			return 0;
		}
		StandardHit = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
		if (StandardHit != none && StandardHit.bIndirectFire)
		{
			return 0;
		}		
		if (AbilityState.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef)
		{
			if (AppliedData.AbilityResultContext.HitResult == eHit_Crit && BonusDmg > 1)
			{
				return BonusDmg + (BonusDmg / 2);
			}			
			else
			{
				return BonusDmg;
			}
		}
		WeaponTemplate = X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate());
		if (WeaponTemplate != none)
		{
			if ((WeaponTemplate.weaponcat == 'pistol' || WeaponTemplate.weaponcat == 'sidearm') && includepistols)
			{
				return BonusDmg;
			}
			if (WeaponTemplate.weaponcat == 'sawedoffshotgun' && includesos && AbilityState.GetMyTemplateName() == 'BothBarrels')
			{
				return BonusDmg*2;
			}
			if (WeaponTemplate.weaponcat == 'sawedoffshotgun' && includesos)
			{
				return BonusDmg;
			}
		}
	}
	return 0;
}
