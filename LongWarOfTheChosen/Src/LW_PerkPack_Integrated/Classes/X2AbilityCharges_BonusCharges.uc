class X2AbilityCharges_BonusCharges extends X2AbilityCharges;

var int BonusChargesCount;
var name BonusAbility;
var name BonusItem;

function int GetInitialCharges(XComGameState_Ability Ability, XComGameState_Unit Unit)
{
    local int Charges;

	// Get base ability bonuses for other compatibility
	Charges = super.GetInitialCharges(Ability, Unit);

	// Handle LW ones for legacy compatibility
	if (Unit.HasAbilityFromAnySource(BonusAbility))
	{
		Charges += BonusChargesCount;
	}
	if(Unit.HasItemOfTemplateType (BonusItem))
	{
		Charges += BonusChargesCount;
	}
	return Charges;
}

defaultproperties
{
    InitialCharges=1
}