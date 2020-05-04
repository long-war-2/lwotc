//---------------------------------------------------------------------------------------
//  FILE:    UIPersonnel_SoldierListItem_LW.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: This is a replacement for SoldierListItem that allows displays stats,
//           and provides hooks for tweaking things per mod.
//---------------------------------------------------------------------------------------
class UIPersonnel_SoldierListItem_LW extends UIPersonnel_SoldierListItem;

var float IconXPos, IconYPos, IconXDelta, IconScale, IconToValueOffsetX, IconToValueOffsetY, IconXDeltaSmallValue;
var float DisabledAlpha;

var bool bIsFocussed;

//icons to be shown in the class area
var UIImage AimIcon, WillIcon;
var UIText AimValue, WillValue;

//icons to be shown in the name area
var UIImage HealthIcon, MobilityIcon, DefenseIcon, HackIcon, DodgeIcon, PsiIcon; 
var UIText HealthValue, MobilityValue, DefenseValue, HackValue, DodgeValue, PsiValue;

var string strUnitName, strClassName;

simulated function UIButton SetDisabled(bool disabled, optional string TooltipText)
{
	super.SetDisabled(disabled, TooltipText);
	UpdateDisabled();
	UpdateItemsForFocus(false);
	return self;
}

simulated function UpdateData()
{
	local XComGameState_Unit Unit;
	local string UnitLoc, status, statusTimeLabel, statusTimeValue, mentalStatus, flagIcon;	
	local int iTimeNum;
	local X2SoldierClassTemplate SoldierClass;
	local XComGameState_ResistanceFaction FactionState;
	local SoldierBond BondData;
	local StateObjectReference BondmateRef;
	local XComGameState_Unit Bondmate;
	local int BondLevel; 
	
	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitRef.ObjectID));

	SoldierClass = Unit.GetSoldierClassTemplate();
	FactionState = Unit.GetResistanceFaction();

	class'UIUtilities_Strategy'.static.GetPersonnelStatusSeparate(Unit, status, statusTimeLabel, statusTimeValue);
	mentalStatus = "";

	if (ShouldDisplayMentalStatus(Unit)) // Issue #651
	{
		Unit.GetMentalStateStringsSeparate(mentalStatus, statusTimeLabel, iTimeNum);
		statusTimeLabel = class'UIUtilities_Text'.static.GetColoredText(statusTimeLabel, Unit.GetMentalStateUIState());

		if (iTimeNum == 0)
		{
			statusTimeValue = "";
		}
		else
		{
			statusTimeValue = class'UIUtilities_Text'.static.GetColoredText(string(iTimeNum), Unit.GetMentalStateUIState());
		}
	}

	if (statusTimeValue == "")
		statusTimeValue = "---";

	flagIcon = Unit.GetCountryTemplate().FlagImage;

	// if personnel is not staffed, don't show location
	if (class'UIUtilities_Strategy'.static.DisplayLocation(Unit))
		UnitLoc = class'UIUtilities_Strategy'.static.GetPersonnelLocation(Unit);
	else
		UnitLoc = "";

	if (BondIcon == none)
	{
		BondIcon = Spawn(class'UIBondIcon', self);
		if (`ISCONTROLLERACTIVE)
			BondIcon.bIsNavigable = false; 
	}

	if (Unit.HasSoldierBond(BondmateRef, BondData))
	{
		Bondmate = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(BondmateRef.ObjectID));
		BondLevel = BondData.BondLevel;
		if (!BondIcon.bIsInited)
		{
			BondIcon.InitBondIcon('UnitBondIcon', BondData.BondLevel, , BondData.Bondmate);
		}
		BondIcon.Show();
		SetTooltipText(Repl(BondmateTooltip, "%SOLDIERNAME", Caps(Bondmate.GetName(eNameType_RankFull))));
		Movie.Pres.m_kTooltipMgr.TextTooltip.SetUsePartialPath(CachedTooltipID, true);
	}
	else if (Unit.ShowBondAvailableIcon(BondmateRef, BondData))
	{
		BondLevel = BondData.BondLevel;
		if (!BondIcon.bIsInited)
		{
			BondIcon.InitBondIcon('UnitBondIcon', BondData.BondLevel, , BondmateRef);
		}
		BondIcon.Show();
		BondIcon.AnimateCohesion(true);
		SetTooltipText(class'XComHQPresentationLayer'.default.m_strBannerBondAvailable);
		Movie.Pres.m_kTooltipMgr.TextTooltip.SetUsePartialPath(CachedTooltipID, true);
	}
	else
	{
		if (!BondIcon.bIsInited)
		{
			BondIcon.InitBondIcon('UnitBondIcon', BondData.BondLevel, , BondData.Bondmate);
		}
		BondIcon.Hide();
		BondLevel = -1; 
	}

	AS_UpdateDataSoldier(Caps(Unit.GetName(eNameType_Full)),
					Caps(Unit.GetName(eNameType_Nick)),
					Caps(Unit.GetSoldierShortRankName()),
					Unit.GetSoldierRankIcon(),
					Caps(SoldierClass != None ? SoldierClass.DisplayName : ""),
					Unit.GetSoldierClassIcon(),
					status,
					statusTimeValue $"\n" $ Class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(Class'UIUtilities_Text'.static.GetSizedText( statusTimeLabel, 12)),
					UnitLoc,
					flagIcon,
					false, //todo: is disabled 
					Unit.ShowPromoteIcon(),
					Unit.IsPsiOperative() && class'Utilities_PP_LW'.static.CanRankUpPsiSoldier(Unit) && !Unit.IsPsiTraining() && !Unit.IsPsiAbilityTraining(),
					mentalStatus,
					BondLevel); // changed from vanilla

	AddAdditionalItems(self);

	AS_SetFactionIcon(FactionState.GetFactionIcon());
}

function AddAdditionalItems(UIPersonnel_SoldierListItem ListItem)
{
	local XComGameState_Unit Unit;
	
	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ListItem.UnitRef.ObjectID));

	if (GetLanguage() == "JPN")
	{
		IconToValueOffsetY = -3.0;
	}

	AddClassColumnIcons(Unit);
	AddNameColumnIcons(Unit);

	if (Unit.GetName(eNameType_Nick) == " ")
		strUnitName = CAPS(Unit.GetName(eNameType_First) @ Unit.GetName(eNameType_Last));
	else
		strUnitName = CAPS(Unit.GetName(eNameType_First) @ Unit.GetName(eNameType_Nick) @ Unit.GetName(eNameType_Last));

	ListItem.MC.ChildSetString("NameFieldContainer.NameField", "htmlText", class'UIUtilities_Text'.static.GetColoredText(strUnitName, eUIState_Normal));
	ListItem.MC.ChildSetNum("NameFieldContainer.NameField", "_y", (GetLanguage() == "JPN" ? -25 :-22));

	ListItem.MC.ChildSetString("NicknameFieldContainer.NicknameField", "htmlText", " ");
	ListItem.MC.ChildSetBool("NicknameFieldContainer.NicknameField", "_visible", false);

	ListItem.MC.ChildSetNum("ClassFieldContainer", "_y", (GetLanguage() == "JPN" ? -3 : 0));

	UpdateDisabled();

	// trigger now to allow overlaying icons/text/etc on top of other stuff
	`XEVENTMGR.TriggerEvent('OnSoldierListItemUpdate_End', ListItem, ListItem);
}

function AddNameColumnIcons(XComGameState_Unit Unit)
{
	local string psioffensestr;

	IconXPos = 174;

	if (HealthIcon == none)
	{
		HealthIcon = Spawn(class'UIImage', self);
		HealthIcon.bAnimateOnInit = false;
		HealthIcon.InitImage('HealthIcon_ListItem_LW', "UILibrary_LWToolbox.StatIcons.Image_Health").SetScale(IconScale).SetPosition(IconXPos, IconYPos);
	}
	if (HealthValue == none)
	{
		HealthValue = Spawn(class'UIText', self);
		HealthValue.bAnimateOnInit = false;
		HealthValue.InitText('HealthValue_ListItem_LW').SetPosition(IconXPos + IconToValueOffsetX, IconYPos + IconToValueOffsetY);
	
	}
	HealthValue.SetHtmlText(class'UIUtilities_Text'.static.GetColoredText(string(int(Unit.GetCurrentStat(eStat_HP))), eUIState_Normal));

	IconXPos += IconXDeltaSmallValue;

	if (MobilityIcon == none)
	{
		MobilityIcon = Spawn(class'UIImage', self);
		MobilityIcon.bAnimateOnInit = false;
		MobilityIcon.InitImage('MobilityIcon_ListItem_LW', "UILibrary_LWToolbox.StatIcons.Image_Mobility").SetScale(IconScale).SetPosition(IconXPos, IconYPos);
	}
	if (MobilityValue == none)
	{
		MobilityValue = Spawn(class'UIText', self);
		MobilityValue.bAnimateOnInit = false;
		MobilityValue.InitText('MobilityValue_ListItem_LW').SetPosition(IconXPos + IconToValueOffsetX, IconYPos + IconToValueOffsetY);
	}
	MobilityValue.SetHtmlText(class'UIUtilities_Text'.static.GetColoredText(string(int(Unit.GetCurrentStat(eStat_Mobility))), eUIState_Normal));

	IconXPos += IconXDeltaSmallValue;

	if (DefenseIcon == none)
	{
		DefenseIcon = Spawn(class'UIImage', self);
		DefenseIcon.bAnimateOnInit = false;
		DefenseIcon.InitImage(, "UILibrary_LWToolbox.StatIcons.Image_Defense").SetScale(IconScale).SetPosition(IconXPos, IconYPos);
	}

	if (DefenseValue == none)
	{
		DefenseValue = Spawn(class'UIText', self);
		DefenseValue.bAnimateOnInit = false;
		DefenseValue.InitText().SetPosition(IconXPos + IconToValueOffsetX, IconYPos + IconToValueOffsetY);
	}
	DefenseValue.SetHtmlText(class'UIUtilities_Text'.static.GetColoredText(string(int(Unit.GetCurrentStat(eStat_Defense))), eUIState_Normal));
	
	IconXPos += IconXDeltaSmallValue;

	if (DodgeIcon == none)
	{
		DodgeIcon = Spawn(class'UIImage', self);
		DodgeIcon.bAnimateOnInit = false;
		DodgeIcon.InitImage('DodgeIcon_ListItem_LW', "UILibrary_LWToolbox.StatIcons.Image_Dodge").SetScale(IconScale).SetPosition(IconXPos, IconYPos);
	}
	if (DodgeValue == none)
	{
		DodgeValue = Spawn(class'UIText', self);
		DodgeValue.bAnimateOnInit = false;
		DodgeValue.InitText('DodgeValue_ListItem_LW').SetPosition(IconXPos + IconToValueOffsetX, IconYPos + IconToValueOffsetY);
	}
	DodgeValue.SetHtmlText(class'UIUtilities_Text'.static.GetColoredText(string(int(Unit.GetCurrentStat(eStat_Dodge))), eUIState_Normal));

	IconXPos += IconXDeltaSmallValue;

	if (!IsPsiUnit(Unit))
	{
		if (HackIcon == none)
		{
			HackIcon = Spawn(class'UIImage', self);
			HackIcon.bAnimateOnInit = false;
			HackIcon.InitImage('HackIcon_ListItem_LW', "UILibrary_LWToolbox.StatIcons.Image_Hacking").SetScale(IconScale).SetPosition(IconXPos, IconYPos);
		}

		if (HackValue == none)
		{
			HackValue = Spawn(class'UIText', self);
			HackValue.bAnimateOnInit = false;
			HackValue.InitText('HackValue_ListItem_LW').SetPosition(IconXPos + IconToValueOffsetX, IconYPos + IconToValueOffsetY);
		}
		HackValue.SetHtmlText(class'UIUtilities_Text'.static.GetColoredText(string(int(Unit.GetCurrentStat(eStat_Hacking))), eUIState_Normal));

		IconXPos += IconXDelta;
	}

	//!class'Utilities_PP_LW'.static.CanRankUpPsiSoldier(Unit)
	if (ShouldShowPsi(Unit))
	{
		if (PsiIcon == none)
		{
			PsiIcon = Spawn(class'UIImage', self);
			PsiIcon.bAnimateOnInit = false;
			PsiIcon.InitImage('PsiIcon_ListItem_LW', "gfxXComIcons.promote_psi").SetScale(IconScale).SetPosition(IconXPos, IconYPos+1);
		}

		if (PsiValue == none)
		{
			PsiValue = Spawn(class'UIText', self);
			PsiValue.bAnimateOnInit = false;
			PsiValue.InitText('PsiValue_ListItem_LW').SetPosition(IconXPos + IconToValueOffsetX, IconYPos + IconToValueOffsetY);
		}

		PsiOffenseStr = string(int(Unit.GetCurrentStat(eStat_PsiOffense)));

		PsiIcon.Show();
		PsiValue.Show();
		PsiValue.SetHtmlText(class'UIUtilities_Text'.static.GetColoredText(PsiOffenseStr, eUIState_Normal));
	}
	else
	{
		if (PsiIcon != none)
			PsiIcon.Hide();
		if (PsiValue != none)
			PsiValue.Hide();
	}
}

function AddClassColumnIcons(XComGameState_Unit Unit)
{
	//Texture2D'UILibrary_LWToolbox.StatIcons.Image_Aim'
	//Texture2D'UILibrary_LWToolbox.StatIcons.Image_Defense'

	IconXPos = 600;

	if (AimIcon == none)
	{
		AimIcon = Spawn(class'UIImage', self);
		AimIcon.bAnimateOnInit = false;
		AimIcon.InitImage(, "UILibrary_LWToolbox.StatIcons.Image_Aim").SetScale(IconScale).SetPosition(IconXPos, IconYPos);
	}
	if (AimValue == none)
	{
		AimValue = Spawn(class'UIText', self);
		AimValue.bAnimateOnInit = false;
		AimValue.InitText().SetPosition(IconXPos + IconToValueOffsetX, IconYPos + IconToValueOffsetY);
	}
	AimValue.SetHtmlText(class'UIUtilities_Text'.static.GetColoredText(string(int(Unit.GetCurrentStat(eStat_Offense))), eUIState_Normal));

	IconXPos += IconXDelta;

	if (WillIcon == none)
	{
		WillIcon = Spawn(class'UIImage', self);
		WillIcon.bAnimateOnInit = false;
		WillIcon.InitImage('WillIcon_ListItem_LW', "UILibrary_LWToolbox.StatIcons.Image_Will").SetScale(IconScale).SetPosition(IconXPos, IconYPos);
	}

	if (WillValue == none)
	{
		WillValue = Spawn(class'UIText', self);
		WillValue.bAnimateOnInit = false;
		WillValue.InitText('WillValue_ListItem_LW').SetPosition(IconXPos + IconToValueOffsetX, IconYPos + IconToValueOffsetY);
	}
	WillValue.SetHtmlText(class'UIUtilities_Text'.static.GetColoredText(GetWillString(Unit), Unit.GetMentalStateUIState()));
}

simulated function UpdateItemsForFocus(bool Focussed)
{
	local int iUIState;
	local XComGameState_Unit Unit;
	local bool bReverse;
	local string Aim, Defense, Health, Mobility, Will, Hack, Dodge, Psi;

	iUIState = (IsDisabled ? eUIState_Disabled : eUIState_Normal);

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitRef.ObjectID));
	bIsFocussed = Focussed;
	bReverse = bIsFocussed && !IsDisabled;

	// Get Unit base stats and any stat modifications from abilities
	Will = GetWillString(Unit);
	Aim = string(int(Unit.GetCurrentStat(eStat_Offense)) + Unit.GetUIStatFromAbilities(eStat_Offense));
	Health = string(int(Unit.GetCurrentStat(eStat_HP)) + Unit.GetUIStatFromAbilities(eStat_HP));
	Mobility = string(int(Unit.GetCurrentStat(eStat_Mobility)) + Unit.GetUIStatFromAbilities(eStat_Mobility));
	Hack = string(int(Unit.GetCurrentStat(eStat_Hacking)) + Unit.GetUIStatFromAbilities(eStat_Hacking));
	Dodge = string(int(Unit.GetCurrentStat(eStat_Dodge)) + Unit.GetUIStatFromAbilities(eStat_Dodge));
	Psi = string(int(Unit.GetCurrentStat(eStat_PsiOffense)) + Unit.GetUIStatFromAbilities(eStat_PsiOffense));
	Defense = string(int(Unit.GetCurrentStat(eStat_Defense)) + Unit.GetUIStatFromAbilities(eStat_Defense));
	
	AimValue.SetHtmlText(class'UIUtilities_Text'.static.GetColoredText(Aim, (bReverse ? -1 : iUIState)));
	DefenseValue.SetHtmlText(class'UIUtilities_Text'.static.GetColoredText(Defense, (bReverse ? -1 : iUIState)));
	HealthValue.SetHtmlText(class'UIUtilities_Text'.static.GetColoredText(Health, (bReverse ? -1 : iUIState)));
	MobilityValue.SetHtmlText(class'UIUtilities_Text'.static.GetColoredText(Mobility, (bReverse ? -1 : iUIState)));
	WillValue.SetHtmlText(class'UIUtilities_Text'.static.GetColoredText(Will, Unit.GetMentalStateUIState()));
	HackValue.SetHtmlText(class'UIUtilities_Text'.static.GetColoredText(Hack, (bReverse ? -1 : iUIState)));
	DodgeValue.SetHtmlText(class'UIUtilities_Text'.static.GetColoredText(Dodge, (bReverse ? -1 : iUIState)));
	if (PsiValue != none)
		PsiValue.SetHtmlText(class'UIUtilities_Text'.static.GetColoredText(Psi, (bReverse ? -1 : iUIState)));

	// trigger now to allow updating on when item is focussed (e.g. changing text color)
	`XEVENTMGR.TriggerEvent('OnSoldierListItemUpdate_Focussed', self, self);

}

simulated function UpdateDisabled()
{
	local float UpdateAlpha;

	UpdateAlpha = (IsDisabled ? DisabledAlpha : 1.0f);

	if (AimIcon == none)
		return;

	AimIcon.SetAlpha(UpdateAlpha);
	DefenseIcon.SetAlpha(UpdateAlpha);
	HealthIcon.SetAlpha(UpdateAlpha);
	MobilityIcon.SetAlpha(UpdateAlpha);
	WillIcon.SetAlpha(UpdateAlpha);
	HackIcon.SetAlpha(UpdateAlpha);
	DodgeIcon.SetAlpha(UpdateAlpha);
	if (PsiIcon != none)
		PsiIcon.SetAlpha(UpdateAlpha);

}

simulated function OnMouseEvent(int Cmd, array<string> Args)
{
	switch(Cmd)
	{
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_IN:
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_OVER:
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OVER:
		UpdateItemsForFocus(true);
		break;
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT:
	case class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OUT:
		UpdateItemsForFocus(false);
		break;

	}

	Super(UIPanel).OnMouseEvent(Cmd, Args);
}

// Returns the string "<Will>/<Max Will>"
static function string GetWillString(XComGameState_Unit Unit)
{
	return string(int(Unit.GetCurrentStat(eStat_Will)) + Unit.GetUIStatFromAbilities(eStat_Will)) $
			"/" $ string(int(Unit.GetMaxStat(eStat_Will)) + Unit.GetUIStatFromAbilities(eStat_Will));
}

static function bool ShouldShowPsi(XComGameState_Unit Unit)
{
	return IsPsiUnit(Unit) || (Unit.GetRank() == 0 && !Unit.CanRankUpSoldier() && `XCOMHQ.IsTechResearched('AutopsySectoid'));
}

static function bool IsPsiUnit(XComGameState_Unit Unit)
{
	return Unit.IsPsiOperative() || Unit.GetSoldierClassTemplateName() == 'Templar';
}

defaultproperties
{
	IconToValueOffsetX = 24.0f; // 26
	IconScale = 0.65f;
	IconYPos = 23.0f;
	IconXDelta = 57.0f; // 64
	IconXDeltaSmallValue = 53.0f;
	LibID = "SoldierListItem";
	DisabledAlpha = 0.5f;

	bAnimateOnInit = false;
}
