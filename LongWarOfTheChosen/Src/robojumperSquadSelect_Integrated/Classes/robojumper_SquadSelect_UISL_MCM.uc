class robojumper_SquadSelect_UISL_MCM extends UIScreenListener config(robojumperSquadSelect);

`include(ModConfigMenuAPI/MCM_API_Includes.uci)
`include(ModConfigMenuAPI/MCM_API_CfgHelpers.uci)
                                                                             
`define DEFOBJ robojumper_SquadSelectConfig(class'Engine'.static.FindClassDefaultObject("robojumperSquadSelect_Integrated.robojumper_SquadSelectConfig"))

var localized string strModTitle;
var localized string strLabel;
var localized string strGroupTitle;

var localized string strShowWeaponUpgradeIcons, strSkipSecondaryUpgradeIconsAvailable, strShowBGImages, strShowMeTheSkills, strSkipInitialAbilities, strAutofillSquad, strShowStats, strDisallowInfiniteScrolling, strSkipIntro;
var localized string strHideTrainingCenterButton;

var localized string strSquadSize;
var config int iSquadSizeMin, iSquadSizeMax;

var localized string strSquadSizeSpawnWarning;
var config array<name> SpawnPointFixingMods;

var bool bShowWeaponUpgradeIcons, bSkipSecondaryUpgradeIconsAvailable, bShowBGImages, bShowMeTheSkills, bSkipInitialAbilities, bAutofillSquad, bShowMeTheStats, bDisallowInfiniteScrolling, bSkipIntro;
var bool bHideTrainingCenterButton;


var int ch_iMaxSoldiers;

const SHOW_WEAPON_UPGRADES = 'showWeaponUpgrades';
const UPGRADES_PRIMARY_ONLY = 'primariesOnly';
const SHOW_BG_IMAGES = 'showBGImages';
const SHOW_ME_SKILLS = 'showMeTheSkills';
const SKIP_SQUADDIE_ABILITIES = 'skipSquaddieAbilities';
const SHOW_STATS = 'showMeTheStats';
const AUTO_FILL_SQUAD = 'autofillSquad';
const DISALLOW_INFINITE_SCROLL = 'disallowScrolling';
const SKIP_INTRO = 'skipIntro';
const HIDE_TRAINING_CENTER = 'hideTrainingCenter';

event OnInit(UIScreen Screen)
{
	if (MCM_API(Screen) != none)
	{
		`MCM_API_Register(Screen, ClientModCallback);
	}
}

simulated function ClientModCallback(MCM_API_Instance ConfigAPI, int GameMode)
{
	local MCM_API_SettingsPage Page;
	local MCM_API_SettingsGroup Group;


	Page = ConfigAPI.NewSettingsPage(strLabel);
	Page.SetPageTitle(strModTitle);
	Page.SetSaveHandler(SaveButtonClicked);

	bShowWeaponUpgradeIcons = class'robojumper_SquadSelectConfig'.static.ShowWeaponUpgradeIcons();
	bSkipSecondaryUpgradeIconsAvailable = class'robojumper_SquadSelectConfig'.static.DontShowSecondaryUpgradeIconsAvailable();
	bShowBGImages = class'robojumper_SquadSelectConfig'.static.ShowBGImages();
	bShowMeTheSkills = class'robojumper_SquadSelectConfig'.static.ShowMeTheSkills();
	bSkipInitialAbilities = class'robojumper_SquadSelectConfig'.static.DontShowInitialAbilities();
	bShowMeTheStats = class'robojumper_SquadSelectConfig'.static.ShouldShowStats();
	bAutofillSquad = class'robojumper_SquadSelectConfig'.static.ShouldAutoFillSquad();
	bDisallowInfiniteScrolling = class'robojumper_SquadSelectConfig'.static.DisAllowInfiniteScrolling();
	bHideTrainingCenterButton = class'robojumper_SquadSelectConfig'.static.HideTrainingCenterButton();

	ch_iMaxSoldiers = class'robojumper_SquadSelectConfig'.static.GetSquadSize();

	Group = Page.AddGroup('Group1', strGroupTitle);

	Group.AddCheckbox(SHOW_WEAPON_UPGRADES, strShowWeaponUpgradeIcons, "", bShowWeaponUpgradeIcons, , CheckboxSaveHandler);
	Group.AddCheckbox(UPGRADES_PRIMARY_ONLY, strSkipSecondaryUpgradeIconsAvailable, "", bSkipSecondaryUpgradeIconsAvailable, , CheckboxSaveHandler).SetEditable(bShowWeaponUpgradeIcons);

	Group.AddCheckbox(SHOW_BG_IMAGES, strShowBGImages, "", bShowBGImages, , CheckboxSaveHandler);

	Group.AddCheckbox(SHOW_ME_SKILLS, strShowMeTheSkills, "", bShowMeTheSkills, , CheckboxSaveHandler);
	Group.AddCheckbox(SKIP_SQUADDIE_ABILITIES, strSkipInitialAbilities, "", bSkipInitialAbilities, , CheckboxSaveHandler).SetEditable(bShowMeTheSkills);

	Group.AddCheckbox(SHOW_STATS, strShowStats, "", bShowMeTheStats, , CheckboxSaveHandler);
	Group.AddCheckbox(HIDE_TRAINING_CENTER, strHideTrainingCenterButton, "", bHideTrainingCenterButton, , CheckboxSaveHandler).SetEditable(bShowMeTheStats);

	Group.AddCheckbox(AUTO_FILL_SQUAD, strAutofillSquad, "", bAutofillSquad, , CheckboxSaveHandler);
	Group.AddCheckbox(SKIP_INTRO, strSkipIntro, "", bSkipIntro, , CheckboxSaveHandler);
	
	Group.AddCheckbox(DISALLOW_INFINITE_SCROLL, strDisallowInfiniteScrolling, "", bDisallowInfiniteScrolling, , CheckboxSaveHandler);

	
	if (!class'X2DownloadableContentInfo_robojumperSquadSelect'.default.bDontTouchSquadSize)
	{
		Group.AddSlider('squadsize', strSquadSize, "", iSquadSizeMin, iSquadSizeMax, 1, ch_iMaxSoldiers, , SquadSizeSaveHandler);
	}

	Page.ShowSettings();
	Page.SetPageTitle(strModTitle);

}

