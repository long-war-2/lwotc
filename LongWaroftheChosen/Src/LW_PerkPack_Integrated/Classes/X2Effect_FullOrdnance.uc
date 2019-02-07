//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_FullOrdnance
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Effect for additional charge from utility slot item, if it is a grenade
//--------------------------------------------------------------------------------------- 

class X2Effect_FullOrdnance extends X2Effect_Persistent config(LW_SoldierSkills);

var config int FULL_ORDNANCE_BONUS;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameStateHistory		History;
	local XComGameState_Unit		UnitState; 
	local XComGameState_Item		ItemState, UpdatedItemState, ItemInnerIter;
	local X2WeaponTemplate			WeaponTemplate;
	local int						Idx, InnerIdx, BonusAmmo;;

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
					if (ItemState.InventorySlot == eInvSlot_Utility)
						BonusAmmo += default.FULL_ORDNANCE_BONUS;

					for (InnerIdx = Idx + 1; InnerIdx < UnitState.InventoryItems.Length; ++InnerIdx)
					{
						ItemInnerIter = XComGameState_Item(History.GetGameStateForObjectID(UnitState.InventoryItems[InnerIdx].ObjectID));
						if (ItemInnerIter != none && ItemInnerIter.GetMyTemplate() == WeaponTemplate)
						{
							if (ItemInnerIter.InventorySlot == eInvSlot_Utility)
								BonusAmmo += default.FULL_ORDNANCE_BONUS;
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


defaultProperties
{
    EffectName="FullOrdnance"
	bInfiniteDuration = true;
}