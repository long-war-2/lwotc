class UIPersonnel_SoldierListItemDetailed extends UIPersonnel_SoldierListItem config(Game);

var config int NUM_HOURS_TO_DAYS;
var config bool ROOKIE_SHOW_PSI_INSTEAD_CI;

var float IconXPos, IconYPos, IconXDelta, IconScale, IconToValueOffsetX, IconToValueOffsetY, IconXDeltaSmallValue;
var float DisabledAlpha;

var bool bIsFocussed;
var bool bShouldHideBonds;
var bool bShouldShowBOndProgress;

var config array<string> APColours;

var UIProgressBar BondProgress;

//icons to be shown in the class area
var UIImage AimIcon, DefenseIcon;
var UIText AimValue, DefenseValue;

//icons to be shown in the name area
var UIImage HealthIcon, MobilityIcon, WillIcon, HackIcon, DodgeIcon, PsiIcon; 
var UIText HealthValue, MobilityValue, WillValue, HackValue, DodgeValue, PsiValue;

var UIImage PCSIcon;
var UIText DetailedData, PCSValue;

var UIIcon APIcon;

var float TraitIconX, AbiltiyIconX;

var float BondBarX, BondBarY, BondWidth, BondHeight;
var UIPanel BadTraitPanel, BonusAbilityPanel;
var array<UIIcon> BadTraitIcon;
var array<UIIcon> BonusAbilityIcon;

var string strUnitName, strClassName;

simulated function UIButton SetDisabled(bool disabled, optional string TooltipText)
{
	super.SetDisabled(disabled, TooltipText);
	UpdateDisabled();
	UpdateItemsForFocus(false);
	return self;
}

simulated function string GetPromotionProgress(XComGameState_Unit Unit)
{
	local string promoteProgress;
	local int NumKills;
	local X2SoldierClassTemplate ClassTemplate;

	if (Unit.IsSoldier())
	{
		ClassTemplate = Unit.GetSoldierClassTemplate();
	}
	else
	{
		return "";
	}

	if (ClassTemplate == none || ClassTemplate.GetMaxConfiguredRank() <= Unit.GetSoldierRank() || ClassTemplate.bBlockRankingUp)
	{
		return "";
	}

	NumKills = Unit.GetTotalNumKills();

	promoteProgress = NumKills $ "/" $ class'X2ExperienceConfig'.static.GetRequiredKills(Unit.GetSoldierRank() + 1);

	return class'UIUtilities_Text'.static.InjectImage(class'UIUtilities_Image'.const.HTML_PromotionIcon, 16, 20, -6) $ "</img>" @ promoteProgress;
}

simulated function string GetDetailedText(XComGameState_Unit Unit)
{
	return class'UIUtilities_Text'.static.InjectImage(class'UIUtilities_Image'.const.HTML_AlienAlertIcon, 16, 20, -18) $ "</img>" @ //class'UISoldierHeader'.default.m_strKillsLabel @ 
			string(Unit.GetNumKills()) @ 
			class'UIUtilities_Text'.static.InjectImage(class'UIUtilities_Image'.const.HTML_ObjectivesIcon, 16, 20, -6) $ "</img>" @ //class'UISoldierHeader'.default.m_strMissionsLabel @ 
			string(Unit.GetNumMissions()) @ 
			//"Armor:" @
			class'UIUtilities_Text'.static.InjectImage("img:///UILibrary_Common.status_armor", 16, 20, -18) $ "</img>" @ 
			string(int(Unit.GetCurrentStat(eStat_ArmorMitigation)) + Unit.GetUIStatFromAbilities(eStat_ArmorMitigation)) @ 
			GetPromotionProgress(Unit);
}

static function GetTimeLabelValue(int Hours, out int TimeValue, out string TimeLabel)
{	
	if (Hours < 0 || Hours > 24 * 30 * 12) // Ignore year long missions
	{
		TimeValue = 0;
		TimeLabel = "";
		return;
	}
	if (Hours > default.NUM_HOURS_TO_DAYS)
	{
		Hours = FCeil(float(Hours) / 24.0f);
		TimeValue = Hours;
		TimeLabel = class'UIUtilities_Text'.static.GetDaysString(Hours);
	}
	else
	{
		TimeValue = Hours;
		TimeLabel = class'UIUtilities_Text'.static.GetHoursString(Hours);
	}
}

