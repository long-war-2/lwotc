class X2Condition_HeavyArmor extends X2Condition;

// checking if target unit has heavy armor equipped
//	condition succeeds if the unit DOES NOT have it.

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(kTarget);
	if (UnitState == none)	return 'AA_NotAUnit';

	if (CanEverBeValid(UnitState, false)) return 'AA_Success';

	return 'AA_AbilityUnavailable';
}

function bool CanEverBeValid(XComGameState_Unit SourceUnit, bool bStrategyCheck)
{
	local XComGameState_Item	ItemState;
	local X2ArmorTemplate		ArmorTemplate;

	ItemState = SourceUnit.GetItemInSlot(eInvSlot_Armor);

	//`LOG("Can ever be valid check for unit:" @ SourceUnit.GetFullName() @ ItemState.GetMyTemplateName(),, 'LW_RocketLauncher_Integrated');

	if (ItemState != none) 
	{
		ArmorTemplate = X2ArmorTemplate(ItemState.GetMyTemplate());

		if (ArmorTemplate != none)
		{
			//`LOG("First checks:" @ class'X2Item_IRI_RocketLaunchers'.default.MOBILITY_PENALTY_IS_APPLIED_TO_HEAVY_ARMOR ,, 'LW_RocketLauncher_Integrated');
			if (!class'X2Item_IRI_RocketLaunchers'.default.MOBILITY_PENALTY_IS_APPLIED_TO_HEAVY_ARMOR && (ArmorTemplate.ArmorClass == 'heavy' || ArmorTemplate.bHeavyWeapon)) 
			{
				//`LOG("returninfg false because it's heavy armor",, 'LW_RocketLauncher_Integrated');
				return false;
			}

			if (!class'X2Item_IRI_RocketLaunchers'.default.MOBILITY_PENALTY_IS_APPLIED_TO_SPARK_ARMOR && ArmorTemplate.ArmorCat == 'spark') return false;
		}
	}
	return true;
}