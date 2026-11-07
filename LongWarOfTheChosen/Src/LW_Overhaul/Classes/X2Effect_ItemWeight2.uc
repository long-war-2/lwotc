class X2Effect_ItemWeight2 extends X2Effect_ModifyStats config(LW_Overhaul);

var config array<EInventorySlot> SlotsToSkip;
var privatewrite name WeightAbilityName;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Unit TargetUnit;
    local StatChange Change;

    TargetUnit = XComGameState_Unit(kNewTargetState);

    Change.StatType = eStat_Mobility;
    if (TargetUnit != none)
    {
        Change.StatAmount = -1 * GetItemWeightForUnit(TargetUnit, NewGameState);
    }
    NewEffectState.StatChanges.AddItem(Change);

    super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

static function int GetItemWeightForUnit(XComGameState_Unit UnitState, optional XComGameState CheckGameState)
{
    local array<XComGameState_Item> CurrentInventory;
    local XComGameState_Item        InventoryItem;
    local X2EquipmentTemplate       EquipmentTemplate;
    local int                       Weight, Index;

    CurrentInventory = UnitState.GetAllInventoryItems(CheckGameState);
    foreach CurrentInventory(InventoryItem)
    {
        if (default.SlotsToSkip.Find(InventoryItem.InventorySlot) == INDEX_NONE)
        {
            EquipmentTemplate = X2EquipmentTemplate(InventoryItem.GetMyTemplate());
            if (EquipmentTemplate != none)
            {
                if (EquipmentTemplate.Abilities.Find(default.WeightAbilityName) != INDEX_NONE)
                {
                    Index = class'LWTemplateMods'.default.ItemTable.Find('ItemTemplateName', EquipmentTemplate.DataName);
                    if (Index != INDEX_NONE)
                    {
                        Weight += class'LWTemplateMods'.default.ItemTable[Index].Weight;
                    }
                    else
                    {
                        Weight++;
                    }
                }
            }
        }
    }

    return Weight;
}

static function int GetIgnoredItemWeightForUnit(XComGameState_Unit UnitState, optional XComGameState CheckGameState)
{
    local array<XComGameState_Item> CurrentInventory;
    local XComGameState_Item        InventoryItem;
    local X2EquipmentTemplate       EquipmentTemplate;
    local int                       Weight, Index;

    CurrentInventory = UnitState.GetAllInventoryItems(CheckGameState);
    foreach CurrentInventory(InventoryItem)
    {
        if (default.SlotsToSkip.Find(InventoryItem.InventorySlot) != INDEX_NONE)
        {
            EquipmentTemplate = X2EquipmentTemplate(InventoryItem.GetMyTemplate());
            if (EquipmentTemplate != none)
            {
                if (EquipmentTemplate.Abilities.Find(default.WeightAbilityName) != INDEX_NONE)
                {
                    Index = class'LWTemplateMods'.default.ItemTable.Find('ItemTemplateName', EquipmentTemplate.DataName);
                    if (Index != INDEX_NONE)
                    {
                        Weight += class'LWTemplateMods'.default.ItemTable[Index].Weight;
                    }
                    else
                    {
                        Weight++;
                    }
                }
            }
        }
    }

    return Weight;
}

defaultproperties
{
    EffectName = "SmallItemWeight"
    DuplicateResponse = eDupe_Ignore

    WeightAbilityName = "SmallItemWeight"
}
