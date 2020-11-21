//---------------------------------------------------------------------------------------
//  FILE:    LWRebelJob_DefaultJobSet.uc
//  AUTHOR:  tracktwo / Pavonis Interactive
//  PURPOSE: Default rebel jobs.
//---------------------------------------------------------------------------------------

class LWRebelJob_DefaultJobSet extends X2StrategyElement config(LW_Outposts);

const SUPPLY_JOB = 'Resupply';
const RECRUIT_JOB = 'Recruit';
const INTEL_JOB = 'Intel';
const HIDING_JOB = 'Hiding';

var localized string strRebelRecruited;
var localized string strSoldierRecruited;
var localized string strStaffRecruited;

struct AvengerScanModifier
{
	var name ResearchOrDarkEvent;
	var float ScanModifier;
};

var config float AVENGER_REGION_SCAN_BONUS;
var config array<AvengerScanModifier> AVENGER_SCAN_MODIFIERS;

var config bool RECRUIT_CREW_IN_LIBERATED_ONLY;
var config int RECRUIT_REBEL_BAR;
var config int RECRUIT_SOLDIER_BAR;
var config int RECRUIT_ENGINEER_BAR;
var config int RECRUIT_SCIENTIST_BAR;
var config int RECRUIT_REBEL_SOLDIER_BIAS;
var config int RECRUIT_SOLDIER_BIAS_IF_FULL;

var config int LOW_REBELS_THRESHOLD;
var config int RECRUIT_REBEL_REBEL_BIAS;
var config array<int> SOLDIER_LIAISON_FLAT_BONUS;
var config float SOLDIER_LIAISON_MULTIPLIER;

var config float ENGINEER_LIAISON_BONUS;
var config float SCIENTIST_LIAISON_BONUS;

static function array <X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;
	
	`LWTrace("  >> LWRebelJob_DefaultJobSet.CreateTemplates()");
	
    Templates.AddItem(ResupplyJob());
    Templates.AddItem(RecruitJob());
    Templates.AddItem(IntelJob());
	Templates.AddItem(HidingJob());
    return Templates;
}

// Standard modifiers that affect all jobs
static function AddStandardModifiers(out LWRebelJobTemplate Template)
{
    // Regions w/ radio relays get a bonus to all jobs 
    Template.IncomeModifiers.AddItem(new class'LWRebelJobIncomeModifier_Radio');
    // Liberated regions get a bonus to all jobs
    Template.IncomeModifiers.AddItem(new class'LWRebelJobIncomeModifier_Liberated');
    Template.IncomeModifiers.AddItem(new class'LWRebelJobIncomeModifier_Retribution');
}

// Resupply - gather supplies. Does not have a threshold or income function, it
// accumulates to the pool but external end-of-month code will use this to determine
// resupply amounts instead of distinct threshold/income events.
static function LWRebelJobTemplate ResupplyJob()
{
    local LWRebelJobTemplate Template;
    local LWRebelJobIncomeModifier_Liaison LiaisonModifier;
	local LWRebelJobIncomeModifier_DiminishingSupplies DiminishingReturnsModifier;
	local LWRebelJobIncomeModifier_Prohibited ProhibitedJobModifier;
	local LWRebelJobIncomeModifier_DarkEvent DarkEventModifier;

    `CREATE_X2TEMPLATE(class'LWRebelJobTemplate', Template, SUPPLY_JOB);

    AddStandardModifiers(Template);

    // Note: Faceless modifier is *not* included here: faceless steal supplies
    // at the month end instead of each day. Having them change supplies each day
    // could make it easy to determine when a recruit is a faceless by seeing a
    // difference in expected supply yield after recruit.

    // Bonus to supply income if an engineer is staffed in the outpost
    LiaisonModifier = new class'LWRebelJobIncomeModifier_Liaison';
    LiaisonModifier.TemplateName = 'Engineer';
    LiaisonModifier.Mod = default.ENGINEER_LIAISON_BONUS;
    Template.IncomeModifiers.AddItem(LiaisonModifier);

	DarkEventModifier = new class'LWRebelJobIncomeModifier_DarkEvent';
	DarkEventModifier.DarkEvent = 'DarkEvent_RuralCheckpoints_LW';
    DarkEventModifier.ApplyToExpectedIncome = true;
	DarkEventModifier.Mod = class'X2StrategyElement_DarkEvents_LW'.default.RURAL_CHECKPOINTS_SUPPLY_MULTIPLIER;
	Template.IncomeModifiers.AddItem(DarkEventModifier);

	//Diminishing returns when draining supplies from a region
	DiminishingReturnsModifier = new class'LWRebelJobIncomeModifier_DiminishingSupplies';
	Template.IncomeModifiers.AddItem(DiminishingReturnsModifier);

	ProhibitedJobModifier = new class'LWRebelJobIncomeModifier_Prohibited';
	ProhibitedJobModifier.TestJob = 'Resupply';
	Template.IncomeModifiers.AddItem(ProhibitedJobModifier);

    return Template;
}

