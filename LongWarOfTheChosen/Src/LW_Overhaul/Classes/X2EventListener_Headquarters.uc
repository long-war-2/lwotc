// X2EventListener_Headquarters.uc
// 
// A listener template that handles events fired in relation to headquarters,
// be they XCOM, Resistance, or Alien.
//
class X2EventListener_Headquarters extends X2EventListener config(LW_Overhaul);

var config array<float> CA_RISK_REDUCTION_PER_RANK;
var config array<float> CA_RISK_INCREASE_PER_FL;
var config array<float> CA_AP_REWARD_SCALAR;
var config array<float> CA_STD_REWARD_SCALAR;
var config int CA_RISK_FL_CAP;
var config int AMBUSH_RISK_MODIFIER;

var config array<name> NO_INSPIRATION_TECHS;

var config int LISTENER_PRIORITY;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateXComHQListeners());
	Templates.AddItem(CreateXComArmoryListeners());
	Templates.AddItem(CreateCovertActionListeners());
	Templates.AddItem(CreateWillProjectListeners());

	return Templates;
}

////////////////
/// Strategy ///
////////////////

static function CHEventListenerTemplate CreateXComHQListeners()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'XComHQListeners');
	Template.AddCHEvent('OverrideScienceScore', OverrideScienceScore, ELD_Immediate, GetListenerPriority());
	Template.AddCHEvent('CanTechBeInspired', CanTechBeInspired, ELD_Immediate, GetListenerPriority());
	Template.AddCHEvent('UIAvengerShortcuts_ShowCQResistanceOrders', ShowOrHideResistanceOrdersButton, ELD_Immediate, GetListenerPriority());
	Template.AddCHEvent('UIPersonnel_OnSortFinished', OnUIPersonnelDataRefreshed, ELD_Immediate, GetListenerPriority());
	Template.AddCHEvent('UpdateResources', OnUpdateResources_LW, ELD_Immediate, GetListenerPriority());
	Template.AddCHEvent('OnResearchReport', ShowItemGrantedPopup, ELD_Immediate, GetListenerPriority());
	Template.AddCHEvent('OverrideImageForItemAvaliable', FixResearchItemImages, ELD_Immediate, GetListenerPriority());

	Template.RegisterInStrategy = true;

	return Template;
}

// KDM : Event listeners dealing with the Armory on the Avenger.
static function CHEventListenerTemplate CreateXComArmoryListeners()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'XComArmoryListeners');
	Template.AddCHEvent('UIArmory_WeaponUpgrade_SlotsUpdated', WeaponUpgrade_SlotsUpdated, ELD_Immediate, 91); // This one needs to run first
	Template.AddCHEvent('UIArmory_WeaponUpgrade_NavHelpUpdated', OnWeaponUpgradeNavHelpUpdated, ELD_Immediate, GetListenerPriority());

	Template.RegisterInStrategy = true;

	return Template;
}

static function CHEventListenerTemplate CreateCovertActionListeners()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'CovertActionListeners');
	Template.AddCHEvent('CovertAction_PreventGiveRewards', CAPreventRewardOnFailure, ELD_Immediate, GetListenerPriority());
	Template.AddCHEvent('CovertAction_AllowResActivityRecord', CAPreventRecordingOnFailure, ELD_Immediate, GetListenerPriority());
	Template.AddCHEvent('CovertActionRisk_AlterChanceModifier', CAAdjustRiskChance, ELD_Immediate, GetListenerPriority());
	Template.AddCHEvent('CovertAction_OverrideRiskStrings', CAOverrideRiskStrings, ELD_Immediate, GetListenerPriority());
	Template.AddCHEvent('CovertAction_OverrideRewardScalar', CAOverrideRewardScalar, ELD_Immediate, GetListenerPriority());
	Template.AddCHEvent('CovertActionCompleted', CAProcessCompletion, ELD_OnStateSubmitted, GetListenerPriority());
	Template.AddCHEvent('StaffUpdated', CARecalculateRisksForUI, ELD_OnStateSubmitted, GetListenerPriority());
	Template.AddCHEvent('LWCovertActionScreenOpened', CARecalculateRisksForUI, ELD_Immediate, GetListenerPriority());

	Template.RegisterInStrategy = true;

	return Template;
}

static function CHEventListenerTemplate CreateWillProjectListeners()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'WillRecoveryProjectListeners');
	Template.AddCHEvent('StaffUpdated', UpdateWillProjectForStaff, ELD_Immediate, 99);

	Template.RegisterInStrategy = true;

	return Template;
}

