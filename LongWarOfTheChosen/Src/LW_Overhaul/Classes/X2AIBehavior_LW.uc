class X2AIBehavior_LW extends X2AIBTDefaultActions;

static event bool FindBTActionDelegate(
    name strName,
    optional out delegate<BTActionDelegate> dOutFn,
    optional out name NameParam,
    optional out name MoveProfile)
{
	local name NodeName, AbilityName;

	dOutFn = None;

	if (SplitNameAtHyphen(strName, NodeName, AbilityName))
	{
		strName = NodeName;
		NameParam = AbilityName;
	}

	switch (strName)
	{
	case 'SetPriorityTargetStack':
		dOutFn = BT_SetPriorityTargetStack;
		return true;

	default:
		`WARN("[X2AIBehavior_LW] Unresolved behavior tree Action name with no delegate definition:" @ strName);
		break;

	}

	return super.FindBTActionDelegate(strName, dOutFn, NameParam, MoveProfile);
}

// This new behavior tree node will add only the priority target to
// the AI's target stack, if there is a priority target available.
// No other potential targets will be added. If there is no priority
// target, the target stack will be empty.
//
// Example usage in XComAI.ini:
// ```ini
// +Behaviors=(BehaviorName=SelectPriorityTargetForStandardShot, NodeType=Sequence, \\
//             Child[0]=SetPriorityTargetStack-StandardShot, Child[1]=SelectPriorityTarget, \\
//             Child[2]=HasValidTarget-StandardShot)
// ```
// The above will ensure that the priority target is the only target
// that can possibly be selected for StandardShot.
// (Copy of X2AIBehavior.BT_SetTargetStack())
function bt_status BT_SetPriorityTargetStack()
{
	local AvailableTarget kTarget;
	local string DebugText;

	m_kBehavior.m_kBTCurrTarget.TargetID = INDEX_NONE;
	m_kBehavior.m_kBTCurrAbility = m_kBehavior.FindAbilityByName(SplitNameParam);
	if (m_kBehavior.m_kBTCurrAbility.AbilityObjectRef.ObjectID > 0 && m_kBehavior.m_kBTCurrAbility.AvailableCode == 'AA_Success' && m_kBehavior.m_kBTCurrAbility.AvailableTargets.Length > 0)
	{
		m_kBehavior.m_strBTCurrAbility = SplitNameParam;
		foreach m_kBehavior.m_kBTCurrAbility.AvailableTargets(kTarget)
		{
			if (IsPriorityTarget(kTarget))  // Issue #1009: this is the only difference from BT_SetTargetStack()
			{
				m_kBehavior.m_arrBTTargetStack.AddItem(kTarget);
				DebugText @= kTarget.PrimaryTarget.ObjectID;
			}
		}
		`LWTrace("SetPriorityTargetStack results- Added:" @ DebugText);
		return BTS_SUCCESS;
	}
	if (m_kBehavior.m_kBTCurrAbility.AbilityObjectRef.ObjectID <= 0)
	{
		`LWTrace("SetPriorityTargetStack results- no Ability reference found: " $ SplitNameParam);
	}
	else if (m_kBehavior.m_kBTCurrAbility.AvailableCode != 'AA_Success')
	{
		`LWTrace("SetPriorityTargetStack results- Ability unavailable - AbilityCode == " $ m_kBehavior.m_kBTCurrAbility.AvailableCode);
	}
	else
	{
		`LWTrace("SetPriorityTargetStack results- No targets available! ");
	}
	return BTS_FAILURE;
}

function bool IsPriorityTarget(AvailableTarget kTarget)
{
	local XComGameState_AIPlayerData PlayerData;

	if (m_kBehavior.m_kPlayer != None)
	{
		PlayerData = XComGameState_AIPlayerData(`XCOMHISTORY.GetGameStateForObjectID(m_kBehavior.m_kPlayer.GetAIDataID()));
		if (PlayerData != None &&
			PlayerData.PriorityTarget.ObjectID > 0 &&
			PlayerData.PriorityTarget.ObjectID == kTarget.PrimaryTarget.ObjectID)
		{
			return true;
		}
	}
	return false;
}