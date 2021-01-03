class NPSBDP_UIArmory_PromotionHeroColumn extends UIArmory_PromotionHeroColumn;

var int Offset;
var UIText RankLabelLine1, RankLabelLine2;

function UIArmory_PromotionHeroColumn InitPromotionHeroColumn(int InitRank)
{
	super.InitPromotionHeroColumn(InitRank);

	// KDM : Create the UIText's which will display the rank labels.
	RankLabelLine1 = Spawn(class'UIText', self);
	RankLabelLine1.InitText('RankLabelLine1', "");
	RankLabelLine2 = Spawn(class'UIText', self);
	RankLabelLine2.InitText('RankLabelLine2', "");

	UpdateSizeAndPosition();

	return self;
}

function UpdateSizeAndPosition()
{
	// KDM : The rank icon.
	MC.ChildSetNum("rankMC", "_x", 41);
	MC.ChildSetNum("rankMC", "_y", -8);

	// KDM : The 'rank up' highlight.
	MC.ChildSetNum("rankHighlight", "_x", 0);
	MC.ChildSetNum("rankHighlight", "_y", -31);

	// KDM : Rank label line 1.
	RankLabelLine1.SetPosition(2, 52);
	RankLabelLine1.SetWidth(145);

	// KDM : Rank label line 2.
	RankLabelLine2.SetPosition(2, 78);
	RankLabelLine2.SetWidth(145);
}

function AS_SetData(bool ShowHighlight, string HighlightText, string RankIcon, string RankLabel)
{
	MC.BeginFunctionOp("SetData");
	MC.QueueBoolean(ShowHighlight);
	MC.QueueString(HighlightText);
	MC.QueueString(RankIcon);
	// KDM : We no longer want to set rankLabel, within Flash, since we will be dealing with
	// multi-line rank labels by ourself.
	MC.QueueString("");
	MC.EndOp();

	SetRankLabel(RankLabel);
}

function SetRankLabel(string RankLabel)
{
	local int i;
	local string ConcatenatedString;
	local array<string> RankLabelComponents;
	
	RankLabelComponents = SplitString(RankLabel, " ", true);
	if (RankLabelComponents.Length >= 1)
	{
		RankLabelLine1.SetHtmlText(class'UIUtilities_Text'.static.GetColoredText(
			RankLabelComponents[0], eUIState_Normal, 24, "CENTER"));

		i = 1;
		ConcatenatedString = "";
		// KDM : Normally, a rank label will consist of 1 or 2 words; if it consists of more, any word after
		// the 1st will be concatenated with spaces and placed in RankLabelLine2.
		while (i < RankLabelComponents.Length)
		{
			ConcatenatedString $= RankLabelComponents[i];
			if (i + 1 < RankLabelComponents.Length)
			{
				ConcatenatedString $= " ";
			}
			i++;
		}
		RankLabelLine2.SetHtmlText(class'UIUtilities_Text'.static.GetColoredText(
			ConcatenatedString, eUIState_Normal, 24, "CENTER"));
	}
}

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

