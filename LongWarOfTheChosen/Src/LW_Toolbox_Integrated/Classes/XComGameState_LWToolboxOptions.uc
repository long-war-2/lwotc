//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_LWToolboxOptions.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: This is a component extension for CampaignSettings GameStates, containing 
//				additional data used for mod configuration, plus UI control code.
//---------------------------------------------------------------------------------------
class XComGameState_LWToolboxOptions extends XComGameState_LWToolboxPrototype
	config(LW_Toolbox)
	dependson(X2DownloadableContentInfo_LWToolbox);

//

struct MissionOverride
{
	var name MissionName;
	var MissionMaxSoldiersOverrideType Type;
	var float Value;
};

var config array<name> Suppress;

var localized string ToolboxTabName;

// ***** HELP BUTTON ***** //
var localized string HelpButtonLabel;
var localized string HelpButtonLabelText;
var localized string HelpButtonLabelTooltip;


// ***** CAMERA CONFIGURATION ***** //
var config array<float> CAMERA_ROTATION_OPTIONS_DEG;
var array<string> sCameraRotationOptions;
var config int DEFAULT_CAMERA_ROTATION_INDEX;
var int CameraRotationIndex;
var int CameraRotationIndex_Cached;

var localized string SetCameraRotation;
var localized string SetCameraRotationTooltip;

// ***** SQUADSIZE CONFIGURATION ***** //
var bool bSquadSizeEnabled;
var int SquadSizeIndex;
var bool bSquadSizeEnabled_Cached;
var int SquadSizeIndex_Cached;
var array<MissionOverride> arrMissionOverrides;
var config array<int> SQUADSIZE_OPTIONS;
var array<string> sSquadSizeOptions;
var localized string EnableSquadSizeMod;
var localized string EnableSquadSizeModTooltip;
var localized string SelectSquadSize;
var localized string SelectSquadSizeTooltip;

//var delegate<GetBestDeployableSoldier> fnGetBestDeployableSoldier;

// ***** RANDOMIZED DAMAGE CONFIGURATION ***** //
var bool bRandomizedDamageEnabled;
var int RandomizedDamageIndex;
var bool bRandomizedDamageEnabled_Cached;
var int RandomizedDamageIndex_Cached;
var config array<int> RANDOMIZED_DAMAGE_OPTIONS;
var array<string> sRandomizedDamageOptions;
var localized string NormalDamage;
var localized string MaxDamage;
var localized string EnableRandomizedDamageMod;
var localized string EnableRandomizedDamageModTooltip;

// ***** RANDOMIZED INITIAL STATS CONFIGURATION ***** //
var bool bRandomizedInitialStatsEnabled;
var bool bRandomizedInitialStatsEnabled_Cached;
var config array<Name> ExtraCharacterTemplatesToRandomize;
var localized string EnableRandomizedInitialStatsMod;
var localized string EnableRandomizedInitialStatsModTooltip;
var localized string sCantChangeWithWoundedSoldiers;

// ***** RANDOMIZED LEVELUP CONFIGURATION ***** //
var bool bRandomizedLevelupStatsEnabled;
var bool bRandomizedLevelupStatsEnabled_Cached;
var localized string EnableRandomizedLevelupStatsMod;
var localized string EnableRandomizedLevelupStatsModTooltip;

// ***** RANDOMIZED LEVELUP SLIDER ***** //
var float fPercentGuaranteedStat;
var float fPercentGuaranteedStat_Cached;
var localized string RandomizedLevelupStrength;
var localized string RandomizedLevelupStrengthTooltip;

// ***** RED FOG CONFIGURATION ***** //
var bool bRedFogXComActive;
var bool bRedFogAliensActive;
var bool bRedFogLinearPenalties;
var bool bRedFogXComActive_Cached;
var bool bRedFogAliensActive_Cached;
var bool bRedFogLinearPenalties_Cached;
var bool bOverriddenRedFogPenaltyType;
var EStatModOp RedFogPenaltyTypeOverride;
var ERedFogHealingType RFHealingTypeOverride;
var config ERedFogHealingType RedFogHealingType;
var config EStatModOp RedFogPenaltyType;
var localized array<string> RedFogOptions;
var localized string EnableRedFogMod;
var localized string EnableRedFogModTooltip;
var localized string EnableRedFogLinearPenaltiesMod;
var localized string EnableRedFogModLinearPenaltiesTooltip;

// ***** SOLDIER LIST INFO CONFIGURATION ***** //

// ***** AUTORESOLVE COMBAT CONFIGURATION ***** //
var bool bSimCombatOptionEnabled;
var bool bEnableSimCombat;
var bool bEnableSimCombat_Cached;
var localized string EnableSimCombatMod;
var localized string EnableSimCombatModTooltip;

// ***** DELEGATE DEFINITIONS ***** //
//public delegate XComGameState_Unit GetBestDeployableSoldier(XComGameState_HeadquartersXCom XComHQ, optional bool bDontIncludeSquad=false, optional bool bAllowWoundedSoldiers = false);
//public delegate bool GetPersonnelStatus(XComGameState_Unit Unit, out string Status, out string TimeLabel, out string TimeValue, optional int MyFontSize = -1);

// ========================================================
// PROTOTYPE DEFINITIONS 
// ========================================================

function XComGameState_LWModOptions InitComponent(class NewClassType)
{
	super.InitComponent(NewClassType);
	CameraRotationIndex = default.DEFAULT_CAMERA_ROTATION_INDEX;
	CameraRotationIndex_Cached = CameraRotationIndex;
	return self;
}

function string GetTabText()
{
	return default.ToolboxTabName;
}

function InitModOptions()
{
	CameraRotationIndex_Cached = CameraRotationIndex;

	SquadSizeIndex_Cached = SquadSizeIndex;

	bRandomizedDamageEnabled_Cached = bRandomizedDamageEnabled;
	RandomizedDamageIndex_Cached = RandomizedDamageIndex;

	bRandomizedInitialStatsEnabled_Cached = bRandomizedInitialStatsEnabled;

	bRandomizedLevelupStatsEnabled_Cached = bRandomizedLevelupStatsEnabled;
	fPercentGuaranteedStat_Cached = fPercentGuaranteedStat;

	bRedFogXComActive_Cached = bRedFogXComActive;
	bRedFogAliensActive_Cached = bRedFogAliensActive;
	bRedFogLinearPenalties_Cached = bRedFogLinearPenalties;

	bEnableSimCombat_Cached = bEnableSimCombat;

}

