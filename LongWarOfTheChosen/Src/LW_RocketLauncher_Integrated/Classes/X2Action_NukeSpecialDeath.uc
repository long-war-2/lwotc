class X2Action_NukeSpecialDeath extends X2Action_ExplodingUnitDeathAction;

// mostly a copy of Purifier's explosive death, we just don't deal any damage

simulated function name GetAssociatedAbilityName()
{
	return 'IRI_FireTacticalNuke';
}

simulated function Name ComputeAnimationToPlay()
{
	// Always allow new animations to play.
	UnitPawn.GetAnimTreeController().SetAllowNewAnimations(true);

	return 'HL_NukeSpecialDeath'; // tell the unit which animation to play
}