static function GetStatusStringsSeparate(XComGameState_Unit Unit, out string Status, out string TimeLabel, out int TimeValue)
{
	local bool bProjectExists;
	local int iHours;
	
	// LWOTC: Make this compatible with community highlander. If this mod is
	// ever updated to use the highlander, then we can just remove the integrated
	// mod without changing any of the LWOTC implementation.
	local XComLWTuple Tuple;

	Tuple = new class'XComLWTuple';
	Tuple.Id = 'CustomizeStatusStringsSeparate';
	Tuple.Data.Add(4);
	Tuple.Data[0].kind = XComLWTVBool;
	Tuple.Data[0].b = false;
	Tuple.Data[1].kind = XComLWTVString;
	Tuple.Data[1].s = Status;
	Tuple.Data[2].kind = XComLWTVString;
	Tuple.Data[2].s = TimeLabel;
	Tuple.Data[3].kind = XComLWTVInt;
	Tuple.Data[3].i = TimeValue;

	`XEVENTMGR.TriggerEvent('CustomizeStatusStringsSeparate', Tuple, Unit);

	if (Tuple.Data[0].b)
	{
		Status = Tuple.Data[1].s;
		TimeLabel = Tuple.Data[2].s;
		TimeValue = Tuple.Data[3].i;
		return;
	}
	// END LWOTC changes
	
	if( Unit.IsInjured() )
	{
		Status = Unit.GetWoundStatus(iHours);
		if (Status != "")
			bProjectExists = true;
	}
	else if (Unit.IsOnCovertAction())
	{
		Status = Unit.GetCovertActionStatus(iHours);
		if (Status != "")
			bProjectExists = true;
	}
	else if (Unit.IsTraining() || Unit.IsPsiTraining() || Unit.IsPsiAbilityTraining())
	{
		Status = Unit.GetTrainingStatus(iHours);
		if (Status != "")
			bProjectExists = true;
	}
	else if( Unit.IsDead() )
	{
		Status = "KIA";
	}
	else
	{
		Status = "";
	}
	
	if (bProjectExists)
	{
		GetTimeLabelValue(iHours, TimeValue, TimeLabel);
	}
}

static function GetPersonnelStatusSeparate(XComGameState_Unit Unit, out string Status, out string TimeLabel, out string TimeValue, optional int FontSizeZ = -1, optional bool bIncludeMentalState = false)
{
	local EUIState eState; 
	local int TimeNum;
	local bool bHideZeroDays;

	bHideZeroDays = true;

	if(Unit.IsMPCharacter())
	{
		Status = class'UIUtilities_Strategy'.default.m_strAvailableStatus;
		eState = eUIState_Good;
		TimeNum = 0;
		Status = class'UIUtilities_Text'.static.GetColoredText(Status, eState, FontSizeZ);
		return;
	}

	// template names are set in X2Character_DefaultCharacters.uc
	if (Unit.IsScientist() || Unit.IsEngineer())
	{
		Status = class'UIUtilities_Text'.static.GetSizedText(Unit.GetLocation(), FontSizeZ);
	}
	else if (Unit.IsSoldier())
	{
		// soldiers get put into the hangar to indicate they are getting ready to go on a mission
		if(`HQPRES != none &&  `HQPRES.ScreenStack.IsInStack(class'UISquadSelect') && `XCOMHQ.IsUnitInSquad(Unit.GetReference()) )
		{
			Status = class'UIUtilities_Strategy'.default.m_strOnMissionStatus;
			eState = eUIState_Highlight;
		}
		else if (Unit.bRecoveryBoosted)
		{
			Status = class'UIUtilities_Strategy'.default.m_strBoostedStatus;
			eState = eUIState_Warning;
		}
		else if( Unit.IsInjured() || Unit.IsDead() )
		{
			GetStatusStringsSeparate(Unit, Status, TimeLabel, TimeNum);
			eState = eUIState_Bad;
		}
		else if(Unit.GetMentalState() == eMentalState_Shaken)
		{
			GetUnitMentalState(Unit, Status, TimeLabel, TimeNum);
			eState = Unit.GetMentalStateUIState();
		}
		else if( Unit.IsPsiTraining() || Unit.IsPsiAbilityTraining() )
		{
			GetStatusStringsSeparate(Unit, Status, TimeLabel, TimeNum);
			eState = eUIState_Psyonic;
		}
		else if( Unit.IsTraining() )
		{
			GetStatusStringsSeparate(Unit, Status, TimeLabel, TimeNum);
			eState = eUIState_Warning;
		}
		else if(  Unit.IsOnCovertAction() )
		{
			GetStatusStringsSeparate(Unit, Status, TimeLabel, TimeNum);
			eState = eUIState_Warning;
			// bHideZeroDays = false; // LWOTC: Hide days if 0 for covert op since it applies to non covert ops too
		}
		else if(bIncludeMentalState && Unit.BelowReadyWillState())
		{
			GetUnitMentalState(Unit, Status, TimeLabel, TimeNum);
			eState = Unit.GetMentalStateUIState();
		}
		else
		{
			GetStatusStringsSeparate(Unit, Status, TimeLabel, TimeNum);
			if (Status == "")
			{
				Status = class'UIUtilities_Strategy'.default.m_strAvailableStatus;
				TimeNum = 0;
			}
			eState = eUIState_Good;
		}
	}

	Status = class'UIUtilities_Text'.static.GetColoredText(Status, eState, FontSizeZ);
	TimeLabel = class'UIUtilities_Text'.static.GetColoredText(TimeLabel, eState, FontSizeZ);
	if( TimeNum == 0 && bHideZeroDays )
		TimeValue = "";
	else
		TimeValue = class'UIUtilities_Text'.static.GetColoredText(string(TimeNum), eState, FontSizeZ);
}

