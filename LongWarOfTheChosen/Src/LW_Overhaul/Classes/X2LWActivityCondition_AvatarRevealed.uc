//---------------------------------------------------------------------------------------
//  FILE:    X2LWActivityCondition_AvatarRevealed
//  AUTHOR:  JohnnyLump / Pavonis Interactive
//  PURPOSE: Conditionals on whether Avatar project has been revealed to the player
//---------------------------------------------------------------------------------------
class X2LWActivityCondition_AvatarRevealed extends X2LWActivityCondition;

simulated function bool MeetsCondition(X2LWActivityCreation ActivityCreation, XComGameState NewGameState)
{
	
	`LWTrace ("X2LWActivityCondition_AvatarRevealed" @ class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('S0_RevealAvatarProject'));
	
	if (class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('S0_RevealAvatarProject'))
		return true;

	return false;
}