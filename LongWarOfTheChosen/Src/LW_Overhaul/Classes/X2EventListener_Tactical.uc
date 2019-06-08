// X2EventListener_Tactical.uc
// 
// A listener template that allows LW2 to override game behaviour related to
// tactical missions. It's a dumping ground for tactical stuff that doesn't
// fit with more specific listener classes.
//
class X2EventListener_Tactical extends X2EventListener config(LW_Overhaul);

var config int LISTENER_PRIORITY;
var config array<float> SOUND_RANGE_DIFFICULTY_MODIFIER;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateEvacListeners());
	Templates.AddItem(CreateYellowAlertListeners());

	return Templates;
}

static function CHEventListenerTemplate CreateEvacListeners()
{
	local CHEventListenerTemplate Template;
	
	`LWTrace("Registering evac event listeners");

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'EvacListeners');
	Template.AddCHEvent('GetEvacPlacementDelay', OnPlacedDelayedEvacZone, ELD_Immediate, GetListenerPriority());
	Template.RegisterInTactical = true;

	return Template;
}

static function CHEventListenerTemplate CreateYellowAlertListeners()
{
	local CHEventListenerTemplate Template;
	
	`LWTrace("Registering evac event listeners");

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'YellowAlertListeners');
	Template.AddCHEvent('OverrideSoundRange', OnOverrideSoundRange, ELD_Immediate, GetListenerPriority());
	Template.AddCHEvent('OverrideSeesAlertedAllies', DisableSeesAlertedAlliesAlert, ELD_Immediate, GetListenerPriority());
	Template.AddCHEvent('ScamperBegin', OnScamperBegin, ELD_Immediate);
	Template.AddCHEvent('UnitTakeEffectDamage', OnUnitTookDamage, ELD_OnStateSubmitted);
	Template.AddCHEvent('OverrideAllowedAlertCause', OnOverrideAllowedAlertCause, ELD_Immediate);
	
	Template.RegisterInTactical = true;

	return Template;
}

static protected function int GetListenerPriority()
{
	return default.LISTENER_PRIORITY != -1 ? default.LISTENER_PRIORITY : class'XComGameState_LWListenerManager'.default.DEFAULT_LISTENER_PRIORITY;
}

