// implements ShowMeTheSkills-like functionality
class robojumper_UISquadSelect_SkillsPanel extends UIPanel config(robojumperSquadSelect);

var robojumper_UISquadSelect_ListItem ParentListItem;
var UIPanel BGBox;

var array<UIIcon> SkillsIcons;

var int iPerksPerLine;
var int perkSize, perkPadding;

var config array<name> ClassesExcemptFromRankFiltering;

// for alternative skill trees, specifiy rank 0 abilities here to hide them if the user wants to
var config array<name> AdditionalRankZeroAbilities;

struct AbilityColorData
{
	var X2AbilityTemplate Template;
	var name AbilityName;
	var string icoColor;
};

var config array<AbilityColorData> ColorOverrides;

var localized string strTrainingCenter;
var UIButton TrainingCenterButton;

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
	BGBox.Height = -1; // force updates to take effect
	BGBox.ProcessMouseEvents(OnBGMouseEvent);

	if (!class'robojumper_SquadSelectConfig'.static.HideTrainingCenterButton())
	{
		TrainingCenterButton = Spawn(class'UIButton', self);
		TrainingCenterButton.ResizeToText = false;
		TrainingCenterButton.InitButton('', "", OnTrainingCenterButtonClicked);
		TrainingCenterButton.SetWidth(width);
		TrainingCenterButton.Hide();
	}

	return self;
}

