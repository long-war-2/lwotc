//---------------------------------------------------------------------------------------
//  FILE:    UIArmory_LWExpandedPromotion
//  AUTHOR:  Amineri (Pavonis Interactive)
//
//  PURPOSE: Tweaked ability selection UI for LW expanded perk tree, modified version of UIArmory_Promotion
//
//--------------------------------------------------------------------------------------- 

class UIArmory_LWExpandedPromotion extends UIArmory_Promotion config (LW_PerkPack); //UIArmory config(LW_PerkPack);

`include(..\..\XComGame\Mods\LongWaroftheChosen\Src\LW_PerkPack_Integrated\LW_PerkPack.uci)

const NUM_ABILITIES_PER_RANK_EXPANDED = 3;

//var XComGameState PromotionState;

//var int PendingRank, PendingBranch;
//var bool bShownClassPopup;
//var bool bShownCorporalPopup, bShownAWCPopup; // necessary to prevent infinite popups if the soldier ability data isn't set up correctly.

//var bool bAfterActionPromotion;	//Set to TRUE if we need to make a pawn and move the camera to the armory
//var UIAfterAction AfterActionScreen; //If bAfterActionPromotion is true, this holds a reference to the after action screen
//var UIArmory_LWExpandedPromotionItem ClassRowItem;

//var localized string m_strSelectAbility;
//var localized string m_strAbilityHeader;

//var localized string m_strConfirmAbilityTitle;
//var localized string m_strConfirmAbilityText;

//var localized string m_strCorporalPromotionDialogTitle;
//var localized string m_strCorporalPromotionDialogText;

//var localized string m_strAWCUnlockDialogTitle;
//var localized string m_strAWCUnlockDialogText;

//var localized string m_strAbilityLockedTitle;
//var localized string m_strAbilityLockedDescription;

var UIList AbilityList;
var UIList SummaryList;

var UIScrollingText LeftTitleText;
var UIScrollingText RightTitleText;

var int SummaryTitleFontSize, SummaryBodyFontSize;
var int LastPreviewIndex;

var config bool bTabToPromote;

simulated function InitPromotion(StateObjectReference UnitRef, optional bool bInstantTransition)
{
	// If the AfterAction screen is running, let it position the camera
	AfterActionScreen = UIAfterAction(Movie.Stack.GetScreen(class'UIAfterAction'));
	if(AfterActionScreen == none) // try and get the overridden one from Toolbox
	{
		AfterActionScreen = UIAfterAction(GetScreen('UIAfterAction_LW'));
	}
	if(AfterActionScreen != none)
	{
		bAfterActionPromotion = true;
		PawnLocationTag = AfterActionScreen.GetPawnLocationTag(UnitRef);
		CameraTag = AfterActionScreen.GetPromotionBlueprintTag(UnitRef);
		DisplayTag = name(AfterActionScreen.GetPromotionBlueprintTag(UnitRef));
	}
	else
	{
		CameraTag = GetPromotionBlueprintTag(UnitRef);
		DisplayTag = name(GetPromotionBlueprintTag(UnitRef));
	}
	
	// Don't show nav help during tutorial, or during the After Action sequence.
	bUseNavHelp = class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('T0_M2_WelcomeToArmory') || Movie.Pres.ScreenStack.IsInStack(class'UIAfterAction');

	UnitReference = UnitRef;
	super(UIArmory).InitArmory(UnitRef,,,,,, bInstantTransition);

	LeftTitleText = Spawn(class'UIScrollingText', self);
	LeftTitleText.bAnimateOnInit = false;
	LeftTitleText.InitScrollingText(, "Title", 146,,,true);
	LeftTitleText.SetText(GetCenteredTitleText("LEFT ABILITY TITLE"));
	LeftTitleText.SetPosition(237, 244);

	RightTitleText = Spawn(class'UIScrollingText', self);
	RightTitleText.bAnimateOnInit = false;
	RightTitleText.InitScrollingText(, "Title", 146,,,true);
	RightTitleText.SetText(GetCenteredTitleText("RIGHT ABILITY TITLE"));
	RightTitleText.SetPosition(547, 244);

	AbilityList = Spawn(class'UIList', self).InitList('promoteList');
	AbilityList.OnSelectionChanged = PreviewRow;
	AbilityList.bStickyHighlight = false;
	AbilityList.bAutosizeItems = false;

	HideRowPreview();

	SummaryList = Spawn(class'UIList', self);
	SummaryList.bAnimateOnInit = false;
	SummaryList.BGPaddingLeft = 0;
	SummaryList.BGPaddingRight = 0;
	SummaryList.BGPaddingTop = 0;
	SummaryList.BGPaddingBottom = 0;
	SummaryList.itemPadding = 4;
	SummaryList.bAutoSizeItems = true;
	SummaryList.InitList(, 50.5, 804, 650, 168, true, false); // create horizontal list without background
	SummaryList.bStickyHighlight = false;
	SummaryList.Show();

	PopulateData();
	AbilityList.Navigator.LoopSelection = false;

	Navigator.Clear();
	Navigator.LoopSelection = false;
	if (ClassRowItem != None) 
	{
		Navigator.AddControl(ClassRowItem);
	}

	Navigator.AddControl(AbilityList);
	if (AbilityList.SelectedIndex < 0)
	{
		Navigator.SetSelected(ClassRowItem);
	}
	else
	{
		Navigator.SetSelected(AbilityList);
	}

	MC.FunctionVoid("animateIn");
}

simulated function string GetCenteredTitleText(string text)
{
	local string OutString;

	OutString = text;
	OutString = class'UIUtilities_Text'.static.AddFontInfo(OutString, true,,, SummaryTitleFontSize);
	OutString = class'UIUtilities_Text'.static.AlignCenter(OutString);

	return OutString;
}

simulated function UIScreen GetScreen(name TestScreenClass )
{
	local UIScreenStack ScreenStack;
	local int Index;

	ScreenStack = `SCREENSTACK;
	for(Index = 0; Index < ScreenStack.Screens.Length;  ++Index)
	{
		if(ScreenStack.Screens[Index].IsA(TestScreenClass))
			return ScreenStack.Screens[Index];
	}
	return none; 
}

