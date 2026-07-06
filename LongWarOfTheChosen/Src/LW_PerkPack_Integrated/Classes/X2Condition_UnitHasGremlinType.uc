class X2Condition_UnitHasGremlinType extends X2Condition;

var() EInventorySlot RelevantSlot;
var() name RequireWeaponCategory;
var() name RequireWeaponName;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	local XComGameState_Item RelevantItem;
	local XComGameState_Unit UnitState;
	local X2GremlinTemplate GremlinTemplate;

	UnitState = XComGameState_Unit(kTarget);
	if (UnitState == none)
		return 'AA_NotAUnit';

	RelevantItem = UnitState.GetItemInSlot(RelevantSlot);
	if (RelevantItem != none)
		GremlinTemplate = X2GremlinTemplate(RelevantItem.GetMyTemplate());

	if (RequireWeaponName != '')
	{
		if (RelevantItem == none || X2GremlinTemplate(RelevantItem.GetMyTemplate()).DataName != RequireWeaponName)
			return 'AA_WeaponIncompatible';
	}

	return 'AA_Success';
}