static function GetUnitMentalState(XComGameState_Unit UnitState, out string Status, out string TimeLabel, out int TimeValue)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersProjectRecoverWill WillProject;
	local int iHours;

	History = `XCOMHISTORY;
	Status = UnitState.GetMentalStateLabel();
	TimeLabel = "";
	TimeValue = 0;

	if(UnitState.BelowReadyWillState())
	{
		foreach History.IterateByClassType(class'XComGameState_HeadquartersProjectRecoverWill', WillProject)
		{
			if(WillProject.ProjectFocus.ObjectID == UnitState.ObjectID)
			{
				iHours = WillProject.GetCurrentNumHoursRemaining();
				GetTimeLabelValue(iHours, TimeValue, TimeLabel);
				break;
			}
		}
	}
}

simulated function bool ShouldShowPsi(XComGameState_Unit Unit)
{
	local XComLWTuple EventTup;

	EventTup = new class'XComLWTuple';
	EventTup.Id = 'ShouldShowPsi';
	EventTup.Data.Add(2);
	EventTup.Data[0].kind = XComLWTVBool;
	EventTup.Data[0].b = false;
	EventTup.Data[1].kind = XComLWTVName;
	EventTup.Data[1].n = nameof(Screen.class);

	if (UIPersonnel_TrainingCenter(Screen) != none && 
	((Unit.GetSoldierClassTemplate() != none && Unit.GetSoldierClassTemplate().bAllowAWCAbilities) ||
	 Unit.IsResistanceHero()))
	{
		EventTup.Data[0].b = false;
	}
	else if (Unit.IsPsiOperative() || (default.ROOKIE_SHOW_PSI_INSTEAD_CI && Unit.GetRank() == 0 && !Unit.CanRankUpSoldier() && `XCOMHQ.IsTechResearched('Psionics')))
	{
		EventTup.Data[0].b = true;
	}

	`XEVENTMGR.TriggerEvent('DSLShouldShowPsi', EventTup, Unit);

	return EventTup.Data[0].b;
}

simulated function UpdateData()
{
	local XComGameState_Unit Unit;
	local string UnitLoc, status, statusTimeLabel, statusTimeValue, classIcon, rankIcon, flagIcon, mentalStatus;
	local int iRank, iTimeNum;
	local X2SoldierClassTemplate SoldierClass;
	local XComGameState_ResistanceFaction FactionState;
	local SoldierBond BondData;
	local StateObjectReference BondmateRef;
	local int BondLevel;
	local float CohesionPercent, CohesionMax;
	local array<int> CohesionThresholds;
	
	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitRef.ObjectID));

	iRank = Unit.GetRank();

	SoldierClass = Unit.GetSoldierClassTemplate();
	FactionState = Unit.GetResistanceFaction();

	class'UIUtilities_Strategy'.static.GetPersonnelStatusSeparate(Unit, status, statusTimeLabel, statusTimeValue);
	mentalStatus = "";

	if(Unit.IsActive())
	{
		GetUnitMentalState(Unit, mentalStatus, statusTimeLabel, iTimeNum);
		statusTimeLabel = class'UIUtilities_Text'.static.GetColoredText(statusTimeLabel, Unit.GetMentalStateUIState());

		if(iTimeNum == 0)
		{
			statusTimeValue = "";
		}
		else
		{
			statusTimeValue = class'UIUtilities_Text'.static.GetColoredText(string(iTimeNum), Unit.GetMentalStateUIState());
		}
	}

	if( statusTimeValue == "" )
		statusTimeValue = "---";

	flagIcon = Unit.GetCountryTemplate().FlagImage;
	//rankIcon = class'UIUtilities_Image'.static.GetRankIcon(iRank, SoldierClass.DataName);
	rankIcon = class'UIUtilities_Image'.static.GetRankIcon(iRank, SoldierClass.DataName);
	classIcon = SoldierClass.IconImage;

	// if personnel is not staffed, don't show location
	if( class'UIUtilities_Strategy'.static.DisplayLocation(Unit) )
		UnitLoc = class'UIUtilities_Strategy'.static.GetPersonnelLocation(Unit);
	else
		UnitLoc = "";
		
	if (BondProgress == none)
	{
		BondProgress = Spawn(class'UIProgressBar', self);
	}

	if( BondIcon == none )
	{
		BondIcon = Spawn(class'UIBondIcon', self);
		if( `ISCONTROLLERACTIVE ) 
			BondIcon.bIsNavigable = false; 
	}

	if( Unit.HasSoldierBond(BondmateRef, BondData) )
	{
		BondLevel = BondData.BondLevel;
		if( !BondIcon.bIsInited )
		{
			BondProgress.InitProgressBar('UnitBondProgress', BondBarX, BondBarY, BondWidth, BondHeight);
			BondIcon.InitBondIcon('UnitBondIcon', BondData.BondLevel, , BondData.Bondmate);
		}
		if (BondLevel < 3)
		{
		
			CohesionThresholds = class'X2StrategyGameRulesetDataStructures'.default.CohesionThresholds;
			CohesionMax = float(CohesionThresholds[Clamp(BondLevel + 1, 0, CohesionThresholds.Length - 1)]);
			CohesionPercent = float(BondData.Cohesion) / CohesionMax;
			BondProgress.SetPercent(CohesionPercent);
			BondProgress.Show();
			bShouldShowBOndProgress = true;
		}
		else
		{
			BondProgress.Hide();
		}
		BondIcon.Show();
	}
	else if( Unit.ShowBondAvailableIcon(BondmateRef, BondData) )
	{
		BondLevel = BondData.BondLevel;
		if( !BondIcon.bIsInited )
		{
			BondProgress.InitProgressBar('UnitBondProgress', BondBarX, BondBarY, BondWidth, BondHeight);
			BondIcon.InitBondIcon('UnitBondIcon', BondData.BondLevel, , BondmateRef);
		}
		BondIcon.Show();
		BondProgress.Hide();
		BondIcon.AnimateCohesion(true);
		BondProgress.Hide();
	}
	else
	{
		if( !BondIcon.bIsInited )
		{
			BondProgress.InitProgressBar('UnitBondProgress', BondBarX, BondBarY, BondWidth, BondHeight);
			BondIcon.InitBondIcon('UnitBondIcon', BondData.BondLevel, , BondData.Bondmate);
		}
		BondIcon.Hide();
		BondProgress.Hide();
		bShouldHideBonds = true;
		BondLevel = -1;
	}

	AS_UpdateDataSoldier(Caps(Unit.GetName(eNameType_Full)),
					Caps(Unit.GetName(eNameType_Nick)),
					Caps(Unit.GetSoldierShortRankName()),
					Unit.GetSoldierRankIcon(),
					Caps(SoldierClass != None ? SoldierClass.DisplayName : ""),
					classIcon,
					status,
					statusTimeValue $"\n" $ Class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(Class'UIUtilities_Text'.static.GetSizedText( statusTimeLabel, 12)),
					UnitLoc,
					flagIcon,
					false, //todo: is disabled 
					Unit.ShowPromoteIcon(),
					false, // psi soldiers can't rank up via missions
					mentalStatus,
					BondLevel);

	if (FactionState != none)
	{
		AS_SetFactionIcon(FactionState.GetFactionIcon());
	}
	AddAdditionalItems(self);
	RefreshTooltipText();

	class'MoreDetailsManager'.static.GetOrSpawnParentDM(self).IsMoreDetails = false;
}