static function LWRebelJobTemplate RecruitJob()
{
    local LWRebelJobTemplate Template;
	local LWRebelJobIncomeModifier_DarkEvent DarkEventModifier;
    local LWRebelJobIncomeModifier_SoldierLiaison LiaisonModifier;
	local LWRebelJobIncomeModifier_Prohibited ProhibitedJobModifier;

    `CREATE_X2TEMPLATE(class'LWRebelJobTemplate', Template, RECRUIT_JOB);

    Template.GetDailyIncomeFn = GetDailyIncome_Recruit;
    Template.IncomeEventFn = IncomeEvent_Recruit;

    // Faceless all up in ur haven, stealin ur suppliez
    Template.IncomeModifiers.AddItem(new class'LWRebelJobIncomeModifier_LocalFaceless');

	DarkEventModifier = new class'LWRebelJobIncomeModifier_DarkEvent';
	DarkEventModifier.DarkEvent = 'DarkEvent_RuralPropagandaBlitz';
    DarkEventModifier.ApplyToExpectedIncome = true;
	DarkEventModifier.Mod = class'X2StrategyElement_DarkEvents_LW'.default.RURAL_PROPAGANDA_BLITZ_RECRUITING_MULTIPLIER;
	Template.IncomeModifiers.AddItem(DarkEventModifier);

    Template.IncomeEventVisualizationFn = IncomeEvent_Recruit_Visualization;

    AddStandardModifiers(Template);

    // Bonus to recruit income if a soldier is staffed in the outpost.
    LiaisonModifier = new class'LWRebelJobIncomeModifier_SoldierLiaison';
    Template.IncomeModifiers.AddItem(LiaisonModifier);
	
	ProhibitedJobModifier = new class'LWRebelJobIncomeModifier_Prohibited';
	ProhibitedJobModifier.TestJob = 'Recruit';
	Template.IncomeModifiers.AddItem(ProhibitedJobModifier);

    return Template;
}

function float GetDailyIncome_Recruit(XComGameState_LWOutpost Outpost, float RebelLevels, LWRebelJobTemplate MyTemplate)
{
    local float income;

    // Compute the "ideal" income based on the config vars
    income = RebelLevels * MyTemplate.IncomePerRebel;

    if (Outpost.HasLiaisonOfKind('Soldier'))
    {
        switch (Outpost.GetRebelCount())
        {
            case 0:
                income += default.SOLDIER_LIAISON_FLAT_BONUS[0];
                break;
            case 1:
                income += default.SOLDIER_LIAISON_FLAT_BONUS[1];
                break;
            case 2:
                income += default.SOLDIER_LIAISON_FLAT_BONUS[2];
                break;
            case 3:
                income += default.SOLDIER_LIAISON_FLAT_BONUS[3];
                break;
            case 4:
                income += default.SOLDIER_LIAISON_FLAT_BONUS[4];
                break;
            case 5:
                income += default.SOLDIER_LIAISON_FLAT_BONUS[5];
                break;
            default:
                income += default.SOLDIER_LIAISON_FLAT_BONUS[6];
                break;
        }
    }
    return income;
}

function XComGameState_Unit CreateRecruit(name Template, name Country, XComGameState NewGameState)
{
    local XComGameState_Unit Unit;
    Unit = `CHARACTERPOOLMGR.CreateCharacter(NewGameState, `XPROFILESETTINGS.Data.m_eCharPoolUsage, Template, Country);
    Unit.RandomizeStats();
    NewGameState.AddStateObject(Unit);
    if (Template == 'Soldier')
        Unit.ApplyInventoryLoadout(NewGameState);
    return Unit;
}

function IncomeEvent_Recruit(XComGameState_LWOutpost Outpost, XComGameState NewGameState, LWRebelJobTemplate MyTemplate)
{
    local StateObjectReference UnitRef;
    local XComGameState_Unit Unit;
    local XComGameState_WorldRegion Region;
    local XComGameState_HeadquartersResistance ResistanceHQ;
    local XComGameState_HeadquartersXCom XComHQ;
    local XComGameStateHistory History;
    local String str;
    local int roll;
    local name nmCountry;
    local int RebelChance;
    local int SoldierChance;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;

    History = `XCOMHISTORY;
    Region = XComGameState_WorldRegion(History.GetGameStateForObjectID(Outpost.Region.ObjectID));

    nmCountry = '';
    nmCountry = Region.GetMyTemplate().GetRandomCountryInRegion();

    if (Outpost.ForceRecruitRoll != 0)
    {
        roll = Outpost.ForceRecruitRoll;
        Outpost.ForceRecruitRoll = 0;
        `Log("Debug: Forcing recruit roll to " $ roll);
    }
    else
    {
		RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(Region);
		if (RegionalAI.bLiberated || !default.RECRUIT_CREW_IN_LIBERATED_ONLY)
		{
			roll = `SYNC_RAND(default.RECRUIT_REBEL_BAR + default.RECRUIT_SOLDIER_BAR + default.RECRUIT_ENGINEER_BAR + default.RECRUIT_SCIENTIST_BAR);
		}
		else
		{
			roll = `SYNC_RAND(default.RECRUIT_REBEL_BAR + default.RECRUIT_SOLDIER_BAR);
		}
    }

    `LWTrace("Recruit: Rolled " $ roll);
	
    // Adjust chances for soldiers and rebels based on how many we have
    RebelChance = RECRUIT_REBEL_BAR;
    SoldierChance = RECRUIT_SOLDIER_BAR;

    ResistanceHQ = class'UIUtilities_Strategy'.static.GetResistanceHQ();

	// if you are super-low on potential recruits, favor troops if ini is set to do so
    if (Outpost.GetRebelCount() > ResistanceHQ.Recruits.Length)
    {
        RebelChance -= RECRUIT_REBEL_SOLDIER_BIAS;
        SoldierChance += RECRUIT_REBEL_SOLDIER_BIAS;
    }

    //If you have low amount of rebels in your haven, prioritize getting rebels
    if (Outpost.GetRebelCount() < default.LOW_REBELS_THRESHOLD)
    {
        RebelChance += default.RECRUIT_REBEL_REBEL_BIAS;
        SoldierChance -= default.RECRUIT_REBEL_REBEL_BIAS;
    }
   
   // bias roll toward soldiers if haven is full
   if (Outpost.GetRebelCount() > Outpost.GetMaxRebelCount())
   {
		RebelChance -= default.RECRUIT_SOLDIER_BIAS_IF_FULL;
		SoldierChance += default.RECRUIT_SOLDIER_BIAS_IF_FULL;
   }

    // If this outpost is overfull (2x working capacity) and we rolled a rebel, bump it up to the next tier.
    if (roll < RebelChance && Outpost.GetRebelCount() >= (2 * Outpost.GetMaxRebelCount()))
    {
		roll += RebelChance;
        `LWTrace("Bumping roll up to " $ roll $ " due to full outpost");
    }

    if (roll < RebelChance)
    {
        `LWTrace("Recruit rewarding a rebel");
        // Spawn a new rebel ... or a new faceless. CreateRebel handles NCE, no need to randomize here.
        UnitRef = Outpost.CreateRebel(NewGameState, Region, true);
        // Note: we already have a new outpost state pending while we're doing an income event, so we just need to add the rebel,
        // no need to create a new state here.
        Outpost.AddRebel(UnitRef, NewGameState);

        Unit = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));
        str = Repl(strRebelRecruited, "%UNIT", Unit.GetFullName());
        str = Repl(str, "%REGION", Region.GetDisplayName());
    }
    else
    {
        roll -= RebelChance;
        if (roll < SoldierChance)
        {
            `LWTrace("Recruit rewarding a soldier");
            Unit = CreateRecruit('Soldier', nmCountry, NewGameState);
            ResistanceHQ = XComGameState_HeadquartersResistance(NewGameState.CreateStateObject(class'XComGameState_HeadquartersResistance', 
                class'UIUtilities_Strategy'.static.GetResistanceHQ().ObjectID));
            ResistanceHQ.Recruits.AddItem(Unit.GetReference());
			`XEVENTMGR.TriggerEvent('SoldierCreatedEvent', Unit, Unit, NewGameState); // event to trigger NCE as needed for new soldier
			class'Utilities_LW'.static.GiveDefaultUtilityItemsToSoldier(Unit, NewGameState);
            NewGameState.AddStateObject(ResistanceHQ);
            str = Repl(strSoldierRecruited, "%UNIT", Unit.GetName(eNameType_RankFull));
            str = Repl(str, "%REGION", Region.GetDisplayName());
        }
        else
        {
            roll -= SoldierChance;
            if (roll < RECRUIT_ENGINEER_BAR)
            {
                `LWTrace("Recruit rewarding an engineer");
                Unit = CreateRecruit('Engineer', nmCountry, NewGameState);
                XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
                XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
                XComHQ.AddToCrew(NewGameState, Unit);
                XComHQ.HandlePowerOrStaffingChange(NewGameState);
                NewGameState.AddStateObject(XComHQ);
                str = Repl(strStaffRecruited, "%UNIT", Unit.GetFullName());
                str = Repl(str, "%REGION", Region.GetDisplayName());
                str = Repl(str, "%TITLE", class'XGLocalizedData'.default.StaffTypeNames[eStaff_Engineer]);
            }
            else
            {
                `LWTrace("Recruit rewarding a scientist");
                Unit = CreateRecruit('Scientist', nmCountry, NewGameState);
                XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
                XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
                XComHQ.AddToCrew(NewGameState, Unit);
                XComHQ.HandlePowerOrStaffingChange(NewGameState);
                NewGameState.AddStateObject(XComHQ);
                str = Repl(strStaffRecruited, "%UNIT", Unit.GetFullName());
                str = Repl(str, "%REGION", Region.GetDisplayName());
                str = Repl(str, "%TITLE", class'XGLocalizedData'.default.StaffTypeNames[eStaff_Scientist]);
            }
        }
    }

    `HQPRES.Notify(str);
}

function IncomeEvent_Recruit_Visualization(XComGameState_LWOutpost Outpost, LWRebelJobTemplate MyTemplate)
{
	local UIStrategyMap StrategyMap;
	local XGGeoscape Geoscape;

    if (`LWOVERHAULOPTIONS.GetPauseOnRecruit())
    {
		StrategyMap = `HQPRES.StrategyMap2D;
		if (StrategyMap != none && StrategyMap.m_eUIState != eSMS_Flight)
		{
			Geoscape = `GAME.GetGeoscape();
			Geoscape.Pause();
			Geoscape.Resume();
		}
    }
}

