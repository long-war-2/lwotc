class X2AbilityCharges_BonusCharges extends X2AbilityCharges;

var int BonusChargesCount;
var name BonusAbility;
var name BonusItem;

function int GetInitialCharges(XComGameState_Ability Ability, XComGameState_Unit Unit)
{
    local int Charges;

    Charges = InitialCharges;
	if (Unit.HasSoldierAbility(BonusAbility, true))
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