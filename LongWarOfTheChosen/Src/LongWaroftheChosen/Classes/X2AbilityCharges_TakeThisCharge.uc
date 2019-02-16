class X2AbilityCharges_TakeThisCharge extends X2AbilityCharges;

function int GetInitialCharges(XComGameState_Ability Ability, XComGameState_Unit Unit)
{
    local int Charges;

    Charges = InitialCharges;
	if (Unit.HasSoldierAbility('PistolStandardShot', true)) // || Unit.HasItemOfTemplateType (BonusItem))
	{
		Charges = 1;
	}
	else
	{
		Charges = 0;
	}
	return Charges;
}

defaultproperties
{
    InitialCharges=0
}