//---------------------------------------------------------------------------------------
//  FILE:    Utilities_LW
//  AUTHOR:  johnnylump(Pavonis Interactive)
//
//  PURPOSE: Miscellaneous helper routines.
//--------------------------------------------------------------------------------------- 

class Utilities_PP_LW extends Object;

function static bool IsContinentBonusActive (name TestContinentBonus)
{
	local XComGameState_Continent Continent;

	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Continent', Continent)
    {
        if(Continent.bContinentBonusActive)
        {
			if (Continent.ContinentBonus == TestContinentBonus)
			{
				return true;
			}
		}
	}
	return false;
}


// This duplicates CanRankUpSoldier except for checking the flag that turns off normal ranking up
static function bool CanRankUpPsiSoldier(XComGameState_Unit Unit)
{
	local int NumKills;
	local XComLWTuple Tuple, CustomPsiRankCond; // LWS  added

	// inserted hook at LeaderEnemyBoss' request
	CustomPsiRankCond = new class'XComLWTuple';
	CustomPsiRankCond.Id = 'CustomPsiRankupCondition';
	CustomPsiRankCond.Data.Add(2);
	CustomPsiRankCond.Data[0].kind = XComLWTVbool;
	CustomPsiRankCond.Data[0].b = false;
	CustomPsiRankCond.Data[1].kind = XComLWTVbool;
	CustomPsiRankCond.Data[1].b = false;
   
	`XEVENTMGR.TriggerEvent('CustomPsiRankupCondition', CustomPsiRankCond, Unit);
   
	If (CustomPsiRankCond.Data[0].b)
	{
		return CustomPsiRankCond.Data[1].b;
	}

	
	`Log("Is the operative yet to rank up?");
	if (Unit.GetSoldierRank() + 1 < `GET_MAX_RANK && !Unit.bRankedUp)
	{
		`Log("Yes!");
		NumKills = Unit.GetTotalNumKills();

		`LOG ("Testing Psi Soldier XP; Kills" @ NumKills @ "Needed:" @ class'X2ExperienceConfig'.static.GetRequiredKills(Unit.GetSoldierRank() + 1));

		if (	NumKills >= class'X2ExperienceConfig'.static.GetRequiredKills(Unit.GetSoldierRank() + 1)
				&& Unit.GetStatus() != eStatus_PsiTesting
				&& !Unit.IsPsiTraining()
				&& !Unit.IsPsiAbilityTraining()
				&& Unit.IsAlive()
				&& !Unit.bCaptured)
			return true;
	}

	return false;
}
