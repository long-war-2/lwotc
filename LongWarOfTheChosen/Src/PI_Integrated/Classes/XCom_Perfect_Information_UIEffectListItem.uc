//-----------------------------------------------------------
//	Class:	XCom_Perfect_Information_UIEffectListItem
//	Author: tjnome
//	
//-----------------------------------------------------------

class XCom_Perfect_Information_UIEffectListItem extends UIEffectListItem;

var UIText EffectiNumTurns;

var localized string TURNS_REMAINING;

simulated function UIEffectListItem InitEffectListItem(UIEffectList initList,
															   optional int InitX = 0, 
															   optional int InitY = 0, 
															   optional int InitWidth = 0)
{
	InitPanel(); 

	List = initList;

	if( List == none )
	{
		//`log("UIEffectListItem incoming 'List' is none.",,'uixcom');
		return self;
	}

	//Inherit size. 
	if( InitWidth == 0 )
		width = List.width;
	else
		width = InitWidth;

	Icon = Spawn(class'UIIcon', self).InitIcon(,,false,true,36);

	Title = Spawn(class'UIScrollingText', self).InitScrollingText('Title', "", width,,,true);
	Title.SetPosition( Icon.Y + Icon.width + TitleXPadding, TitleYPadding);
	Title.SetWidth(width - Title.X); 

	Line = class'UIUtilities_Controls'.static.CreateDividerLineBeneathControl(Title);

	Desc = Spawn(class'UIText', self).InitText('Desc', "", true);
	Desc.SetWidth(width); 
	Desc.SetPosition(0, Line.Y + DescPadding);
	Desc.onTextSizeRealized = onTextSizeRealized; 

	EffectiNumTurns = Spawn(class'UIText', self).InitText('EffectiNumTurns', "", true);
	EffectiNumTurns.SetWidth(width); 
	return self;
}

simulated function RefreshDisplay()
{
	if (Data.Icon == "")
	{
		Icon.Hide();
	}
	else
	{
		Icon.LoadIcon(Data.Icon);
		Icon.Show();
	}

	Title.SetHTMLText(class'UIUtilities_Text'.static.StyleText(Data.Name, eUITextStyle_Tooltip_Title));
	Desc.SetHTMLText(class'UIUtilities_Text'.static.StyleText(Data.Description, eUITextStyle_Tooltip_Body));
	EffectiNumTurns.SetText(GetNumTurnsString(Data.Cooldown));
}

simulated function string GetNumTurnsString(int NumTurns)
{
	if(NumTurns > 0)
		return string(NumTurns) @ Class'UIUtilities_Text'.static.GetColoredText(TURNS_REMAINING, eUITextStyle_Tooltip_Title);
	else if (NumTurns == -1)
		return string(0) @ Class'UIUtilities_Text'.static.GetColoredText(TURNS_REMAINING, eUITextStyle_Tooltip_Title);
	else 
		return "";
		//return Chr(8734) @ Class'UIUtilities_Text'.static.GetColoredText(TURNS_REMAINING, eUITextStyle_Tooltip_Title);
}

simulated function onTextSizeRealized()
{
	local int iCalcNewHeight;

	if (Data.Cooldown != 0)
		iCalcNewHeight = Desc.Y + Desc.height + EffectiNumTurns.Height; 
	else 
		iCalcNewHeight = Desc.Y + Desc.height + BottomPadding;

	//iCalcNewHeight = Desc.Y + Desc.height + EffectiNumTurns.Height;
	if (iCalcNewHeight != Height )
	{
		Height = iCalcNewHeight;  
		EffectiNumTurns.SetY(Desc.Y + Desc.height);
		List.OnItemChanged(self);
	}
}