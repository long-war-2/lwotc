//---------------------------------------------------------------------------------------
//  FILE:    UIArmory_LWOfficerPromotionItem 
//  AUTHOR:  Amineri
//  PURPOSE: Tweaked ability selection UI for LW officer system
//--------------------------------------------------------------------------------------- 

class UIArmory_LWOfficerPromotionItem extends UIArmory_PromotionItem;

// Override Mouse Controls to point back to UIArmory_LWOfficerPromotion mouse handlers
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
			if (cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_UP)
			{
				if (bEligibleForPromotion)
				{
					PromotionScreen.ConfirmAbilitySelection(Rank, 0);
				}
				else
				{
					Movie.Pres.PlayUISound(eSUISound_MenuClickNegative);
				}
			}
			else if (cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_IN)
			{
				OnReceiveFocus();
				AbilityIcon1.OnReceiveFocus();
				RealizePromoteState();
			}
			else if (cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT || cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OUT)
			{
				AbilityIcon1.OnLoseFocus();
				RealizePromoteState();
			}
			break;
		
		case AbilityIcon2:
			if (cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_UP)
			{
				if (bEligibleForPromotion)
				{
					PromotionScreen.ConfirmAbilitySelection(Rank, 1);
				}
				else
				{
					Movie.Pres.PlayUISound(eSUISound_MenuClickNegative);
				}
			}
			else if (cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_IN || cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OVER)
			{
				OnReceiveFocus();
				AbilityIcon2.OnReceiveFocus();
				RealizePromoteState();
			}
			else if (cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT || cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OUT)
			{
				AbilityIcon2.OnLoseFocus();
				RealizePromoteState();
			}
			break;
		
		case InfoButton1:
		case InfoButton2:
			if (cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_UP)
			{
				OnAbilityInfoClicked(UIButton(ChildControl));
			}
			else if (cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_IN || cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OVER)
			{
				OnReceiveFocus();
			}
			break;
		
		case ClassIcon:
			if (cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_IN || cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OVER)
			{
				OnReceiveFocus();
			}
			break;
		
		default:
			bHandled = false;
			break;
	}

	if (bHandled)
	{
		RealizeVisuals();
	}
}

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	if (!CheckInputIsReleaseOrDirectionRepeat(cmd, arg))
	{
		return false;
	}
	
	switch(cmd)
	{
		case class'UIUtilities_Input'.const.FXS_VIRTUAL_LSTICK_LEFT:
		case class'UIUtilities_Input'.const.FXS_DPAD_LEFT:
		case class'UIUtilities_Input'.const.FXS_ARROW_LEFT:
			if (AbilityIcon1.bIsVisible)
			{
				OnChildMouseEvent(AbilityIcon1, class'UIUtilities_Input'.const.FXS_L_MOUSE_IN);
				OnChildMouseEvent(AbilityIcon2, class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT);
				SelectedAbility = 0;
				// KDM : Let SelectedAbilityIndex know that the left ability has been selected; this information will be used when
				// we select a new row.
				UIArmory_Promotion(Screen).SelectedAbilityIndex = SelectedAbility;
			}
			return true;

		case class'UIUtilities_Input'.const.FXS_VIRTUAL_LSTICK_RIGHT:
		case class'UIUtilities_Input'.const.FXS_DPAD_RIGHT:
		case class'UIUtilities_Input'.const.FXS_ARROW_RIGHT:
			if (AbilityIcon2.bIsVisible)
			{
				OnChildMouseEvent(AbilityIcon1, class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT);
				OnChildMouseEvent(AbilityIcon2, class'UIUtilities_Input'.const.FXS_L_MOUSE_IN);
				SelectedAbility = 1;
				// KDM : Let SelectedAbilityIndex know that the right ability has been selected; this information will be used when
				// we select a new row.
				UIArmory_Promotion(Screen).SelectedAbilityIndex = SelectedAbility;
			}
			return true;
		
		case class'UIUtilities_Input'.const.FXS_DPAD_UP:
		case class'UIUtilities_Input'.const.FXS_VIRTUAL_LSTICK_UP:
		case class'UIUtilities_Input'.const.FXS_ARROW_UP:
			if (self != UIArmory_Promotion(Screen).ClassRowItem)
			{
				// KDM : When a new row is selected, UIArmory_LWOfficerPromotion --> PreviewRow() will make sure that ability selection
				// remains consistent between the previous row and newly selected row.
				OnChildMouseEvent(AbilityIcon1, class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT);
				OnChildMouseEvent(AbilityIcon2, class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT);
			}
			break;

		case class'UIUtilities_Input'.const.FXS_DPAD_DOWN:
		case class'UIUtilities_Input'.const.FXS_VIRTUAL_LSTICK_DOWN:
		case class'UIUtilities_Input'.const.FXS_ARROW_DOWN:
			if (UIArmory_Promotion(Screen).List.SelectedIndex < UIArmory_Promotion(Screen).List.GetItemCount() - 1)
			{
				// KDM : When a new row is selected, UIArmory_LWOfficerPromotion --> PreviewRow() will make sure that ability selection
				// remains consistent between the previous row and newly selected row.
				OnChildMouseEvent(AbilityIcon1, class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT);
				OnChildMouseEvent(AbilityIcon2, class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT);
			}
			break;

		case class'UIUtilities_Input'.const.FXS_BUTTON_A:
		case class'UIUtilities_Input'.const.FXS_KEY_ENTER:
		case class'UIUtilities_Input'.const.FXS_KEY_SPACEBAR:
			if (!bEligibleForPromotion)
			{
				return false;
			}

			// KDM : SelectedAbilityIndex need not be updated here since the A button does nothing to change the selected ability.

			if (SelectedAbility == 0)
			{
				OnChildMouseEvent(AbilityIcon1, class'UIUtilities_Input'.const.FXS_L_MOUSE_UP);
			}
			else if (SelectedAbility == 1)
			{
				OnChildMouseEvent(AbilityIcon2, class'UIUtilities_Input'.const.FXS_L_MOUSE_UP);
			}
			return true;

		case class'UIUtilities_Input'.const.FXS_BUTTON_L3:
			if (!bIsDisabled)
			{
				// KDM : SelectedAbilityIndex need not be updated here since the L3 button does nothing to change the selected ability.

				if (SelectedAbility == 0)
				{
					OnChildMouseEvent(InfoButton1, class'UIUtilities_Input'.const.FXS_L_MOUSE_UP);
				}
				else if (SelectedAbility == 1)
				{
					OnChildMouseEvent(InfoButton2, class'UIUtilities_Input'.const.FXS_L_MOUSE_UP);
				}
			}
			return true;
	}

	return super(UIPanel).OnUnrealCommand(cmd, arg);
}