//LWS - Updated to accept child class of UIAfterAction
simulated function UpdateNavHelp()
{
	//<workshop> SCI 2016/4/12
	//INS:
	local int i;
	local string PrevKey, NextKey;
	local XGParamTag LocTag;
	if(!bIsFocused)
	{
		return;
	}

	NavHelp = `HQPRES.m_kAvengerHUD.NavHelp;

	NavHelp.ClearButtonHelp();
	//</workshop>

	if(UIAfterAction(GetScreen('UIAfterAction')) != none)
	{
		//<workshop> SCI 2016/3/1
		//WAS:
		//`HQPRES.m_kAvengerHUD.NavHelp.ClearButtonHelp();
		//`HQPRES.m_kAvengerHUD.NavHelp.AddContinueButton(OnCancel);
		NavHelp.AddBackButton(OnCancel);
		if (!UIArmory_PromotionItem(AbilityList.GetSelectedItem()).bIsDisabled)
		{
			//NavHelp.AddLeftHelp(m_strInfo, class'UIUtilities_Input'.static.GetGamepadIconPrefix() $class'UIUtilities_Input'.const.ICON_LSCLICK_L3);
		}

		if (!XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitReference.ObjectID)).ShowPromoteIcon())
		{
			NavHelp.AddContinueButton(OnCancel);
		}
		else if (UIArmory_PromotionItem(AbilityList.GetSelectedItem()).bEligibleForPromotion)
		{
			//NavHelp.AddLeftHelp(m_strSelect, class'UIUtilities_Input'.static.GetAdvanceButtonIcon());
		}

		if( `ISCONTROLLERACTIVE )
		{
			if (IsAllowedToCycleSoldiers() && class'UIUtilities_Strategy'.static.HasSoldiersToCycleThrough(UnitReference, CanCycleTo))
			{
				NavHelp.AddLeftHelp(class'UIUtilities_Input'.static.InsertGamepadIcons("%LB %RB" @ m_strTabNavHelp));
			}

			NavHelp.AddLeftHelp(class'UIUtilities_Input'.static.InsertGamepadIcons("%RS" @ m_strRotateNavHelp));
		}
	}
	else
	{
		//<workshop> SCI 2016/4/12
		//WAS:
		//super.UpdateNavHelp();
		NavHelp.AddBackButton(OnCancel);
		
		if (XComHQPresentationLayer(Movie.Pres) != none)
		{
			LocTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
			LocTag.StrValue0 = Movie.Pres.m_kKeybindingData.GetKeyStringForAction(PC.PlayerInput, eTBC_PrevUnit);
			PrevKey = `XEXPAND.ExpandString(PrevSoldierKey);
			LocTag.StrValue0 = Movie.Pres.m_kKeybindingData.GetKeyStringForAction(PC.PlayerInput, eTBC_NextUnit);
			NextKey = `XEXPAND.ExpandString(NextSoldierKey);

			if (class'XComGameState_HeadquartersXCom'.static.GetObjectiveStatus('T0_M7_WelcomeToGeoscape') != eObjectiveState_InProgress &&
				RemoveMenuEvent == '' && NavigationBackEvent == '' && `SCREENSTACK.GetFirstInstanceOf(class'UISquadSelect') == none)
			{
				NavHelp.AddGeoscapeButton();
			}

			if (Movie.IsMouseActive() && IsAllowedToCycleSoldiers() && class'UIUtilities_Strategy'.static.HasSoldiersToCycleThrough(UnitReference, CanCycleTo))
			{
				NavHelp.SetButtonType("XComButtonIconPC");
				i = eButtonIconPC_Prev_Soldier;
				NavHelp.AddCenterHelp( string(i), "", PrevSoldier, false, PrevKey);
				i = eButtonIconPC_Next_Soldier; 
				NavHelp.AddCenterHelp( string(i), "", NextSoldier, false, NextKey);
				NavHelp.SetButtonType("");
			}
		}

	    if (UIArmory_PromotionItem(AbilityList.GetSelectedItem()).bEligibleForPromotion)
		{
			NavHelp.AddSelectNavHelp();
		}

		if (!UIArmory_PromotionItem(AbilityList.GetSelectedItem()).bIsDisabled)
		{
			//NavHelp.AddLeftHelp(m_strInfo, class'UIUtilities_Input'.static.GetGamepadIconPrefix() $class'UIUtilities_Input'.const.ICON_LSCLICK_L3);
		}

		if( `ISCONTROLLERACTIVE )
		{
			if (IsAllowedToCycleSoldiers() && class'UIUtilities_Strategy'.static.HasSoldiersToCycleThrough(UnitReference, CanCycleTo))
			{
				NavHelp.AddLeftHelp(class'UIUtilities_Input'.static.InsertGamepadIcons("%LB %RB" @ m_strTabNavHelp));
			}

			NavHelp.AddLeftHelp(class'UIUtilities_Input'.static.InsertGamepadIcons("%RS" @ m_strRotateNavHelp));
		}

		NavHelp.Show();
		//</workshop>
	}
}

simulated function OnLoseFocus()
{
	super(UIArmory).OnLoseFocus();
	//<workshop> FIX_FOR_PROMOTION_LOST_FOCUS_ISSUE kmartinez 2015-10-28
	// only set our variable if we're not trying to set a default value.
	if( AbilityList.SelectedIndex != -1)
		previousSelectedIndexOnFocusLost = AbilityList.SelectedIndex;
	//AbilityList.SetSelectedIndex(-1);
	`HQPRES.m_kAvengerHUD.NavHelp.ClearButtonHelp();
}

// Don't allow soldier switching when promoting soldiers on top of avenger or in squad select
simulated function bool IsAllowedToCycleSoldiers()
{
	local bool bInBadScreen;

	bInBadScreen =	IsInScreenStack('UIAfterAction') ||
					IsInScreenStack('UIAfterAction_LW') ||
					IsInScreenStack('UISquadSelect') ||
					IsInScreenStack('UISquadSelect_LW');
	return !bInBadScreen;
}

simulated function bool IsInScreenStack(name ScreenName)
{
	local UIScreenStack ScreenStack;
	local int Index;

	ScreenStack = Movie.Pres.ScreenStack;
	for( Index = 0; Index < ScreenStack.Screens.Length;  ++Index)
	{
		if( ScreenStack.Screens[Index].IsA(ScreenName) )
			return true;
	}
	return false;
}

