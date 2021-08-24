class X2AbilityCost_RocketActionPoints extends X2AbilityCost_HeavyWeaponActionPoints;

simulated function int GetPointCost(XComGameState_Ability AbilityState, XComGameState_Unit AbilityOwner)
{
	return X2WeaponTemplate(AbilityState.GetSourceWeapon().GetMyTemplate()).iTypicalActionCost;
}

simulated function bool ConsumeAllPoints(XComGameState_Ability AbilityState, XComGameState_Unit AbilityOwner)
{
	local int i;
	
	if (bConsumeAllPoints)
	{
		for (i = 0; i < class'X2Ability_IRI_Rockets'.default.DO_NOT_END_TURN_ABILITIES.Length; ++i)
		{
			if (AbilityOwner.HasSoldierAbility(class'X2Ability_IRI_Rockets'.default.DO_NOT_END_TURN_ABILITIES[i]))
				return false;
		}
		return super.ConsumeAllPoints(AbilityState, AbilityOwner);
	}

	return bConsumeAllPoints;
}