//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_LWPerkPackOptions.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: This is a component extension for CampaignSettings GameStates, containing 
//				additional data used for mod configuration, plus UI control code.
//---------------------------------------------------------------------------------------
class XComGameState_LWPerkPackOptions extends XComGameState_LWModOptions
	config(LW_PerkPack);

`include(..\..\XComGame\Mods\LongWaroftheChosen\Src\LW_PerkPack_Integrated\LW_PerkPack.uci)

var config array<name> Suppress;

var localized string PerkPackTabName;

// ***** VIEW LOCKED PERKS CONFIGURATION ***** //
var bool bViewLockedPerksEnabled;
var bool bViewLockedPerksEnabled_Cached;
var localized string ViewLockedPerksMod;
var localized string ViewLockedPerksModTooltip;

// ***** USE BASE GAME PERK UI CONFIGURATION ***** //
var bool bBaseGamePerkUIEnabled;
var bool bBaseGamePerkUIEnabled_Cached;
var localized string BaseGamePerkUIMod;
var localized string BaseGamePerkUIModTooltip;

// ***** USE DEFAULT TACTICALHUD ABILITY CONTAINER ***** //
var bool bDefaultTacticalAbilityContainer;
var bool bDefaultTacticalAbilityContainer_Cached;
var localized string DefaultTacticalAbilityContainerMod;
var localized string DefaultTacticalAbilityContainerModTooltip;

// ***** NUM DISPLAYED ABILITIES IN HUD CONFIGURATION ***** //
var int NumDisplayedAbilitiesIndex;
var int NumDisplayedAbilitiesIndex_Cached;
var config array<int> NUM_DISPLAYED_ABILITIES_IN_HUD_OPTIONS;
var array<string> sDisplayedAbilityOptions;
var localized string NumDisplayedAbilitiesMod;
var localized string NumDisplayedAbilitiesModTooltip;

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
	return default.PerkPackTabName;
}

function InitModOptions()
{
	bViewLockedPerksEnabled_Cached = bViewLockedPerksEnabled;

	bBaseGamePerkUIEnabled_Cached = bBaseGamePerkUIEnabled;

	bDefaultTacticalAbilityContainer_Cached = bDefaultTacticalAbilityContainer;

	NumDisplayedAbilitiesIndex_Cached = NumDisplayedAbilitiesIndex;
}

//returns the number of MechaItems set -- this is the number that will be enabled in the calling UIScreen
function int SetModOptionsEnabled(out array<UIMechaListItem> m_arrMechaItems)
{
	local int ButtonIdx;

	UpdateStrings();

	// View Locked Perks ----------------------------------------------------
	m_arrMechaItems[ButtonIdx].UpdateDataCheckbox(ViewLockedPerksMod, "", bViewLockedPerksEnabled_Cached, UpdateViewLockedPerks);
	m_arrMechaItems[ButtonIdx++].BG.SetTooltipText(ViewLockedPerksModTooltip, , , 10, , , , 0.0f);

	// Base-game PerkUI --------------------------------------------
	if(!AnySoldierTemplateHasThreeAbilities())
	{
		m_arrMechaItems[ButtonIdx].UpdateDataCheckbox(BaseGamePerkUIMod, "", bBaseGamePerkUIEnabled_Cached, UpdateBaseGamePerkUIEnabled);
		m_arrMechaItems[ButtonIdx++].BG.SetTooltipText(BaseGamePerkUIModTooltip, , , 10, , , , 0.0f);
	}

	// Use Default TacticalHUD Ability Container ----------------------------------------------------
	m_arrMechaItems[ButtonIdx].UpdateDataCheckbox(DefaultTacticalAbilityContainerMod, "", bDefaultTacticalAbilityContainer_Cached, UpdateDefaultTacticalAbilityContainer);
	m_arrMechaItems[ButtonIdx++].BG.SetTooltipText(DefaultTacticalAbilityContainerModTooltip, , , 10, , , , 0.0f);

	// Num Displayed Abilities --------------------------------------------
	m_arrMechaItems[ButtonIdx].UpdateDataSpinner(NumDisplayedAbilitiesMod, sDisplayedAbilityOptions[NumDisplayedAbilitiesIndex_Cached], UpdateNumDisplayedAbilities_OnChanged);
	m_arrMechaItems[ButtonIdx++].BG.SetTooltipText(NumDisplayedAbilitiesModTooltip, , , 10, , , , 0.0f);

	return ButtonIdx;
}

//allow UIOptionsPCScreen to see if any value has been changed
function bool HasAnyValueChanged()
{
	if(bViewLockedPerksEnabled_Cached != bViewLockedPerksEnabled)
	{
		`PPTRACE("PerkPack: ViewLockedPerksEnabled changed.");
		return true;
	}
	if(bBaseGamePerkUIEnabled_Cached != bBaseGamePerkUIEnabled)
	{
		`PPTRACE("PerkPack: BaseGamePerkUIEnabled changed.");
		return true;
	}
	if(bDefaultTacticalAbilityContainer_Cached != bDefaultTacticalAbilityContainer)
	{
		`PPTRACE("PerkPack: DefaultTacticalAbilityContainer changed.");
		return true;
	}	
	if(NumDisplayedAbilitiesIndex_Cached != NumDisplayedAbilitiesIndex)
	{
		`PPTRACE("PerkPack: NumDisplayedAbilitiesIndex changed.");
		return true;
	}
	return false;
}

//message to ModOptions to apply any cached/pending changes
function ApplyModSettings()
{
	local XComGameState_LWPerkPackOptions UpdatedOptions;
	local XComGameStateContext_ChangeContainer ChangeContainer;
	local XComGameState NewGameState;

	ChangeContainer = class'XComGameStateContext_ChangeContainer'.static.CreateEmptyChangeContainer("Apply PerkPack Options");
	NewGameState = `XCOMHISTORY.CreateNewGameState(true, ChangeContainer);

	UpdatedOptions = XComGameState_LWPerkPackOptions(NewGameState.CreateStateObject(Class, ObjectID));
	NewGameState.AddStateObject(UpdatedOptions);
	
	UpdatedOptions.bViewLockedPerksEnabled = bViewLockedPerksEnabled_Cached;
	UpdatedOptions.bBaseGamePerkUIEnabled = bBaseGamePerkUIEnabled_Cached;
	UpdatedOptions.bDefaultTacticalAbilityContainer = bDefaultTacticalAbilityContainer_Cached;
	UpdatedOptions.NumDisplayedAbilitiesIndex = NumDisplayedAbilitiesIndex_Cached;

	if  (`TACTICALRULES != none && `TACTICALRULES.TacticalGameIsInPlay())
		`TACTICALRULES.SubmitGameState(NewGameState);
	else
		`GAMERULES.SubmitGameState(NewGameState);

	UpdateTacticalHUDAbilityContainer();
}

