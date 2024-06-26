//---------------------------------------------------------------------------------------
//  FILE:    UISquadSelect_InfiltrationItem.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//
//  PURPOSE: Item linking to X2ObjectiveListItem for displaying shadowed text
//--------------------------------------------------------------------------------------- 
class UISquadSelect_InfiltrationItem extends UIPanel config(LW_Overhaul);

var UIPanel TitleIcon;

simulated function UISquadSelect_InfiltrationItem InitObjectiveListItem(optional int InitX = 0, 
																		optional int InitY = 0)
{
	InitPanel(); 

	TitleIcon = Spawn(class'UIPanel', self).InitPanel('titleIcon');

	SetPosition(InitX, InitY);

	return self;
}

simulated function OnInit()
{
	super.OnInit();
}

simulated function SetTitleTest(string Text)
{
	MC.FunctionString("setTitle", Text);
}

simulated function SetText(string Text)
{
	MC.FunctionString("setLabelRow", Text);
}
simulated function SetNewText(string Text)
{
	MC.FunctionString("setLabelRow", "<font face='$NormalFont' size='22'>" $ Text $ "</font>");
}

simulated function SetSubTitle(string Text, optional string TextColor)
{
	if (TextColor == "")
		MC.FunctionString("setLabelRow", "<font face='$TitleFont' size='22' color='#a7a085'>" $ CAPS(Text) $ "</font>");
	else
		MC.FunctionString("setLabelRow", "<font face='$TitleFont' size='22' color='#" $ TextColor $ "'>" $ CAPS(Text) $ "</font>");

}

simulated function SetInfoValue(string Text, string TextColor)
{
	MC.FunctionString("setLabelRow", "<font face='$NormalFont' size='22' color='#" $ TextColor $ "'>" $ Text  $ "</font>");
}

simulated function SetNewInfoValue(string PreText, string Text, string TextColor)
{
	MC.FunctionString("setLabelRow","<font face='$NormalFont' size='22'>" $ PreText $ ": " $ "</font>" $ "<font face='$NormalFont' size='22' color='#" $ TextColor $ "'>" $ Text  $ "</font>");
}


defaultproperties
{
	LibID = "X2ObjectiveListItem";
	Height = 32; 

	bAnimateOnInit = false;

}