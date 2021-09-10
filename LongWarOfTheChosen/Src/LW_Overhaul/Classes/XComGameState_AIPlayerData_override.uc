class XComGameState_AIPlayerData_override extends XComGameState_AIPlayerData;

function UpdateFightMgrStats( XComGameState NewGameState )
{
	local XGAIPlayer AIPlayer;

	// Keep updating current line of play, in case its needed elsewhere.
	AIPlayer = XGAIPlayer(XGBattle_SP(`BATTLE).GetAIPlayer());
	AIPlayer = XGAIPlayer(`BATTLE.GetAIPlayer());
	AIPlayer.m_kNav.UpdateCurrentLineOfPlay( CurrentLineOfPlay );

	bDownThrottlingActive = false;
	bUpThrottlingActive = false;

	UpdateThrottleAlerts(NewGameState);
}