function AddAdditionalItems(UIPersonnel_SoldierListItem ListItem)
{
	local XComGameState_Unit Unit;
	
	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ListItem.UnitRef.ObjectID));

	if(GetLanguage() == "JPN")
	{
		IconToValueOffsetY = -3.0;
	}

	AddClassColumnIcons(Unit);
	AddNameColumnIcons(Unit);

	if(Unit.GetName(eNameType_Nick) == " ")
		strUnitName = CAPS(Unit.GetName(eNameType_First) @ Unit.GetName(eNameType_Last));
	else
		strUnitName = CAPS(Unit.GetName(eNameType_First) @ Unit.GetName(eNameType_Nick) @ Unit.GetName(eNameType_Last));

	ListItem.MC.ChildSetString("NameFieldContainer.NameField", "htmlText", class'UIUtilities_Text'.static.GetColoredText(strUnitName, eUIState_Normal));
	ListItem.MC.ChildSetNum("NameFieldContainer.NameField", "_y", (GetLanguage() == "JPN" ? -25 :-22));

	ListItem.MC.ChildSetString("NicknameFieldContainer.NicknameField", "htmlText", " ");
	ListItem.MC.ChildSetBool("NicknameFieldContainer.NicknameField", "_visible", false);

	ListItem.MC.ChildSetNum("ClassFieldContainer", "_y", (GetLanguage() == "JPN" ? -3 : 0));

	UpdateDisabled();
}