static protected function int GetListenerPriority()
{
	return default.LISTENER_PRIORITY != -1 ? default.LISTENER_PRIORITY : class'XComGameState_LWListenerManager'.default.DEFAULT_LISTENER_PRIORITY;
}

// Tedster - borrowed from Prototype Armory code

static protected function EventListenerReturn WeaponUpgrade_SlotsUpdated (Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local UIDropWeaponUpgradeButton DropButton;
	local UIArmory_WeaponUpgradeItem Slot;
	local UIList SlotsList;
	local UIPanel Panel;

	// Only if we can reuse upgrades
	if (!`XCOMHQ.bReuseUpgrades) return ELR_NoInterrupt;

	if (`ISCONTROLLERACTIVE)
	{
		// We add the button only if using mouse
		return ELR_NoInterrupt;
	}

	SlotsList = UIList(EventData);
	if (SlotsList == none)
	{
		`RedScreen("Recived UIArmory_WeaponUpgrade_SlotsUpdated but data isn't UIList");
		return ELR_NoInterrupt;
	}

	foreach SlotsList.ItemContainer.ChildPanels(Panel)
	{
		Slot = UIArmory_WeaponUpgradeItem(Panel);
		if (Slot == none || Slot.UpgradeTemplate == none || Slot.bIsDisabled) continue;

		DropButton = Slot.Spawn(class'UIDropWeaponUpgradeButton', Slot);
		DropButton.InitDropButton();
	}

	return ELR_NoInterrupt;
}


// KDM : Listen for navigation help updates within UIArmory_WeaponUpgrade
static function EventListenerReturn OnWeaponUpgradeNavHelpUpdated(
	Object EventData,
	Object EventSource,
	XComGameState NewGameState,
	Name InEventID,
	Object CallbackData)
{
	local bool AllowWeaponStripping, IsUpgradesListSelected;
	local UIArmory_WeaponUpgrade WeaponUpgradeScreen;
	local UIList UpgradesList;
	local UINavigationHelp NavHelp;
	local UIPanel UpgradesListContainer;
	
	WeaponUpgradeScreen = UIArmory_WeaponUpgrade(EventSource);
	NavHelp = UINavigationHelp(EventData);

	if (NavHelp == none)
	{
		`LWTrace("OnWeaponUpgradeNavHelpUpdated event did not have UINavigationHelp as its data");
		return ELR_NoInterrupt;
	}

	if ((WeaponUpgradeScreen == none) || (UIArmory_WeaponTrait(WeaponUpgradeScreen) != none))
	{
		`LWTrace("OnWeaponUpgradeNavHelpUpdated event did not have UIArmory_WeaponUpgrade as its source");
		return ELR_NoInterrupt;
	}

	UpgradesListContainer = WeaponUpgradeScreen.UpgradesListContainer;
	UpgradesList = WeaponUpgradeScreen.UpgradesList;

	IsUpgradesListSelected = ((WeaponUpgradeScreen.Navigator.GetSelected() == UpgradesListContainer) && (UpgradesListContainer.Navigator.GetSelected() == UpgradesList));
	// KDM : Don't allow weapon stripping if either the 1.] upgrade slot list is open 2.] colour selector is open.
	AllowWeaponStripping = (!(IsUpgradesListSelected || (WeaponUpgradeScreen.ColorSelector != none)));
	
	if (AllowWeaponStripping)
	{
		// KDM : 'Strip Weapon Upgrades' is a CustomizeList list item for mouse & keyboard users, so it doesn't need to be added to the
		// navigation help system.
		if (`ISCONTROLLERACTIVE)
		{
			// KDM : Right stick click corresponds to 'Strip [this weapon's] Upgrades'
			NavHelp.AddRightHelp(CAPS(class'UIScreenListener_ArmoryWeaponUpgrade_LW'.default.strStripWeaponUpgradesButton), 
				class'UIUtilities_Input'.const.ICON_RSCLICK_R3, , false, 
				class'UIScreenListener_ArmoryWeaponUpgrade_LW'.default.strStripWeaponUpgradesTooltip);
		}

		// KDM : Left stick click corresponds to 'Strip Upgrades From Inactive Soldiers'.
		NavHelp.AddRightHelp(CAPS(class'UIScreenListener_ArmoryWeaponUpgrade_LW'.default.StripAllWeaponUpgradesStr), 
			class'UIUtilities_Input'.const.ICON_LSCLICK_L3, class'UIScreenListener_ArmoryWeaponUpgrade_LW'.static.OnStripUpgrades, 
			false, class'UIUtilities_LW'.default.m_strTooltipStripWeapons);
	}

	NavHelp.Show();

	return ELR_NoInterrupt;
}

