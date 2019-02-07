//---------------------------------------------------------------------------------------
//  FILE:    X2Condition_UnitDoesNotHaveItem.uc
//  AUTHOR:  tracktwo / Pavonis Interactive
//  
//  PURPOSE: Condition for abilities only available if a unit is NOT carrying a particular 
//           item.
//---------------------------------------------------------------------------------------
class X2Condition_UnitDoesNotHaveItem extends X2Condition;

var name ItemTemplateName;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	local XComGameState_Unit Unit;
	
	Unit = XComGameState_Unit(kTarget);
	if (Unit == none)
		return 'AA_NotAUnit';

	if (Unit.HasItemOfTemplateType(ItemTemplateName))
	{
		return 'AA_AbilityUnavailable';
	}

	return 'AA_Success';
}

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{
	local XComGameState_Unit Unit;
	
	Unit = XComGameState_Unit(kSource);
	if (Unit == none)
		return 'AA_NotAUnit';

	if (Unit.HasItemOfTemplateType(ItemTemplateName))
	{
		return 'AA_AbililtyUnavailable';
	}

	return 'AA_Success';
}
