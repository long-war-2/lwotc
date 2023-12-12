//---------------------------------------------------------------------------------------
//  FILE:    X2EventListener_LWModAPI.uc
//  AUTHOR:  Tedster
//  PURPOSE: Mod data API using ELRs
//
//---------------------------------------------------------------------------------------

class X2EventListener_LWModAPI extends X2EventListener;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    Templates.AddItem(CreateLWUnitInfoReturn());
	Templates.AddItem(CreateLWUnitSquadInfoReturn());
	Templates.AddItem(CreateLWRegionalAIListeners());

    return Templates;
}

static function CHEventListenerTemplate CreateLWUnitInfoReturn()
{
    local CHEventListenerTemplate Template;

    `CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'Ted_LWUnitInfoReturn');

    //    Should the Event Listener listen for the event during tactical missions?
    Template.RegisterInTactical = true;

    //    Should listen to the event while on Avenger?
    Template.RegisterInStrategy = true;
    Template.AddCHEvent('GetLWUnitInfo', LWUnitInfoReturn, ELD_Immediate, 80);

    return Template;
}

static function CHEventListenerTemplate CreateLWUnitSquadInfoReturn()
{
    local CHEventListenerTemplate Template;

    `CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'Ted_LWUnitSquadInfoReturn');

    //    Should the Event Listener listen for the event during tactical missions?
    Template.RegisterInTactical = true;

    //    Should listen to the event while on Avenger?
    Template.RegisterInStrategy = true;
    Template.AddCHEvent('GetLWUnitSquadInfo', LWUnitSquadInfoReturn, ELD_Immediate, 80);

    return Template;
}