static function EventListenerReturn OverrideScienceScore(
	Object EventData,
	Object EventSource,
	XComGameState NewGameState,
	Name InEventID,
	Object CallbackData)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameStateHistory History;
	local XComGameState_Unit Scientist;
	local XComGameState_StaffSlot StaffSlot;
	local XComLWTuple Tuple;
	local int CurrScienceScore;
	local int idx;
	local bool AddLabBonus;

	Tuple = XComLWTuple(EventData);
	if (Tuple == none)
	{
		`LWTrace("OverrideScienceScore event not fired with a Tuple as its data");
		return ELR_NoInterrupt;
	}

	CurrScienceScore = Tuple.Data[0].i;
	AddLabBonus = Tuple.Data[1].b;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	// If AddLabBonus is true, we're computing science scores, so we should remove the contribution from any scientist assigned
	// to a facility that isn't the lab. If it's false, we're checking a science gate and should consider all scientists regardless
	// of their location.
	if (AddLabBonus)
	{
		for (idx = 0; idx < XComHQ.Crew.Length; ++idx)
		{
			Scientist = XComGameState_Unit(History.GetGameStateForObjectID(XComHQ.Crew[idx].ObjectID));

			// Only worry about living scientists, and skip Tygan. LWOTC: Scientists on covert actions
			// (which includes haven advisers) are handled by the base game, so ignore those too.
			if (Scientist.IsScientist() && !Scientist.IsDead() && !Scientist.IsOnCovertAction() &&
				Scientist.GetMyTemplateName() != 'HeadScientist')
			{
				// This scientist was counted by the base game. If they are in a staff slot that is not the lab,
				// remove their score.
				StaffSlot = Scientist.GetStaffSlot();
				if (StaffSlot != none && StaffSlot.GetMyTemplateName() != 'LaboratoryStaffSlot')
				{
					CurrScienceScore -= Scientist.GetSkillLevel(AddLabBonus);
				}
			}
		}
	}

	Tuple.Data[0].i = CurrScienceScore;
	return ELR_NoInterrupt;
}

// Prevent repeatable research from being inspired.
static function EventListenerReturn CanTechBeInspired(
	Object EventData,
	Object EventSource,
	XComGameState NewGameState,
	Name InEventID,
	Object CallbackData)
{
	local XComLWTuple Tuple;
	local XComGameState_Tech TechState;

	Tuple = XComLWTuple(EventData);
	if (Tuple == none)
	{
		`LWTrace("CanTechBeInspired event not fired with a Tuple as its data");
		return ELR_NoInterrupt;
	}

	// Exclude repeatable research from inspiration
	TechState = XComGameState_Tech(EventSource);

	if(default.NO_INSPIRATION_TECHS.Find(TechState.GetMyTemplateName()) != INDEX_NONE)
	{
		Tuple.Data[0].b = false;
		return ELR_NoInterrupt;
	}
	else
	{
		Tuple.Data[0].b = !TechState.GetMyTemplate().bRepeatable;
	}

	return ELR_NoInterrupt;
}

static function EventListenerReturn ShowOrHideResistanceOrdersButton(
	Object EventData,
	Object EventSource,
	XComGameState GameState,
	Name EventID,
	Object CallbackData)
{
	local XComLWTuple Tuple;

	Tuple = XComLWTuple(EventData);
	if (Tuple == none) return ELR_NoInterrupt;

	// The event expects `true` if the button should be shown, or
	// `false` if it should be hidden.
	Tuple.Data[0].b = class'Helpers_LW'.static.AreResistanceOrdersEnabled();

	return ELR_NoInterrupt;
}

