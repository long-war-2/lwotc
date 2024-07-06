//---------------------------------------------------------------------------------------
//  FILE:    X2DownloadableContentInfo_LWPerkPack.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Initializes PerkPack mod settings on campaign start or when loading campaign without mod previously active
//--------------------------------------------------------------------------------------- 

class X2DownloadableContentInfo_LWPerkPack extends X2DownloadableContentInfo;	

`include(LW_PerkPack_Integrated\LW_PerkPack.uci)

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
	//short circuit if in shell:
//	if(class'WorldInfo'.static.GetWorldInfo().GRI.GameClass.name == 'XComShell')
//	{
//		`LWTrace("InstallNewCampaign called in Shell, aborting.");
//		return;
//	}
	
	class'XComGameState_LWPerkPackOptions'.static.CreateModSettingsState_NewCampaign(class'XComGameState_LWPerkPackOptions', StartState);
}

/// <summary>
/// Called after the Templates have been created (but before they are validated) while this DLC / Mod is installed.
/// </summary>
static event OnPostTemplatesCreated()
{
	local X2ItemTemplateManager			ItemManager;

	ItemManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	UpdateBaseGameOverwatchShot();
	UpdateBaseGameThrowGrenade();
	/*
		Might not be the right place to be adding this. I recall that lwotc does something unique in place
		of a lot of OPTC shenanigans.
	*/
	PatchItemsForDenseSmoke(ItemManager);
	PatchItemsForStingGrenades(ItemManager);
	//UpdateBaseGameAidProtocol();
}

static function PatchItemsForStingGrenades(X2ItemTemplateManager ItemManager)
{
	local X2GrenadeTemplate					Template;
	local name								ItemName;

	foreach class'LW_PerkPack_Integrated.X2Ability_PerkPackAbilitySet2'.default.FLASHBANGS_FOR_STING_GRENADES(ItemName)
	{
		Template = X2GrenadeTemplate(ItemManager.FindItemTemplate(ItemName));
		if(Template != none)
		{
			UpdateForStingGrenades(Template);
		}
	}
}

static function UpdateForStingGrenades(X2GrenadeTemplate Template)
{
	Template.ThrownGrenadeEffects.AddItem(class'LW_PerkPack_Integrated.X2Ability_PerkPackAbilitySet2'.static.StingGrenadeEffect());
	Template.LaunchedGrenadeEffects.AddItem(class'LW_PerkPack_Integrated.X2Ability_PerkPackAbilitySet2'.static.StingGrenadeEffect());
}

static function PatchItemsForDenseSmoke(X2ItemTemplateManager ItemManager)
{
	local X2GrenadeTemplate					Template;
	local name								ItemName;

	foreach class'LW_PerkPack_Integrated.X2Ability_PerkPackAbilitySet2'.default.SMOKE_GRENADES_FOR_DENSE_SMOKE(ItemName)
	{
		Template = X2GrenadeTemplate(ItemManager.FindItemTemplate(ItemName));
		if(Template != none)
		{
			UpdateForDenseSmoke(Template);
		}
	}
}

