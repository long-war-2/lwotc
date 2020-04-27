//---------------------------------------------------------------------------------------
//	FILE:    UIOutpostManagement_ListItem
//	AUTHOR:  tracktwo / Pavonis Interactive
//	PURPOSE: List Item (one row) for UIOutpostManagement
//---------------------------------------------------------------------------------------

class UIOutpostManagement_ListItem extends UIPanel
	config(LW_UI);

const ABILITY_ICON_X=148;
const ABILITY_ICON_Y=32;
const ABILITY_ICON_GAP=30;

var config bool FONT_SIZE_2D_3D_SAME_MK;
var config int LEVEL_ICON_OFFSET_MK, LEVEL_ICON_SIZE_MK, LIST_ITEM_FONT_SIZE_MK, LIST_ITEM_FONT_SIZE_FANCY_MK;
var config int LEVEL_ICON_OFFSET_CTRL, LEVEL_ICON_SIZE_CTRL, LIST_ITEM_FONT_SIZE_CTRL, LIST_ITEM_FONT_SIZE_FANCY_CTRL;

var bool USE_FANCY_VERSION;
var int TheFontSize;

var StateObjectReference OutpostRef;
var StateObjectReference RebelRef;
var int Index;

var UIButton ButtonBG;
var UIImage MugShot;
var UIText NameLabel;
var UIText LevelLabel, LevelLabel2;
var UIList List;
var array<UIIcon> AbilityIcons;
var UIOutpostManagement OutpostUI;
var int JobHeaderX;
var int JobHeaderWidth;
var UIImage LeftButton;
var UIImage RightButton;
var UIText SpinnerLabel;

