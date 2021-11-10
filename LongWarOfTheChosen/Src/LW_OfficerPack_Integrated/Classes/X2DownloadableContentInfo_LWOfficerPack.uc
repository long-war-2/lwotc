//---------------------------------------------------------------------------------------
//  FILE:    X2DownloadableContentInfo_LWOfficerPack.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Initializes Officer mod settings on campaign start or when loading campaign without mod previously active
//--------------------------------------------------------------------------------------- 

class X2DownloadableContentInfo_LWOfficerPack extends X2DownloadableContentInfo;	

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{
	`Log("LW OfficerPack : Starting OnLoadedSavedGame");
	UpdateOTSFacility();
}

static event OnPostTemplatesCreated()
{
	local X2FacilityTemplate FacilityTemplate;
	local array<X2FacilityTemplate> FacilityTemplates;
	local StaffSlotDefinition StaffSlotDef;
	`Log(">>>> LWOfficerPack OnPostTemplates");

	// ***  OFFICER TRAINING SCHOOL *** //
	FindFacilityTemplateAllDifficulties('OfficerTrainingSchool', FacilityTemplates);
	foreach FacilityTemplates(FacilityTemplate)
	{
		StaffSlotDef.StaffSlotTemplateName = 'OTSStaffSlot';
		StaffSlotDef.bStartsLocked = false;
		FacilityTemplate.StaffSlotDefs.AddItem(StaffSlotDef);

		StaffSlotDef.StaffSlotTemplateName = 'OTSOfficerSlot';
		StaffSlotDef.bStartsLocked = true;
		FacilityTemplate.StaffSlotDefs.AddItem(StaffSlotDef);
		FacilityTemplate.StaffSlotDefs.AddItem(StaffSlotDef);
		`log("LW OfficerPack: Added OTSOfficerSlot to facility template OfficerTrainingSchool");

		FacilityTemplate.Upgrades.AddItem('OTS_LWOfficerTrainingUpgrade');
		`log("LW OfficerPack: Added OTS Facility upgrade to facility template OfficerTrainingSchool");

		FacilityTemplate.Upgrades.AddItem('OTS_LWOfficerTrainingUpgrade_SecondSlot');
		`log("LW OfficerPack: Added OTS Facility upgrade to facility template OfficerTrainingSchool");
	}
	`LOG("LW OfficerPack : Update OTS Templates");
}

//retrieves all difficulty variants of a given facility template
static function FindFacilityTemplateAllDifficulties(name DataName, out array<X2FacilityTemplate> FacilityTemplates, optional X2StrategyElementTemplateManager StrategyTemplateMgr)
{
	local array<X2DataTemplate> DataTemplates;
	local X2DataTemplate DataTemplate;
	local X2FacilityTemplate FacilityTemplate;

	if(StrategyTemplateMgr == none)
	{ 
		StrategyTemplateMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	}

	StrategyTemplateMgr.FindDataTemplateAllDifficulties(DataName, DataTemplates);
	FacilityTemplates.Length = 0;
	foreach DataTemplates(DataTemplate)
	{
		FacilityTemplate = X2FacilityTemplate(DataTemplate);
		if( FacilityTemplate != none )
		{
			FacilityTemplates.AddItem(FacilityTemplate);
		}
	}
}

/// <summary>
/// This method is run when the player loads a saved game directly into Strategy while this DLC is installed
/// </summary>
static event OnLoadedSavedGameToStrategy()
{
	UpdateOTSFacility();
	TransferLegacyOfficerAbilities();
}

//transfer any legacy officer abilities from AWCAbilities into officer state
static function TransferLegacyOfficerAbilities()
{
	local XComGameStateHistory History;
	local XComGameState_Unit UnitState, UpdatedUnit;
	local XComGameState_Unit_LWOfficer OfficerState, UpdatedOfficer;
	local ClassAgnosticAbility Ability;
	local XComGameState NewGameState;

	History = `XCOMHISTORY;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Transfer Officer Abilities");

	foreach History.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		if (!UnitState.IsSoldier())
			continue;

		OfficerState = class'LWOfficerUtilities'.static.GetOfficerComponent(UnitState);
		if (OfficerState == none)
			continue;
	
		if (UnitState.AWCAbilities.Length == 0)
			continue;

		foreach UnitState.AWCAbilities(Ability)
		{
			if (class'LWOfficerUtilities'.default.OfficerAbilityTree.Find('AbilityName', Ability.AbilityType.AbilityName) != -1)
			{
				UpdatedOfficer = XComGameState_Unit_LWOfficer(NewGameState.CreateStateObject(class'XComGameState_Unit_LWOfficer', OfficerState.ObjectID));
				NewGameState.AddStateObject(UpdatedOfficer);
				UpdatedOfficer.OfficerAbilities.AddItem(Ability);

				UpdatedUnit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', UnitState.ObjectID));
				NewGameState.AddStateObject(UpdatedUnit);
				UpdatedUnit.AWCAbilities.RemoveItem(Ability);
			}
		}
	}

	if(NewGameState.GetNumGameStateObjects() > 0)
		`GAMERULES.SubmitGameState(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);
}

// update OTS Facility data
static event OnPostMission()
{
	UpdateOTSFacility();
	UpdateScavengerRewards();
	TransferLegacyOfficerAbilities();
}

static function ModifyEarnedSoldierAbilities(out array<SoldierClassAbilityType> EarnedAbilities, XComGameState_Unit UnitState)
{
	local XComGameState_Unit_LWOfficer OfficerState;
	local ClassAgnosticAbility Ability;
	local string CallStack;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameStateHistory History;
	local StateObjectReference UnitRef;
	local bool OfficerAlreadyPresent;
	local XComGameState_Unit UnitStateOtherSoldier;

	if(UnitState == none)
	{
		`REDSCREEN("ModifyEarnedSoldierAbilities called with none unit.");
		return;
	}

	OfficerAlreadyPresent = false;

	// don't add for non-commanding officers when called from GatherUnitAbilitiesForInit -- ID 1673
	CallStack = GetScriptTrace();
	if (InStr(CallStack, "GatherUnitAbilitiesForInit") != -1)
	{
		if (!class'LWOfficerUtilities'.static.IsHighestRankOfficerInSquad(UnitState))  // only add abilities for highest rank officer
		{
			return;
		}
		
		//If there is already a unit with the officer abilities present, then that means current unit is later deployed one (e.g. Avenger Defense reinforcements, liaisons, covert ops).
		//In that case, adding officer abilites to this unit would lead to two officers present in the mission.
		//Rather than removing abilities from previous lower-ranked officer, we are not making this unit officer instead. 
		XComHQ = `XCOMHQ;
		History = `XCOMHISTORY;
		
		if (XComHQ != none) {			
			foreach XComHQ.Squad(UnitRef)
			{
				UnitStateOtherSoldier = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));
				if (UnitStateOtherSoldier != none)
				{
					if (UnitState.ObjectID == UnitStateOtherSoldier.ObjectID)
					{
						continue;
					}
					if (UnitStateOtherSoldier.FindAbility(class'LWOfficerUtilities'.static.GetAbilityName(0, 0)).ObjectID > 0) {// this should generally be the command ability
						OfficerAlreadyPresent = true;
						break;
					}					
				}
			}
		}		
	}

	// add all earned officer abilities as EarnedSoldierAbilities
	OfficerState = class'LWOfficerUtilities'.static.GetOfficerComponent(UnitState);
	if (OfficerState != none && !OfficerAlreadyPresent)
	{
		//add the rank 0 starter abilities so they show up in right-hand panels
		foreach OfficerState.OfficerAbilities(Ability)
		{
			EarnedAbilities.AddItem(Ability.AbilityType);
		}	
	}
}

// Use SLG hook to add officer abilities from officer component
static function FinalizeUnitAbilitiesForInit(XComGameState_Unit UnitState, out array<AbilitySetupData> SetupData, optional XComGameState StartState, optional XComGameState_Player PlayerState, optional bool bMultiplayerDisplay)
{
	local array<AbilitySetupData> arrData;
	local array<AbilitySetupData> arrAdditional;
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityTemplateManager AbilityTemplateMan;
	local XComGameState_Unit_LWOfficer OfficerState;
	local int i;
	local name AbilityName;
	local AbilitySetupData Data, EmptyData;
	local array<SoldierClassAbilityType> EarnedOfficerAbilities;

	return; // DEPRECATED

	OfficerState = class'LWOfficerUtilities'.static.GetOfficerComponent(UnitState);
	if (OfficerState == none)
		return;

	if (!class'LWOfficerUtilities'.static.IsHighestRankOfficerInSquad(UnitState))  // only add abilities for highest rank officer
		return;

	AbilityTemplateMan = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	//retrieve the officer abilities from the officer state
	for(i = 0; i < OfficerState.OfficerAbilities.Length; ++i)
	{
		EarnedOfficerAbilities.AddItem(OfficerState.OfficerAbilities[i].AbilityType);
	}

	//add the officer abilities
	for (i = 0; i < EarnedOfficerAbilities.Length; ++i)
	{
		AbilityName = EarnedOfficerAbilities[i].AbilityName;
		AbilityTemplate = AbilityTemplateMan.FindAbilityTemplate(AbilityName);
		if (AbilityTemplate != none && !AbilityTemplate.bUniqueSource || arrData.Find('TemplateName', AbilityTemplate.DataName) == INDEX_NONE)
		{
			Data = EmptyData;
			Data.TemplateName = AbilityName;
			Data.Template = AbilityTemplate;
			arrData.AddItem(Data); // array used to check for additional abilities
			SetupData.AddItem(Data);  // return array
		}
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

// update mission rewards for scavenger ability
static function UpdateScavengerRewards()
{
	local int idx, Bonus;
	local StateObjectReference UnitRef;
	local XComGameState_Unit UnitState;
	local XComGameState_Unit_LWOfficer OfficerState;
	local bool bHasScavenger;
	local XComGameStateHistory History;
	local XComGameStateContext_ChangeContainer ChangeContainer;
	local XComGameState UpdateState;
	local XComGameState_MissionSite MissionState;
	local XComGameState_Reward RewardState, UpdatedReward;

	History = `XCOMHISTORY;

	foreach `XCOMHQ.Squad(UnitRef)
	{
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));

		//requires unit to be alive and conscious
		if (UnitState == none || UnitState.IsDead() || UnitState.IsUnconscious() || !UnitState.IsSoldier())
			continue;

		OfficerState = class'LWOfficerUtilities'.static.GetOfficerComponent(UnitState);
		if (OfficerState == none)
			continue;

		if (OfficerState.HasOfficerAbility('Scavenger'))
		{
			bHasScavenger = true;
			break;
		}
	}
	if(!bHasScavenger)
		return;

	//requires all objectives complete
	if(!XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData')).AllStrategyObjectivesCompleted() )
		return;

	MissionState = XComGameState_MissionSite(History.GetGameStateForObjectID(`XCOMHQ.MissionRef.ObjectID));
	ChangeContainer = class'XComGameStateContext_ChangeContainer'.static.CreateEmptyChangeContainer("Scavenger Reward Added");
	UpdateState = History.CreateNewGameState(true, ChangeContainer);

	for(idx = 0; idx < MissionState.Rewards.Length; idx++)
	{
		RewardState = XComGameState_Reward(History.GetGameStateForObjectID(MissionState.Rewards[idx].ObjectID));
		UpdatedReward = XComGameState_Reward(UpdateState.CreateStateObject(class'XComGameState_Reward', RewardState.ObjectID));

		switch(RewardState.GetMyTemplateName()) 
		{
			case 'Reward_Supplies': 
			case 'Reward_Alloys': 
			case 'Reward_Elerium': 
				Bonus = RewardState.Quantity;
				Bonus *= class'X2Effect_Scavenger'.default.SCAVENGER_BONUS_MULTIPLIER;
				UpdatedReward.Quantity += Max(1, Bonus);
				UpdateState.AddStateObject(UpdatedReward);
				`log("LW Officer Ability (Scavenger): RewardType=" $ RewardState.GetMyTemplateName() $ ", Amount=" $ Bonus);
				break;
			default:
				break;
		}
	}
	if(UpdateState.GetNumGameStateObjects() > 0)
		`GAMERULES.SubmitGameState(UpdateState);
	else
		History.CleanupPendingGameState(UpdateState);
}

// ******** HANDLE UPDATING OTS FACILITY ************* //
// This handles updating the OTS facility, in case facility is already built or is being built
// Upgrades are dynamically pulled from templates even for already-completed facilities, so don't have to be updated
static function UpdateOTSFacility()
{
	local XComGameState NewGameState;
	local XComGameStateHistory History;
	local name TemplateName;
	local XComGameState_FacilityXCom FacilityState, OTSState;

	`Log("LW OfficerPack : Searching for existing OTS Facility");
	TemplateName = 'OfficerTrainingSchool';
	History = `XCOMHISTORY;
	foreach History.IterateByClassType(class'XComGameState_FacilityXCom', FacilityState)
	{
		if( FacilityState.GetMyTemplateName() == TemplateName )
		{
			OTSState = FacilityState; 
			break;
		}
	}

	if(OTSState == none) 
	{
		`log("LW OfficerPack: No existing OTS facility, update aborted");
		return;
	}

	`Log("LW OfficerPack: Found existing OTS, Attempting to update StaffSlots");
	if(OTSState.StaffSlots.Length == 1)
	{
		`log("LW OfficerPack: OTS had only single staff slot, attempting to update facility"); 
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Updating OTS Facility for LW_OfficerPack");
		CreateStaffSlots(OTSState, NewGameState);
		NewGameState.AddStateObject(OTSState);
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
}


//---------------------------------------------------------------------------------------
static function CreateStaffSlots(XComGameState_FacilityXCom FacilityState, XComGameState NewGameState)
{
	local X2FacilityTemplate FacilityTemplate;
	local X2StaffSlotTemplate StaffSlotTemplate;
	local XComGameState_StaffSlot StaffSlotState;
	local int i;
	
	FacilityTemplate = FacilityState.GetMyTemplate();

	for (i = FacilityState.StaffSlots.Length ; i < FacilityTemplate.StaffSlotDefs.Length; i++)
	{
		StaffSlotTemplate = X2StaffSlotTemplate(class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager().FindStrategyElementTemplate(FacilityTemplate.StaffSlotDefs[i].StaffSlotTemplateName));

		if (StaffSlotTemplate != none)
		{
			StaffSlotState = StaffSlotTemplate.CreateInstanceFromTemplate(NewGameState);
			StaffSlotState.Facility = FacilityState.GetReference(); //make sure the staff slot knows what facility it is in
			if (FacilityTemplate.StaffSlotDefs[i].bStartsLocked)
			{
				StaffSlotState.LockSlot();
			}
			
			NewGameState.AddStateObject(StaffSlotState);

			FacilityState.StaffSlots.AddItem(StaffSlotState.GetReference());
		}
	}
}

static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
    local name Type;

    Type = name(InString);
    switch(Type)
    {
        case 'AIR_CONTROLLER_EVAC_TURN_REDUCTION':
			OutString = string(class'X2Ability_OfficerAbilitySet'.default.AIR_CONTROLLER_EVAC_TURN_REDUCTION);
            return true;
		case 'FOCUS_FIRE_AIM_BONUS':
			OutString = string(class'X2Effect_FocusFire'.default.AIMBONUSPERATTACK);
			return true;
		case 'FOCUS_FIRE_COOLDOWN':
			OutString = string(class'X2Effect_FocusFire'.default.FOCUSFIRE_COOLDOWN);
			return true;
		case 'FOCUS_FIRE_ARMORPIERCING':
			OutString = string(class'X2Effect_FocusFire'.default.ARMORPIERCINGEFFECT);
			return true;
        default:
            return false;
    }
    return ReturnValue;    
}
