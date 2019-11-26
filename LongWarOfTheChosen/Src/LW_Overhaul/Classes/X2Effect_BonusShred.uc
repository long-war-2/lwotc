//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_BonusShred.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: An effect that applies bonus shred if the affected unit has the Shredder
//           ability.
//---------------------------------------------------------------------------------------
class X2Effect_BonusShred extends X2Effect_Persistent;

var int BonusShredValue;

function int GetExtraShredValue(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData)
{
	if (Attacker.HasSoldierAbility('Shredder'))
	{
        return BonusShredValue;
    }

	return 0;
}