// Handles modification of the evac timer based on various conditions, such as
// infiltration percentage, squad size, etc.
static function EventListenerReturn OnPlacedDelayedEvacZone(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComLWTuple EvacDelayTuple;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_LWSquadManager SquadMgr;
	local XComGameState_LWPersistentSquad Squad;
	local XComGameState_MissionSite MissionState;
	local XComGameState_LWAlienActivity CurrentActivity;

	EvacDelayTuple = XComLWTuple(EventData);
	if(EvacDelayTuple == none)
		return ELR_NoInterrupt;

	if(EvacDelayTuple.Id != 'DelayedEvacTurns')
		return ELR_NoInterrupt;

	if(EvacDelayTuple.Data[0].Kind != XComLWTVInt)
		return ELR_NoInterrupt;

	XComHQ = `XCOMHQ;
	SquadMgr = class'XComGameState_LWSquadManager'.static.GetSquadManager();
	if(SquadMgr == none)
		return ELR_NoInterrupt;

	Squad = SquadMgr.GetSquadOnMission(XComHQ.MissionRef);

	`LWTRACE("**** Evac Delay Calculations ****");
	`LWTRACE("Base Delay : " $ EvacDelayTuple.Data[0].i);

	// adjustments based on squad size
	EvacDelayTuple.Data[0].i += Squad.EvacDelayModifier_SquadSize();
	`LWTRACE("After Squadsize Adjustment : " $ EvacDelayTuple.Data[0].i);

	// adjustments based on infiltration
	EvacDelayTuple.Data[0].i += Squad.EvacDelayModifier_Infiltration();
	`LWTRACE("After Infiltration Adjustment : " $ EvacDelayTuple.Data[0].i);

	// adjustments based on number of active missions engaged with
	EvacDelayTuple.Data[0].i += Squad.EvacDelayModifier_Missions();
	`LWTRACE("After NumMissions Adjustment : " $ EvacDelayTuple.Data[0].i);

	MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(`XCOMHQ.MissionRef.ObjectID));
	CurrentActivity = class'XComGameState_LWAlienActivityManager'.static.FindAlienActivityByMission(MissionState);

	EvacDelayTuple.Data[0].i += CurrentActivity.GetMyTemplate().MissionTree[CurrentActivity.CurrentMissionLevel].EvacModifier;

	`LWTRACE("After Activity Adjustment : " $ EvacDelayTuple.Data[0].i);
	
	return ELR_NoInterrupt;

}

static function EventListenerReturn OnOverrideSoundRange(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComLWTuple Tuple;
	local XComGameState_Item WeaponState;
	local XComGameState_Ability ActivatedAbilityState;
	local int SoundRange;

	Tuple = XComLWTuple(EventData);
	if (Tuple == none)
		return ELR_NoInterrupt;

	if (Tuple.Id != 'OverrideSoundRange')
		return ELR_NoInterrupt;

	WeaponState = XComGameState_Item(Tuple.Data[1].o);
	if (WeaponState == None)
	{
		`REDSCREEN("Invalid item state passed to OnOverrideSoundRange");
		return ELR_NoInterrupt;
	}

	ActivatedAbilityState = XComGameState_Ability(Tuple.Data[2].o);
	if (ActivatedAbilityState == None)
	{
		`REDSCREEN("Invalid ability state passed to OnOverrideSoundRange");
		return ELR_NoInterrupt;
	}

	SoundRange = Tuple.Data[3].i;

	// If the sound comes from ammo, like a grenade fired from a grenade launcher, use
	// the ammo's sound range instead of the weapon's.
	if (!WeaponState.SoundOriginatesFromOwnerLocation() && ActivatedAbilityState.GetSourceAmmo() != None)
	{
		SoundRange = ActivatedAbilityState.GetSourceAmmo().GetItemSoundRange();
	}
	
	// Apply any sound range modifiers, like those provided by suppressors.
	SoundRange += ModifySoundRange(WeaponState, ActivatedAbilityState);
	Tuple.Data[3].i = SoundRange;

	return ELR_NoInterrupt;
}
	
static function EventListenerReturn DisableSeesAlertedAlliesAlert(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComLWTuple Tuple;

	Tuple = XComLWTuple(EventData);
	if (Tuple == none)
		return ELR_NoInterrupt;

	if (Tuple.Id != 'OverrideSeesAlertedAllies')
		return ELR_NoInterrupt;

	// Copying original LW2 behaviour for now, which is to disable this alert
	// when yellow alert is enabled.
	Tuple.Data[2].i = eAC_None;
	return ELR_NoInterrupt;
}

// Add extra actions to eligible green- and yellow-alert units.
static function EventListenerReturn OnScamperBegin(
	Object EventData,
	Object EventSource,
	XComGameState NewGameState,
	Name InEventID,
	Object CallbackData)
{
	local array<int> AlivePodMembers;
	local XComGameState_Unit PodLeaderUnit;
	local XComGameState_Unit PreviousUnit;
	local XComGameState_Unit PodMember;
	local XComGameStateHistory History;
	local XComGameState_AIGroup Group;
	local bool IsYellow;
	local float Chance;
	local UnitValue Value;
	local XComGameState_MissionSite			MissionSite;
	local XComGameState_LWPersistentSquad	SquadState;
	local XComGameState_BattleData			BattleData;
	local int i, NumSuccessfulReflexActions, UnitID;

	History = `XCOMHISTORY;
	Group = XComGameState_AIGroup(EventSource);
	if (Group == none)
	{
		`REDSCREEN("Event source for 'ScamperBegin' is not an XCGS_AIGroup");
	}

	// Start by getting hold of the members of the pod that are currently
	// alive + the leader.
	Group.GetLivingMembers(AlivePodMembers);
	PodLeaderUnit = XComGameState_Unit(History.GetGameStateForObjectID(AlivePodMembers[0]));

	`LWTrace(GetFuncName() $ ": Processing reflex move for pod leader " $ PodLeaderUnit.GetMyTemplateName());

	// LWOTC: This note is from original LW2. I don't know if the assumptions and reasoning
	// still hold with WOTC.
	//
	// Note: We don't currently support reflex actions on XCOM's turn. Doing so requires
	// adjustments to how scampers are processed so the units would use their extra action
	// point. Also note that giving units a reflex action point while it's not their turn
	// can break stun animations unless those action points are used: see X2Effect_Stunned
	// where action points are only removed if it's the units turn, and the effect actions
	// (including the stunned idle anim override) are only visualized if the unit has no
	// action points left. If the unit has stray reflex actions they haven't used they
	// will stand back up and perform the normal idle animation (although they are still
	// stunned and won't act).
	if (PodLeaderUnit.ControllingPlayer != `TACTICALRULES.GetCachedUnitActionPlayerRef())
	{
		`LWTrace(GetFuncName() $ ": Not the alien turn: aborting");
		return ELR_NoInterrupt;
	}

	if (PodLeaderUnit.GetCurrentStat(eStat_AlertLevel) <= 1)
	{
		// This unit isn't in red alert. If a scampering unit is not in red, this generally means they're a reinforcement
		// pod. Skip them.
		`LWTrace(GetFuncName() $ ": Reinforcement unit: aborting");
		return ELR_NoInterrupt;
	}

	// Look for the special 'NoReflexAction' unit value. If present, this unit isn't allowed to take an action.
	// This is typically set on reinforcements on the turn they spawn. But if they spawn out of LoS they are
	// eligible, just like any other yellow unit, on subsequent turns. Both this check and the one above are needed.
	PodLeaderUnit.GetUnitValue(class'Utilities_LW'.const.NoReflexActionUnitValue, Value);
 	if (Value.fValue == 1)
	{
		`LWTrace(GetFuncName() $ ": Unit with no reflex action value: aborting");
		return ELR_NoInterrupt;
	}

	// Walk backwards through history for this unit until we find a state in which this unit wasn't in red
	// alert to see if we entered from yellow or from green.
	PreviousUnit = PodLeaderUnit;
	while (PreviousUnit != none && PreviousUnit.GetCurrentStat(eStat_AlertLevel) > 1)
	{
		PreviousUnit = XComGameState_Unit(History.GetPreviousGameStateForObject(PreviousUnit));
	}

	IsYellow = PreviousUnit != none && PreviousUnit.GetCurrentStat(eStat_AlertLevel) == 1;
	Chance = IsYellow ? class'Utilities_LW'.default.REFLEX_ACTION_CHANCE_YELLOW[`TACTICALDIFFICULTYSETTING]
			 : class'Utilities_LW'.default.REFLEX_ACTION_CHANCE_GREEN[`TACTICALDIFFICULTYSETTING];

	// if is infiltration mission, get infiltration % and modify yellow and green alert chances by how much you missed 100%, diff modifier, positive boolean
	BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	MissionSite = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(BattleData.m_iMissionID));

	// Infiltration modifier
	if (`LWSQUADMGR.IsValidInfiltrationMission(MissionSite.GetReference()))
	{
		SquadState = `LWSQUADMGR.GetSquadOnMission(MissionSite.GetReference());
		if (SquadState.CurrentInfiltration <= 1)
		{
			Chance += (1.0 - SquadState.CurrentInfiltration) * class'Utilities_LW'.default.LOW_INFILTRATION_MODIFIER_ON_REFLEX_ACTIONS[`TACTICALDIFFICULTYSETTING];
		}
		else
		{
			Chance -= (SquadState.CurrentInfiltration - 1.0) * class'Utilities_LW'.default.HIGH_INFILTRATION_MODIFIER_ON_REFLEX_ACTIONS[`TACTICALDIFFICULTYSETTING];
		}
	}

	NumSuccessfulReflexActions = 0;
	for (i = 0; i < AlivePodMembers.Length; ++i)
	{
		PodMember = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', AlivePodMembers[i]));
		NumSuccessfulReflexActions += ProcessReflexActionsForUnit(
			PodMember,
			IsYellow,
			Chance,
			NumSuccessfulReflexActions);
	}

	return ELR_NoInterrupt;
}

static function EventListenerReturn OnUnitTookDamage(
	Object EventData,
	Object EventSource,
	XComGameState GameState,
	Name InEventID,
	Object CallbackData)
{
	local XComGameState_Unit Unit;
	local XComGameState NewGameState;

	Unit = XComGameState_Unit(EventSource);
	if (Unit.ControllingPlayerIsAI() &&
		Unit.IsInjured() &&
		`BEHAVIORTREEMGR.IsScampering() &&
		Unit.ActionPoints.Find(class'Utilities_LW'.const.OffensiveReflexAction) >= 0)
	{
		// This unit has taken damage, is scampering, and has an 'offensive' reflex action point. Replace it with
		// a defensive action point.
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Replacing reflex action for injured unit");
		Unit = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', Unit.ObjectID));
		Unit.ActionPoints.RemoveItem(class'Utilities_LW'.const.OffensiveReflexAction);
		Unit.ActionPoints.AddItem(class'Utilities_LW'.const.DefensiveReflexAction);
		`TACTICALRULES.SubmitGameState(NewGameState);
	}

	return ELR_NoInterrupt;
}

static function EventListenerReturn OnOverrideAllowedAlertCause(
	Object EventData,
	Object EventSource,
	XComGameState NewGameState,
	Name InEventID,
	Object CallbackData)
{
	local XComLWTuple Tuple;
	local EAlertCause AlertCause;
	local XComLWTValue Value;

	Tuple = XComLWTuple(EventData);
	if (Tuple == none)
		return ELR_NoInterrupt;

	// Sanity check. This should not happen.
	if (Tuple.Id != 'OverrideAllowedAlertCause')
	{
		`REDSCREEN("Received unexpected event ID in OnOverrideAllowedAlertCause() event handler");
		return ELR_NoInterrupt;
	}

	if (class'Helpers_LW'.static.YellowAlertEnabled())
	{
		AlertCause = EAlertCause(Tuple.Data[0].i);
		switch (AlertCause)
		{
			case eAC_DetectedSound:
			case eAC_DetectedAllyTakingDamage:
			case eAC_DetectedNewCorpse:
			case eAC_SeesExplosion:
			case eAC_SeesSmoke:
			case eAC_SeesFire:
			case eAC_AlertedByYell:
				Tuple.Data[1].b = true;
				break;

			default:
				break;
		}
	}

	return ELR_NoInterrupt;
}

