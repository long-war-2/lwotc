//----------------------------------------------------------------------------
//  FILE:    UITacticalHUD_AbilityContainer_LWExtended.uc
//  AUTHOR:  A. Behne (Amineri for integration)
//  PURPOSE: Containers holding current soldiers ability icons.
//----------------------------------------------------------------------------

class UITacticalHUD_AbilityContainer_LWExtended extends UITacticalHUD_AbilityContainer;

/** The maximum number of abilities per page. */
var int MaxAbilitiesPerPage;

/** The left-hand scroll button. */
var UIButton LeftButton;
/** The right-hand scroll button. */
var UIButton RightButton;

/** The current page index. */
var int m_iCurrentPage;
/** The number of pages. */
var int m_iPageCount;

var localized string strChangePageTitle;
var localized string strChangePageDesc;

/**
 * Initializes the container's properties.
 *
 * Overridden to spawn ability page scroll buttons.
 */
simulated function UITacticalHUD_AbilityContainer InitAbilityContainer()
{
	local UITacticalHUD_AbilityContainer container;

	container = super.InitAbilityContainer();

	LeftButton = Spawn(class'UIButton', self);
	LeftButton.LibID = 'X2DrawerButton';
	LeftButton.bAnimateOnInit = false;
	LeftButton.InitButton(,,OnScrollButtonClicked); //.SetPosition(-32, -13);

	RightButton = Spawn(class'UIButton', self);
	RightButton.LibID = 'X2DrawerButton';
	RightButton.bAnimateOnInit = false;
	RightButton.InitButton(,,OnScrollButtonClicked); //.SetPosition(431, -13);

	MaxAbilitiesPerPage = class'XComGameState_LWPerkPackOptions'.static.GetNumDisplayedAbilities();
	UpdateLeftRightButtonPositions();

	return container;
}

simulated function UpdateLeftRightButtonPositions()
{
	LeftButton.SetPosition(-32, -13);
	LeftButton.MC.ChildFunctionString("bg.arrow", "gotoAndStop", "left");
	RightButton.SetPosition((44.25 * MaxAbilitiesPerPage) + 31 - 44, -13);
	RightButton.MC.FunctionString("gotoAndStop", "right");
	RightButton.MC.ChildFunctionString("bg.arrow", "gotoAndStop", "left");
}

/**
 * Callback function for page scroll buttons.
 */
simulated function OnScrollButtonClicked(UIButton Button)
{
	if (Button == LeftButton)
	{
		// KDM : Show the 'previous' ability page.
		ChangeAbilityPage(true);
	}
	else if (Button == RightButton)
	{
		// KDM : Show the 'next' ability page.
		ChangeAbilityPage(false);
	}
}

/**
 * Regenerates the ability backing arrays and updates the visuals.
 *
 * Overridden to update the number of ability pages before updating the visuals.
 */
