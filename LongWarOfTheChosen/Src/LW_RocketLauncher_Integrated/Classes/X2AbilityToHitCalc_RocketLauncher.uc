class X2AbilityToHitCalc_RocketLauncher extends X2AbilityToHitCalc_StandardAim;

//	Used by Sabot Rocket
function int GetWeaponRangeModifier(XComGameState_Unit Shooter, XComGameState_Unit Target, XComGameState_Item Weapon)
{
    local int Tiles, Modifier;
	local array<int> RangeAccuracy;

    if (Shooter != none && Target != none)
    {
		//	Gets Range Accuracy table for the rocket launcher equipped on the soldier. 
		//	Different Range Accuracy tables will be used depending on launhcer's WeaponTech and how many actions the soldier has remaining.
		RangeAccuracy = class'X2TargetingMethod_IRI_RocketLauncher'.static.GetRangeAccuracyArray(Shooter);

        if (RangeAccuracy.Length > 0)
        {
			Tiles = Shooter.TileDistanceBetween(Target);

            if (Tiles < RangeAccuracy.Length) Modifier = RangeAccuracy[Tiles];
            else Modifier = RangeAccuracy[RangeAccuracy.Length - 1]; //	if there's no config for the current tile, use the previously configured one
        }
    }
    return Modifier;
}