static function EventListenerReturn OnUIPersonnelDataRefreshed(
	Object EventData,
	Object EventSource,
	XComGameState GameState,
	Name EventID,
	Object CallbackData)
{
	local UIList PersonnelList;
	local UIPersonnel PersonnelScreen;
	local UIScrollbar Scrollbar;
	
	PersonnelScreen = UIPersonnel(EventSource);

	if (PersonnelScreen != none)
	{
		PersonnelList = PersonnelScreen.m_kList;
		if (PersonnelList != none && PersonnelList.GetItemCount() > 1)
		{
			Scrollbar = PersonnelList.Scrollbar;
			if (Scrollbar != none)
			{
				// KDM : If the personnel list needs a scrollbar, we know that the total height of the personnel rows
				// exceeds the height of the personnel list. In this case, we want to make sure that the personnel
				// list is scrolled to the appropriate location, so we see the selected personnel row.
				//
				// Now, when the personnel screen, UIPersonnel, receives focus, its list can potentially re-select a previously
				// selected personnel row via RefreshData() --> UpdateList(). This behaviour is desirable, as you may have 
				// chosen to view a particular soldier from the soldier list then cancelled back to the soldier list after 
				// finishing whatever it was you were doing.
				
				// Unfortunately : 
				// 1.] UIPersonnel's UpdateList() clears the list via ClearItems() which removes, and thus resets, the scrollbar.
				// BUT
				// 2.] UIPersonnel's UpdateList() calls SetSelectedIndex() on the list, and SetSelected() on the 
				// list's navigator; however, neither function modifies the list's scroll position via Scrollbar.SetThumbAtPercent(). 
				// This is because the only place the scrollbar is manipulated is within UIList's NavigatorSelectionChanged, which 
				// is called via Navigator.OnSelectedIndexChanged. Navigator.OnSelectedIndexChanged is called in functions like 
				// Prev(), Next(), SelectFirstAvailable(), and SelectFirstAvailableIfNoCurrentSelection(); however, it is not 
				// called within SetSelected().
				//
				// The end result is that we can have a list item selected, but not be able to see it due to an inappropriate
				// scrollbar value. Generally speaking, the scrollbar will be scrolled to the top, after being reset, while 
				// the selected list item will be down below. Consequently, we set the scrollbar value here to make sure we 'see' 
				// the currently selected list item.
			 
				Scrollbar.SetThumbAtPercent(float(PersonnelList.SelectedIndex) 
					/ float(PersonnelList.GetItemCount() - 1));
			}
		}
	}

	return ELR_NoInterrupt;
}

static function EventListenerReturn OnUpdateResources_LW(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComHQPresentationLayer HQPres;

	HQPres = `HQPRES;

	// KDM : If we are viewing the 'fixed' recruit screen, UIRecruitSoldiers_LW, or any subclass of 
	// UIRecruitSoldiers, the resource display will not work as UIAvengerHUD only looks for the base screen, 
	// UIRecruitSoldiers. Therefore, we need to set up the resource display ourself.
	//
	// Note : We do not want to run this code if the screen we are looking at is of type UIRecruitSoldiers
	// since it has already been dealt with in UIAvengerHUD, and this would display double.
	if (HQPres.ScreenStack.IsCurrentClass(class'UIRecruitSoldiers') && 
		!(HQPres.ScreenStack.GetCurrentClass() == class'UIRecruitSoldiers'))
	{
		// KDM : Display the same information a normal Recruit Screen would show.
		HQPres.m_kAvengerHUD.UpdateMonthlySupplies();
		HQPres.m_kAvengerHUD.UpdateSupplies();
		HQPres.m_kAvengerHUD.ShowResources();
	}
	// KDM : If we are viewing the Long War Dark Event screen, UIAdventOperations_LW, or any subclass
	// of UIAdventOperations, make sure the resource bar displays properly.
	else if (HQPres.ScreenStack.IsCurrentClass(class'UIAdventOperations') && 
		!(HQPres.ScreenStack.GetCurrentClass() == class'UIAdventOperations'))
	{
		// KDM : Display the same information a normal Dark Event Screen would show.
		HQPres.m_kAvengerHUD.UpdateMonthlySupplies();
		HQPres.m_kAvengerHUD.UpdateSupplies();
		HQPres.m_kAvengerHUD.UpdateIntel();
		HQPres.m_kAvengerHUD.ShowResources();
	}

	return ELR_NoInterrupt;
}

// Forces the "item granted" popup to show when research is complete,
// since the base game doesn't do this.
static function EventListenerReturn ShowItemGrantedPopup(
	Object EventData,
	Object EventSource,
	XComGameState GameState,
	Name EventID,
	Object CallbackData)
{
	local XComGameState_Tech TechState;
	// local X2ItemTemplateManager ItemTemplateManager;
	local X2ItemTemplate ItemTemplate;
	local array<X2ItemTemplate> ItemRewards;

	TechState = XComGameState_Tech(EventData);
	if (TechState == none) return ELR_NoInterrupt;

	// ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	ItemRewards = TechState.ItemRewards;

	foreach ItemRewards(ItemTemplate)
	{
		`HQPRES.UIItemReceived(ItemTemplate);
	}

	return ELR_NoInterrupt;
}