function AddNameColumnIcons(XComGameState_Unit Unit)
{
	local string psioffensestr;
	local X2EventListenerTemplateManager EventTemplateManager;
	local X2TraitTemplate TraitTemplate;
	local X2AbilityTemplate AbilityTemplate;
	local int i, AWCRank;

	IconXPos = 174;

	if(HealthIcon == none)
	{
		HealthIcon = Spawn(class'UIImage', self);
		HealthIcon.bAnimateOnInit = false;
		HealthIcon.InitImage('HealthIcon_ListItem_LW', "UILibrary_LWToolbox.StatIcons.Image_Health").SetScale(IconScale).SetPosition(IconXPos, IconYPos);
	}
	if(HealthValue == none)
	{
		HealthValue = Spawn(class'UIText', self);
		HealthValue.bAnimateOnInit = false;
		HealthValue.InitText('HealthValue_ListItem_LW').SetPosition(IconXPos + IconToValueOffsetX, IconYPos + IconToValueOffsetY);
	
	}
	HealthValue.SetHtmlText(class'UIUtilities_Text'.static.GetColoredText(string(int(Unit.GetCurrentStat(eStat_HP))), eUIState_Normal));

	if (DetailedData == none)
	{
		DetailedData = Spawn(class'UIText', self);
		DetailedData.bAnimateOnInit = false;
		DetailedData.InitText('DetailedData_ListItem_LW').SetPosition(IconXPos, IconYPos + IconToValueOffsetY);
		DetailedData.Hide();
	}
	DetailedData.SetHtmlText(class'UIUtilities_Text'.static.GetColoredText(GetDetailedText(Unit), eUIState_Normal));

	IconXPos += IconXDeltaSmallValue;

	if(MobilityIcon == none)
	{
		MobilityIcon = Spawn(class'UIImage', self);
		MobilityIcon.bAnimateOnInit = false;
		MobilityIcon.InitImage('MobilityIcon_ListItem_LW', "UILibrary_LWToolbox.StatIcons.Image_Mobility").SetScale(IconScale).SetPosition(IconXPos, IconYPos);
	}
	if(MobilityValue == none)
	{
		MobilityValue = Spawn(class'UIText', self);
		MobilityValue.bAnimateOnInit = false;
		MobilityValue.InitText('MobilityValue_ListItem_LW').SetPosition(IconXPos + IconToValueOffsetX, IconYPos + IconToValueOffsetY);
	}
	MobilityValue.SetHtmlText(class'UIUtilities_Text'.static.GetColoredText(string(int(Unit.GetCurrentStat(eStat_Mobility))), eUIState_Normal));

	IconXPos += IconXDeltaSmallValue;
//
	//if(WillIcon == none)
	//{
		//WillIcon = Spawn(class'UIImage', self);
		//WillIcon.bAnimateOnInit = false;
		//WillIcon.InitImage('WillIcon_ListItem_LW', "UILibrary_LWToolbox.StatIcons.Image_Will").SetScale(IconScale).SetPosition(IconXPos, IconYPos);
	//}
	//if(WillValue == none)
	//{
		//WillValue = Spawn(class'UIText', self);
		//WillValue.bAnimateOnInit = false;
		//WillValue.InitText('WillValue_ListItem_LW').SetPosition(IconXPos + IconToValueOffsetX, IconYPos + IconToValueOffsetY);
	//}
	//WillValue.SetHtmlText(class'UIUtilities_Text'.static.GetColoredText(string(int(Unit.GetCurrentStat(eStat_Will))), eUIState_Normal));
//
	//IconXPos += IconXDelta * 1.5;

	if(HackIcon == none)
	{
		HackIcon = Spawn(class'UIImage', self);
		HackIcon.bAnimateOnInit = false;
		HackIcon.InitImage('HackIcon_ListItem_LW', "UILibrary_LWToolbox.StatIcons.Image_Hacking").SetScale(IconScale).SetPosition(IconXPos, IconYPos);
	}
	if(HackValue == none)
	{
		HackValue = Spawn(class'UIText', self);
		HackValue.bAnimateOnInit = false;
		HackValue.InitText('HackValue_ListItem_LW').SetPosition(IconXPos + IconToValueOffsetX, IconYPos + IconToValueOffsetY);
	}
	HackValue.SetHtmlText(class'UIUtilities_Text'.static.GetColoredText(string(int(Unit.GetCurrentStat(eStat_Hacking))), eUIState_Normal));

	IconXPos += IconXDelta;

	if(DodgeIcon == none)
	{
		DodgeIcon = Spawn(class'UIImage', self);
		DodgeIcon.bAnimateOnInit = false;
		DodgeIcon.InitImage('DodgeIcon_ListItem_LW', "UILibrary_LWToolbox.StatIcons.Image_Dodge").SetScale(IconScale).SetPosition(IconXPos, IconYPos);
	}
	if(DodgeValue == none)
	{
		DodgeValue = Spawn(class'UIText', self);
		DodgeValue.bAnimateOnInit = false;
		DodgeValue.InitText('DodgeValue_ListItem_LW').SetPosition(IconXPos + IconToValueOffsetX, IconYPos + IconToValueOffsetY);
	}
	DodgeValue.SetHtmlText(class'UIUtilities_Text'.static.GetColoredText(string(int(Unit.GetCurrentStat(eStat_Dodge))), eUIState_Normal));

	IconXPos += IconXDeltaSmallValue;

	if(PsiIcon == none)
	{
		PsiIcon = Spawn(class'UIImage', self);
		PsiIcon.bAnimateOnInit = false;
		PsiIcon.InitImage('PsiIcon_ListItem_LW', "gfxXComIcons.promote_psi").SetScale(IconScale).SetPosition(IconXPos, IconYPos+1);
	}
	if(PsiValue == none)
	{
		PsiValue = Spawn(class'UIText', self);
		PsiValue.bAnimateOnInit = false;
		PsiValue.InitText('PsiValue_ListItem_LW').SetPosition(IconXPos + IconToValueOffsetX, IconYPos + IconToValueOffsetY);
	}

	if (ShouldShowPsi(Unit))
	{
		PsiOffenseStr = string(int(Unit.GetCurrentStat(eStat_PsiOffense)));

		PsiIcon.LoadImage("gfxXComIcons.promote_psi");
		PsiIcon.Show();
		PsiValue.Show();
		PsiValue.SetHtmlText(class'UIUtilities_Text'.static.GetColoredText(PsiOffenseStr, eUIState_Normal));
	}
	else
	{
		if ((Unit.GetSoldierClassTemplate() != none && Unit.GetSoldierClassTemplate().bAllowAWCAbilities) || Unit.IsResistanceHero() || Unit.GetRank() == 0)
		{
			PsiIcon.Hide();
			if (APIcon == none)
			{
				APIcon = Spawn(class'UIIcon', self);
				APIcon.bAnimateOnInit = false;
				APIcon.bDisableSelectionBrackets = true;
				APIcon.InitIcon('APIcon_ListItem_LW', "gfxStrategyComponents.combatIntIcon", false, false);
			}
			APIcon.SetScale(IconScale * 0.6);
			APIcon.SetPosition(IconXPos - (IconToValueOffsetX * 0.1), IconYPos);
			APIcon.Show();
			PsiValue.Show();
		}
		else
		{
			PsiIcon.Hide();
			PsiValue.Hide();
		}
	}

	IconXPos += IconXDelta;

	EventTemplateManager = class'X2EventListenerTemplateManager'.static.GetEventListenerTemplateManager();

	if (BadTraitPanel == none)
	{
		BadTraitPanel = Spawn(class'UIPanel', self);
		BadTraitPanel.bAnimateOnInit = false;
		BadTraitPanel.bIsNavigable = false;
		BadTraitPanel.InitPanel('BadTraitIcon_List_LW');
		BadTraitPanel.SetPosition(IconXPos, IconYPos+1);
		BadTraitPanel.SetSize(IconScale * 4, IconScale);
	}

	if (BonusAbilityPanel == none)
	{
		BonusAbilityPanel = Spawn(class'UIPanel', self);
		BonusAbilityPanel.bAnimateOnInit = false;
		BonusAbilityPanel.bIsNavigable = false;
		BonusAbilityPanel.InitPanel('BonusAbilityIcon_List_LW');
		BonusAbilityPanel.SetPosition(IconXPos - (IconXDelta * 0.5), IconYPos+1);
		BonusAbilityPanel.SetSize(IconScale * 4, IconScale);
		BonusAbilityPanel.Hide();
	}

	for (i = 0; i < Unit.AcquiredTraits.Length; i++)
	{
		TraitTemplate = X2TraitTemplate(EventTemplateManager.FindEventListenerTemplate(Unit.AcquiredTraits[i]));
		if (TraitTemplate != none)
		{
			BadTraitIcon.InsertItem(i, Spawn(class'UIIcon', BadTraitPanel));
			BadTraitIcon[i].bAnimateOnInit = false;
			BadTraitIcon[i].bDisableSelectionBrackets = true;
			BadTraitIcon[i].InitIcon(name("TraitIcon_ListItem_LW_" $ i), TraitTemplate.IconImage, false, false).SetScale(IconScale).SetPosition(TraitIconX, 0);
			BadTraitIcon[i].SetForegroundColor("9acbcb");
			TraitIconX += IconToValueOffsetX;
		}
	}

	if (Unit.GetSoldierClassTemplateName() != '' && Unit.bRolledForAWCAbility)
	{
		AWCRank = Unit.GetSoldierClassTemplate().AbilityTreeTitles.Length - 1;
		//`log("Unit has AWC abilities, column:" @ AWCRank,, 'MoreSoldierDetails');
		for (i = 1; i < Unit.GetSoldierClassTemplate().GetMaxConfiguredRank(); i++)
		{
			//`log("Rank check:" @ i @ "length:" @ Unit.AbilityTree[i].Abilities.Length,, 'MoreSoldierDetails');
			if (Unit.AbilityTree[i].Abilities.Length > AWCRank && Unit.HasSoldierAbility(Unit.AbilityTree[i].Abilities[AWCRank].AbilityName))
			{
				AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(Unit.AbilityTree[i].Abilities[AWCRank].AbilityName);
				//`log("AWC Ability found:" @ Unit.AbilityTree[i].Abilities[AWCRank].AbilityName @ AbilityTemplate.IconImage,, 'MoreSoldierDetails');
				BonusAbilityIcon.AddItem(Spawn(class'UIIcon', BonusAbilityPanel));
				BonusAbilityIcon[BonusAbilityIcon.Length - 1].bAnimateOnInit = false;
				BonusAbilityIcon[BonusAbilityIcon.Length - 1].bDisableSelectionBrackets = true;
				BonusAbilityIcon[BonusAbilityIcon.Length - 1].InitIcon(name("AbilityIcon_ListItem_LW_" $ i), AbilityTemplate.IconImage, false, false).SetScale(IconScale).SetPosition(AbiltiyIconX, 0);
				BonusAbilityIcon[BonusAbilityIcon.Length - 1].SetForegroundColor("9acbcb");
				AbiltiyIconX += IconToValueOffsetX;
			}
		}
	}
}

