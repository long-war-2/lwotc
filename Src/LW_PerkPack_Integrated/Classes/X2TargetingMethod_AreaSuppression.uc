class X2TargetingMethod_AreaSuppression extends X2TargetingMethod_TopDown;

function Update(float DeltaTime)
{
    local array<Actor> CurrentlyMarkedTargets;
    local array<TTile> Tiles;
	local Actor TargetedActor, CurrentTarget;
	local XGUnit TargetedUnit;

	TargetedActor = GetTargetedActor();
	GetTargetedActors(TargetedActor.Location, CurrentlyMarkedTargets, Tiles);
	foreach CurrentlyMarkedTargets (CurrentTarget)
	{
		TargetedUnit = XGUnit (CurrentTarget);
		if (TargetedUnit == none)
		{
			CurrentlyMarkedTargets.RemoveItem(CurrentTarget);
		}
		else
		{
			if (FiringUnit.GetTeam() == TargetedUnit.GetTeam())
				CurrentlyMarkedTargets.RemoveItem(CurrentTarget);
		}
	}

	MarkTargetedActors(CurrentlyMarkedTargets, ((!AbilityIsOffensive) ? FiringUnit.GetTeam() : 0));
}

function Canceled()
{
    super.Canceled();
	ClearTargetedActors();
}
