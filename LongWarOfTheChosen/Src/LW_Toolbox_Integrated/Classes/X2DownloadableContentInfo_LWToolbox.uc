//---------------------------------------------------------------------------------------
//  FILE:    X2DownloadableContentInfo_LWToolbox.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Initializes Toolbox mod settings on campaign start or when loading campaign without mod previously active
//--------------------------------------------------------------------------------------- 

class X2DownloadableContentInfo_LWToolbox extends X2DownloadableContentInfo config(LW_Toolbox);	

//

struct DefaultBaseDamageEntry
{
	var name WeaponTemplateName;
	var WeaponDamageValue BaseDamage;
};
var transient array<DefaultBaseDamageEntry> arrDefaultBaseDamage;

var config bool bRandomizedInitialStatsEnabledAtStart;

static function X2DownloadableContentInfo_LWToolbox GetThisDLCInfo()
{
	local array<X2DownloadableContentInfo> DLCInfos;
	local X2DownloadableContentInfo DLCInfo;
	local X2DownloadableContentInfo_LWToolbox ToolboxInfo;

	DLCInfos = `ONLINEEVENTMGR.GetDLCInfos(false);
	foreach DLCInfos(DLCInfo)
	{
		if (DLCInfo.DLCIdentifier == default.DLCIdentifier)
		{
			ToolboxInfo = X2DownloadableContentInfo_LWToolbox(DLCInfo);
			if (ToolboxInfo != none)
				return ToolboxInfo;
		}
	}
	return none;
}

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{
	`LOG("X2DLCInfo: Starting OnLoadedSavedGame",, 'LW_Toolbox');
	class'XComGameState_LWToolboxOptions'.static.CreateModSettingsState_ExistingCampaign(class'XComGameState_LWToolboxOptions');
}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed. When a new campaign is started the initial state of the world
/// is contained in a strategy start state. Never add additional history frames inside of InstallNewCampaign, add new state objects to the start state
/// or directly modify start state objects
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{
	local XComGameState_LWToolboxOptions ToolboxOptions;

	//short circuit if in shell:
	if(class'WorldInfo'.static.GetWorldInfo().GRI.GameClass.name == 'XComShell')
	{
		`LWTrace("InstallNewCampaign called in Shell, aborting.");
		return;
	}

	`LOG("X2DLCInfo: InstallNewCampaign",, 'LW_Toolbox');
	ToolboxOptions = XComGameState_LWToolboxOptions(class'XComGameState_LWToolboxOptions'.static.CreateModSettingsState_NewCampaign(class'XComGameState_LWToolboxOptions', StartState));

	// Overhaul-only mod -- start with NCE active
	if (default.bRandomizedInitialStatsEnabledAtStart)
	{
		ToolboxOptions.bRandomizedInitialStatsEnabled = true;
		ToolboxOptions.UpdatedRandomizedInitialStats(StartState);
	}
}


/// <summary>
/// This method is run when the player loads a saved game directly into Strategy while this DLC is installed
/// </summary>
static event OnLoadedSavedGameToStrategy()
{
	local XComGameState_LWToolboxOptions ToolboxOptions;
	ToolboxOptions = class'XComGameState_LWToolboxOptions'.static.GetToolboxOptions();

	if(ToolboxOptions == none)
		ToolboxOptions = XComGameState_LWToolboxOptions(class'XComGameState_LWToolboxOptions'.static.CreateModSettingsState_ExistingCampaign(class'XComGameState_LWToolboxOptions'));

	if(ToolboxOptions == none) 
	{
		`REDSCREEN("Toolbox OnLoadedSavedGameToStrategy : Unable to find or create ToolboxOptions");
		return;
	}

	ToolboxOptions.RegisterListeners();
	ToolboxOptions.UpdateWeaponTemplates_RandomizedDamage();
	ToolboxOptions.UpdateRewardSoldierTemplates();

	PatchupMissingPCSStats();

	if(ToolboxOptions.bRandomizedLevelupStatsEnabled)
		`XCOMHISTORY.RegisterOnNewGameStateDelegate(ToolboxOptions.OnNewGameState_RankWatcher);
}

/// <summary>
/// Called when the player completes a mission while this DLC / Mod is installed.
/// </summary>
static event OnPostMission()
{
	local XComGameState_LWToolboxOptions ToolboxOptions;
	ToolboxOptions = class'XComGameState_LWToolboxOptions'.static.GetToolboxOptions();

	PatchupMissingPCSStats();

	if(ToolboxOptions.bRandomizedLevelupStatsEnabled)
		`XCOMHISTORY.RegisterOnNewGameStateDelegate(ToolboxOptions.OnNewGameState_RankWatcher);
}

static function PatchupMissingPCSStats()
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_Unit Unit, UpdatedUnit;
	local float CurrentPCSStat, IdealPCSStat, MaxPCSStat;
	local XComGameState_LWToolboxOptions ToolboxOptions;

	History = `XCOMHISTORY;
	ToolboxOptions = class'XComGameState_LWToolboxOptions'.static.GetToolboxOptions();

	`LOG("Updating Missing PCS Stats.");
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Updating Missing PCS Stats");
	foreach History.IterateByClassType(class'XComGameState_Unit', Unit)
	{
		if(Unit.IsSoldier() && Unit.GetRank() > 0)
		{
			CurrentPCSStat = Unit.GetCurrentStat(eStat_CombatSims);
			IdealPCSStat = ToolboxOptions.GetTemplateCharacterStat(Unit, eStat_CombatSims, MaxPCSStat, 1);
			if(CurrentPCSStat < IdealPCSStat)
			{
				UpdatedUnit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', Unit.ObjectID));
				NewGameState.AddStateObject(UpdatedUnit);
				UpdatedUnit.SetBaseMaxStat(eStat_CombatSims, IdealPCSStat);
			}
		}
	}
	if (NewGameState.GetNumGameStateObjects() > 0)
		`GAMERULES.SubmitGameState(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);

}

// Use SLG hook to add red fog, if appropriate -- workaround for Avenger Defense SeqAct_SpawnUnitFromAvenger, which applies abilities in a wonky manner
static function FinalizeUnitAbilitiesForInit(XComGameState_Unit UnitState, out array<AbilitySetupData> SetupData, optional XComGameState StartState, optional XComGameState_Player PlayerState, optional bool bMultiplayerDisplay)
{
	local array<AbilitySetupData> arrData;
	local array<AbilitySetupData> arrAdditional;
	local X2AbilityTemplate AbilityTemplate;
	local name AbilityName;
	local X2AbilityTemplateManager AbilityTemplateMan;
	local int i;
	local AbilitySetupData Data, EmptyData;

	local XComGameState_LWToolboxOptions ToolboxOptions;
	ToolboxOptions = class'XComGameState_LWToolboxOptions'.static.GetToolboxOptions();

	//only apply RedFog to xcom units in this manner
	if (!UnitState.IsSoldier())
	{
		return;
	}

	if (!ToolboxOptions.bRedFogXComActive)
	{
		return;
	}

	AbilityTemplateMan = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	AbilityName = 'RedFog_LW';
	AbilityTemplate = AbilityTemplateMan.FindAbilityTemplate(AbilityName);
	if (AbilityTemplate != none && !AbilityTemplate.bUniqueSource || arrData.Find('TemplateName', AbilityTemplate.DataName) == INDEX_NONE)
	{
		Data = EmptyData;
		Data.TemplateName = AbilityName;
		Data.Template = AbilityTemplate;
		arrData.AddItem(Data); // array used to check for additional abilities
		SetupData.AddItem(Data);  // return array
	}

	//  Add any additional abilities
	for (i = 0; i < arrData.Length; ++i)
	{
		foreach arrData[i].Template.AdditionalAbilities(AbilityName)
		{
			AbilityTemplate = AbilityTemplateMan.FindAbilityTemplate(AbilityName);
			if (AbilityTemplate != none && !AbilityTemplate.bUniqueSource || arrData.Find('TemplateName', AbilityTemplate.DataName) == INDEX_NONE)
			{
				Data = EmptyData;
				Data.TemplateName = AbilityName;
				Data.Template = AbilityTemplate;
				Data.SourceWeaponRef = arrData[i].SourceWeaponRef;
				arrAdditional.AddItem(Data);
			}			
		}
	}
	//  Move all of the additional abilities into the return list
	for (i = 0; i < arrAdditional.Length; ++i)
	{
		if( SetupData.Find('TemplateName', arrAdditional[i].TemplateName) == INDEX_NONE )
		{
			SetupData.AddItem(arrAdditional[i]);
		}
	}
}

//=========================================================================================
//================== BEGIN EXEC LONG WAR CONSOLE EXEC =====================================
//=========================================================================================


// this allows enabling/disabling the auto-resolve in-game menu option
exec function LWSetAutoResolveEnabled(bool NewState)
{
	local XComGameState_LWToolboxOptions ToolboxOptions, UpdatedToolboxOptions;
	local XComGameState NewGameState;

	ToolboxOptions = class'XComGameState_LWToolboxOptions'.static.GetToolboxOptions();
	if(ToolboxOptions.bSimCombatOptionEnabled == NewState)
		return;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Change SimCombat Availability");
	UpdatedToolboxOptions = XComGameState_LWToolboxOptions(NewGameState.CreateStateObject(class'XComGameState_LWToolboxOptions', ToolboxOptions.ObjectID));
	NewGameState.AddStateObject(UpdatedToolboxOptions);

	UpdatedToolboxOptions.bSimCombatOptionEnabled = NewState;
	
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
}

// this allows disabling the UI even from strategy layer
exec function LWToggleUI(bool NewState)
{
	if(NewState)
	{
		`HQPRES.ShowUIForCinematics();
	}
	else
	{
		`HQPRES.HideUIForCinematics();
	}
}