function ShowDetailed(bool IsDetailed)
{
	local XComGameState_Unit Unit;
	
	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitRef.ObjectID));
	if (IsDetailed)
	{
		DetailedData.Show();
		DefenseIcon.Show();
		DefenseValue.Show();
		PCSIcon.Show();
		PCSValue.Show();
		BonusAbilityPanel.Show();
		AimValue.Hide();
		HealthValue.Hide();
		MobilityValue.Hide();
		WillValue.Hide();
		HackValue.Hide();
		DodgeValue.Hide();
		PsiValue.Hide();
		APIcon.Hide();
		AimIcon.Hide();
		WillIcon.Hide();
		HealthIcon.Hide();
		MobilityIcon.Hide();
		HackIcon.Hide();
		DodgeIcon.Hide();
		PsiIcon.Hide();
		BadTraitPanel.Hide();
		BondIcon.Hide();
		BondProgress.Hide();
	}
	else
	{
		DetailedData.Hide();	
		DefenseIcon.Hide();
		DefenseValue.Hide();
		PCSIcon.Hide();
		PCSValue.Hide();
		BonusAbilityPanel.Hide();
		AimValue.Show();
		HealthValue.Show();
		MobilityValue.Show();
		WillValue.Show();
		HackValue.Show();
		DodgeValue.Show();
		AimIcon.Show();
		WillIcon.Show();
		HealthIcon.Show();
		MobilityIcon.Show();
		HackIcon.Show();
		DodgeIcon.Show();
		BadTraitPanel.Show();
		if (!bShouldHideBonds)
		{
			BondIcon.Show();
			if (bShouldShowBOndProgress)
			{
				BondProgress.Show();
			}
		}
		if (ShouldShowPsi(Unit))
		{
			PsiValue.Show();
			PsiIcon.Show();
		}
		else if ((Unit.GetSoldierClassTemplate() != none && Unit.GetSoldierClassTemplate().bAllowAWCAbilities) || Unit.IsResistanceHero() || Unit.GetRank() == 0)
		{
			APIcon.Show();
			PsiValue.Show();
		}
	}
}

simulated function string GetStatBoostString(XComGameState_Item ImplantToAdd)
{
	local int Index, TotalBoost, BoostValue;
	local bool bHasStatBoostBonus;
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = `XCOMHQ;

	if (XComHQ != none)
	{
		bHasStatBoostBonus = XComHQ.SoldierUnlockTemplates.Find('IntegratedWarfareUnlock') != INDEX_NONE;
	}

	if(ImplantToAdd != none)
	{
		BoostValue = ImplantToAdd.StatBoosts[0].Boost;
		if (bHasStatBoostBonus)
		{				
			if (X2EquipmentTemplate(ImplantToAdd.GetMyTemplate()).bUseBoostIncrement)
				BoostValue += class'X2SoldierIntegratedWarfareUnlockTemplate'.default.StatBoostIncrement;
			else
				BoostValue += Round(BoostValue * class'X2SoldierIntegratedWarfareUnlockTemplate'.default.StatBoostValue);
		}
			
		Index = ImplantToAdd.StatBoosts.Find('StatType', eStat_HP);
		if (Index == 0)
		{
			if (`SecondWaveEnabled('BetaStrike'))
			{
				BoostValue *= class'X2StrategyGameRulesetDataStructures'.default.SecondWaveBetaStrikeHealthMod;
			}

		}
		TotalBoost += BoostValue;
			
	}

	if(TotalBoost != 0)
		return class'UIUtilities_Text'.static.GetColoredText((TotalBoost > 0 ? "+" : "") $ string(TotalBoost), TotalBoost > 0 ? eUIState_Good : eUIState_Bad);
	else
		return "";
}

