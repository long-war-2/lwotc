class robojumper_SquadSelect_Helpers extends Object;


static function GetCurrentAndMaxStatForUnit(XComGameState_Unit UnitState, ECharStatType Stat, out int CurrStat, out int MaxStat)
{
	CurrStat = UnitState.GetCurrentStat(Stat) + UnitState.GetUIStatFromInventory(Stat) + UnitState.GetUIStatFromAbilities(Stat);
	MaxStat = UnitState.GetMaxStat(Stat) + UnitState.GetUIStatFromInventory(Stat) + UnitState.GetUIStatFromAbilities(Stat);
}

static function bool UnitParticipatesInWillSystem(XComGameState_Unit UnitState)
{
	return UnitState.UsesWillSystem();
}

static function GetSoldierAndGlobalAP(XComGameState_Unit UnitState, out int iSoldierAP, out int iGlobalAP)
{
	iSoldierAP = UnitState.AbilityPoints;
	iGlobalAP = `XCOMHQ.GetAbilityPoints();
}
