//----------------------------------------------------------------------------
//  FILE:    UIScrollingTextField.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Alternate text scroller that links to XComScrollingTextField, allowing shadows to be placed
//----------------------------------------------------------------------------
class UIScrollingTextField extends UIPanel;

// UIText member variables
var string text;
var string htmlText;
var bool bDisabled; //For gray text coloring 

var const float DefaultShadowColor;
var const float DefaultShadowStrength;
var const float DefaultShadowThickness;
var const float DefaultShadowAlpha;
var const float DefaultShadowBlur;

simulated function UIScrollingTextField InitScrollingText(optional name InitName, optional string initText, optional float initWidth,
															 optional float initX, optional float initY, optional bool useTitleFont)
{
	InitPanel(InitName);
	
	// HAX: scrolling text fields are always one liners, make them huge to fit the text
	mc.FunctionNum("setTextWidth", Screen.Movie.UI_RES_X);

	SetPosition(initX, initY);
	SetWidth(initWidth);

	if(useTitleFont)
		SetTitle(initText);
	else
		SetText(initText);

	return self;
}

simulated function UIScrollingTextField SetText(optional string txt)
{
	if(text != txt)
	{
		text = txt;
		SetHTMLText(class'UIUtilities_Text'.static.AddFontInfo(txt, Screen.bIsIn3D));
	}
	return self;
}

simulated function UIScrollingTextField SetTitle(optional string txt, optional bool bReversed, optional bool bForce)
{
	local string formattedText;

	if(text != txt || bForce)
	{
		text = txt;
		formattedText = class'UIUtilities_Text'.static.AddFontInfo(txt, Screen.bIsIn3D, true);
		formattedText = class'UIUtilities_Text'.static.GetColoredText(formattedText, (bReversed ? -1 : eUIState_Normal));
		SetHTMLText(formattedText);
	}
	return self;
}

simulated function UIScrollingTextField SetSubTitle(optional string txt, optional bool bReversed, optional bool bForce)
{
	local string formattedText;
	if(text != txt || bForce)
	{
		text = txt;
		formattedText = class'UIUtilities_Text'.static.AddFontInfo(txt, Screen.bIsIn3D, true, true);
		formattedText = class'UIUtilities_Text'.static.GetColoredText(formattedText, (bReversed ? -1 : eUIState_Normal));
		SetHTMLText(formattedText);
	}
	return self;
}

simulated function UIScrollingTextField SetHTMLText(optional string txt, optional bool bForce = false)
{
	if(bForce || htmlText != txt)
	{
		htmlText = txt;
		mc.FunctionString("setHTMLText", htmlText);
	}
	return self;
}

// Sizing this control really means sizing its mask
simulated function SetWidth(float NewWidth)
{
	if(Width != NewWidth)
	{
		Width = NewWidth;
		mc.FunctionNum("setWidth", Width);
	}
}

// Sizing this control really means sizing its mask
simulated function SetHeight(float NewHeight)
{
	`RedScreen("NOT SUPPORTED");
}

simulated function UIPanel SetSize(float NewWidth, float NewHeight)
{
	`RedScreen("NOT SUPPORTED");
	return self;
}

simulated function UIScrollingTextField ResetScroll()
{
	mc.FunctionVoid("resetScroll");
	return self;
}

simulated function UIScrollingTextField SetDisabled(optional bool bDisable = true)
{
	if( bDisabled != bDisable )
	{
		bDisabled = bDisable;
		mc.FunctionBool("setDisabled", bDisabled);
	}
	return self;
}

simulated function ShowShadow(	optional int ShadowColor = DefaultShadowColor, 
								optional float ShadowBlur = DefaultShadowBlur, 
								optional float ShadowThickness = DefaultShadowThickness, 
								optional float ShadowStrength = DefaultShadowStrength, 
								optional float ShadowAlpha = DefaultShadowAlpha)
{
	local string ShadowStyle;

	MC.FunctionVoid("showShadow");

	if(ShadowColor != DefaultShadowColor)
	{
		MC.ChildSetNum("textField", "shadowColor", ShadowColor);
	}
	if(ShadowBlur != DefaultShadowBlur)
	{
		MC.ChildSetNum("textField", "shadowBlurX", ShadowBlur);
		MC.ChildSetNum("textField", "shadowBlurY", ShadowBlur);
	}
	if(ShadowThickness != DefaultShadowThickness)
	{
		ShadowStyle = "s{" $ ShadowThickness $ ",0}{0," $ ShadowThickness $ "}{" $ ShadowThickness $ "," $ ShadowThickness $ "}{" $ -1 * ShadowThickness $ ",0}{0," $ -1 * ShadowThickness $ "}{" $ -1 * ShadowThickness $ "," $ -1 * ShadowThickness $ "}{" $ ShadowThickness $ "," $ -1 * ShadowThickness $ "}{" $ -1 * ShadowThickness $ "," $ ShadowThickness $ "}t{0,0}";
		MC.ChildSetString("textField", "shadowStyle", ShadowStyle);
	}
	if(ShadowStrength != DefaultShadowStrength)
	{
		MC.ChildSetNum("textField", "shadowStrength", ShadowStrength);
	}
	//if(ShadowAlpha != DefaultShadowAlpha)
	//{
		MC.ChildSetNum("textField", "shadowAlpha", ShadowAlpha);
	//}

}

simulated function HideShadow()
{
	MC.FunctionVoid("clearShadow");
}

defaultproperties
{
	LibID = "XComScrollingTextField";
	bIsNavigable = false;

	height = 32; // default text height

	bAnimateOnInit = false;

	DefaultShadowColor = 3552822;
	DefaultShadowStrength = 0.0;
	DefaultShadowThickness = 2;
	DefaultShadowAlpha = 0.5;
	DefaultShadowBlur = 1.0;

}