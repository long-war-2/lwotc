//---------------------------------------------------------------------------------------
//  FILE:    LWTutorial.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Contains the elements of the LWOTC tutorial, such as functions to
//           display the tutorial boxes and the content to go in them.
//--------------------------------------------------------------------------------------- 

class LWTutorial extends Object;

var localized string CampaignStartTitle;
var localized string CampaignStartBody;

static function DoCampaignStart()
{
	if (!class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('LW_TUT_CampaignStart'))
    {
		class'LWTutorial'.static.CompleteObjective('LW_TUT_CampaignStart');
        `PRESBASE.UITutorialBox(
            default.CampaignStartTitle,
            default.CampaignStartBody,
            "img:///UILibrary_LW_Overhaul.TutorialImages.LWOTC_Logo");
    }
}

// Completes an objective, creating a new game state for the change if no game
// state is provided.
static function CompleteObjective(name TutorialObjectiveName, optional XComGameState NewGameState)
{
    local bool DoGameStateSubmit;

    if (NewGameState == none)
    {
        NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Complete Objective: " $ TutorialObjectiveName);
        DoGameStateSubmit = true;
    }

    class'XComGameState_Objective'.static.CompleteObjectiveByName(NewGameState, TutorialObjectiveName);

    if (DoGameStateSubmit)
    {
	    `XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
    }
}
