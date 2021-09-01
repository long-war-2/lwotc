class XGAIBehavior_override extends XGAIBehavior;

var config bool ENABLE_AI_LOGGING;

function bool IsValidTarget(AvailableTarget kTarget)
{
	local bool retVal;
	local XComGameStateHistory History;
	local XComGameState_Unit kTargetState;

	retVal = super.IsValidTarget(kTarget);

	// If we found a valid target and we are an AI, reconsider if the target is civilian.
	if (retVal &&
		UnitState.ControllingPlayerIsAI() && 
		m_kPlayer != None ) {
		History = `XCOMHISTORY;
		kTargetState = XComGameState_Unit(History.GetGameStateForObjectID(kTarget.PrimaryTarget.ObjectID));
		if( kTargetState != None && 
			kTargetState.GetTeam() == eTeam_Neutral && 
			!m_kPlayer.bCiviliansTargetedByAliens) // Ignore civs if the AI player has visibility of XCom.
		{
			retVal = false;
		}
	}

	return retVal;
}

function SaveBTTraversals()
{
	local int RootIndex;
	local array<BTDetailedInfo> arrStatusList;

	if(default.ENABLE_AI_LOGGING)
	{
		BT_GetNodeDetailList(arrStatusList);
		RootIndex = `BEHAVIORTREEMGR.GetNodeIndex(m_kBehaviorTree.m_strName);
		AddTraversalData(arrStatusList, RootIndex);
	}
	
}
