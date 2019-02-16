//---------------------------------------------------------------------------------------
//  FILE:    X2LWActivityCreation_ProtectResearch.uc
//  AUTHOR:  JL / Pavonis Interactive
//	PURPOSE: This ensures conditions for creation, particularly how many PR activities 
//  are already out there, are checked only once per tick, to avoid spamming this activity
//---------------------------------------------------------------------------------------
class X2LWActivityCreation_ProtectResearch extends X2LWActivityCreation;



simulated function int GetNumActivitiesToCreate(XComGameState NewGameState)
{
	PrimaryRegions = FindValidRegions(NewGameState);

	NumActivitiesToCreate = PrimaryRegions.length;
	NumActivitiesToCreate = Min(NumActivitiesToCreate, 1);
	
	`LWTRACE ("Attempting to create ProtectResearch" @ NumActivitiesToCreate);

	return NumActivitiesToCreate;
}