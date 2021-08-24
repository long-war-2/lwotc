class X2Condition_WithinChemthrowerRange extends X2Condition;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource) 
{
	local XComGameState_Unit	Target, Source;
	local int					Range;

	Target = XComGameState_Unit(kTarget);
	Source = XComGameState_Unit(kSource);

	if ( Target != none && Source != none )
	{

		Range = class'X2Ability_Immolator'.default.FlameTHROWER_TILE_LENGTH;
		if ( Source.HasSoldierAbility('LWLengthNozzleBsc') ) { Range += 1; }
		if ( Source.HasSoldierAbility('LWLengthNozzleAdv') ) { Range += 2; }
		if ( Source.HasSoldierAbility('LWLengthNozzleSup') ) { Range += 3; }
		
		if ( Source.TileDistanceBetween(Target) <= Range )
		{
			return 'AA_Success';
		}

		return 'AA_NotInRange';
	}

	return 'AA_NotAUnit';
}