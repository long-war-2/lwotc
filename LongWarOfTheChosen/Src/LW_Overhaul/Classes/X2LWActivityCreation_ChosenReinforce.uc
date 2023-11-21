// Author: Tedster
// Extension of the Reinforce activity so that I can tie initialization to Chosen.

class X2LWActivityCreation_ChosenReinforce extends X2LWActivityCreation_Reinforce config(LW_Activities);

simulated function InitActivityCreation(X2LWAlienActivityTemplate Template, XComGameState NewGameState)
{
    local XComGameState_HeadquartersAlien AlienHQ;
    local array<XComGameState_AdvevntChosen>  AllChosen;
    local XComGameState_AdventChosen ChosenState;
    local XComGameState_ChosenAction ActionState;

    AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	AllChosen = AlienHQ.GetAllChosen(, true);
    NumActivitiesToCreate = 0;

    foreach AllChosen(ChosenState)
    {
        ActionState = XComGameState_ChosenAction(History.GetGameStateForObjectID(ChosenState.CurrentMonthAction.ObjectID));
        if(ActionState.GetMyTemplateName == 'ChosenAction_TransferStrength')
        {
            NumActionPoints = 0;
        }
    }

	ActivityTemplate = Template;
	ActivityStates = class'XComGameState_LWAlienActivityManager'.static.GetAllActivities(NewGameState);
}