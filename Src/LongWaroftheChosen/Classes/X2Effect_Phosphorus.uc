class X2Effect_Phosphorus extends X2Effect_Persistent;

var int BonusShred;

function int GetExtraShredValue(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData)
{
	local Name AbilityName;

	`LOG ("TEsting New Phos Effect 1");

	if(AbilityState == none)
		return 0;

	`LOG ("TEsting New Phos Effect 2");

	if (Attacker.HasSoldierAbility('PhosphorusPassive'))
	{
		`LOG ("TEsting New Phos Effect 3");		
		AbilityName = AbilityState.GetMyTemplateName();
		switch (AbilityName)
		{
			case 'LWFlamethrower':
			case 'Roust':
			case 'Firestorm':
				`LOG ("Testing New Phos Effect 4" @ BonusShred);
				return BonusShred;
			default:
				return 0;
		}
	}
	return 0;
}