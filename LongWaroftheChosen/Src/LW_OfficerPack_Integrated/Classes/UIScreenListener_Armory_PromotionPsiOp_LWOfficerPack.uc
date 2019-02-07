//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_Armor_Promotion_LWOfficerPack
//  AUTHOR:  Amineri
//
//  PURPOSE: Implements hooks to initiate Officer UI based on UIArmory classes
//--------------------------------------------------------------------------------------- 

class UIScreenListener_Armory_PromotionPsiOp_LWOfficerPack extends UIScreenListener deprecated;

//var UIButton OfficerButton;
//var UIArmory_PromotionPsiOp ParentScreen;
//
//// This event is triggered after a screen is initialized
//event OnInit(UIScreen Screen)
//{
	//ParentScreen = UIArmory_PromotionPsiOp(Screen);
	////if (OfficerButton == none)
		////AddFloatingButton();
//}
//
//// This event is triggered after a screen receives focus
//event OnReceiveFocus(UIScreen Screen)
//{
	//ParentScreen = UIArmory_PromotionPsiOp(Screen);
//
	////ParentScreen.Show();
	////if (OfficerButton == none)
		////AddFloatingButton();
//}
//
//// This event is triggered after a screen loses focus
//event OnLoseFocus(UIScreen Screen)
//{
	////ParentScreen.Hide();
//}
//
//// This event is triggered when a screen is removed
////event OnRemoved(UIScreen Screen);
//
//function AddFloatingButton()
//{
	//OfficerButton = ParentScreen.Spawn(class'UIButton', ParentScreen);
	//OfficerButton.InitButton('', Caps(class'UIScreenListener_Armory_Promotion_LWOfficerPack'.default.strOfficerMenuOption), OnButtonCallback, eUIButtonStyle_HOTLINK_BUTTON);
	//OfficerButton.SetResizeToText(false);
	//OfficerButton.SetFontSize(24);
	//OfficerButton.SetPosition(140, 80);
	//OfficerButton.SetSize(280, 40);
	//OfficerButton.Show();
//}
//
//simulated function OnButtonCallback(UIButton kButton)
//{
	//local XComHQPresentationLayer HQPres;
	//local UIArmory_LWOfficerPromotion OfficerScreen;
//
	//HQPres = `HQPRES;
	//OfficerScreen = UIArmory_LWOfficerPromotion(HQPres.ScreenStack.Push(HQPres.Spawn(class'UIArmory_LWOfficerPromotion', HQPres), HQPres.Get3DMovie()));
	//OfficerScreen.InitPromotion(ParentScreen.GetUnitRef(), false);
//}

defaultproperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = UIArmory_PromotionPsiOp;
}