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
    Template.AddCHEvent('GetLWUnitSquadInfo', LWUnitInfoReturn, ELD_Immediate, 80);

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
	Tuple.Data[4].kind = XComLWTVArrayObjects;	Tuple.Data[4].ao = none;	//Array of XComGameState_Units that are normally part of the squad
	Tuple.Data[5].kind = XComLWTVArrayObjects;	Tuple.Data[5].ao = none;	//Array of XComGameState_Units that are temporarily part of the squad

	`XEVENTMGR.TriggerEvent('GetLWUnitSquadInfo', Tuple, Unit, GameState);
*/

static protected function EventListenerReturn LWUnitSquadInfoReturn(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComLWTuple Tuple;
	local XComGameState_Unit Unit;
	local XComGameState_LWPersistentSquad SquadState;

	Tuple = XComLWTuple(EventData);
	Unit = XComGameState_Unit(EventSource);

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

	return ELR_NoInterrupt;
}