// Adapted from Highbob's ShowMeTheSkills
simulated function UpdateData()
{
	local int i;
	local int iSoldierAP, iPoolAP;
	local string strButtonText;
	local array<AbilityColorData> Data;
	Height = 0;
	
	GetAbilities(Data);
	SpawnSkillsIcons(Data.Length);
	for (i = 0; i < Data.Length; i++)
	{
		SkillsIcons[i].SetBGColor(Data[i].icoColor);
		SkillsIcons[i].LoadIcon(Data[i].Template.IconImage);
		SkillsIcons[i].SetTooltipText(Data[i].Template.GetMyLongDescription(), Data[i].Template.LocFriendlyName, , , , class'UIUtilities'.const.ANCHOR_BOTTOM_LEFT, , 0);
	}
	if (Data.Length > 0)
	{
		// -1 because it's the first, eighth, ... item that causes a new line not the 0th, seventh...
		Height = 20 + (((Data.Length - 1) / (iPerksPerLine)) + 1) * (perkSize + perkPadding);
	}
	if (TrainingCenterButton != none && Height > 0 && `XCOMHQ.HasFacilityByName('RecoveryCenter') && (GetUnit().IsResistanceHero() || GetUnit().GetSoldierClassTemplate().bAllowAWCAbilities))
	{
		Height += 20;
		TrainingCenterButton.Show();
		TrainingCenterButton.SetY(Height - 29);
		class'robojumper_SquadSelect_Helpers'.static.GetSoldierAndGlobalAP(GetUnit(), iSoldierAP, iPoolAP);
		strButtonText = strTrainingCenter;
		strButtonText = Repl(strButtonText, "%SOLDIERPOINTS", iSoldierAP);
		strButtonText = Repl(strButtonText, "%TOTALPOINTS", iPoolAP);
		TrainingCenterButton.SetText(strButtonText);
	}
	BGBox.SetHeight(Height);
	if (Height == 0)
	{
		BGBox.Hide();
	}
}

simulated function GetAbilities(out array<AbilityColorData> Data)
{
	local XComGameState_Unit Unit;
	local array<SoldierClassAbilityType> AbilityTree;
	local X2AbilityTemplateManager AbMgr;
	local X2AbilityTemplate AbTempl;
	local AbilityColorData EmptyData, BuildData;
	local int i;
	
	Unit = GetUnit();
	
	if (Unit != none)
	{
		AbMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
		AbilityTree = Unit.GetEarnedSoldierAbilities();
		if (class'robojumper_SquadSelectConfig'.static.DontShowInitialAbilities())
		{
			RemoveSuperfluousAbilities(Unit.GetSoldierClassTemplate(), AbilityTree, Unit);
		}
		for (i = 0; i < AbilityTree.Length; i++)
		{
			AbTempl = AbMgr.FindAbilityTemplate(AbilityTree[i].AbilityName);

			BuildData = EmptyData;
			BuildData.Template = AbTempl;
			BuildData.AbilityName = AbTempl.DataName;
			BuildData.icoColor = GetIconColor(AbTempl, Unit);
			Data.AddItem(BuildData);
		}
	}
}

simulated function string GetIconColor(X2AbilityTemplate Template, XComGameState_Unit Unit)
{
	local string icoColor;
	local int idx;

	icoColor = class'UIUtilities_Colors'.const.NORMAL_HTML_COLOR;

	idx = ColorOverrides.Find('AbilityName', Template.DataName);
	if (idx != INDEX_NONE)
		icoColor = ColorOverrides[idx].icoColor;
	else if (Template.AbilitySourceName == 'eAbilitySource_Psionic')
		icoColor = class'UIUtilities_Colors'.const.PSIONIC_HTML_COLOR;
	else if (IsAnAWCPerk(Template, Unit))
		icoColor = class'UIUtilities_Colors'.const.WARNING_HTML_COLOR;

	return icoColor;
}

// unchanged from LeaderEnemyBoss' ShowMeTheSkillsRevived for LW2
simulated function RemoveSuperfluousAbilities(X2SoldierClassTemplate SoldierClassTemplate, out array<SoldierClassAbilityType> AbilityTree, XComGameState_Unit UnitState)
{
	local array<SoldierClassAbilityType> AbilitiesToRemove;
	local SoldierClassAbilityType Ability;

	foreach AbilityTree(Ability)
	{
		if (UnitState.AbilityTree[0].Abilities.Find('AbilityName', Ability.AbilityName) != INDEX_NONE)
		{
			AbilitiesToRemove.AddItem(Ability);
		}

		if (AdditionalRankZeroAbilities.Find(Ability.AbilityName) != INDEX_NONE)
		{
			AbilitiesToRemove.AddItem(Ability);
		}
	}

	foreach AbilitiesToRemove(Ability)
	{
		AbilityTree.RemoveItem(Ability);
	}
}

// almost unchanged from LeaderEnemyBoss' ShowMeTheSkillsRevived for LW2
// TODO: change for WotC by directly inspecting the AWC branch
simulated function bool IsAnAWCPerk(X2AbilityTemplate Ability, XComGameState_Unit Unit) {

	local X2SoldierClassTemplate ClassTemplate;
	local array<SoldierClassAbilityType> SoldierRank;
	local int i;

	ClassTemplate = Unit.GetSoldierClassTemplate();
	SoldierRank = ClassTemplate.GetAllPossibleAbilities();
	for (i = 0; i < SoldierRank.Length; i++)
	{
		if (SoldierRank[i].AbilityName == Ability.DataName)
		{
			return false;
		}
	}
	// The perk was nowhere to be found, so it's from awc.
	return true;
}

simulated function SpawnSkillsIcons(int num)
{
	local int i;
	
	for (i = 0; i < num; i++)
	{
		if (i == SkillsIcons.Length)
		{
			SkillsIcons.AddItem(Spawn(class'UIIcon', self));
			SkillsIcons[i].bAnimateOnInit = false;
			SkillsIcons[i].InitIcon('');
			SkillsIcons[i].OnClickedDelegate = OnPromoteClicked;
			SkillsIcons[i].DisableNavigation();
			SkillsIcons[i].SetSize(perkSize, perkSize);
			SkillsIcons[i].SetPosition(10 + ((perkSize + perkPadding) * (i % iPerksPerLine)), 10 + ((perkSize + perkPadding) * (i / iPerksPerLine)));
		}
		SkillsIcons[i].Show();
	}
	for (i = num; i < SkillsIcons.Length; i++)
	{
		SkillsIcons[i].Hide();
	}
}

simulated function AnimateIn(optional float Delay = -1.0)
{
	AddTweenBetween("_alpha", 0, Alpha, class'UIUtilities'.const.INTRO_ANIMATION_TIME, Delay);
	AddTweenBetween("_y", Y + 20, Y, class'UIUtilities'.const.INTRO_ANIMATION_TIME * 2, Delay, "easeoutquad");
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
		case class'UIUtilities_Input'.const.FXS_L_MOUSE_UP:
			OnPromoteClicked();
			break;
	}
}


simulated function OnPromoteClicked()
{
	robojumper_UISquadSelect_ListItem(GetParent(class'robojumper_UISquadSelect_ListItem', true)).OnClickedPromote();
}

simulated function OnTrainingCenterButtonClicked(UIButton Button)
{
	local XComGameStateHistory History;
	local XComGameState_FacilityXCom FacilityState;
	local UIArmory_Promotion PromotionUI;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_FacilityXCom', FacilityState)
	{
		if( FacilityState.GetMyTemplateName() == 'RecoveryCenter' && !FacilityState.IsUnderConstruction() )
		{
			PromotionUI = UIArmory_PromotionHero(Movie.Stack.Push(Spawn(class'UIArmory_PromotionHero', self), Movie.Pres.Get3DMovie()));
			PromotionUI.InitPromotion(GetUnit().GetReference(), false);
			return;
		}
	}
}

defaultproperties
{
	bAnimateOnInit=false
	bIsNavigable=false
	bCascadeFocus=false
	iPerksPerLine=8
	perkSize=24
	perkPadding=8
}