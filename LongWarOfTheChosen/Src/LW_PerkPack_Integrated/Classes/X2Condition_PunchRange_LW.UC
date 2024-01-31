// Used with permission from NotSoLoneWolf

class X2Condition_PunchRange_LW extends X2Condition;

// Without this X2Condition any Bladestorm-clone ability has infinite range.
// No clue why this is necessary, the vanilla Bladestorm seems to work fine without a file like this.
// Kudos to spacemanaki and his "Lost Bladestorm" mod for coming up with this solution!
function name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{
    local XComGameState_Unit Source;
    local XComGameState_Unit Target;
    local int Tiles;

    Source = XComGameState_Unit(kSource);
    Target = XComGameState_Unit(kTarget);
    Tiles = Source.TileDistanceBetween(Target);

    if (Tiles <= 1)
    {
        return 'AA_Success';
    }
	return 'AA_NotInRange';
}
