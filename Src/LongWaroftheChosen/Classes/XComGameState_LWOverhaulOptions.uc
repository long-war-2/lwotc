//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_LWOverhaulOptions.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: This is a component extension for CampaignSettings GameStates, containing 
//				additional data used for mod configuration, plus UI control code.
//---------------------------------------------------------------------------------------
class XComGameState_LWOverhaulOptions extends XComGameState_LWModOptions
	config(LW_Overhaul);

`include(LongWaroftheChosen\Src\LW_Overhaul.uci)

var localized string LWOverhaulTabName;

// ***** GRAZE BAND CONFIGURATION ***** //
var int GrazeBandWidth;
var int GrazeBandWidth_Cached;
var localized string GrazeBandWidthMod;
var localized string GrazeBandWidthModTooltip;
var localized string GrazeBandValue;

// ***** PAUSE ON RECRUIT ***** //
var bool PauseOnRecruit;
var bool PauseOnRecruit_Cached;
var localized string PauseOnRecruitMod;
var localized string PauseOnRecruitModTooltip;

// ========================================================
// PROTOTYPE DEFINITIONS 
// ========================================================

function XComGameState_LWModOptions InitComponent(class NewClassType)
{
	super.InitComponent(NewClassType);
	return self;
}

function string GetTabText()
{
	return default.LWOverhaulTabName;
}

function InitModOptions()
{
	GrazeBandWidth_Cached = GrazeBandWidth;
    PauseOnRecruit_Cached = PauseOnRecruit;
}

//returns the number of MechaItems set -- this is the number that will be enabled in the calling UIScreen
function int SetModOptionsEnabled(out array<UIMechaListItem> m_arrMechaItems)
{
	local int ButtonIdx;

    // Pause on recruit
    m_arrMechaItems[ButtonIdx].UpdateDataCheckbox(PauseOnRecruitMod, "", PauseOnRecruit_Cached, UpdatePauseOnRecruit);
    m_arrMechaItems[ButtonIdx].BG.SetTooltipText(PauseOnRecruitModTooltip, , , 10, , , , 0.0f);
    ButtonIdx++;

	// Graze band setting: --------------------------------------------
	m_arrMechaItems[ButtonIdx].UpdateDataSlider(GrazeBandWidthMod, "", GrazeBandToPctFloat(GrazeBandWidth_Cached), , UpdateGrazeBand);
	m_arrMechaItems[ButtonIdx].Slider.SetText(GetGrazeBandString());
	m_arrMechaItems[ButtonIdx].BG.SetTooltipText(GrazeBandWidthModTooltip, , , 10, , , , 0.0f);
	ButtonIdx++;

	return ButtonIdx;
}

//allow UIOptionsPCScreen to see if any value has been changed
function bool HasAnyValueChanged()
{
	if(GrazeBandWidth != GrazeBandWidth_Cached)
        return true;

    if (PauseOnRecruit != PauseOnRecruit_Cached)
        return true;

	return false; 
}

//message to ModOptions to apply any cached/pending changes
function ApplyModSettings()
{
	local XComGameState_LWOverhaulOptions UpdatedOptions;
	local XComGameStateContext_ChangeContainer ChangeContainer;
	local XComGameState NewGameState;

	ChangeContainer = class'XComGameStateContext_ChangeContainer'.static.CreateEmptyChangeContainer("Apply LWOverhaul Options");
	NewGameState = `XCOMHISTORY.CreateNewGameState(true, ChangeContainer);

	UpdatedOptions = XComGameState_LWOverhaulOptions(NewGameState.CreateStateObject(Class, ObjectID));
	NewGameState.AddStateObject(UpdatedOptions);

	UpdatedOptions.GrazeBandWidth = GrazeBandWidth_Cached;
    UpdatedOptions.PauseOnRecruit = PauseOnRecruit_Cached;

	if  (`TACTICALRULES != none && `TACTICALRULES.TacticalGameIsInPlay())
		`TACTICALRULES.SubmitGameState(NewGameState);
	else
		`GAMERULES.SubmitGameState(NewGameState);
}

//message to ModOptions to restore any cached/pending changes if user aborts without applying changes
function RestorePreviousModSettings()
{
	GrazeBandWidth_Cached = GrazeBandWidth;
    PauseOnRecruit_Cached = PauseOnRecruit;
}

function bool CanResetModSettings() { return true; }

//message to ModOptions to reset any settings to "factory default"
function ResetModSettings()
{
	GrazeBandWidth_Cached = default.GrazeBandWidth;
    PauseOnRecruit_Cached = default.PauseOnRecruit;
}

// ========================================================
// UI HELPERS 
// ========================================================

function string GetGrazeBandString()
{
	local XGParamTag kTag;
	local string ValueString;

	kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	kTag.IntValue0 = GrazeBandWidth_Cached;
	ValueString = GrazeBandValue;
	ValueString = class'UIUtilities_Text'.static.GetColoredText(ValueString, eUIState_Normal);
	ValueString = class'UIUtilities_Text'.static.AddFontInfo(ValueString, false, false, false, 20);
	//ValueString = class'UIUtilities_Text'.static.StyleText(ValueString, eUITextStyle_Body);
	return `XEXPAND.ExpandString(ValueString);
}

function float GrazeBandToPctFloat(int Value)
{
	return 5.0 * GrazeBandWidth_Cached;
}

// ========================================================
// GETTERS / SETTERS 
// ========================================================

static function XComGameState_LWOverhaulOptions GetLWOverhaulOptions()
{
	local XComGameState_CampaignSettings CampaignSettingsStateObject;

	CampaignSettingsStateObject = XComGameState_CampaignSettings(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings', true));
	if(CampaignSettingsStateObject != none)
		return XComGameState_LWOverhaulOptions(CampaignSettingsStateObject.FindComponentObject(class'XComGameState_LWOverhaulOptions'));
	return none;
}

function int GetGrazeBand()
{
	return GrazeBandWidth;
}

function bool GetPauseOnRecruit()
{
    return PauseOnRecruit;
}

// ========================================================
// GRAZE BAND 
// ========================================================

public function UpdateGrazeBand(UISlider SliderControl)
{
	local int OldValue;

	OldValue = GrazeBandWidth_Cached;
	GrazeBandWidth_Cached = Round(SliderControl.percent / 5.0);
	SliderControl.SetText(GetGrazeBandString());
	if (OldValue != GrazeBandWidth_Cached)
		`SOUNDMGR.PlaySoundEvent("Play_MenuSelect");
}

// Pause on recruit
function UpdatePauseOnRecruit(UICheckbox Checkbox)
{
    PauseOnRecruit_Cached = Checkbox.bChecked;
    `SOUNDMGR.PlaySoundEvent("Play_MenuSelect");
}


defaultProperties
{
	GrazeBandWidth=10
    PauseOnRecruit=false
}
