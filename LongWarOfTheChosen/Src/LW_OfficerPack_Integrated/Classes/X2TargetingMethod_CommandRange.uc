// X2TargetingMethod_CommandRange.uc
// 
// This is a custom version of the default TopDown targeting method that makes
// sure that only allies are highlighted by the targeting visualisation used by
// various officer abilities that work on allies within command range of the
// officer.
//
// This is because the unit conditions that determine whether a unit is affected
// by a Multi Target Style ability aren't used by the targeting method.
//
class X2TargetingMethod_CommandRange extends X2TargetingMethod_TopDown;

// Override this method to filter out any actors that aren't on Team XCom.
protected function GetTargetedActors(const vector Location, out array<Actor> TargetActors, optional out array<TTile> TargetTiles)
{
    local int i;
    local array<Actor> XComActors;

    super.GetTargetedActors(Location, TargetActors, TargetTiles);

    // Filter actors for only team XCOM.
    for (i = 0; i < TargetActors.Length; i++)
    {
        if (TargetActors[i].m_eTeam == eTeam_XCom)
        {
            XComActors.AddItem(TargetActors[i]);
        }
    }

    TargetActors = XComActors;
}
