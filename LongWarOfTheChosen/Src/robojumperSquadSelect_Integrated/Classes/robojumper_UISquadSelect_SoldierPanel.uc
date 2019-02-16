// this is the bottom soldier panel with name, nick, class, rank and two buttons
class robojumper_UISquadSelect_SoldierPanel extends UIPanel config(robojumperSquadSelect);

struct ExtraCharacterData
{
	var name CharacterTemplateName;
	var string ClassIconPath;
};

var UIList List;
var UIPanel BGBox;
var UIText ClassText;
var UIText RankText;
var UIText NickText;
var UIText NameText;

var UIText HealthText;

// the images are all around the class image, and this panel is the parent of all of them to have less magic numbers
var UIPanel ImageAnchor;
var UIImage ClassImage;
var UIImage RankImage;
// clickable
var UIImage PromoteImage;
var UIImage ImplantsImage;

// remove soldier button
var int iRightButtonWidth;
var UIPanel RemoveButton;
var UIImage DismissImage;
var UIImage ControllerButtonImage;

var UIBondIcon BondIcon;

var config array<ExtraCharacterData> CharData;

// Override InitPanel to run important listItem specific logic
simulated function UIPanel InitPanel(optional name InitName, optional name InitLibID)
{
	local int removeIconSize;
	super.InitPanel(InitName, InitLibID);

	List = UIList(GetParent(class'UIList')); // list items must be owned by UIList.ItemContainer
	if(List == none || List.bIsHorizontal)
	{
		ScriptTrace();
	}

	SetWidth(List.width);
	// for consistency, our panel is an EmptyControl without a default height
	MC.FunctionNum("setHeight", Height);

	BGBox = Spawn(class'UIPanel', self);
	BGBox.bAnimateOnInit = false;
	// our bg raises mouse events, but is not navigable
	BGBox.bIsNavigable = false;
	BGBox.InitPanel('', 'X2BackgroundSimple');
	BGBox.SetSize(Width, Height);
	// we don't have a flash control so our BG has to raise mouse events
	BGBox.ProcessMouseEvents(OnBGMouseEvent);
	SetBGColor(bIsFocused);

	ImageAnchor = Spawn(class'UIPanel', self);
	ImageAnchor.bAnimateOnInit = false;
	ImageAnchor.InitPanel().SetPosition(8, 14);

	ClassImage = Spawn(class'UIImage', ImageAnchor);
	ClassImage.bAnimateOnInit = false;
	ClassImage.InitImage('');
	ClassImage.SetSize(64, 64);

	RankImage = Spawn(class'UIImage', ImageAnchor);
	RankImage.bAnimateOnInit = false;
	RankImage.InitImage('');
	RankImage.SetPosition(32, 0);
	RankImage.SetSize(32, 32);

	PromoteImage = Spawn(class'UIImage', ImageAnchor);
	PromoteImage.bAnimateOnInit = false;
	PromoteImage.InitImage('', "img:///gfxAlerts.promote_icon", OnPromoteClicked);
	PromoteImage.SetPosition(4, 4);
	PromoteImage.SetSize(24, 24);
	PromoteImage.Hide();

	// can't make PCS clickable, since the PCS screen requires the armory main menu to be in the stack (that's where it gets the unit from)
	ImplantsImage = Spawn(class'UIImage', ImageAnchor);
	ImplantsImage.bAnimateOnInit = false;
	ImplantsImage.InitImage();
	ImplantsImage.SetSize(24, 24);
	ImplantsImage.SetPosition(4, 36);
	ImplantsImage.Hide();


	ClassText = Spawn(class'UIText', self);
	ClassText.bAnimateOnInit = false;
	ClassText.InitText();
	ClassText.SetPosition(8, 70);

	NickText = Spawn(class'UIText', self);
	NickText.bAnimateOnInit = false;
	NickText.InitText();
	NickText.SetPosition(70, 44);

	NameText = Spawn(class'UIText', self);
	NameText.bAnimateOnInit = false;
	NameText.InitText();
	NameText.SetPosition(70, 22);

	RankText = Spawn(class'UIText', self);
	RankText.bAnimateOnInit = false;
	RankText.InitText();
	RankText.SetPosition(70, 2);

	HealthText = Spawn(class'UIText', self);
	HealthText.bAnimateOnInit = false;
	HealthText.InitText();
	HealthText.SetY(70);

	HealthText.SetWidth(width);


	RemoveButton = Spawn(class'UIPanel', self);
	RemoveButton.bIsNavigable = false;
	RemoveButton.bAnimateOnInit = false;
	RemoveButton.InitPanel('', 'X2Button');

	RemoveButton.SetX(width * 2.0f / 3.0f);
	RemoveButton.SetSize(width / 3.0f, 24);

	RemoveButton.ProcessMouseEvents(OnRemoveButtonMouseEvent);
	DismissImage = Spawn(class'UIImage', RemoveButton);
	DismissImage.bAnimateOnInit = false;
	DismissImage.InitImage('', "img:///UILibrary_robojumperSquadSelect.55");

	removeIconSize = Min(RemoveButton.Width, RemoveButton.Height) / 1.5f;

	DismissImage.SetSize(removeIconSize, removeIconSize);
	DismissImage.SetY((RemoveButton.Height - removeIconSize) / 2);

	ControllerButtonImage = Spawn(class'UIImage', RemoveButton);
	ControllerButtonImage.bAnimateOnInit = false;
	ControllerButtonImage.InitImage('', "img:///gfxComponents." $ class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_Y_TRIANGLE);
	ControllerButtonImage.SetSize(removeIconSize, removeIconSize);
	ControllerButtonImage.SetY((RemoveButton.Height - removeIconSize) / 2);
	ControllerButtonImage.Hide();

	RealizeDismissImageState();

	BondIcon = Spawn(class'UIBondIcon', self).InitBondIcon('bondIconMC', , OnClickBondIcon);
	BondIcon.SetPanelScale(0.5);
	BondIcon.SetPosition(Width - BondIcon.Width / 2, 26);

	return self;
}