simulated function bool DoesNotHaveSquaddieAbilities( XComGameState_Unit Unit, X2SoldierClassTemplate ClassTemplate)
{
	local int i;
	//local XComGameState_Unit Unit;
	local array<SoldierClassAbilitySlot> AbilitySlots;

	//Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitReference.ObjectID));

	// Add new abilities to the Unit
	AbilitySlots = ClassTemplate.GetAbilitySlots(0);
	for(i = 0; i < AbilitySlots.Length; i++)
	{
		if(!HasBoughtSpecificAbility(Unit, 0, i))
			return true;
	}
	return false;
}

simulated function string PromoCaps(string s)
{
	return s;
}

simulated function PopulateData()
{
	local int i, maxRank, previewIndex;
	local string AbilityIcon1, AbilityIcon2, AbilityIcon3, AbilityName1, AbilityName2, AbilityName3, HeaderString;
	//local string LeftColumnTitle, RightColumnTitle;
	local bool bFirstUnnassignedRank, bHasAbility1, bHasAbility2, bHasAbility3, bHasRankAbility, bLockedRow;
	local XComGameState_Unit Unit;
	local X2SoldierClassTemplate ClassTemplate;
	local X2AbilityTemplate AbilityTemplate1, AbilityTemplate2, AbilityTemplate3;
	local X2AbilityTemplateManager AbilityTemplateManager;
	local array<SoldierClassAbilitySlot> AbilitySlots;
	local UIArmory_LWExpandedPromotionItem Item;
	local array<name> AWCAbilityNames;
	local Vector ZeroVec;
	local Rotator UseRot;
	local XComUnitPawn UnitPawn, GremlinPawn;
	local UIArmory_LWExpandedPromotionItem LocalClassRowItem;

	// We don't need to clear the AbilityList, or recreate the pawn here -sbatista
	//super(UIArmory).PopulateData();
	Unit = GetUnit();
	ClassTemplate = Unit.GetSoldierClassTemplate();

	HeaderString = m_strAbilityHeader;

	if(Unit.GetRank() != 1 && Unit.HasAvailablePerksToAssign())
	{
		HeaderString = m_strSelectAbility;
	}

	//LeftColumnTitle = class'UIUtilities_Text'.static.GetColoredText(ClassTemplate.LeftAbilityTreeTitle, eUIState_Normal, 18);
	//RightColumnTitle = class'UIUtilities_Text'.static.GetColoredText(ClassTemplate.RightAbilityTreeTitle, eUIState_Normal, 18);
	//AS_SetTitle(ClassTemplate.IconImage, HeaderString, LeftColumnTitle, RightColumnTitle, PromoCaps(ClassTemplate.DisplayName));

	AS_SetTitle(ClassTemplate.IconImage, HeaderString, "", "", Caps(ClassTemplate.DisplayName));
	LeftTitleText.SetText(GetCenteredTitleText(PromoCaps(ClassTemplate.LeftAbilityTreeTitle)));
	RightTitleText.SetText(GetCenteredTitleText(PromoCaps(ClassTemplate.RightAbilityTreeTitle)));

	if(ActorPawn == none || (Unit.GetRank() == 1 && bAfterActionPromotion)) //This condition is TRUE when in the after action report, and we need to rank someone up to squaddie
	{
		//Get the current pawn so we can extract its rotation
		UnitPawn = Movie.Pres.GetUIPawnMgr().RequestPawnByID(AfterActionScreen, UnitReference.ObjectID, ZeroVec, UseRot);
		UseRot = UnitPawn.Rotation;

		//if (ClassTemplate.DataName != 'Spark')
		//{
			//Free the existing pawn, and then create the ranked up pawn. This may not be strictly necessary since most of the differences between the classes are in their equipment. However, it is easy to foresee
			//having class specific soldier content and this covers that possibility
			Movie.Pres.GetUIPawnMgr().ReleasePawn(AfterActionScreen, UnitReference.ObjectID);
			CreateSoldierPawn(UseRot);
		//}

		if(bAfterActionPromotion && !Unit.bCaptured)
		{
			//Let the pawn manager know that the after action report is referencing this pawn too			
			UnitPawn = Movie.Pres.GetUIPawnMgr().RequestPawnByID(AfterActionScreen, UnitReference.ObjectID, ZeroVec, UseRot);
			AfterActionScreen.SetPawn(UnitReference, UnitPawn);
			GremlinPawn = Movie.Pres.GetUIPawnMgr().GetCosmeticPawn(eInvSlot_SecondaryWeapon, UnitReference.ObjectID);
			if (GremlinPawn != none)
				GremlinPawn.SetLocation(UnitPawn.Location);
		}
	}

	// Check to see if Unit needs to show a new class popup.
	if(Unit.bNeedsNewClassPopup)
	{
		AwardRankAbilities(ClassTemplate, 0);

		`HQPRES.UIClassEarned(Unit.GetReference());

		Unit = GetUnit(); // we've updated the UnitState, update the Unit to reflect the latest changes
	}
	
	// Check for AWC Ability popup
	if(Unit.NeedsAWCAbilityPopup())
	{
		AWCAbilityNames = Unit.GetAWCAbilityNames();
		
		if(AWCAbilityNames.Length > 0)
		{
			ShowAWCDialog(AWCAbilityNames);
		}

		Unit = GetUnit(); // we've updated the UnitState, update the Unit to reflect the latest changes
	}

	previewIndex = -1;
	maxRank = ClassTemplate.GetMaxConfiguredRank();
	if (maxRank > 0) 
	{
		maxRank = Min (maxRank+1, class'X2ExperienceConfig'.static.GetMaxRank());
	}
	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	if(ClassRowItem == none)
	{
		ClassRowItem = Spawn(class'UIArmory_LWExpandedPromotionItem', self);
		ClassRowItem.MCName = 'classRow';
		ClassRowItem.InitPromotionItem(0);
		ClassRowItem.OnMouseEventDelegate = OnClassRowMouseEvent;

		if(Unit.GetRank() == 1)
			ClassRowItem.OnReceiveFocus();
	}
	LocalClassRowItem = UIArmory_LWExpandedPromotionItem(ClassRowItem);

	LocalClassRowItem.ClassName = ClassTemplate.DataName;
	LocalClassRowItem.SetRankData(class'UIUtilities_Image'.static.GetRankIcon(1, ClassTemplate.DataName), PromoCaps(class'X2ExperienceConfig'.static.GetRankName(1, ClassTemplate.DataName)));

	AbilitySlots = ClassTemplate.GetAbilitySlots(LocalClassRowItem.Rank);
	AbilityTemplate2 = AbilityTemplateManager.FindAbilityTemplate(AbilitySlots[2].AbilityType.AbilityName);
	if(AbilityTemplate2 == none)
		AbilityTemplate2 = AbilityTemplateManager.FindAbilityTemplate(AbilitySlots[1].AbilityType.AbilityName);

	if(AbilityTemplate2 != none)
	{
		LocalClassRowItem.AbilityName3 = AbilityTemplate2.DataName;
		AbilityName3 = PromoCaps(AbilityTemplate2.LocFriendlyName);
		AbilityIcon3 = AbilityTemplate2.IconImage;
	}
	else
	{
		AbilityTemplate1 = AbilityTemplateManager.FindAbilityTemplate(AbilitySlots[0].AbilityType.AbilityName);
		LocalClassRowItem.AbilityName3 = AbilityTemplate1.DataName;
		AbilityName3 = PromoCaps(AbilityTemplate1.LocFriendlyName);
		AbilityIcon3 = AbilityTemplate1.IconImage;
	}

	LocalClassRowItem.SetEquippedAbilities3(true, true, true);
	LocalClassRowItem.SetAbilityData3("", "", "", "", AbilityIcon3, AbilityName3);
	LocalClassRowItem.SetClassData(ClassTemplate.IconImage, Caps(ClassTemplate.DisplayName));

	for(i = 2; i < maxRank; ++i)
	{
		Item = UIArmory_LWExpandedPromotionItem(AbilityList.GetItem(i - 2));
		if(Item == none)
		{
			Item = UIArmory_LWExpandedPromotionItem(AbilityList.CreateItem(class'UIArmory_LWExpandedPromotionItem'));
			Item.InitPromotionItem(i - 1);
		}
		Item.Rank = i - 1;
		Item.ClassName = ClassTemplate.DataName;
		Item.SetRankData(class'UIUtilities_Image'.static.GetRankIcon(i, ClassTemplate.DataName), PromoCaps(class'X2ExperienceConfig'.static.GetRankName(i, ClassTemplate.DataName)));

		AbilitySlots = ClassTemplate.GetAbilitySlots(Item.Rank);

		if(AbilitySlots.Length == 0)
		{
			Item.Hide();
		}
		bLockedRow = i > Unit.GetRank() && !class'XComGameState_LWPerkPackOptions'.static.IsViewLockedStatsEnabled();

		AbilityTemplate1 = (AbilitySlots.Length > 0 ? AbilityTemplateManager.FindAbilityTemplate(AbilitySlots[0].AbilityType.AbilityName) : none);
		if(AbilityTemplate1 != none)
		{
			Item.AbilityName1 = AbilityTemplate1.DataName;
			AbilityName1 = bLockedRow ? class'UIUtilities_Text'.static.GetColoredText(m_strAbilityLockedTitle, eUIState_Disabled) : PromoCaps(AbilityTemplate1.LocFriendlyName);
			AbilityIcon1 = bLockedRow ? class'UIUtilities_Image'.const.UnknownAbilityIcon : AbilityTemplate1.IconImage;
		} else {
			AbilityName1 = "";
			AbilityIcon1 = "";
		}

		AbilityTemplate2 = (AbilitySlots.Length > 1 ? AbilityTemplateManager.FindAbilityTemplate(AbilitySlots[1].AbilityType.AbilityName) : none);
		if(AbilityTemplate2 != none)
		{
			Item.AbilityName2 = AbilityTemplate2.DataName;
			AbilityName2 = bLockedRow ? class'UIUtilities_Text'.static.GetColoredText(m_strAbilityLockedTitle, eUIState_Disabled) : PromoCaps(AbilityTemplate2.LocFriendlyName);
			AbilityIcon2 = bLockedRow ? class'UIUtilities_Image'.const.UnknownAbilityIcon : AbilityTemplate2.IconImage;
		} else {
			AbilityName2 = "";
			AbilityIcon2 = "";
		}

		AbilityTemplate3 = (AbilitySlots.Length > 2 ? AbilityTemplateManager.FindAbilityTemplate(AbilitySlots[2].AbilityType.AbilityName) : none);
		if(AbilityTemplate3 != none)
		{
			Item.AbilityName3 = AbilityTemplate3.DataName;
			AbilityName3 = bLockedRow ? class'UIUtilities_Text'.static.GetColoredText(m_strAbilityLockedTitle, eUIState_Disabled) : PromoCaps(AbilityTemplate3.LocFriendlyName);
			AbilityIcon3 = bLockedRow ? class'UIUtilities_Image'.const.UnknownAbilityIcon : AbilityTemplate3.IconImage;
		} else {
			AbilityName3 = "";
			AbilityIcon3 = "";
		}

		//bHasAbility1 = Unit.HasSoldierAbility(Item.AbilityName1);
		//bHasAbility2 = Unit.HasSoldierAbility(Item.AbilityName2);
		//bHasAbility3 = Unit.HasSoldierAbility(Item.AbilityName3);
		bHasAbility1 = HasBoughtSpecificAbility(Unit, Item.Rank, 0);
		bHasAbility2 = HasBoughtSpecificAbility(Unit, Item.Rank, 1);
		bHasAbility3 = HasBoughtSpecificAbility(Unit, Item.Rank, 2);
		bHasRankAbility = HasBoughtSpecificAbility(Unit, Item.Rank, 0) || HasBoughtSpecificAbility(Unit, Item.Rank, 1) || HasBoughtSpecificAbility(Unit, Item.Rank, 2);

		Item.SetEquippedAbilities3(bHasAbility1, bHasAbility2, bHasAbility3);
		Item.SetAbilityData3(AbilityIcon1, AbilityName1, AbilityIcon2, AbilityName2, AbilityIcon3, AbilityName3);

		if(i == 1 || bHasRankAbility) // || (i == Unit.GetRank() && !Unit.HasAvailablePerksToAssign()))  // removed so can still train with AWC ability
		{
			Item.SetDisabled(false);
			Item.SetPromote3(false);
		}
		else if(i > Unit.GetRank())
		{
			Item.SetDisabled(!class'XComGameState_LWPerkPackOptions'.static.IsViewLockedStatsEnabled());
			Item.SetPromote3(false);
		}
		else // has available perks to assign
		{
			if(!bFirstUnnassignedRank)
			{
				previewIndex = i - 2;
				bFirstUnnassignedRank = true;
				Item.SetDisabled(false);
				Item.SetPromote3(true);
				AbilityList.SetSelectedIndex(AbilityList.GetItemIndex(Item), true);
			}
			else
			{
				Item.SetDisabled(true);
				Item.SetPromote3(false);
			}
		}

		Item.RealizeVisuals();
	}

	PopulateAbilitySummary(Unit);
	PreviewRow(AbilityList, previewIndex);
	if (previewIndex < 0)
	{
		Navigator.SetSelected(ClassRowItem);
		ClassRowItem.OnReceiveFocus();
	}
	else
	{
		Navigator.SetSelected(AbilityList);
		AbilityList.SetSelectedIndex(previewIndex);
	}
}

// populate with only the basic class abilities, not every earned ability
// specifically PCS, officer and AWC abilities aren't displayed here
simulated function PopulateAbilitySummary(XComGameState_Unit Unit)
{
	local int i, Index;
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityTemplateManager AbilityTemplateManager;
	local array<SoldierClassAbilityType> AbilityTree;
	local array<AbilitySetupData> AbilitySetupList;

	Movie.Pres.m_kTooltipMgr.RemoveTooltipsByPartialPath(string(MCPath) $ ".abilitySummaryList");

	MC.FunctionString("setSummaryTitle", class'UIUtilities_Strategy'.default.m_strAbilityListTitle);

	// Populate ability list (multiple param function call: image then title then description)
	MC.BeginFunctionOp("setAbilitySummaryList");

	Index = 0;

	if(Unit.IsSoldier())
	{
		AbilityTree = GetSoldierClassAbilities(Unit);
		AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

		for(i = 0; i < AbilityTree.Length; ++i)
		{
			AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(AbilityTree[i].AbilityName);
			if( !AbilityTemplate.bDontDisplayInAbilitySummary )
			{
				class'UIUtilities_Strategy'.static.AddAbilityToSummary(Screen, AbilityTemplate, Index++, Unit, CheckGameState);
			}
		}
	}
	else
	{
		AbilitySetupList = Unit.GatherUnitAbilitiesForInit(CheckGameState,,true);

		for(i = 0; i < AbilitySetupList.Length; ++i)
		{
			AbilityTemplate = AbilitySetupList[i].Template;
			if( !AbilityTemplate.bDontDisplayInAbilitySummary )
			{
				class'UIUtilities_Strategy'.static.AddAbilityToSummary(Screen, AbilityTemplate, Index++, Unit, CheckGameState);
			}
		}
	}

	MC.EndOp();
}

function array<SoldierClassAbilityType> GetSoldierClassAbilities(XComGameState_Unit Unit)
{
	local X2SoldierClassTemplate ClassTemplate;
	local array<SoldierClassAbilityType> EarnedAbilities;
	local array<SoldierClassAbilitySlot> AbilitySlots;
	local SoldierClassAbilityType Ability;
	local int i;

	ClassTemplate = Unit.GetSoldierClassTemplate();
	if (ClassTemplate != none)
	{
		for (i = 0; i < Unit.m_SoldierProgressionAbilties.Length; ++i)
		{
			if (ClassTemplate.GetMaxConfiguredRank() <= Unit.m_SoldierProgressionAbilties[i].iRank)
				continue;
			AbilitySlots = ClassTemplate.GetAbilitySlots(Unit.m_SoldierProgressionAbilties[i].iRank);
			if (AbilitySlots.Length <= Unit.m_SoldierProgressionAbilties[i].iBranch)
				continue;
			Ability = AbilitySlots[Unit.m_SoldierProgressionAbilties[i].iBranch].AbilityType;
			EarnedAbilities.AddItem(Ability);
		}
	}
	return EarnedAbilities;
}

simulated function bool HasBoughtSpecificAbility(XComGameState_Unit UnitState, int iAbilityRank, int iAbilityBranch)
{
	local SCATProgression ProgressAbility;
	
	foreach UnitState.m_SoldierProgressionAbilties(ProgressAbility)
	{
		if (ProgressAbility.iBranch == iAbilityBranch && ProgressAbility.iRank == iAbilityRank)
		{
			return true;
		}
	}
	return false;
}

simulated function OnClassRowMouseEvent(UIPanel Panel, int Cmd)
{
	if(Cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_IN || Cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OVER)
		PreviewRow(AbilityList,-2);
}

simulated function RequestPawn(optional Rotator DesiredRotation)
{
	local XComGameState_Unit UnitState;
	local name IdleAnimName;

	super(UIArmory).RequestPawn(DesiredRotation);

	UnitState = GetUnit();
	if(!UnitState.IsInjured())
	{
		IdleAnimName = UnitState.GetMyTemplate().CustomizationManagerClass.default.StandingStillAnimName;

		// Play the "By The Book" idle to minimize character overlap with UI elements
		XComHumanPawn(ActorPawn).PlayHQIdleAnim(IdleAnimName);

		// Cache desired animation in case the pawn hasn't loaded the customization animation set
		XComHumanPawn(ActorPawn).CustomizationIdleAnim = IdleAnimName;
	}
}

// DEPRECATED bsteiner 3/24/2016
simulated function AwardRankAbilities(X2SoldierClassTemplate ClassTemplate, int Rank);
simulated function array<name> AwardAWCAbilities();
simulated function ShowCorporalDialog(X2SoldierClassTemplate ClassTemplate);
// END DEPRECATED ITEMS bsteiner 3/24/2016

simulated function ShowAWCDialog(array<name> AWCAbilityNames)
{
	local int i;
	local string tmpStr;
	local XGParamTag        kTag;
	local TDialogueBoxData  kDialogData;
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityTemplateManager AbilityTemplateManager;
	local XComGameState NewGameState;
	local XComGameState_Unit UnitState;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Display AWC Ability Popup");
	UnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', UnitReference.ObjectID));
	NewGameState.AddStateObject(UnitState);
	UnitState.bSeenAWCAbilityPopup = true;
	`GAMERULES.SubmitGameState(NewGameState);

	kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));

	kDialogData.strTitle = m_strAWCUnlockDialogTitle;

	kTag.StrValue0 = "";
	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	for(i = 0; i < AWCAbilityNames.Length; ++i)
	{
		AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(AWCAbilityNames[i]);

		// Ability Name
		tmpStr = AbilityTemplate.LocFriendlyName != "" ? AbilityTemplate.LocFriendlyName : ("Missing 'LocFriendlyName' for ability '" $ AbilityTemplate.DataName $ "'");
		kTag.StrValue0 $= "- " $ PromoCaps(tmpStr) $ ":\n";

		// Ability Description
		tmpStr = AbilityTemplate.HasLongDescription() ? AbilityTemplate.GetMyLongDescription(, GetUnit()) : ("Missing 'LocLongDescription' for ability " $ AbilityTemplate.DataName $ "'");
		kTag.StrValue0 $= tmpStr $ "\n\n";
	}

	kDialogData.strText = `XEXPAND.ExpandString(m_strAWCUnlockDialogText);
	kDialogData.strAccept = class'UIUtilities_Text'.default.m_strGenericOK;

	Movie.Pres.UIRaiseDialog(kDialogData);
}

simulated function PreviewRow(UIList ContainerList, int ItemIndex)
{
	local int i, Rank; 
	local string TmpIconPath, TmpClassPath, TmpTitleText, TmpSummaryText;
	local X2AbilityTemplate AbilityTemplate;
	local array<SoldierClassAbilitySlot> AbilitySlots;
	local X2AbilityTemplateManager AbilityTemplateManager;
	local X2SoldierClassTemplate ClassTemplate;
	local XComGameState_Unit Unit;
	local UIArmory_LWExpandedPromotionSummaryItem Item;

	Unit = GetUnit();

	//`PPTRACE("PreviewRow : ItemIndex = " $ ItemIndex);

	if(ItemIndex == INDEX_NONE)
	{
		return;
	}
	else if(ItemIndex == -2)
	{
		Rank = 0;
	}
	else
	{
		Rank = UIArmory_LWExpandedPromotionItem(AbilityList.GetItem(ItemIndex)).Rank;
	}

	if(Rank == LastPreviewIndex)
	{
		return;
	}

	LastPreviewIndex = Rank;
	SummaryList.ClearItems();

	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	ClassTemplate = Unit.GetSoldierClassTemplate();
	AbilitySlots = ClassTemplate.GetAbilitySlots(Rank);
	for(i = 0; i < NUM_ABILITIES_PER_RANK_EXPANDED; i++)
	{
		if(Rank >= Unit.GetRank() && !class'XComGameState_LWPerkPackOptions'.static.IsViewLockedStatsEnabled())
		{
			TmpIconPath = class'UIUtilities_Image'.const.LockedAbilityIcon;
			TmpClassPath = "";
			TmpTitleText = class'UIUtilities_Text'.static.GetColoredText(Caps(m_strAbilityLockedTitle), eUIState_Disabled, SummaryTitleFontSize);
			TmpSummaryText = class'UIUtilities_Text'.static.GetColoredText(m_strAbilityLockedDescription, eUIState_Disabled, SummaryBodyFontSize);
			Item = GetNextSummaryItem(i);
			if(i>= AbilitySlots.Length || AbilitySlots[i].AbilityType.AbilityName == '')
			{
				Item.Hide();
				continue;
			}
		} else {
			if((Rank == 0) && (i == 0))
			{
				TmpIconPath = "";
				TmpClassPath = ClassTemplate.IconImage;
				TmpTitleText = Caps(ClassTemplate.DisplayName);
				TmpSummaryText = ClassTemplate.ClassSummary;
				Item = GetNextSummaryItem(i);
			} else {

				if ((Rank == 0) && (i > 0))
				{
					if(i-1 < AbilitySlots.Length)
						AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(AbilitySlots[i-1].AbilityType.AbilityName);
					else
						AbilityTemplate = none;
					if ((i-1 >= AbilitySlots.Length) || (AbilitySlots[i-1].AbilityType.AbilityName == ''))
					{
						Item = GetNextSummaryItem(i);
						Item.Hide();
						continue;
					}
				} else {
					if(i < AbilitySlots.Length)
						AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(AbilitySlots[i].AbilityType.AbilityName);
					else
						AbilityTemplate = none;
					if ((i >= AbilitySlots.Length) || (AbilitySlots[i].AbilityType.AbilityName == ''))
					{
						Item = GetNextSummaryItem(i);
						Item.Hide();
						continue;
					}
				}

				Item = GetNextSummaryItem(i);

				if(AbilityTemplate != none)
				{
					TmpIconPath = AbilityTemplate.IconImage;
					TmpClassPath = "";
					TmpTitleText = AbilityTemplate.LocFriendlyName != "" ? AbilityTemplate.LocFriendlyName : ("Missing 'LocFriendlyName' for " $ AbilityTemplate.DataName);
					TmpSummaryText = AbilityTemplate.HasLongDescription() ? AbilityTemplate.GetMyLongDescription(, Unit) : ("Missing 'LocLongDescription' for " $ AbilityTemplate.DataName);
				}
				else
				{
					Item.Hide();
					TmpIconPath = "";
					TmpClassPath = "";
					TmpTitleText = string(AbilitySlots[i].AbilityType.AbilityName); 
					TmpSummaryText = ""; //"Missing template for ability '" $ AbilitySlots[i].AbilityType.AbilityName $ "'"; 
				}
			}
			TmpTitleText = class'UIUtilities_Text'.static.GetColoredText(Caps(TmpTitleText), eUIState_Normal, SummaryTitleFontSize);
			TmpSummaryText = class'UIUtilities_Text'.static.GetColoredText(TmpSummaryText, eUIState_Normal, SummaryBodyFontSize);
		}
		Item.SetSummaryData(TmpIconPath, TmpClassPath, TmpTitleText, TmpSummaryText);
	}
	if (Rank == 0)
	{
		ClassRowItem.SetSelectedAbility(1);
	}
	else
	{
		UIArmory_PromotionItem(AbilityList.GetItem(ItemIndex)).SetSelectedAbility(SelectedAbilityIndex);
	}
}

