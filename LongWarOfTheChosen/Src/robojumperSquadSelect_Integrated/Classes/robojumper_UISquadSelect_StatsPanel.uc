// responsible for showing soldier stats below the unit panel
// fixed height, so it should go above anything dynamic for consistency
class robojumper_UISquadSelect_StatsPanel extends UIPanel config(robojumperSquadSelect);

struct SquadSelectStatIconBind
{
	var ECharStatType Stat;
	var string Icon;
};

var config array<SquadSelectStatIconBind> StatIcons;


var int fontsize;
var int iconsize;

var robojumper_UISquadSelect_ListItem ParentListItem;
var UIPanel BGBox;

var array<UIImage> StatImages;
var array<UIText> StatLabels;

// Override InitPanel to run important listItem specific logic
simulated function UIPanel InitPanel(optional name InitName, optional name InitLibID)
{
	super.InitPanel(InitName, InitLibID);

	ParentListItem = robojumper_UISquadSelect_ListItem(GetParent(class'robojumper_UISquadSelect_ListItem', true)); // list items must be owned by UIList.ItemContainer
	if(ParentListItem == none)
	{
		ScriptTrace();
	}

	SetWidth(ParentListItem.width);
	BGBox = Spawn(class'UIPanel', self);
	// our bg raises mouse events, but is not navigable
	BGBox.bIsNavigable = false;
	BGBox.InitPanel('', 'X2BackgroundSimple');
	BGBox.mc.FunctionString("gotoAndPlay", "gray");
	BGBox.SetWidth(Width);
	BGBox.SetHeight(Height);
	BGBox.ProcessMouseEvents(OnBGMouseEvent);

	return self;
}

simulated function UpdateData()
{
	local XComGameState_Unit UnitState;
	local int i;
	local ECharStatType Stat;
	local eUIState StatState;
	local int CurrStat, BonusStat, MaxStat;
	local string statstring;

	UnitState = GetUnit();

	for (i = 0; i < StatIcons.Length; i++)
	{
		Stat = StatIcons[i].Stat;
		if (Stat != eStat_PsiOffense || `XCOMHQ.IsTechResearched('Psionics'))
		{
			// for HP, show current "/" max stat
			if (Stat == eStat_HP
				|| (Stat == eStat_Will && class'robojumper_SquadSelect_Helpers'.static.UnitParticipatesInWillSystem(UnitState))
				)
			{
				class'robojumper_SquadSelect_Helpers'.static.GetCurrentAndMaxStatForUnit(UnitState, Stat, CurrStat, MaxStat);

				if (float(CurrStat) / float(MaxStat) < 0.33f)
					StatState = eUIState_Bad;
				else if (float(CurrStat) / float(MaxStat) >= 0.67f)
					StatState = eUIState_Good;
				else
					StatState = eUIState_Warning;

				statstring = class'UIUtilities_Text'.static.GetColoredText(CurrStat $"/"$ MaxStat, StatState, fontsize);
			}
			else
			{
				// otherwise, show base "+" bonus
				CurrStat = UnitState.GetCurrentStat(Stat) + UnitState.GetUIStatFromAbilities(Stat);
				BonusStat = UnitState.GetUIStatFromInventory(Stat);

				statstring = class'UIUtilities_Text'.static.GetColoredText(string(CurrStat), eUIState_Normal, fontsize);
				if (BonusStat != 0)
				{
					StatString $= class'UIUtilities_Text'.static.GetColoredText(BonusStat > 0 ? ("+" $ BonusStat) : ("-" $ int(Abs(BonusStat))), BonusStat > 0 ? eUIState_Good : eUIState_Bad, fontsize);
				}
			}
			AddStat(statstring, StatIcons[i].Icon, i);
		}
		else
		{
			AddStat("", "", i);
		}
	}
}

simulated function AddStat(string strLabel, string strIcon, int idx)
{
	local UIText TempText;
	local UIImage TempImage;
	local int iconpadding;
	local int paddedHeight, paddedWidth;

	paddedHeight = Height - 4;
	paddedWidth = Width - 4;

	iconpadding = (paddedHeight / 4 - iconsize / 2);
	if (idx == StatImages.Length)
	{
		TempImage = Spawn(class'UIImage', self).InitImage();
		TempImage.SetPosition((idx % 4) * (paddedWidth / 4) + iconpadding + 2, (idx / 4) * (paddedHeight / 2) + iconpadding + 2);
		TempImage.SetColor(class'UIUtilities_Colors'.const.NORMAL_HTML_COLOR);
		TempImage.SetSize(iconsize, iconsize);
		StatImages.AddItem(TempImage);

		TempText = Spawn(class'UIText', self).InitText();
		TempText.SetPosition((idx % 4) * (paddedWidth / 4) + (2 * iconpadding) + iconsize + 2, (idx / 4) * (paddedHeight / 2) + iconpadding + 2);
		StatLabels.AddItem(TempText);
	}
	
	if (strLabel != "")
	{
		StatLabels[idx].Show();
		StatLabels[idx].SetHTMLText(strLabel);
	}
	else
	{
		StatLabels[idx].Hide();
	}
	
	if (strIcon != "")
	{
		StatImages[idx].Show();
		StatImages[idx].LoadImage(strIcon);
	}
	else
	{
		StatImages[idx].Hide();
	}
}

simulated function XComGameState_Unit GetUnit()
{
	return robojumper_UISquadSelect_ListItem(GetParent(class'robojumper_UISquadSelect_ListItem', true)).GetUnit();
}

simulated function OnBGMouseEvent(UIPanel control, int cmd)
{
	switch( cmd )
	{
		case class'UIUtilities_Input'.const.FXS_L_MOUSE_IN:
			OnReceiveFocus();
			control.OnReceiveFocus();
			robojumper_UISquadSelect_ListItem(GetParent(class'robojumper_UISquadSelect_ListItem', true)).SetSelectedNavigationSoldierPanel();
			break;
		case class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT:
			OnLoseFocus();
			control.OnLoseFocus();
			break;
	}
}

defaultproperties
{
	bAnimateOnInit=false
	bIsNavigable=false
	bCascadeFocus=false
	Height=48
	fontsize=16
	iconsize=19
}