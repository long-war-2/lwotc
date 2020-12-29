//----------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIVerticalScrollingText2.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: UIText control for vertical scrolling text.
//----------------------------------------------------------------------------

class UIVerticalScrollingText2 extends UIPanel;

`include(LW_PerkPack_Integrated\LW_PerkPack.uci)

// UIText member variables
var protectedwrite UIBGBox  	bg;
var protectedwrite UIText       text;
var protectedwrite UIMask       mask;
var protectedwrite UIScrollbar	scrollbar;

var private int						scrollbarPadding;
var private int						bgPadding;
var private bool					bAutoScroll; 

simulated function UIVerticalScrollingText2 InitVerticalScrollingText(optional name InitName, optional string initText,
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
		bg.ProcessMouseEvents(OnChildMouseEvent);
	}

	bAutoScroll = true; 

	text = Spawn(class'UIText', self).InitText('text', initText, true);
	text.onTextSizeRealized = RealizeTextSize;
	//text.OnMouseEventDelegate = OnChildMouseEvent;
	//text.ProcessMouseEvents(OnChildMouseEvent);

	SetPosition(initX, initY);
	SetSize(initWidth, initHeight);
	
	// text starts off hidden, show after text sizing information is obtained
	text.Hide();

	`PPTRACE("Scrolling Text (Init): Y = " $ text.y);

	return self;
}

simulated function UIVerticalScrollingText2 SetText(string txt)
{
	local int textPosOffset;

	text.ClearScroll();
	// KDM : If there is no background then there should be no text offset; this is exactly
	// what is done within RealizeTextSize.
	// Within Flash, once scrolling completes, the Y value of the UIText is reverted
	// to the value it was at, when AnimateScroll was called on it. In practical terms,
	// the text would appear lower than it should when a new 'scroll cycle' started.
	if (bg != none)
	{
		textPosOffset = bgPadding * 0.5;
	}
	else
	{
		textPosOffset = 0;
	}
	text.SetPosition(textPosOffset , textPosOffset );
	text.SetText(txt);
	`PPTRACE("Scrolling Text (SetText): Y = " $ text.y);
	return self;
}

simulated function UIVerticalScrollingText2 SetHTMLText(string txt)
{
	local int textPosOffset;

	text.ClearScroll();
	// KDM : If there is no background then there should be no text offset !
	// The reasoning is described within SetText.
	if (bg != none)
	{
		textPosOffset = bgPadding * 0.5;
	}
	else
	{
		textPosOffset = 0;
	}
	text.SetPosition(textPosOffset, textPosOffset);
	text.SetHTMLText(txt);
	`PPTRACE("Scrolling Text (SetHtmlText): Y = " $ text.y);
	return self;
}

// Sizing this control really means sizing its mask
simulated function SetWidth(float newWidth)
{
	if(width != newWidth)
	{
		width = newWidth;
		text.SetWidth(newWidth);

		if(mask != none && scrollbar != none)
		{
			mask.SetWidth(width);
			scrollbar.SnapToControl(mask);
		}
	}
	`PPTRACE("Scrolling Text (SetWidth): Y = " $ text.y);
}
simulated function SetHeight(float newHeight)
{
	if(height != newHeight)
	{
		height = newHeight;
		//text.SetHeight(newHeight);  // don't set height, so that text isn't clipped

		if(mask != none && scrollbar != none)
		{
			mask.SetHeight(height);
			scrollbar.SnapToControl(mask);
		}
	}
	`PPTRACE("Scrolling Text (SetHeight): Y = " $ text.y);
}
simulated function UIPanel SetSize(float newWidth, float newHeight)
{
	SetWidth(newWidth);
	SetHeight(newHeight);
	`PPTRACE("Scrolling Text (SetSize): Y = " $ text.y);
	return self;
}

simulated private function RealizeTextSize()
{
	local int textPosOffset, textSizeOffset;

	if (bg != none)
	{
		textPosOffset = bgPadding * 0.5;
		textSizeOffset = bgPadding;
	}
	else
	{
		textPosOffset = 0;
		textSizeOffset = 0;
	}
	`PPTRACE("Scrolling Text (RealizeTextSize - Start): Y = " $ text.y);

	text.ClearScroll();
	if(text.Height > height)
	{
		if(mask == none)
		{
			mask = Spawn(class'UIMask', self).InitMask();
		}
		mask.SetMask(text);
		mask.SetSize(width - textSizeOffset, height - textSizeOffset);
		mask.SetPosition(textPosOffset, textPosOffset);


		if( bAutoScroll )
		{
			text.AnimateScroll( text.Height + bgpadding, height);
		}
		else
		{
			if(scrollbar == none)
			{
				scrollbar = Spawn(class'UIScrollbar', self).InitScrollbar();
			}
			scrollbar.SnapToControl(mask, -scrollbarPadding);
			scrollbar.NotifyPercentChange(text.SetScroll); 
			textSizeOffset += scrollbarPadding;
		}
	}
	else if(mask != none)
	{
		mask.Remove();
		mask = none;

		if(scrollbar != none)
		{
			scrollbar.Remove();
			scrollbar = none;
		}
	}

	// offset text size and location by the bg offset
	text.SetWidth(width - textSizeOffset);
	text.SetPosition(textPosOffset, textPosOffset);
	text.Show();
	`PPTRACE("Scrolling Text (RealizeTextSize - End): Y = " $ text.y);
}

simulated function OnChildMouseEvent( UIPanel control, int cmd )
{
	if(scrollbar != none && cmd == class'UIUtilities_Input'.const.FXS_MOUSE_SCROLL_UP)
		scrollbar.OnMouseScrollEvent(-1);
	else if(scrollbar != none && cmd == class'UIUtilities_Input'.const.FXS_MOUSE_SCROLL_DOWN)
		scrollbar.OnMouseScrollEvent(1);
}

defaultproperties
{
	bIsNavigable = false;
	scrollbarPadding = 20;
	bgPadding = 20;
}
