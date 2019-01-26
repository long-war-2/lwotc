//----------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIListItemString_SelfContained.uc
//  AUTHOR:  Amineri
//  PURPOSE: Basic List item control -- used for inserting list items with their own callback controls
//
//  NOTE: Unlike Parent, ButtonBG cah have own mouse handler defined, instead of through parent list
//
//----------------------------------------------------------------------------
//  Copyright (c) 2014 Firaxis Games, Inc. All rights reserved.
//----------------------------------------------------------------------------


class UIListItemString_SelfContained extends UIListItemString;

// mouse callbacks
delegate OnClickedDelegate(UIButton Button);

function SetButtonBGClickHander(delegate<OnClickedDelegate> InitOnClicked)
{
	ButtonBG.OnClickedDelegate = InitOnClicked;
}
