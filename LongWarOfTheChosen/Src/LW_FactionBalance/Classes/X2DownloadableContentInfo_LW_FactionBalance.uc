//credit to AngelRane, NotSoLoneWolf, Udaya, and Grobobobo
class X2DownloadableContentInfo_LW_FactionBalance extends X2DownloadableContentInfo config (LW_FactionBalance);

var config float REAPER_DETECTION_RANGE_REDUCTION;

static event OnPostTemplatesCreated()
{
	IgnoreSuperConcealmentOnAllMissions();
  	AllowTwoSoldiersFromEachFaction();
}

static function IgnoreSuperConcealmentOnAllMissions()
{
	local int i;

	for (i = 0; i < `TACTICALMISSIONMGR.arrMissions.length; i++)
	{
		`TACTICALMISSIONMGR.arrMissions[i].IgnoreSuperConcealmentDetection = true;
	}
}

//Copy pasted Realitymachina's code
static function AllowTwoSoldiersFromEachFaction()
{
	local X2RewardTemplate RewardTemplate;
	local X2StrategyElementTemplateManager StratMgr;
	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();

	RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_ExtraFactionSoldier'));

	if(RewardTemplate != none)
		RewardTemplate.IsRewardAvailableFn = IsExtraSoldierAvailable;
}

static function bool IsExtraSoldierAvailable(optional XComGameState NewGameState, optional StateObjectReference AuxRef)
{
	local int NumFactionSoldiers;
	local XComGameState_ResistanceFaction FactionState;

	FactionState = class'X2StrategyElement_DefaultRewards'.static.GetFactionState(NewGameState, AuxRef);

	if (FactionState != none)
		NumFactionSoldiers = FactionState.GetNumFactionSoldiers(NewGameState);
	else
		return false;

	return (FactionState.bMetXCom && NumFactionSoldiers > 0 && NumFactionSoldiers < FactionState.default.MaxHeroesPerFaction);
}

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{}

static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
	local name Type;
	local float TempFloat;
	local int TempInt;

	Type = name(InString);
	switch(Type)
	{
	case 'FOCUS4MOBILITY':
		OutString = string(class'X2LWModTemplate_TemplarAbilities'.default.FOCUS4MOBILITY);
		return true;
	case 'FOCUS4DODGE':
		OutString = string(class'X2LWModTemplate_TemplarAbilities'.default.FOCUS4DODGE);
		return true;
	case 'FOCUS4RENDDAMAGE':
		OutString = string(class'X2LWModTemplate_TemplarAbilities'.default.FOCUS4RENDDAMAGE);
		return true;
	case 'STUNSTRIKE_STUN_CHANCE':
		OutString = string(class'X2LWModTemplate_TemplarAbilities'.default.STUNSTRIKE_STUN_CHANCE);
		return true;
	case 'LingeringShadowDefenseBonus':
		OutString = string(class'X2Ability_ReaperAbilitySet_LW'.default.LINGERING_DEFENSE);
		return true;
	case 'LingeringShadowDodgeBonus':
		OutString = string(class'X2Ability_ReaperAbilitySet_LW'.default.LINGERING_DODGE);
		return true;
	case 'BLOOD_TRAIL_ANTIDODGE_BONUS':
		OutString = string(class'X2LWModTemplate_ReaperAbilities'.default.BLOOD_TRAIL_ANTIDODGE_BONUS);
		return true;
	case 'PALE_HORSE_BASE_CRIT':
		OutString = string(class'X2LWModTemplate_ReaperAbilities'.default.PALE_HORSE_BASE_CRIT);
		return true;
	case 'PALE_HORSE_PER_KILL_CRIT':
		OutString = string(class'X2LWModTemplate_ReaperAbilities'.default.PALE_HORSE_PER_KILL_CRIT);
		return true;
	case 'PALE_HORSE_MAX_CRIT':
		OutString = string(class'X2LWModTemplate_ReaperAbilities'.default.PALE_HORSE_MAX_CRIT);
		return true;
	case 'STING_RUPTURE':
		OutString = string(class'X2LWModTemplate_ReaperAbilities'.default.STING_RUPTURE);
		return true;
	case 'StingCharges':
		OutString = string(class'X2Ability_ReaperAbilitySet'.default.StingCharges);
		return true;
	case 'CHARGE_BATTERY_CHARGES':
		OutString = string(class'X2Ability_ReaperAbilitySet_LW'.default.CHARGE_BATTERY_CHARGES);
		return true;
	case 'DemolitionistExtraChargeCount':
		OutString = string(class'X2LWModTemplate_ReaperAbilities'.default.REMOTE_START_DEMOLITIONIST_CHARGES);
		return true;
	case 'DisablingShotStunActions':
		OutString = string(class'X2Ability_ReaperAbilitySet_LW'.default.DisablingShotBaseStunActions);
		return true;
	case 'DisablingShotCritStunActions':
		OutString = string(class'X2Ability_ReaperAbilitySet_LW'.default.DisablingShotCritStunActions);
		return true;
	case 'FULL_THROTTLE_DURATION':
		OutString = string(class'X2LWModTemplate_SkirmisherAbilities'.default.FULL_THROTTLE_DURATION);
		return true;
	case 'RECKONING_LW_COOLDOWN':
		OutString = string(class'X2Ability_SkirmisherAbilitySet_LW'.default.RECKONING_LW_COOLDOWN);
		return true;
	case 'RECKONING_LW_SLASH_COOLDOWN':
		OutString = string(class'X2Ability_SkirmisherAbilitySet_LW'.default.RECKONING_LW_SLASH_COOLDOWN);
		return true;
	case 'REND_FLECHE_BONUS_DAMAGE_PER_TILES':
		TempFloat = 1 / class'X2Ability_TemplarAbilitySet_LW'.default.BONUS_REND_DAMAGE_PER_TILE;
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
	case 'MeditationFocusRecovery':
		OutString = string(class'X2Ability_TemplarAbilitySet_LW'.default.MEDITATION_FOCUS_RECOVERY);
		return true;
	case 'OverchargeAimBonus':
		OutString = string(class'X2Ability_TemplarAbilitySet_LW'.default.FOCUS1AIM);
		return true;
	case 'OverchargeDefenseBonus':
		OutString = string(class'X2Ability_TemplarAbilitySet_LW'.default.FOCUS1DEFENSE);
		return true;
	case 'VoltDangerZoneBonus':
		OutString = string(class'X2LWModTemplate_TemplarAbilities'.default.VOLT_DANGER_ZONE_BONUS_RADIUS);
		return true;
	case 'ApotheosisMobilityBonus':
		OutString = string(class'X2Ability_TemplarAbilitySet_LW'.default.APOTHEOSIS_MOBILITY_BONUS);
		return true;
	case 'ApotheosisDodgeBonus':
		OutString = string(class'X2Ability_TemplarAbilitySet_LW'.default.APOTHEOSIS_DODGE_BONUS);
		return true;
	case 'ApotheosisDamageMultiplier':
		OutString = string(int(class'X2Ability_TemplarAbilitySet_LW'.default.APOTHEOSIS_DAMAGE_MULTIPLIER * 100));
		return true;
	}

	return false;
}
