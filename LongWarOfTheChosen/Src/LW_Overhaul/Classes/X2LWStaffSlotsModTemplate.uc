//---------------------------------------------------------------------------------------
//  FILE:    X2LWStaffSlotsModTemplate.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Modifies existing staff slot templates.
//---------------------------------------------------------------------------------------
class X2LWStaffSlotsModTemplate extends X2LWTemplateModTemplate config(LW_Overhaul);

var config int RESCOMMS_1ST_ENGINEER_BONUS;
var config int RESCOMMS_2ND_ENGINEER_BONUS;

var config array<float> AWC_HEALING_BONUS;

static function UpdateStaffSlots(X2StrategyElementTemplate Template, int Difficulty)
{
	local X2StaffSlotTemplate StaffSlotTemplate;

	StaffSlotTemplate = X2StaffSlotTemplate(Template);
	if (StaffSlotTemplate == none)
		return;

	switch (StaffSlotTemplate.DataName)
	{
		case 'AWCScientistStaffSlot':
			StaffSlotTemplate.GetContributionFromSkillFn = GetAWCContribution_LW;
			StaffSlotTemplate.FillFn = FillAWCSciSlot_LW;
			StaffSlotTemplate.EmptyFn = EmptyAWCSciSlot_LW;
			StaffSlotTemplate.GetAvengerBonusAmountFn = GetAWCAvengerBonus_LW;
			StaffSlotTemplate.GetBonusDisplayStringFn = GetAWCBonusDisplayString_LW;
			StaffSlotTemplate.bEngineerSlot = false;
			StaffSlotTemplate.bScientistSlot = true;
			StaffSlotTemplate.MatineeSlotName = "Scientist";
			break;
		case 'PsiChamberScientistStaffSlot':
			StaffSlotTemplate.bEngineerSlot = false;
			StaffSlotTemplate.bScientistSlot = true;
			StaffSlotTemplate.MatineeSlotName = "Scientist";
			break;
		case 'OTSStaffSlot':
			StaffSlotTemplate.IsUnitValidForSlotFn = IsUnitValidForOTSSoldierSlot;
			break;
		case 'PsiChamberSoldierStaffSlot':
			StaffSlotTemplate.IsUnitValidForSlotFn = IsUnitValidForPsiChamberSoldierSlot;
			break;
		case 'AWCSoldierStaffSlot':
			StaffSlotTemplate.IsUnitValidForSlotFn = IsUnitValidForAWCSoldierSlot;
			break;
		case 'ResCommsStaffSlot':
			StaffSlotTemplate.GetContributionFromSkillFn = SubstituteResCommStaffFn;
			break;
		case 'ResCommsBetterStaffSlot':
			StaffSlotTemplate.GetContributionFromSkillFn = SubstituteBetterResCommStaffFn;
			break;
		case 'SparkStaffSlot':
			StaffSlotTemplate.IsUnitValidForSlotFn = IsUnitValidForSparkSlotWithInfiltration;

			// DLC3 doesn't update the unit status when adding units to or removing them
			// from the repair slot. So provide our own that do that.
			StaffSlotTemplate.FillFn = FillSparkSlotAndSetHealing;
			StaffSlotTemplate.EmptyFn = EmptySparkSlotAndSetActive;
			break;
		case 'CovertActionImproveComIntStaffSlot':
			StaffSlotTemplate.IsUnitValidForSlotFn = Fixed_IsUnitValidForCovertActionImproveComIntSlot;
			break;
		default:
			break;
	}
}

static function int GetAWCContribution_LW(XComGameState_Unit UnitState)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
	
	return class'X2StrategyElement_DefaultStaffSlots'.static.GetContributionDefault(UnitState) * (`ScaleGameLengthArrayInt(XComHQ.XComHeadquarters_BaseHealRates) / 5) * (default.AWC_HEALING_BONUS[`STRATEGYDIFFICULTYSETTING] / 100.0);
}

