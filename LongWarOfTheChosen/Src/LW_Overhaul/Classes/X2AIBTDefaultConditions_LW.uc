class X2AIBTDefaultConditions_LW extends X2AIBTDefaultConditions;

static event bool FindBTConditionDelegate(name strName, optional out delegate<BTConditionDelegate> dOutFn, optional out Name NameParam)
{
	dOutFn = None;
	switch( strName )
	{
		case 'LWNoVisibleEnemiesToTeam':
			dOutFn = LWNoVisibleEnemiesToTeam;
			return true;
			break;
		default:
		break;
	}

	return super.FindBTConditionDelegate(strName, dOutFn, NameParam);
}

function bt_status LWNoVisibleEnemiesToTeam()
{
    local XComGameState_Unit UnitState, TestUnit;
    local XComGameState_AIGroup AIGroup;
    local array<XComGameState_Unit> GroupUnitStates;
    local array<int> UnitIDs;
    local int VisibleEnemiesCount;

    // Get the unit we're interested in
    UnitState = m_kBehavior.m_kUnit.GetVisualizedGameState();

    `LWTrace("No visible enemies to pod condition called");

    VisibleEnemiesCount = 0;

    // Get the AI group
    AIGroup = UnitState.GetGroupMembership();

    if(AIGroup != none)
    {
        if(AIGroup.GetLivingMembers(UnitIDs, GroupUnitStates))
        {
            // Check the members of the group
            foreach GroupUnitStates (TestUnit)
            {
                `LWTrace("Testing group unit" @TestUnit.GetFullName());
                VisibleEnemiesCount += XGUnit(TestUnit.GetVisualizer()).m_kBehavior.BT_GetVisibleEnemyCount(true, false, false);

                if(VisibleEnemiesCount > 0)
                {
                    `LWTrace("We spotted an enemy, fail");
                    return BTS_Failure;
                }
            }
        }
        // If we're here, VisibleEnemiesCount should be 0
        `LWTrace("Yes! no visible enemies.");
        return BTS_Success;
    }

    return BTS_Failure;
}