static function XComGameState_LWToolboxPrototype GetToolboxPrototype()
{
	local XComGameState_CampaignSettings CampaignSettingsStateObject;

	CampaignSettingsStateObject = XComGameState_CampaignSettings(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings', true));
	if(CampaignSettingsStateObject != none)
		return XComGameState_LWToolboxPrototype(CampaignSettingsStateObject.FindComponentObject(class'XComGameState_LWToolboxOptions'));
	return none;
}

//returns the number of MechaItems set -- this is the number that will be enabled in the calling UIScreen
function int SetModOptionsEnabled(out array<UIMechaListItem> m_arrMechaItems)
{
	local int ButtonIdx;
	local XComGameState_BattleData BattleData;
	local bool bIsMultiplayer;

	BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData', true));
	bIsMultiplayer = BattleData != none && BattleData.IsMultiplayer();
	
	UpdateStrings();

	// Help Button -------------------------------------------------
	m_arrMechaItems[ButtonIdx].UpdateDataButton(HelpButtonLabel, HelpButtonLabelText, OpenHelpDialogue);
	m_arrMechaItems[ButtonIdx].BG.SetTooltipText(HelpButtonLabelTooltip, , , 10, , , , 0.0f);
	ButtonIdx++;

	// Camera Rotation: --------------------------------------------
	m_arrMechaItems[ButtonIdx].UpdateDataSpinner(SetCameraRotation, sCameraRotationOptions[CameraRotationIndex_Cached], UpdateCameraRotation_OnChanged);
	m_arrMechaItems[ButtonIdx].BG.SetTooltipText(SetCameraRotationTooltip, , , 10, , , , 0.0f);
	ButtonIdx++;

	if(bIsMultiplayer)
		return ButtonIdx;

	// Disabled for overhaul mod
	// Squad Size Selection: --------------------------------------------
	//m_arrMechaItems[ButtonIdx].UpdateDataSpinner(SelectSquadSize, sSquadSizeOptions[SquadSizeIndex_Cached], UpdateSquadSize_OnChanged);
	//m_arrMechaItems[ButtonIdx].BG.SetTooltipText(SelectSquadSizeTooltip, , , 10, , , , 0.0f);
	//ButtonIdx++;
	
	// DamageRoulette Spinner  --------------------------------------------
	m_arrMechaItems[ButtonIdx].UpdateDataSpinner(EnableRandomizedDamageMod, GetDamageRouletteSpinnerString(), UpdateRandomizedDamage_OnChanged);
	m_arrMechaItems[ButtonIdx].BG.SetTooltipText(EnableRandomizedDamageModTooltip, , , 10, , , , 0.0f);
	ButtonIdx++;

	// Randomized Initial Stats Enabled --------------------------------------------
	m_arrMechaItems[ButtonIdx].UpdateDataCheckbox(EnableRandomizedInitialStatsMod, "", bRandomizedInitialStatsEnabled_Cached, UpdateRandomizedInitialStatsEnabled);
	if(AnyActiveSoldierWounded() || GetTacticalPlayerTurnCount() > 1)
		m_arrMechaItems[ButtonIdx].SetDisabled(true, sCantChangeWithWoundedSoldiers);
	else
		m_arrMechaItems[ButtonIdx].BG.SetTooltipText(EnableRandomizedInitialStatsModTooltip, , , 10, , , , 0.0f);

	ButtonIdx++;	

	// Randomized Levelup Stats Enabled --------------------------------------------
	m_arrMechaItems[ButtonIdx].UpdateDataCheckbox(EnableRandomizedLevelupStatsMod, "", bRandomizedLevelupStatsEnabled_Cached, UpdateRandomizedLevelupStatsEnabled);
	m_arrMechaItems[ButtonIdx].BG.SetTooltipText(EnableRandomizedLevelupStatsModTooltip, , , 10, , , , 0.0f);
	ButtonIdx++;

	// Randomized Levelup Stats Guaranteed Amount: --------------------------------------------
	m_arrMechaItems[ButtonIdx].UpdateDataSlider(EnableRandomizedLevelupStatsMod, "", 100.0 - (fPercentGuaranteedStat_Cached * 100.0), , UpdateRandomizedStrength);
	m_arrMechaItems[ButtonIdx].Slider.SetText(GetRandomizedLevelUpStatsString());
	m_arrMechaItems[ButtonIdx].BG.SetTooltipText(RandomizedLevelupStrengthTooltip, , , 10, , , , 0.0f);
	ButtonIdx++;

	// Red Fog Spinner --------------------------------------------
	m_arrMechaItems[ButtonIdx].UpdateDataSpinner(EnableRedFogMod, GetRedFogSpinnerString(), UpdateRedFog_OnChanged);
	m_arrMechaItems[ButtonIdx].BG.SetTooltipText(EnableRedFogModTooltip, , , 10, , , , 0.0f);
	ButtonIdx++;

	// Linear Red Fog --------------------------------------------
	m_arrMechaItems[ButtonIdx].UpdateDataCheckbox(EnableRedFogLinearPenaltiesMod, "", bRedFogLinearPenalties_Cached, UpdateRedFogLinearPenaltiesEnabled);
	m_arrMechaItems[ButtonIdx].BG.SetTooltipText(EnableRedFogModLinearPenaltiesTooltip, , , 10, , , , 0.0f);
	ButtonIdx++;

	// SimCombat Enabled --------------------------------------------
	if(bSimCombatOptionEnabled)
	{
		m_arrMechaItems[ButtonIdx].UpdateDataCheckbox(EnableSimCombatMod, "", bEnableSimCombat_Cached, UpdateSimCombatEnabled);
		m_arrMechaItems[ButtonIdx].BG.SetTooltipText(EnableSimCombatModTooltip, , , 10, , , , 0.0f);
		ButtonIdx++;
	}

	return ButtonIdx;
}

//allow UIOptionsPCScreen to see if any value has been changed
function bool HasAnyValueChanged()
{
	if(CameraRotationIndex != CameraRotationIndex_Cached)
		return true;
	if(SquadSizeIndex != SquadSizeIndex_Cached)
		return true;
	if(bRandomizedDamageEnabled != bRandomizedDamageEnabled_Cached)
		return true;
	if(RandomizedDamageIndex != RandomizedDamageIndex_Cached)
		return true;
	if(bRandomizedInitialStatsEnabled != bRandomizedInitialStatsEnabled_Cached)
		return true;
	if(bRandomizedLevelupStatsEnabled != bRandomizedLevelupStatsEnabled_Cached)
		return true;
	if(fPercentGuaranteedStat != fPercentGuaranteedStat_Cached)
		return true;
	if(bRedFogXComActive != bRedFogXComActive_Cached)
		return true;
	if(bRedFogAliensActive != bRedFogAliensActive_Cached)
		return true;
	if(bRedFogLinearPenalties != bRedFogLinearPenalties_Cached)
		return true;
	if(bEnableSimCombat_Cached != bEnableSimCombat)
		return true;

	return false; 
}

//message to ModOptions to apply any cached/pending changes
function ApplyModSettings()
{
	local XComGameState_LWToolboxOptions UpdatedToolboxOptions;
	local XComGameStateContext_ChangeContainer ChangeContainer;
	local XComGameState NewGameState;

	ChangeContainer = class'XComGameStateContext_ChangeContainer'.static.CreateEmptyChangeContainer("Apply Toolbox Options");
	NewGameState = `XCOMHISTORY.CreateNewGameState(true, ChangeContainer);

	UpdatedToolboxOptions = XComGameState_LWToolboxOptions(NewGameState.CreateStateObject(Class, ObjectID));
	NewGameState.AddStateObject(UpdatedToolboxOptions);

	UpdatedToolboxOptions.CameraRotationIndex = CameraRotationIndex_Cached;

	UpdatedToolboxOptions.SquadSizeIndex = SquadSizeIndex_Cached;

	UpdatedToolboxOptions.bRandomizedDamageEnabled = bRandomizedDamageEnabled_Cached;
	UpdatedToolboxOptions.RandomizedDamageIndex = RandomizedDamageIndex_Cached;
	UpdatedToolboxOptions.UpdateWeaponTemplates_RandomizedDamage();

	if(bRandomizedInitialStatsEnabled != bRandomizedInitialStatsEnabled_Cached)
	{
		UpdatedToolboxOptions.bRandomizedInitialStatsEnabled = bRandomizedInitialStatsEnabled_Cached;
		UpdatedToolboxOptions.UpdatedRandomizedInitialStats(NewGameState);
	}

	if(bRandomizedLevelupStatsEnabled != bRandomizedLevelupStatsEnabled_Cached)
	{
		UpdatedToolboxOptions.bRandomizedLevelupStatsEnabled = bRandomizedLevelupStatsEnabled_Cached;
		UpdatedToolboxOptions.UpdateRandomizedLevelupStats(NewGameState);
	}
	if(fPercentGuaranteedStat != fPercentGuaranteedStat_Cached)
	{
		UpdatedToolboxOptions.fPercentGuaranteedStat = fPercentGuaranteedStat_Cached;
	}

	if(bRedFogXComActive || bRedFogXComActive_Cached
		|| bRedFogAliensActive || bRedFogAliensActive_Cached
		|| bRedFogLinearPenalties || bRedFogLinearPenalties_Cached)
	{
		UpdatedToolboxOptions.bRedFogXComActive = bRedFogXComActive_Cached;
		UpdatedToolboxOptions.bRedFogAliensActive = bRedFogAliensActive_Cached;
		UpdatedToolboxOptions.bRedFogLinearPenalties = bRedFogLinearPenalties_Cached;
		UpdatedToolboxOptions.ActivateRedFog(UpdatedToolboxOptions.bRedFogXComActive, UpdatedToolboxOptions.bRedFogAliensActive, NewGameState);
	}
	UpdatedToolboxOptions.bEnableSimCombat = bEnableSimCombat_Cached;

	if  (`TACTICALRULES != none && `TACTICALRULES.TacticalGameIsInPlay())
	{	
		`TACTICALRULES.SubmitGameState(NewGameState);
	}
	else
	{
		`GAMERULES.SubmitGameState(NewGameState);
	}

	// trigger the events to update red fog at this point
	SetRedFogAbilityActivation();
}

//message to ModOptions to restore any cached/pending changes if user aborts without applying changes
function RestorePreviousModSettings()
{
	CameraRotationIndex_Cached = CameraRotationIndex;

	SquadSizeIndex_Cached = SquadSizeIndex;

	bRandomizedDamageEnabled_Cached = bRandomizedDamageEnabled;
	RandomizedDamageIndex_Cached = RandomizedDamageIndex;

	bRandomizedInitialStatsEnabled_Cached = bRandomizedInitialStatsEnabled;

	bRandomizedLevelupStatsEnabled_Cached = bRandomizedLevelupStatsEnabled;
	fPercentGuaranteedStat_Cached = fPercentGuaranteedStat;

	bRedFogXComActive_Cached = bRedFogXComActive;
	bRedFogAliensActive_Cached = bRedFogAliensActive;
	bRedFogLinearPenalties_Cached = bRedFogLinearPenalties;

	bEnableSimCombat_Cached = bEnableSimCombat;
}

function bool CanResetModSettings() { return true; }

//message to ModOptions to reset any settings to "factory default"
function ResetModSettings()
{
	CameraRotationIndex_Cached = default.DEFAULT_CAMERA_ROTATION_INDEX;

	SquadSizeIndex_Cached = 0;

	bRandomizedDamageEnabled_Cached = false;
	RandomizedDamageIndex_Cached = 0;

	bRandomizedInitialStatsEnabled_Cached = false;

	bRandomizedLevelupStatsEnabled_Cached = false;
	fPercentGuaranteedStat_Cached = default.fPercentGuaranteedStat;

	bRedFogXComActive_Cached = false;
	bRedFogAliensActive_Cached = false;
	bRedFogLinearPenalties_Cached = false;

	bEnableSimCombat_Cached = false;
}

// ========================================================
// UI HELPERS 
// ========================================================

function UpdateStrings()
{
	local float Rotation;
	local int idx, Size;

	foreach default.CAMERA_ROTATION_OPTIONS_DEG(Rotation, idx)
	{
		sCameraRotationOptions[idx] = string(int(Rotation));
	}
	foreach default.SQUADSIZE_OPTIONS(Size, idx)
	{
		sSquadSizeOptions[idx] = string(Size);
	}
	foreach default.RANDOMIZED_DAMAGE_OPTIONS(Size, idx)
	{
		if(Size >= 100)
			sRandomizedDamageOptions[idx] = MaxDamage;
		else
			sRandomizedDamageOptions[idx] = string(Size) $ "%";

	}
}

function string GetRandomizedLevelUpStatsString()
{
	local XGParamTag kTag;
	local string ValueString;

	kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	kTag.IntValue0 = int(100.0 * (1.0 - fPercentGuaranteedStat_Cached));
	ValueString = RandomizedLevelupStrength;
	ValueString = class'UIUtilities_Text'.static.GetColoredText(ValueString, eUIState_Normal);
	ValueString = class'UIUtilities_Text'.static.AddFontInfo(ValueString, false, false, false, 20);
	//ValueString = class'UIUtilities_Text'.static.StyleText(ValueString, eUITextStyle_Body);
	return `XEXPAND.ExpandString(ValueString);
}

function string GetRedFogSpinnerString()
{
	return RedFogOptions[(bRedFogXComActive_Cached ? 1 : 0) + (bRedFogAliensActive_Cached ? 2 : 0)];
}

function string GetDamageRouletteSpinnerString()
{
	if(!bRandomizedDamageEnabled_Cached)
		return NormalDamage;
	else
		return sRandomizedDamageOptions[RandomizedDamageIndex_Cached];
}

// ========================================================
// GETTERS / SETTERS 
// ========================================================

static function XComGameState_LWToolboxOptions GetToolboxOptions()
{
	local XComGameState_CampaignSettings CampaignSettingsStateObject;

	CampaignSettingsStateObject = XComGameState_CampaignSettings(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings', true));
	if(CampaignSettingsStateObject != none)
		return XComGameState_LWToolboxOptions(CampaignSettingsStateObject.FindComponentObject(class'XComGameState_LWToolboxOptions'));
	return none;
}

// retrieves camera angle based on positive/negative and mask
static function EventListenerReturn OnGetCameraRotationAngle(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComLWTuple			Tuple;
	local int ActionMask;
	local bool bPositive;
	local float Angle;

	Tuple = XComLWTuple(EventData);
	if(Tuple == none)
	{
		`REDSCREEN("OnGetCameraRotationAngle event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}

	if (Tuple.Data[2].Kind == XComLWTVBool)
		bPositive = Tuple.Data[2].b;
	else
		return ELR_NoInterrupt;

	if (Tuple.Data[3].Kind == XComLWTVInt)
		ActionMask = Tuple.Data[3].i;
	else
		return ELR_NoInterrupt;
		
	if (( ActionMask & class'UIUtilities_Input'.const.FXS_ACTION_RELEASE) != 0)
	{
		Angle = GetRotationAngle();

		if (!bPositive)
			Angle = - Angle;

		Tuple.Data[0].f = Angle;
	}
	Tuple.Data[1].b = true;

	return ELR_NoInterrupt;
}

static function float GetRotationAngle()
{
	local XComGameState_LWToolboxOptions ToolboxOptions;

	ToolboxOptions = GetToolboxOptions();
	return default.CAMERA_ROTATION_OPTIONS_DEG[ToolboxOptions.CameraRotationIndex];
}

static function int GetMaxSquadSize(optional MissionDefinition Mission)
{
	//local XComGameState_LWToolboxOptions ToolboxOptions;
	local int MaxSquadSize;


	//ToolboxOptions = GetToolboxOptions();
	//MaxSquadSize = default.SQUADSIZE_OPTIONS[ToolboxOptions.SquadSizeIndex];
	if (Mission.MissionName == 'AlienNest' || Mission.MissionName == 'LastGift')
	{
		MaxSquadSize = 6;
	}
	else
	{
		MaxSquadSize = class'X2StrategyGameRulesetDataStructures'.default.m_iMaxSoldiersOnMission;
	}
	return MaxSquadSize;
}

static function SetDefaultMaxSquadSize(int NewSize)
{
	local object CDO;
	local X2StrategyGameRulesetDataStructures DataStructures;

	CDO = class'Engine'.static.FindClassDefaultObject("X2StrategyGameRulesetDataStructures");
	DataStructures = X2StrategyGameRulesetDataStructures(CDO);
	DataStructures.m_iMaxSoldiersOnMission = NewSize;
}

static function UpdateDefaultMaxSquadSize()
{
	local Object ThisObj;

	//SetDefaultMaxSquadSize(GetMaxSquadSize());
	ThisObj = GetToolboxOptions();
	`XEVENTMGR.RegisterForEvent(ThisObj, 'OnTacticalBeginPlay', OnTacticalBeginPlay, ELD_OnStateSubmitted, 10 /* High priority so soldier are spawned in before anything else*/ ,, true);
}

simulated function RegisterListeners()
{
	local Object ThisObj;
	local X2EventManager EventManager;

	EventManager = `XEVENTMGR;
	ThisObj = self;
	EventManager.RegisterForEvent(ThisObj, 'OnTacticalBeginPlay', OnTacticalBeginPlay, ELD_OnStateSubmitted, 10 /* High priority so soldier are spawned in before anything else*/ ,, true);
	EventManager.RegisterForEvent(ThisObj, 'OnDismissSoldier', CleanUpComponentStateOnDismiss, ELD_OnStateSubmitted,,,true);

	// Hooks added in overhaul mod into XComGame
	// angle rotation
	EventManager.RegisterForEvent(ThisObj, 'GetCameraRotationAngle', OnGetCameraRotationAngle, ELD_Immediate,,,true);

	// recruit listitem modification
	EventManager.RegisterForEvent(ThisObj, 'OnRecruitmentListItemInit', AddRecruitStats, ELD_Immediate,,,true);
	EventManager.RegisterForEvent(ThisObj, 'OnRecruitmentListItemUpdateFocus', UpdateRecruitFocus, ELD_Immediate,,,true);
}

// adds elements to Recruit list items
static function EventListenerReturn AddRecruitStats(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_Unit Recruit;
	local UIRecruitmentListItem ListItem;

	Recruit = XComGameState_Unit(EventData);
	if(Recruit == none)
	{
		`REDSCREEN("AddRecruitStats event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}
	ListItem = UIRecruitmentListItem(EventSource);
	if(ListItem == none)
	{
		`REDSCREEN("AddRecruitStats event triggered with invalid event source.");
		return ELR_NoInterrupt;
	}
	class'UIRecruitmentListItem_LW'.static.AddRecruitStats(Recruit, ListItem);

	return ELR_NoInterrupt;
}

// updates recruit list item for focus changes
static function EventListenerReturn UpdateRecruitFocus(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local UIRecruitmentListItem ListItem;

	ListItem = UIRecruitmentListItem(EventSource);
	if(ListItem == none)
	{
		`REDSCREEN("AddRecruitStats event triggered with invalid event source.");
		return ELR_NoInterrupt;
	}
	class'UIRecruitmentListItem_LW'.static.UpdateItemsForFocus(ListItem);

	return ELR_NoInterrupt;
}

//API access for other mods to directly change max squad size
static function SetMaxSquadSize(int NewSize)
{
	local XComGameState_LWToolboxOptions ToolboxOptions, UpdatedToolboxOptions;
	local XComGameStateContext_ChangeContainer ChangeContainer;
	local XComGameState UpdateState;
	local int NewIndex;

	NewIndex = default.SQUADSIZE_OPTIONS.Find(NewSize);
	if(NewIndex == -1) return;

	ChangeContainer = class'XComGameStateContext_ChangeContainer'.static.CreateEmptyChangeContainer("API Change Squadsize");
	UpdateState = `XCOMHISTORY.CreateNewGameState(true, ChangeContainer);

	ToolboxOptions = GetToolboxOptions();
	UpdatedToolboxOptions = XComGameState_LWToolboxOptions(UpdateState.CreateStateObject(class'XComGameState_LWToolboxOptions', ToolboxOptions.ObjectID));

	NewIndex = UpdatedToolboxOptions.default.SQUADSIZE_OPTIONS.Find(NewSize);
	UpdatedToolboxOptions.SquadSizeIndex = NewIndex;
	UpdateState.AddStateObject(UpdatedToolboxOptions);
	`GAMERULES.SubmitGameState(UpdateState);
}

static function SetMissionMaxSoldiersOverride(name MissionName, MissionMaxSoldiersOverrideType Type, optional float Value = 1.0)
{
	local MissionOverride Override;
	local XComGameState_LWToolboxOptions ToolboxOptions, UpdatedToolboxOptions;
	local XComGameStateContext_ChangeContainer ChangeContainer;
	local XComGameState UpdateState;
	local int idx;

	ChangeContainer = class'XComGameStateContext_ChangeContainer'.static.CreateEmptyChangeContainer("API Set Mission Squadsize Override");
	UpdateState = `XCOMHISTORY.CreateNewGameState(true, ChangeContainer);

	ToolboxOptions = GetToolboxOptions();
	UpdatedToolboxOptions = XComGameState_LWToolboxOptions(UpdateState.CreateStateObject(class'XComGameState_LWToolboxOptions', ToolboxOptions.ObjectID));

	Override.MissionName = MissionName;
	Override.Type = Type;
	Override.Value = Value;

	idx = UpdatedToolboxOptions.arrMissionOverrides.Find('MissionName', MissionName);
	if(idx == -1)
		UpdatedToolboxOptions.arrMissionOverrides.AddItem(Override);
	else
		UpdatedToolboxOptions.arrMissionOverrides[idx] = Override;

	UpdateState.AddStateObject(UpdatedToolboxOptions);
	`GAMERULES.SubmitGameState(UpdateState);
}

static function int GetMissionMaxSoldiersOverride(MissionDefinition MissionData)
{
	local XComGameState_LWToolboxOptions ToolboxOptions;
	local int idx, MaxSoldiers;
	local MissionOverride Override;

	MaxSoldiers = MissionData.MaxSoldiers;
	ToolboxOptions = GetToolboxOptions();
	switch(MissionData.MissionName)
	{
		case 'AvengerDefense':
			MaxSoldiers = ToolboxOptions.GetMaxSquadSize() + 2;
			break;
		//case 'CentralNetworkBroadcast':
			//MaxSoldiers = (ToolboxOptions.GetMaxSquadSize() + 2)/2;	
			//break;
		default:
			break;
	}

	idx = ToolboxOptions.arrMissionOverrides.Find('MissionName', MissionData.MissionName);
	if(idx != -1)
	{
		Override = ToolboxOptions.arrMissionOverrides[idx];
		switch(Override.Type)
		{
			case eMMSoldiers_Fixed:
				MaxSoldiers = Override.Value;
				break;
			case eMMSoldiers_Ratio:
				MaxSoldiers = int(float(ToolboxOptions.GetMaxSquadSize()) * Override.Value + 0.5) ;
				break;
			case eMMSoldiers_Additive:
				MaxSoldiers = ToolboxOptions.GetMaxSquadSize() + int(Override.Value);
				break;
			case eMMSoldiers_Default:
				MaxSoldiers = MissionData.MaxSoldiers;
				break;
			default:
				break;
		}
	}
	return MaxSoldiers;
}

static function OverrideRedFogHealingType(ERedFogHealingType NewType)
{
	local XComGameState_LWToolboxOptions ToolboxOptions, UpdatedToolboxOptions;
	local XComGameStateContext_ChangeContainer ChangeContainer;
	local XComGameState UpdateState;

	ChangeContainer = class'XComGameStateContext_ChangeContainer'.static.CreateEmptyChangeContainer("API Change RedFogHealingType");
	UpdateState = `XCOMHISTORY.CreateNewGameState(true, ChangeContainer);
	ToolboxOptions = GetToolboxOptions();
	UpdatedToolboxOptions = XComGameState_LWToolboxOptions(UpdateState.CreateStateObject(class'XComGameState_LWToolboxOptions', ToolboxOptions.ObjectID));

	UpdatedToolboxOptions.RFHealingTypeOverride = NewType;

	UpdateState.AddStateObject(UpdatedToolboxOptions);
	`GAMERULES.SubmitGameState(UpdateState);
}

function ERedFogHealingType GetRedFogHealingType()
{
	if(RFHealingTypeOverride == eRFHealing_Undefined)
		return default.RedFogHealingType;
	else
		return RFHealingTypeOverride;
}

static function OverrideRedFogPenaltyType(EStatModOp NewType)
{
	local XComGameState_LWToolboxOptions ToolboxOptions, UpdatedToolboxOptions;
	local XComGameStateContext_ChangeContainer ChangeContainer;
	local XComGameState UpdateState;

	ChangeContainer = class'XComGameStateContext_ChangeContainer'.static.CreateEmptyChangeContainer("API Change RedFogPenaltyType");
	UpdateState = `XCOMHISTORY.CreateNewGameState(true, ChangeContainer);
	ToolboxOptions = GetToolboxOptions();
	UpdatedToolboxOptions = XComGameState_LWToolboxOptions(UpdateState.CreateStateObject(class'XComGameState_LWToolboxOptions', ToolboxOptions.ObjectID));

	UpdatedToolboxOptions.bOverriddenRedFogPenaltyType = true;
	UpdatedToolboxOptions.RedFogPenaltyTypeOverride = NewType;

	UpdateState.AddStateObject(UpdatedToolboxOptions);
	`GAMERULES.SubmitGameState(UpdateState);
}

function EStatModOp GetRedFogPenaltyType()
{
	if(bOverriddenRedFogPenaltyType)
		return RedFogPenaltyTypeOverride;
	else
		return default.RedFogPenaltyType;
}


// ========================================================
// DATA HOOKS 
// ========================================================

// ======= HELP BUTTON  ======= // 

public function OpenHelpDialogue(UIButton ButtonSource)
{
	local TDialogueBoxData kDialogData;
	local XComPresentationLayerBase PresBase;

	PresBase = XComPlayerController(class'WorldInfo'.static.GetWorldInfo().GetALocalPlayerController()).Pres;

	kDialogData.strTitle = ToolboxTabName;

	kDialogData.strText = "";
	kDialogData.strText $= CAPS(SetCameraRotation) $ "<br/>";
	kDialogData.strText $= SetCameraRotationTooltip $ "<br/><br/>";

	//kDialogData.strText $= CAPS(SelectSquadSize) $ "<br/>";
	//kDialogData.strText $= SelectSquadSizeTooltip $ "<br/><br/>";

	kDialogData.strText $= CAPS(EnableRandomizedDamageMod) $ "<br/>";
	kDialogData.strText $= EnableRandomizedDamageModTooltip $ "<br/><br/>";

	kDialogData.strText $= CAPS(EnableRandomizedInitialStatsMod) $ "<br/>";
	kDialogData.strText $= EnableRandomizedInitialStatsModTooltip $ "<br/><br/>";

	kDialogData.strText $= CAPS(EnableRandomizedLevelupStatsMod) $ "<br/>";
	kDialogData.strText $= EnableRandomizedLevelupStatsModTooltip $ "<br/><br/>";

	kDialogData.strText $= CAPS(EnableRedFogMod) $ "<br/>";
	kDialogData.strText $= EnableRedFogModTooltip $ "<br/><br/>";

	kDialogData.strText $= CAPS(EnableRedFogLinearPenaltiesMod) $ "<br/>";
	kDialogData.strText $= EnableRedFogModLinearPenaltiesTooltip $ "<br/><br/>";

	kDialogData.strText $= CAPS(EnableSimCombatMod) $ "<br/>";
	kDialogData.strText $= EnableSimCombatModTooltip;

	kDialogData.strCancel = PresBase.default.m_strOK;

	PresBase.UIRaiseDialog(kDialogData);
}

// ======= CAMERA ROTATION  ======= // 

public function UpdateCameraRotation_OnChanged(UIListItemSpinner SpinnerControl, int Direction)
{
	CameraRotationIndex_Cached += direction;

	if (CameraRotationIndex_Cached < 0)
		CameraRotationIndex_Cached = sCameraRotationOptions.Length - 1;
	else if (CameraRotationIndex_Cached > sCameraRotationOptions.Length - 1)
		CameraRotationIndex_Cached = 0;

	SpinnerControl.SetValue(sCameraRotationOptions[CameraRotationIndex_Cached]);

	`SOUNDMGR.PlaySoundEvent("Play_MenuSelect");
}

// ======= SQUAD SIZE  ======= // 

public function UpdateSquadSize_OnChanged(UIListItemSpinner SpinnerControl, int Direction)
{
	
	SquadSizeIndex_Cached += direction;

	if (SquadSizeIndex_Cached < 0)
		SquadSizeIndex_Cached = sSquadSizeOptions.Length - 1;
	else if (SquadSizeIndex_Cached > sSquadSizeOptions.Length - 1)
		SquadSizeIndex_Cached = 0;

	SpinnerControl.SetValue(sSquadSizeOptions[SquadSizeIndex_Cached]);
	//SetDefaultMaxSquadSize(SQUADSIZE_OPTIONS[SquadSizeIndex]);
	`SOUNDMGR.PlaySoundEvent("Play_MenuSelect");
}

// loops over units in XComHQ.Squad and spawns in any that aren't in play yet -- post-AlienHunters, also re-registers the HP GameStateListener
function EventListenerReturn OnTacticalBeginPlay(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameStateHistory History;
	local int idx;
	local XComGameState_Unit UnitState;

	`LOG("SquadSize Listener: Starting to add additional squad members",, 'LW_Toolbox');
	XComHQ = `XCOMHQ;
	History = `XCOMHISTORY;
	for(idx = 0; idx < XComHQ.Squad.Length; idx++)
	{
		`LOG("SquadSize Listener: Checking Squad index=" $ idx,, 'LW_Toolbox');
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(XComHQ.Squad[idx].ObjectID));
		if(UnitState != none)
		{
			`LOG("SquadSize Listener: Accessed Unit, Name=" $ UnitState.GetFullName(),, 'LW_Toolbox');
			if(UnitState.GetVisualizer() == none)
			{
				`LOG("SquadSize Listener: Unit has no visualizer, attempting to spawn unit",, 'LW_Toolbox');
				class'LWSpawnUnitFromAvenger'.static.SpawnUnitFromAvenger(UnitState.GetReference());
				UnitState.OnBeginTacticalPlay(GameState);
			}
		}
	}

	//test removing this now that the persistent flag has been removed from the event listener
	//CleanupRedFog();

	//re-register the HP gamestate listener, since this appears to be cleaned up when switching from strategy to tactical
	if(bRedFogXComActive || bRedFogAliensActive)
		History.RegisterOnNewGameStateDelegate(OnNewGameState_HealthWatcher);

	return ELR_NoInterrupt;
}

// ======= RANDOMIZED DAMGE  ======= // 

public function UpdateRandomizedDamage_OnChanged(UIListItemSpinner SpinnerControl, int Direction)
{
	local int Index;

	if(!bRandomizedDamageEnabled_Cached)
		Index = 0;
	else
		Index = RandomizedDamageIndex_Cached + 1;

	Index += direction;

	if(Index < 0)
		Index = default.RANDOMIZED_DAMAGE_OPTIONS.Length;
	else if(Index > default.RANDOMIZED_DAMAGE_OPTIONS.Length)
		Index = 0;

	if(Index == 0)
		bRandomizedDamageEnabled_Cached = false;
	else
	{
		bRandomizedDamageEnabled_Cached = true;
		RandomizedDamageIndex_Cached = Index - 1;
	}

	SpinnerControl.SetValue(GetDamageRouletteSpinnerString());
	`SOUNDMGR.PlaySoundEvent("Play_MenuSelect");
}

function EventListenerReturn PostGameLoad(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	`LOG("ToolboxOptions: PostGameLoad called",, 'LW_Toolbox');
	UpdateWeaponTemplates_RandomizedDamage();

	return ELR_NoInterrupt;
}

function UpdateWeaponTemplates_RandomizedDamage()
{
	local X2ItemTemplateManager ItemTemplateManager;
	local int DifficultyIndex, OriginalDifficulty, OriginalLowestDifficulty;
	local XComGameState_CampaignSettings Settings;
	local XComGameStateHistory History;
	local X2WeaponTemplate Template;
	local array<X2WeaponTemplate> WeaponTemplates;
	local int WeaponIdx;
	local array<DefaultBaseDamageEntry> arrDefaultBaseDamage;
	local X2DownloadableContentInfo_LWToolbox ToolboxInfo;

	`LOG("ToolboxOptions: Updating Weapon Templates for Randomized Damage");

	ToolboxInfo = class'X2DownloadableContentInfo_LWToolbox'.static.GetThisDLCInfo();
	if (ToolboxInfo == none)
	{
		`REDSCREEN("Unable to find X2DLCInfo");
		return;
	}
	arrDefaultBaseDamage = ToolboxInfo.arrDefaultBaseDamage;

	History = `XCOMHISTORY;
	// The CampaignSettings are initialized in CreateStrategyGameStart, so we can pull it from the history here
	Settings = XComGameState_CampaignSettings(History.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings', true));

	OriginalDifficulty = Settings.DifficultySetting;
	OriginalLowestDifficulty = Settings.LowestDifficultySetting;

	//get access to item element template manager
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	if (ItemTemplateManager == none) {
		`Redscreen("LW Toolbox : failed to retrieve ItemTemplateManager to modify Spread");
		return;
	}

	for( DifficultyIndex = `MIN_DIFFICULTY_INDEX; DifficultyIndex <= `MAX_DIFFICULTY_INDEX; ++DifficultyIndex )
	{
		// WOTC TODO: Work out whether I'm setting the correct boolean parameter here, since there
		// are two of them and I don't know what the original one was.
		Settings.SetDifficulty(DifficultyIndex, , , , , true);
		//(int , optional float NewTacticalDifficulty = -1, optional float NewStrategyDifficulty = -1, optional float NewGameLength = -1, optional bool IsPlayingGame = false, optional bool InitialDifficultyUpdate = false)

		WeaponTemplates = ItemTemplateManager.GetAllWeaponTemplates();
	
		foreach WeaponTemplates(Template)
		{
			if(bRandomizedDamageEnabled)
			{
				Template.BaseDamage.Spread = Min(Template.BaseDamage.Damage - 1, (Template.BaseDamage.Damage * default.RANDOMIZED_DAMAGE_OPTIONS[RandomizedDamageIndex] + 50) / 100);
			}
			else
			{
				WeaponIdx = arrDefaultBaseDamage.Find('WeaponTemplateName', Template.DataName);
				if (WeaponIdx == -1)
					Template.BaseDamage.Spread = Template.default.BaseDamage.Spread;
				else
					Template.BaseDamage.Spread = arrDefaultBaseDamage[WeaponIdx].BaseDamage.Spread;
			}
		}

	}

	//restore difficulty settings
	Settings.SetDifficulty(OriginalLowestDifficulty, , , , , true);
	Settings.SetDifficulty(OriginalDifficulty, , , , , false);		
}

