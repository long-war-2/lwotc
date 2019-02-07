//---------------------------------------------------------------------------------------
//  FILE:    UIArmory_LWExpandedPromotionSummaryItem
//  AUTHOR:  Amineri (Pavonis Interactive)
//
//  PURPOSE: (New) Container to hold individual items for the list showing class/ability summary
//
//--------------------------------------------------------------------------------------- 

class UIArmory_LWExpandedPromotionSummaryItem  extends UIPanel;

`include(..\..\XComGame\Mods\LongWaroftheChosen\Src\LW_PerkPack_Integrated\LW_PerkPack.uci)

var int BGPadding;
var UIBGBox BGBox, BGBoxTest; 
var UIImage ClassIcon;
var UIICon AbilityIcon;
var UIScrollingText AbilityTitleText;
//var UITextContainer AbilitySummaryText;
var UIVerticalScrollingText2 AbilitySummaryText;
//var UIVerticalScrollingText AbilitySummaryText;

simulated function UIArmory_LWExpandedPromotionSummaryItem InitSummaryItem()
{
	InitPanel();

	//BGBoxTest = Spawn(class'UIBGBox', self);
	//BGBoxTest.InitPanel('', class'UIUtilities_Controls'.const.MC_X2BackgroundSimple).SetSize(Width, Height);
//

	BGBox = Spawn(class'UIBGBox', self);
	BGBox.bAnimateOnInit = false;
	BGBox.InitPanel('', class'UIUtilities_Controls'.const.MC_X2Background).SetSize(Width, Height);

	//Spawn(class'UIPanel', self).InitPanel('BGBox', class'UIUtilities_Controls'.const.MC_X2Background).SetSize(width, height);

	AbilityIcon = Spawn(class'UIIcon', self);
	AbilityIcon.bAnimateOnInit = false;
	AbilityIcon.InitIcon('IconMC',,false, true, 26); // 'IconMC' matches instance name of control in Flash's 'AbilityItem' Symbol
	AbilityIcon.SetPosition(12, 12);
	//AbilityIcon.Hide();

	ClassIcon = Spawn(class'UIImage', self);
	ClassIcon.bAnimateOnInit = false;
	ClassIcon.InitImage();
	ClassIcon.SetPosition(10, 10);
	ClassIcon.SetSize(36, 36);
	ClassIcon.Hide();

	AbilityTitleText = Spawn(class'UIScrollingText', self);
	AbilityTitleText.bAnimateOnInit = false;
	AbilityTitleText.InitScrollingText(, "Title", 146,,,true);
	AbilityTitleText.SetText(class'UIUtilities_Text'.static.GetColoredText("SAMPLE VERY LONG ABILITY TITLE", eUIState_Normal, 26));
	//AbilityTitleText.SetWidth(124); 
	AbilityTitleText.SetPosition(50, 13);

	//AbilitySummaryText = Spawn(class'UITextContainer', self).InitTextContainer(,"",6, 48, 196, 600,,,true);
	AbilitySummaryText = Spawn(class'UIVerticalScrollingText2', self);
	AbilitySummaryText.bAnimateOnInit = false;
	AbilitySummaryText.InitVerticalScrollingText(, "", 6, 48, 196, 1000); // create, size and position vertical auto-scrolling text field
	AbilitySummaryText.SetHTMLText(class'UIUtilities_Text'.static.GetColoredText("Summary Text l l l l l l l l l l l l l l l l l l Test\nTest\nTest\nTest\nTest\nTest\nTest\n", eUIState_Normal, 18));
	AbilitySummaryText.SetHeight(110);

	//Hide();
	return self;
}

simulated function SetSummaryData(string IconPath, string ClassPath, string TitleText, string SummaryText)
{
	if (IconPath != "")
	{
		AbilityIcon.LoadIcon(iconPath);
		AbilityIcon.Show();
	} else {
		AbilityIcon.Hide();
	}

	if (ClassPath != "")
	{
		ClassIcon.LoadImage(ClassPath);
		ClassIcon.Show();
	} else {
		ClassIcon.Hide();
	}
	
	AbilityTitleText.SetText(TitleText);
	AbilitySummaryText.SetHTMLText(SummaryText);

	Show();
}

simulated function UpdateSizeAndPosition(int ListSize)
{
	local float UpdatedWidth;
	local UIList ParentList;
	//local Vector2D ClassIconPos, AbilityIconPos;
	//local Vector2D TitleTextPos, SummaryTextPos;

	ParentList = UIList(GetParent(class'UIList'));
	if(ParentList == none)
	{
		`Redscreen("Expanded Perk Tree: Failed to find ParentPanel for auto-sizing");
		return;
	}

	//update full panel
	UpdatedWidth = (ParentList.width - (ParentList.ItemPadding * (ListSize - 1))) / ListSize;
	SetSize(UpdatedWidth, ParentList.height);
	`PPDEBUG("ExpandedPerkTree/ResizePanel : ListWidth=" $ ParentList.width $ ", UpdatedWidth=" $ UpdatedWidth);
	`PPDEBUG("ExpandedPerkTree/ResizePanel : Panel.width=" $ width $ ", Panel.height=" $ height);

	////reposition icons
	//ClassIconPos.X = 0.075 * UpdatedWidth;
	//ClassIconPos.Y = 0.1 * ParentList.height;
	//AbilityIconPos.X = 0.075 * UpdatedWidth;
	//AbilityIconPos.Y = 0.1 * ParentList.height;
	//ClassIcon.SetPosition(ClassIconPos.X, ClassIconPos.Y);
	//AbilityIcon.SetPosition(AbilityIconPos.X, AbilityIconPos.Y);
//
	////reposition text
	//TitleTextPos.X = 0.25 * UpdatedWidth;
	//TitleTextPos.Y = 0.1 * ParentList.height;
	//SummaryTextPos.X = 0.1 * UpdatedWidth;
	//SummaryTextPos.Y = 0.3 * ParentList.height;
	//AbilityTitleText.SetPosition(TitleTextPos.X, TitleTextPos.Y);
	//AbilitySummaryText.SetPosition(SummaryTextPos.X, SummaryTextPos.Y);
//
	////resize text
	//AbilitySummaryText.SetWidth(0.85 * UpdatedWidth);
	//AbilitySummaryText.SetHeight(0.725 * ParentList.height);
	//AbilityTitleText.SetWidth(0.625 * UpdatedWidth);

}

defaultproperties
{
	//Package = "/ package/gfxArmory_LW/Armory_Expanded";

	bAnimateOnInit = false;

	BGPadding = -6;
	Width = 214;
	Height = 168;
	bCascadeFocus = false;
}