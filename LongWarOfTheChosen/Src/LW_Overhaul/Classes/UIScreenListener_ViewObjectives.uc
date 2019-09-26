//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_ViewObjectives.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Adjust objectives pane to use scrollbar instead of slow autoscroll
//---------------------------------------------------------------------------------------

class UIScreenListener_ViewObjectives extends UIScreenListener config(LW_Overhaul);

event OnInit(UIScreen Screen)
{
	MakeDescriptionUseScrollbar(UIViewObjectives(Screen));
}

event OnReceiveFocus(UIScreen Screen)
{
	MakeDescriptionUseScrollbar(UIViewObjectives(Screen));
}

function MakeDescriptionUseScrollbar(UIViewObjectives ViewObjectives)
{
	local string Description;
	local Commodity ListItem;

	local UITextContainer DescriptionText;

	if (ViewObjectives != none)
	{
		// this will just add a scrollbar to the existing text, but it won't be scrollable with mouse wheel
		//ViewObjectives.ItemCard.MC.ChildFunctionVoid("description", "EnableScrollbar");
		//ViewObjectives.ItemCard.MC.ChildFunctionVoid("description", "ResetScroll");

		// this will empty the text, and replace with a new container, which will be wheel scrollable, but the leading is too big
		ViewObjectives.ItemCard.MC.ChildFunctionString("description", "setHTML", "");
		ListItem = ViewObjectives.arrItems[ViewObjectives.iSelectedItem];
		Description = ListItem.Desc;
		`LWTrACE("View Objectives description : " $ Description);

		DescriptionText = UITextContainer(ViewObjectives.GetChild('ObjectivesDescription_LW'));
		if (DescriptionText == none)
		{
			DescriptionText = ViewObjectives.Spawn(class'UITextContainer', ViewObjectives);
			DescriptionText.bAnimateOnInit = false;
			DescriptionText.InitTextContainer('ObjectivesDescription_LW', "", 700+33, 470+51, 460+104, 350+82, true);
		}
		DescriptionText.SetHTMLText("<font size='24' leading='24'>" $ Description $ "</font>");
		DescriptionText.bg.SetAlpha(0);
	}
}

defaultproperties
{
    ScreenClass=UIViewObjectives
}

