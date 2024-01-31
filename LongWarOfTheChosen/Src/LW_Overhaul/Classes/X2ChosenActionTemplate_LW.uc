// Modification of X2ChosenActionTemplate to fix a bug with global cooldown until CHL fixes it.

class X2ChosenActionTemplate_LW extends X2ChosenActionTemplate;

function bool CanPerformAction(XComGameState_AdventChosen ChosenState, array<XComGameState_AdventChosen> AllChosen, array<name> UsedActions, XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_AdventChosen Chosen;
	local int MonthUses, ICooldown, GCooldown;
	local name ActionName;

	// Check for met XCom req
	if(!bCanPerformIfUnmet && !ChosenState.bMetXCom)
	{
		return false;
	}

	// Check for uses this month req (Unmet don't obey this)
	if(ChosenState.bMetXCom)
	{
		if(MaxPerMonth > 0)
		{
			MonthUses = 0;
			foreach UsedActions(ActionName)
			{
				if(ActionName == DataName)
				{
					MonthUses++;
				}
			}

			if(MonthUses >= MaxPerMonth)
			{
				return false;
			}
		}
	}

	// Check for knowledge req
	if(ChosenState.GetKnowledgeLevel() < MinXComKnowledge)
	{
		return false;
	}

	// Check for force level req
	History = `XCOMHISTORY;
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));

	if(AlienHQ.GetForceLevel() < MinForceLevel)
	{
		return false;
	}

	// Check for individual cooldown req
	ICooldown = ChosenState.GetMonthsSinceAction(DataName);

	if(ICooldown > 0 && ICooldown <= IndividualCooldown)
	{
		return false;
	}

	// Check for global cooldown req
	GCooldown = 0;

	foreach AllChosen(Chosen)
	{
        // The fix is the below line, ChosenState changed to Chosen
		ICooldown = Chosen.GetMonthsSinceAction(DataName);

		if(ICooldown > 0 && (ICooldown < GCooldown || GCooldown <= 0))
		{
			GCooldown = ICooldown;
		}
	}

	if(GCooldown > 0 && GCooldown <= GlobalCooldown)
	{
		return false;
	}

	// Check for custom reqs
	if(CanBePlayedFn != none)
	{
		return CanBePlayedFn(ChosenState.GetReference(), NewGameState);
	}

	return true;
}