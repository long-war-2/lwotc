class X2AbilityCharges_Extended extends X2AbilityCharges;

struct BonusChargeFromItem
{
    var name ItemName;
    var int NumCharges;
};

var array<BonusChargeFromItem> BonusChargesFromItems;

function AddBonusChargeFromItem(const name ItemName, const int NumCharges)
{
    local BonusChargeFromItem NewBonus;

    NewBonus.ItemName = ItemName;
    NewBonus.NumCharges = NumCharges;
    BonusChargesFromItems.AddItem(NewBonus);
}

function int GetInitialCharges(XComGameState_Ability Ability, XComGameState_Unit Unit) 
{ 
    local int Charges;
    local int i;

    Charges = InitialCharges;

    for (i = 0; i < BonusCharges.Length; i++)
    {
        if (Unit.HasAbilityFromAnySource(BonusCharges[i].AbilityName))
        {
            Charges += BonusCharges[i].NumCharges;
        }
    }

    for (i = 0; i < BonusChargesFromItems.Length; i++)
    {
        if (Unit.HasItemOfTemplateType(BonusChargesFromItems[i].ItemName))
        {
            Charges += BonusChargesFromItems[i].NumCharges;
        }
    }

    return Charges; 
}

defaultproperties
{
    InitialCharges = 1
}