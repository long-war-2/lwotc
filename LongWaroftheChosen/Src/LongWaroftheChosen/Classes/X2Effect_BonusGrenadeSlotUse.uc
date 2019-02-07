//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_BonusGrenadeSlotUse
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: General effect for granting extra uses of items in grenade slot
//--------------------------------------------------------------------------------------- 

class X2Effect_BonusGrenadeSlotUse extends X2Effect_Persistent;

var int BonusUses;
var bool bDamagingGrenadesOnly;
var bool bNonDamagingGrenadesOnly;
var EInventorySlot SlotType;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameStateHistory		History;
	local XComGameState_Unit		UnitState; 
	local XComGameState_Item		ItemState, UpdatedItemState, ItemInnerIter;
	local X2WeaponTemplate			WeaponTemplate;
	local int						Idx, InnerIdx, BonusAmmo;

	History = `XCOMHISTORY;

	UnitState = XComGameState_Unit(kNewTargetState);
	if (UnitState == none)
		return;

	for (Idx = 0; Idx < UnitState.InventoryItems.Length; ++Idx)
	{
		ItemState = XComGameState_Item(History.GetGameStateForObjectID(UnitState.InventoryItems[Idx].ObjectID));
		if (ItemState != none && !ItemState.bMergedOut)
		{
			WeaponTemplate = X2WeaponTemplate(ItemState.GetMyTemplate());
			if(X2GrenadeTemplate(WeaponTemplate) != none || WeaponTemplate.DataName == 'Battlescanner')
			{
				BonusAmmo = 0;
				if (WeaponTemplate != none && WeaponTemplate.bMergeAmmo)
				{
					if (ItemState.InventorySlot == SlotType && ValidGrenadeType(ItemState, WeaponTemplate))
						BonusAmmo += BonusUses;

					for (InnerIdx = Idx + 1; InnerIdx < UnitState.InventoryItems.Length; ++InnerIdx)
					{
						ItemInnerIter = XComGameState_Item(History.GetGameStateForObjectID(UnitState.InventoryItems[InnerIdx].ObjectID));
						if (ItemInnerIter != none && ItemInnerIter.GetMyTemplate() == WeaponTemplate)
						{
							if (ItemInnerIter.InventorySlot == SlotType && ValidGrenadeType(ItemInnerIter, WeaponTemplate))
								BonusAmmo += BonusUses;
						}
					}
				
				}
				if(BonusAmmo > 0)
				{
					UpdatedItemState = XComGameState_Item(NewGameState.CreateStateObject(class'XComGameState_Item', ItemState.ObjectID));
					UpdatedItemState.Ammo += BonusAmmo;
					NewGameState.AddStateObject(UpdatedItemState);
				}
			}
		}
	}

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

simulated function bool ValidGrenadeType(XComGameState_Item ItemState, X2WeaponTemplate WeaponTemplate)
{
	if(bDamagingGrenadesOnly)
	{
		if(WeaponTemplate.BaseDamage.Damage <= 0)
			return false;
	}
	if(bNonDamagingGrenadesOnly)
	{
		if(WeaponTemplate.BaseDamage.Damage > 0)
			return false;
	}
	return true;
}

defaultProperties
{
	bInfiniteDuration = true;
}