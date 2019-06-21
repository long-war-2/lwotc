//---------------------------------------------------------------------------------------
//  FILE:    UIPersonnel_LEBVS
//  AUTHOR:  LeaderEnemyBoss
//
//  PURPOSE: Implements custom filtering to only show soldiers that are currently infiltrating the selected mission
//--------------------------------------------------------------------------------------- 

class UIPersonnel_LEBVS extends UIPersonnel;

var array<StateObjectReference> SoldierList;

simulated function UpdateData()
{
	local int i;
	local XComGameState_Unit Unit;

	// Destroy old data
	m_arrSoldiers.Length = 0;
	m_arrScientists.Length = 0;
	m_arrEngineers.Length = 0;
	m_arrDeceased.Length = 0;

	for (i = 0; i < SoldierList.length; i++)
	{		
		Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(SoldierList[i].ObjectID));

		If (Unit != none) m_arrSoldiers.AddItem(Unit.GetReference());
	}
}

simulated function OnReceiveFocus()
{
	//local XComStrategyMap XComMap;

	super.OnReceiveFocus();
	`HQPRES.GetCamera().ForceEarthViewImmediately(false);
	
	//XComMap = XComHQPresentationLayer(Movie.Pres).m_kXComStrategyMap;
	//XComMap.OnReceiveFocus();
}

simulated function UpdateNavHelp()
{
	local UINavigationHelp NavHelp;

	NavHelp = `HQPRES.m_kAvengerHUD.NavHelp;

	NavHelp.ClearButtonHelp();
	NavHelp.AddBackButton(OnCancel);
}

defaultproperties
{
	m_eListType = eUIPersonnel_Soldiers;
	m_bRemoveWhenUnitSelected = false;
}
