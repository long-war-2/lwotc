class NPSBDP_UIArmory_PromotionHeroColumn extends UIArmory_PromotionHeroColumn;

var int Offset;

function OnAbilityInfoClicked(UIButton Button)
{
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityTemplateManager AbilityTemplateManager;
	local UIButton InfoButton;
	local NPSBDP_UIArmory_PromotionHero PromotionScreen;
	local int idx;

	PromotionScreen = NPSBDP_UIArmory_PromotionHero(Screen);

	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	
	foreach InfoButtons(InfoButton, idx)
	{
		if (InfoButton == Button)
		{
			AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(AbilityNames[idx]);
			break;
		}
	}
	
	if (AbilityTemplate != none)
		`HQPRES.UIAbilityPopup(AbilityTemplate, PromotionScreen.UnitReference);

	if( InfoButton != none )
		InfoButton.Hide();
}

function OnAbilityIconMouseEvent(UIPanel Panel, int Cmd)
{
	local UIIcon AbilityIcon;
	local bool bHandled;
	local int idx;

	foreach AbilityIcons(AbilityIcon, idx)
	{
		if (Panel == AbilityIcon)
		{
			if (cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_UP)
			{
				SelectAbility(idx);
			}
			else if (cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_IN)
			{
				OnReceiveFocus();
				AbilityIcon.OnReceiveFocus();
				RealizeAvailableState(idx);

				PreviewAbility(idx);

				if (!UIArmory_PromotionHero(Screen).IsAbilityLocked(Rank) || UIArmory_PromotionHero(Screen).RevealAllAbilities)
				{
					InfoButtons[idx].Show();
				}
				ClearTimer('Hide', InfoButtons[idx]);
			}
			else if (cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT || cmd == class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OUT)
			{
				AbilityIcon.OnLoseFocus();
				RealizeAvailableState(idx);

				HideAbilityPreview();
				SetTimer(0.01, false, 'Hide', InfoButtons[idx]);
			}

			bHandled = true;
			break;
		}
	}

	if (bHandled)
		RealizeVisuals();
}

function SelectAbility(int idx)
{
	local UIArmory_PromotionHero PromotionScreen;
	
	PromotionScreen = UIArmory_PromotionHero(Screen);

	if( PromotionScreen.OwnsAbility(AbilityNames[idx]) )
		OnInfoButtonMouseEvent(InfoButtons[idx], class'UIUtilities_Input'.const.FXS_L_MOUSE_UP);
	else if (bEligibleForPurchase && PromotionScreen.CanPurchaseAbility(Rank, idx + Offset, AbilityNames[idx]))
		PromotionScreen.ConfirmAbilitySelection(Rank, idx);
	else if (!PromotionScreen.IsAbilityLocked(Rank))
		OnInfoButtonMouseEvent(InfoButtons[idx], class'UIUtilities_Input'.const.FXS_L_MOUSE_UP);
	else
		Movie.Pres.PlayUISound(eSUISound_MenuClickNegative);
}

// Override to handle Scrolling
simulated function SelectNextIcon()
{
	local int newIndex;
	newIndex = m_iPanelIndex; //Establish a baseline so we can loop correctly

	do
	{
		newIndex += 1;
		if( newIndex >= AbilityIcons.Length )
		{
			if (AttemptScroll(false))
			{
				// The screen has scrolled for us, we don't need to wrap around for now
				newIndex--;
			}
			else
			{
				// Wrap around
				newIndex = 0;
			}
		}
	} until( AbilityIcons[newIndex].bIsVisible);
	
	UnfocusIcon(m_iPanelIndex);
	m_iPanelIndex = newIndex;
	FocusIcon(m_iPanelIndex);
	Movie.Pres.PlayUISound(eSUISound_MenuSelect); //bsg-crobinson (5.11.17): Add sound
}

simulated function SelectPrevIcon()
{
	local int newIndex;
	newIndex = m_iPanelIndex; //Establish a baseline so we can loop correctly

	do
	{
		newIndex -= 1;
		if( newIndex < 0 )
		{
			if (AttemptScroll(true))
			{
				// The screen has scrolled for us, we don't need to wrap around for now
				newIndex++;
			}
			else
			{
				// Wrap around
				newIndex = AbilityIcons.Length - 1;
			}
		}
	} until( AbilityIcons[newIndex].bIsVisible);
	
	UnfocusIcon(m_iPanelIndex);
	m_iPanelIndex = newIndex;
	FocusIcon(m_iPanelIndex);
	Movie.Pres.PlayUISound(eSUISound_MenuSelect); //bsg-crobinson (5.11.17): Add sound
}


// Instruct the Screen to Scroll the selection.
// Returns false if the column needs to wrap around, true else
// I.e. if we have <= 4 rows, this will always return false
simulated function bool AttemptScroll(bool Up)
{
	return NPSBDP_UIArmory_PromotionHero(Screen).AttemptScroll(Up);
}
