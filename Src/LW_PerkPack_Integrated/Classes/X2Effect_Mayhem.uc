class X2Effect_Mayhem extends X2Effect_Persistent config(LW_SoldierSkills);

var config float MAYHEM_DAMAGE_BONUS_PCT;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
    local XComGameState_Item SourceWeapon;
    local XComGameState_Unit TargetUnit;

	if(AbilityState.GetMyTemplateName() == 'SuppressionShot_LW' || AbilityState.GetMyTemplateName() == 'AreaSuppressionShot_LW')
	{
		if(AppliedData.AbilityResultContext.HitResult == eHit_Success)
		{
			SourceWeapon = AbilityState.GetSourceWeapon();
			if(SourceWeapon != none) 
			{
				TargetUnit = XComGameState_Unit(TargetDamageable);
				if(TargetUnit != none)
				{
					if (Attacker.HasSoldierAbility('Mayhem'))
					{
						return int (CurrentDamage * (default.MAYHEM_DAMAGE_BONUS_PCT / 100));
					}
				}
            }
        }
    }
    return 0;
}