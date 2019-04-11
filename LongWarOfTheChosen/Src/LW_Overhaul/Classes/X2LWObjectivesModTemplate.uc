//---------------------------------------------------------------------------------------
//  FILE:    X2LWObjectivesModTemplate.uc
//  AUTHOR:  Peter Ledbrook
//	PURPOSE: Modifies existing objective templates.
//
//           In particular, it removes the Proving Grounds objective and
//           makes some changes to Broadcast the Truth.
//---------------------------------------------------------------------------------------
class X2LWObjectivesModTemplate extends X2LWTemplateModTemplate;

static function UpdateObjectives(X2StrategyElementTemplate Template, int Difficulty)
{
	local X2ObjectiveTemplate ObjectiveTemplate;

	ObjectiveTemplate = X2ObjectiveTemplate(Template);
	if(ObjectiveTemplate == none)
		return;
	
	switch (ObjectiveTemplate.DataName)
	{
		case 'T1_M2_HackACaptain':
			`LWTrace("X2LWObjectivesModTemplate - removing proving grounds objective");
			ObjectiveTemplate.Steps.RemoveItem('T1_M2_S1_BuildProvingGrounds');
			break;
		case 'T5_M2_CompleteBroadcastTheTruthMission':
			`LWTrace("X2LWObjectivesModTemplate - updating Broadcast the Truth objective");
			ObjectiveTemplate.AssignObjectiveFn = CreateBroadcastTheTruthMission_LW;
			break;
		case 'XP3_M0_NonLostAndAbandoned':
			`LWTrace("X2LWObjectivesModTemplate - removing the SpawnFirstPOI objective");
			ObjectiveTemplate.NextObjectives.RemoveItem('XP3_M2_SpawnFirstPOI');
		default:
			break;
	}	
}

static function CreateBroadcastTheTruthMission_LW(XComGameState NewGameState, XComGameState_Objective ObjectiveState)
{
	local XComGameStateHistory History;
	local XComGameState_MissionCalendar CalendarState;
	local array<XComGameState_Reward> Rewards;

	class'X2StrategyElement_DefaultObjectives'.static.CreateMission(NewGameState, Rewards, 'MissionSource_Broadcast', 2); // remove the bForceAtThreshold flag

	// Update the calendar to use the end game mission decks
	foreach NewGameState.IterateByClassType(class'XComGameState_MissionCalendar', CalendarState)
	{
		break;
	}

	if (CalendarState == none)
	{
		History = `XCOMHISTORY;
		CalendarState = XComGameState_MissionCalendar(History.GetSingleGameStateObjectForClass(class'XComGameState_MissionCalendar'));
		CalendarState = XComGameState_MissionCalendar(NewGameState.CreateStateObject(class'XComGameState_MissionCalendar', CalendarState.ObjectID));
		NewGameState.AddStateObject(CalendarState);
	}

	CalendarState.SwitchToEndGameMissions(NewGameState);
}

defaultproperties
{
	StrategyElementTemplateModFn=UpdateObjectives
}