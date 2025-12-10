class X2Condition_UnitInventoryExpanded extends X2Condition;

var() EInventorySlot RelevantSlot;
var() array<name> ExcludeWeaponCategory;
var() array<name> RequireWeaponCategory;
var name ExcludeTemplateName;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	local XComGameState_Item RelevantItem;
	local XComGameState_Unit UnitState;
	local X2WeaponTemplate WeaponTemplate;

	UnitState = XComGameState_Unit(kTarget);
	if (UnitState == none)
		return 'AA_NotAUnit';

	RelevantItem = UnitState.GetItemInSlot(RelevantSlot);
	if (RelevantItem != none)
		WeaponTemplate = X2WeaponTemplate(RelevantItem.GetMyTemplate());

	if (ExcludeWeaponCategory.Length > 0)
	{		
		if (WeaponTemplate != none && ExcludeWeaponCategory.Find(WeaponTemplate.WeaponCat) != INDEX_NONE)
			return 'AA_WeaponIncompatible';
	}
	if (RequireWeaponCategory.Length > 0)
	{
		if (WeaponTemplate == none || RequireWeaponCategory.Find(WeaponTemplate.WeaponCat) == INDEX_NONE)
			return 'AA_WeaponIncompatible';
	}

	if (ExcludeTemplateName != '')
	{
		if(UnitState.HasItemOfTemplateType(ExcludeTemplateName))
			return 'AA_WeaponIncompatible'; 
	}

	return 'AA_Success';
}