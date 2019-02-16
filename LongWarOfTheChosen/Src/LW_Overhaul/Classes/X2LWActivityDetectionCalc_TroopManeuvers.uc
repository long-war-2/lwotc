//---------------------------------------------------------------------------------------
//  FILE:    X2LWActivityDetectionCalc_TroopManeuvers.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//	PURPOSE: Adds additional detection chance for AlertLevel
//---------------------------------------------------------------------------------------
class X2LWActivityDetectionCalc_TroopManeuvers extends X2LWActivityDetectionCalc;

var float DetectionChancePerLocalAlert;

function float GetDetectionChance(XComGameState_LWAlienActivity ActivityState, X2LWAlienActivityTemplate ActivityTemplate, XComGameState_LWOutpost OutpostState)
{
	local float DetectionChance, BonusAlertDetectionChance;
	local XComGameState_WorldRegion_LWStrategyAI	RegionalAI;

	DetectionChance = super.GetDetectionChance(ActivityState, ActivityTemplate, OutpostState);

	RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(GetRegion(ActivityState));

	BonusAlertDetectionChance = float(RegionalAI.LocalAlertLevel) * DetectionChancePerLocalAlert;
	BonusAlertDetectionChance *= float(class'X2LWAlienActivityTemplate'.default.HOURS_BETWEEN_ALIEN_ACTIVITY_DETECTION_UPDATES) / 24.0;
	DetectionChance += BonusAlertDetectionChance;

	return DetectionChance;
}
