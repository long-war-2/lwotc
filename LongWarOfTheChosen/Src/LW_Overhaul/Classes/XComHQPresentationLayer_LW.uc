// Exists to override promotion stuff until CHL fix gets pushed.

class XComHQPresentationLayer_LW extends XComHQPresentationLayer;




function ShowPromotionUI(StateObjectReference UnitRef, optional bool bInstantTransition)
{
	local UIArmory_Promotion PromotionUI;
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitRef.ObjectID));

	/*
	// Start Issue #600: Replaced class literals with the local variables
	if (UnitState.IsResistanceHero() || ScreenStack.IsInStack(class'UIFacility_TrainingCenter'))
		PromotionUI = UIArmory_PromotionHero(ScreenStack.Push(
			Spawn(TriggerOverridePromotionUIClass(eCHLPST_Hero), self), Get3DMovie()));
	else if (UnitState.GetSoldierClassTemplateName() == 'PsiOperative')
		PromotionUI = UIArmory_PromotionPsiOp(ScreenStack.Push(
			Spawn(TriggerOverridePromotionUIClass(eCHLPST_PsiOp), self), Get3DMovie()));
	else
		PromotionUI = UIArmory_Promotion(ScreenStack.Push(
			Spawn(TriggerOverridePromotionUIClass(eCHLPST_Standard), self), Get3DMovie()));
	// End Issue #600
	*/

	/// HL-Docs: ref:Bugfixes; issue:1356
	/// ShowPromotionUI no longer casts the resulting screen type to subclasses of UIArmory_Promotion

	// Start Issue #600: Replaced class literals with the local variables
	// Start Issue #1356
	if (UnitState.IsResistanceHero() || ScreenStack.IsInStack(class'UIFacility_TrainingCenter'))
	{
		PromotionUI = UIArmory_Promotion(ScreenStack.Push(
			Spawn(TriggerOverridePromotionUIClass(eCHLPST_Hero), self), Get3DMovie()));
	}
	else if (UnitState.GetSoldierClassTemplateName() == 'PsiOperative')
	{
		PromotionUI = UIArmory_Promotion(ScreenStack.Push(
			Spawn(TriggerOverridePromotionUIClass(eCHLPST_PsiOp), self), Get3DMovie()));
	}
	else
	{
		PromotionUI = UIArmory_Promotion(ScreenStack.Push(
			Spawn(TriggerOverridePromotionUIClass(eCHLPST_Standard), self), Get3DMovie()));
	}
	// End Issue #1356
	// End Issue #600
	
	PromotionUI.InitPromotion(UnitRef, bInstantTransition);
}