//message to ModOptions to restore any cached/pending changes if user aborts without applying changes
function RestorePreviousModSettings()
{
	bViewLockedPerksEnabled_Cached = bViewLockedPerksEnabled;

	bBaseGamePerkUIEnabled_Cached = bBaseGamePerkUIEnabled;

	bDefaultTacticalAbilityContainer_Cached = bDefaultTacticalAbilityContainer;

	NumDisplayedAbilitiesIndex_Cached = NumDisplayedAbilitiesIndex;
}

function bool CanResetModSettings() { return true; }

//message to ModOptions to reset any settings to "factory default"
function ResetModSettings()
{
	bViewLockedPerksEnabled_Cached = false;

	bBaseGamePerkUIEnabled_Cached = false;

	bDefaultTacticalAbilityContainer_Cached = false;

	NumDisplayedAbilitiesIndex_Cached = 0;
}


// ========================================================
// UI HELPERS 
// ========================================================

function UpdateStrings()
{
	local int idx, Size;

	foreach default.NUM_DISPLAYED_ABILITIES_IN_HUD_OPTIONS( Size, idx)
	{
		sDisplayedAbilityOptions[idx] = string(Size);
	}
}

// ========================================================
// GETTERS / SETTERS 
// ========================================================

static function XComGameState_LWPerkPackOptions GetPerkPackOptions()
{
	local XComGameState_CampaignSettings CampaignSettingsStateObject;

	CampaignSettingsStateObject = XComGameState_CampaignSettings(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings', true));
	if(CampaignSettingsStateObject != none)
		return XComGameState_LWPerkPackOptions(CampaignSettingsStateObject.FindComponentObject(class'XComGameState_LWPerkPackOptions'));
	return none;
}

static function bool IsViewLockedStatsEnabled()
{
	local XComGameState_LWPerkPackOptions PerkPackOptions;

	PerkPackOptions = GetPerkPackOptions();
	return PerkPackOptions.bViewLockedPerksEnabled;
}

static function bool IsBaseGamePerkUIEnabled()
{
	local XComGameState_LWPerkPackOptions PerkPackOptions;

	PerkPackOptions = GetPerkPackOptions();
	return PerkPackOptions.bBaseGamePerkUIEnabled;
}

static function int GetNumDisplayedAbilities()
{
	local XComGameState_LWPerkPackOptions PerkPackOptions;

	PerkPackOptions = GetPerkPackOptions();
	return default.NUM_DISPLAYED_ABILITIES_IN_HUD_OPTIONS[PerkPackOptions.NumDisplayedAbilitiesIndex];
}

// ========================================================
// DATA HOOKS 
// ========================================================


// ======= VIEW LOCKED PERKS ======= // 

function UpdateViewLockedPerks(UICheckbox CheckboxControl)
{
	bViewLockedPerksEnabled_Cached = CheckboxControl.bChecked;
	`SOUNDMGR.PlaySoundEvent("Play_MenuSelect");
}

// ======= BASE-GAME PERKUI ======= // 

function UpdateBaseGamePerkUIEnabled(UICheckbox CheckboxControl)
{
	bBaseGamePerkUIEnabled_Cached = CheckboxControl.bChecked;
	`SOUNDMGR.PlaySoundEvent("Play_MenuSelect");
}

// ======= USE DEFAULT ABILITY CONTAINER IN TACTICAL HUD ======= // 

function UpdateDefaultTacticalAbilityContainer(UICheckbox CheckboxControl)
{
	bDefaultTacticalAbilityContainer_Cached = CheckboxControl.bChecked;
	`SOUNDMGR.PlaySoundEvent("Play_MenuSelect");
}

// ======= ABILITY HUD SIZE  ======= // 

function UpdateNumDisplayedAbilities_OnChanged(UIListItemSpinner SpinnerControl, int Direction)
{
	
	NumDisplayedAbilitiesIndex_Cached += direction;

	if (NumDisplayedAbilitiesIndex_Cached < 0)
		NumDisplayedAbilitiesIndex_Cached = sDisplayedAbilityOptions.Length - 1;
	else if (NumDisplayedAbilitiesIndex_Cached > sDisplayedAbilityOptions.Length - 1)
		NumDisplayedAbilitiesIndex_Cached = 0;

	SpinnerControl.SetValue(sDisplayedAbilityOptions[NumDisplayedAbilitiesIndex_Cached]);
	`SOUNDMGR.PlaySoundEvent("Play_MenuSelect");
}

function UpdateTacticalHUDAbilityContainer()
{
	local UITacticalHUD HUDScreen;
	local UITacticalHUD_AbilityContainer_LWExtended AbilityContainer;

	if(!bDefaultTacticalAbilityContainer && `TACTICALRULES.TacticalGameIsInPlay())
	{
		HUDScreen = UITacticalHUD(`SCREENSTACK.GetScreen(class'UITacticalHUD'));
		if(HUDScreen != none)
		{
			AbilityContainer = UITacticalHUD_AbilityContainer_LWExtended(HUDScreen.m_kAbilityHUD);
			if(AbilityContainer != none)
			{
				AbilityContainer.MaxAbilitiesPerPage = default.NUM_DISPLAYED_ABILITIES_IN_HUD_OPTIONS[NumDisplayedAbilitiesIndex];
				AbilityContainer.UpdateLeftRightButtonPositions(); // update the left/right button positions
				AbilityContainer.m_iCurrentPage = 0; //reset to first page to prevent getting stuck on an empty page
				AbilityContainer.PopulateFlash(); // re-populate to reset all the icon positions
				AbilityContainer.UpdateAbilitiesArray(); // update the array
			}
		}
	}
}

function bool AnySoldierTemplateHasThreeAbilities()
{
	local X2SoldierClassTemplateManager ClassTemplateMgr;
	local array<X2SoldierClassTemplate> AllClassTemplates;
	local X2SoldierClassTemplate ClassTemplate;
	local int iRank;
	local array<SoldierClassAbilitySlot> SCATs;

	ClassTemplateMgr = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();
	AllClassTemplates = ClassTemplateMgr.GetAllSoldierClassTemplates(); // by default excludes multiplayer

	foreach AllClassTemplates(ClassTemplate)
	{
		for(iRank = 1; iRank < ClassTemplate.GetMaxConfiguredRank(); iRank++)
		{
			SCATs = ClassTemplate.GetAbilitySlots(iRank);
			if(SCATs.Length > 2)
				return true;
		}
	}
	return false;
}


defaultProperties
{
	//ClassType = class'XComGameState_LWPerkPackOptions';
}