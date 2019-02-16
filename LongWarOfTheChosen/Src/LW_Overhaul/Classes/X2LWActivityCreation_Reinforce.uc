//---------------------------------------------------------------------------------------
//  FILE:    X2LWActivityCreation_Reinforce.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//	PURPOSE: Extended Creation class that selects reinforcement region based on neighboring regions
//---------------------------------------------------------------------------------------
class X2LWActivityCreation_Reinforce extends X2LWActivityCreation config(LW_Activities);



var config int MAX_ALERT_FOR_REINFORCE;

simulated function StateObjectReference FindBestPrimaryRegion(XComGameState NewGameState)
{	
	local StateObjectReference			NullRef;
	local XComGameState_WorldRegion		RegionState;

	RegionState = FindBestReinforceDestRegion(NewGameState);
	
	if(RegionState == none)
		return NullRef;
	else
		return RegionState.GetReference();
}

function int GetDesiredAlertLevel (XComGameState_WorldRegion RegionState) 
{
	local XComGameStateHistory History;
	local int DesiredAlertLevel;
	local XComGameState_MissionSite MissionState;
	local StateObjectReference LinkedRegionRef;
	local XComGameState_LWAlienActivity ActivityState;
	local XComGameState_WorldRegion NeighborRegionState;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI, NeighborRegionStateAI;

	History = `XCOMHISTORY;

	RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI (RegionState);

	DesiredAlertLevel = RegionalAI.LocalVigilanceLevel;

	if(RegionalAI.bHasResearchFacility)
	{
		DesiredAlertLevel += 1;
	}
	if (RegionState.ResistanceLevel == eResLevel_Outpost && !RegionState.IsStartingRegion())
	{
		DesiredAlertLevel += 1;
	}
	foreach History.IterateByClassType(class'XComGameState_LWAlienActivity', ActivityState)
	{
		if (ActivityState.GetMyTemplateName() == 'ProtectRegion' && RegionState.GetReference() == ActivityState.PrimaryRegion)
		{
			DesiredAlertLevel += 1;
		}
		if (ActivityState.GetMyTemplateName() == 'BuildResearchFacility' && RegionState.GetReference() == ActivityState.PrimaryRegion)
		{
			DesiredAlertLevel += 1;
		}
		if (ActivityState.GetMyTemplateName() == 'Invasion' && RegionState.GetReference() == ActivityState.SecondaryRegions[0])
		{
			DesiredAlertLevel += 1;
		}
	}

	foreach History.IterateByClassType(class'XComGameState_MissionSite', MissionState)
	{
		if (MissionState.GetMissionSource().DataName == 'MissionSource_Blacksite')
		{
			if (MissionState.Region == RegionState.GetReference())
			{
				DesiredAlertLevel += 2;
			}
			if(MissionState.GetWorldRegion().LinkedRegions.Find('ObjectID', RegionState.ObjectID) != -1)
			{
				DesiredAlertLevel += 1;
			}
		}
		if (MissionState.GetMissionSource().DataName == 'MissionSource_Forge')
		{
			if (MissionState.Region == RegionState.GetReference())
			{
				DesiredAlertLevel += 2;
			}
			if(MissionState.GetWorldRegion().LinkedRegions.Find('ObjectID', RegionState.ObjectID) != -1)
			{
				DesiredAlertLevel += 1;
			}
		}
		if (MissionState.GetMissionSource().DataName == 'MissionSource_PsiGate')
		{
			if (MissionState.Region == RegionState.GetReference())
			{
				DesiredAlertLevel += 2;
			}
			if(MissionState.GetWorldRegion().LinkedRegions.Find('ObjectID', RegionState.ObjectID) != -1)
			{
				DesiredAlertLevel += 1;
			}
		}
	}
	
	// For each of our neighbors that is liberated or in real trouble
	foreach RegionState.LinkedRegions (LinkedRegionRef)
	{
		NeighborRegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(LinkedRegionRef.ObjectID));
        NeighborRegionStateAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(NeighborRegionState);
		if (NeighborRegionStateAI.bLiberated)
		{
			DesiredAlertLevel += 2;
		}
		if (NeighborRegionStateAI.LocalVigilanceLevel - NeighborRegionStateAI.LocalAlertLevel > 5)
		{
			DesiredAlertLevel += 1;
		}
	}

	return Min(DesiredAlertLevel, 15);
}

function XComGameState_WorldRegion FindBestReinforceDestRegion(XComGameState NewGameState)
{

	local XComGameStateHistory History;
	local StateObjectReference DestRegionRef;
	local XComGameState_WorldRegion DestRegionState, BestDestRegionState, BestOrigRegionState;
	local XComGameState_WorldRegion_LWStrategyAI DestRegionalAI;
	local float CurrentOrigDelta, CurrentDestDelta;
	local float BiggestDelta, CurrentDelta;
	local int DesiredAlertLevel;

	History = `XCOMHISTORY;

	foreach PrimaryRegions(DestRegionRef)
	{
		DestRegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(DestRegionRef.ObjectID));
		DestRegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(DestRegionState, NewGameState);
		if (DestRegionalAI == none)
		{
			`REDSCREEN("Reinforce Region ERROR : No Regional AI  " $ DestRegionState.GetMyTemplate().DisplayName );
			continue;
		}

		// We're good
		if (DestRegionalAI.LocalAlertLevel >= default.MAX_ALERT_FOR_REINFORCE)
			continue;

		// Can't reinf free region
		if (DestRegionalAI.bLiberated)
			continue;

		// This is what we want in this region
		DesiredAlertLevel = GetDesiredAlertLevel (DestRegionState);
		
		// This is is how far we are from that
		CurrentDestDelta = DesiredAlertLevel - DestRegionalAI.LocalAlertLevel;
		//`LWTRACE("Reinforce Region TESTING" @ DestRegionState.GetMyTemplate().DisplayName @ "Considering Reinforcements: Alert need is" @ string(CurrentDestDelta));

		// If I need somebody
		if(CurrentDestDelta > 0)
		{
			CurrentOrigDelta = 0;
			// look for an adjacent region to act as origin -- recording the best one
			BestOrigRegionState = FindBestReinforceOrigRegion(DestRegionState, NewGameState, CurrentOrigDelta);
			if(BestOrigRegionState != none)
			{
				//`LWTRACE("Reinforce Region: Best Origin:" @ BestOrigRegionState.GetMyTemplate().DisplayName);
				CurrentDelta = CurrentOrigDelta + CurrentDestDelta;
				if(CurrentDelta > BiggestDelta)
				{
					BiggestDelta = CurrentDelta;
					BestDestRegionState = DestRegionState;
				}
			}
		}
	}
	return BestDestRegionState;
}

