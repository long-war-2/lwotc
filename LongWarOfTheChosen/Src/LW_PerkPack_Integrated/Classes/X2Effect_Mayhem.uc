class X2Effect_Mayhem extends X2Effect_Persistent config(LW_SoldierSkills);

var config float MAYHEM_DAMAGE_BONUS_PCT;

function float GetPostDefaultAttackingDamageModifier_CH(
	XComGameState_Effect EffectState,
	XComGameState_Unit SourceUnit,
	Damageable Target,
	XComGameState_Ability AbilityState,
	const out EffectAppliedData AppliedData,
	float WeaponDamage,
	XComGameState NewGameState)
{
	local XComGameState_Item SourceWeapon;
	local XComGameState_Unit TargetUnit;

	if (AbilityState.GetMyTemplateName() == 'SuppressionShot_LW' || AbilityState.GetMyTemplateName() == 'AreaSuppressionShot_LW')
	{
		if (AppliedData.AbilityResultContext.HitResult == eHit_Success)
		{
			SourceWeapon = AbilityState.GetSourceWeapon();
			if (SourceWeapon != none)
			{
				TargetUnit = XComGameState_Unit(Target);
				if (TargetUnit != none)
				{
					if (SourceUnit.HasSoldierAbility('Mayhem'))
					{
						return WeaponDamage * (default.MAYHEM_DAMAGE_BONUS_PCT / 100);
					}
				}
			}
		}
	}

    return 0.0;
}

defaultproperties
{
	DuplicateResponse=eDupe_Ignore
}
