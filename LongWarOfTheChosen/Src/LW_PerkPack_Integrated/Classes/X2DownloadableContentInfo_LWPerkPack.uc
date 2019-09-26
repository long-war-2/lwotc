//---------------------------------------------------------------------------------------
//  FILE:    X2DownloadableContentInfo_LWPerkPack.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Initializes PerkPack mod settings on campaign start or when loading campaign without mod previously active
//--------------------------------------------------------------------------------------- 

class X2DownloadableContentInfo_LWPerkPack extends X2DownloadableContentInfo;	

//`include(LW_PerkPack_Integrated\LW_PerkPack.uci)

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{
	`PPDEBUG("LW PerkPack : Starting OnLoadedSavedGame");
	class'XComGameState_LWPerkPackOptions'.static.CreateModSettingsState_ExistingCampaign(class'XComGameState_LWPerkPackOptions');
}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed. When a new campaign is started the initial state of the world
/// is contained in a strategy start state. Never add additional history frames inside of InstallNewCampaign, add new state objects to the start state
/// or directly modify start state objects
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{
	class'XComGameState_LWPerkPackOptions'.static.CreateModSettingsState_NewCampaign(class'XComGameState_LWPerkPackOptions', StartState);
}

/// <summary>
/// Called after the Templates have been created (but before they are validated) while this DLC / Mod is installed.
/// </summary>
static event OnPostTemplatesCreated()
{
	UpdateBaseGameOverwatchShot();
	UpdateBaseGameThrowGrenade();
	//UpdateBaseGameAidProtocol();
}

//Restores VM's ability to modify radius
static function UpdateBaseGameThrowGrenade()
{
	local X2AbilityTemplateManager			AbilityTemplateManager;
	local X2AbilityTemplate					ThrowGrenadeAbilityTemplate, LaunchGrenadeAbilityTemplate, ProximityMineAbilityTemplate;
	//local AbilityGrantedBonusRadius			BonusRadius;

	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	ThrowGrenadeAbilityTemplate = AbilityTemplateManager.FindAbilityTemplate('ThrowGrenade');
	LaunchGrenadeAbilityTemplate = AbilityTemplateManager.FindAbilityTemplate('LaunchGrenade');
	ProximityMineAbilityTemplate = AbilityTemplateManager.FindAbilityTemplate('ProximityMineDetonation');
	X2AbilityMultiTarget_Radius(ThrowGrenadeAbilityTemplate.AbilityMultiTargetStyle).AddAbilityBonusRadius('VolatileMix', 1.0);
	X2AbilityMultiTarget_Radius(LaunchGrenadeAbilityTemplate.AbilityMultiTargetStyle).AddAbilityBonusRadius('VolatileMix', 1.0);
	X2AbilityMultiTarget_Radius(ProximityMineAbilityTemplate.AbilityMultiTargetStyle).AddAbilityBonusRadius('VolatileMix', 1.0);

	`PPDEBUG ("Updated Grenades to respect VM radius increase");
}

