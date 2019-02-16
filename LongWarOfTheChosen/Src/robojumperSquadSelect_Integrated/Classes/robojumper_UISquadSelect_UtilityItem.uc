// for utility items (and ammo/grenade pockets) we don't need to waste that much space and clutter it with text
// however, it's integrated into the normal UIList, which means we need some hackery to make UIList organize it properly
// namingly, our height is 0 unless we are the last item in our row
// and our x is set manually, which prevents UIList from manually fucking things up
// ammo / grenade pockets are highlighted using some kind of frame
class robojumper_UISquadSelect_UtilityItem extends UIPanel;

var EInventorySlot InvSlot;
var int SlotIndex;

var UIList List;


var UIPanel ButtonBG;
var UIImage ItemImage;
var UIText SlotText; // if we are a grenade pocket, we show a G, ammo pocket: A (or whatever the localized equivalent is)

// math!
var int rowIndex, rowTotal;

var string strImagePath;
var bool bDisabled;

var StateObjectReference ItemStateRef;


var int trueHeight;
var int listWidth;

// Override InitPanel to run important listItem specific logic
simulated function UIPanel InitPanel(optional name InitName, optional name InitLibID)
{
	super.InitPanel(InitName, InitLibID);

	List = UIList(GetParent(class'UIList', true)); // list items must be owned by UIList.ItemContainer
	if(List == none || List.bIsHorizontal)
	{
		ScriptTrace();
	}

	listWidth = List.width;

	ButtonBG = Spawn(class'UIPanel', self);
	ButtonBG.bAnimateOnInit = false;
	ButtonBG.bIsNavigable = false;
	ButtonBG.InitPanel('', 'X2Button');
	//ButtonBG.InitPanel('', 'X2BackgroundSimple');
	ButtonBG.SetSize(Width, Height);
	// we don't have a flash control so our BG has to raise mouse events
	ButtonBG.ProcessMouseEvents(OnChildMouseEvent);
	
	ItemImage = Spawn(class'UIImage', self).InitImage('');
	ItemImage.bAnimateOnInit = false;
	ItemImage.OriginCenter();

	SlotText = Spawn(class'UIText', self);
	SlotText.bAnimateOnInit = false;
	SlotText.InitText().SetPosition(Width - 10, 0);


	return self;
}

simulated function RealizeLayout()
{
	if (rowTotal <= 0)
	{
		// Now allowed
		//`REDSCREEN("RealizeLayout called without having been inited properly");
		return;
	}
	SetX(listWidth * rowIndex / rowTotal);
	// everything that affects scaling does not get propagated to flash!
	// we don't want everything to get scaled!
	SetWidth(listWidth / rowTotal);
	ItemImage.SetScale(FMin(0.25, 0.33 - (rowTotal * 0.04)));// (rowTotal > 2 ? 0.21 : 0.25);

}


// don't send stuff across the wire
simulated function SetHeight(float NewHeight)
{
//	Height = NewHeight;
  	SetSize(Width, NewHeight);
}

simulated function SetWidth(float NewWidth)
{
	SetSize(NewWidth, trueHeight);
}

simulated function UIPanel SetSize(float NewWidth, float NewHeight)
{
	Width = NewWidth;
	trueHeight = NewHeight;
	if (rowTotal != -1 && rowIndex == rowTotal - 1)
	{
		Height = trueHeight;
	}
	else
	{
		Height = 0;
	}
	ButtonBG.SetSize(Width, trueHeight);
	ItemImage.SetPosition(Width / 2, trueHeight / 2);
	List.OnItemSizeChanged(self);
	SlotText.SetX(Width - 20);
	return self;
}

simulated function PopulateData()
{
	ItemImage.LoadImage(strImagePath);
	if (!bDisabled)
	{
		ButtonBG.MC.FunctionVoid("enable");
	}
	else
	{
		ButtonBG.MC.FunctionVoid("disable");
	}
	UpdateTexts();
	
}

// this acts as init and refresh
// Item.ObjectID == 0 <==> we are empty
simulated function robojumper_UISquadSelect_UtilityItem InitUtilityItem(EInventorySlot inInvSlot, optional StateObjectReference Item, optional bool bLocked, optional int Index, optional int inRowIndex, optional int maxThisRow)
{
	// we need: an image, and a string
	local XComGameState_Item TheItem;
	local array<string> Images;
	
	bDisabled = bLocked;
	InvSlot = inInvSlot;
	SlotIndex = Index;

	ItemStateRef = Item;
	strImagePath = "";
	if (Item.ObjectID > 0)
	{
		TheItem = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(Item.ObjectID));
		Images = TheItem.GetWeaponPanelImages();
		strImagePath = Images[0]; // TODO
	}
	else if (bDisabled)
	{
		strImagePath = class'UIUtilities_Image'.const.SquadSelect_LockedUtilitySlot;
	}

	if (!bIsInited)
	{
		InitPanel();
	}
	SetLayoutInfo(inRowIndex, maxThisRow);
	PopulateData();

	return self;
}

