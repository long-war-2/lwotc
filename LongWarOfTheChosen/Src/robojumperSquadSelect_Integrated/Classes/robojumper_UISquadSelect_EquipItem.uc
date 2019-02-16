// this is a shared and alternative approach to the way equipment is presented on the squad select screen
// these are all items that aren't "small". Small item slots use robojumper_UISquadSelect_UtilityItem, those are Utility Item Slots, Grenade Pockets and Ammo Pockets
class robojumper_UISquadSelect_EquipItem extends UIPanel;

//m_strInventoryLabels

var EInventorySlot InvSlot;

var UIList List;
var UIPanel ButtonBG;
var UIPanel WeaponImageParent;
var array<UIImage> WeaponImages;
var array<UIIcon> WeaponUpgradeIcons;
var UIScrollingText EquipmentText;
var UIText SlotText;
var UIMask ImageMask;



var array<string> strImagePaths;
var array<string> strCategoryImages;
var array<string> WeaponUpgradeNames;
var array<string> WeaponUpgradeDescs;

var string strItemText;
var bool bDisabled;

var StateObjectReference ItemStateRef;

// Override InitPanel to run important listItem specific logic
simulated function UIPanel InitPanel(optional name InitName, optional name InitLibID)
{
	super.InitPanel(InitName, InitLibID);

	List = UIList(GetParent(class'UIList', true)); // list items must be owned by UIList.ItemContainer
	if(List == none || List.bIsHorizontal)
	{
		ScriptTrace();
	}

	SetWidth(List.width);
	// for consistency, our panel is an EmptyControl without a default height
	MC.FunctionNum("setHeight", Height);

	ButtonBG = Spawn(class'UIPanel', self);
	ButtonBG.bAnimateOnInit = false;
	ButtonBG.bIsNavigable = false;
	ButtonBG.InitPanel('', 'X2Button');
	//ButtonBG.InitPanel('', 'X2BackgroundSimple');
	ButtonBG.SetSize(Width, Height);
	// we don't have a flash control so our BG has to raise mouse events
	ButtonBG.ProcessMouseEvents(OnChildMouseEvent);
	// only exists to give the mask a good control to mask
	WeaponImageParent = Spawn(class'UIPanel', self);
	WeaponImageParent.bIsNavigable = false;
	WeaponImageParent.bAnimateOnInit = false;
	WeaponImageParent.InitPanel();
	WeaponImageParent.SetAlpha(0.5);

	SpawnWeaponImages(1);

	ImageMask = Spawn(class'UIMask', self);
	ImageMask.bAnimateOnInit = false; // no idea if neccessary
	ImageMask.InitMask('', WeaponImageParent);
	ImageMask.SetPosition(2, 2);
	ImageMask.SetSize(Width - 4, Height - 4);
	
	EquipmentText = Spawn(class'UIScrollingText', self);
	EquipmentText.bAnimateOnInit = false;
	EquipmentText.InitScrollingText();
	EquipmentText.SetPosition(10, 0);
	// prevent text from spilling into the next list item
	EquipmentText.SetWidth(Width - 20);
	
	SlotText = Spawn(class'UIText', self);
	SlotText.bAnimateOnInit = false;
	SlotText.InitText();
	SlotText.SetPosition(10, 22);
	SlotText.SetPanelScale(0.7);

	return self;
}

simulated function SpawnWeaponImages(int num)
{
	local int i;
	
/*	if (InvSlot == eInvSlot_PrimaryWeapon)
		WeaponImageParent.SetAlpha(1);
	else
		WeaponImageParent.SetAlpha(0.6);
*/	
	for (i = 0; i < num; i++)
	{
		if (i == WeaponImages.Length)
		{
			WeaponImages.AddItem(Spawn(class'UIImage', WeaponImageParent));
			WeaponImages[i].bAnimateOnInit = false;
			WeaponImages[i].InitImage('');
		}
		// haxhaxhax -- primary weapons are bigger than the others, which is normally handled by the image stack
		// but we need to do it manually
		if (InvSlot == eInvSlot_PrimaryWeapon)
		{
			WeaponImages[i].SetPosition(102, -24);
			WeaponImages[i].SetSize(192, 96);

		}
		else
		{
			WeaponImages[i].SetPosition(70, -40);
			WeaponImages[i].SetSize(256, 128);
		}
		WeaponImages[i].Show();
	}
	for (i = num; i < WeaponImages.Length; i++)
	{
		WeaponImages[i].Hide();
	}
}