simulated function UpdateData(bool bDisableEdit, bool bDisableDismiss)
{
	local XComGameState_Unit Unit;
	local string NameStr;
	local int Health, MaxHealth;
	local string strStatLabel;
	local int Will, MaxWill;
	local EUIState WillState;
	local SoldierBond BondData;
	local StateObjectReference BondmateRef;
	local TPCSAvailabilityData PCSAvailabilityData;
	local array<XComGameState_Item> EquippedImplants;

	Unit = GetUnit();

	if (Unit != none)
	{
		NameStr = Unit.GetName(eNameType_Last);
		if (NameStr == "") // If the unit has no last name, display their first name instead
		{
			NameStr = Unit.GetName(eNameType_First);
		}
		class'robojumper_SquadSelect_Helpers'.static.GetCurrentAndMaxStatForUnit(Unit, eStat_HP, Health, MaxHealth);
		class'robojumper_SquadSelect_Helpers'.static.GetCurrentAndMaxStatForUnit(Unit, eStat_Will, Will, MaxWill);

		class'UIUtilities_Strategy'.static.GetPCSAvailability(Unit, PCSAvailabilityData);


		ClassImage.LoadImage(GetClassIcon(Unit));
		RankImage.LoadImage(GetRankIcon(Unit.GetRank(), Unit.GetSoldierClassTemplateName(), Unit));

		ClassText.SetText(class'UIUtilities_Text'.static.GetColoredText(class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(GetClassDisplayName(Unit)), eUIState_Faded));
		NickText.SetText(class'UIUtilities_Text'.static.GetColoredText(class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(Unit.GetName(eNameType_Nick)), eUIState_Header, 28));
		NameText.SetText(class'UIUtilities_Text'.static.GetColoredText(class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(NameStr), eUIState_Normal, 22));
		// this accounts for CH / LWHL changes to rank text
		RankText.SetText(class'UIUtilities_Text'.static.GetColoredText(class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(Unit.IsSoldier() ? Unit.GetName(eNameType_Rank) : ""), eUIState_Normal, 18));
		if (!class'robojumper_SquadSelectConfig'.static.ShouldShowStats())
		{
			strStatLabel = "H:" $ class'UIUtilities_Text'.static.GetColoredText(Health $"/"$ MaxHealth, (Health < MaxHealth) ? eUIState_Bad : eUIState_Normal, 22);
			if (class'robojumper_SquadSelect_Helpers'.static.UnitParticipatesInWillSystem(Unit))
			{
				if (float(Will) / float(MaxWill) < 0.33f)
					WillState = eUIState_Bad;
				else if (float(Will) / float(MaxWill) >= 0.67f)
					WillState = eUIState_Good;
				else
					WillState = eUIState_Warning;

				strStatLabel $= "; W:" $ class'UIUtilities_Text'.static.GetColoredText(Will $"/"$ MaxWill, WillState, 22);
			}
			HealthText.SetText(class'UIUtilities_Text'.static.AlignRight(strStatLabel));
		}
		PromoteImage.SetVisible(Unit.IsSoldier() && Unit.ShowPromoteIcon());
		if (PCSAvailabilityData.bHasGTS && PCSAvailabilityData.bHasAchievedCombatSimsRank && PCSAvailabilityData.bCanEquipCombatSims)
		{
			// our unit has the potential to equip PCS
			ImplantsImage.Show();
			EquippedImplants = Unit.GetAllItemsInSlot(eInvSlot_CombatSim);
			if (EquippedImplants.Length == 0)
			{
				ImplantsImage.LoadImage("img:///UILibrary_robojumperSquadSelect.implants_available");
			}
			else
			{
				ImplantsImage.LoadImage(class'UIUtilities_Image'.static.GetPCSImage(EquippedImplants[0]));
			}
		}
		else
		{
			// this unit couldn't equip PCS
			ImplantsImage.Hide();
		}

		RealizeDismissImageState();
		// Bond icon
		if(!Unit.IsSoldier() || !Unit.GetSoldierClassTemplate().bCanHaveBonds)
		{
			BondIcon.SetBondLevel(-1);
			BondIcon.RemoveTooltip();
		}
		else if( Unit.HasSoldierBond(BondmateRef, BondData) )
		{
			BondIcon.SetBondLevel(BondData.BondLevel, UISquadSelect(Screen).IsUnitOnSquad(BondmateRef));
			BondIcon.SetBondmateTooltip(BondmateRef);
		}
		else
		{
			BondIcon.SetBondLevel(0);
			if (Unit.HasSoldierBondAvailable(BondmateRef, BondData))
			{
				BondIcon.AnimateCohesion(true);
				BondIcon.SetTooltipText(class'XComHQPresentationLayer'.default.m_strBannerBondAvailable);
			}
			else
			{
				BondIcon.AnimateCohesion(false);
				BondIcon.SetTooltipText(class'UISoldierBondScreen'.default.BondTitle);
			}
		}
	}
}