// Returns a modifier that should be applied to the sound range for a weapon/ability combo
//
// Implementation copied from X2DLCInfo_LW_Overhaul in the original LW2.
static function int ModifySoundRange(XComGameState_Item Weapon, XComGameState_Ability Ability)
{
	local array<X2WeaponUpgradeTemplate> WeaponUpgrades;
	local float SoundRangeModifier;
	local int k;
	local X2WeaponTemplate WeaponTemplate;
	local X2MultiWeaponTemplate MultiWeaponTemplate;
	local X2AbilityTemplate AbilityTemplate;
	local X2Effect AbilityEffect;
	local bool UseAltWeaponSoundRange;

	SoundRangeModifier = 0.0;
	WeaponTemplate = X2WeaponTemplate(Weapon.GetMyTemplate());

	// Is it a multiweapon?
	MultiWeaponTemplate = X2MultiWeaponTemplate(WeaponTemplate);

	if (MultiWeaponTemplate != none)
	{
		AbilityTemplate = Ability.GetMyTemplate();
		foreach AbilityTemplate.AbilityTargetEffects(AbilityEffect)
		{
			if (AbilityEffect.IsA('X2Effect_ApplyAltWeaponDamage'))
			{
				UseAltWeaponSoundRange = true;
				break;
			}
		}

		foreach AbilityTemplate.AbilityMultiTargetEffects(AbilityEffect)
		{
			if (AbilityEffect.IsA('X2Effect_ApplyAltWeaponDamage'))
			{
				UseAltWeaponSoundRange = true;
				break;
			}
		}

		if (UseAltWeaponSoundRange)
		{
			// This ability is using the secondary effect of a multi-weapon. We need to apply a mod to use the alt sound
			// range in place of the primary range.
			SoundRangeModifier += (MultiWeaponTemplate.iAltSoundRange - MultiWeaponTemplate.iSoundRange);
		}
	}

	if (WeaponTemplate != none)
	{
		WeaponUpgrades = Weapon.GetMyWeaponUpgradeTemplates();
		for (k = 0; k < WeaponUpgrades.Length; k++)
		{
			switch (WeaponUpgrades[k].DataName)
			{
				case 'FreeKillUpgrade_Bsc':
					SoundRangeModifier = -class'X2Item_DefaultWeaponMods_LW'.default.BASIC_SUPPRESSOR_SOUND_REDUCTION_METERS;
					break;
				case 'FreeKillUpgrade_Adv':
					SoundRangeModifier = -class'X2Item_DefaultWeaponMods_LW'.default.ADVANCED_SUPPRESSOR_SOUND_REDUCTION_METERS;
					break;
				case 'FreeKillUpgrade_Sup':
					SoundRangeModifier = -class'X2Item_DefaultWeaponMods_LW'.default.ELITE_SUPPRESSOR_SOUND_REDUCTION_METERS;
					break;
				default: break;
			}
		}
	}

	SoundRangeModifier += default.SOUND_RANGE_DIFFICULTY_MODIFIER[`TACTICALDIFFICULTYSETTING];

	return int (FMax (SoundRangeModifier, 0.0));
}

static function int ProcessReflexActionsForUnit(
	XComGameState_Unit Unit,
	bool IsYellowAlert,
	float Chance,
	int NumSuccessfulReflexActions)
{
	if (class'Utilities_LW'.default.REFLEX_ACTION_CHANCE_REDUCTION > 0 && NumSuccessfulReflexActions > 0)
	{
		`LWTrace(GetFuncName() $ ": Reducing reflex chance due to " $ NumSuccessfulReflexActions $ " successes");
		Chance -= NumSuccessfulReflexActions * class'Utilities_LW'.default.REFLEX_ACTION_CHANCE_REDUCTION;
	}

	if (`SYNC_FRAND_STATIC() < Chance)
	{
		`LWTrace(GetFuncName() $ ": Awarding an extra action point to unit " $ Unit.GetMyTemplateName());
		// Award the unit a special kind of action point. These are more restricted than standard action points.
		// See the 'OffensiveReflexAbilities' and 'DefensiveReflexAbilities' arrays in LW_Overhaul.ini for the list
		// of abilities that have been modified to allow these action points.
		//
		// Damaged units, and units in green (if enabled) get 'defensive' action points. Others get 'offensive' action points.
		if (Unit.IsInjured() || !IsYellowAlert)
		{
			Unit.ActionPoints.AddItem(class'Utilities_LW'.const.DefensiveReflexAction);
		}
		else
		{
			Unit.ActionPoints.AddItem(class'Utilities_LW'.const.OffensiveReflexAction);
		}

		return 1;
	}
	else
	{
		return 0;
	}
}