simulated function SpawnUpgradeIcons(int num)
{
	local int i;
	
	for (i = 0; i < num; i++)
	{
		if (i == WeaponUpgradeIcons.Length)
		{
			WeaponUpgradeIcons.AddItem(Spawn(class'UIIcon', self));
			WeaponUpgradeIcons[i].bIsNavigable = false;
			WeaponUpgradeIcons[i].bAnimateOnInit = false;
			WeaponUpgradeIcons[i].InitIcon('');
			WeaponUpgradeIcons[i].bDisableSelectionBrackets = true;
			WeaponUpgradeIcons[i].SetSize(20, 20);
			WeaponUpgradeIcons[i].SetPosition(width - 25 - ((i / 2) * 23), 1 + ((i % 2) * 23));
			WeaponUpgradeIcons[i].OnClickedDelegate = OnClickedUpgradeIcon;
		}
		WeaponUpgradeIcons[i].Show();
	}
	for (i = num; i < WeaponUpgradeIcons.Length; i++)
	{
		WeaponUpgradeIcons[i].Hide();
	}
}

// this acts as init and refresh
// Item.ObjectID == 0 <==> we are empty
simulated function robojumper_UISquadSelect_EquipItem InitEquipItem(EInventorySlot inInvSlot, optional StateObjectReference Item, optional bool bLocked)
{
	// we need: an image, and a string
	local XComGameState_Item TheItem;
	
	bDisabled = bLocked;
	InvSlot = inInvSlot;

	strItemText = "";

	ItemStateRef = Item;
	strImagePaths.Length = 0;
	strCategoryImages.Length = 0;
	if (Item.ObjectID > 0)
	{
		TheItem = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(Item.ObjectID));
		strItemText = TheItem.GetMyTemplate().GetItemFriendlyName(Item.ObjectID);
		if (class'robojumper_SquadSelectConfig'.static.ShowBGImages())
		{
			strImagePaths = TheItem.GetWeaponPanelImages();
		}
		if (class'robojumper_SquadSelectConfig'.static.ShowWeaponUpgradeIcons())
		{
			strCategoryImages.Length = 0;
			WeaponUpgradeNames.Length = 0;
			WeaponUpgradeDescs.Length = 0;
			GetUpgradeInfo(TheItem, InvSlot, strCategoryImages, WeaponUpgradeNames, WeaponUpgradeDescs);
		}
	}

//	strItemText = "<font color='#e69831'><b>The Weapon</b></font>";
//	strImagePath = "img:///UILibrary_Common.ConvCannon.ConvCannon_Base";
	if (!bIsInited)
	{
		InitPanel();
	}
	
	PopulateData();

	return self;
}

// one icon per upgrade!
simulated function GetUpgradeInfo(XComGameState_Item Item, EInventorySlot inInvSlot, out array<string> Images, out array<string> Names, out array<string> Descs)
{
	local int i, j, totalslots, filledimages;
	local array<X2WeaponUpgradeTemplate> Upgrades;
	local string strBest;
	Upgrades = Item.GetMyWeaponUpgradeTemplates();
	for (i = 0; i < Upgrades.Length; i++)
	{
		strBest = "";
		if (Upgrades[i] != none)
		{
			for (j = 0; j < Upgrades[i].UpgradeAttachments.Length; j++)
			{
				if (Upgrades[i].UpgradeAttachments[j].InventoryCategoryIcon != "")
				{
					if (Upgrades[i].UpgradeAttachments[j].ApplyToWeaponTemplate == Item.GetMyTemplateName())
					{
						strBest = Upgrades[i].UpgradeAttachments[j].InventoryCategoryIcon;
						break; // j-loop
					}
					// fallback for when attachments don't have them properly set up for certain weapons
					strBest = Upgrades[i].UpgradeAttachments[j].InventoryCategoryIcon;
				}
			}
			if (strBest == "")
			{
				// indicate missing one by highlighting, grimy's loot mod tends to not have them be set up properly
				strBest = "img:///UILibrary_robojumperSquadSelect.implants_available";
			}
		}
		if (strBest == "")
		{
			// we don't have an upgrade there, show empty
			strBest = class'UIUtilities_Image'.const.PersonalCombatSim_Empty;
		}
		Images.AddItem(strBest);
		Names.AddItem(Upgrades[i].GetItemFriendlyName());
		Descs.AddItem(Item.GetUpgradeEffectForUI(Upgrades[i]));
		
	}
	// empty slots, but only if we are primary or the user wants to explicitely see them
	if (inInvSlot == eInvSlot_PrimaryWeapon || !class'robojumper_SquadSelectConfig'.static.DontShowSecondaryUpgradeIconsAvailable())
	{
		// keep in sync with UIArmory_WeaponUpgrade.UpdateSlots(). Thanks Firaxis
		totalslots = 0;
		if (X2WeaponTemplate(Item.GetMyTemplate()) != none)
		{
			totalSlots = X2WeaponTemplate(Item.GetMyTemplate()).NumUpgradeSlots;
			// this is not checked in UIArmory_WeaponUpgrade but in UIArmory_MainMenu essentially (via UIUtilities_Strategy.GetWeaponUpgradeAvailability())
			if (totalSlots > 0)
			{
				if (`XCOMHQ.bExtraWeaponUpgrade)
				{
					totalSlots++;
				}
				if (`XCOMHQ.ExtraUpgradeWeaponCats.Find(X2WeaponTemplate(Item.GetMyTemplate()).WeaponCat) != INDEX_NONE)
				{
					totalSlots++;
				}
			}
		}
		filledimages = Images.Length;
		for (i = 0; i < totalslots - filledimages; i++)
		{
			Images.AddItem(class'UIUtilities_Image'.const.PersonalCombatSim_Empty);
			Names.AddItem("");
			Descs.AddItem("");
		}
	}
}

