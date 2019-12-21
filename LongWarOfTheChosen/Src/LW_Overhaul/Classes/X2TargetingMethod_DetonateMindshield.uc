class X2TargetingMethod_DetonateMindshield extends X2TargetingMethod_TopDown;

var protected XComGameState_Ability DetonateMindshieldAbility;

function DirectSetTarget(int TargetIndex)
{
	local StateObjectReference DetonateMindshieldRef;
	local XComGameState_Unit TargetUnit;
	local int TargetID;
	local array<TTile> Tiles;

	super.DirectSetTarget(TargetIndex);

	DetonateMindshieldAbility = none;
	TargetID = GetTargetedObjectID();
	if (TargetID != 0)
	{
		TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(TargetID));
		if (TargetUnit != none)
		{
			if (class'X2Condition_DetonateMindshieldTarget'.static.GetAvailableDetonateMindshield(TargetUnit, DetonateMindshieldRef))
			{
				DetonateMindshieldAbility = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(DetonateMindshieldRef.ObjectID));
				if (DetonateMindshieldAbility != none && DetonateMindshieldAbility.GetMyTemplate().AbilityMultiTargetStyle != none)
				{
					DetonateMindshieldAbility.GetMyTemplate().AbilityMultiTargetStyle.GetValidTilesForLocation(DetonateMindshieldAbility, GetTargetedActor().Location, Tiles);	
					DrawAOETiles(Tiles);
				}
			}
		}
	}
}

function Update(float DeltaTime)
{
	local XComGameState_Ability ActualAbility;
	local array<Actor> CurrentlyMarkedTargets;
	local vector NewTargetLocation;
	local TTile SnapTile;

	NewTargetLocation = GetTargetedActor().Location;
	SnapTile = `XWORLD.GetTileCoordinatesFromPosition( NewTargetLocation );
	`XWORLD.GetFloorPositionForTile( SnapTile, NewTargetLocation );

	if(NewTargetLocation != CachedTargetLocation)
	{		
		ActualAbility = Ability;
		Ability = DetonateMindshieldAbility;
		GetTargetedActors(NewTargetLocation, CurrentlyMarkedTargets);
		CheckForFriendlyUnit(CurrentlyMarkedTargets);	
		MarkTargetedActors(CurrentlyMarkedTargets, (!AbilityIsOffensive) ? FiringUnit.GetTeam() : eTeam_None );

		Ability = ActualAbility;
		CachedTargetLocation = NewTargetLocation;
	}
}

function Canceled()
{
	ClearTargetedActors();
	super.Canceled();
}