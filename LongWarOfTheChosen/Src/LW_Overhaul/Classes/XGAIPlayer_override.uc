class XGAIPlayer_override extends XGAIPlayer;

function UpdateTerror()
{
	local int i;
	local array<XComGameState_Unit> enemies;

	super.UpdateTerror();
	
	enemies = GetAllVisibleEnemies();
	for (i = 0; i < enemies.Length; ++i) {
		if (enemies[i].GetTeam() == eTeam_XCom) { // If aliens see at least one XCom soldier, disregard civilian targets
			bCiviliansTargetedByAliens = false;
			return;
		}
	}
}

function array<XComGameState_Unit> GetAllVisibleEnemies()
{
	local array<XComGameState_Unit> enemies;
	local XComGameStateHistory kHistory;
	local StateObjectReference kUnitRef;
	local XComGameState_Unit kUnit;
	local array<StateObjectReference> VisibleUnits;
	kHistory = `XCOMHISTORY;
	class'X2TacticalVisibilityHelpers'.static.GetAllVisibleEnemiesForPlayer(ObjectID, VisibleUnits);
	foreach VisibleUnits(kUnitRef)
	{
		kUnit = XComGameState_Unit(kHistory.GetGameStateForObjectID(kUnitRef.ObjectID));
		enemies.AddItem(kUnit);
	}
	return enemies;
}

