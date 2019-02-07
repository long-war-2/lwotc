//--------------------------------------------------------------------------------------- 
//  FILE:    X2Condition_HasEnoughIntel;
//  AUTHOR:  JL (Pavonis Interactive)
//  PURPOSE: Adds a check against strategic intel
//---------------------------------------------------------------------------------------
class X2Condition_HasEnoughIntel extends X2Condition;

var int MinIntel;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	local StrategyCost StratCost;
	local ArtifactCost IntelCost;
	local array<StrategyCostScalar> CostScalars;	

	IntelCost.ItemTemplateName = 'Intel';
	IntelCost.Quantity = MinIntel;
	StratCost.ResourceCosts.AddItem(IntelCost);
	CostScalars.length = 0;

	if (`XCOMHQ.CanAffordAllStrategyCosts(StratCost, CostScalars))
		return 'AA_Success';

	return 'AA_InsufficientIntel';	
}