simulated function PopulateData()
{
	local int i;
	UpdateTexts();
	if (!bDisabled)
	{
		ButtonBG.MC.FunctionVoid("enable");
	}
	else
	{
		ButtonBG.MC.FunctionVoid("disable");
	}
	SpawnWeaponImages(strImagePaths.Length);
	for (i = strImagePaths.Length - 1; i >= 0; i--)
	{
		WeaponImages[i].LoadImage(strImagePaths[i]);
	}
	SpawnUpgradeIcons(strCategoryImages.Length);
	for (i = 0; i < strCategoryImages.Length; i++)
	{
		WeaponUpgradeIcons[i].LoadIcon(strCategoryImages[i]);
		if (WeaponUpgradeIcons[i].bHasTooltip)
		{
			WeaponUpgradeIcons[i].RemoveTooltip();
		}
		WeaponUpgradeIcons[i].SetTooltipText(WeaponUpgradeDescs[i], WeaponUpgradeNames[i]);
	}
	// don't have the text go behind the icons
	EquipmentText.SetWidth(Width - 10 - ((FCeil(float(strCategoryImages.Length) / 2.0)) * 25));
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
	EquipmentText.SetText(AddAppropriateColor(strItemText));
	SlotText.SetSubTitle(AddAppropriateColor(class'UIArmory_loadout'.default.m_strInventoryLabels[InvSlot]));	
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
		UIArmory_Loadout(Movie.Stack.GetScreen(class'UIArmory_Loadout')).SelectItemSlot(InvSlot, 0);
	}
}

simulated function OnClickedUpgradeIcon()
{
	if (`XCOMHQ.bModularWeapons)
	{
		UISquadSelect_ListItem(GetParent(class'UISquadSelect_ListItem', true)).SetDirty(true, true);
		UISquadSelect(Screen).SnapCamera();
		SetTimer(0.1f, false, nameof(GoToUpgradeScreen));
	}
}

simulated function GoToUpgradeScreen()
{
	if (!bDisabled)
	{
		`HQPRES.UIArmory_WeaponUpgrade(ItemStateRef);
	}
}

simulated function AnimateIn(optional float Delay = -1.0)
{
	WeaponImageParent.AddTweenBetween("_alpha", 0, WeaponImageParent.Alpha, class'UIUtilities'.const.INTRO_ANIMATION_TIME, Delay);
	WeaponImageParent.AddTweenBetween("_x", WeaponImageParent.X + 50, WeaponImageParent.X, class'UIUtilities'.const.INTRO_ANIMATION_TIME * 2, Delay, "easeoutquad");
	
	EquipmentText.AddTweenBetween("_alpha", 0, EquipmentText.Alpha, class'UIUtilities'.const.INTRO_ANIMATION_TIME, Delay);
	SlotText.AddTweenBetween("_alpha", 0, SlotText.Alpha, class'UIUtilities'.const.INTRO_ANIMATION_TIME, Delay);
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


simulated function SetNavigatorFocus()
{
	robojumper_UISquadSelect_ListItem(GetParent(class'robojumper_UISquadSelect_ListItem', true)).SetSelectedNavigation();
	List.SetSelectedItem(self);
}

defaultproperties
{
	height=48
	bAnimateOnInit=false
}