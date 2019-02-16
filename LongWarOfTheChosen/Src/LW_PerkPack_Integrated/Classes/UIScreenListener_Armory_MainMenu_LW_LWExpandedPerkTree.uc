//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_Armory_MainMenu_LW_LWExpandedPerkTree
//  AUTHOR:  Amineri
//
//  PURPOSE: Implements hooks to modify ability button in List in order to invoke Expanded Perk Tree
//		updated for overhaul
//--------------------------------------------------------------------------------------- 

class UIScreenListener_Armory_MainMenu_LW_LWExpandedPerkTree extends UIScreenListener;

`include(LW_PerkPack_Integrated\LW_PerkPack.uci)


var UIListItemString ExpandedListItem; // for integration into existing list
var UIArmory_MainMenu ParentScreen;

//var delegate<OnItemSelectedCallback> NextOnSelectionChanged;
//
var localized string strExpandedMenuOption;
var localized string strExpandedTooltip;
var localized string ExpandedListItemDescription;


delegate OnItemSelectedCallback(UIList _list, int itemIndex);

// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
	local UIListItemString		Button;
	local UIButton				BG;
	local XComGameState_Unit	Unit;
	
	`PPTrace("Initializing UIScreenListener_Armory_MainMenu_LW_LWExpandedPerkTree");
	ParentScreen = UIArmory_MainMenu(Screen); 

	//link ability button to new callback in order to call new UIScreen for expanded perk tree
    if(ParentScreen != none)
    {
		Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ParentScreen.UnitReference.ObjectID));
		`Log("Looking for earned abilities for " $ Unit.GetName(eNameType_Full));

		if(!class'UIArmory_MainMenu_LW'.default.bUse2WideAbilityTree &&
			 !class'XComGameState_LWPerkPackOptions'.static.IsBaseGamePerkUIEnabled() &&
			 // WOTC: Don't override the promotion screen for faction soldiers
			 !Unit.IsResistanceHero())
		{
			class'UIScreenListener_Armory_MainMenu_LWExpandedPerkTree'.static.DisableSoldierIntros();
			ParentScreen.PromotionButton.ButtonBG.OnClickedDelegate = OnExpandedButtonCallback;
		}
	}
}

//This event is triggered after a screen receives focus
event OnReceiveFocus(UIScreen Screen)
{
	local XComGameState_Unit	Unit;

	`PPTrace("Perk tree receiving focus");
	ParentScreen = UIArmory_MainMenu(Screen);
	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ParentScreen.UnitReference.ObjectID));

	// WOTC: Don't override the promotion screen for faction soldiers
	if(!class'UIArmory_MainMenu_LW'.default.bUse2WideAbilityTree && !Unit.IsResistanceHero())
	{
		ParentScreen.PromotionButton.ButtonBG.OnClickedDelegate = OnExpandedButtonCallback;
	}
	`PPTrace("    Done");
}

// This event is triggered when a screen is removed
event OnRemoved(UIScreen Screen)
{
	ParentScreen = none;
}

//callback handler for list button -- invokes the LW officer ability UI
simulated function OnExpandedButtonCallback(UIButton kButton)
{
	local XComHQPresentationLayer HQPres;
	local UIArmory_LWExpandedPromotion ExpandedScreen;
	local UIArmory_Promotion PromotionScreen;
	local XComGameState_Unit UnitState;
	local name SoldierClassName;
	local StateObjectReference UnitRef;
	`PPTrace("OnExpandedButtonCallback");

	if(ParentScreen.CheckForDisabledListItem(kButton)) return;

	HQPres = `HQPRES;
	UnitRef = ParentScreen.GetUnitRef();
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitRef.ObjectID));
	SoldierClassName = class'X2StrategyGameRulesetDataStructures'.static.PromoteSoldier(UnitRef);
	if (SoldierClassName == '')
	{
		SoldierClassName = UnitState.GetSoldierClassTemplate().DataName;
	}
	
	if(UnitState == none)
	{
		`REDSCREEN("LW PerkPack: Promotion UI callback without a valid Unit State.");
		return;
	}

	// The ShowPromotionUI will get triggered at the end of the class movie if it plays, or...
	//if (!class'X2StrategyGameRulesetDataStructures'.static.ShowClassMovie(SoldierClassName, UnitRef))
	//{
		// ...this wasn't the first time we saw this unit's new class so just show the UI
	if (UnitState.GetSoldierClassTemplateName() == 'PsiOperative')
	{
		PromotionScreen = UIArmory_PromotionPsiOp(HQPres.ScreenStack.Push(HQPres.Spawn(class'UIArmory_PromotionPsiOp', HQPres), HQPres.Get3DMovie()));
		PromotionScreen.InitPromotion(UnitRef, false);
	}
	else
	{
		ExpandedScreen = UIArmory_LWExpandedPromotion(HQPres.ScreenStack.Push(HQPres.Spawn(class'UIArmory_LWExpandedPromotion', HQPres), HQPres.Get3DMovie()));
		ExpandedScreen.InitPromotion(UnitRef, false);
	}
	PromotionScreen = ExpandedScreen;
	`XEVENTMGR.TriggerEvent('OnUnitPromotion', UnitState, PromotionScreen); // trigger for manual promotion events -- typically used for first-time promotion dialogue boxes, cinematics, etc
	
	`PPTrace("    Done");
}

defaultproperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = UIArmory_MainMenu;
}