// Items unlocked by research are displayed in popups using the
// "base" images, i.e. without attachments. Looks really weird.
// This listener overrides those with the correct images. Thanks
// to Xymanek and the Prototype Armoury mod from which this code
// was copied.
static function EventListenerReturn FixResearchItemImages(
	Object EventData,
	Object EventSource,
	XComGameState GameState,
	Name EventID,
	Object CallbackData)
{
	local X2ItemTemplate CurrentItemTemplate;
	local XComLWTuple Tuple;

	Tuple = XComLWTuple(EventData);
	if (Tuple == none || Tuple.Id != 'OverrideImageForItemAvaliable') return ELR_NoInterrupt;

	CurrentItemTemplate = X2ItemTemplate(Tuple.Data[1].o);

	if (CurrentItemTemplate.strInventoryImage != "")
	{
		Tuple.Data[0].s = CurrentItemTemplate.strInventoryImage;
	}

	return ELR_NoInterrupt;
}

// Don't give the rewards if the covert action failed.
static function EventListenerReturn CAPreventRewardOnFailure(
	Object EventData,
	Object EventSource,
	XComGameState GameState,
	Name EventID,
	Object CallbackData)
{
	local XComGameState_CovertAction CAState;
	local XComLWTuple Tuple;

	Tuple = XComLWTuple(EventData);
	if (Tuple == none) return ELR_NoInterrupt;

	CAState = XComGameState_CovertAction(EventSource);
	if (CAState == none) return ELR_NoInterrupt;

	// Prevent the reward if the covert action failed.
	Tuple.Data[0].b = class'Utilities_LW'.static.DidCovertActionFail(CAState);

	return ELR_NoInterrupt;
}

// Don't record the resistance activity if the covert action failed.
static function EventListenerReturn CAPreventRecordingOnFailure(
	Object EventData,
	Object EventSource,
	XComGameState GameState,
	Name EventID,
	Object CallbackData)
{
	local XComGameState_CovertAction CAState;
	local XComLWTuple Tuple;

	Tuple = XComLWTuple(EventData);
	if (Tuple == none) return ELR_NoInterrupt;

	CAState = XComGameState_CovertAction(EventSource);
	if (CAState == none) return ELR_NoInterrupt;

	// The failure risk has triggered, so prevent covert action
	// completion code from recording this resistance activity.
	// Note that failure should return `false` in the tuple because
	// `true` means the listener is *allowing* the recording of this
	// action.
	Tuple.Data[0].b = !class'Utilities_LW'.static.DidCovertActionFail(CAState);

	return ELR_NoInterrupt;
}