simulated function UpdateAbilitiesArray() 
{
	local int i;
	local int len;
	local X2GameRuleset Ruleset;
	local GameRulesCache_Unit UnitInfoCache;
	local array<AvailableAction> arrCommandAbilities;
	local int bCommanderAbility;
	local AvailableAction AbilityAvailableInfo; //Represents an action that a unit can perform. Usually tied to an ability.
	local UITacticalHUD TacticalHUD;
	
	TacticalHUD = UITacticalHUD(screen);

	// Hide any AOE indicators from old abilities
	for (i = 0; i < m_arrAbilities.Length; i++)
	{
		HideAOE(i);
	}

	// Clear out the array 
	m_arrAbilities.Length = 0;

	// Loop through all abilities
	Ruleset = `XCOMGAME.GameRuleset;
	Ruleset.GetGameRulesCache_Unit(XComTacticalController(PC).GetActiveUnitStateRef(), UnitInfoCache);

	len = UnitInfoCache.AvailableActions.Length;
	for (i = 0; i < len; i++)
	{	
		// Obtain unit's ability
		AbilityAvailableInfo = UnitInfoCache.AvailableActions[i];
		
		if (ShouldShowAbilityIcon(AbilityAvailableInfo, bCommanderAbility))
		{
			// Separate out the command abilities to send to the CommandHUD, and do not want to show them in the regular list
			// Commented out in case we bring CommanderHUD back
			if( bCommanderAbility == 1 )
			{
				arrCommandAbilities.AddItem(AbilityAvailableInfo);
			}

			// Add to our list of abilities 
			m_arrAbilities.AddItem(AbilityAvailableInfo);
		}
	}

	arrCommandAbilities.Sort(SortAbilities);
	m_arrAbilities.Sort(SortAbilities);

	// Calculate page count
	//m_iPageCount = 1 + (m_arrAbilities.Length - 1) / MaxAbilitiesPerPage;
	m_iPageCount = 1 + (m_arrAbilities.Length - arrCommandAbilities.Length - 1) / MaxAbilitiesPerPage;

	m_iCurrentPage = Min(m_iPageCount-1, m_iCurrentPage);

	PopulateFlash();

	TacticalHUD.m_kShotInfoWings.Show();
	// KDM : Follow the lead of UITacticalHUD_AbilityContainer.UpdateAbilitiesArray and, if using a controller,
	// update the 'Call Skyranger' navigation help visibility.
	if (`ISCONTROLLERACTIVE)
	{
		// KDM : If the ability menu is raised then hide the 'Call Skyranger' navigation help so it doesn't
		// get in the way of target selection.
		if (TacticalHUD.IsMenuRaised() && TacticalHUD.SkyrangerButton != none)
		{
			TacticalHUD.SkyrangerButton.Hide();
		}
		else
		{
			UITacticalHUD(screen).UpdateSkyrangerButton();
		}
	}
	TacticalHUD.m_kMouseControls.SetCommandAbilities(arrCommandAbilities);
	TacticalHUD.m_kMouseControls.UpdateControls();

	//  jbouscher: I am 99% certain this call is entirely redundant, so commenting it out
	//kUnit.UpdateUnitBuffs();

	// If we're in shot mode, then set the current ability index based on what (if anything) was populated
	if (TacticalHUD.IsMenuRaised() && (m_arrAbilities.Length > 0))
	{
		if (m_iMouseTargetedAbilityIndex == -1)
		{
			// MHU - We reset the ability selection if it's not initialized
			//       We also define the initial shot determined in XGAction_Fire
			//       Otherwise, retain the last selection
			if (m_iCurrentIndex < 0)
			{
				SetAbilityByIndex(0);
			}
			else
			{
				SetAbilityByIndex(m_iCurrentIndex);
			}
		}
	}

	// Do this after assigning the CurrentIndex
	UpdateWatchVariables();
	CheckForHelpMessages();
	DoTutorialChecks();
	//INS:

	if (`ISCONTROLLERACTIVE)
	{
		if(m_iCurrentIndex >= 0 && m_arrAbilities[m_iCurrentIndex].AvailableTargets.Length > 1)
			m_arrAbilities[m_iCurrentIndex].AvailableTargets = SortTargets(m_arrAbilities[m_iCurrentIndex].AvailableTargets);
		else if(m_iPreviousIndexForSecondaryMovement >= 0 && m_arrAbilities[m_iPreviousIndexForSecondaryMovement].AvailableTargets.Length > 1)
			m_arrAbilities[m_iPreviousIndexForSecondaryMovement].AvailableTargets = SortTargets(m_arrAbilities[m_iPreviousIndexForSecondaryMovement].AvailableTargets);
	}
}

/**
 * Configures the ability item sprites.
 *
 * Overridden to configure only the items of the current page and to
 * dynamically show/hide the corresponding scroll buttons.
 */
simulated function PopulateFlash()
{
	local int i, len, numActiveAbilities;
	local AvailableAction AvailableActionInfo; // Represents an action that a unit can perform, usually tied to an ability
	local XComGameState_Ability AbilityState;
	local X2AbilityTemplate AbilityTemplate;
	local UITacticalHUD_AbilityTooltip TooltipAbility;

	local UITacticalHUD_Ability item;
	local int iTmp;
		
	// Process the number of abilities, verify that it does not violate UI assumptions
	len = m_arrAbilities.Length;

	// Calculate start item index
	i = m_iCurrentPage * MaxAbilitiesPerPage;

	// Calculate end item index
	len -= i;
	if (len > MaxAbilitiesPerPage)
	{
		// Clamp number of items
		len = MaxAbilitiesPerPage;
	}
	len += i;
	
	numActiveAbilities = 0;
	while (i < len)
	{
		AvailableActionInfo = m_arrAbilities[i];

		AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(AvailableActionInfo.AbilityObjectRef.ObjectID));
		AbilityTemplate = AbilityState.GetMyTemplate();
		
		if (!AbilityTemplate.bCommanderAbility)
		{
			item = m_arrUIAbilities[numActiveAbilities];
			item.UpdateData(i, AvailableActionInfo);
			// Update hotkey label
			if (Movie.IsMouseActive())
			{
				iTmp = eTBC_Ability1 + numActiveAbilities;
				if (iTmp <= eTBC_Ability0)
				{
					item.SetHotkeyLabel(PC.Pres.m_kKeybindingData.GetPrimaryOrSecondaryKeyStringForAction(PC.PlayerInput, iTmp));
				}
				else
				{
					item.SetHotkeyLabel("");
				}
			}
			numActiveAbilities++;
		}
		i++;
	}
	
	mc.FunctionNum("SetNumActiveAbilities", numActiveAbilities);

	// Show/hide scroll buttons
	if (m_iCurrentPage > 0)
	{
		// Fade in left-hand scroll button
		LeftButton.Show();
		LeftButton.RemoveTweens();
		LeftButton.AddTweenBetween("_alpha", 0.0, 100.0, 0.1, FCeil(float(numActiveAbilities) / 2.0) * 0.05);
		// Left-align ability container
		mc.SetNum("fullWidth", 420.0);
		mc.FunctionVoid("realizeLocation");
	}
	else
	{
		// Hide scroll button
		LeftButton.Hide();
	}
	if (m_iCurrentPage < (m_iPageCount - 1))
	{
		// Fade in right-hand scroll button
		RightButton.Show();
		RightButton.RemoveTweens();
		RightButton.AddTweenBetween("_alpha", 0.0, 100.0, 0.1, 0.25);
	}
	else
	{
		// Hide scroll button
		RightButton.Hide();
	}

	Show();

	// Refresh the ability tooltip if it's open
	TooltipAbility = UITacticalHUD_AbilityTooltip(Movie.Pres.m_kTooltipMgr.GetChildByName('TooltipAbility', false));
	if ((TooltipAbility != none) && TooltipAbility.bIsVisible)
	{
		TooltipAbility.RefreshData();
	}
}

/**
 * LW : Used by the mouse hover tooltip to figure out which ability to get info from.
 * Overridden to hide tooltip when mousing over prev/next buttons.
 *
 * KDM : The LW description above is only partially true; within base XCom 2 GetAbilityAtIndex is called in 2 locations : 
 * [A] UITacticalHUD_AbilityTooltip.RefreshData, where it is used to help determine appropriate tooltip text.
 * [B] UITacticalHUD_AbilityContainer.GetCurrentSelectedAbility, where it helps get the ability state associated
 * with the currently selected ability; this information is then used in various calling functions.
 *
 * This has now been changed so that :
 * - UITacticalHUD_AbilityTooltip.RefreshData calls UITacticalHUD_AbilityContainer_LWExtended.GetAbilityAtIndex
 * - GetCurrentSelectedAbility has been overridden and calls UITacticalHUD_AbilityContainer.GetAbilityAtIndex
 *
 * For a thorough discussion on the issues present please see the comments above GetCurrentSelectedAbility
 * within this file.
 */
simulated function XComGameState_Ability GetAbilityAtIndex(int AbilityIndex)
{
	local UITacticalHUD_AbilityTooltip TooltipAbility;

	// KDM : If the AbilityIndex is greater than or equal to the maximum number of abilties on an 'ability page' 
	// then we are dealing with the 'previous page' or 'next page' button. How do we know this ?
	// The 'previous page' button and 'next page' button have an AbilityIndex equal to their flash path index; 
	// for example, the button _level0.theInterfaceMgr.UITacticalHUD_0.theTacticalHUD.AbilityContainerMC.UIButton_116.bg 
	// has an AbilityIndex of 116. Now, since these buttons are spawned after super.InitAbilityContainer is called, 
	// their flash path index will be greater than all conventional UITacticalHUD_AbilityContainer UI elements.
	// Consequently, if there is more than one ability page, these two buttons will have indices greater than or equal
	// to the maximum number of abilities on an 'ability page'; in fact, their indices will oftentimes be much larger.
	if (AbilityIndex < 0 || AbilityIndex >= MaxAbilitiesPerPage)
	{
		TooltipAbility = UITacticalHUD_AbilityTooltip(Movie.Pres.m_kTooltipMgr.GetChildByName('TooltipAbility', false));
		if (TooltipAbility != none)
		{
			TooltipAbility.Keybinding.SetHTMLText( "" );
			TooltipAbility.Actions.SetText( "" );
			TooltipAbility.EndTurn.SetText( "" );
			TooltipAbility.Cooldown.SetText( "" );
			TooltipAbility.Effect.SetText( "" );

			// LW : Can't hide because of interaction between Flash/TooltipMgr, so fill out with some help text instead
			TooltipAbility.Title.SetHTMLText(class'UIUtilities_Text'.static.StyleText(strChangePageTitle, eUITextStyle_Tooltip_Title));
			TooltipAbility.Desc.SetHTMLText( class'UIUtilities_Text'.static.StyleText(strChangePageDesc, eUITextStyle_Tooltip_Body) );

			TooltipAbility.RefreshSizeAndScroll();
		}
		return none;
	}

	// KDM : If we arrive here, we are dealing with an ability on the current 'ability page' which is NEITHER the
	// 'previous page' button nor the 'next page' button. Since LW2 uses a single row / multi-page ability system, 
	// we need to determine the abilities actual index.
	AbilityIndex += m_iCurrentPage * MaxAbilitiesPerPage;

	// KDM : Get the abilities associated ability state and return it.
	return super(UITacticalHUD_AbilityContainer).GetAbilityAtIndex(AbilityIndex);
}

/**
 * Callback method for clicking an ability item.
 *
 * Overridden to convert between view item index and model ability index.
 */
simulated function bool AbilityClicked(int index)
{
	index += m_iCurrentPage * MaxAbilitiesPerPage;
	return super.AbilityClicked(index);
}

/**
 * Callback method for triggering an ability via hotkey.
 *
 * Overridden to convert between view item index and model ability index.
 */
function DirectConfirmAbility(int index, optional bool ActivateViaHotKey)
{
	local int MaxIndex;

	// LW : Get the 'real' index of the ability, taking into account which ability page we are on.
	index += m_iCurrentPage * MaxAbilitiesPerPage;

	// XCom : For the tutorial, don't allow the user to bring up the HUD by clicking on it if the right trigger is disabled.
	if (`BATTLE.m_kDesc.m_bIsTutorial)
	{
		if (XComTacticalInput(XComTacticalController(PC).PlayerInput).ButtonIsDisabled(class'UIUtilities_Input'.const.FXS_BUTTON_RTRIGGER))
		{
			PlaySound( SoundCue'SoundUI.NegativeSelection2Cue', true , true);
			return;
		}
	}

	// KDM : Originally, DirectConfirmAbility would only perform an ability if it was a 'normal' ability, not 
	// a 'command' ability; mathematically, this was represented as : 
	// (index >= m_arrAbilities.Length - UITacticalHUD(screen).m_kMouseControls.CommandAbilities.Length).
	// 
	// This works well for mouse and keyboard users since it prevents them from hitting a number key on the 
	// keyboard and activating a 'command' ability which is not on the ability bar. Unfortunately, for controller users,
	// the 'command' ability 'Call Skyranger' routes through DirectConfirmAbility, and was being ignored.
	//
	// Since the reason for ignoring 'command' abilities was to prevent users from activating abilities accidentally
	// with number keys, something which controller users don't have to worry about, we can safely allow 'command'
	// abilities through when a controller is active.
	if (`ISCONTROLLERACTIVE)
	{
		MaxIndex = m_arrAbilities.Length;
	}
	else
	{
		MaxIndex = m_arrAbilities.Length - UITacticalHUD(screen).m_kMouseControls.CommandAbilities.Length;
	}

	// XCom : Check if it's in range, and bail if out of range 
	if (index >= MaxIndex)
	{
		Movie.Pres.PlayUISound(eSUISound_MenuClose); 
		return; 
	}

	if (m_iMouseTargetedAbilityIndex != index)
	{
		if (ActivateViaHotKey)
		{
			m_arrUIAbilities[m_iCurrentIndex].OnLoseFocus();
		}
		// XCom : Update the selection 
		m_iMouseTargetedAbilityIndex = index;
		if (ActivateViaHotKey)
		{
			if (!SelectAbility(m_iMouseTargetedAbilityIndex, ActivateViaHotKey))
			{
				UITacticalHUD(Owner).CancelTargetingAction();
				return;
			}
		}
		else
		{
			SelectAbility(m_iMouseTargetedAbilityIndex, ActivateViaHotKey);
		}
		Movie.Pres.PlayUISound(eSUISound_MenuSelect);
		if (ActivateViaHotKey)
		{
			Invoke("Deactivate");
			PopulateFlash();
		}
	}
	else
	{
		m_iSelectionOnButtonDown = index;
		OnAccept();
	}
}

/**
 * Hides the AOI indicator for the specified ability.
 * 
 * Overridden to convert between view item index and model ability index.
 */
simulated function HideAOE(int index)
{
	index += m_iCurrentPage * MaxAbilitiesPerPage;
	super.HideAOE(index);
}

/**
 * Displays the AOI indicator for the specified ability.
 * 
 * Overridden to convert between view item index and model ability index.
 */
simulated function ShowAOE(int Index)
{
	Index += m_iCurrentPage * MaxAbilitiesPerPage;
	super.ShowAOE(Index);
}

/**
 * Selects the specified ability.
 *
 * Overridden to update the current page index and item focus states.
 */
simulated function bool SelectAbility(int index, optional bool ActivateViaHotKey)
{
	local int prevIndex, prevPage;

	prevIndex = m_iCurrentIndex;
	prevPage = m_iCurrentPage;
	m_iCurrentPage = Max(0, Min(index / MaxAbilitiesPerPage, m_iPageCount - 1));

	if (super.SelectAbility(index, ActivateViaHotKey))
	{
		// Update focus state
		if (prevIndex != -1)
		{
			m_arrUIAbilities[prevIndex % MaxAbilitiesPerPage].OnLoseFocus();
		}
		if (m_iCurrentIndex != -1)
		{
			m_arrUIAbilities[m_iCurrentIndex % MaxAbilitiesPerPage].OnReceiveFocus();
		}
		return true;
	}

	// Revert page index
	m_iCurrentPage = prevPage;

	return false;
}

// KDM : Changes the ability page being looked at; if PreviousPage is true then look at the
// 'previous' ability page, else look at the 'next' ability page.
simulated function ChangeAbilityPage(bool PreviousPage, optional bool ResetMouse = false)
{
	local bool AbilityIsSelected;
	local int AbilityIndex, AbilityPage, MaxAbilityIndex;
	
	// KDM : There is only 1 ability page so we can't change pages.
	if (m_iPageCount == 1)
	{
		return;
	}

	AbilityIsSelected = (m_iCurrentIndex == -1) ? false : true;
	AbilityPage = m_iCurrentPage;
	
	if (PreviousPage)
	{
		AbilityPage -= 1;
		// KDM : If we are looking at the first ability page, then loop around to the last ability page.
		if (AbilityPage < 0)
		{
			AbilityPage = m_iPageCount - 1;
			AbilityIndex = ((m_iPageCount - 1) * MaxAbilitiesPerPage) + (m_iCurrentIndex % MaxAbilitiesPerPage);
		}
		else
		{
			AbilityIndex = m_iCurrentIndex - MaxAbilitiesPerPage;
		}
	}
	else
	{
		AbilityPage += 1;
		// LW + KDM : If we are looking at the last ability page, then loop around to the first ability page.
		if (AbilityPage >= m_iPageCount)
		{
			AbilityPage = 0;
			AbilityIndex = m_iCurrentIndex % MaxAbilitiesPerPage;
		} 
		else
		{				
			AbilityIndex = m_iCurrentIndex + MaxAbilitiesPerPage;
		}
	}

	// KDM : If an ability was selected before the 'page change', make sure a suitable ability is 
	// selected after the 'page change'. If an ability was not selected before the 'page change' then 
	// we have no interest in ability selection; we will simply change the page and be done.
	if (AbilityIsSelected)
	{
		// LW : Clamp the ability index; since 'command' abilities are always placed at the end of m_arrAbilities,
		// due to UITacticalHUD_AbilityContainer.SortAbilities, this guarantees we won't select a 'command'
		// ability.
		MaxAbilityIndex = m_arrAbilities.Length - UITacticalHUD(screen).m_kMouseControls.CommandAbilities.Length;
		
		if (AbilityIndex >= MaxAbilityIndex)
		{
			AbilityIndex = MaxAbilityIndex - 1;
			// KDM : AbilityIndex just changed; therefore, make sure AbilityPage is up-to-date.
			AbilityPage = AbilityIndex / MaxAbilitiesPerPage;
		}

		if (ResetMouse)
		{
			self.ResetMouse();
		}
		// LW : Shot HUD is visible; therefore, change ability selection.
		self.SelectAbility(AbilityIndex);
	}
	else
	{
		// LW : Refresh ability items without selecting.
		m_iCurrentPage = AbilityPage;
		self.PopulateFlash();
	}
}

// KDM : CycleAbilitySelection has been modified to interact properly with LW2's 'single row' ability bar.
// Previously, this function relied upon MAX_NUM_ABILITIES_PER_ROW_BAR to determine the number of abilites
// per row; however, LW2 makes use of MaxAbilitiesPerPage to determine the number of abilities per page.
simulated function CycleAbilitySelection(int Step)
{
	local int AbilityIndex, FirstIndexOfPage, LastIndexOfPage;
	local int Counter;

	// XCom : Ignore if index was never set (e.g. nothing was populated.).
	if (m_iCurrentIndex == -1)
	{
		return;
	}

	Counter = 0;
	AbilityIndex = m_iCurrentIndex;

	FirstIndexOfPage = (AbilityIndex / MaxAbilitiesPerPage) * MaxAbilitiesPerPage;
	LastIndexOfPage = FirstIndexOfPage + (MaxAbilitiesPerPage - 1);
	if (LastIndexOfPage >= m_arrAbilities.Length)
	{
		LastIndexOfPage = m_arrAbilities.Length - 1;
	}

	do
	{
		// KDM : If we are cycling to the left then Step is -1; if we are cycling to the right then Step is 1.
		AbilityIndex += Step;

		// KDM : If we are cycling leftwards, loop from the front of the ability page to the end if necessary.
		if (AbilityIndex < FirstIndexOfPage)
		{
			AbilityIndex = LastIndexOfPage;
		}
		// KDM : If we are cycling rightwards, loop from the end of the ability page to the front if necessary.
		else if (AbilityIndex > LastIndexOfPage)
		{
			AbilityIndex = FirstIndexOfPage;
		}

		// KDM : This is a fail-safe which was never implemented in base XCom 2 code, and should never occur.
		// Nonetheless, it will prevent a hang if, somehow, a command ability erroneously finds its way onto an 
		// ability page with no 'normal' abilities.
		Counter++;
		if (Counter > MaxAbilitiesPerPage)
		{
			`log("KDM ERROR : UITacticalHUD_AbilityContainer_LWExtended.CycleAbilitySelection found no valid ability.");
			return;
		}
	}
	// KDM : Guarantee that the index doesn't correspond to a commander ability.
	until (!IsCommmanderAbility(AbilityIndex));

	ResetMouse();
	SelectAbility(AbilityIndex);
}