simulated function UIArmory_LWExpandedPromotionSummaryItem GetNextSummaryItem(int count)
{
	local UIArmory_LWExpandedPromotionSummaryItem Item;
	Item = UIArmory_LWExpandedPromotionSummaryItem(SummaryList.GetItem(count));
	if (Item == none)
		Item = UIArmory_LWExpandedPromotionSummaryItem(SummaryList.CreateItem(class'UIArmory_LWExpandedPromotionSummaryItem')).InitSummaryItem();

	return Item;

}

simulated function HideRowPreview()
{
	MC.FunctionVoid("hideAbilityPreview");
}

simulated function ClearRowPreview()
{
	MC.FunctionVoid("clearAbilityPreview");
}

simulated function ConfirmAbilitySelection(int Rank, int Branch)
{
	local XGParamTag LocTag;
	local TDialogueBoxData DialogData;
	local X2SoldierClassTemplate ClassTemplate;
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityTemplateManager AbilityTemplateManager;
	local array<SoldierClassAbilitySlot> AbilitySlots;

	PendingRank = Rank;
	PendingBranch = Branch;

	Movie.Pres.PlayUISound(eSUISound_MenuSelect);

	DialogData.eType = eDialog_Alert;
	DialogData.bMuteAcceptSound = true;
	DialogData.strTitle = m_strConfirmAbilityTitle;
	DialogData.strAccept = class'UIUtilities_Text'.default.m_strGenericYes;
	DialogData.strCancel = class'UIUtilities_Text'.default.m_strGenericNO;
	DialogData.fnCallback = ComfirmAbilityCallback;
	
	ClassTemplate = GetUnit().GetSoldierClassTemplate();
	AbilitySlots = ClassTemplate.GetAbilitySlots(Rank);
	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(AbilitySlots[Branch].AbilityType.AbilityName);

	LocTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	LocTag.StrValue0 = AbilityTemplate.LocFriendlyName;
	DialogData.strText = `XEXPAND.ExpandString(m_strConfirmAbilityText);
	Movie.Pres.UIRaiseDialog(DialogData);
	UpdateNavHelp();
}

simulated function ComfirmAbilityCallback(Name Action)
{
	local XComGameStateHistory History;
	local bool bSuccess;
	local XComGameState UpdateState;
	local XComGameState_Unit UpdatedUnit;
	local XComGameStateContext_ChangeContainer ChangeContainer;

	if(Action == 'eUIAction_Accept')
	{
		History = `XCOMHISTORY;
		ChangeContainer = class'XComGameStateContext_ChangeContainer'.static.CreateEmptyChangeContainer("Soldier Promotion");
		UpdateState = History.CreateNewGameState(true, ChangeContainer);

		UpdatedUnit = XComGameState_Unit(UpdateState.CreateStateObject(class'XComGameState_Unit', GetUnit().ObjectID));
		bSuccess = UpdatedUnit.BuySoldierProgressionAbility(UpdateState, PendingRank, PendingBranch);

		if(bSuccess)
		{
			UpdateState.AddStateObject(UpdatedUnit);
			`GAMERULES.SubmitGameState(UpdateState);

			Header.PopulateData();
			PopulateData();
		}
		else
			History.CleanupPendingGameState(UpdateState);

		Movie.Pres.PlayUISound(eSUISound_SoldierPromotion);
	}
	else 	// if we got here it means we were going to upgrade an ability, but then we decided to cancel
	{
		Movie.Pres.PlayUISound(eSUISound_MenuClickNegative);
		AbilityList.SetSelectedIndex(previousSelectedIndexOnFocusLost, true);
		UIArmory_PromotionItem(AbilityList.GetSelectedItem()).SetSelectedAbility(SelectedAbilityIndex);
	}
}

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	local XComGameStateHistory History;
	local bool bHandled;
	local name SoldierClassName;
	local XComGameState_Unit UpdatedUnit;
	local XComGameState UpdateState;
	local XComGameStateContext_ChangeContainer ChangeContainer;

	// Only pay attention to presses or repeats; ignoring other input types
	if ( !CheckInputIsReleaseOrDirectionRepeat(cmd, arg) )
		return false;
	if (AbilityList.GetSelectedItem().OnUnrealCommand(cmd, arg))
	{
		UpdateNavHelp();
		return true;
	}

	bHandled = true;

	switch( cmd )
	{
		// DEBUG: Press Tab to rank up the soldier
		case class'UIUtilities_Input'.const.FXS_KEY_TAB:
			if(bTabToPromote)
			{
				History = `XCOMHISTORY;
				ChangeContainer = class'XComGameStateContext_ChangeContainer'.static.CreateEmptyChangeContainer("DEBUG Unit Rank Up");
				UpdateState = History.CreateNewGameState(true, ChangeContainer);
				UpdatedUnit = XComGameState_Unit(UpdateState.CreateStateObject(class'XComGameState_Unit', GetUnit().ObjectID));

				if (UpdatedUnit.GetRank() == 0)
					SoldierClassName = class'UIUtilities_Strategy'.static.GetXComHQ().SelectNextSoldierClass();

				UpdatedUnit.RankUpSoldier(UpdateState, SoldierClassName);

				UpdateState.AddStateObject(UpdatedUnit);
				`GAMERULES.SubmitGameState(UpdateState);

				PopulateData();
				break;
			}
		case class'UIUtilities_Input'.const.FXS_MOUSE_5:
		case class'UIUtilities_Input'.const.FXS_KEY_TAB:
		case class'UIUtilities_Input'.const.FXS_BUTTON_RBUMPER:
		case class'UIUtilities_Input'.const.FXS_MOUSE_4:
		case class'UIUtilities_Input'.const.FXS_KEY_LEFT_SHIFT:
		case class'UIUtilities_Input'.const.FXS_BUTTON_LBUMPER:
			// Prevent switching soldiers during AfterAction promotion
			if( UIAfterAction(GetScreen('UIAfterAction')) == none &&
				!XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitReference.ObjectID)).ShowPromoteIcon())
				bHandled = false;
			break;
		case class'UIUtilities_Input'.const.FXS_BUTTON_B:
		case class'UIUtilities_Input'.const.FXS_KEY_ESCAPE:
		case class'UIUtilities_Input'.const.FXS_R_MOUSE_DOWN:
			OnCancel();
			break;
		case class'UIUtilities_Input'.const.FXS_BUTTON_A:
		case class'UIUtilities_Input'.const.FXS_KEY_ENTER:
		case class'UIUtilities_Input'.const.FXS_KEY_SPACEBAR:
			if( UIAfterAction(GetScreen('UIAfterAction')) != none )
				OnCancel();
			break;
		default:
			bHandled = false;
			break;
	}
	
	//if (AbilityList.Navigator.OnUnrealCommand(cmd, arg))
	//{
		//return true;
	//}
	
	return bHandled || super(UIArmory).OnUnrealCommand(cmd, arg);
}

simulated function OnReceiveFocus()
{
	local int i;
	local XComHQPresentationLayer HQPres;

	super(UIArmory).OnReceiveFocus();

	HQPres = XComHQPresentationLayer(Movie.Pres);

	if(HQPres != none)
	{
		if(bAfterActionPromotion) //If the AfterAction screen is running, let it position the camera
			HQPres.CAMLookAtNamedLocation(AfterActionScreen.GetPromotionBlueprintTag(UnitReference), `HQINTERPTIME);
		else
			HQPres.CAMLookAtNamedLocation(CameraTag, `HQINTERPTIME);
	}

	for(i = 0; i < AbilityList.ItemCount; ++i)
	{
		UIArmory_LWExpandedPromotionItem(AbilityList.GetItem(i)).RealizePromoteState();
	}

	if (previousSelectedIndexOnFocusLost >= 0)
	{
		Navigator.SetSelected(AbilityList);
		AbilityList.SetSelectedIndex(previousSelectedIndexOnFocusLost);
		UIArmory_PromotionItem(AbilityList.GetSelectedItem()).SetSelectedAbility(SelectedAbilityIndex);
	}
	else
	{
		Navigator.SetSelected(ClassRowItem);
		ClassRowItem.SetSelectedAbility(1);
	}
	UpdateNavHelp();
}

simulated function string GetPromotionBlueprintTag(StateObjectReference UnitRef)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitRef.ObjectID));
	if (UnitState.IsGravelyInjured())
	{
		return default.DisplayTag $ "Injured";
	}
	return string(default.DisplayTag);
}

simulated static function bool CanCycleTo(XComGameState_Unit Soldier)
{
	return super(UIArmory).CanCycleTo(Soldier) && Soldier.GetRank() >= 1 || Soldier.CanRankUpSoldier();
}

simulated static function CycleToSoldier(StateObjectReference UnitRef)
{
	local XComHQPresentationLayer HQPres;
	local UIArmory_MainMenu_LW MainMenu;
	local UIArmory_LWExpandedPromotion ExpandedScreen;
	local UIArmory_Promotion PromotionScreen;
	local XComGameState_Unit UnitState;
	local name SoldierClassName;
	//local bool bHadClassPopup;
	//local UIAlert OldAlert;

	super(UIArmory).CycleToSoldier(UnitRef);
	HQPres = `HQPRES;

	// Prevent the spawning of popups while we reload the promotion screen
	MainMenu = UIArmory_MainMenu_LW(`SCREENSTACK.GetScreen(class'UIArmory_MainMenu_LW'));
	MainMenu.bIsHotlinking = true;

	// Reload promotion screen since we might need a separate instance (regular or psi promote) depending on unit
	`SCREENSTACK.PopFirstInstanceOfClass(class'UIArmory_LWExpandedPromotion');

	SoldierClassName = class'X2StrategyGameRulesetDataStructures'.static.PromoteSoldier(UnitRef);
	if (SoldierClassName == '')
	{
		UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitRef.ObjectID));
		SoldierClassName = UnitState.GetSoldierClassTemplate().DataName;
	}
	
	if (UnitState.GetSoldierClassTemplateName() == 'PsiOperative')
	{
		PromotionScreen = UIArmory_PromotionPsiOp(HQPres.ScreenStack.Push(HQPres.Spawn(class'UIArmory_PromotionPsiOp', HQPres), HQPres.Get3DMovie()));
		PromotionScreen.InitPromotion(UnitRef, true);
	}
	else
	{
		ExpandedScreen = UIArmory_LWExpandedPromotion(HQPres.ScreenStack.Push(HQPres.Spawn(class'UIArmory_LWExpandedPromotion', HQPres), HQPres.Get3DMovie()));
		ExpandedScreen.InitPromotion(UnitRef, true);
	}
	PromotionScreen = ExpandedScreen;
	`XEVENTMGR.TriggerEvent('OnUnitPromotion', UnitState, PromotionScreen); // trigger for manual promotion events -- typically used for first-time promotion dialogue boxes, cinematics, etc

	MainMenu.bIsHotlinking = false;
}

simulated function OnRemoved()
{
	if(ActorPawn != none)
	{
		// Restore the character's default idle animation
		XComHumanPawn(ActorPawn).CustomizationIdleAnim = '';
		XComHumanPawn(ActorPawn).PlayHQIdleAnim();
	}

	// Reset soldiers out of view if we're promoting this unit on top of the avenger.
	// NOTE: This can't be done in UIAfterAction.OnReceiveFocus because that function might trigger when user dismisses the new class cinematic.
	if(AfterActionScreen != none)
	{
		AfterActionScreen.ResetUnitLocations();
	}

	super(UIArmory).OnRemoved();
}

simulated function OnCancel()
{
	if( UIAfterAction(GetScreen('UIAfterAction')) != none || 
		class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('T0_M2_WelcomeToArmory') )
	{
		super(UIArmory).OnCancel();
	}
}

//==============================================================================

simulated function AS_SetTitle(string Image, string TitleText, string LeftTitle, string RightRitle, string ClassTitle)
{
	MC.BeginFunctionOp("setPromotionTitle");
	MC.QueueString(Image);
	MC.QueueString(TitleText);
	MC.QueueString(class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(LeftTitle));
	MC.QueueString(class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(RightRitle));
	MC.QueueString(ClassTitle);
	MC.EndOp();
}

//==============================================================================

defaultproperties
{
	Package         = "/ package/gfxArmory_LW/Armory_Expanded";

	LibID = "PromotionScreenMC";
	bHideOnLoseFocus = false;
	bAutoSelectFirstNavigable = false;
	DisplayTag = "UIBlueprint_Promotion";
	CameraTag = "UIBlueprint_Promotion";
	SummaryTitleFontSize = 22
	SummaryBodyFontSize = 18
	SelectedAbilityIndex = -1;
}