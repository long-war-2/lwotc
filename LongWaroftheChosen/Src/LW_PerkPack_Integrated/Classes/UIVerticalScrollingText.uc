//----------------------------------------------------------------------------
//  FILE:    UIVerticalScrollingText.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: UIText control for vertical scrolling text.
//----------------------------------------------------------------------------

class UIVerticalScrollingText extends UIPanel;

// UIText member variables
var protectedwrite string Text;
var protectedwrite string HtmlText;
var protectedwrite bool ResizeToText;
var protectedwrite bool TextSizeRealized;

var UIBGBox bg;
var int bgPadding;

simulated function UIVerticalScrollingText InitVerticalScrollingText(optional name InitName, optional string initText,
															 optional float initX, optional float initY, 
															 optional float initWidth, optional float initHeight,
															 optional bool addBG, optional name bgLibID)
{
	InitPanel(InitName);

	if(addBG)
	{
		// bg must be added before itemContainer so it draws underneath it
		bg = Spawn(class'UIBGBox', self);
		if(bgLibID != '') bg.LibID = bgLibID;
		bg.InitBG('', 0, 0, initWidth, initHeight);
	}

	
	SetSize(initWidth, initHeight);
//	SetMaskHeight(initHeight);
	SetPosition(initX, initY);
	//SetHtmlText(initText);
	SmoothScrollUp();
	return self;
}

simulated function UIVerticalScrollingText SetHtmlText(string NewText)
{
	if (HtmlText != NewText)
	{
		HtmlText = NewText;

		MC.BeginFunctionOp("setHTML");
		MC.QueueString(NewText);
		MC.EndOp();
		
	}
	return self;
}

simulated function ResetScroll()
{
	MC.BeginFunctionOp("ResetScroll");
	MC.EndOp();
}

simulated function SmoothScrollUp()
{
	MC.BeginFunctionOp("smoothScrollUp");
	MC.EndOp();
}

simulated function SetMaskHeight(float newHeight)
{
	MC.FunctionNum("setMaskHeight",newHeight);
}

// Width TextControl works differently from regular UIControls
simulated function SetWidth(float NewWidth)
{
	if(Width != NewWidth)
	{
		Width = NewWidth;
		MC.FunctionNum("setTextWidth", Width);
	}
}

// setting height is really just setting the mask height
simulated function SetHeight(float newHeight)
{
	if(Height != newHeight)
	{
		Height = newHeight;
		SetMaskHeight(newHeight);
	}
}

simulated function UIPanel SetSize(float newWidth, float newHeight)
{
	SetWidth(newWidth);
	SetMaskHeight(newHeight);
	return self;
}

defaultproperties
{
	//Package = "/ package/gfxArmory_LW/Armory_Expanded";
	LibID = "scrollingTextField"
	bIsNavigable = false;
	bgPadding = 20;
}