static function string GetRankIcon(int iRank, name ClassName, XComGameState_Unit Unit)
{
	if (Unit.IsSoldier())
	{
		return class'UIUtilities_Image'.static.GetRankIcon(Unit.GetRank(), Unit.GetSoldierClassTemplateName());
	}
	else
	{
		return "";
	}
}

static function string GetClassIcon(XComGameState_Unit Unit)
{
	local int i;
	if (Unit.IsSoldier())
	{
		if (class'robojumper_SquadSelectConfig'.static.IsCHHLMinVersionInstalled(1, 5))
		{
			return Unit.GetSoldierClassIcon();
		}
		return Unit.GetSoldierClassTemplate().IconImage;
	}
	else
	{
		i = default.CharData.Find('CharacterTemplateName', Unit.GetMyTemplateName());
		if (i != INDEX_NONE)
		{
			return default.CharData[i].ClassIconPath;
		}
		return "";
	}
}

static function string GetClassDisplayName(XComGameState_Unit Unit)
{
	if (Unit.IsSoldier())
	{
		if (class'robojumper_SquadSelectConfig'.static.IsCHHLMinVersionInstalled(1, 5))
		{
			return Unit.GetSoldierClassDisplayName();
		}
		return Unit.GetSoldierClassTemplate().DisplayName;
	}
	else
	{
		return Unit.GetMyTemplate().strCharacterName;
	}
}

simulated function OnClickBondIcon(UIBondIcon Icon)
{
	local XComGameState_Unit UnitState;

	UnitState = GetUnit();

	if(UnitState.GetSoldierClassTemplate().bCanHaveBonds )
	{
		robojumper_UISquadSelect_ListItem(GetParent(class'robojumper_UISquadSelect_ListItem', true)).SetDirty(true);
		UISquadSelect(Screen).SnapCamera();
		SetTimer(0.1f, false, nameof(GoBond));
	}
}

