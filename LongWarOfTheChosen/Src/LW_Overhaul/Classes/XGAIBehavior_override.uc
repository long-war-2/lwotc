class XGAIBehavior_override extends XGAIBehavior;

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