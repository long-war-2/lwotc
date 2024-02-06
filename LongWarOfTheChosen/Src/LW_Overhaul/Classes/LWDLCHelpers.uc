//---------------------------------------------------------------------------------------
//  FILE:    LWDLCHelpers
//  AUTHOR:  amineri / Pavonis Interactive
//
//  PURPOSE: Helpers for interfacing with Firaxis DLC
//--------------------------------------------------------------------------------------- 

class LWDLCHelpers extends object config(LW_Overhaul);

var const array<name> AlienRulerTags;

static function bool IsAlienHuntersNarrativeEnabled()
{
    local XComGameStateHistory History;
    local XComGameState_CampaignSettings CampaignSettings;

    History = class'XComGameStateHistory'.static.GetGameStateHistory();
    CampaignSettings = XComGameState_CampaignSettings(History.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings'));
	if (CampaignSettings != none)
	    return CampaignSettings.HasOptionalNarrativeDLCEnabled('DLC_2');
	return false;
}

static function bool IsAlienHuntersNarrativeContentComplete()
{
    if(IsAlienHuntersNarrativeEnabled())
    {
        if(class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('DLC_HunterWeapons') && class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('DLC_AlienNestMissionComplete'))
        {
            return true;
        }
    }
    return false;
}

static function GetAlienHunterWeaponSpecialRequirementFunction(out delegate<X2StrategyGameRulesetDataStructures.SpecialRequirementsDelegate> ReturnRn, name ItemTemplateName)
{
	switch (ItemTemplateName)
	{
		case 'HunterRifle_MG_Schematic':
			ReturnRn = IsHunterRifleCVAvailableForUpgrade;
			break;
		case 'HunterRifle_BM_Schematic':
			ReturnRn = IsHunterRifleMGAvailableForUpgrade;
			break;
		case 'HunterPistol_MG_Schematic':
			ReturnRn = IsHunterPistolCVAvailableForUpgrade;
			break;
		case 'HunterPistol_BM_Schematic':
			ReturnRn = IsHunterPistolMGAvailableForUpgrade;
			break;
		case 'HunterAxe_MG_Schematic':
			ReturnRn = IsHunterAxeCVAvailableForUpgrade;
			break;
		case 'HunterAxe_BM_Schematic':
			ReturnRn = IsHunterAxeMGAvailableForUpgrade;
			break;
		default: 
			ReturnRn = none;
	}
}

static function bool IsHunterRifleCVAvailableForUpgrade()
{
	return IsAlienHunterWeaponAvailableForUpgrade('AlienHunterRifle_CV');
}

static function bool IsHunterRifleMGAvailableForUpgrade()
{
	return IsAlienHunterWeaponAvailableForUpgrade('AlienHunterRifle_MG');
}

static function bool IsHunterAxeCVAvailableForUpgrade()
{
	return IsAlienHunterWeaponAvailableForUpgrade('AlienHunterAxe_CV');
}

static function bool IsHunterAxeMGAvailableForUpgrade()
{
	return IsAlienHunterWeaponAvailableForUpgrade('AlienHunterAxe_MG');
}

static function bool IsHunterPistolCVAvailableForUpgrade()
{
	return IsAlienHunterWeaponAvailableForUpgrade('AlienHunterPistol_CV');
}

static function bool IsHunterPistolMGAvailableForUpgrade()
{
	return IsAlienHunterWeaponAvailableForUpgrade('AlienHunterPistol_MG');
}

static function bool IsAlienHunterWeaponAvailableForUpgrade(name ItemTemplateName)
{
	local XComGameState_Item ItemState;
	local XComGameState_Unit OwningUnit;

	ItemState = FindItem(ItemTemplateName);
	if  (ItemState == none)
		return false; // no item, so can't upgrade

	if (ItemState.OwnerStateObject.ObjectID == 0)
		return true; // no owner, so can upgrade

	OwningUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ItemState.OwnerStateObject.ObjectID));
	if (OwningUnit == none)
		return true; // no owner, so can upgrade

	if (class'LWDLCHelpers'.static.IsUnitOnMission(OwningUnit))
		return false; // owner is on mission (infiltrating or liaison), so can't upgrade

	return true; // owner is at base, so can upgrade
}

