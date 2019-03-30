//---------------------------------------------------------------------------------------
//  FILE:    UIOutpostManagement_ListItem
//  AUTHOR:  tracktwo / Pavonis Interactive
//
//  PURPOSE: List Item (one row) for UIOutpostManagement
//--------------------------------------------------------------------------------------- 

class UIOutpostManagement_ListItem extends UIPanel;

const ABILITY_ICON_X=148;
const ABILITY_ICON_Y=32;
const ABILITY_ICON_GAP=30;

var StateObjectReference OutpostRef;
var StateObjectReference RebelRef;
var int Index;

var UIImage MugShot;
var UIText NameLabel;
var UIText LevelLabel;
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
    List = UIList(GetParent(class'UIList'));
    OutpostUI = UIOutpostManagement(Screen);

    Width = List.Width;
    JobHeaderX = OutpostUI.JobHeaderButton.X;
    JobHeaderWidth = OutpostUI.JobHeaderButton.Width;
    
    MugShot = Spawn(class'UIImage', self).InitImage();
    MugShot.SetPosition(0, 3);
    MugShot.SetSize(64,64);

    NameLabel = Spawn(class'UIText', self).InitText();
    NameLabel.SetPosition(70, 3);
    LevelLabel = Spawn(class'UIText', self).InitText();
    LevelLabel.SetPosition(70, 38);

    // Use a hand-written spinner instead of UIListItemSpinner, which has trouble with mouse events not propagating
    // to the parents, which messes up the mouse wheel scrolling in the list item. I *think* this is an issue in the
    // flash with XComSpinner gobbling up the child mouse events except for MOUSE_UP, so the big blank space to the
    // left of the buttons where the label ordinarily is becomes a dead zone for scrolling.
    LeftButton = Spawn(class'UIImage', self).InitImage(,"img:///gfxComponents.PC_arrowLEFT", OnClick);
    LeftButton.SetSize(24, 24);
    LeftButton.SetPosition(JobHeaderX + 10, (Height - LeftButton.Height) / 2);

    RightButton = Spawn(class'UIImage', self).InitImage(,"img:///gfxComponents.PC_arrowRIGHT", OnClick);
    RightButton.SetSize(24, 24);
    RightButton.SetPosition(JobHeaderWidth + JobHeaderX - RightButton.Width - 10, (Height - RightButton.Height) / 2);

    SpinnerLabel = Spawn(class'UIText', self).InitText();
    SpinnerLabel.SetPosition(LeftButton.X + LeftButton.Width + 4, LeftButton.Y);
    SpinnerLabel.SetWidth(RightButton.X - SpinnerLabel.X - 4);
    SpinnerLabel.SetText("Foo");
}

simulated function UIOutpostManagement_ListItem InitListItem()
{
    InitPanel();
    BuildItem();
    return self;
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

simulated function SetRebelName(String RebelName)
{
    NameLabel.SetText(RebelName);
}

simulated function SetJobName(String JobName)
{
    SpinnerLabel.SetCenteredText(JobName);
}

simulated function SetLevel(int Level)
{
    local String text;
    while(Level > 0)
    {
        text = text $ class'UIUtilities_Text'.static.InjectImage(class'UIUtilities_Image'.const.HTML_ObjectiveIcon, 20, 20, 0);
        --Level;
    }

    LevelLabel.SetHtmlText(text);
}

simulated function AddAbility(X2AbilityTemplate Ability)
{
    local UIIcon Icon;

    Icon = Spawn(class'UIIcon', self).InitIcon(,Ability.IconImage, true, true, 24);
    Icon.SetSize(24, 24);
    Icon.bDisableSelectionBrackets = true;
    Icon.bShouldPlayGenericUIAudioEvents = false;
    Icon.SetPosition(ABILITY_ICON_X + ABILITY_ICON_GAP * AbilityIcons.Length, ABILITY_ICON_Y);
    AbilityIcons.AddItem(Icon);
    Icon.SetTooltipText(Ability.LocHelpText, Ability.LocFriendlyName,,,true, class'UIUtilities'.const.ANCHOR_BOTTOM_LEFT, false, 0.5);
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

defaultproperties
{
    Height = 72;
	bIsNavigable = true;
}

