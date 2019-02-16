//---------------------------------------------------------------------------------------
//  FILE:    X2LWActivityCondition.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//	PURPOSE: Conditional emchanics for creation of alien activities
//---------------------------------------------------------------------------------------
class X2LWActivityCondition extends Object abstract;

simulated function bool MeetsCondition(X2LWActivityCreation ActivityCreation, XComGameState NewGameState) {return true;}
simulated function bool MeetsConditionWithRegion(X2LWActivityCreation ActivityCreation, XComGameState_WorldRegion Region, XComGameState NewGameState) {return true;}