static function UpdateBaseGameOverwatchShot()
{
	local X2AbilityTemplateManager			AbilityTemplateManager;
	local X2AbilityTemplate					OverwatchAbilityTemplate;
	local X2Condition_RequiredToHitChance	RequiredHitChanceCondition;
	local X2Condition_OverwatchLimit		OWLimitCondition;
	local name AbilityName;

	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	RequiredHitChanceCondition = new class'X2Condition_RequiredToHitChance';
	RequiredHitChanceCondition.MinimumRequiredHitChance = class'X2Ability_PerkPackAbilitySet2'.default.REQUIRED_TO_HIT_FOR_OVERWATCH;  
	foreach class'X2Ability_perkPackAbilitySet2'.default.REQUIRED_OVERWATCH_TO_HIT_EXCLUDED_ABILITIES(AbilityName)
	{
		RequiredHitChanceCondition.ExcludedAbilities.AddItem(AbilityName);
	}
	
	OWLimitCondition = new class 'X2Condition_OverwatchLimit';

	`PPDEBUG("Updating OverwatchShot for REQUIRED_TO_HIT_FOR_OVERWATCH");
	OverwatchAbilityTemplate = AbilityTemplateManager.FindAbilityTemplate('OverwatchShot');
	OverwatchAbilityTemplate.AbilityTargetConditions.AddItem(RequiredHitChanceCondition);
	OverwatchAbilityTemplate.AbilityTargetConditions.AddItem(OWLimitCondition);

	`PPDEBUG("Updating KillzoneShot for REQUIRED_TO_HIT_FOR_OVERWATCH");
	OverwatchAbilityTemplate = AbilityTemplateManager.FindAbilityTemplate('KillzoneShot');
	OverwatchAbilityTemplate.AbilityTargetConditions.AddItem(RequiredHitChanceCondition);
	// Kill Zone (and Gunslinger) polices multi-shots against hte same target already

	`PPDEBUG("Updating LongWatchShot for REQUIRED_TO_HIT_FOR_OVERWATCH");
	OverwatchAbilityTemplate = AbilityTemplateManager.FindAbilityTemplate('LongWatchShot');
	OverwatchAbilityTemplate.AbilityTargetConditions.AddItem(RequiredHitChanceCondition);
	OverwatchAbilityTemplate.AbilityTargetConditions.AddItem(OWLimitCondition);

	`PPDEBUG("Updating PistolOverwatchShot for REQUIRED_TO_HIT_FOR_OVERWATCH");
	OverwatchAbilityTemplate = AbilityTemplateManager.FindAbilityTemplate('PistolOverwatchShot');
	OverwatchAbilityTemplate.AbilityTargetConditions.AddItem(RequiredHitChanceCondition);
	OverwatchAbilityTemplate.AbilityTargetConditions.AddItem(OWLimitCondition);
}

static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
    local name Type;
	local float TempFloat;
	local int TempInt;

    Type = name(InString);
    switch(Type)
    {
        case 'FLECHE_BONUS_DAMAGE_PER_TILES':
			TempFloat = 1 / class'X2Effect_FlecheBonusDamage'.default.BonusDmgPerTile;
			TempFloat = Round(TempFloat * 10.0) / 10.0;
			TempInt = int(TempFloat);
			if ( float(TempInt) ~= TempFloat)
			{
				OutString = string(TempInt);
			}
			else
			{
				OutString = Repl(string(TempFloat), "0", "");
			}
            return true;
		case 'GRAZING_FIRE_SUCCESS_CHANCE':
			Outstring = string (class 'X2Ability_PerkPackAbilitySet'.default.GRAZING_FIRE_SUCCESS_CHANCE);
			return true;
        default:
            return false;
    }
    return ReturnValue;    
}

//unused for now, but keeping since we may want to update threat assessment later
//static function UpdateBaseGameAidProtocol()
//{
	//local X2AbilityTemplateManager			AbilityTemplateManager;
	//local X2AbilityTemplate					AidProtocolAbilityTemplate;
	//local X2Effect							Effect;
	//local X2Effect_ThreatAssessment			CoveringFireEffect;
	//local X2Condition_AbilityProperty       AbilityCondition;
	//local X2Condition_AbilityProperty		SchismCondition;
//
	//AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
//
	//AidProtocolAbilityTemplate = AbilityTemplateManager.FindAbilityTemplate('AidProtocol');
//
//
	//SchismCondition = new class'X2Condition_AbilityProperty';
	//SchismCondition.OwnerHasSoldierAbilities.AddItem('Schism');
//
//
	////  add covering fire effect if the soldier has threat assessment - this pistol shot only applies to units with sniper rifles and no snapshot
	//CoveringFireEffect = new class'X2Effect_ThreatAssessment';
	//CoveringFireEffect.EffectName = 'PistolThreatAssessment';
	//CoveringFireEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	//CoveringFireEffect.AbilityToActivate = 'PistolReturnFire';
	//CoveringFireEffect.ImmediateActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	//AbilityCondition = new class'X2Condition_AbilityProperty';
	//AbilityCondition.OwnerHasSoldierAbilities.AddItem('ThreatAssessment');
	//CoveringFireEffect.TargetConditions.AddItem(AbilityCondition);
//
	//UnitCondition = new class'X2Condition_UnitProperty';
	//UnitCondition.ExcludeHostileToSource = true;
	//UnitCondition.ExcludeFriendlyToSource = false;
	//UnitCondition.RequireSoldierClasses.AddItem('Sharpshooter_LW');
	//CoveringFireEffect.TargetConditions.AddItem(UnitCondition);
	//Template.AddTargetEffect(CoveringFireEffect);
//
//}

