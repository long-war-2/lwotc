//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_BringEmOn
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up damage bonuses for BEO
//---------------------------------------------------------------------------------------
class X2Effect_BringEmOn extends X2Effect_Persistent config (LW_SoldierSkills);

var config float BEO_BONUS_CRIT_DAMAGE_PER_ENEMY;
var config int BEO_MAX_BONUS_CRIT_DAMAGE;
var config bool BEO_SQUADSIGHT_ENEMIES_APPLY;
var config bool APPLIES_TO_EXPLOSIVES;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Item SourceWeapon;
	local XComGameState_Unit TargetUnit;
	local array<StateObjectReference> arrSSEnemies;
	local int BadGuys;
	local X2AbilityToHitCalc_StandardAim StandardHit;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;
	local bool bShouldApply;

	

    if (AppliedData.AbilityResultContext.HitResult == eHit_Crit)
    {
        SourceWeapon = AbilityState.GetSourceWeapon();
        if (SourceWeapon != none)
        {
			if (AbilityState.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef)
			{
				// If the source weapon matches the weapon slot bound to the ability,
				// then the crit bonus should apply
				bShouldApply = true;
			}

			if (default.APPLIES_TO_EXPLOSIVES && CurrentDamage > 0) //add damage check on grenades function to exclude support grenades from BEM bonus. 
			{
				if (X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate()).WeaponCat == 'grenade')
				{
					// This should apply to any grenades that can crit
					bShouldApply = true;
				}

				if (class'X2Effect_BonusRocketDamage_LW'.default.VALID_ABILITIES.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE || AbilityState.GetMyTemplateName() == 'MicroMissiles')
				{
					bShouldApply = true;
				}

				StandardHit = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
				if (StandardHit != none && StandardHit.bIndirectFire)
				{
					// Grenade launchers can get the bonus crit damage too (as well as any
					// other ability/weapon that uses StandardAim with indirect fire)
					bShouldApply = true;
				}
			}

			if (!bShouldApply)
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
			TargetUnit = XComGameState_Unit(TargetDamageable);
            if (TargetUnit != none)
            {
                BadGuys = Attacker.GetNumVisibleEnemyUnits (true, false, false, -1, false, false);
				if (Attacker.HasSquadsight() && default.BEO_SQUADSIGHT_ENEMIES_APPLY)
				{
					class'X2TacticalVisibilityHelpers'.static.GetAllSquadsightEnemiesForUnit(Attacker.ObjectID, arrSSEnemies, -1, false);
					BadGuys += arrSSEnemies.length;
				}
				if (BadGuys > 0)
				{
					return clamp (BadGuys * default.BEO_BONUS_CRIT_DAMAGE_PER_ENEMY, 0, default.BEO_MAX_BONUS_CRIT_DAMAGE);
				}
            }
        }
    }
    return 0;
}