function AddClassColumnIcons(XComGameState_Unit Unit)
{
	local array<XComGameState_Item> EquippedImplants;

	IconXPos = 600;

	if(AimIcon == none)
	{
		AimIcon = Spawn(class'UIImage', self);
		AimIcon.bAnimateOnInit = false;
		AimIcon.InitImage(, "UILibrary_LWToolbox.StatIcons.Image_Aim").SetScale(IconScale).SetPosition(IconXPos, IconYPos);
	}
	if(AimValue == none)
	{
		AimValue = Spawn(class'UIText', self);
		AimValue.bAnimateOnInit = false;
		AimValue.InitText().SetPosition(IconXPos + IconToValueOffsetX, IconYPos + IconToValueOffsetY);
	}
	AimValue.SetHtmlText(class'UIUtilities_Text'.static.GetColoredText(string(int(Unit.GetCurrentStat(eStat_Offense))), eUIState_Normal));

	if (PCSIcon == none)
	{
		PCSIcon = Spawn(class'UIImage', self);
		PCSIcon.bAnimateOnInit = false;
		PCSIcon.InitImage().SetScale(IconScale * 0.5).SetPosition(IconXPos, IconYPos);
	}
	if (PCSValue == none)
	{
		PCSValue = Spawn(class'UIText', self);
		PCSValue.bAnimateOnInit = false;
		PCSValue.InitText().SetPosition(IconXPos + IconToValueOffsetX, IconYPos + IconToValueOffsetY);
	}
	EquippedImplants = Unit.GetAllItemsInSlot(eInvSlot_CombatSim);
	if (EquippedImplants.Length > 0)
	{
		PCSIcon.LoadImage(class'UIUtilities_Image'.static.GetPCSImage(EquippedImplants[0]));
		PCSValue.SetHtmlText(class'UIUtilities_Text'.static.GetColoredText(GetStatBoostString(EquippedImplants[0]), eUIState_Normal));
	}
	PCSIcon.Hide();
	PCSValue.Hide();

	IconXPos += IconXDelta;

	if(WillIcon == none)
	{
		WillIcon = Spawn(class'UIImage', self);
		WillIcon.bAnimateOnInit = false;
		WillIcon.InitImage('WillIcon_ListItem_LW', "UILibrary_LWToolbox.StatIcons.Image_Will").SetScale(IconScale).SetPosition(IconXPos, IconYPos);
	}
	if(WillValue == none)
	{
		WillValue = Spawn(class'UIText', self);
		WillValue.bAnimateOnInit = false;
		WillValue.InitText('WillValue_ListItem_LW').SetPosition(IconXPos + IconToValueOffsetX, IconYPos + IconToValueOffsetY);
	}
	WillValue.SetHtmlText(class'UIUtilities_Text'.static.GetColoredText(string(int(Unit.GetCurrentStat(eStat_Will))), eUIState_Normal));

	if(DefenseIcon == none)
	{
		DefenseIcon = Spawn(class'UIImage', self);
		DefenseIcon.bAnimateOnInit = false;
		DefenseIcon.InitImage(, "UILibrary_LWToolbox.StatIcons.Image_Defense").SetScale(IconScale).SetPosition(IconXPos, IconYPos);
	}
	if(DefenseValue == none)
	{
		DefenseValue = Spawn(class'UIText', self);
		DefenseValue.bAnimateOnInit = false;
		DefenseValue.InitText().SetPosition(IconXPos + IconToValueOffsetX, IconYPos + IconToValueOffsetY);
	}
	DefenseValue.SetHtmlText(class'UIUtilities_Text'.static.GetColoredText(string(int(Unit.GetCurrentStat(eStat_Defense))), eUIState_Normal));
	DefenseIcon.Hide();
	DefenseValue.Hide();
}

simulated function UpdateItemsForFocus(bool Focussed)
{
	local int iUIState;
	local XComGameState_Unit Unit;
	local bool bReverse;
	local string Aim, Defense, Health, Mobility, Will, Hack, Dodge, Psi;
	local UIIcon traitIcon;
	local array<XComGameState_Item> EquippedImplants;

	iUIState = (IsDisabled ? eUIState_Disabled : eUIState_Normal);

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitRef.ObjectID));
	bIsFocussed = Focussed;
	bReverse = bIsFocussed && !IsDisabled;

	// Get Unit base stats and any stat modifications from abilities
	Will = string(int(Unit.GetCurrentStat(eStat_Will)) + Unit.GetUIStatFromAbilities(eStat_Will)) $ "/" $
		string(int(Unit.GetMaxStat(eStat_Will)));
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
	DetailedData.SetHtmlText(class'UIUtilities_Text'.static.GetColoredText(GetDetailedText(Unit), (bReverse ? -1 : iUIState)));
	
	EquippedImplants = Unit.GetAllItemsInSlot(eInvSlot_CombatSim);
	if (EquippedImplants.Length > 0)
	{
		PCSValue.SetHtmlText(class'UIUtilities_Text'.static.GetColoredText(GetStatBoostString(EquippedImplants[0]), (bReverse ? -1 : iUIState)));
	}

	if (ShouldShowPsi(Unit))
	{
		PsiValue.SetHtmlText(class'UIUtilities_Text'.static.GetColoredText(Psi, (bReverse ? -1 : iUIState)));
	}
	else
	{
		if ((Unit.GetSoldierClassTemplate() != none && Unit.GetSoldierClassTemplate().bAllowAWCAbilities) || Unit.IsResistanceHero() || Unit.GetRank() == 0)
		{
			PsiValue.SetHtmlText(class'UIUtilities_Text'.static.GetColoredText(string(Unit.AbilityPoints), (bReverse ? -1 : iUIState)));

			if (APIcon != none)
			{
				APIcon.SetForegroundColor(APColours[int(Unit.ComInt)]);
			}
		}
	}

	foreach BadTraitIcon(traitIcon)
	{
		traitIcon.SetForegroundColor(bReverse ? "000000" : "9acbcb");
	}

	foreach BonusAbilityIcon(traitIcon)
	{
		traitIcon.SetForegroundColor(bReverse ? "000000" : "9acbcb");
	}
}