// KDM : CycleAbilitySelectionRow has been modified to interact properly with LW2's 'single row' ability bar.
// Cycling to the previous ability row is now equivalent to cycling to the previous ability page.
// Cycling to the next ability row is now equivalent to cycling to the next ability page.
simulated function CycleAbilitySelectionRow(int Step)
{
	// XCom : Ignore if index was never set (e.g. nothing was populated.).
	if (m_iCurrentIndex == -1)
	{
		return;
	}

	// KDM : If we are cycling to the previous ability page, step = -1;
	if (Step == -1)
	{
		ChangeAbilityPage(true, true);
	}
	// KDM : If we are cycling to the next ability page, step = 1;
	else if (Step == 1)
	{
		ChangeAbilityPage(false, true);
	}
}

simulated function NotifyCanceled()
{
	ResetMouse();
	// XCom : Clears out any message when canceling the mode.
	UpdateHelpMessage("");
	// XCom : Animate back to top corner. Handle this here instead of in "clear", so that we prevent 
	// unwanted animations when staying in show mode.
	Invoke("Deactivate");  
	
	if (TargetingMethod != none)
	{
		TargetingMethod.Canceled();
		TargetingMethod = none;
	}

	if (m_iCurrentIndex != -1)
	{
		// KDM : LW2 modified the usage of m_arrUIAbilities; rather than storing a UI element for each ability,
		// it only stores a UI element for each ability 'on the currently selected ability page'. Consequently,
		// the index into m_arrUIAbilities had to be modified, in order for focus to be lost on any ability which
		// was not on the first ability page. 
		m_arrUIAbilities[m_iCurrentIndex % MaxAbilitiesPerPage].OnLoseFocus();
	}

	// XCom : Force a show refresh, since the menu is canceling out.
	RefreshTutorialShine(true); 
	
	m_iCurrentIndex = -1;

	if (`ISCONTROLLERACTIVE)
	{
		// KDM : When we cancel out of ability selection make sure that we go back to the
		// first ability page.
		m_iCurrentPage = 0;
	}
}

// KDM : After nearly a full day of research I have discovered that LW2 modified GetAbilityAtIndex in a
// 'PROBLEMATIC' way. 
// 
// First off, UITacticalHUD_AbilityContainer.GetAbilityAtIndex is called in 2 locations : 
// [A] UITacticalHUD_AbilityTooltip.RefreshData [B] UITacticalHUD_AbilityContainer.GetCurrentSelectedAbility. 
//
// [A] UITacticalHUD_AbilityTooltip.RefreshData is concerned with updating the ability tooltip for the 
// the ability currently hovered over by the mouse; consequently, it sends GetAbilityAtIndex a
// parameter ranging from 0 to the number of abilities visible on the ability bar minus 1.
// [B] UITacticalHUD_AbilityContainer.GetCurrentSelectedAbility is concerned with retrieving the 
// ability game state corresponding to the ability index sent into it; therefore, it sends GetAbilityAtIndex a
// parameter ranging from 0 to the total number of abilities minus 1.
//
// LW2 modified GetAbilityAtIndex in the following way :
// 1.] GetAbilityAtIndex now expected a parameter value to be between 0 and the number of abilities visible on the 
// ability bar minus 1, (MaxAbilitiesPerPage - 1). 
// 1A.] If this was the case, it determined the abilities 'true' index by adding (m_iCurrentPage * MaxAbilitiesPerPage)
// to the parameter value, and then ultimately got and returned the ability's associated game state.
// 1B.] If this was not the case, it : assumed we were dealing with with one of the page scrolling buttons, set
// some tooltip text, then returned 'none'. This was a problem, since UITacticalHUD_AbilityContainer.GetCurrentSelectedAbility 
// could send in a perfectly valid parameter greater than (MaxAbilitiesPerPage - 1) and less than (m_arrAbilities.Length - 1); 
// yet, it would receive 'none' rather than a valid ability game state.
// 
// The issue I noticed, related to 1B, was that the enemy head icons, representing enemy targets, would never update 
// when looking at an ability page greater than 1. Ultimately, after much research, I discovered that 
// UITacticalHUD_Enemies.UpdateVisibleEnemies calls UITacticalHUD_AbilityContainer.GetCurrentSelectedAbility
// and expects an ability game state. Instead, it can receive 'none', never fill out its target array, and never
// update its visuals properly.
//
// THE SOLUTION : 
// 1.] Allow UITacticalHUD_AbilityTooltip.RefreshData to continue calling the LW2 variant of GetAbilityAtIndex
// since it sends in a parameter whose value is between 0 and (MaxAbilitiesPerPage - 1). If the parameter is out of
// this range then we are dealing with the 'previous page' button or 'next page' button, and the situation is
// dealt with accordingly.
// 2.] Override GetCurrentSelectedAbility so it calls UITacticalHUD_AbilityContainer.GetAbilityAtIndex, a function 
// which can accept a parameter value between 0 and (m_arrAbilities.Length - 1) without issue. It is important to note
// that GetCurrentSelectedAbility is unconcerned with the 'previous page' button and the 'next page' button since these 
// buttons are only activated via OnScrollButtonClicked. Consequently, it can safely skip page button related code.
simulated function XComGameState_Ability GetCurrentSelectedAbility()
{ 
	if (m_iCurrentIndex == -1)
	{
		return none;
	}
	else
	{
		return super(UITacticalHUD_AbilityContainer).GetAbilityAtIndex(m_iCurrentIndex);
	}
}

simulated public function bool OnAccept (optional string strOption = "")
{
	local int CurrentIndex;
	
	CurrentIndex = m_iCurrentIndex;
	
	if (ConfirmAbility())
	{
		// KDM : Only remove focus on an ability if it went through; if this is not done,
		// selecting an inactive ability will remove its focus even though it is still focused.
		// Additionally, since LW2 uses a 'single row' ability bar we need to index into m_arrUIAbilities
		// with (CurrentIndex % MaxAbilitiesPerPage) rather than simply CurrentIndex.
		m_arrUIAbilities[CurrentIndex % MaxAbilitiesPerPage].OnLoseFocus();
		return true;
	}
	
	return false;
}

simulated function bool OnUnrealCommand(int ucmd, int arg)
{
	// XCom : Only allow releases through.
	if ((arg & class'UIUtilities_Input'.const.FXS_ACTION_RELEASE) == 0)
	{
		return false;
	}

	if (!CanAcceptAbilityInput())
	{
		return false;
	}

	// LW : X key cycles through ability pages for mouse and keyboard users.
	// KDM : The X button no longer cycles through ability pages since controller users
	// must raise the ability menu before choosing any abilities. Now DPad Up/Down cycles
	// between ability pages once the ability menu has been raised.
	switch (ucmd)
	{
	case (class'UIUtilities_Input'.const.FXS_KEY_X):
		// KDM : Show the 'next' ability page.
		ChangeAbilityPage(false);
		return true;
	}

	return super.OnUnrealCommand(ucmd, arg);
}

// ===========================================================================
//  DEFAULTS:
// ===========================================================================

defaultproperties
{
	m_iCurrentPage = 0;
	m_iPageCount = 1;
}
