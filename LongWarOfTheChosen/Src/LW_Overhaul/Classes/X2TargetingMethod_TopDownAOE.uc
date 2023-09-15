// Tedster - Extending the TopDown AOE one to add the Firing Unit to the target location.

class X2TargetingMethod_TopDownAOE extends X2TargetingMethod_TopDown;

function GetTargetLocations(out array<Vector> TargetLocations)
{
	`LWTrace("Ted Targeting method GetTargetLocations called");
	TargetLocations.Length = 0;
	TargetLocations.AddItem(FiringUnit.GetLocation());
}