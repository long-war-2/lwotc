//---------------------------------------------------------------------------------------
//  FILE:    X2Condition_UnitPropsTacticalDE.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Conditional on the target unit meeting certain rules, such as being an enemy
//           or being of a certain character type.
//---------------------------------------------------------------------------------------

class X2Condition_UnitPropsTacticalDE extends X2Condition dependson(X2Ability_DarkEvents_LW);

var ApplicationRulesType ApplicationRules;
var array<name> ApplicationTargets;

function bool CanEverBeValid(XComGameState_Unit SourceUnit, bool bStrategyCheck)
{
	switch (ApplicationRules)
	{
	case  eAR_ADVENTClones:
		return SourceUnit.IsAdvent() && !SourceUnit.IsRobotic();

	case eAR_AllADVENT:
		return SourceUnit.IsAdvent();

	case eAR_Robots:
		return SourceUnit.IsAdvent() && SourceUnit.IsRobotic();

	case eAR_Aliens:
		return SourceUnit.IsAlien();

	case eAR_AllEnemies:
		return SourceUnit.IsAlien() || SourceUnit.IsAdvent();

	case eAR_CustomList:
		return ApplicationTargets.Find(SourceUnit.GetMyTemplateName()) != INDEX_NONE;

	default:
		return false;
	}
}
