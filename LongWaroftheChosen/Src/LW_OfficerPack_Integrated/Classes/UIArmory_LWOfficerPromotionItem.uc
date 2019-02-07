//---------------------------------------------------------------------------------------
//  FILE:    UIArmory_LWOfficerPromotionItem
//  AUTHOR:  Amineri
//
//  PURPOSE: Tweaked ability selection UI for LW officer system
//
//--------------------------------------------------------------------------------------- 

class UIArmory_LWOfficerPromotionItem extends UIArmory_PromotionItem;

//override Mouse Controls to point back to UIArmory_LWOfficerPromotion mouse handlers
// all other functionality identical to parent method
simulated function OnChildMouseEvent(UIPanel ChildControl, int cmd)
{
	local bool bHandled;
	local UIArmory_LWOfficerPromotion PromotionScreen;

	bHandled = true;
	PromotionScreen = UIArmory_LWOfficerPromotion(Screen);

	switch(ChildControl)  
	{
	case AbilityIcon1:
		if(cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_UP)
		{
			if(bEligibleForPromotion)
				PromotionScreen.ConfirmAbilitySelection(Rank, 0);
			else
				Movie.Pres.PlayUISound(eSUISound_MenuClickNegative);
		}
		else if(cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_IN)
		{
			OnReceiveFocus();
			AbilityIcon1.OnReceiveFocus();
			RealizePromoteState();
		}
		else if(cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT || cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OUT)
		{
			AbilityIcon1.OnLoseFocus();
			RealizePromoteState();
		}
		break;
	case AbilityIcon2:
		if(cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_UP)
		{
			if(bEligibleForPromotion)
				PromotionScreen.ConfirmAbilitySelection(Rank, 1);
			else
				Movie.Pres.PlayUISound(eSUISound_MenuClickNegative);
		}
		else if(cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_IN || cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OVER)
		{
			OnReceiveFocus();
			AbilityIcon2.OnReceiveFocus();
			RealizePromoteState();
		}
		else if(cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT || cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OUT)
		{
			AbilityIcon2.OnLoseFocus();
			RealizePromoteState();
		}
		break;
	case InfoButton1:
	case InfoButton2:
		if(cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_UP)
		{
			OnAbilityInfoClicked(UIButton(ChildControl));
		}
		else if(cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_IN || cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OVER)
		{
			OnReceiveFocus();
		}
		break;
	case ClassIcon:
		if(cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_IN || cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OVER)
		{
			OnReceiveFocus();
		}
		break;
	default:
		bHandled = false;
		break;
	}

	if( bHandled )
		RealizeVisuals();
}