// ======= RANDOMIZED INITIAL STATS ======= // 

function UpdateRandomizedInitialStatsEnabled(UICheckbox CheckboxControl)
{
	if(AnyActiveSoldierWounded() || GetTacticalPlayerTurnCount() > 1)
	{
		CheckBoxControl.SetChecked(bRandomizedInitialStatsEnabled_Cached);
		`SOUNDMGR.PlaySoundEvent("Play_MenuClickNegative");
	}
	else
	{
		bRandomizedInitialStatsEnabled_Cached = CheckboxControl.bChecked;
		`SOUNDMGR.PlaySoundEvent("Play_MenuSelect");
	}
}

function int GetTacticalPlayerTurnCount()
{
	local XComGameStateHistory History;
	local XComGameState_Player PlayerState;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_Player', PlayerState)
	{
		if(PlayerState.GetTeam() == eTeam_XCom)
		{
			break;
		}
	}

	if(PlayerState == none) 
	{ 
		`LOG("ToolboxOptions: Failed to find PlayerState.");
		return -1; 
	}
	//`LOG("ToolboxOptions: PlayerTurnCount=" $ PlayerState.PlayerTurnCount);
	return PlayerState.PlayerTurnCount;
}

function bool AnyActiveSoldierWounded()
{
	local XComGameStateHistory History;
	local XComGameState_Unit Unit; 
	local bool TacticalGameInPlay;

	if(`TACTICALRULES == none)
		TacticalGameInPlay = true;
	else
		TacticalGameInPlay = `TACTICALRULES.TacticalGameIsInPlay();	

	//`LOG("ToolboxOptions.AnyActiveSoldierWounded: Tactical Game in play =" @ TacticalGameInPlay);

	if (!TacticalGameInPlay)
		return false;

	History = `XCOMHISTORY;
	foreach History.IterateByClassType(class'XComGameState_Unit', Unit)
	{
		if(IsEligibleForRandomStats(Unit) && Unit.GetVisualizer() != none)
		{
			if(Unit.GetMaxStat(eStat_HP) != Unit.GetCurrentStat(eStat_HP))
				return true;
		}
	}
	return false;
}

function UpdatedRandomizedInitialStats(optional XComGameState NewGameState)
{
	local X2EventManager EventManager;
	local Object ThisObj;

	UpdateSoldiers_RandomizedInitialStats(NewGameState);

	UpdateRewardSoldierTemplates();  // update the templates with new GeneratePersonnel delegates to add EventIDs needed

	//register for update events
	EventManager = `XEVENTMGR;
	ThisObj = self;
	if(bRandomizedInitialStatsEnabled)
	{
		EventManager.RegisterForEvent( ThisObj, 'OnMonthlyReportAlert', OnMonthEnd, ELD_OnStateSubmitted,,,true); //end of month handling of new recruits at Resistance HQ
		EventManager.RegisterForEvent( ThisObj, 'SoldierCreatedEvent', OnSoldierCreatedEvent, ELD_OnStateSubmitted,,,true); //handles reward soldier creation, both for missions and purchase-able
	} else {
		EventManager.UnRegisterFromEvent( ThisObj, 'OnMonthlyReportAlert');
		EventManager.UnRegisterFromEvent( ThisObj, 'SoldierCreatedEvent');
	}

}

function UpdateSoldiers_RandomizedInitialStats(optional XComGameState NewGameState)
{
	//local XComGameStateContext_ChangeContainer ChangeContainer;
	//local XComGameState GameState;
	local string ChangeString;
	local bool NeedsSubmit;

	NeedsSubmit = NewGameState == none;

	//Build GameState change container
	ChangeString = "Toggle Randomized Initial Stats";
	if(bRandomizedInitialStatsEnabled)
		ChangeString @= "(On)";
	else
		ChangeString @= "(Off)";

	if(NewGameState == none)
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(ChangeString);
	
	UpdateAllSoldiers_RandomizedInitialStats(NewGameState);

	if(NeedsSubmit)
	{
		if (`TACTICALRULES.TacticalGameIsInPlay())
		{	
			`TACTICALRULES.SubmitGameState(NewGameState);
		}
		else
		{
			`GAMERULES.SubmitGameState(NewGameState);
		}
	}
}

function bool IsEligibleForRandomStats(XComGameState_Unit Unit)
{
	// Note: This specifically looks for 'Soldier' and not Unit.IsSoldier() to exclude sparks. Additional character types can
	// be re-added via the ExtraCharacterTemplatesToRandomize array.
	return Unit.GetMyTemplateName() == 'Soldier' || ExtraCharacterTemplatesToRandomize.Find(Unit.GetMyTemplateName()) >= 0;
}

function UpdateAllSoldiers_RandomizedInitialStats(XComGameState GameState)
{
	local XComGameStateHistory History;
	local XComGameState StrategyState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit Unit, StrategyUnit; 
	local int LastStrategyStateIndex;
	local array<StateObjectReference> UnitsInPlay;

	History = `XCOMHISTORY;

	foreach GameState.IterateByClassType(class'XComGameState_Unit', Unit)
	{
		//`LOG("Stat randomization: Checking history for units, found " $  Unit.GetFullName(),, 'LW_Toolbox');
		if(IsEligibleForRandomStats(Unit))
		{
			UnitsInPlay.AddItem(Unit.GetReference());
			UpdateOneSoldier_RandomizedInitialStats(Unit, GameState);
		}
	}
	foreach History.IterateByClassType(class'XComGameState_Unit', Unit,, true)
	{
		//`LOG("Stat randomization: Checking history for units, found " $  Unit.GetFullName(),, 'LW_Toolbox');
		if(IsEligibleForRandomStats(Unit))
		{
			UnitsInPlay.AddItem(Unit.GetReference());
			UpdateOneSoldier_RandomizedInitialStats(Unit, GameState);
		}
	}
	if (`TACTICALRULES.TacticalGameIsInPlay())
	{
		// grab the archived strategy state from the history and the headquarters object
		LastStrategyStateIndex = History.FindStartStateIndex() - 1;
		StrategyState = History.GetGameStateFromHistory(LastStrategyStateIndex, eReturnType_Copy, false);
		foreach StrategyState.IterateByClassType(class'XComGameState_HeadquartersXCom', XComHQ)
		{
			break;
		}
		//XComHQ = `XCOMHQ;
		if(XComHQ == none)
		{
			`Redscreen("UpdateAllSoldiers_RandomizedInitialStats: Could not find an XComGameState_HeadquartersXCom state in the archive!");
		}

		//`LOG("Stat randomization: LastStrategyStateIndex=" $ LastStrategyStateIndex,, 'LW_Toolbox');
		if(LastStrategyStateIndex > 0)
		{
			foreach StrategyState.IterateByClassType(class'XComGameState_Unit', StrategyUnit)
			{
				//`LOG("Stat randomization: Checking last StrategyState for strategy units, found " $  StrategyUnit.GetFullName(),, 'LW_Toolbox');

				// must be an eligible unit type (not randomizing Bradford, Tygan and Shen)
				if (!IsEligibleForRandomStats(StrategyUnit))
					continue;

				// only if not already on the board
				if(UnitsInPlay.Find('ObjectID', StrategyUnit.ObjectID) != INDEX_NONE)
					continue;

				UpdateOneSoldier_RandomizedInitialStats(StrategyUnit, GameState);
			}
		}
	}
}

function UpdateOneSoldier_RandomizedInitialStats(XComGameState_Unit Unit, XComGameState GameState)
{
	local XComGameState_Unit UpdatedUnit;
	local XComGameState_Unit_LWRandomizedStats RandomizedStatsState, SearchRandomizedStats;

	UpdatedUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(Unit.ObjectID));
	if(UpdatedUnit == none || UpdatedUnit.bReadOnly)
	{
		UpdatedUnit = XComGameState_Unit(GameState.CreateStateObject(class'XComGameState_Unit', Unit.ObjectID));
		GameState.AddStateObject(UpdatedUnit);
	}

	if (!IsEligibleForRandomStats(Unit))
		return;

	if(GameState != none)
	{
		//first look in the supplied gamestate
		foreach GameState.IterateByClassType(class'XComGameState_Unit_LWRandomizedStats', SearchRandomizedStats)
		{
			if(SearchRandomizedStats.OwningObjectID == Unit.ObjectID)
			{
				RandomizedStatsState = SearchRandomizedStats;
				break;
			}
		}
	}
	if(RandomizedStatsState == none)
	{
		//try and pull it from the history
		RandomizedStatsState = XComGameState_Unit_LWRandomizedStats(Unit.FindComponentObject(class'XComGameState_Unit_LWRandomizedStats'));
		if(RandomizedStatsState != none)
		{
			//if found in history, create an update copy for submission
			RandomizedStatsState = XComGameState_Unit_LWRandomizedStats(GameState.CreateStateObject(RandomizedStatsState.Class, RandomizedStatsState.ObjectID));
			GameState.AddStateObject(RandomizedStatsState);
		}
	}
	if(RandomizedStatsState == none)
	{
		//first time randomizing, create component gamestate and attach it
		RandomizedStatsState = XComGameState_Unit_LWRandomizedStats(GameState.CreateStateObject(class'XComGameState_Unit_LWRandomizedStats'));
		UpdatedUnit.AddComponentObject(RandomizedStatsState);
		GameState.AddStateObject(RandomizedStatsState);
	}

	RandomizedStatsState.ApplyRandomInitialStats(UpdatedUnit, bRandomizedInitialStatsEnabled);
}

function EventListenerReturn OnMonthEnd(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState NewGameState;
	local string ChangeString;

	if(!GameState.bReadOnly)
	{
		UpdateAllSoldiers_RandomizedInitialStats(GameState);
	}
	else 	// when read-only we need to create and submit our own gamestate
	{
		//Build GameState change container
		ChangeString = "Toggle Randomized Initial Stats";
		if(bRandomizedInitialStatsEnabled)
			ChangeString @= "(On)";
		else
			ChangeString @= "(Off)";

		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(ChangeString);

		UpdateAllSoldiers_RandomizedInitialStats(NewGameState);

		if (`TACTICALRULES.TacticalGameIsInPlay())
		{	
			`TACTICALRULES.SubmitGameState(NewGameState);
		}
		else
		{
			`GAMERULES.SubmitGameState(NewGameState);
		}
	}
	return ELR_NoInterrupt;
}

function EventListenerReturn OnSoldierCreatedEvent(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_Unit Unit;
	local XComGameState NewGameState;
	local string ChangeString;

	Unit = XComGameState_Unit(EventData);
	if(Unit == none) 
	{
		`REDSCREEN("ToolboxOptions.OnSoldierCreatedEvent with no UnitState EventData");
		return ELR_NoInterrupt;
	}

	if(!GameState.bReadOnly)
	{
		UpdateOneSoldier_RandomizedInitialStats(Unit, GameState);
	}
	else 	// when read-only we need to create and submit our own gamestate
	{
		//Build GameState change container
		ChangeString = "Toggle Randomized Initial Stats";
		if(bRandomizedInitialStatsEnabled)
			ChangeString @= "(On)";
		else
			ChangeString @= "(Off)";

		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(ChangeString);

		UpdateOneSoldier_RandomizedInitialStats(Unit, NewGameState);

		if (`TACTICALRULES.TacticalGameIsInPlay())
		{	
			`TACTICALRULES.SubmitGameState(NewGameState);
		}
		else
		{
			`GAMERULES.SubmitGameState(NewGameState);
		}
	}

	return ELR_NoInterrupt;
}

// ======= RANDOMIZED LEVELUP STATS ======= // 

function UpdateRandomizedLevelupStatsEnabled(UICheckbox CheckboxControl)
{
	bRandomizedLevelupStatsEnabled_Cached = CheckboxControl.bChecked;
	`SOUNDMGR.PlaySoundEvent("Play_MenuSelect");
}

function UpdateRandomizedLevelupStats(optional XComGameState UpdateState)
{
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	if(bRandomizedLevelupStatsEnabled)
		History.RegisterOnNewGameStateDelegate(OnNewGameState_RankWatcher);
	else	
		History.UnRegisterOnNewGameStateDelegate(OnNewGameState_RankWatcher);
}

public function UpdateRandomizedStrength(UISlider SliderControl)
{
	fPercentGuaranteedStat_Cached = 1.0 - (SliderControl.percent / 100.0);
	SliderControl.SetText(GetRandomizedLevelUpStatsString());
	`SOUNDMGR.PlaySoundEvent("Play_MenuSelect");
}

//register to receive new gamestates in order to update RedFog whenever HP changes on a unit, and in tactical
function OnNewGameState_RankWatcher(XComGameState GameState)
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local int StateObjectIndex;
	local int idx, PreviousRank, CurrentRank;
	local XComGameState_Unit RankChangedUnit, UpdatedUnit, PreviousUnitState;
	local array<XComGameState_Unit> RankChangedObjects;  // is generically just a XComGameState_BaseObject, post the change

	if(!bRandomizedLevelupStatsEnabled)
		return; 

	RankChangedObjects.Length = 0;
	GetRankChangedObjectList(GameState, RankChangedObjects);
	
	if(RankChangedObjects.Length == 0)
		return;

	History = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Update RandomizedLevelupStats OnNewGameState_RankWatcher");
	for( StateObjectIndex = 0; StateObjectIndex < RankChangedObjects.Length; ++StateObjectIndex )
	{	
		RankChangedUnit = RankChangedObjects[StateObjectIndex];
		PreviousUnitState = XcomGameState_Unit(History.GetGameStateForObjectID(RankChangedUnit.ObjectID, , GameState.HistoryIndex - 1));

		if (!IsEligibleForRandomStats(PreviousUnitState))
			continue;

		PreviousRank = PreviousUnitState.GetRank();
		CurrentRank = RankChangedUnit.GetRank() ;

		UpdatedUnit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', RankChangedUnit.ObjectID));
		NewGameState.AddStateObject(UpdatedUnit);

		//reset randomized stats back to previous value
		for(idx=0; idx < eStat_MAX ; idx++)
		{
			if(class'XComGameState_Unit_LWRandomizedStats'.default.RANDOMIZED_LEVELUP_STATS.Find(ECharStatType(idx)) != -1)
			{
				if (ECharStatType(idx) == eStat_Will && PreviousUnitState.bIsShaken)
					UpdatedUnit.SavedWillValue = PreviousUnitState.SavedWillValue;
				else
					UpdatedUnit.SetBaseMaxStat(ECharStatType(idx), PreviousUnitState.GetBaseStat(ECharStatType(idx)));
			}
		}

 		for(idx = PreviousRank; idx < CurrentRank; idx++)
		{
			ApplyRankUpRandomizedStats(UpdatedUnit, idx, NewGameState);
		}
	}
	if(NewGameState.GetNumGameStateObjects() > 0)
		`GAMERULES.SubmitGameState(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);
}



//extract the XCGS_Unit object that have their Rank stat changed
function GetRankChangedObjectList(XComGameState NewGameState, out array<XComGameState_Unit> OutRankChangedObjects)
{
	local XComGameStateHistory History;
	local int StateObjectIndex;
	local XComGameState_BaseObject StateObjectCurrent;
	local XComGameState_BaseObject StateObjectPrevious;
	local XComGameState_Unit UnitStateCurrent, UnitStatePrevious;

	History = `XCOMHISTORY;
	
	foreach NewGameState.IterateByClassType(class'XComGameState_Unit', UnitStateCurrent)
	{
		StateObjectPrevious = History.GetGameStateForObjectID(StateObjectCurrent.ObjectID, , NewGameState.HistoryIndex - 1);
		UnitStatePrevious = XComGameState_Unit(StateObjectPrevious);

		if(UnitStatePrevious != none && UnitStateCurrent.GetRank() != UnitStatePrevious.GetRank())
		{
			OutRankChangedObjects.AddItem(UnitStateCurrent);
		}
	}
}

function ApplyRankUpRandomizedStats(XComGameState_Unit UnitState, int NewRank, XComGameState GameState)
{
	local int idx;
	local float BaseStat, NewValue, AutoIncrease, RandIncrease, ClampStat;
	local float PctAuto;
	local float Increase1, Increase2;

	if(UnitState == none)
		return;

	PctAuto = fPercentGuaranteedStat;

	for(idx=0; idx < eStat_Max ; idx++)
	{
		if(class'XComGameState_Unit_LWRandomizedStats'.default.RANDOMIZED_LEVELUP_STATS.Find(ECharStatType(idx)) != -1)
		{
			BaseStat = GetTemplateCharacterStat(UnitState, ECharStatType(idx), ClampStat, NewRank);
			if (ECharStatType(idx) == eStat_Will && UnitState.bIsShaken)
				NewValue = UnitState.SavedWillValue;
			else
				NewValue = UnitState.GetBaseStat(ECharStatType(idx));

			if(BaseStat < 1.0f)
			{
				Increase1 = `SYNC_FRAND();
				if(Increase1 < BaseStat)
					Increase2 = 1.0f;
				else
					Increase2 = 0.0f;
				NewValue += Increase2;
			}
			else 
			{
				AutoIncrease = FFloor(PctAuto * BaseStat); 
				RandIncrease = BaseStat - AutoIncrease;
				RandIncrease += 1;
				Increase1 = `SYNC_RAND(int(RandIncrease));
				Increase2 = `SYNC_RAND(int(RandIncrease));
				NewValue += AutoIncrease + Increase1 + Increase2;
				if(RandIncrease - int(RandIncrease) > 0)
					NewValue += 1;
			}

			if(ClampStat > 0)
				NewValue = Min(NewValue, ClampStat);

			if (ECharStatType(idx) == eStat_Will && UnitState.bIsShaken)
				UnitState.SavedWillValue = NewValue;
			else
				UnitState.SetBaseMaxStat(ECharStatType(idx), NewValue);

		}
	}
}

//Rank of -1 refers to the unit's base stats, otherwise the gain from going from Rank to Rank+1
simulated function float GetTemplateCharacterStat(XComGameState_Unit Unit, ECharStatType Stat, out float MaxValue, optional int Rank = -1)
{
	local array<SoldierClassStatType> StatProgressionArray;
	local SoldierClassStatType StatProgression;
	local X2SoldierClassTemplate ClassTemplate;
	local float SumStat;
	local int idx, MaxRank;

	if(Unit == none) return 0.0f;
	if(Rank < 0)
	{
		if(Unit.GetMyTemplate() != none)
			return Unit.GetMyTemplate().CharacterBaseStats[Stat];
	}
	else // level up stat
	{
		ClassTemplate = Unit.GetSoldierClassTemplate();
		if(ClassTemplate != none)
		{
			foreach class'X2SoldierClassTemplateManager'.default.GlobalStatProgression(StatProgression)  //handle global stats (Will, in base-game)
			{
				if(StatProgression.StatType == Stat)
				{
					MaxValue = StatProgression.CapStatAmount;

					if(StatProgression.RandStatAmount <= 0)
						return StatProgression.StatAmount;
					else
						return StatProgression.StatAmount + (StatProgression.RandStatAmount-1.0f)/2.0f; //take average value
				}
			}

			MaxRank = ClassTemplate.GetMaxConfiguredRank();
			if (Rank < 0 || Rank > MaxRank)
				return 0.0f;

			for(idx=0; idx < MaxRank ; idx++)
			{
				StatProgressionArray = ClassTemplate.GetStatProgression(idx);
				foreach StatProgressionArray(StatProgression)
				{
					if(StatProgression.StatType == Stat)
						SumStat += StatProgression.StatAmount;
				}
			}
			if(SumStat < class'X2ExperienceConfig'.static.GetMaxRank())
			{
				return (SumStat / float(class'X2ExperienceConfig'.static.GetMaxRank()));
			}
			StatProgressionArray = ClassTemplate.GetStatProgression(Rank);
			foreach StatProgressionArray(StatProgression)
			{
				if(StatProgression.StatType == Stat)
				{
					MaxValue = StatProgression.CapStatAmount;

					if(StatProgression.RandStatAmount <= 0)
						return StatProgression.StatAmount;
					else
						return StatProgression.StatAmount + (StatProgression.RandStatAmount-1.0f)/2.0f; //take average value
				}
			}
		}
	}
	return 0.0f;
}

// ======= RANDOMIZED STATS COMMON ======= // 

static function XComGameState_Unit_LWRandomizedStats GetRandomizedStatsComponent(XComGameState_Unit Unit, optional XComGameState NewGameState)
{
	local XComGameState_Unit_LWRandomizedStats RandomizedStats;

	if (Unit != none)
	{
		if(NewGameState != none)
		{
			foreach NewGameState.IterateByClassType(class'XComGameState_Unit_LWRandomizedStats', RandomizedStats)
			{
				if(RandomizedStats.OwningObjectID == Unit.ObjectID)
					return RandomizedStats;
			}
		}
		return XComGameState_Unit_LWRandomizedStats(Unit.FindComponentObject(class'XComGameState_Unit_LWRandomizedStats'));
	}
	return none;
}

function EventListenerReturn CleanUpComponentStateOnDismiss(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_Unit UnitState, UpdatedUnit;
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_Unit_LWRandomizedStats RandomizedState, UpdatedRandomized;

	`LOG("ToolboxOptions: CleanUpComponentStateOnDismiss starting.",, 'LW_Toolbox');

	UnitState = XComGameState_Unit(EventData);
	if(UnitState == none)
		return ELR_NoInterrupt;

	RandomizedState = GetRandomizedStatsComponent(UnitState, GameState);
	if(RandomizedState != none)
	{
		`LOG("CleanUpComponentStateOnDismiss: Found RandomizedState, Unit=" $ UnitState.GetFullName() $ ", Removing Component.",, 'LW_Toolbox');
		History = `XCOMHISTORY;
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("RandomizedStats State cleanup");
		UpdatedUnit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', UnitState.ObjectID));
		UpdatedRandomized = XComGameState_Unit_LWRandomizedStats(NewGameState.CreateStateObject(class'XComGameState_Unit_LWRandomizedStats', RandomizedState.ObjectID));
		NewGameState.RemoveStateObject(UpdatedRandomized.ObjectID);
		UpdatedUnit.RemoveComponentObject(UpdatedRandomized);
		NewGameState.AddStateObject(UpdatedRandomized);
		NewGameState.AddStateObject(UpdatedUnit);
		if (NewGameState.GetNumGameStateObjects() > 0)
			`GAMERULES.SubmitGameState(NewGameState);
		else
			History.CleanupPendingGameState(NewGameState);
	}
	return ELR_NoInterrupt;
}

static function RandomizedStatsGCandValidationChecks()
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_Unit UnitState, UpdatedUnit;
	local XComGameState_Unit_LWRandomizedStats RandomizedState, UpdatedRandomized;

	`LOG("ToolboxOptions: Starting Garbage Collection and Validation.",, 'LW_Toolbox');

	History = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("RandomizedStats States cleanup");
	foreach History.IterateByClassType(class'XComGameState_Unit_LWRandomizedStats', RandomizedState,,true)
	{
		`LOG("GCandValidationChecks: Found RandomizedState, OwningObjectID=" $ RandomizedState.OwningObjectId $ ", Deleted=" $ RandomizedState.bRemoved,, 'LW_Toolbox');
		//check and see if the OwningObject is still alive and exists
		if(RandomizedState.OwningObjectId > 0)
		{
			UnitState = XComGameState_Unit(History.GetGameStateForObjectID(RandomizedState.OwningObjectID));
			if(UnitState == none)
			{
				`LOG("GCandValidationChecks: Randomized Component has no current owning unit, cleaning up state.",, 'LW_Toolbox');
				// Remove disconnected officer state
				NewGameState.RemoveStateObject(RandomizedState.ObjectID);
			}
			else
			{
				`LOG("GCandValidationChecks: Found Owning Unit=" $ UnitState.GetFullName() $ ", Deleted=" $ UnitState.bRemoved,, 'LW_Toolbox');
				if(UnitState.bRemoved)
				{
					`LOG("GCandValidationChecks: Owning Unit was removed, Removing and unlinking RandomizedState",, 'LW_Toolbox');
					UpdatedUnit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', UnitState.ObjectID));
					UpdatedRandomized = XComGameState_Unit_LWRandomizedStats(NewGameState.CreateStateObject(class'XComGameState_Unit_LWRandomizedStats', RandomizedState.ObjectID));
					NewGameState.RemoveStateObject(UpdatedRandomized.ObjectID);
					UpdatedUnit.RemoveComponentObject(UpdatedRandomized);
					NewGameState.AddStateObject(UpdatedRandomized);
					NewGameState.AddStateObject(UpdatedUnit);
				}
			}
		}
	}
	if (NewGameState.GetNumGameStateObjects() > 0)
		`GAMERULES.SubmitGameState(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);
}

//this updates the GenerateRewardFn delegate for the three types of reward soldier functions, in order to generate reward soldiers with appropriate stats
static function UpdateRewardSoldierTemplates()
{
	local X2StrategyElementTemplateManager TemplateMgr;
	local X2RewardTemplate Template;

	TemplateMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();

	Template = X2RewardTemplate(TemplateMgr.FindStrategyElementTemplate('Reward_Soldier'));  
	Template.GenerateRewardFn = class'X2StrategyElement_RandomizedSoldierRewards'.static.GeneratePersonnelReward;
	TemplateMgr.AddStrategyElementTemplate(Template, true);

	Template = X2RewardTemplate(TemplateMgr.FindStrategyElementTemplate('Reward_Rookie')); 
	Template.GenerateRewardFn = class'X2StrategyElement_RandomizedSoldierRewards'.static.GeneratePersonnelReward;
	TemplateMgr.AddStrategyElementTemplate(Template, true);

	Template = X2RewardTemplate(TemplateMgr.FindStrategyElementTemplate('Reward_SoldierCouncil')); 
	Template.GenerateRewardFn = class'X2StrategyElement_RandomizedSoldierRewards'.static.GenerateCouncilSoldierReward;
	TemplateMgr.AddStrategyElementTemplate(Template, true);
}

// ======= RED FOG ======= // 

public function UpdateRedFog_OnChanged(UIListItemSpinner SpinnerControl, int Direction)
{
	local int Bits;

	Bits = (bRedFogXComActive_Cached ? 1 : 0) + (bRedFogAliensActive_Cached ? 2 : 0);
	Bits += direction;

	if (Bits < 0)
		Bits = 3;
	else if (Bits > 3)
		Bits = 0;

	bRedFogXComActive_Cached = (Bits & 1) > 0;
	bRedFogAliensActive_Cached = (Bits & 2) > 0;

	SpinnerControl.SetValue(GetRedFogSpinnerString());
	//ActivateRedFog(bRedFogXComActive, bRedFogAliensActive);
	`SOUNDMGR.PlaySoundEvent("Play_MenuSelect");
}

function UpdateRedFogLinearPenaltiesEnabled(UICheckbox CheckboxControl)
{
	bRedFogLinearPenalties_Cached = CheckboxControl.bChecked;

	//ActivateRedFog(bRedFogXComActive, bRedFogAliensActive);
	`SOUNDMGR.PlaySoundEvent("Play_MenuSelect");
}

function ActivateRedFog(bool bXCOM, bool bAliens, optional XComGameState NewGameState)
{
	//local XComGameState NewGameState;
	local XComGameStateHistory History;
	local X2EventManager EventMgr;
	local object ThisObj;
	local XComGameStateContext_ChangeContainer ChangeContainer;
	local bool NeedsSubmit;

	History = `XCOMHISTORY;
	EventMgr = `XEVENTMGR;
	ThisObj = self;
	
	if (`TACTICALRULES != none && `TACTICALRULES.TacticalGameIsInPlay())
	{
		NeedsSubmit = NewGameState == none;

		if(NewGameState == none)
		{
			ChangeContainer = class'XComGameStateContext_ChangeContainer'.static.CreateEmptyChangeContainer("Applying Red Fog to all units");
			NewGameState = History.CreateNewGameState(true, ChangeContainer);
		}
		AddRedFogAbilityToAllUnits(NewGameState);
		if(NeedsSubmit)
			`GAMERULES.SubmitGameState(NewGameState);
	}
	if(bXCom || bAliens)
	{
		`LOG("ActivateRedFog : OnUnitBeginPlay registered.",, 'LW_Toolbox');
		EventMgr.RegisterForEvent(ThisObj, 'OnUnitBeginPlay', OnPostInitAbilities, ELD_OnStateSubmitted, 30,, true);
		History.RegisterOnNewGameStateDelegate(OnNewGameState_HealthWatcher);
	}
	else	
	{
		EventMgr.UnRegisterFromEvent(ThisObj, 'OnUnitBeginPlay');
		History.UnRegisterOnNewGameStateDelegate(OnNewGameState_HealthWatcher);
	}
}

//register to receive new gamestates in order to update RedFog whenever HP changes on a unit, and in tactical
static function OnNewGameState_HealthWatcher(XComGameState GameState)
{
	local XComGameState NewGameState;
	local int StateObjectIndex;
	local XComGameState_Effect RedFogEffect;
	local XComGameState_Effect_RedFog_LW RFEComponent;
	local XComGameState_Unit HPChangedUnit, UpdatedUnit;
	local array<XComGameState_Unit> HPChangedObjects;  // is generically just a pair of XComGameState_BaseObjects, pre and post the change

	if(`TACTICALRULES == none || !`TACTICALRULES.TacticalGameIsInPlay()) return; // only do this checking when in tactical battle

	HPChangedObjects.Length = 0;
	GetHPChangedObjectList(GameState, HPChangedObjects);
	
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Update RedFog OnNewGameState_HealthWatcher");
	for( StateObjectIndex = 0; StateObjectIndex < HPChangedObjects.Length; ++StateObjectIndex )
	{	
		HPChangedUnit = HPChangedObjects[StateObjectIndex];
		if(HPChangedUnit.IsUnitAffectedByEffectName(class'X2Effect_RedFog_LW'.default.EffectName))
		{
			RedFogEffect = HPChangedUnit.GetUnitAffectedByEffectState(class'X2Effect_RedFog_LW'.default.EffectName);
			if(RedFogEffect != none)
			{
				RFEComponent = XComGameState_Effect_RedFog_LW(RedFogEffect.FindComponentObject(class'XComGameState_Effect_RedFog_LW'));
				if(RFEComponent != none)
				{
					UpdatedUnit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', HPChangedUnit.ObjectID));
					NewGameState.AddStateObject(UpdatedUnit);
					RFEComponent.UpdateRedFogPenalties(UpdatedUnit, NewGameState);
				}
			}
		}
	}
	if(NewGameState.GetNumGameStateObjects() > 0)
		`TACTICALRULES.SubmitGameState(NewGameState);
	else
		`XCOMHISTORY.CleanupPendingGameState(NewGameState);
}

//extract the XCGS_Unit object that have their HP stat changed
static function GetHPChangedObjectList(XComGameState NewGameState, out array<XComGameState_Unit> OutHPChangedObjects)
{
	local XComGameStateHistory History;
	local int StateObjectIndex;
	local XComGameState_BaseObject StateObjectCurrent;
	local XComGameState_BaseObject StateObjectPrevious;
	local XComGameState_Unit UnitStateCurrent, UnitStatePrevious;

	History = `XCOMHISTORY;
	
	foreach NewGameState.IterateByClassType(class'XComGameState_Unit', UnitStateCurrent)
	{
		StateObjectPrevious = History.GetGameStateForObjectID(StateObjectCurrent.ObjectID, , NewGameState.HistoryIndex - 1);
		UnitStatePrevious = XComGameState_Unit(StateObjectPrevious);

		if(UnitStatePrevious != none && UnitStateCurrent.GetCurrentStat(eStat_HP) != UnitStatePrevious.GetCurrentStat(eStat_HP))
		{
			OutHPChangedObjects.AddItem(UnitStateCurrent);
		}
	}
}

function CleanupRedFog()
{
	local XComGameStateHistory History;
	local XComGameState_Effect EffectState;
	local XComGameState_Effect_RedFog_LW RFEState;
	local XComGameState NewGameState;
	local Object ThisObj;
	local X2EventManager EventManager;

	EventManager = `XEVENTMGR;
	History = `XCOMHISTORY;

	//make sure all of our RedFog states are cleaned up like they should be
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Clean up Red Fog effects");
	foreach History.IterateByClassType(class'XComGameState_Effect_RedFog_LW', RFEState)
	{
		`LOG("CleanupRedFog: Found RedFog Effect gamestate, cleaning up",,'LW_Toolbox');
		ThisObj = RFEState;
		EventManager.UnRegisterFromEvent(ThisObj, 'UpdateRedFogActivation');

		EffectState = XComGameState_Effect(History.GetGameStateForObjectID(RFEState.OwningObjectId));
		if(EffectState != none && !EffectState.bRemoved)
		{
			`LOG("CleanupRedFog: Found owning XCGS_Effect, removing",, 'LW_Toolbox');
			NewGameState.RemoveStateObject(EffectState.ObjectID);
		}

		NewGameState.RemoveStateObject(RFEState.ObjectID);
	}

	if(NewGameState.GetNumGameStateObjects() > 0)
		History.AddGameStateToHistory(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);

}

function EventListenerReturn OnPostInitAbilities(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState NewGameState;
	local XComGameStateHistory History;
	local XComGameStateContext_ChangeContainer ChangeContainer;
	local XComGameState_Unit UnitState, UpdatedUnitState;
	local bool UnitNeedsRedFog;

	History = `XCOMHISTORY;

	`LOG("OnAddRedFogAbility : OnUnitBeginPlay triggered.",, 'LW_Toolbox');
	UnitState = XComGameState_Unit(EventData);
	if(UnitState != none)
	{
		UnitNeedsRedFog = !UnitState.IsSoldier();
		if (UnitNeedsRedFog)
		{
			ChangeContainer = class'XComGameStateContext_ChangeContainer'.static.CreateEmptyChangeContainer("Applying Red Fog to specific unit");
			NewGameState = History.CreateNewGameState(true, ChangeContainer);
			UpdatedUnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', UnitState.ObjectID));
			AddRedFogAbilityToOneUnit(UpdatedUnitState, NewGameState);
			NewGameState.AddStateObject(UpdatedUnitState);
			`GAMERULES.SubmitGameState(NewGameState);
		}
	}
	else
	{
		`REDSCREEN("OnAddRedFogAbility : Event Triggered without valid Unit EventData");
	}
	return ELR_NoInterrupt;
}

function EventListenerReturn OnSetRedFogActivation(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	//SetRedFogAbilityActivation(GameState);

	return ELR_NoInterrupt;
}

function AddRedFogAbilityToAllUnits(XComGameState GameState)
{
	local X2AbilityTemplate RedFogAbilityTemplate, AbilityTemplate;
	local array<X2AbilityTemplate> AllAbilityTemplates;
	local XComGameStateHistory History;
	local XComGameState_Unit AbilitySourceUnitState;
	local StateObjectReference AbilityRef;
	local XComGameState_Ability AbilityState;
	local Name AdditionalAbilityName;
	local X2EventManager EventMgr;

	History = `XCOMHISTORY;
	EventMgr = `XEVENTMGR;
	RedFogAbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate('RedFog_LW');

	if( RedFogAbilityTemplate != none )
	{
		AllAbilityTemplates.AddItem(RedFogAbilityTemplate);
		foreach RedFogAbilityTemplate.AdditionalAbilities(AdditionalAbilityName)
		{
			AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(AdditionalAbilityName);
			if( AbilityTemplate != none )
			{
				AllAbilityTemplates.AddItem(AbilityTemplate);
			}
		}
	}

	foreach History.IterateByClassType(class'XComGameState_Unit', AbilitySourceUnitState)
	{
		if(AbilitySourceUnitState.GetTeam() != eTeam_XCom && AbilitySourceUnitState.GetTeam() != eTeam_Alien)
			continue;

		AbilitySourceUnitState = XComGameState_Unit(GameState.CreateStateObject(class'XComGameState_Unit', AbilitySourceUnitState.ObjectID));
		GameState.AddStateObject(AbilitySourceUnitState);

		foreach AllAbilityTemplates(AbilityTemplate)
		{
			AbilityRef = AbilitySourceUnitState.FindAbility(AbilityTemplate.DataName);
			if( AbilityRef.ObjectID == 0 )
			{
				AbilityRef = `TACTICALRULES.InitAbilityForUnit(RedFogAbilityTemplate, AbilitySourceUnitState, GameState);
			}

			AbilityState = XComGameState_Ability(GameState.CreateStateObject(class'XComGameState_Ability', AbilityRef.ObjectID));
			GameState.AddStateObject(AbilityState);
		}

		// trigger event listeners now to update red fog activation for already applied effects
		EventMgr.TriggerEvent('UpdateRedFogActivation', self, AbilitySourceUnitState, GameState);
	}
}

function AddRedFogAbilityToOneUnit(XComGameState_Unit AbilitySourceUnitState, XComGameState GameState)
{
	local X2AbilityTemplate RedFogAbilityTemplate, AbilityTemplate;
	local array<X2AbilityTemplate> AllAbilityTemplates;
	local StateObjectReference AbilityRef;
	local XComGameState_Ability AbilityState;
	local Name AdditionalAbilityName;
	local X2EventManager EventMgr;

	EventMgr = `XEVENTMGR;
	RedFogAbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate('RedFog_LW');

	if( RedFogAbilityTemplate != none )
	{
		AllAbilityTemplates.AddItem(RedFogAbilityTemplate);
		foreach RedFogAbilityTemplate.AdditionalAbilities(AdditionalAbilityName)
		{
			AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(AdditionalAbilityName);
			if( AbilityTemplate != none )
			{
				AllAbilityTemplates.AddItem(AbilityTemplate);
			}
		}
	}

	if(AbilitySourceUnitState.GetTeam() != eTeam_XCom && AbilitySourceUnitState.GetTeam() != eTeam_Alien)
		return;

	AbilitySourceUnitState = XComGameState_Unit(GameState.CreateStateObject(class'XComGameState_Unit', AbilitySourceUnitState.ObjectID));
	GameState.AddStateObject(AbilitySourceUnitState);

	foreach AllAbilityTemplates(AbilityTemplate)
	{
		AbilityRef = AbilitySourceUnitState.FindAbility(AbilityTemplate.DataName);
		if( AbilityRef.ObjectID == 0 )
		{
			AbilityRef = `TACTICALRULES.InitAbilityForUnit(RedFogAbilityTemplate, AbilitySourceUnitState, GameState);
		}

		AbilityState = XComGameState_Ability(GameState.CreateStateObject(class'XComGameState_Ability', AbilityRef.ObjectID));
		GameState.AddStateObject(AbilityState);
	}

	// trigger event listeners now to update red fog activation for already applied effects
	EventMgr.TriggerEvent('UpdateRedFogActivation', self, AbilitySourceUnitState, GameState);
}

