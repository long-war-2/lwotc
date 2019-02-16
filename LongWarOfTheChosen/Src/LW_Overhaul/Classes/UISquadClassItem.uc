//---------------------------------------------------------------------------------------
//  FILE:    UISquadClassItem.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//
//  PURPOSE: An class icon within a squad element
//--------------------------------------------------------------------------------------- 
class UISquadClassItem extends UIPanel config(LW_Overhaul);

// the list that owns this item
var UIList List;

var UIImage ClassIcon;
var UIImage TempIcon;

var string TempIconImagePath;

simulated function UISquadClassItem InitSquadClassItem()
{
	InitPanel(); 

	SetSize(38, 38);

	List = UIList(GetParent(class'UIList')); // list items must be owned by UIList.ItemContainer
	if(List == none)
	{
		ScriptTrace();
		`warn("UI list items must be owned by UIList.ItemContainer");
	}

	ClassIcon = Spawn(class'UIImage', self);
	ClassIcon.bAnimateOnInit = false;
	ClassIcon.InitImage().SetSize(38, 38);

	TempIcon = Spawn(class'UIImage', self);
	TempIcon.bAnimateOnInit = false;
	TempIcon.InitImage().SetSize(16, 16).SetPosition(24, 24);
	TempIcon.LoadImage(default.TempIconImagePath);
	TempIcon.Hide();

	return self;
}

simulated function ShowTempIcon(bool bShow)
{
	if(bShow)
		TempIcon.Show();
	else
		TempIcon.Hide();
}

simulated function UIImage LoadClassImage(string NewPath)
{
	return ClassIcon.LoadImage(NewPath);
}

defaultProperties
{
	TempIconImagePath="img:///gfxComponents.attention_icon"
}