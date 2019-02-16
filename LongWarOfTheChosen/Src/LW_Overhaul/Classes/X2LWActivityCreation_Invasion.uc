//---------------------------------------------------------------------------------------
//  FILE:    X2LWActivityCreation_Invasion.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//	PURPOSE: Extended Creation class that selects invasion region based on neighboring regions
//---------------------------------------------------------------------------------------
class X2LWActivityCreation_Invasion extends X2LWActivityCreation config (LW_Activities);



var config int INVASION_MIN_ALERT_TO_LAUNCH;

simulated function StateObjectReference FindBestPrimaryRegion(XComGameState NewGameState)
{	
	local StateObjectReference			NullRef;
	local XComGameState_WorldRegion		RegionState;

	RegionState = FindInvasionTarget(NewGameState);
	`LWTRACE ("Searching for Invasion Candidates");
	if(RegionState == none)
		return NullRef;
	else
	{
		`LWTRACE ("Invasion Target Candidate Found" @ RegionState.GetMyTemplate().DisplayName);
		return RegionState.GetReference();
	}
}

simulated function XComGameState_WorldRegion FindInvasionTarget(XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_WorldRegion					RegionState, NeighborRegionState;
	local array<XComGameState_WorldRegion>			InvasionCandidates; 
	local StateObjectReference						TargetRegionRef, OrigRegionRef;
	local XComGameState_WorldRegion_LWStrategyAI	NeighborRegionAI;

	History = `XCOMHISTORY;
	//Find all liberated regions next to an alien region with troops to spare
	foreach PrimaryRegions(TargetRegionRef)
	{
		RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(TargetRegionRef.ObjectID));
		foreach RegionState.LinkedRegions(OrigRegionRef)
		{
			NeighborRegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(OrigRegionRef.ObjectID));
			NeighborRegionAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(NeighborRegionState, NewGameState);

			if (NeighborRegionAI == none)
			{
				`REDSCREEN ("FindInvasionTarget: Missing RegionalAI for " @ NeighborRegionState.GetMyTemplate().DisplayName);
				continue;
			}

			//`LWTRACE ("Contacted Invader Region Alert:" @ NeighborRegionAI.LocalAlertLevel @ "must be higher than vigilance:" @ NeighborRegionAI.LocalVigilanceLevel);

			// at least one region has an alert level higher than vigilance and sufficient alert to launch
			if (!NeighborRegionAI.bLiberated && NeighborRegionAI.LocalAlertLevel >= default.INVASION_MIN_ALERT_TO_LAUNCH)
			{
				if (InvasionCandidates.Find(RegionState) == -1)
					InvasionCandidates.AddItem(RegionState);
			}
		}
	}
	if (InvasionCandidates.Length == 0) 
		return none;
	else
		return InvasionCandidates[`SYNC_RAND(InvasionCandidates.Length)];
}

simulated function array<StateObjectReference> GetSecondaryRegions(XComGameState NewGameState, XComGameState_LWAlienActivity ActivityState)
{
	local XComGameState_WorldRegion DestRegionState, OrigRegionState;
	local array<StateObjectReference> OrigRegionRefs;


	DestRegionState = XComGameState_WorldRegion(NewGameState.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));
	if(DestRegionState == none)
		DestRegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(ActivityState.PrimaryRegion.ObjectID));

	if(DestRegionState == none)
	{
		`REDSCREEN("Invasion Activity : GetSecondaryRegions called but no primary region found.");
		return OrigRegionRefs;
	}

	OrigRegionState = FindInvasionOrig(DestRegionState, NewGameState);
	`LWTRACE("InvasionRegion : Choosing Secondary Region " $ OrigRegionState.GetMyTemplate().DisplayName );

	OrigRegionRefs.AddItem(OrigRegionState.GetReference());
	return OrigRegionRefs;
}

function XComGameState_WorldRegion FindInvasionOrig(XComGameState_WorldRegion DestRegionState, XComGameState NewGameState, optional out int BiggestDelta)
{
	local StateObjectReference						OrigRegionRef;
	local int										HighestAlert;
	local XComGameState_WorldRegion					NeighborRegionState;
	local array<XComGameState_WorldRegion>			OrigCandidates;
	local XComGameState_WorldRegion_LWStrategyAI	NeighborRegionAI;

	HighestAlert = 0;
	foreach DestRegionState.LinkedRegions(OrigRegionRef)
	{
		NeighborRegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(OrigRegionRef.ObjectID));
		NeighborRegionAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(NeighborRegionState, NewGameState);
		If (!NeighborRegionAI.bLiberated && NeighborRegionAI.LocalAlertLevel >= HighestAlert && NeighborRegionAI.LocalAlertLevel >= default.INVASION_MIN_ALERT_TO_LAUNCH)
		{
			HighestAlert = NeighborRegionAI.LocalAlertLevel;
		}
	}
	foreach DestRegionState.LinkedRegions(OrigRegionRef)
	{
		NeighborRegionState = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(OrigRegionRef.ObjectID));
		NeighborRegionAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(NeighborRegionState, NewGameState);
		If (!NeighborRegionAI.bLiberated && NeighborRegionAI.LocalAlertLevel >= HighestAlert)
		{
			OrigCandidates.AddItem (NeighborRegionState);
		}
	}
	if (OrigCandidates.length > 0)
	{
		return OrigCandidates[`SYNC_RAND(OrigCandidates.Length)];
	}
	else
	{
		`LWTRACE ("No Suitable Invasion Origin Found. HighestAlert is" @ HighestAlert);
		return none;
	}

}