function XComGameState_WorldRegion FindBestReinforceOrigRegion(XComGameState_WorldRegion DestRegionState, XComGameState NewGameState, optional out float BiggestDelta)
{
	local XComGameStateHistory History;
	local StateObjectReference OrigRegionRef;
	local XComGameState_WorldRegion OrigRegionState, BestOrigRegionState;
	local XComGameState_WorldRegion_LWStrategyAI OrigRegionalAI, DestRegionalAI;
	local XComGameState_LWAlienActivity ActivityState;
	local XComGameState_MissionSite MissionState;
	local float CurrentDelta;

	History = `XCOMHISTORY;
	`LWTRACE ("FindBestReinforceOrigRegion: Search for source started for reinforcing" @ DestRegionState.GetMyTemplate().DisplayName);

	foreach DestRegionState.LinkedRegions(OrigRegionRef)
	{
		OrigRegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(OrigRegionRef.ObjectID));
		//`LWTRACE ("Reinforcements Origin Testing of" @ OrigRegionState.GetMyTemplate().DisplayName);

		OrigRegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(OrigRegionState, NewGameState);
		if (OrigRegionalAI == none)
		{
			`REDSCREEN ("FindBestReinforceOrigRegion: No Regional AI for" @ OrigRegionState.GetMyTemplate().DisplayName);
			continue;
		}

		// nothing to give
		if (OrigRegionalAI.bLiberated || (OrigRegionalAI.LocalAlertLevel - GetNumReinforceActivitiesOriginatingInRegion(OrigRegionRef) < 2))
			continue;

		foreach History.IterateByClassType(class'XComGameState_LWAlienActivity', ActivityState)
		{
			// No, you're reinforcing me, jerk!
			if (ActivityState.GetMyTemplateName() == 'Reinforce' && OrigRegionState.GetReference() == Activitystate.PrimaryRegion && DestRegionState.GetReference() == ActivityState.SecondaryRegions[0])
				continue;

			// Shut up; I'm invading
			if (ActivityState.GetMyTemplateName() == 'Invasion' && OrigRegionState.GetReference() == ActivityState.SecondaryRegions[0])
				continue;
		}

		// if the rebels are in range of a plot site, I'm staying right here
		foreach History.IterateByClassType(class'XComGameState_MissionSite', MissionState)
		{
			if (MissionState.GetMissionSource().DataName == 'MissionSource_Blacksite' || MissionState.GetMissionSource().DataName == 'MissionSource_Forge')
			{
				if (MissionState.Region == OrigRegionState.GetReference() && OrigRegionState.ResistanceLevel > eResLevel_Unlocked && OrigRegionalAI.LocalAlertLevel <= 5)
					continue;
			}
			if (MissionState.GetMissionSource().DataName == 'MissionSource_PsiGate')
			{
				if (MissionState.Region == OrigRegionState.GetReference() && OrigRegionState.ResistanceLevel >= eResLevel_Unlocked && OrigRegionalAI.LocalAlertLevel <= 5)
					continue;
			}
		}
		
		// Do I have any to spare
		CurrentDelta = OrigRegionalAI.LocalAlertLevel - GetDesiredAlertLevel (OrigRegionState) - GetNumReinforceActivitiesOriginatingInRegion(OrigRegionRef);
		
		// Is the situation dire that I should send someone anyway, I'll see what I can spare -- if it's not so bad here or I got a bunch
		If (CurrentDelta < 1 && (CurrentDelta >= -3 || OrigRegionalAI.LocalAlertLevel > 8))
		{
			DestRegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(DestRegionState);
			// How bad is it in the destination
			if (DestRegionalAI.LocalAlertLevel - GetDesiredAlertLevel (DestRegionState) - GetNumReinforceActivitiesOriginatingInRegion(DestRegionState.GetReference()) <= -3)
			{
				// Set us beneath any origins who actually can spare some help but still leave reinfs possible
				CurrentDelta = 0.5;
			}
		}
		
		//`LWTRACE ("FindBestReinforceOrigRegion:" @ OrigRegionState.GetMyTemplate().DisplayName @ "Scores" @ string (Currentdelta) @ "wrt forces to spare");
		if(CurrentDelta > 0 && CurrentDelta > BiggestDelta)
		{
			BestOrigRegionState = OrigRegionState;
			BiggestDelta = CurrentDelta;
		}
	}
	
	return BestOrigRegionState;
}