simulated function GoBond()
{
	//We need an armory screen beneath the soldier bonds to handle the pawn. 
	`HQPRES.UIArmory_MainMenu(UISquadSelect(Screen).XComHQ.Squad[UISquadSelect(screen).m_iSelectedSlot]);
	`HQPRES.UISoldierBonds(GetUnit().GetReference());
}

simulated function SetBGColor(bool focused)
{
	BGBox.mc.FunctionString("gotoAndPlay", focused ? "cyan" : "gray");
}

simulated function OnReceiveFocus()
{
	super.OnReceiveFocus();
	SetBGColor(bIsFocused);
}

simulated function OnLoseFocus()
{
	super.OnLoseFocus();
	SetBGColor(bIsFocused);	
}

simulated function SetNavigatorFocus()
{
	robojumper_UISquadSelect_ListItem(GetParent(class'robojumper_UISquadSelect_ListItem', true)).SetSelectedNavigation();
}

simulated function XComGameState_Unit GetUnit()
{
	return robojumper_UISquadSelect_ListItem(GetParent(class'robojumper_UISquadSelect_ListItem', true)).GetUnit();
}


simulated function OnBGMouseEvent(UIPanel control, int cmd)
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
			robojumper_UISquadSelect_ListItem(GetParent(class'robojumper_UISquadSelect_ListItem', true)).OnClickedEditUnitButton();
			break;
	}
}


simulated function OnPromoteClicked(UIImage Image)
{
	robojumper_UISquadSelect_ListItem(GetParent(class'robojumper_UISquadSelect_ListItem', true)).OnClickedPromote();
}

simulated function OnDismissReceiveFocus()
{
	RemoveButton.OnReceiveFocus();
	RealizeDismissImageState();	
}

simulated function OnDismissLoseFocus()
{
	RemoveButton.OnLoseFocus();
	RealizeDismissImageState();	
}

simulated function RealizeDismissImageState()
{
	local bool bCanEdit;
	local bool bHorizontal;

	bCanEdit = !robojumper_UISquadSelect_ListItem(GetParent(class'robojumper_UISquadSelect_ListItem', true)).bDisabledEdit;

	DismissImage.SetColor((RemoveButton.bIsFocused && bCanEdit) ? class'UIUtilities_Colors'.const.BLACK_HTML_COLOR : class'UIUtilities_Colors'.const.NORMAL_HTML_COLOR);
	RemoveButton.MC.FunctionVoid(robojumper_UISquadSelect_ListItem(GetParent(class'robojumper_UISquadSelect_ListItem', true)).bDisabledDismiss ? "disable" : "enable");

	bHorizontal = RemoveButton.Width > RemoveButton.Height;

	if (`ISCONTROLLERACTIVE && GetParent(class'robojumper_UISquadSelect_ListItem', true).bIsFocused && bCanEdit)
	{
		ControllerButtonImage.Show();
		if (bHorizontal)
		{
			DismissImage.SetX((RemoveButton.Width - 2 * DismissImage.Width) / 2);
			ControllerButtonImage.SetX((RemoveButton.Width) / 2);
		}
		else
		{
			DismissImage.SetY((RemoveButton.Height - 2 * DismissImage.Height) / 2);
			ControllerButtonImage.SetY((RemoveButton.Height) / 2);
		}
	}
	else
	{
		if (ControllerButtonImage != none)
		{
			ControllerButtonImage.Hide();
		}

		if (bHorizontal)
		{
			DismissImage.SetX((RemoveButton.Width - DismissImage.Width) / 2);
		}
		else
		{
			DismissImage.SetY((RemoveButton.Height - DismissImage.Height) / 2);
		}
	}
}

simulated function OnRemoveButtonMouseEvent(UIPanel control, int cmd)
{
	switch( cmd )
	{
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_IN:
		OnDismissReceiveFocus();
		SetNavigatorFocus();
		break;
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT:
		OnDismissLoseFocus();
		break;
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_UP:
		robojumper_UISquadSelect_ListItem(GetParent(class'robojumper_UISquadSelect_ListItem', true)).OnClickedDismissButton();
		UISquadSelect(Screen).SignalOnReceiveFocus();
		break;
	}
}


defaultproperties
{
	height=96
	bAnimateOnInit=false
	// not navigable, handled by robojumper_UISquadSelect_ListItem
	bIsNavigable=false
	bCascadeFocus=false
	iRightButtonWidth=48
}