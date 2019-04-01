//---------------------------------------------------------------------------------------
//  FILE:    LWDLCHelpers
//  AUTHOR:  amineri / Pavonis Interactive
//
//  PURPOSE: Helpers for interfacing with Firaxis DLC
//--------------------------------------------------------------------------------------- 

class LWDLCHelpers extends object config(LW_Overhaul);

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

static function bool IsAlienRuler(name CharacterTemplateName)
{
	switch (CharacterTemplateName)
	{
		case 'ArchonKing':
		case 'BerserkerQueen':
		case 'ViperKing':
			return true;
		default:
			return false;
	}
}

//class'LWDLCHelpers'.static.IsUnitOnMission(UnitState)
// helper for sparks to resolve if a wounded spark is on a mission, since that status can override the OnMission one
static function bool IsUnitOnMission(XComGameState_Unit UnitState)
{
	switch (UnitState.GetMyTemplateName())
	{
		case  'SparkSoldier':
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
static function SetOnMissionStatus(XComGameState_Unit UnitState, XComGameState NewGameState)
{
	local XComGameState_StaffSlot StaffSlotState;
	local XComGameState_HeadquartersProjectHealSoldier HealSparkProject;

	switch (UnitState.GetMyTemplateName())
	{
		case  'SparkSoldier':
			//sparks can be wounded and set on a mission, in which case don't update their status, but pull them from the healing bay
			if (UnitState.GetStatus() == eStatus_Healing)
			{
				//if it's in a healing slot, remove it from slot
				StaffSlotState = UnitState.GetStaffSlot();
				if(StaffSlotState != none)
				{
					StaffSlotState.EmptySlot(NewGameState);
				}
				//and pause any healing project
				HealSparkProject = GetHealSparkProject(UnitState.GetReference());
				if (HealSparkProject != none)
				{
					HealSparkProject.PauseProject();
				}
			}
			break;
		default:
			break;
	}
	UnitState.SetStatus(eStatus_CovertAction);
}

//helper to retrieve spark heal project -- note that we can't retrieve the proper project, since it is in the DLC3.u
// so instead we retrieve the parent heal project class and check using IsA
static function XComGameState_HeadquartersProjectHealSoldier GetHealSparkProject(StateObjectReference UnitRef)
{
    local XComGameStateHistory History;
    local XComGameState_HeadquartersXCom XCOMHQ;
    local XComGameState_HeadquartersProjectHealSoldier HealSparkProject;
    local int Idx;

    History = `XCOMHISTORY;
    XCOMHQ = `XCOMHQ;
    for(Idx = 0; Idx < XCOMHQ.Projects.Length; ++ Idx)
    {
        HealSparkProject = XComGameState_HeadquartersProjectHealSoldier(History.GetGameStateForObjectID(XCOMHQ.Projects[Idx].ObjectID));
        if(HealSparkProject != none && HealSparkProject.IsA('XComGameState_HeadquartersProjectHealSpark'))
        {
            if(UnitRef == HealSparkProject.ProjectFocus)
            {
                return HealSparkProject;
            }
        }
    }
    return none;
}