simulated function BuildItem()
{
	local int ArrowSize, BorderPadding, LevelIconOffset, MugShotSize, RebelLevel;

	List = UIList(GetParent(class'UIList'));
	OutpostUI = UIOutpostManagement(Screen);
	USE_FANCY_VERSION = UIOutpostManagement(Screen).USE_FANCY_VERSION;

	// KDM : Get the font size for the rebel name and rebel job; this depends upon 2 factors :
	// [1] Input method - controller vs. mouse & keyboard [2] UI mode - normal vs. fancy
	if (`ISCONTROLLERACTIVE)
	{
		TheFontSize = (USE_FANCY_VERSION) ? LIST_ITEM_FONT_SIZE_FANCY_CTRL : LIST_ITEM_FONT_SIZE_CTRL;
	}
	else
	{
		// KDM : The font size for the rebel name and job is larger if viewed on a 3D screen like the Avenger.
		// This is ignored, however, if FONT_SIZE_2D_3D_SAME_MK is true.
		if (class'Utilities_LW'.static.IsOnStrategyMap())
		{
			TheFontSize = (USE_FANCY_VERSION) ? LIST_ITEM_FONT_SIZE_FANCY_MK : LIST_ITEM_FONT_SIZE_MK;
		}
		else
		{
			if (USE_FANCY_VERSION)
			{
				TheFontSize = (FONT_SIZE_2D_3D_SAME_MK) ? LIST_ITEM_FONT_SIZE_FANCY_MK : LIST_ITEM_FONT_SIZE_FANCY_MK + 4;
			}
			else
			{
				TheFontSize = (FONT_SIZE_2D_3D_SAME_MK) ? LIST_ITEM_FONT_SIZE_MK : LIST_ITEM_FONT_SIZE_MK + 4;
			}
		}
	}

	Width = List.Width;

	ArrowSize = 24;
	BorderPadding = 10;
	MugShotSize = 64;
	RebelLevel = OutpostUI.CachedRebels[List.GetItemIndex(self)].Level;

	// KDM : Background button which highlights when focused; this is only needed when using a controller.
	if (`ISCONTROLLERACTIVE)
	{
		ButtonBG = Spawn(class'UIButton', self);
		ButtonBG.bIsNavigable = false;
		ButtonBG.InitButton(, , , eUIButtonStyle_NONE);
		ButtonBG.SetResizeToText(false);
		ButtonBG.SetPosition(OutpostUI.JobHeaderButton.X, 0);
		ButtonBG.SetSize(OutpostUI.JobHeaderButton.Width, Height);
	}

	// KDM : Rebel photo
	MugShot = Spawn(class'UIImage', self);
	MugShot.InitImage();
	MugShot.SetPosition(OutpostUI.NameHeaderButton.X + BorderPadding, 3);
	MugShot.SetSize(MugShotSize, MugShotSize);

	// KDM : Rebel name
	NameLabel = Spawn(class'UIText', self);
	NameLabel.InitText();
	if (USE_FANCY_VERSION)
	{
		NameLabel.SetPosition(MugShot.X + MugShotSize + 27, 18);
	}
	else
	{
		NameLabel.SetPosition(MugShot.X + MugShotSize + 6, 3);
	}

	// KDM : Icons representing rebel level; basically you will see 0, 1, or 2 stars.
	LevelLabel = Spawn(class'UIText', self);
	LevelLabel.InitText();

	if (`ISCONTROLLERACTIVE)
	{
		LevelIconOffset = LEVEL_ICON_OFFSET_CTRL;
	}
	else
	{
		LevelIconOffset = LEVEL_ICON_OFFSET_MK;
	}

	if (USE_FANCY_VERSION)
	{
		// KDM : When using the fancy UI, rank 2 rebels have their level icons placed on top of each other.
		if (RebelLevel == 2)
		{
			LevelLabel.SetPosition(MugShot.X + MugShotSize - 1, 11 - LevelIconOffset);

			LevelLabel2 = Spawn(class'UIText', self);
			LevelLabel2.InitText();
			LevelLabel2.SetPosition(MugShot.X + MugShotSize - 1, 35 - LevelIconOffset);
		}
		else
		{
			LevelLabel.SetPosition(MugShot.X + MugShotSize - 1, 21 - LevelIconOffset);
		}
	}
	else
	{
		LevelLabel.SetPosition(MugShot.X + MugShotSize + 6, 36 - LevelIconOffset);
	}

	// KDM : Arrows are only displayed when using a mouse & keyboard; controllers use the D-Pad instead.
	if (!`ISCONTROLLERACTIVE)
	{
		// KDM : Left arrow
		LeftButton = Spawn(class'UIImage', self);
		LeftButton.InitImage(,"img:///gfxComponents.PC_arrowLEFT", OnClick);
		LeftButton.SetPosition(OutpostUI.JobHeaderButton.X + BorderPadding, ((Height - ArrowSize) / 2) - 1);
		LeftButton.SetSize(ArrowSize, ArrowSize);

		// KDM : Right arrow
		RightButton = Spawn(class'UIImage', self);
		RightButton.InitImage(,"img:///gfxComponents.PC_arrowRIGHT", OnClick);
		RightButton.SetPosition(OutpostUI.JobHeaderButton.X + OutpostUI.JobHeaderButton.Width - ArrowSize - BorderPadding,
			((Height - ArrowSize) / 2) - 1);
		RightButton.SetSize(ArrowSize, ArrowSize);
	}

	// KDM : Rebel job
	SpinnerLabel = Spawn(class'UIText', self);
	SpinnerLabel.InitText();
	if (USE_FANCY_VERSION)
	{
		SpinnerLabel.SetPosition(OutpostUI.JobHeaderButton.X + BorderPadding, (Height / 2) - 18);
	}
	else
	{
		SpinnerLabel.SetPosition(OutpostUI.JobHeaderButton.X + BorderPadding, (Height / 2) - 16);
	}
	SpinnerLabel.SetWidth(OutpostUI.JobHeaderButton.Width - BorderPadding * 2);
}

simulated function UIOutpostManagement_ListItem InitListItem()
{
	InitPanel();
	BuildItem();

	// KDM : Static data only needs to be set once, when the list item is first created.
	UpdateStaticData();
	// KDM : Dynamic data needs to be updated when the list item : [1] is first created [2] receives focus [3] loses focus.
	// For example, a rebel's job text is considered dynamic because it is blue when the rebel is unselected, and black when selected.
	UpdateDynamicData(bIsFocused);

	return self;
}