simulated function CheckboxSaveHandler(MCM_API_Setting _Setting, bool _SettingValue)
{
	local name SettingName;
	SettingName = _Setting.GetName();
	switch (SettingName)
	{
		case SHOW_WEAPON_UPGRADES:
			bShowWeaponUpgradeIcons = _SettingValue;
			_Setting.GetParentGroup().GetSettingByName(UPGRADES_PRIMARY_ONLY).SetEditable(_SettingValue);
			break;
		case UPGRADES_PRIMARY_ONLY:
			bSkipSecondaryUpgradeIconsAvailable = _SettingValue;
			break;
		case SHOW_BG_IMAGES:
			bShowBGImages = _SettingValue;
			break;
		case SHOW_ME_SKILLS:
			bShowMeTheSkills = _SettingValue;
			_Setting.GetParentGroup().GetSettingByName(SKIP_SQUADDIE_ABILITIES).SetEditable(_SettingValue);
			break;
		case SKIP_SQUADDIE_ABILITIES:
			bSkipInitialAbilities = _SettingValue;
			break;
		case SHOW_STATS:
			bShowMeTheStats = _SettingValue;
			_Setting.GetParentGroup().GetSettingByName(HIDE_TRAINING_CENTER).SetEditable(_SettingValue);
			break;
		case HIDE_TRAINING_CENTER:
			bHideTrainingCenterButton = _SettingValue;
			break;
		case AUTO_FILL_SQUAD:
			bAutofillSquad = _SettingValue;
			break;
		case DISALLOW_INFINITE_SCROLL:
			bDisallowInfiniteScrolling = _SettingValue;
			break;
		case SKIP_INTRO:
			bSkipIntro = _SettingValue;
			break;
		default:
			assert(false);
	}
}

simulated function SquadSizeSaveHandler(MCM_API_Setting _Setting, float _SettingValue)
{
	ch_iMaxSoldiers = _SettingValue;
}


simulated function SaveButtonClicked(MCM_API_SettingsPage Page)
{
	local robojumper_SquadSelectConfig DefObj;
	DefObj = `DEFOBJ;
	DefObj.bShowWeaponUpgradeIcons = bShowWeaponUpgradeIcons;
	DefObj.bSkipSecondaryUpgradeIconsAvailable = bSkipSecondaryUpgradeIconsAvailable;
	DefObj.bShowBGImages = bShowBGImages;
	DefObj.bShowMeTheSkills = bShowMeTheSkills;
	DefObj.bSkipInitialAbilities = bSkipInitialAbilities;
	DefObj.bAutofillSquad = bAutofillSquad;
	DefObj.bShowStats = bShowMeTheStats;
	DefObj.bHideTrainingCenterButton = bHideTrainingCenterButton;
	DefObj.bDisallowInfiniteScrolling = bDisallowInfiniteScrolling;
	DefObj.bSkipIntro = bSkipIntro;
	DefObj.iSquadSize = ch_iMaxSoldiers;
	class'robojumper_SquadSelectConfig'.static.StaticSaveConfig();
	// internally guarded
	class'X2DownloadableContentInfo_robojumperSquadSelect'.static.PatchSquadSize();

	if (!class'X2DownloadableContentInfo_robojumperSquadSelect'.default.bDontTouchSquadSize)
	{
		MaybeShowSquadSizeWarning();
	}
}

simulated function MaybeShowSquadSizeWarning()
{
	local TDialogueBoxData      kDialogData;
	local int i;
	local name DLCName;
	local XComOnlineEventMgr Mgr;
	local bool bNeedsFix;

	Mgr = `ONLINEEVENTMGR;

	// 7+2 = 9 is fine
	if (class'robojumper_SquadSelectConfig'.static.GetSquadSize() <= 7) return;

	bNeedsFix = true;

	for (i = Mgr.GetNumDLC() - 1; i >= 0; i--)
	{
		DLCName = Mgr.GetDLCNames(i);
		if (DLCName != '' && SpawnPointFixingMods.Find(DLCName) != INDEX_NONE)
		{
			bNeedsFix = false;
			break;
		}
	}

	if (!bNeedsFix) return;

	kDialogData.eType = eDialog_Warning;
	kDialogData.strText = strSquadSizeSpawnWarning;

	kDialogData.strTitle = strSquadSize;
	kDialogData.strAccept = class'UIUtilities_Text'.default.m_strGenericAccept;
	
	`PRESBASE.UIRaiseDialog(kDialogData);
}


defaultproperties
{
	ScreenClass=none
}