simulated function SetLayoutInfo(optional int inRowIndex, optional int maxThisRow)
{
	rowIndex = inRowIndex;
	rowTotal = maxThisRow;
	RealizeLayout();
}

simulated function OnChildMouseEvent(UIPanel control, int cmd)
{
	switch( cmd )
	{
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_IN:
		OnReceiveFocus();
		SetNavigatorFocus();
		break;
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT:
		OnLoseFocus();
		break;
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_UP:
		OnClick();
		break;
	}
}

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	local bool bHandled;

	if ( !CheckInputIsReleaseOrDirectionRepeat(cmd, arg) )
		return false;
	
	bHandled = true;
	switch (cmd)
	{
		case class'UIUtilities_Input'.const.FXS_KEY_ENTER:
		case class'UIUtilities_Input'.const.FXS_BUTTON_A:
		case class'UIUtilities_Input'.const.FXS_KEY_SPACEBAR:
			OnClick();
			break;
		default:
			bHandled = false;
			break;
	}

	return bHandled || Navigator.OnUnrealCommand(cmd, arg);
}

function string AddAppropriateColor(string InString)
{
	local string strColor;
	
	if (bDisabled)
		strColor = class'UIUtilities_Colors'.const.DISABLED_HTML_COLOR;
	else if (ItemStateRef.ObjectID == 0)
		strColor = class'UIUtilities_Colors'.const.WARNING_HTML_COLOR;
	else if (bIsFocused)
		strColor = class'UIUtilities_Colors'.const.BLACK_HTML_COLOR;
	else
		strColor = class'UIUtilities_Colors'.const.NORMAL_HTML_COLOR;
		
	return "<font color='#" $ strColor $ "'>" $ InString $ "</font>";
}

function UpdateTexts()
{
	SlotText.SetSubTitle(AddAppropriateColor(GetSpecialSlotText()));
}

simulated function AnimateIn(optional float Delay = -1.0)
{
	ItemImage.AddTweenBetween("_alpha", 0, ItemImage.Alpha, class'UIUtilities'.const.INTRO_ANIMATION_TIME, Delay);
	SlotText.AddTweenBetween("_alpha", 0, SlotText.Alpha, class'UIUtilities'.const.INTRO_ANIMATION_TIME, Delay);
}


simulated function OnReceiveFocus()
{
	super.OnReceiveFocus();
	UpdateTexts();
}

simulated function OnLoseFocus()
{
	super.OnLoseFocus();
	UpdateTexts();
}

simulated function SetNavigatorFocus()
{
	robojumper_UISquadSelect_ListItem(GetParent(class'robojumper_UISquadSelect_ListItem', true)).SetSelectedNavigation();
	List.SetSelectedItem(self);
}

simulated function OnClick()
{
	UISquadSelect_ListItem(GetParent(class'UISquadSelect_ListItem', true)).SetDirty(true, true);
	UISquadSelect(Screen).SnapCamera();
	SetTimer(0.1f, false, nameof(GoToUtilityItem));
}

simulated function GoToUtilityItem()
{
	`HQPRES.UIArmory_Loadout(UISquadSelect_ListItem(GetParent(class'UISquadSelect_ListItem', true)).GetUnitRef(), UISquadSelect_ListItem(GetParent(class'UISquadSelect_ListItem', true)).CannotEditSlots);
	if (!bDisabled)
	{
		UIArmory_Loadout(Movie.Stack.GetFirstInstanceOf(class'UIArmory_Loadout')).SelectItemSlot(InvSlot, SlotIndex);
	}
}

simulated function string GetSpecialSlotText()
{
	switch (InvSlot)
	{
		case eInvSlot_AmmoPocket:
			return GetAmmoLetter();
		case eInvSlot_GrenadePocket:
			return GetGrenadeLetter();
		default:
			if (class'robojumper_SquadSelectConfig'.static.IsCHHLMinVersionInstalled(1, 6))
			{
				if (class'CHItemSlot'.static.SlotIsTemplated(InvSlot))
				{
					return class'CHItemSlot'.static.GetTemplateForSlot(InvSlot).GetDisplayLetter();
				}
			}
			return "";
	}
}

simulated function string GetGrenadeLetter()
{
	switch (GetLanguage())
	{
		case "DEU":
		case "ESN":
		case "FRA":
		case "INT":
		case "ITA":
		case "POL":
		default:
			return "G";
	}
}

simulated function string GetAmmoLetter()
{
	switch (GetLanguage())
	{
		case "DEU":
		case "ESN":
		case "FRA":
		case "ITA":
			return "M"; // munition etc.
		case "INT":
		case "POL":
		default:
			return "A"; // ammunition etc.
	}
}

defaultproperties
{
	bAnimateOnInit=false
	trueHeight=72
	rowIndex=-1
	rowTotal=-1
}