//---------------------------------------------------------------------------------------
//  FILE:    X2LWActivityDetectionCalc_Terror.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Adds additional detection chance for AlertLevel
//---------------------------------------------------------------------------------------
class X2LWActivityDetectionCalc_Terror extends X2LWActivityDetectionCalc config(LW_Activities);

var config array<float> RESISTANCE_INFORMANT_DETECTION_DIVIDER;
var config float PER_FACELESS_TERROR_DETECTION_MODIFIER;

function float GetDetectionChance(XComGameState_LWAlienActivity ActivityState, X2LWAlienActivityTemplate ActivityTemplate, XComGameState_LWOutpost OutpostState)
{
	local float DetectionChance;
	local int k;

	DetectionChance = super.GetDetectionChance(ActivityState, ActivityTemplate, OutpostState);

	if (IsDarkEventActive('DarkEvent_ResistanceInformant'))
	{
		DetectionChance /= default.RESISTANCE_INFORMANT_DETECTION_DIVIDER[`STRATEGYDIFFICULTYSETTING];
	}

	for (k = 0; k < OutPostState.Rebels.length; k++)
	{
		if (OutPostState.Rebels[k].IsFaceless)
			DetectionChance *= default.PER_FACELESS_TERROR_DETECTION_MODIFIER;
	}

	return DetectionChance;
}

function bool IsDarkEventActive(name DarkEventName)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_DarkEvent DarkEventState;
	
	History = `XCOMHISTORY;
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	foreach History.IterateByClassType(class'XComGameState_DarkEvent', DarkEventState)
	{
		if(DarkEventState.GetMyTemplateName() == DarkEventName)
		{
			if(AlienHQ.ActiveDarkEvents.Find('ObjectID', DarkEventState.ObjectID) != -1)
			{
				return true;
			}
		}
	}
	return false;
}

