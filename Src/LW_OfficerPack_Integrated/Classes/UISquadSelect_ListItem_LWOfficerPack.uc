//---------------------------------------------------------------------------------------
//  FILE:    UISquadSelect_ListItem_LWOfficerPack.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Displays information pertaining to a single soldier in the Squad Select screen,
//			 extended for LW Officer functionality
//--------------------------------------------------------------------------------------- 

//DEPRECATED

class UISquadSelect_ListItem_LWOfficerPack extends UISquadSelect_ListItem;

//var UIICon OfficerIcon;
//
////override UpdateData in order to update officer icon at lower right corner
//simulated function UpdateData(optional int Index = -1, optional bool bDisableEdit, optional bool bDisableDismiss, optional bool bDisableLoadout, optional array<EInventorySlot> CannotEditSlotsList)
//{
	//local XComGameState_Unit Unit;
	//super.UpdateData(Index, bDisableEdit, bDisableDismiss);
//
	//Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(GetUnitRef().ObjectID));
//
	//if (Unit != none)
		//UpdateUtilityItems(Unit, bDisableLoadout, CannotEditSlotsList);
//
	//if (class'LWOfficerUtilities'.static.IsOfficer(Unit))
	//{
		//if (OfficerIcon == none) 
		//{
			//OfficerIcon = Spawn(class'UIIcon', DynamicContainer);
			//OfficerIcon.bAnimateOnInit = false;
			//OfficerIcon.InitIcon('abilityIcon1MC', class'LWOfficerUtilities'.static.GetGenericIcon(), false, true, 18);
		//} 
		//else 
		//{
			//OfficerIcon.Show();
		//}
		//OfficerIcon.OriginBottomRight();
		//OfficerIcon.SetPosition(50.5, 265);
	//} 
	//else 
	//{
		//if (OfficerIcon != none)
		//{
			//OfficerIcon.Hide();
		//}
	//}
//}
//
////override in order to provide custom UIPersonnel to prevent more than one officer from being added to squad
//simulated function OnClickedSelectUnitButton()
//{
	//local UISquadSelect SquadScreen;
	//local XComHQPresentationLayer HQPres;
	//local UIPersonnel_SquadSelect kPersonnelList;
//
	//HQPres = `HQPRES;
//
	//SquadScreen = UISquadSelect(Screen);
	//SquadScreen.m_iSelectedSlot = SlotIndex;
	//SquadScreen.bDirty = true;
	//SquadScreen.SnapCamera();
//
	//if(HQPres.ScreenStack.IsNotInStack(class'UIPersonnel_SquadSelect_LWOfficerPack'))
	//{
		//kPersonnelList = Spawn( class'UIPersonnel_SquadSelect_LWOfficerPack', HQPres );
		//kPersonnelList.onSelectedDelegate = ChangeSlot;
		//kPersonnelList.GameState = SquadScreen.UpdateState;
		//kPersonnelList.HQState = SquadScreen.XComHQ;
		//HQPres.ScreenStack.Push( kPersonnelList );
	//}
//}
//
//simulated function ChangeSlot(optional StateObjectReference UnitRef)
//{
	//local UISquadSelect SquadScreen;
	//SquadScreen = UISquadSelect(Screen);
//
	//SquadScreen.ChangeSlot(UnitRef);
	//SquadScreen.SignalOnReceiveFocus();
//}
//
//simulated function OnClickedDismissButton()
//{
	//super.OnClickedDismissButton();
	//UISquadSelect(Screen).SignalOnReceiveFocus();
//}
//
//simulated function UpdateUtilityItems(XComGameState_Unit Unit, optional bool bDisableLoadout, optional array<EInventorySlot> CannotEditSlotsList)
//{
	//local int i, NumUtilitySlots, UtilityItemIndex;
	//local float UtilityItemWidth, UtilityItemHeight;
	//local UISquadSelect_UtilityItem_LWOfficerPack UtilityItem;
	//local array<XComGameState_Item> EquippedItems;
//
	//NumUtilitySlots = 2;
	//if(Unit.HasGrenadePocket()) NumUtilitySlots++;
	//if(Unit.HasAmmoPocket()) NumUtilitySlots++;
		//
	//UtilityItemWidth = (UtilitySlots.GetTotalWidth() - (UtilitySlots.ItemPadding * (NumUtilitySlots - 1))) / NumUtilitySlots;
	//UtilityItemHeight = UtilitySlots.Height;