static function UpdateForDenseSmoke(X2GrenadeTemplate Template)
{
	Template.ThrownGrenadeEffects.AddItem(class'LW_PerkPack_Integrated.X2Ability_PerkPackAbilitySet2'.static.DenseSmokeEffect());
	Template.LaunchedGrenadeEffects.AddItem(class'LW_PerkPack_Integrated.X2Ability_PerkPackAbilitySet2'.static.DenseSmokeEffect());
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

	X2AbilityMultiTarget_Radius(ThrowGrenadeAbilityTemplate.AbilityMultiTargetStyle).AddAbilityBonusRadius('MistyMadness_LW', 2.0);
	X2AbilityMultiTarget_Radius(LaunchGrenadeAbilityTemplate.AbilityMultiTargetStyle).AddAbilityBonusRadius('MistyMadness_LW', 2.0);
	X2AbilityMultiTarget_Radius(ProximityMineAbilityTemplate.AbilityMultiTargetStyle).AddAbilityBonusRadius('MistyMadness_LW', 2.0);
	
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

static function bool AbilityTagExpandHandler_CH(string InString, out string OutString, Object ParseObj, Object StrategyParseObj, XComGameState GameState)
{
	local XComGameState_Ability AbilityState;
	local XComGameState_Effect EffectState;
	local X2AbilityTemplate AbilityTemplate;
	local X2ItemTemplate ItemTemplate;
	local name Type;
	local float TempFloat;
	local int TempInt;

    Type = name(InString);
    switch(Type)
    {
		case 'BOUND_WEAPON_NAME':
			AbilityTemplate = X2AbilityTemplate(ParseObj);
			if (StrategyParseObj != none && AbilityTemplate != none)
			{
				ItemTemplate = GetItemBoundToAbilityFromUnit(XComGameState_Unit(StrategyParseObj), AbilityTemplate.DataName, GameState);
			}
			else
			{
				AbilityState = XComGameState_Ability(ParseObj);
				EffectState = XComGameState_Effect(ParseObj);
				if (EffectState != none)
				{
					AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(
							EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
				}

				if (AbilityState != none)
					ItemTemplate = AbilityState.GetSourceWeapon().GetMyTemplate();
			}

			if (ItemTemplate != none)
			{
				OutString = ItemTemplate.GetItemAbilityDescName();
				return true;
			}
			OutString = AbilityTemplate.LocDefaultPrimaryWeapon;
			return true;
        case 'FLECHE_BONUS_DAMAGE_PER_TILES':
			TempFloat = 1 / class'X2Ability_PerkPackAbilitySet2'.default.BONUS_SLICE_DAMAGE_PER_TILE;
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
		case 'MAX_SLICE_FLECHE_DAMAGE':
			Outstring = string(class'X2Ability_PerkPackAbilitySet2'.default.MAX_SLICE_FLECHE_DAMAGE);
			return true;
		case 'CUTTHROAT_BONUS_CRIT_CHANCE':
			Outstring = string(class'X2Ability_PerkPackAbilitySet'.default.CUTTHROAT_BONUS_CRIT_CHANCE);
			return true;
		case 'CUTTHROAT_BONUS_CRIT_DAMAGE':
			Outstring = string(class'X2Ability_PerkPackAbilitySet'.default.CUTTHROAT_BONUS_CRIT_DAMAGE);
			return true;
		case 'CCS_AMMO_PER_SHOT':
			Outstring = string(class'X2Ability_PerkPackAbilitySet'.default.CCS_AMMO_PER_SHOT);
			return true;
		case 'CCS_RANGE':
			Outstring = string(class'X2AbilityTarget_Single_CCS'.default.CCS_RANGE);
			return true;
		case 'COVERING_FIRE_OFFENSE_MALUS':
			Outstring = string(class'X2Ability_PerkPackAbilitySet'.default.COVERING_FIRE_OFFENSE_MALUS);
			return true;
		case 'GHOSTWALKER_DETECTION_RANGE_REDUCTION':
			Outstring = string(int(class'X2Ability_PerkPackAbilitySet'.default.GHOSTWALKER_DETECTION_RANGE_REDUCTION * 100));
			return true;
		case 'GHOSTWALKER_DURATION':
			Outstring = string(class'X2Ability_PerkPackAbilitySet'.default.GHOSTWALKER_DURATION);
			return true;
		case 'COVERT_DETECTION_RANGE_REDUCTION':
			Outstring = string(int(class'X2Ability_PerkPackAbilitySet'.default.COVERT_DETECTION_RANGE_REDUCTION * 100));
			return true;
		case 'NUM_AIRDROP_CHARGES':
			Outstring = string(class'X2Ability_PerkPackAbilitySet2'.default.NUM_AIRDROP_CHARGES);
			return true;
		case 'GRAZING_FIRE_SUCCESS_CHANCE':
			Outstring = string (class 'X2Ability_PerkPackAbilitySet'.default.GRAZING_FIRE_SUCCESS_CHANCE);
			return true;
		case 'IMPULSE_AIM_BONUS':
			OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.IMPULSE_AIM_BONUS);
			return true;
		case 'IMPULSE_CRIT_BONUS':
			OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.IMPULSE_CRIT_BONUS);
			return true;
		case 'MAIM_AMMO_COST':
			OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.MAIM_AMMO_COST);
			return true;
		case 'MAIM_COOLDOWN':
			OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.MAIM_COOLDOWN);
			return true;
		case 'OVERBEARING_SUPERIORITY_CRIT':
			OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.OVERBEARING_SUPERIORITY_CRIT);
			return true;
		case 'TRIGGER_BOT_DAMAGE_PENALTY':
			OutString = string(int(class'X2Ability_XMBPerkAbilitySet'.default.TRIGGER_BOT_DAMAGE_PENALTY * 100));
			return true;
		case 'LICKYOURWOUNDS_HEALAMOUNT':
			OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.LICKYOURWOUNDS_HEALAMOUNT);
			return true;
		case 'LICKYOURWOUNDS_MAXHEALAMOUNT':
			OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.LICKYOURWOUNDS_MAXHEALAMOUNT);
			return true;
		case 'PRESERVATION_DEFENSE_BONUS':
			OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.PRESERVATION_DEFENSE_BONUS);
			return true;
		case 'PRESERVATION_DURATION':
			OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.PRESERVATION_DURATION);
			return true;
		case 'LOCKNLOAD_AMMO_TO_RELOAD':
			OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.LOCKNLOAD_AMMO_TO_RELOAD);
			return true;
		case 'DEDICATIONLW_MOBILITY':
			OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.DEDICATION_MOBILITY);
			return true;
		case 'DEDICATION_COOLDOWN':
			OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.DEDICATION_COOLDOWN);
			return true;
		case 'APEX_PREDATOR_PANIC_RADIUS':
			OutString = string(int(class'X2Ability_XMBPerkAbilitySet'.default.APEX_PREDATOR_PANIC_RADIUS));
			return true;
		case 'APEX_PREDATOR_BASE_PANIC_CHANCE':
			OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.APEX_PREDATOR_BASE_PANIC_CHANCE + class'X2AbilityToHitCalc_PanicCheck'.default.BaseValue);
			return true;
		case 'PREDATOR_AIM_BONUS':
			OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.PREDATOR_AIM_BONUS);
			return true;
		case 'PREDATOR_CRIT_BONUS':
			OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.PREDATOR_CRIT_BONUS);
			return true;
		case 'SAVIOR_BONUS_HEAL':
			OutString = string(class'X2Ability_PerkPackAbilitySet2'.default.SAVIOR_BONUS_HEAL);
			return true;
		case 'STILETTO_ARMOR_PIERCING':
			OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.STILETTO_ARMOR_PIERCING);
			return true;
		case 'THATS_CLOSE_ENOUGH_TILE_RANGE':
			OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.THATS_CLOSE_ENOUGH_TILE_RANGE);	
			return true;
		case 'THATS_CLOSE_ENOUGH_COOLDOWN':
			OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.THATS_CLOSE_ENOUGH_COOLDOWN);	
			return true;
		case 'THATS_CLOSE_ENOUGH_PER_TARGET_COOLDOWN':
			OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.THATS_CLOSE_ENOUGH_PER_TARGET_COOLDOWN);	
			return true;
		case 'NONE_SHALL_PASS_TILE_RANGE':
			OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.NONE_SHALL_PASS_TILE_RANGE);	
			return true;
		case 'BRUTALITY_TILE_RADIUS':
			OutString = string(int(class'X2Ability_XMBPerkAbilitySet'.default.BRUTALITY_TILE_RADIUS));	
			return true;
		case 'BRUTALITY_PANIC_CHANCE':
			OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.BRUTALITY_PANIC_CHANCE);	
			return true;
		case 'WPN_HANDLING_MODIFIER':
			OutString = string(int(class'X2Ability_XMBPerkAbilitySet'.default.WEAPONHANDLING_MULTIPLIER * -100));	
			return true;
		case 'ZONE_CONTROL_AIM_PENALTY':
			OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.ZONE_CONTROL_AIM_PENALTY);
			return true;
		case 'ZONE_CONTROL_MOBILITY_PENALTY':
			OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.ZONE_CONTROL_MOBILITY_PENALTY);
			return true;
		case 'BLIND_PROTOCOL_RADIUS_CV':
			Outstring = string(int(class'X2Ability_XMBPerkAbilitySet'.default.BLIND_PROTOCOL_RADIUS_T1_BASE));
			return true;
		case 'BLIND_PROTOCOL_RADIUS_MG':
			Outstring = string(int(class'X2Ability_XMBPerkAbilitySet'.default.BLIND_PROTOCOL_RADIUS_T1_BASE + class'X2Ability_XMBPerkAbilitySet'.default.BLIND_PROTOCOL_RADIUS_T2_BONUS));
			return true;
		case 'BLIND_PROTOCOL_RADIUS_BM':
			Outstring = string(int(class'X2Ability_XMBPerkAbilitySet'.default.BLIND_PROTOCOL_RADIUS_T1_BASE + class'X2Ability_XMBPerkAbilitySet'.default.BLIND_PROTOCOL_RADIUS_T3_BONUS));
			return true;
		case 'TARGET_FOCUS_AIM_BONUS':
			Outstring = string(class'X2Ability_XMBPerkAbilitySet'.default.TARGET_FOCUS_AIM_BONUS);
			return true;
		case 'TARGET_FOCUS_PEN_BONUS':
			Outstring = string(class'X2Ability_XMBPerkAbilitySet'.default.TARGET_FOCUS_PIERCE);
			return true;
		case 'AIM_ASSIST_AIM_BONUS':
			Outstring = string(class'X2Ability_XMBPerkAbilitySet'.default.AIM_ASSIST_AIM_BONUS);
			return true;
		case 'AIM_ASSIST_CRIT_BONUS':
			Outstring = string(class'X2Ability_XMBPerkAbilitySet'.default.AIM_ASSIST_CRIT_BONUS);
			return true;
		case 'SS_PIERCE':
			Outstring = string(class'X2Ability_XMBPerkAbilitySet'.default.SS_PIERCE);
			return true;
		case 'SS_AIM_BONUS':
			Outstring = string(class'X2Ability_XMBPerkAbilitySet'.default.SS_AIM_BONUS);
			return true;
		case 'SUPERCHARGE_CHARGES':
			OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.SUPERCHARGE_CHARGES);
			return true;
		case 'SUPERCHARGE_HEAL':
			OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.SUPERCHARGE_HEAL);
			return true;
		case 'OVERKILL_DAMAGE':
			OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.OverkillBonusDamage);
			return true;
		case 'DISASSEMBLY_HACK':
			OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.DISSASSEMBLY_HACK);
			return true;
		case 'LIGHTNINGSLASH_COOLDOWN':
			OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.LIGHTNINGSLASH_COOLDOWN);
			return true;
		case 'INSPIRE_DODGE':
			OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.INSPIRE_DODGE);
			return true;
		case 'LEAD_TARGET_AIM_BONUS':
			OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.LEAD_TARGET_AIM_BONUS);
			return true;
		case 'LEAD_TARGET_COOLDOWN':
			OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.LEAD_TARGET_COOLDOWN);
			return true;
		case 'ZONE_CONTROL_RADIUS':
			OutString = string(int(sqrt(class'X2Ability_XMBPerkAbilitySet'.default.ZONE_CONTROL_RADIUS_SQ)));
			return true;
		case 'EXECUTIONER_AIM_BONUS':
			OutString = string(class'X2Effect_Executioner_LW'.default.EXECUTIONER_AIM_BONUS);
			return true;
		case 'EXECUTIONER_CRIT_BONUS':
			OutString = string(class'X2Effect_Executioner_LW'.default.EXECUTIONER_CRIT_BONUS);
			return true;
		case 'LOCKEDON_AIM_BONUS':
			OutString = string(class'X2Effect_LockedOn'.default.LOCKEDON_AIM_BONUS);
			return true;
		case 'LOCKEDON_CRIT_BONUS':
			OutString = string(class'X2Effect_LockedOn'.default.LOCKEDON_CRIT_BONUS);
			return true;
		case 'CYCLIC_FIRE_COOLDOWN':
			OutString = string(class'X2Ability_PerkPackAbilitySet'.default.CYCLIC_FIRE_COOLDOWN);
			return true;
		case 'CYCLIC_FIRE_AIM_MALUS':
			OutString = string(class'X2Ability_PerkPackAbilitySet'.default.CYCLIC_FIRE_AIM_MALUS);
			return true;
		case 'BASTION_RADIUS_TILES':
			OutString = string(int(sqrt(class'X2Effect_Bastion'.default.BASTION_DISTANCE_SQ)));
			return true;
		case 'IRON_CURTAIN_DAMAGE_MODIFIER':
			OutString = string(int(class'X2Effect_IronCurtain'.default.IRON_CURTAIN_DAMAGE_MODIFIER * 100));
			return true;
		case 'IRON_CURTAIN_MOBILITY_DAMAGE':
			OutString = string(class'X2Ability_PerkPackAbilitySet'.default.IRON_CURTAIN_MOBILITY_DAMAGE);
			return true;
		case 'IRON_CURTAIN_MOB_DAMAGE_DURATION':
			OutString = string(class'X2Ability_PerkPackAbilitySet'.default.IRON_CURTAIN_MOB_DAMAGE_DURATION);
			return true;
		case 'IRON_CURTAIN_AMMO_COST':
			OutString = string(class'X2Ability_PerkPackAbilitySet'.default.IRON_CURTAIN_AMMO_COST);
			return true;
		case 'SLUG_SHOT_COOLDOWN':
			OutString = string(class'X2Ability_PerkPackAbilitySet'.default.SLUG_SHOT_COOLDOWN);
			return true;
		case 'RAPID_STUN_COOLDOWN':
			OutString = string(class'X2Ability_XMBPerkAbilitySet'.default.RAPID_STUN_COOLDOWN);
			return true;
		case 'SHARPSHOOTERAIM_CRITBONUS':
			OutString = string(class'X2Ability_PerkPackAbilitySet'.default.SHARPSHOOTERAIM_CRITBONUS);
			return true;
		case 'PRECISION_SHOT_CRIT_BONUS':
			OutString = string(class'X2Ability_PerkPackAbilitySet'.default.PRECISION_SHOT_CRIT_BONUS);
			return true;
		case 'PRECISION_SHOT_CRIT_DAMAGE_MODIFIER':
			OutString = string(int(class'X2Effect_PrecisionShotCritDamage'.default.PRECISION_SHOT_CRIT_DAMAGE_MODIFIER * 100));
			return true;
		case 'DISORIENTED_MOBILITY_ADJUST':
			OutString = string (class 'X2StatusEffects'.default.DISORIENTED_MOBILITY_ADJUST);
			return true;
		case 'DISORIENTED_AIM_ADJUST':
			OutString = string (class 'X2StatusEffects'.default.DISORIENTED_AIM_ADJUST);
			return true;
		case 'WALK_FIRE_DMG':
			OutString = string (int(class 'X2Effect_WalkFireDamage'.default.WALK_FIRE_DAMAGE_MODIFIER * -100));
			return true;
		case 'WALK_FIRE_AIM_BONUS':
			OutString = string(class'X2Ability_PerkPackAbilitySet'.default.WALK_FIRE_AIM_BONUS);
			return true;
		case 'WALK_FIRE_CRIT_MALUS':
			OutString = string(class'X2Ability_PerkPackAbilitySet'.default.WALK_FIRE_CRIT_MALUS);
			return true;
		case 'GUNSLINGER_TILES_RANGE':
			OutString = string(class'X2Ability_PerkPackAbilitySet'.default.GUNSLINGER_METERS_RANGE * 2 / 3);
			return true;
		case 'GUNSLINGER_COOLDOWN':
			OutString = string(class'X2Ability_PerkPackAbilitySet'.default.GUNSLINGER_COOLDOWN);
			return true;
		case 'INFIGHTER_DODGE_BONUS':
			OutString = string(class'X2Effect_Infighter'.default.INFIGHTER_DODGE_BONUS);
			return true;
		case 'IRT_DODGE_PER_TILE':
			OutString = string(class'X2Effect_InstantReactionTime'.default.IRT_DODGE_PER_TILE);
			return true;
		case 'BRAWLER_DR_PCT':
			OutString = string(int(class'X2Effect_Brawler'.default.BRAWLER_DR_PCT));
			return true;
		case 'BRAWLER_MAX_TILES':
			OutString = string(class'X2Effect_Brawler'.default.BRAWLER_MAX_TILES);
			return true;
		case 'LONEWOLF_AIM_PER_TILE':
			OutString = string(class'X2Effect_LoneWolf'.default.LONEWOLF_AIM_PER_TILE);
			return true;
		case 'LONEWOLF_DEF_PER_TILE':
			OutString = string(class'X2Effect_LoneWolf'.default.LONEWOLF_DEF_PER_TILE);
			return true;
		case 'LONEWOLF_AIM_BONUS':
			OutString = string(class'X2Effect_LoneWolf'.default.LONEWOLF_AIM_BONUS);
			return true;
		case 'LONEWOLF_DEF_BONUS':
			OutString = string(class'X2Effect_LoneWolf'.default.LONEWOLF_DEF_BONUS);
			return true;
		case 'LONEWOLF_MIN_DIST_TILES':
			OutString = string(class'X2Effect_LoneWolf'.default.LONEWOLF_MIN_DIST_TILES);
			return true;
		case 'LONEWOLF_MIN_BONUS_TILES':
			OutString = string(class'X2Effect_LoneWolf'.default.LONEWOLF_MIN_DIST_TILES - 
					(class'X2Effect_LoneWolf'.default.LONEWOLF_AIM_BONUS / class'X2Effect_LoneWolf'.default.LONEWOLF_AIM_PER_TILE) + 1);
			return true;
		case 'LETHAL_DAMAGE_LW':
			OutString = string(class'X2Ability_PerkPackAbilitySet'.default.LETHAL_DAMAGE);
			return true;
		case 'LETHAL_CRIT_DAMAGE_LW':
			OutString = string(class'X2Ability_PerkPackAbilitySet'.default.LETHAL_DAMAGE / 2);
			return true;
		case 'FORMIDABLE_EXPLOSIVES_DR':
			OutString = string(int(class'X2Ability_PerkPackAbilitySet'.default.FORMIDABLE_EXPLOSIVES_DR * 100));
			return true;
		case 'FORMIDABLE_ABLATIVE_HP':
			OutString = string(class'X2Ability_PerkPackAbilitySet'.default.FORMIDABLE_ABLATIVE_HP);
			return true;
		case 'SLUG_SHOT_PIERCE':
			OutString = string(class'X2Ability_PerkPackAbilitySet'.default.SLUG_SHOT_PIERCE);
			return true;
		case 'SLUG_SHOT_ACC_BONUS':
			OutString = string(class'X2Ability_PerkPackAbilitySet'.default.SLUG_SHOT_ACC_BONUS);
			return true;
		case 'KILLER_INSTINCT_CRIT_DAMAGE_BONUS_PCT':
			OutString = string(int(class'X2Effect_KillerInstinct'.default.KILLER_INSTINCT_CRIT_DAMAGE_BONUS_PCT));
			return true;
		case 'RUN_AND_GUN_COOLDOWN':
			OutString = string(class'X2AbilityCooldown_RunAndGun_LW'.default.RUN_AND_GUN_COOLDOWN);
			return true;
		case 'LOCKDOWN_TOHIT_BONUS':
			OutString = string(Round(class'X2Effect_LockdownDamage'.default.LOCKDOWN_TOHIT_BONUS * (1.0 - class'X2AbilityToHitCalc_StandardAim'.default.REACTION_FINALMOD)));
			return true;
		case 'MAYHEM_DAMAGE_BONUS_PCT':
			OutString = string(int(class'X2Effect_Mayhem'.default.MAYHEM_DAMAGE_BONUS_PCT));
			return true;
		case 'DP_AIM_BONUS': // Depth Perception
			Outstring = string(class'X2Effect_DepthPerception'.default.DP_AIM_BONUS);
			return true;
		case 'DP_ANTIDODGE_BONUS': // Depth Perception
			Outstring = string(class'X2Effect_DepthPerception'.default.DP_ANTIDODGE_BONUS);
			return true;
		case 'HYPERREACTIVE_PUPILS_AIM_BONUS':
			Outstring = string(class'X2Effect_HyperReactivePupils'.default.HYPERREACTIVE_PUPILS_AIM_BONUS);
			return true;
		case 'COMBAT_AWARENESS_BONUS_ARMOR':
			Outstring = string(class'X2Effect_CombatAwareness'.default.COMBAT_AWARENESS_BONUS_ARMOR);
			return true;
		case 'COMBAT_AWARENESS_BONUS_DEFENSE':
			Outstring = string(class'X2Effect_CombatAwareness'.default.COMBAT_AWARENESS_BONUS_DEFENSE);
			return true;
		case 'COMBAT_RUSH_RADIUS':
			Outstring = string(int(class'X2Ability_PerkPackAbilitySet'.default.COMBAT_RUSH_RADIUS));
			return true;
		case 'COMBAT_RUSH_AIM_BONUS':
			Outstring = string(class'X2Ability_PerkPackAbilitySet'.default.COMBAT_RUSH_AIM_BONUS);
			return true;
		case 'COMBAT_RUSH_CRIT_BONUS':
			Outstring = string(class'X2Ability_PerkPackAbilitySet'.default.COMBAT_RUSH_CRIT_BONUS);
			return true;
		case 'COMBAT_RUSH_MOBILITY_BONUS':
			Outstring = string(class'X2Ability_PerkPackAbilitySet'.default.COMBAT_RUSH_MOBILITY_BONUS);
			return true;
		case 'COMBAT_RUSH_DURATION':
			Outstring = string(class'X2Ability_PerkPackAbilitySet'.default.COMBAT_RUSH_DURATION);
			return true;
		case 'COMBAT_RUSH_COOLDOWN':
			Outstring = string(class'X2Ability_PerkPackAbilitySet'.default.COMBAT_RUSH_COOLDOWN);
			return true;
		case 'DAMAGE_CONTROL_DURATION':
			Outstring = string(class'X2Ability_PerkPackAbilitySet'.default.DAMAGE_CONTROL_DURATION);
			return true;
		case 'DAMAGE_CONTROL_BONUS_ARMOR':
			Outstring = string(class'X2Ability_PerkPackAbilitySet'.default.DAMAGE_CONTROL_BONUS_ARMOR);
			return true;
		case 'ABSORPTION_FIELDS_COOLDOWN':
			Outstring = string(class'X2Ability_PerkPackAbilitySet'.default.ABSORPTION_FIELDS_COOLDOWN);
			return true;
		case 'ABSORPTION_FIELDS_DURATION':
			Outstring = string(class'X2Ability_PerkPackAbilitySet'.default.ABSORPTION_FIELDS_DURATION);
			return true;
		case 'BODY_SHIELD_DEF_BONUS':
			Outstring = string(class'X2Ability_PerkPackAbilitySet'.default.BODY_SHIELD_DEF_BONUS);
			return true;
		case 'BODY_SHIELD_ENEMY_CRIT_MALUS':
			Outstring = string(class'X2Ability_PerkPackAbilitySet'.default.BODY_SHIELD_ENEMY_CRIT_MALUS);
			return true;
		case 'BODY_SHIELD_COOLDOWN':
			Outstring = string(class'X2Ability_PerkPackAbilitySet'.default.BODY_SHIELD_COOLDOWN);
			return true;
		case 'BODY_SHIELD_DURATION':
			Outstring = string(class'X2Ability_PerkPackAbilitySet'.default.BODY_SHIELD_DURATION);
			return true;
		case 'EMERGENCY_LIFE_SUPPORT_BONUS_BLEEDINGOUT_TURNS':
			Outstring = string(class'X2Effect_EmergencyLifeSupport'.default.EMERGENCY_LIFE_SUPPORT_BONUS_BLEEDINGOUT_TURNS);
			return true;
		case 'IRON_SKIN_MELEE_DAMAGE_REDUCTION':
			Outstring = string(class'X2Ability_PerkPackAbilitySet'.default.IRON_SKIN_MELEE_DAMAGE_REDUCTION);
			return true;
		case 'MIND_MERGE_WILL_DIVISOR':
			Outstring = string(int(class'X2Ability_PerkPackAbilitySet'.default.MIND_MERGE_WILL_DIVISOR));
			return true;
		case 'MIND_MERGE_CRIT_DIVISOR':
			Outstring = string(int(class'X2Ability_PerkPackAbilitySet'.default.MIND_MERGE_CRIT_DIVISOR));
			return true;
		case 'MIND_MERGE_SHIELDHP_DIVISOR':
			Outstring = string(int(class'X2Ability_PerkPackAbilitySet'.default.MIND_MERGE_SHIELDHP_DIVISOR));
			return true;
		case 'MIND_MERGE_AMP_MG_TOTAL_WILL':
			Outstring = string(class'X2Ability_PerkPackAbilitySet'.default.MIND_MERGE_AMP_MG_WILL_BONUS);
			return true;
		case 'MIND_MERGE_AMP_MG_TOTAL_CRIT':
			Outstring = string(class'X2Ability_PerkPackAbilitySet'.default.MIND_MERGE_AMP_MG_CRIT_BONUS);
			return true;
		case 'MIND_MERGE_AMP_MG_TOTAL_SHIELDHP':
			Outstring = string(1 + class'X2Ability_PerkPackAbilitySet'.default.MIND_MERGE_AMP_MG_SHIELDHP_BONUS); // bonus is on top of conventional
			return true;
		case 'MIND_MERGE_AMP_BM_TOTAL_WILL':
			Outstring = string(class'X2Ability_PerkPackAbilitySet'.default.MIND_MERGE_AMP_BM_WILL_BONUS);
			return true;
		case 'MIND_MERGE_AMP_BM_TOTAL_CRIT':
			Outstring = string(class'X2Ability_PerkPackAbilitySet'.default.MIND_MERGE_AMP_BM_CRIT_BONUS);
			return true;
		case 'MIND_MERGE_AMP_BM_TOTAL_SHIELDHP':
			Outstring = string(1 + class'X2Ability_PerkPackAbilitySet'.default.MIND_MERGE_AMP_BM_SHIELDHP_BONUS); // bonus is on top of conventional
			return true;
		case 'MOVING_TARGET_DEFENSE':
			Outstring = string(class'X2Ability_XMBPerkAbilitySet'.default.MOVING_TARGET_DEFENSE);
			return true;
		case 'MOVING_TARGET_DODGE':
			Outstring = string(class'X2Ability_XMBPerkAbilitySet'.default.MOVING_TARGET_DODGE);
			return true;
		case 'HERO_SLAYER_DMG':
			Outstring = string(int(class'X2Ability_XMBPerkAbilitySet'.default.HERO_SLAYER_DMG * 100));
			return true;
		case 'PSYCHOTIC_RAGE_BELOW_THRESHOLD':
			Outstring = string(class'X2Ability_XMBPerkAbilitySet'.default.PSYCHOTIC_RAGE_BELOW_THRESHOLD);
			return true;
		case 'PSYCHOTIC_RAGE_DMG_BONUS':
			Outstring = string(class'X2Ability_XMBPerkAbilitySet'.default.PSYCHOTIC_RAGE_DMG_BONUS);
			return true;
		case 'ADVANCED_LOGIC_HACK_BONUS':
			Outstring = string(class'X2Ability_PerkPackAbilitySet2'.default.ADVANCED_LOGIC_HACK_BONUS);
			return true;
		case 'SACRIFICE_COOLDOWN':
			OutString = string(class'X2Ability_SparkAbilitySet'.default.SACRIFICE_COOLDOWN);
			return true;
		case 'NEUTRALIZE_COOLDOWN':
			Outstring = string(class'X2Ability_PerkPackAbilitySet2'.default.NEUTRALIZE_COOLDOWN);
			return true;
		case 'SHELLSHOCK_AIM_REDUCTION':
			Outstring = string(class'X2Ability_PerkPackAbilitySet2'.default.SHELLSHOCK_AIM_REDUCTION);
			return true;
		case 'SHELLSHOCK_CRIT_CHANCE_REDUCTION':
			Outstring = string(class'X2Ability_PerkPackAbilitySet2'.default.SHELLSHOCK_CRIT_CHANCE_REDUCTION);
			return true;
		case 'SHELLSHOCK_TURNS':
			Outstring = string(class'X2Ability_PerkPackAbilitySet2'.default.SHELLSHOCK_TURNS);
			return true;
		case 'SHOCKWAVE_DEF_REDUCTION':
			Outstring = string(class'X2Ability_PerkPackAbilitySet2'.default.SHOCKWAVE_DEF_REDUCTION);
			return true;
		case 'SHOCKWAVE_DODGE_REDUCTION':
			Outstring = string(class'X2Ability_PerkPackAbilitySet2'.default.SHOCKWAVE_DODGE_REDUCTION);
			return true;
		case 'SHOCKWAVE_TURNS':
			Outstring = string(class'X2Ability_PerkPackAbilitySet2'.default.SHOCKWAVE_TURNS);
			return true;
				
        default:
            return false;
    }
    return false;
}

static function X2ItemTemplate GetItemBoundToAbilityFromUnit(XComGameState_Unit UnitState, name AbilityName, XComGameState GameState)
{
	local SCATProgression Progression;

	Progression = UnitState.GetSCATProgressionForAbility(AbilityName);
	if (Progression.iRank == INDEX_NONE || Progression.iBranch == INDEX_NONE)
		return none;

	return UnitState.GetItemInSlot(
		UnitState.AbilityTree[Progression.iRank].Abilities[Progression.iBranch].ApplyToWeaponSlot,
		GameState).GetMyTemplate();
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