function SetRedFogAbilityActivation()
{
	local XComGameStateHistory History;
	local XComGameStateContext_ChangeContainer ChangeContainer;
	local XComGameState NewGameState;
	local XComGameState_Unit UnitState;
	local X2EventManager EventMgr;

	History = `XCOMHISTORY;
	EventMgr = `XEVENTMGR;
	ChangeContainer = class'XComGameStateContext_ChangeContainer'.static.CreateEmptyChangeContainer("UpdateRedFogActivation");
	NewGameState = `XCOMHISTORY.CreateNewGameState(true, ChangeContainer);
	foreach History.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		if (UnitState.IsInPlay())
		{
			// trigger event listeners now to update red fog activation for already applied effects
			EventMgr.TriggerEvent('UpdateRedFogActivation', self, UnitState, NewGameState);
		}
	}
	if (`TACTICALRULES != none && `TACTICALRULES.TacticalGameIsInPlay())
		`TACTICALRULES.SubmitGameState(NewGameState);
	else
		`GAMERULES.SubmitGameState(NewGameState);
}

// ======= SIMCOMBAT  ======= // 

function UpdateSimCombatEnabled(UICheckbox CheckboxControl)
{
	bEnableSimCombat_Cached = CheckboxControl.bChecked;
	`SOUNDMGR.PlaySoundEvent("Play_MenuSelect");
}


defaultProperties
{
	fPercentGuaranteedStat=0.65
	//bRandomizedInitialStatsEnabled=true
	//ClassType = class'XComGameState_LWToolboxOptions';
}