//finds the best secondary (origin) reinforcement region, based on difference between alertlevel and vigilancelevel
simulated function array<StateObjectReference> GetSecondaryRegions(XComGameState NewGameState, XComGameState_LWAlienActivity ActivityState)
{
	local XComGameState_WorldRegion DestRegionState, OrigRegionState;
	local array<StateObjectReference> OrigRegionRefs;

	DestRegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
	if(DestRegionState == none)
		DestRegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));

	if(DestRegionState != none)
	{
		OrigRegionState = FindBestReinforceOrigRegion(DestRegionState, NewGameState);
		OrigRegionRefs.AddItem(OrigRegionState.GetReference());
	}
	else
	{
		`REDSCREEN("Reinforce Activity : GetSecondaryRegions called but no primary region found.");
	}
	//`LWTRACE("ReinforceRegion : Choosing Secondary Region " $ OrigRegionState.GetMyTemplate().DisplayName );

	return OrigRegionRefs;
}

//get the number of current active reinforce activies already emanating from this region
simulated function int GetNumReinforceActivitiesOriginatingInRegion(StateObjectReference RegionRef)
{
	local int NumActivities;
	local XComGameState_LWAlienActivity Activity;

	foreach ActivityStates(Activity)
	{
		if (Activity.GetMyTemplateName() != 'ReinforceActivity')
			continue;

		if (Activity.SecondaryRegions.Find('ObjectID', RegionRef.ObjectID) == -1)
			continue;

		++NumActivities;
	}

	return NumActivities;
}