// Intel Job - does both increasing of Intel Resource and Searching for missions. Does not have a threshold or income function, it
// accumulates to the pool but external alien activity code will use this to determine
// activity detection instead of distinct threshold/income events.
// It uses a custom income function in order to provide a bonus if the Avenger is scanning in the same region.
static function LWRebelJobTemplate IntelJob()
{
    local LWRebelJobTemplate Template;
	local LWRebelJobIncomeModifier_DarkEvent DarkEventModifier;
    local LWRebelJobIncomeModifier_Liaison LiaisonModifier;
	local LWRebelJobIncomeModifier_Prohibited ProhibitedJobModifier;

    `CREATE_X2TEMPLATE(class'LWRebelJobTemplate', Template, INTEL_JOB);

    Template.IncomeEventFn = IncomeEvent_Intel;
	Template.GetDailyIncomeFn = GetDailyIncome_Intel;
    Template.IncomeEventVisualizationFn = IncomeEvent_Intel_Visualization;

    // Faceless all up in ur haven, stealin ur suppliez
    Template.IncomeModifiers.AddItem(new class'LWRebelJobIncomeModifier_LocalFaceless');

	DarkEventModifier = new class'LWRebelJobIncomeModifier_DarkEvent';
	DarkEventModifier.DarkEvent = 'DarkEvent_CounterintelligenceSweep';
    DarkEventModifier.ApplyToExpectedIncome = true;
	DarkEventModifier.Mod = class'X2StrategyElement_DarkEvents_LW'.default.COUNTERINTELLIGENCE_SWEEP_INTEL_MULTIPLIER;
	Template.IncomeModifiers.AddItem(DarkEventModifier);

    AddStandardModifiers(Template);

    // Bonus to intel income if a scientist is staffed in the outpost
    LiaisonModifier = new class'LWRebelJobIncomeModifier_Liaison';
    LiaisonModifier.TemplateName = 'Scientist';
    LiaisonModifier.Mod = default.SCIENTIST_LIAISON_BONUS;
    Template.IncomeModifiers.AddItem(LiaisonModifier);
	
	ProhibitedJobModifier = new class'LWRebelJobIncomeModifier_Prohibited';
	ProhibitedJobModifier.TestJob = 'Intel';
	Template.IncomeModifiers.AddItem(ProhibitedJobModifier);

    return Template;
}

simulated function IncomeEvent_Intel(XComGameState_LWOutpost Outpost, XComGameState NewGameState, LWRebelJobTemplate MyTemplate)
{
    local XComGameState_HeadquartersXCom XComHQ;
    local XComGameState_WorldRegion Region;
	local XComGameState_WorldRegion_LWStrategyAI RegionAI;

    XComHQ = `XCOMHQ;

	Region = Outpost.GetWorldRegionForOutpost();
	RegionAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(Region);

	if (RegionAI.bLiberated)
	{
	    XComHQ.AddResource(NewGameState, 'Intel', 2 * MyTemplate.ResourceIncomeAmount);
	}
	else
	{
	    XComHQ.AddResource(NewGameState, 'Intel', MyTemplate.ResourceIncomeAmount);
	}

}

