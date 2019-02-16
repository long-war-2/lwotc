//---------------------------------------------------------------------------------------
//  FILE:    X2LWActivityCreation_SafestRegion.uc
//  AUTHOR:  JL / Pavonis Interactive
//	PURPOSE: Extended Creation class that optimizes to putting activity in somewhat random yet strategically important location
//---------------------------------------------------------------------------------------
class X2LWActivityCreation_AlertUFOLandingRegion extends X2LWActivityCreation;



// only allow once to be created per cycle, then the global cooldown will take effect
simulated function int GetNumActivitiesToCreate(XComGameState NewGameState)
{
	PrimaryRegions = FindValidRegions(NewGameState);
	NumActivitiesToCreate = Min(NumActivitiesToCreate, 1);
	return NumActivitiesToCreate;
}

simulated function StateObjectReference FindBestPrimaryRegion(XComGameState NewGameState)
{
	local XComGameStateHistory	History;
	local StateObjectReference NullRef;
	local array<StateObjectReference> BestRegions;
	local XComGameState_WorldRegion		RegionState;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;
	local int k;
	local XComGameState_MissionSite MissionState;
	local XComGameState_LWAlienActivity ActivityState;
	local XComGameState_HeadquartersResistance ResistanceHQ;

	if (PrimaryRegions.Length == 0)
		return NullRef;

	History = `XCOMHISTORY;
	BestRegions.Length = 0;
    ResistanceHQ = XComGameState_HeadquartersResistance(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));
	for (k = 0; k < PrimaryRegions.Length; k++)
	{
		RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(PrimaryRegions[k].ObjectID));
		RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState, NewGameState);
		
		if (RegionalAI == none)
		{
			`LWTRACE("Picking Random Region, FindBestPrimaryRegion: Can't Find Regional AI for" @ RegionState.GetMyTemplate().DisplayName);
			return PrimaryRegions[`SYNC_RAND(PrimaryRegions.Length)];
		}

		if (RegionalAI.bLiberated)
			continue;

		if (RegionalAI.LocalAlertLevel > class'X2LWActivityCreation_Reinforce'.default.MAX_ALERT_FOR_REINFORCE)
			continue;

		if (ResistanceHQ.NumMonths == 0 && RegionState.IsStartingRegion())
			continue;

		if(RegionalAI.LocalVigilanceLevel > RegionalAI.LocalAlertLevel - 2)
			BestRegions.AddItem (PrimaryRegions[k]);
		
		if(RegionalAI.bHasResearchFacility)
		{
			BestRegions.AddItem (PrimaryRegions[k]);
			BestRegions.AddItem (PrimaryRegions[k]);
		}
		if(RegionalAI.LocalVigilanceLevel > RegionalAI.LocalAlertLevel)
			BestRegions.AddItem (PrimaryRegions[k]);
		if(RegionalAI.LocalVigilanceLevel > RegionalAI.LocalAlertLevel + 1)
			BestRegions.AddItem (PrimaryRegions[k]);
		if(RegionalAI.LocalVigilanceLevel > RegionalAI.LocalAlertLevel + 3)
			BestRegions.AddItem (PrimaryRegions[k]);

		foreach History.IterateByClassType(class'XComGameState_MissionSite', MissionState)
		{
			if (MissionState.GetMissionSource().DataName == 'MissionSource_Blacksite')
			{
				if (MissionState.Region == RegionState.GetReference())
				{
					BestRegions.AddItem (PrimaryRegions[k]);
					BestRegions.AddItem (PrimaryRegions[k]);
				}
				if(MissionState.GetWorldRegion().LinkedRegions.Find('ObjectID', RegionState.ObjectID) != -1)
				{
					BestRegions.AddItem (PrimaryRegions[k]);
				}
			}
			if (MissionState.Region == RegionState.GetReference() && MissionState.GetMissionSource().DataName == 'MissionSource_Forge')
			{
				BestRegions.AddItem (PrimaryRegions[k]);
				BestRegions.AddItem (PrimaryRegions[k]);
				BestRegions.AddItem (PrimaryRegions[k]);
				if(MissionState.GetWorldRegion().LinkedRegions.Find('ObjectID', RegionState.ObjectID) != -1)
				{
					BestRegions.AddItem (PrimaryRegions[k]);
				}
			}
			if (MissionState.Region == RegionState.GetReference() && MissionState.GetMissionSource().DataName == 'MissionSource_PsiGate')
			{
				BestRegions.AddItem (PrimaryRegions[k]);
				BestRegions.AddItem (PrimaryRegions[k]);
				BestRegions.AddItem (PrimaryRegions[k]);
				BestRegions.AddItem (PrimaryRegions[k]);
				if(MissionState.GetWorldRegion().LinkedRegions.Find('ObjectID', RegionState.ObjectID) != -1)
				{
					BestRegions.AddItem (PrimaryRegions[k]);
				}
			}
		}
		foreach History.IterateByClassType(class'XComGameState_LWAlienActivity', ActivityState)
		{
			if (ActivityState.GetMyTemplateName() == 'ProtectRegion' && RegionState.GetReference() == ActivityState.PrimaryRegion)
				BestRegions.AddItem (PrimaryRegions[k]);
			if (ActivityState.GetMyTemplateName() == 'BuildResearchFacility' && RegionState.GetReference() == ActivityState.PrimaryRegion)
				BestRegions.AddItem (PrimaryRegions[k]);
			if (ActivityState.GetMyTemplateName() == 'Invasion' && RegionState.GetReference() == ActivityState.SecondaryRegions[0])
			{
				BestRegions.AddItem (PrimaryRegions[k]);
				BestRegions.AddItem (PrimaryRegions[k]);
			}
		}
	}		

	if (BestRegions.Length == 0)
		return PrimaryRegions[`SYNC_RAND(PrimaryRegions.Length)];
	
	return BestRegions[`SYNC_RAND(BestRegions.Length)];
}
