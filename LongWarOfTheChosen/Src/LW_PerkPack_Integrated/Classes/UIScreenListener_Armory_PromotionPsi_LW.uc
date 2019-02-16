//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_Armory_PromotionPsi_LW.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//
//  PURPOSE: Makes adjustments to the psi promotion UI to better fit 8 rows
//--------------------------------------------------------------------------------------- 

class UIScreenListener_Armory_PromotionPsi_LW extends UIScreenListener;

// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
	local UIArmory_PromotionPsiOp PromotionScreen;
	local XComGameState_Unit UnitState;
	local X2SoldierClassTemplate ClassTemplate;
	local string HeaderString;

	PromotionScreen = UIArmory_PromotionPsiOp(Screen);
	if(PromotionScreen == none)
	{
		`REDSCREEN("No PromotionScreen in UIArmory_PromotionPsiOp Screen Listener");
		return;
	}
	UnitState = PromotionScreen.GetUnit();
	ClassTemplate = UnitState.GetSoldierClassTemplate();

	HeaderString = PromotionScreen.m_strAbilityHeader;
	if (UnitState.GetRank() != 1 && UnitState.HasAvailablePerksToAssign())
	{
		HeaderString = PromotionScreen.m_strSelectAbility;
	}

	//blank out the titles to make room for the 8th row
	PromotionScreen.AS_SetTitle(ClassTemplate.IconImage, HeaderString, "", "", Caps(ClassTemplate.DisplayName));

	//Adjust the size/position/padding of the list
	PromotionScreen.List.SetPosition(59.5, 243);
	PromotionScreen.List.SetHeight(551);
	PromotionScreen.List.ItemPadding = -2;
	PromotionScreen.List.RealizeItems();
}

//This event is triggered after a screen receives focus
//event OnReceiveFocus(UIScreen Screen);

// This event is triggered after a screen loses focus
//event OnLoseFocus(UIScreen Screen);


// This event is triggered when a screen is removed
//event OnRemoved(UIScreen Screen);

defaultproperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = UIArmory_PromotionPsiOp;
}