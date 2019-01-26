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
	local int page, index, max;

	page = m_iCurrentPage;
	index = m_iCurrentIndex;

	// Determine which button was clicked
	if (Button == LeftButton)
	{
		// Decrement page and ability indexes
		page -= 1;
		index -= MaxAbilitiesPerPage;
	}
	else if (Button == RightButton)
	{
		// Increment page and ability indexes
		page += 1;
		index += MaxAbilitiesPerPage;
		// Clamp ability index to not exceed total number of abilities and to not target a command ability
		max = m_arrAbilities.Length - UITacticalHUD(screen).m_kMouseControls.CommandAbilities.Length;
		if (index >= max)
		{
			index = max - 1;
		}
	}

	if (m_iCurrentIndex != -1)
	{
		// Shot HUD is visible, change ability selection
		self.SelectAbility(index);
	}
	else
	{
		// Refresh ability items without selecting
		m_iCurrentPage = page;
		self.PopulateFlash();
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
	// WOTC:
	local XComGameStateHistory History;
	local XComGameState_Ability AbilityState;
	local XComGameState_Unit Unit;
	// END WOTC

	local AvailableAction AbilityAvailableInfo; //Represents an action that a unit can perform. Usually tied to an ability.

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

	// WOTC debugging:
	History = Ruleset.CachedHistory;
	Unit = XComGameState_Unit(History.GetGameStateForObjectID(UnitInfoCache.UnitObjectRef.ObjectID));
	if (Unit.FindComponentObject(class'XComGameState_Unit_LWOfficer') != none)
	{
		`Log("Updating abilities for officer " $ Unit.GetName(eNameType_Full));
	}
	// END


	len = UnitInfoCache.AvailableActions.Length;
	for (i = 0; i < len; i++)
	{	
		// Obtain unit's ability
		AbilityAvailableInfo = UnitInfoCache.AvailableActions[i];

		// WOTC:
		AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(AbilityAvailableInfo.AbilityObjectRef.ObjectID));
		if (AbilityState != none)
		{
			`Log("Should we show ability icon for " $ AbilityState.GetMyTemplateName() $ " (" $ AbilityState.GetMyIconImage() $ ")?");
		}

		if (ShouldShowAbilityIcon(AbilityAvailableInfo, bCommanderAbility))
		{
			`Log("    Yes!!!");
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

	UITacticalHUD(screen).m_kShotInfoWings.Show();
	UITacticalHUD(screen).m_kMouseControls.SetCommandAbilities(arrCommandAbilities);
	UITacticalHUD(screen).m_kMouseControls.UpdateControls();

	//  jbouscher: I am 99% certain this call is entirely redundant, so commenting it out
	//kUnit.UpdateUnitBuffs();

	// If we're in shot mode, then set the current ability index based on what (if anything) was populated
	if (UITacticalHUD(screen).IsMenuRaised() && (m_arrAbilities.Length > 0))
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

		// WOTC:
		if (AbilityState != none)
		{
			`Log("Should we show ability icon for " $ AbilityState.GetMyTemplateName() $ " (" $ AbilityTemplate.AbilityIconColor $ ")?");
		}

		if (!AbilityTemplate.bCommanderAbility)
		{
			`Log("    Yes! (It's not a command ability)");
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
 * Used by the mouse hover tooltip to figure out which ability to get info from.
 *
 * Overridden to hide tooltip when mousing over prev/next buttons.
 */
simulated function XComGameState_Ability GetAbilityAtIndex( int AbilityIndex )
{
	local AvailableAction       AvailableActionInfo;
	local XComGameState_Ability AbilityState;
	local UITacticalHUD_AbilityTooltip TooltipAbility;

	if( AbilityIndex < 0 || AbilityIndex >= MaxAbilitiesPerPage) // m_arrAbilities.Length )
	{
		TooltipAbility = UITacticalHUD_AbilityTooltip(Movie.Pres.m_kTooltipMgr.GetChildByName('TooltipAbility', false));
		if (TooltipAbility != none)
		{
			TooltipAbility.Keybinding.SetHTMLText( "" );
			TooltipAbility.Actions.SetText( "" );
			TooltipAbility.EndTurn.SetText( "" );
			TooltipAbility.Cooldown.SetText( "" );
			TooltipAbility.Effect.SetText( "" );

			//can't hide because of interaction between Flash/TooltipMgr, so fill out with some help text instead
			TooltipAbility.Title.SetHTMLText(class'UIUtilities_Text'.static.StyleText(strChangePageTitle, eUITextStyle_Tooltip_Title));
			TooltipAbility.Desc.SetHTMLText( class'UIUtilities_Text'.static.StyleText(strChangePageDesc, eUITextStyle_Tooltip_Body) );

			TooltipAbility.RefreshSizeAndScroll();
		}
		return none;
	}

	AbilityIndex += m_iCurrentPage * MaxAbilitiesPerPage;
	if (AbilityIndex < 0 || AbilityIndex >= m_arrAbilities.Length)
	{
		`redscreen("Attempt to get ability with illegal index: '" $ AbilityIndex $ "', numAbilities: '" $ m_arrAbilities.Length $ "'.");
		return none;
	}
	AvailableActionInfo = m_arrAbilities[AbilityIndex];
	AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(AvailableActionInfo.AbilityObjectRef.ObjectID));
	`assert(AbilityState != none);
	return AbilityState; 
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
	index += m_iCurrentPage * MaxAbilitiesPerPage;
	super.DirectConfirmAbility(index, ActivateViaHotKey);
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

// override to remap X key to cycle through ability pages
simulated function bool OnUnrealCommand(int ucmd, int arg)
{
	local int page, index, max;

	// Only allow releases through.
	if ( ( arg & class'UIUtilities_Input'.const.FXS_ACTION_RELEASE) == 0 )
		return false;

	if( !CanAcceptAbilityInput() )
	{
		return false;
	}

	//intercept the X key here
	switch(ucmd)
	{
		case (class'UIUtilities_Input'.const.FXS_BUTTON_X):
		case (class'UIUtilities_Input'.const.FXS_KEY_X):
			page = m_iCurrentPage;
			index = m_iCurrentIndex;

			// Increment page and ability indexes
			page += 1;
			if(page >= m_iPageCount)
			{
				page = 0;
				index = m_iCurrentIndex % MaxAbilitiesPerPage;
			} else {				
				index += MaxAbilitiesPerPage;
			}
			// Clamp ability index to not exceed total number of abilities and to not target a command ability
			max = m_arrAbilities.Length - UITacticalHUD(screen).m_kMouseControls.CommandAbilities.Length;
			if (index >= max)
			{
				index = max - 1;
			}
			if (m_iCurrentIndex != -1)
			{
				// Shot HUD is visible, change ability selection
				self.SelectAbility(index);
			}
			else
			{
				// Refresh ability items without selecting
				m_iCurrentPage = page;
				self.PopulateFlash();
			}
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