// The chance of a covert action failure is adjusted by the ranks of the
// soldiers on the covert action. The higher the rank, the lower the chance
// of failure.
//
// The chance of ambush scales with the difficulty rating/level of the
// covert action.
static function EventListenerReturn CAAdjustRiskChance(
	Object EventData,
	Object EventSource,
	XComGameState GameState,
	Name EventID,
	Object CallbackData)
{
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_CovertAction CAState;
	local XComGameState_StaffSlot SlotState;
	local XComGameState_Unit UnitState;
	local XComLWTuple Tuple;
	local CovertActionRisk Risk;
	local int i, RiskIndex, RiskChanceAdjustment;
	
	Tuple = XComLWTuple(EventData);
	if (Tuple == none) return ELR_NoInterrupt;
	
	CAState = XComGameState_CovertAction(EventSource);
	if (CAState == none) return ELR_NoInterrupt;

	// Modify the Ambush risk based the number of covert actions in a row
	// that haven't been ambushed.
	if (Tuple.Data[0].n == 'CovertActionRisk_Ambush')
	{
		Tuple.Data[4].i += class'XComGameState_CovertActionTracker'.static.CreateOrGetCovertActionTracker(GameState).ActionsCompletedWithoutAmbush *
			default.AMBUSH_RISK_MODIFIER;
		return ELR_NoInterrupt;
	}
	
	// We're only interested in altering the risk chance for the failure
	// risk right now.
	if (InStr(Caps(Tuple.Data[0].n), Caps(class'Utilities_LW'.const.CA_FAILURE_RISK_MARKER)) == INDEX_NONE)
		return ELR_NoInterrupt;
	
	// Go through all the soldier slots, building up the failure risk
	// reduction based on the soldiers' ranks.
	RiskChanceAdjustment = 0;
	for (i = 0; i < CAState.StaffSlots.Length; i++)
	{
		SlotState = CAState.GetStaffSlot(i);
		if (SlotState.IsSlotFilled())
		{
			UnitState = SlotState.GetAssignedStaff();
			if (UnitState.IsSoldier())
			{
				RiskChanceAdjustment -= UnitState.GetRank() * `ScaleStrategyArrayFloat(default.CA_RISK_REDUCTION_PER_RANK);
			}
		}
	}

	// Adjust risk reduction by number of soldiers (we don't want risk reduction scaling
	// by number of soldiers, just the relative ranks of those soldiers).
	RiskChanceAdjustment = Round(RiskChanceAdjustment * 2 / CAState.StaffSlots.Length);

	// Adjust the risk chance in the other direction based on force level.
	AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	RiskChanceAdjustment += Min(AlienHQ.GetForceLevel(), default.CA_RISK_FL_CAP) * `ScaleStrategyArrayFloat(default.CA_RISK_INCREASE_PER_FL);

	// Make sure we don't go negative on the risk chance.
	RiskIndex = CAState.Risks.Find('RiskTemplateName', Tuple.Data[0].n);
	if (RiskIndex != INDEX_NONE)
	{
		Risk = CAState.Risks[RiskIndex];
		RiskChanceAdjustment = Max(RiskChanceAdjustment, -Risk.ChanceToOccur);
	}
	else
	{
		`REDSCREEN("Cannot find covert action risk " $ Tuple.Data[0].n $ " in this CA's list of risks");
	}

	// Modify the current risk chance modifier by the risk reduction
	// we just calculated.
	Tuple.Data[4].i += RiskChanceAdjustment;

	return ELR_NoInterrupt;
}

// Called when a staff slot is updated, this function will force a
// recalculation of the current covert action's risks (if the
// Covert Actions screen is open when the event is fired).
static function EventListenerReturn CARecalculateRisksForUI(
	Object EventData,
	Object EventSource,
	XComGameState GameState,
	Name EventID,
	Object CallbackData)
{
	local UICovertActions CAScreen;
	local XComGameState_CovertAction CAState;

	//`LWTrace(" CARecalculateRisksForUI called");

	CAScreen = UICovertActions(`SCREENSTACK.GetFirstInstanceOf(class'UICovertActions'));
	if (CAScreen == none)
	{
		// We're not in the Covert Actions screen, so we don't care about the
		// 'StaffUpdated' event.
		return ELR_NoInterrupt;
	}

	CAState = CAScreen.GetAction();
	CAState.RecalculateRiskChanceToOccurModifiers();

	// Refresh the Risks page to show the updated numbers.
	CAScreen.RefreshRisksPanel();

	return ELR_NoInterrupt;
}

static function EventListenerReturn CAOverrideRiskStrings(
	Object EventData,
	Object EventSource,
	XComGameState GameState,
	Name EventID,
	Object CallbackData)
{
	local X2StrategyElementTemplateManager TemplateManager;
	local X2CovertActionRiskTemplate CARiskTemplate;
	local XComGameState_CovertAction CAState;
	local CovertActionRisk Risk;
	local XComLWTuple Tuple;
	local string RiskChanceString, NewChanceString;
	local int i;

	Tuple = XComLWTuple(EventData);
	if (Tuple == none) return ELR_NoInterrupt;

	CAState = XComGameState_CovertAction(EventSource);
	if (CAState == none) return ELR_NoInterrupt;

	TemplateManager = CAState.GetMyTemplateManager();

	foreach CAState.Risks(Risk)
	{
		CARiskTemplate = X2CovertActionRiskTemplate(TemplateManager.FindStrategyElementTemplate(Risk.RiskTemplateName));

		// Find the index of the label that matches this risk's localized name
		i = Tuple.Data[0].as.Find(CARiskTemplate.RiskName);
		if (i != INDEX_NONE)
		{
			RiskChanceString = class'X2StrategyGameRulesetDataStructures'.default.CovertActionRiskLabels[Risk.Level];
			NewChanceString = string(Risk.ChanceToOccur + Risk.ChanceToOccurModifier) $ "%";

			// This is replacing the risk value with the percentage chance to occur.
			Tuple.Data[1].as[i] = Repl(Tuple.Data[1].as[i], RiskChanceString, NewChanceString);
		}
	}
	return ELR_NoInterrupt;
}

// Modify the reward scalar used for covert action rewards like supplies and intel
static function EventListenerReturn CAOverrideRewardScalar(
	Object EventData,
	Object EventSource,
	XComGameState GameState,
	Name EventID,
	Object CallbackData)
{
	local XComLWTuple Tuple;
	local XComGameState_Reward RewardState;

	Tuple = XComLWTuple(EventData);
	if (Tuple == none) return ELR_NoInterrupt;

	RewardState = XComGameState_Reward(Tuple.Data[1].o);
	if (RewardState == none) return ELR_NoInterrupt;

	// This is replacing the risk value with the percentage chance to occur.
	Tuple.Data[0].f = RewardState.GetMyTemplateName() == 'Reward_AbilityPoints' ?
			`ScaleStrategyArrayFloat(default.CA_AP_REWARD_SCALAR) :
			`ScaleStrategyArrayFloat(default.CA_STD_REWARD_SCALAR);

	return ELR_NoInterrupt;
}

// We need to keep track of how many times units go on the Intense
// Training covert action and how many covert actions have not
// been ambushed (that have an ambush risk).
// Also handles respawning failed golden path covert actions
// Also handles spawning new mission for new big supply depot
static function EventListenerReturn CAProcessCompletion(
	Object EventData,
	Object EventSource,
	XComGameState GameState,
	Name EventID,
	Object CallbackData)
{
	local XComGameState NewGameState;
	local XComGameStateHistory History;
	local XComGameState_CovertAction CAState, PrevCAState;
	local XComGameState_CovertActionTracker CATracker;
	local XComGameState_StaffSlot SlotState;
	local XComGameState_Unit UnitState;
	local CovertActionStaffSlot StaffSlot;
	local UnitValue UnitValue;

	local XComGameState_ResistanceFaction FactionState;
	local X2CovertActionTemplate ActionTemplate;

	//local XComGameState_LWAlienActivity NewActivityState;
	//local X2LWAlienActivityTemplate ActivityTemplate;
	//local X2StrategyElementTemplateManager StrategyElementTemplateMgr;

	CAState = XComGameState_CovertAction(EventSource);
	if (CAState == none) return ELR_NoInterrupt;

	PrevCAState = XComGameState_CovertAction(`XCOMHISTORY.GetPreviousGameStateForObject(CAState));

	// We want to keep track of how many covert actions with an ambush
	// risk have not been ambushed in a row. This is so we can increase
	// the ambush chance the more covert actions have not been ambushed.
	if (CAState.GetMyTemplate().Risks.Find('CovertActionRisk_Ambush') != INDEX_NONE)
	{
		// We need to get the last covert action state from history because
		// the `bAmbushed` flag is cleared just before the covert action
		// completion processing happens.
		// line moved above if block so that PrevCAState can be used elsewhere.
		
		if (PrevCAState.bAmbushed)
		{
			// Covert action was ambushed, so reset the counter
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Reset non-ambushed CA counter");
			CATracker = class'XComGameState_CovertActionTracker'.static.CreateOrGetCovertActionTracker(NewGameState);
			CATracker = XComGameState_CovertActionTracker(NewGameState.ModifyStateObject(class'XComGameState_CovertActionTracker', CATracker.ObjectID));
			CATracker.ActionsCompletedWithoutAmbush = 0;
			`GAMERULES.SubmitGameState(NewGameState);
		}
		else
		{
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Increment non-ambushed CA counter");
			CATracker = class'XComGameState_CovertActionTracker'.static.CreateOrGetCovertActionTracker(NewGameState);
			CATracker = XComGameState_CovertActionTracker(NewGameState.ModifyStateObject(class'XComGameState_CovertActionTracker', CATracker.ObjectID));
			CATracker.ActionsCompletedWithoutAmbush++;
		}

		// We need to force ambush risk values to be updated for all currently
		// available covert actions, otherwise they will remain as they were
		// before this covert action completed.
		RecalculateCovertActionRisks(NewGameState);
		`GAMERULES.SubmitGameState(NewGameState);
	}

	// Handle respawning golden path covert action if it failed
	//Grab the previous covert action template.
	ActionTemplate = PrevCAState.GetMyTemplate();
	if(class'Utilities_LW'.static.DidCovertActionFail(PrevCAState) && ActionTemplate.bGoldenPath)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Respawn golden path covert action");
		FactionState = PrevCAState.GetFaction();
		FactionState = XComGameState_ResistanceFaction(NewGameState.ModifyStateObject(class'XComGameState_ResistanceFaction', FactionState.ObjectID));
		FactionState.GoldenPathActions.AddItem(FactionState.CreateCovertAction(NewGameState, ActionTemplate, ActionTemplate.RequiredFactionInfluence));

		`GAMERULES.SubmitGameState(NewGameState);
	}

	// Spawn depot mission if was successful.
	//`LWTrace("Current CA name:"@CAState.GetMyTemplateName());
	//if(!class'Utilities_LW'.static.DidCovertActionFail(PrevCAState) && CAState.GetMyTemplateName() == 'CovertAction_BigSupplyDepot')
	//{
		// spawn mission here:
	//	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Spawn Big Supply Extraction post covert");
	//	`LWTrace("Trying to spawn Big Supply Extract Mission");
	//	StrategyElementTemplateMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	//	ActivityTemplate = X2LWAlienActivityTemplate(StrategyElementTemplateMgr.FindStrategyElementTemplate('BigSupplyExtraction_LW'));

	//	NewActivityState = ActivityTemplate.CreateInstanceFromTemplate(CAState.Region, NewGameState);
	//	NewActivityState.bNeedsUpdateDiscovery = true;
	//	NewGameState.AddStateObject(NewActivityState);

	//	`GAMERULES.SubmitGameState(NewGameState);
	//}

	// Now handle the Intense Training covert action
	if (CAState.GetMyTemplateName() != 'CovertAction_IntenseTraining')
		return ELR_NoInterrupt;

	History = `XCOMHISTORY;
	foreach CAState.StaffSlots(StaffSlot)
	{
		SlotState = XComGameState_StaffSlot(History.GetGameStateForObjectID(StaffSlot.StaffSlotRef.ObjectID));
		if (SlotState == none) continue;

		UnitValue.fValue = 0.0;
		UnitState = SlotState.GetAssignedStaff();
		UnitState.GetUnitValue('CAIntenseTrainingCount', UnitValue);
		UnitState.SetUnitFloatValue('CAIntenseTrainingCount', UnitValue.fValue + 1, eCleanup_Never);
	}

	return ELR_NoInterrupt;
}

// 
static function RecalculateCovertActionRisks(XComGameState NewGameState)
{
	local XComGameStateHistory History;
	local XComGameState_CovertAction CAState;

	History = `XCOMHISTORY;
	foreach History.IterateByClassType(class'XComGameState_CovertAction', CAState)
	{
		if (CAState.GetMyTemplate().Risks.Find('CovertActionRisk_Ambush') != INDEX_NONE)
		{
			CAState = XComGameState_CovertAction(NewGameState.ModifyStateObject(class'XComGameState_CovertAction', CAState.ObjectID));
			CAState.RecalculateRiskChanceToOccurModifiers();
		}
	}
}

// Called when a staff slot is updated, this function will update
// any will project that currently exists for the given staff member
// that has been removed from or added to a staff slot. Only applies
// to soldiers.
static function EventListenerReturn UpdateWillProjectForStaff(
	Object EventData,
	Object EventSource,
	XComGameState GameState,
	Name EventID,
	Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameState_StaffSlot StaffSlot;
	local XComGameState_Unit UnitState;
	local X2StaffSlotTemplate SlotTemplate;

	StaffSlot = XComGameState_StaffSlot(EventSource);
	if (StaffSlot == none)
		return ELR_NoInterrupt;

	// Get the staff slot state from the new game state for reliability and access
	// to the absolutely latest state.
	StaffSlot = XComGameState_StaffSlot(GameState.GetGameStateForObjectID(StaffSlot.ObjectID));

	// Not a soldier, so no Will project.
	SlotTemplate = StaffSlot.GetMyTemplate();
	if (!SlotTemplate.bSoldierSlot)
		return ELR_NoInterrupt;

	// Get the previous game state if the slot is empty, because we're interested
	// in which unit was removed from the slot.
	History = `XCOMHISTORY;
	if (!StaffSlot.IsSlotFilled())
	{
		StaffSlot = XComGameState_StaffSlot(History.GetPreviousGameStateForObject(StaffSlot));
		if (StaffSlot == none || !StaffSlot.IsSlotFilled())
		{
			`REDSCREEN("Slot states are all messed up within StaffUpdated event!");
			return ELR_NoInterrupt;
		}
	}

	// Get the unit that was added to or removed from the slot.
	UnitState = XComGameState_Unit(GameState.GetGameStateForObjectID(StaffSlot.GetAssignedStaffRef().ObjectID));
	if (UnitState == none)
	{
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(StaffSlot.GetAssignedStaffRef().ObjectID));
	}

	// SPARKs don't have Will recovery projects!
	if (!UnitState.UsesWillSystem())
		return ELR_NoInterrupt;

	// Only update Will projects for certain staff slots.
	if (InStr(Caps(SlotTemplate.DataName), "COVERTACTION") == 0 ||
			SlotTemplate.DataName == 'RecoveryCenterBondStaffSlot' ||
			SlotTemplate.DataName == 'OTSOfficerSlot' ||
			SlotTemplate.DataName == 'PsiChamberSoldierStaffSlot' ||
			SlotTemplate.DataName == 'OTSStaffSlot')
	{
		class'Helpers_LW'.static.UpdateUnitWillRecoveryProject(UnitState);
	}

	return ELR_NoInterrupt;
}
