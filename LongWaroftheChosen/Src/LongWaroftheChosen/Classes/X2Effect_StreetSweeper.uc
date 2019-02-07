class X2Effect_StreetSweeper extends X2Effect_Persistent;

var float Unarmored_Damage_Multiplier;
var int Unarmored_Damage_Bonus;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Unit TargetUnit;

    if(AbilityState.GetMyTemplateName() == 'StreetSweeper2')
    {
		TargetUnit = XComGameState_Unit(TargetDamageable);
		if(TargetUnit != none)
		{
			if (TargetUnit.GetCurrentStat (eStat_ArmorMitigation) == 0)
			{
				if (Unarmored_Damage_Multiplier != 0.0)
				{
					return int (float(CurrentDamage) * Unarmored_Damage_Multiplier);
				}
				else
				{
					return Unarmored_Damage_Bonus;
				}
			}
		}
	}
}