function IncomeEvent_Intel_Visualization(XComGameState_LWOutpost Outpost, LWRebelJobTemplate MyTemplate)
{
	local XComGameState_WorldRegion Region;
	local XComGameState_WorldRegion_LWStrategyAI RegionAI;

	Region = Outpost.GetWorldRegionForOutpost();
	RegionAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(Region);

	if (RegionAI.bLiberated)
	{
		FlyoverPopup(Outpost, 'Intel', 2 * MyTemplate.ResourceIncomeAmount);
	}
	else
	{
		FlyoverPopup(Outpost, 'Intel', MyTemplate.ResourceIncomeAmount);
	}
}

simulated function FlyoverPopup(XComGameState_LWOutpost Outpost, Name ResourceName, int ResourceAmount)
{
    local string FlyoverResourceName;
    local Vector2D MessageLocation;
    local XComGameState_Haven Haven;
    local XComGameState_WorldRegion Region;
    local XComGameStateHistory History;

    FlyoverResourceName = class'UIUtilities_Strategy'.static.GetResourceDisplayName(ResourceName, ResourceAmount);

    // Figure out where to put this message.
    History = `XCOMHISTORY;
    Region = XComGameState_WorldRegion(History.GetGameStateForObjectID(Outpost.Region.ObjectID));
    Haven = XComGameState_Haven(History.GetGameStateForObjectID(Region.Haven.ObjectID));

    MessageLocation = Haven.Get2DLocation();
    MessageLocation.Y -= 0.006; //scoot above the pin
    `HQPRES.GetWorldMessenger().Message(FlyoverResourceName $ " +" $ ResourceAmount, `EARTH.ConvertEarthToWorld(MessageLocation), , , , , , , , 2.0);
    `HQPRES.m_kAvengerHUD.UpdateResources();
}


function float GetDailyIncome_Intel(XComGameState_LWOutpost Outpost, float RebelLevels, LWRebelJobTemplate MyTemplate)
{
    local float income;
	local XComGameState_HeadquartersXCom XComHQ;

    // Compute the "ideal" income based on the config vars
    income = RebelLevels * MyTemplate.IncomePerRebel;
	//`LOG("Mission Income: NumRebels=" $ NumRebels $ ");


	//adjust income if the avenger is in the same region
	XComHQ = `XCOMHQ;
	//`LOG("Daily Mission Income: HQ RegionID=" $ XComHQ.Region.ObjectID $ ", OutpostRegionID=" $ Outpost.Region.ObjectID);
	if(XComHQ.GetCurrentScanningSite() != none && XComHQ.GetCurrentScanningSite().GetReference().ObjectID == Outpost.Region.ObjectID)
		income += GetAvengerMissionValue(XComHQ); 

	//`LOG("Mission Income: Final Value=" $ income);
	return income;
}

function float GetAvengerMissionValue(XComGameState_HeadquartersXCom XComHQ)
{
	local float ScanValue;
	local AvengerScanModifier ScanModifier;

	ScanValue = default.AVENGER_REGION_SCAN_BONUS;
	foreach default.AVENGER_SCAN_MODIFIERS(ScanModifier)
	{
		if(XComHQ.IsTechResearched(ScanModifier.ResearchOrDarkEvent) || DarkEventActive(ScanModifier.ResearchOrDarkEvent))
		{
			ScanValue += ScanModifier.ScanModifier;
		}
	}
	//`LOG("Avenger ScanValue=" $ ScanValue);
	return FMax(0.0, ScanValue);
}

function bool DarkEventActive(name DarkEventName)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_DarkEvent DarkEventState;
	
	History = `XCOMHISTORY;
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	foreach History.IterateByClassType(class'XComGameState_DarkEvent', DarkEventState)
	{
		if(DarkEventState.GetMyTemplateName() == DarkEventName)
		{
			if(AlienHQ.ActiveDarkEvents.Find('ObjectID', DarkEventState.ObjectID) != -1)
			{
				return true;
			}
		}
	}
	return false;
}

static function LWRebelJobTemplate HidingJob()
{
    local LWRebelJobTemplate Template;

    `CREATE_X2TEMPLATE(class'LWRebelJobTemplate', Template, HIDING_JOB);

    Template.IncomeEventFn = none;
	Template.GetDailyIncomeFn = none;
    Template.IncomeEventVisualizationFn = none;

    return Template;
}

