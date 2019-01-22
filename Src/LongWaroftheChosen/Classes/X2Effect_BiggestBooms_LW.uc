// Adds check for actual damage before applying crit to prevent 

class X2Effect_BiggestBooms_LW extends X2Effect_BiggestBooms;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
    local X2AbilityToHitCalc_StandardAim StandardHit;
	local bool Explosives;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;

	if(AppliedData.AbilityResultContext.HitResult == eHit_Crit)
	{
		StandardHit = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
		if(StandardHit != none && StandardHit.bIndirectFire) 
		{
			Explosives = true;
		}
		if (AbilityState.GetMyTemplateName() == 'LWRocketLauncher' || AbilityState.GetMyTemplateName() == 'LWBlasterLauncher' || AbilityState.GetMyTemplateName() == 'MicroMissiles')
		{
			Explosives = true;
		}
		if (Explosives)
		{
			if (CurrentDamage > 0)
			{
				WeaponDamageEffect = X2Effect_ApplyWeaponDamage(class'X2Effect'.static.GetX2Effect(AppliedData.EffectRef));
				if (WeaponDamageEffect != none)
				{			
					if (WeaponDamageEffect.bIgnoreBaseDamage)
					{	
						return 1;
					}
				}
				return default.CRIT_DAMAGE_BONUS;
			}
		}
    }
	return 0;
}


function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo BoomInfo;

	if(bIndirectFire || AbilityState.GetMyTemplateName() == 'LWRocketLauncher' || AbilityState.GetMyTemplateName() == 'LWBlasterLauncher' || AbilityState.GetMyTemplateName() == 'MicroMissiles')
	{
		BoomInfo.ModType = eHit_Crit;
		BoomInfo.Value = default.CRIT_CHANCE_BONUS;
	    BoomInfo.Reason = FriendlyName;
		ShotModifiers.AddItem(BoomInfo);
	}
}