static function XComGameState_Item FindItem(name ItemTemplateName)
{
	local XComGameState_Item ItemState;

	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Item', ItemState)
	{
		if(ItemState.GetMyTemplateName() == ItemTemplateName)
		{
			return ItemState;
		}
	}
	return none;
}


static function bool IsLostTowersNarrativeEnabled()
{
    local XComGameStateHistory History;
    local XComGameState_CampaignSettings CampaignSettings;

    History = class'XComGameStateHistory'.static.GetGameStateHistory();
    CampaignSettings = XComGameState_CampaignSettings(History.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings'));
	if (CampaignSettings != none)
	    return CampaignSettings.HasOptionalNarrativeDLCEnabled('DLC_3');
	return false;
}

// Replaces X2StrategyElement_DLC_Day90Techs.static.IsMechanizedWarfareAvailable()
static function bool IsMechanizedWarfareAvailable()
{
    // We need MechanizedWarfare to be available in Integrated DLC mode. This function replaces the
	// default SpecialRequirementsFn for MechanizedWarfare from WOTC with our own, making the tree
	// function in the expected LW2 style. See also LWTemplateMods.uc for the actual replacement.
	local XComGameState_CampaignSettings CampaignSettings;

	CampaignSettings = XComGameState_CampaignSettings(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings'));

	if (CampaignSettings != none)
		return (!CampaignSettings.HasOptionalNarrativeDLCEnabled(name(class'X2DownloadableContentInfo_DLC_Day90'.default.DLCIdentifier)));
	return false;
}

static function bool IsLostTowersNarrativeContentComplete()
{
    if(IsLostTowersNarrativeEnabled())
    {
        if(class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('DLC_LostTowersMissionComplete'))
        {
            return true;
        }
    }
    return false;
}

static function bool IsAlienRuler(name CharacterTemplateName, bool HasRulerOnlyBool)
{
    switch (CharacterTemplateName)
    {
        case 'ArchonKing':
        case 'BerserkerQueen':
        case 'ViperKing':
        case 'CXQueen':
            return true;
        default:
            return HasRulerOnlyBool;
    }
}

// Checks the given mission's tactical gameplay tags to see whether
// they include one of the Alien Ruler "active" tags.
static function bool IsAlienRulerOnMission(XComGameState_MissionSite MissionState)
{
	return TagArrayHasActiveRulerTag(MissionState.TacticalGameplayTags);
}

static function bool TagArrayHasActiveRulerTag(const out array<name> TacticalGameplayTags)
{
	local name GameplayTag;

	foreach TacticalGameplayTags(GameplayTag)
	{
		if (default.AlienRulerTags.Find(GameplayTag) != INDEX_NONE)
		{
			return true;
		}
	}

	return false;
}

// Returns the unit state for whatever alien ruler is on the given
// mission. If there is no alien ruler on the mission, then this
// returns `none`.
static function XComGameState_Unit GetAlienRulerForMission(XComGameState_MissionSite MissionState)
{
	local name GameplayTag, FoundRulerTag;

	foreach MissionState.TacticalGameplayTags(GameplayTag)
	{
		if (default.AlienRulerTags.Find(GameplayTag) != INDEX_NONE)
		{
			FoundRulerTag = GameplayTag;
		}
	}

	if (FoundRulerTag == '') return none;
	else return GetAlienRulerForTacticalTag(FoundRulerTag);
}

static function XComGameState_Unit GetAlienRulerForTacticalTag(name RulerActiveTacticalTag)
{
	local XComGameState_AlienRulerManager RulerMgr;
	local XComGameState_Unit RulerState;
	local XComGameStateHistory History;
	local StateObjectReference RulerRef;
	local name RulerTemplateName;
	local int i;

	// *WARNING* Don't declare a variable of type AlienRulerData for this loop, because
	// that will crash the game if Alien Rulers DLC is not installed.
	for (i = 0; i < class'XComGameState_AlienRulerManager'.default.AlienRulerTemplates.Length; i++)
	{
		if (class'XComGameState_AlienRulerManager'.default.AlienRulerTemplates[i].ActiveTacticalTag == RulerActiveTacticalTag)
		{
			RulerTemplateName = class'XComGameState_AlienRulerManager'.default.AlienRulerTemplates[i].AlienRulerTemplateName;
			break;
		}
	}

	History = `XCOMHISTORY;
	RulerMgr = XComGameState_AlienRulerManager(History.GetSingleGameStateObjectForClass(class'XComGameState_AlienRulerManager'));
	foreach RulerMgr.AllAlienRulers(RulerRef)
	{
		RulerState = XComGameState_Unit(History.GetGameStateForObjectID(RulerRef.ObjectID));
		if (RulerState.GetMyTemplateName() == RulerTemplateName)
			break;
		else
			RulerState = none;
	}

	return RulerState;
}

// Copy of the private function SetRulerOnCurrentMission() in XCGS_AlienRulerManager
//
// Note that XComHQ and RulerMgr must both be modifiable.
//
// *WARNING* Do not call this function unless you have verified that the Alien Ruler
// DLC is installed.
static function PutRulerOnCurrentMission(XComGameState NewGameState, XComGameState_Unit UnitState, XComGameState_HeadquartersXCom XComHQ)
{
	local XComGameState_AlienRulerManager RulerMgr;
	local int RulerIndex, idx, NumAppearances, MaxNumAppearances, MaxAppearanceIndex;

	RulerMgr = XComGameState_AlienRulerManager(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_AlienRulerManager'));
	RulerMgr = XComGameState_AlienRulerManager(NewGameState.ModifyStateObject(class'XComGameState_AlienRulerManager', RulerMgr.ObjectID));

	RulerMgr.RulerOnCurrentMission = UnitState.GetReference();

	RulerIndex = class'XComGameState_AlienRulerManager'.default.AlienRulerTemplates.Find('AlienRulerTemplateName', UnitState.GetMyTemplateName());
	XComHQ.TacticalGameplayTags.AddItem(class'XComGameState_AlienRulerManager'.default.AlienRulerTemplates[RulerIndex].ActiveTacticalTag);

	// *WARNING* Don't declare a variable of type AlienRulerData for this code, because
	// that will crash the game if Alien Rulers DLC is not installed.
	//
	// Code below is slightly modified copy of XCGS_AlienRulerManager.AddRulerAdditionalTacticalTags()
	if (class'XComGameState_AlienRulerManager'.default.AlienRulerTemplates[RulerIndex].AdditionalTags.Length == 0)
	{
		return;
	}

	NumAppearances = class'X2Helpers_DLC_Day60'.static.GetRulerNumAppearances(UnitState) + 1;
	MaxNumAppearances = 0;
	MaxAppearanceIndex = 0;

	for (idx = 0; idx < class'XComGameState_AlienRulerManager'.default.AlienRulerTemplates[RulerIndex].AdditionalTags.Length; idx++)
	{
		if (NumAppearances == class'XComGameState_AlienRulerManager'.default.AlienRulerTemplates[RulerIndex].AdditionalTags[idx].NumTimesAppeared)
		{
			XComHQ.TacticalGameplayTags.AddItem(class'XComGameState_AlienRulerManager'.default.AlienRulerTemplates[RulerIndex].AdditionalTags[idx].TacticalTag);
			return;
		}

		if (class'XComGameState_AlienRulerManager'.default.AlienRulerTemplates[RulerIndex].AdditionalTags[idx].NumTimesAppeared > MaxNumAppearances)
		{
			MaxNumAppearances = class'XComGameState_AlienRulerManager'.default.AlienRulerTemplates[RulerIndex].AdditionalTags[idx].NumTimesAppeared;
			MaxAppearanceIndex = idx;
		}
	}

	if (NumAppearances >= MaxNumAppearances)
	{
		XComHQ.TacticalGameplayTags.AddItem(class'XComGameState_AlienRulerManager'.default.AlienRulerTemplates[RulerIndex].AdditionalTags[MaxAppearanceIndex].TacticalTag);
	}
}

//class'LWDLCHelpers'.static.IsUnitOnMission(UnitState)
// helper for sparks to resolve if a wounded spark is on a mission, since that status can override the OnMission one
static function bool IsUnitOnMission(XComGameState_Unit UnitState)
{
	switch (UnitState.GetMyTemplateName())
	{
		case 'SparkSoldier':
		case 'LostTowersSpark':
			//sparks can be wounded and on a mission, so instead we have to do a more brute force check of existing squads and havens
			if (UnitState.GetStatus() == eStatus_CovertAction)
			{
				return true;
			}
			if (`LWSQUADMGR.UnitIsOnMission(UnitState.GetReference()))
			{
				return true;
			}
			if (`LWOUTPOSTMGR.IsUnitAHavenLiaison(UnitState.GetReference()))
			{
				return true;
			}
			break;
		default:
			return UnitState.GetStatus() == eStatus_CovertAction;
			break;
	}
	return false;
}

//class'LWDLCHelpers'.static.SetOnMissionStatus(UnitState, NewGameState)
// helper for sparks to update healing project and staffslot
static function SetOnMissionStatus(XComGameState_Unit UnitState, XComGameState NewGameState, optional bool bClearSlot = true)
{
	local XComGameState_StaffSlot StaffSlotState;
	local XComGameState_HeadquartersProjectHealSoldier HealProject;

	if(bClearSlot)
	{//If we're here, I'm going to assume you're allowed to be on the mission already, meaning that if you're in a slot you should be removed from it.
		StaffSlotState = UnitState.GetStaffSlot();
		if(StaffSlotState != none)
		{
			StaffSlotState = XComGameState_StaffSlot(NewGameState.ModifyStateObject(class'XComGameState_StaffSlot', StaffSlotState.ObjectID));
			StaffSlotState.EmptySlot(NewGameState);
		}
	}
	// Tedster - see if commenting out this if check to always check for and pause heal projects fixes things.
	//if (UnitState.GetStatus() == eStatus_Healing)
//	{
		//and pause any healing project
		HealProject = GetHealProject(UnitState.GetReference());
		if (HealProject != none)
		{
			HealProject = XComGameState_HeadquartersProjectHealSoldier(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersProjectHealSoldier', HealProject.ObjectID));
			HealProject.PauseProject();
		}
//	}

	UnitState.SetStatus(eStatus_CovertAction);
	class'Helpers_LW'.static.UpdateUnitWillRecoveryProject(UnitState);
}

//helper to retrieve spark heal project -- note that we can't retrieve the proper project, since it is in the DLC3.u
// so instead we retrieve the parent heal project class and check using IsA
static function XComGameState_HeadquartersProjectHealSoldier GetHealProject(StateObjectReference UnitRef)
{
    local XComGameStateHistory History;
    local XComGameState_HeadquartersXCom XCOMHQ;
    local XComGameState_HeadquartersProjectHealSoldier HealProject;
    local int Idx;

    History = `XCOMHISTORY;
    XCOMHQ = `XCOMHQ;
    for(Idx = 0; Idx < XCOMHQ.Projects.Length; ++ Idx)
    {
        HealProject = XComGameState_HeadquartersProjectHealSoldier(History.GetGameStateForObjectID(XCOMHQ.Projects[Idx].ObjectID));
        if(HealProject != none && HealProject.IsA('XComGameState_HeadquartersProjectHealSoldier'))
        {
            if(UnitRef == HealProject.ProjectFocus)
            {
                return HealProject;
            }
        }
    }
    return none;
}

defaultproperties
{
	AlienRulerTags[0] = "Ruler_ViperKingActive";
	AlienRulerTags[1] = "Ruler_BerserkerQueenActive";
	AlienRulerTags[2] = "Ruler_ArchonKingActive";
}