static function CHEventListenerTemplate CreateLWRegionalAIListeners()
{
	local CHEventListenerTemplate Template;

    `CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'Ted_LWRegionalFLReturn');
	Template.RegisterInStrategy = true;
    Template.AddCHEvent('GetLWRegionalForceLevel', OnGetLWRegionalForceLevel, ELD_Immediate, 80);
	Template.AddCHEvent('SetLWRegionalForceLevel', OnSetLWRegionalForceLevel, ELD_Immediate, 80);

    return Template;
}

/*
	Unit info API.  Trigger this to receive information about a solider from the LW officer and haven systems.

	local XComLWTuple Tuple;

	Tuple = new class'XComLWTuple';
	Tuple.Id = 'GetLWUnitInfo';
	Tuple.Data.Add(9);
	Tuple.Data[0].kind = XComLWTVBool;		Tuple.Data[0].b = false;	//Is the unit an Officer
	Tuple.Data[1].kind = XComLWTVInt;		Tuple.Data[1].i = -1;		//Officer Rank integer value
	Tuple.Data[2].kind = XComLWTVString;	Tuple.Data[2].s = "";		//Officer Rank Full Name string
	Tuple.Data[3].kind = XComLWTVString;	Tuple.Data[3].s = "";		//Officer Rank Short string
	Tuple.Data[4].kind = XComLWTVString;	Tuple.Data[4].s = "";		//Officer Rank Icon Path
	Tuple.Data[5].kind = XComLWTVBool;		Tuple.Data[5].b = false;	//Is a Haven Liason
	Tuple.Data[6].kind = XComLWTVObject;	Tuple.Data[6].o = none;		//XComGameState_WorldRegion object for the region the unit is located in
	Tuple.Data[7].kind = XComLWTVBool;		Tuple.Data[7].b = false;	//Is the unit Locked in their Haven
	Tuple.Data[8].kind = XComLWTVBool;		Tuple.Data[8].b = false;	//Is this unit on a mission right now

	`XEVENTMGR.TriggerEvent('GetLWUnitInfo', Tuple, Unit, GameState);
*/

static protected function EventListenerReturn LWUnitInfoReturn(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{

	local XComLWTuple Tuple;
	local XComGameState_Unit Unit;

	Tuple = XComLWTuple(EventData);
	Unit = XComGameState_Unit(EventSource);

	//abort if inputs incorrect
	if(Tuple == none || Tuple.Id != 'GetLWUnitInfo' || Unit == none)
	{
		return ELR_NoInterrupt;
	}

	//Is  An Officer
	if(class'LWOfficerUtilities'.static.IsOfficer(Unit))
	{
		//if we're here, the unit is confirmed to be an officer so grab their rank
		Tuple.Data[0].b = true; //is an officer
		Tuple.Data[1].i = class'LWOfficerUtilities'.static.GetOfficerComponent(Unit).GetOfficerRank();				//officer rank
		Tuple.Data[2].s = class'LWOfficerUtilities'.static.GetLWOfficerRankName(Tuple.Data[1].i);					//rankname full
		Tuple.Data[3].s = class'LWOfficerUtilities'.static.GetLWOfficerShortRankName(Tuple.Data[1].i);				//rankname short
		Tuple.Data[4].s = class'LWOfficerUtilities'.static.GetRankIcon(Tuple.Data[1].i);							//rankicon path
	}

	//Is In haven
	if(`LWOUTPOSTMGR.IsUnitAHavenLiaison(Unit.GetReference()))
	{
		Tuple.Data[5].b = true;
		Tuple.Data[6].o = `LWOUTPOSTMGR.GetRegionForLiaison(Unit.GetReference());									//grab the region they're in

		if(`LWOUTPOSTMGR.IsUnitALockedHavenLiaison(Unit.GetReference()))											//are they locked there
		{
			Tuple.Data[7].b = true;
		}
	}
	Tuple.Data[8].b = `LWSQUADMGR.UnitIsOnMission(Unit.GetReference());

	return ELR_NoInterrupt;
}

/*
	Unit's Squad info API. Trigger this to receive information about a unit's squad from the LW Squad system.

	local XComLWTuple Tuple;

	Tuple = new class'XComLWTuple';
	Tuple.Id = 'GetLWUnitSquadInfo';
	Tuple.Data.Add(6);
	Tuple.Data[0].kind = XComLWTVBool;			Tuple.Data[0].b = false;	//Is the unit in a squad
	Tuple.Data[1].kind = XComLWTVString;		Tuple.Data[1].s = "";		//The squad's name
	Tuple.Data[2].kind = XComLWTVString;		Tuple.Data[2].s = "";		//The squad's icon path
	Tuple.Data[3].kind = XComLWTVBool;			Tuple.Data[3].b = false;	//Is the unit a temporary member, or permanently assigned to the squad
	Tuple.Data[4].kind = XComLWTVArrayObjects;	Tuple.Data[4].ao = [];	//Array of XComGameState_Units that are normally part of the squad
	Tuple.Data[5].kind = XComLWTVArrayObjects;	Tuple.Data[5].ao = [];	//Array of XComGameState_Units that are temporarily part of the squad

	`XEVENTMGR.TriggerEvent('GetLWUnitSquadInfo', Tuple, Unit, GameState);
*/

static protected function EventListenerReturn LWUnitSquadInfoReturn(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComLWTuple Tuple;
	local XComGameState_Unit Unit;
	local XComGameState_LWPersistentSquad SquadState;

	Tuple = XComLWTuple(EventData);
	Unit = XComGameState_Unit(EventSource);
	`LWTrace("Squad info Tuple called with unit:" @Unit);

	`LWTrace("Tuple Received:" @Tuple.Id);

	//abort if inputs incorrect
	if(Tuple == none || Tuple.Id != 'GetLWUnitSquadInfo' || Unit == none)
	{
		return ELR_NoInterrupt;
	}

	if(`LWSQUADMGR.UnitIsInAnySquad(Unit.GetReference(), SquadState))
	{
		Tuple.Data[0].b = true;
		Tuple.Data[1].s = SquadState.GetSquadName();									//squad name
		Tuple.Data[2].s = SquadState.GetSquadImagePath();								//squad icon image path
		Tuple.Data[3].b = SquadState.IsSoldierTemporary(Unit.GetReference());			//is the unit temporary
		Tuple.Data[4].ao = SquadState.GetSoldiers();									//grabs all soldiers assigned to the squad
		Tuple.Data[5].ao = SquadState.GetTempSoldiers();								//grabs soldiers on the mission the squad is currently on that are not formally assigned to the squad
	}

	`LWTrace("Squad Info Tuple data:");
	`LWTrace("Tuple 0:" @Tuple.Data[0].b);
	`LWTrace("Tuple 1:" @Tuple.Data[1].s);
	`LWTrace("Tuple 2:" @Tuple.Data[2].s);
	`LWTrace("Tuple 3:" @Tuple.Data[3].b);

	return ELR_NoInterrupt;
}


/*
	This Tuple gets the current LW Force Level for all regions.
	Tuple inputs: none
	Tuple outputs:
	Tuple.Data[0] - Array Objects - Array of XCGS_WorldRegion.
	Tuple.Data[1] - Array ints - Force Level for the Regions. Use matched index 

	local XComLWTuple Tuple;

	Tuple = new class'XComLWTuple';
	Tuple.Id = 'GetLWRegionalForceLevel';
	Tuple.Data.Add(2);

	`XEVENTMGR.TriggerEvent('GetLWRegionalForceLevel', Tuple);

 */

static protected function EventListenerReturn OnGetLWRegionalForceLevel(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComLWTuple Tuple;
	local XCOmGameState_WorldRegion RegionState;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;
	local int i;

	Tuple = XComLWTuple(EventData);

	if(Tuple == none || Tuple.Id != 'GetLWRegionalForceLevel' )
	{
		return ELR_NoInterrupt;
	}

	i=0;

	Tuple.Data[0].kind = XComLWTVArrayObjects;
	Tuple.Data[1].kind = XComLWTVArrayInts;

	foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
	{
		if(RegionState != NONE)
		{
			
			Tuple.Data[0].ao[i] = RegionState;

			RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState);
			
			Tuple.Data[1].ai[i] = RegionalAI.LocalForceLevel;

			i += 1;
		}
	}

	return ELR_NoInterrupt;
}

/*
	This event adjusts the force level in a region, or in all regions, by the specified amount.

	EventData: the below Tuple
	EventSource: the XComGameState_WorldRegion you want to adjust (optional if Tuple.Data[0].b is set to true)
	NewGameState: your updated Game State. You must submit it afterwards.

	Tuple inputs:
	Tuple.Data[0] - bool - if set to true, adjust FL in all regions.  If set to false, adjust FL in just specified region.
	Tuple.Data[1] - int - value for the change in Force Level; can be negative.

	Tuple outputs:
	Tuple.Data[2] - bool - set to true if the change went through, set to false if it failed.

	local XComLWTuple Tuple;

	Tuple = new class'XComLWTuple';
	Tuple.Id = 'SetLWRegionalForceLevel';
	Tuple.Data.Add(4);
	
	Tuple.Data[0].kind = XComLWTVBool;
	Tuple.Data[0].b = true;

	Tuple.Data[1].kind = XComLWTVInt;
	Tuple.Data[1].i = 1;

	Tuple.Data[2].kind = XComLWTVBool;
	Tuple.Data[2].b = false;

	`XEVENTMGR.TriggerEvent('SetLWRegionalForceLevel', Tuple, RegionState, NewGameState);

 */

static protected function EventListenerReturn OnSetLWRegionalForceLevel(Object EventData, Object EventSource, XComGameState NewGameState, Name Event, Object CallbackData)
{
	local XComLWTuple Tuple;
	local XComGameState_WorldRegion_LWStrategyAI RegionalAI;
	local XCOmGameState_WorldRegion RegionState;
	local bool bAllRegions;
	local XComGameStateHistory History;

	Tuple = XComLWTuple(EventData);

	History = `XCOMHISTORY;

	if(Tuple == NONE || Tuple.Id != 'SetLWRegionalForceLevel')
	{
		return ELR_NoInterrupt;
	}

	if(NewGameState == NONE)
	{
		`LWTrace("SetRegionalFL Event called with no Game State");
		Tuple.Data[2].b = false;
		return ELR_NoInterrupt;
	}

	bAllRegions = Tuple.Data[0].b;
	RegionState = XCOmGameState_WorldRegion(EventSource);

	if(RegionState == NONE && !bAllRegions)
	{
		Tuple.Data[2].b = false;
		return ELR_NoInterrupt;
	}

	if(!bAllRegions) // If just one region is being updated
	{
		RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState, NewGameState, true);

		if(RegionalAI == NONE)
		{
			`LWTrace("SetRegionalFL event: no RegionalAI found");
			Tuple.Data[2].b = false;
			return ELR_NoInterrupt;
		}

		RegionalAI.LocalForceLevel += Tuple.Data[1].i;
		
		// Minimum FL of 1, if it goes below this, reset and return false.
		if(RegionalAI.LocalForceLevel < 1)
		{
			RegionalAI.LocalForceLevel=1;
			Tuple.Data[2].b = false;
			return ELR_NoInterrupt;
		}
		else if(RegionalAI.LocalForceLevel > 99) // cap at 99 too
		{
			RegionalAI.LocalForceLevel=99;
			Tuple.Data[2].b = false;
			return ELR_NoInterrupt;
		}
	}
	else // if all regions are being updated
	{
		foreach History.IterateByClassType(class'XComGameState_WorldRegion', RegionState)
		{
			RegionalAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(RegionState, NewGameState, true);

			if(RegionalAI != NONE)
			{
				RegionalAI.LocalForceLevel += Tuple.Data[1].i;
		
				// Minimum FL of 1, if it goes below this, reset and return false.
				if(RegionalAI.LocalForceLevel < 1)
				{
					RegionalAI.LocalForceLevel=1;
					Tuple.Data[2].b = false;
				}
				else if(RegionalAI.LocalForceLevel > 99) // cap at 99 too
				{
					RegionalAI.LocalForceLevel=99;
					Tuple.Data[2].b = false;
				}
			}
		}

	}
	Tuple.Data[2].b = true;

	return ELR_NoInterrupt;
}