static function int GetAWCAvengerBonus_LW(XComGameState_Unit UnitState, optional bool bPreview)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local float PercentIncrease;

	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();

	// Need to return the percent increase in overall healing speed provided by this unit
	PercentIncrease = (GetAWCContribution_LW(UnitState) * 100.0) / (`ScaleGameLengthArrayInt(XComHQ.XComHeadquarters_BaseHealRates));

	return Round(PercentIncrease);
}

static function FillAWCSciSlot_LW(XComGameState NewGameState, StateObjectReference SlotRef, StaffUnitInfo UnitInfo, optional bool bTemporary = false)
{
	local XComGameState_HeadquartersXCom NewXComHQ;
	local XComGameState_Unit NewUnitState;
	local XComGameState_StaffSlot NewSlotState;

	class'X2StrategyElement_DefaultStaffSlots'.static.FillSlot(NewGameState, SlotRef, UnitInfo, NewSlotState, NewUnitState);
	NewXComHQ = class'X2StrategyElement_DefaultStaffSlots'.static.GetNewXComHQState(NewGameState);
	
	NewXComHQ.HealingRate += GetAWCContribution_LW(NewUnitState);
}

static function EmptyAWCSciSlot_LW(XComGameState NewGameState, StateObjectReference SlotRef)
{
	local XComGameState_HeadquartersXCom NewXComHQ;
	local XComGameState_StaffSlot NewSlotState;
	local XComGameState_Unit NewUnitState;

	class'X2StrategyElement_DefaultStaffSlots'.static.EmptySlot(NewGameState, SlotRef, NewSlotState, NewUnitState);
	NewXComHQ = class'X2StrategyElement_DefaultStaffSlots'.static.GetNewXComHQState(NewGameState);

	NewXComHQ.HealingRate -= GetAWCContribution_LW(NewUnitState);

	if (NewXComHQ.HealingRate < `ScaleGameLengthArrayInt(NewXComHQ.XComHeadquarters_BaseHealRates))
	{
		NewXComHQ.HealingRate = `ScaleGameLengthArrayInt(NewXComHQ.XComHeadquarters_BaseHealRates);
	}
}

static function string GetAWCBonusDisplayString_LW(XComGameState_StaffSlot SlotState, optional bool bPreview)
{
	local string Contribution;

	if (SlotState.IsSlotFilled())
	{
		Contribution = string(GetAWCAvengerBonus_LW(SlotState.GetAssignedStaff(), bPreview));
	}

	return class'X2StrategyElement_DefaultStaffSlots'.static.GetBonusDisplayString(SlotState, "%AVENGERBONUS", Contribution);
}

static function int SubstituteResCommStaffFn(XComGameState_Unit Unit)
{
	return default.RESCOMMS_1ST_ENGINEER_BONUS;
}

static function int SubstituteBetterResCommStaffFn(XComGameState_Unit Unit)
{
	return default.RESCOMMS_2ND_ENGINEER_BONUS;
}
	
// this is an override for the rookie training slot, to disallow training of soldiers currently on a mission
static function bool IsUnitValidForOTSSoldierSlot(XComGameState_StaffSlot SlotState, StaffUnitInfo UnitInfo)
{
	local XComGameState_Unit Unit;

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitInfo.UnitRef.ObjectID));
	if (class'LWDLCHelpers'.static.IsUnitOnMission(Unit))
		return false;

	return class'X2StrategyElement_DefaultStaffSlots'.static.IsUnitValidForOTSSoldierSlot(SlotState, UnitInfo);
}


// this is an override for the psi training slot, to disallow training of soldiers currently on a mission
static function bool IsUnitValidForPsiChamberSoldierSlot(XComGameState_StaffSlot SlotState, StaffUnitInfo UnitInfo)
{
	local XComGameState_Unit Unit;
	local X2SoldierClassTemplate SoldierClassTemplate;
	local array<SoldierClassAbilityType> AllPsiAbilities;
	local SoldierClassAbilityType PsiAbility;

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitInfo.UnitRef.ObjectID));
	
	`LWTrace("Checking whether " $ Unit.GetName(eNameType_Full) $ " is valid for PsiChamber");
	if(class'LWDLCHelpers'.static.IsUnitOnMission(Unit)) // needed to work with infiltration system
		return false;

	if (Unit.CanBeStaffed()
		&& Unit.IsSoldier()
		&& !Unit.IsInjured()
		&& !Unit.IsTraining()
		&& !Unit.IsPsiTraining()
		&& !Unit.IsPsiAbilityTraining()
		&& !Unit.BelowReadyWillState()  // LWOTC: Tired and Shaken soldiers can't train
		&& SlotState.GetMyTemplate().ExcludeClasses.Find(Unit.GetSoldierClassTemplateName()) == INDEX_NONE)
	{
		if (Unit.GetRank() == 0 && !Unit.CanRankUpSoldier()) // All rookies who have not yet ranked up can be trained as Psi Ops
		{
			`LWTrace("Rookie! Can train as PsiOp");
			return true;
		}
		else if (Unit.IsPsiOperative()) // Psi Ops can only train if there are abilities left
		{ 
			`LWTrace("This is a PsiOp - need to check whether they can rank up");
			SoldierClassTemplate = Unit.GetSoldierClassTemplate();
			if (class'Utilities_PP_LW'.static.CanRankUpPsiSoldier(Unit)) // LW2 override, this limits to 8 abilities
			{
				// WOTC TODO: Need to test soldier selection for Psi Chamber. This may not work as it includes
				// a random deck of abilities. I don't know if it's possible to distinguish between Psi abilities
				// and others
				AllPsiAbilities = SoldierClassTemplate.GetAllPossibleAbilities();
				foreach AllPsiAbilities(PsiAbility)
				{
					`Log("Checking for (Psi?) ability " $ PsiAbility.AbilityName $ " (" $ PsiAbility.UtilityCat $ ")");
					if (PsiAbility.AbilityName != '' && !Unit.HasSoldierAbility(PsiAbility.AbilityName))
					{
						return true; // If we find an ability that the soldier hasn't learned yet, they are valid
					}
				}
			}
		}
	}
	return false;
}

// this is an override for the AWC class ability re-training slot, to disallow training of soldiers currently on a mission
static function bool IsUnitValidForAWCSoldierSlot(XComGameState_StaffSlot SlotState, StaffUnitInfo UnitInfo)
{
	local XComGameState_Unit Unit;

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitInfo.UnitRef.ObjectID));
	if(class'LWDLCHelpers'.static.IsUnitOnMission(Unit))
		return false;

	return class'X2StrategyElement_DefaultStaffSlots'.static.IsUnitValidForAWCSoldierSlot(SlotState, UnitInfo);
}

// this is an override for the DLC3 spark healing slot, to disallow healing of sparks currently on a mission
static function bool IsUnitValidForSparkSlotWithInfiltration(XComGameState_StaffSlot SlotState, StaffUnitInfo UnitInfo)
{
	local XComGameState_Unit Unit;

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitInfo.UnitRef.ObjectID));
	
	if (Unit.IsAlive()
		&& Unit.GetMyTemplate().bStaffingAllowed
		&& Unit.GetReference().ObjectID != SlotState.GetAssignedStaffRef().ObjectID
		&& Unit.IsSoldier()
		&& Unit.IsInjured()
		&& (Unit.GetMyTemplateName() == 'SparkSoldier' || Unit.GetMyTemplateName() == 'LostTowersSpark')
		&& !class'LWDLCHelpers'.static.IsUnitOnMission(Unit)) // added condition to prevent healing spark units on mission here
	{
		return true;
	}

	return false;
}

static function FillSparkSlotAndSetHealing(XComGameState NewGameState, StateObjectReference SlotRef, StaffUnitInfo UnitInfo, optional bool bTemporary = false)
{
	local XComGameState_Unit NewUnitState;

	NewUnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', UnitInfo.UnitRef.ObjectID));

	class'X2StrategyElement_DLC_Day90StaffSlots'.static.FillSparkSlot(NewGameState, SlotRef, UnitInfo, bTemporary);

	NewUnitState.SetStatus(eStatus_Healing);
}

static function EmptySparkSlotAndSetActive(XComGameState NewGameState, StateObjectReference SlotRef)
{
	local XComGameState_StaffSlot SlotState;
	local XComGameState_Unit NewUnitState;

	SlotState = XComGameState_StaffSlot(`XCOMHISTORY.GetGameStateForObjectID(SlotRef.ObjectID));
	NewUnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', SlotState.AssignedStaff.UnitRef.ObjectID));

	class'X2StrategyElement_DLC_Day90StaffSlots'.static.EmptySparkSlot(NewGameState, SlotRef);

	NewUnitState.SetStatus(eStatus_Active);
}

static function bool Fixed_IsUnitValidForCovertActionImproveComIntSlot(XComGameState_StaffSlot SlotState, StaffUnitInfo UnitInfo)
{
	local XComGameState_Unit Unit;
	
	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitInfo.UnitRef.ObjectID));
	// Heroes don't have bAllowAWCAbilities set to to true
	if (Unit.ComInt >= eComInt_Savant || !(Unit.GetSoldierClassTemplate().bAllowAWCAbilities || Unit.IsResistanceHero()))
	{
		// If this unit is already at the max Com Int level, they are not available
		return false;
	}
	return class'X2StrategyElement_XpackStaffSlots'.static.IsUnitValidForCovertActionSoldierSlot(SlotState, UnitInfo);
}

defaultproperties
{
	StrategyElementTemplateModFn=UpdateStaffSlots
}