simulated function UpdateStaticData()
{
	local int ListItemIndex, RebelLevel, LevelIconSize;
	local string strRebelName, strRebelLevel;
	local XComGameState_Unit Unit;
	local XComGameStateHistory History;

	ListItemIndex = List.GetItemIndex(self);

	if (`ISCONTROLLERACTIVE)
	{
		LevelIconSize = LEVEL_ICON_SIZE_CTRL;
	}
	else
	{
		LevelIconSize = LEVEL_ICON_SIZE_MK;
	}

	History = `XCOMHISTORY;

	Unit = XComGameState_Unit(History.GetGameStateForObjectID(OutpostUI.CachedRebels[ListItemIndex].Unit.ObjectID));

	// KDM : Rebel photo
	SetMugShot(Unit.GetReference());

	// KDM : Rebel name
	if (OutpostUI.ShowFaceless && OutpostUI.CachedRebels[ListItemIndex].IsFaceless)
	{
		strRebelName = "* " $ Unit.GetFullName();
	}
	else
	{
		strRebelName = Unit.GetFullName();
	}
	NameLabel.SetHTMLText(class'UIUtilities_Text'.static.GetColoredText(strRebelName, eUIState_Normal, TheFontSize));

	// KDM : Rebel level icons
	RebelLevel = OutpostUI.CachedRebels[ListItemIndex].Level;
	if (USE_FANCY_VERSION)
	{
		strRebelLevel = class'UIUtilities_Text'.static.InjectImage(class'UIUtilities_Image'.const.HTML_ObjectiveIcon, LevelIconSize, LevelIconSize, 0);
		if (RebelLevel == 2)
		{
			LevelLabel.SetHtmlText(strRebelLevel);
			LevelLabel2.SetHtmlText(strRebelLevel);
		}
		else if (RebelLevel == 1)
		{
			LevelLabel.SetHtmlText(strRebelLevel);
		}
	}
	else
	{
		while (RebelLevel > 0)
		{
			strRebelLevel = strRebelLevel $ class'UIUtilities_Text'.static.InjectImage(class'UIUtilities_Image'.const.HTML_ObjectiveIcon, LevelIconSize, LevelIconSize, 0);
			--RebelLevel;
		}
		LevelLabel.SetHtmlText(strRebelLevel);
	}

	// KDM : Rebel abilities
	AbilityIcons.length = 0;
	AddAbilityIcons(Unit, self);
}

simulated function AddAbilityIcons(XComGameState_Unit Unit, UIOutpostManagement_ListItem ListItem)
{
	local int i, DisplayedIcons, IconX, IconY, IconPadding, IconSize, StartX, TotalLength;
	local UIIcon AbilityIcon;
	local array<SoldierClassAbilityType> Abilities;
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityTemplateManager AbilityTemplateManager;

	DisplayedIcons = 0;

	// KDM : When using the fancy UI, ability buttons are centered within the perks column; therefore,
	// we can't position them until we know how many perks are going to be visible.
	if (USE_FANCY_VERSION)
	{
		IconSize = 32;
		IconPadding = 3;
	}
	else
	{
		IconSize = 24;
		IconPadding = 3;
		IconX = 148;
		IconY = 37;
	}

	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	Abilities = Unit.GetEarnedSoldierAbilities();

	for (i = 0; i < Abilities.Length; ++i)
	{
		AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(Abilities[i].AbilityName);
		if (!AbilityTemplate.bDontDisplayInAbilitySummary)
		{
			AbilityIcon = Spawn(class'UIIcon', self);
			AbilityIcon.bDisableSelectionBrackets = true;
			// KDM : Icons should not be navigable
			AbilityIcon.bIsNavigable = false;
			AbilityIcon.bShouldPlayGenericUIAudioEvents = false;
			AbilityIcon.InitIcon(, AbilityTemplate.IconImage, true, true, IconSize);
			AbilityIcon.SetPosition(IconX + ((IconSize + IconPadding) * AbilityIcons.Length), IconY);
			AbilityIcon.SetSize(IconSize, IconSize);
			AbilityIcons.AddItem(AbilityIcon);
			AbilityIcon.SetTooltipText(AbilityTemplate.LocHelpText, AbilityTemplate.LocFriendlyName,,,true, class'UIUtilities'.const.ANCHOR_BOTTOM_LEFT, false, 0.5);
		}
	}

	// KDM : Determine the ability icons placement for the fancy UI.
	DisplayedIcons = AbilityIcons.length;
	if (USE_FANCY_VERSION && DisplayedIcons > 0)
	{
		// KDM : The total length of the icon strip.
		TotalLength = (DisplayedIcons * IconSize) +  ((DisplayedIcons - 1) * IconPadding);
		StartX = OutpostUI.PerksHeaderButton.X +
			(OutpostUI.PerksHeaderButton.Width / 2.0) - (TotalLength / 2.0);

		for (i = 0; i < DisplayedIcons; i++)
		{
			AbilityIcon = AbilityIcons[i];
			AbilityIcon.SetPosition(StartX + ((IconSize + IconPadding) * i), 17);
		}
	}
}

simulated function UpdateDynamicData(bool Focused = false)
{
	local int ListItemIndex;
	local string strRebelJob;

	ListItemIndex = List.GetItemIndex(self);

	// KDM : Background button placed behind the rebel's job to show list item selection; this is only needed when using a controller.
	if (`ISCONTROLLERACTIVE)
	{
		if (Focused)
		{
			ButtonBG.Show();
			ButtonBG.MC.FunctionVoid("mouseIn");
		}
		else
		{
			ButtonBG.Hide();
		}
	}

	// KDM : Rebel job
	strRebelJob = class'XComGameState_LWOutpost'.static.GetJobName(OutpostUI.CachedRebels[ListItemIndex].Job);
	SpinnerLabel.SetCenteredText(class'UIUtilities_Text'.static.GetColoredText(strRebelJob, Focused ? -1: eUIState_Normal, TheFontSize));
}

simulated function SetMugShot(StateObjectReference InRebel)
{
	local Texture2D RebelPicture;
	// Remember which rebel we are taking a picture for
	RebelRef = InRebel;

	RebelPicture = class'UIUtilities_LW'.static.TakeUnitPicture(RebelRef, UpdateMugShot);
	if (RebelPicture != none)
	{
		MugShot.LoadImage(PathName(RebelPicture));
	}
	else
	{
		MugShot.Hide();
	}
}

simulated function UpdateMugShot(StateObjectReference UnitRef)
{
	local Texture2D RebelPicture;

	RebelPicture = class'UIUtilities_LW'.static.FinishUnitPicture(UnitRef);

	if (RebelPicture != none)
	{
		MugShot.LoadImage(PathName(RebelPicture));
		MugShot.Show();
	}
}

simulated function SetJobName(String JobName)
{
	local string strRebelJob;

	// KDM : If this rebel is selected, his/her background button will be highlighted, so make his/her job text black.
	// If this rebel is not selected, no background button will be visible, so make his/her job text blue.
	if (`ISCONTROLLERACTIVE)
	{
		strRebelJob = class'UIUtilities_Text'.static.GetColoredText(JobName, bIsFocused ? -1: eUIState_Normal, TheFontSize);
	}
	else
	{
		strRebelJob = class'UIUtilities_Text'.static.GetColoredText(JobName, eUIState_Normal, TheFontSize);
	}

	SpinnerLabel.SetCenteredText(strRebelJob);
}

simulated function OnClick(UIImage Btn)
{
	if (Btn == LeftButton)
	{
		OutpostUI.OnJobChanged(self, -1);
	}
	else if (Btn == RightButton)
	{
		OutpostUI.OnJobChanged(self, 1);
	}
}

simulated function OnReceiveFocus()
{
	super.OnReceiveFocus();

	// KDM : When a list item receives focus, we need to change its job colour so it doesn't clash with the background button.
	if (`ISCONTROLLERACTIVE)
	{
		UpdateDynamicData(true);
	}
}

simulated function OnLoseFocus()
{
	super.OnLoseFocus();

	// KDM : When a list item loses focus, we need to change its job colour so it doesn't clash with the black background.
	if (`ISCONTROLLERACTIVE)
	{
		UpdateDynamicData(false);
	}
}

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	local bool bHandled;

	if (!CheckInputIsReleaseOrDirectionRepeat(cmd, arg))
	{
		return false;
	}

	bHandled = true;

	switch (cmd)
	{
		// KDM : D-Pad left cycles this rebel's job to the left
		case class'UIUtilities_Input'.const.FXS_DPAD_LEFT:
			OutpostUI.OnJobChanged(self, -1);
			break;

		// KDM : D-Pad right cycles this rebel's job to the right
		case class'UIUtilities_Input'.const.FXS_DPAD_RIGHT:
			OutpostUI.OnJobChanged(self, 1);
			break;

		default:
			bHandled = false;
			break;
	}

	if (bHandled)
	{
		return true;
	}

	// KDM : If the input has not been handled, allow it to continue on its way
	return super.OnUnrealCommand(cmd, arg);
}

defaultproperties
{
	Height = 72;
	bIsNavigable = true;
}

