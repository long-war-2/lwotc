//---------------------------------------------------------------------------------------
//  FILE:    UIRecruitmentListItem_LW.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: This is an extension for RecruitmentListItem that allows displays stats, called via registered events
//
//	KDM :	 UIRecruitmentListItem_LWOTC is now used in place of UIRecruitmentListItem_LW.
//---------------------------------------------------------------------------------------

class UIRecruitmentListItem_LW extends Object;

/*
static function AddRecruitStats(XComGameState_Unit Recruit, UIRecruitmentListItem ListItem)
{
	local UIPanel kLine;

	ListItem.bAnimateOnInit = false;

	//shift confirm button up
	ListItem.ConfirmButton.SetY(0);

	//shift soldier name up
	ListItem.MC.ChildSetNum("soldierName", "_y", 5);

	// update flag size and position
	ListItem.MC.BeginChildFunctionOp("flag", "setImageSize");  
	ListItem.MC.QueueNumber(81);			// add number Value
	ListItem.MC.QueueNumber(42);			// add number Value
	ListItem.MC.EndOp();					// add delimiter and process command
	ListItem.MC.ChildSetNum("flag", "_x", 7);
	ListItem.MC.ChildSetNum("flag", "_y", 10.5);

	// extend divider line
	kLine = ListItem.Spawn(class'UIPanel', ListItem);
	kLine.InitPanel('', class'UIUtilities_Controls'.const.MC_GenericPixel);
	kLine.SetColor(class'UIUtilities_Colors'.const.NORMAL_HTML_COLOR);
	kLine.SetSize(1, 21.5).SetPosition(90.6, 36.75).SetAlpha(66.40625);

	AddIcons(Recruit, ListItem);

	// HAX: Undo the height override set by UIListItemString
	Listitem.Height = 64; // don't use SetHeight here, as UIListItemString can't handle it
	ListItem.MC.ChildSetNum("theButton", "_height", 64);

	ListItem.List.OnItemSizeChanged(ListItem);
}

static function AddIcons(XComGameState_Unit Unit, UIRecruitmentListItem ListItem)
{
	local float IconXPos, IconYPos, IconXDelta;
	local bool PsiStatIsVisible;

	PsiStatIsVisible = `XCOMHQ.IsTechResearched('AutopsySectoid');

	IconYPos = 34.5f;
	IconXPos = 97;
	IconXDelta = 65.0f;

	if(PsiStatIsVisible) {
		IconXDelta -= 10.0f;
	}

	InitIconValuePair(Unit, ListItem,	eStat_Offense,	"Aim",		"UILibrary_LWToolbox.StatIcons.Image_Aim",		IconXPos, IconYPos);
	IconXPos += IconXDelta;
	InitIconValuePair(Unit, ListItem,	eStat_Defense,	"Defense",	"UILibrary_LWToolbox.StatIcons.Image_Defense",	IconXPos, IconYPos);
	IconXPos += IconXDelta;
	InitIconValuePair(Unit, ListItem,	eStat_HP,		"Health",	"UILibrary_LWToolbox.StatIcons.Image_Health",	IconXPos, IconYPos);
	IconXPos += IconXDelta;
	InitIconValuePair(Unit, ListItem,	eStat_Mobility,	"Mobility",	"UILibrary_LWToolbox.StatIcons.Image_Mobility",	IconXPos, IconYPos);
	IconXPos += IconXDelta;
	InitIconValuePair(Unit, ListItem,	eStat_Will,		"Will",		"UILibrary_LWToolbox.StatIcons.Image_Will",		IconXPos, IconYPos);
	IconXPos += IconXDelta;
	InitIconValuePair(Unit, ListItem,	eStat_Hacking,	"Hacking",	"UILibrary_LWToolbox.StatIcons.Image_Hacking",	IconXPos, IconYPos);
	IconXPos += IconXDelta;
	InitIconValuePair(Unit, ListItem,	eStat_Dodge,	"Dodge",	"UILibrary_LWToolbox.StatIcons.Image_Dodge",	IconXPos, IconYPos);
	
	if(PsiStatIsVisible) {
		IconXPos += IconXDelta;
		InitIconValuePair(Unit, ListItem,   eStat_PsiOffense, "Psi",	"gfxXComIcons.promote_psi",      IconXPos, IconYPos);
	}
}

static function InitIconValuePair(XComGameState_Unit Unit, UIRecruitmentListItem ListItem, ECharStatType StatType, string MCRoot,  string ImagePath, float XPos, float YPos)
{
	local UIImage Icon;
	local UIText Value;
	local float IconScale, IconToValueOffsetX, IconToValueOffsetY;

	IconScale = 0.65f;
	IconToValueOffsetX = 26.0f;
	if(GetLanguage() == "JPN")
	{
		IconToValueOffsetY = -3.0;
	}
	if(Icon == none)
	{
		Icon = ListItem.Spawn(class'UIImage', ListItem);
		Icon.InitImage(name("RecruitmentItem_" $ MCRoot $ "Icon_LW"), ImagePath).SetScale(IconScale).SetPosition(XPos, YPos);
		Icon.bAnimateOnInit = false;
	}
	if(Value == none)
	{
		Value = UIText(ListItem.Spawn(class'UIText', ListItem).InitText().SetPosition(XPos + IconToValueOffsetX, YPos + IconToValueOffsetY));
		Value.MCName = name("RecruitmentItem_" $ MCRoot $ "Value_LW");
		Value.bAnimateOnInit = false;
	}
	Value.Text = string(int(Unit.GetCurrentStat(StatType)));
	Value.SetHtmlText(class'UIUtilities_Text'.static.GetColoredText(Value.Text, eUIState_Normal));
}

static function UpdateItemsForFocus(UIRecruitmentListItem ListItem)
{
	local bool bReverse;

	bReverse = ListItem.bIsFocused && !ListItem.bDisabled;

	UpdateText(ListItem, "Aim", bReverse);
	UpdateText(ListItem, "Defense", bReverse);
	UpdateText(ListItem, "Health", bReverse);
	UpdateText(ListItem, "Mobility", bReverse);
	UpdateText(ListItem, "Will", bReverse);
	UpdateText(ListItem, "Hacking", bReverse);
	UpdateText(ListItem, "Dodge", bReverse);
	UpdateText(ListItem, "Psi", bReverse);
}

static function UpdateText(UIRecruitmentListItem ListItem, string MCRoot, bool bReverse)
{
	local name LookupMCName;
	local UIText Value;
	local string OldText;

	LookupMCName = name("RecruitmentItem_" $ MCRoot $ "Value_LW");
	Value = UIText(ListItem.GetChildByName(LookupMCName, false));
	if (Value != none)
	{
		OldText = Value.Text;
		Value.SetHtmlText(class'UIUtilities_Text'.static.GetColoredText(OldText, (bReverse ? -1 : eUIState_Normal)));
	}
}
*/