simulated function UpdateDisabled()
{
	local float UpdateAlpha;

	UpdateAlpha = (IsDisabled ? DisabledAlpha : 1.0f);

	if(AimIcon == none)
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

simulated function FocusBondEntry(bool IsFocus)
{
	local XComGameState_Unit Unit;
	local UIPersonnel_SoldierListItemDetailed OtherListItem;
	local array<UIPanel> AllOtherListItem;
	local UIPanel OtherItem;
	local StateObjectReference BondmateRef;
	local SoldierBond BondData;
	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitRef.ObjectID));

	if( Unit.HasSoldierBond(BondmateRef, BondData) )
	{
		ParentPanel.GetChildrenOfType(class'UIPersonnel_SoldierListItemDetailed', AllOtherListItem);
		foreach AllOtherListitem(OtherItem)
		{
			OtherListItem = UIPersonnel_SoldierListItemDetailed(OtherItem);
			if (OtherListItem != none && OtherListItem.UnitRef.ObjectID == BondmateRef.ObjectID)
			{
				if (IsFocus)
				{
					OtherListItem.BondIcon.OnReceiveFocus();
				}
				else
				{
					OtherListItem.BondIcon.OnLoseFocus();
				}
			}
		}
	}
}

simulated function OnMouseEvent(int Cmd, array<string> Args)
{
	//switch(Cmd)
	//{
	//case class'UIUtilities_Input'.const.FXS_L_MOUSE_IN:
	//case class'UIUtilities_Input'.const.FXS_L_MOUSE_OVER:
	//case class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OVER:
		//UpdateItemsForFocus(true);
		//FocusBondEntry(true);
		//break;
	//case class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT:
	//case class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OUT:
		//UpdateItemsForFocus(false);
		//FocusBondEntry(false);
		//break;
//
	//}

	Super(UIPanel).OnMouseEvent(Cmd, Args);
}

simulated function OnReceiveFocus()
{
	super.OnReceiveFocus();
	UpdateItemsForFocus(true);
	FocusBondEntry(true);
}

simulated function OnLoseFocus()
{
	super.OnLoseFocus();
	UpdateItemsForFocus(false);
	FocusBondEntry(false);
}

simulated function RefreshTooltipText()
{
	local XComGameState_Unit Unit;
	local SoldierBond BondData;
	local StateObjectReference BondmateRef;
	local XComGameState_Unit Bondmate;
	local string textTooltip, traitTooltip;
	local X2EventListenerTemplateManager EventTemplateManager;
	local X2TraitTemplate TraitTemplate;
	local int i;

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitRef.ObjectID));

	EventTemplateManager = class'X2EventListenerTemplateManager'.static.GetEventListenerTemplateManager();

	textTooltip = "";
	traitTooltip = "";

	for (i = 0; i < Unit.AcquiredTraits.Length; i++)
	{
		TraitTemplate = X2TraitTemplate(EventTemplateManager.FindEventListenerTemplate(Unit.AcquiredTraits[i]));
		if (TraitTemplate != none)
		{
			if (traitTooltip != "")
			{
				traitTooltip $= "\n";
			}
			traitTooltip $= TraitTemplate.TraitFriendlyName @ "-" @ TraitTemplate.TraitDescription;
		}
	}

	if( Unit.HasSoldierBond(BondmateRef, BondData) )
	{
		Bondmate = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(BondmateRef.ObjectID));
		textTooltip = Repl(BondmateTooltip, "%SOLDIERNAME", Caps(Bondmate.GetName(eNameType_RankFull)));
	}
	else if( Unit.ShowBondAvailableIcon(BondmateRef, BondData) )
	{
		textTooltip = class'XComHQPresentationLayer'.default.m_strBannerBondAvailable;
	}

	if (textTooltip != "")
	{
		textTooltip $= "\n\n" $ traitTooltip;
	}
	else
	{
		textTooltip = traitTooltip;
	}
	
	if (textTooltip != "")
	{
		SetTooltipText(textTooltip);
		Movie.Pres.m_kTooltipMgr.TextTooltip.SetUsePartialPath(CachedTooltipID, true);
	}
	else
	{
		SetTooltipText("");
	}
}

defaultproperties
{
	IconToValueOffsetX = 23.0f; // 26
	IconScale = 0.65f;
	IconYPos = 23.0f;
	IconXDelta = 60.0f; // 64
	IconXDeltaSmallValue = 48.0f;
	BondBarX = 488.0f;
	BondBarY = 43.0f;
	BondWidth = 36.0f;
	BondHeight = 6.0f;
	LibID = "SoldierListItem";
	DisabledAlpha = 0.5f;

	bAnimateOnInit = false;
}