//
	//if((UtilitySlots.ItemCount != NumUtilitySlots) ||  UISquadSelect_UtilityItem_LWOfficerPack(UtilitySlots.GetItem(0)) == none)
		//UtilitySlots.ClearItems();
//
	//for(i = 0; i < NumUtilitySlots; ++i)
	//{
		//if(i >= UtilitySlots.ItemCount)
		//{
			//UtilityItem = UISquadSelect_UtilityItem_LWOfficerPack(UtilitySlots.CreateItem(class'UISquadSelect_UtilityItem_LWOfficerPack').InitPanel());
			//UtilityItem.SetSize(UtilityItemWidth, UtilityItemHeight);
			//UtilityItem.CannotEditSlots = CannotEditSlotsList;
			//UtilitySlots.OnItemSizeChanged(UtilityItem);
		//}
	//}
//
	//UtilityItemIndex = 0;
//
	//UtilityItem = UISquadSelect_UtilityItem_LWOfficerPack(UtilitySlots.GetItem(UtilityItemIndex++));
	//EquippedItems = class'UIUtilities_Strategy'.static.GetEquippedItemsInSlot(Unit, eInvSlot_Utility);
	//if (bDisableLoadout)
		//UtilityItem.SetDisabled(EquippedItems.Length > 0 ? EquippedItems[0] : none, eInvSlot_Utility, 0, NumUtilitySlots);
	//else
		//UtilityItem.SetAvailable(EquippedItems.Length > 0 ? EquippedItems[0] : none, eInvSlot_Utility, 0, NumUtilitySlots);
//
	////if(class'XComGameState_HeadquartersXCom'.static.GetObjectiveStatus('T0_M5_EquipMedikit') == eObjectiveState_InProgress)
	////{
		////// spawn the attention icon externally so it draws on top of the button and image 
		////Spawn(class'UIPanel', UtilityItem).InitPanel('attentionIconMC', class'UIUtilities_Controls'.const.MC_AttentionIcon)
		////.SetPosition(2, 4)
		////.SetSize(70, 70); //the animated rings count as part of the size. 
	////} else if(GetChildByName('attentionIconMC', false) != none) {
		////GetChildByName('attentionIconMC').Remove();
	////}
//
	//UtilityItem = UISquadSelect_UtilityItem_LWOfficerPack(UtilitySlots.GetItem(UtilityItemIndex++));
	//if (Unit.HasExtraUtilitySlot())
	//{
		//if (bDisableLoadout)
			//UtilityItem.SetDisabled(EquippedItems.Length > 1 ? EquippedItems[1] : none, eInvSlot_Utility, 1, NumUtilitySlots);
		//else
			//UtilityItem.SetAvailable(EquippedItems.Length > 1 ? EquippedItems[1] : none, eInvSlot_Utility, 1, NumUtilitySlots);
	//}
	//else
		//UtilityItem.SetLocked(m_strNeedsMediumArmor);
//
	//if(Unit.HasGrenadePocket())
	//{
		//UtilityItem = UISquadSelect_UtilityItem_LWOfficerPack(UtilitySlots.GetItem(UtilityItemIndex++));
		//EquippedItems = class'UIUtilities_Strategy'.static.GetEquippedItemsInSlot(Unit, eInvSlot_GrenadePocket); 
		//if (bDisableLoadout)
			//UtilityItem.SetDisabled(EquippedItems.Length > 0 ? EquippedItems[0] : none, eInvSlot_GrenadePocket, 0, NumUtilitySlots);
		//else
			//UtilityItem.SetAvailable(EquippedItems.Length > 0 ? EquippedItems[0] : none, eInvSlot_GrenadePocket, 0, NumUtilitySlots);
	//}
//
	//if(Unit.HasAmmoPocket())
	//{
		//UtilityItem = UISquadSelect_UtilityItem_LWOfficerPack(UtilitySlots.GetItem(UtilityItemIndex++));
		//EquippedItems = class'UIUtilities_Strategy'.static.GetEquippedItemsInSlot(Unit, eInvSlot_AmmoPocket);
		//if (bDisableLoadout)
			//UtilityItem.SetDisabled(EquippedItems.Length > 0 ? EquippedItems[0] : none, eInvSlot_AmmoPocket, 0, NumUtilitySlots);
		//else
			//UtilityItem.SetAvailable(EquippedItems.Length > 0 ? EquippedItems[0] : none, eInvSlot_AmmoPocket, 0, NumUtilitySlots);
	//}
//}