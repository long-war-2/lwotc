// Author: Tedster
// function to update chosen knowledge at month end

class X2EventListener_ChosenEndOfMonth extends X2EventListener config(LW_Overhaul);

var config int STARTING_CHOSEN_KNOWLEDGE_GAIN;
var config array<int> CHOSEN_KNOWLEDGE_GAINS;



static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2DataTemplate> Templates;

    // You can create any number of Event Listener templates within one X2EventListener class.
    Templates.AddItem(CreateListenerTemplate_LW_ChosenEOMListener());

    return Templates;
}

static function CHEventListenerTemplate CreateListenerTemplate_LW_ChosenEOMListener()
{
    local CHEventListenerTemplate Template;

    `CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'LW_ChosenEOMListener');

    // Whether this Listener should be active during tactical missions.
    Template.RegisterInTactical = false;
    // Whether this Listener should be active on the strategic layer (while on Avenger)
    Template.RegisterInStrategy = true;

    Template.AddCHEvent('PreEndOfMonth', LW_ChosenEOM_Listener, ELD_Immediate, 50);

    return Template;
}

static function EventListenerReturn LW_ChosenEOM_Listener(Object EventData, Object EventSource, XComGameState NewGameState, Name Event, Object CallbackData)
{
    local XComGameState_AdventChosen ChosenState;
    local array<int> RandomChosenKnowledgeGains;
    local array<XComGameState_ResistanceFaction> AllFactions;
    local XComGameState_ResistanceFaction FactionState;
    local XComGameState_HeadquartersResistance ResistanceHQ;



    ResistanceHQ = XComGameState_HeadquartersResistance(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));


    AllFactions = ResistanceHQ.GetAllFactions();

    foreach AllFactions(FactionState)
    {
        ChosenState = FactionState.GetRivalChosen();

        // short circuits
        if(ChosenState.bMetXCom != true || ChosenState.bDefeated == true)
            continue;

        if(FactionState.bFirstFaction)
        {
            ChosenState = XComGameState_AdventChosen(NewGameState.ModifyStateObject(class'XComGameState_AdventChosen', ChosenState.ObjectID));
            `LWTrace("Adding" @ default.STARTING_CHOSEN_KNOWLEDGE_GAIN @ "To Chosen" @ `SHOWVAR(ChosenState.GetMyTemplateName()));
            ChosenState.ModifyKnowledgeScore(NewGameState, default.STARTING_CHOSEN_KNOWLEDGE_GAIN);
        }
        else if (FactionState.bFarthestFaction)
        {
            `LWTrace("Adding" @ default.CHOSEN_KNOWLEDGE_GAINS[1] @ "To Chosen" @ `SHOWVAR(ChosenState.GetMyTemplateName()));
            ChosenState.ModifyKnowledgeScore(NewGameState, default.CHOSEN_KNOWLEDGE_GAINS[1]);
        }
        else // Middle Faction
        {
            `LWTrace("Adding" @ default.CHOSEN_KNOWLEDGE_GAINS[0] @ "To Chosen" @ `SHOWVAR(ChosenState.GetMyTemplateName()));
            ChosenState.ModifyKnowledgeScore(NewGameState, default.CHOSEN_KNOWLEDGE_GAINS[0]);
        }

    }

    
    //grab the randomized values from the array set up in the LWOverhaulOptions
    /*RandomChosenKnowledgeGains = `LWOVERHAULOPTIONS.GetChosenKnowledgeGains_Randomized();
    
    foreach AllChosen(ChosenState)
	{
	    ChosenState = XComGameState_AdventChosen(NewGameState.ModifyStateObject(class'XComGameState_AdventChosen', ChosenState.ObjectID));

        // short circuit if chosen aren't active yet.
        if(ChosenState.bMetXCom != true)
            continue;

        // short circuit if chosen is defeated.
        if(ChosenState.bDefeated == true)
            continue;

        //actually add the chosen knowledge to the chosen.
        switch (ChosenState.GetMyTemplateName())
        {       
            case `LWOVERHAULOPTIONS.StartingChosen:
                `LWTrace("Adding" @ default.STARTING_CHOSEN_KNOWLEDGE_GAIN @ "To Chosen" @ `SHOWVAR(ChosenState.GetMyTemplateName()));
                ChosenState.ModifyKnowledgeScore(NewGameState, default.STARTING_CHOSEN_KNOWLEDGE_GAIN);
                break;
            case `LWOVERHAULOPTIONS.ChosenNames[0]:
                `LWTrace("Adding" @ CHOSEN_KNOWLEDGE_GAINS[0] @ "To Chosen" @ `SHOWVAR(ChosenState.GetMyTemplateName()));
                ChosenState.ModifyKnowledgeScore(NewGameState, CHOSEN_KNOWLEDGE_GAINS[0]);
                break;
            case `LWOVERHAULOPTIONS.ChosenNames[1]:
                `LWTrace("Adding" @ CHOSEN_KNOWLEDGE_GAINS[1] @ "To Chosen" @ `SHOWVAR(ChosenState.GetMyTemplateName()));
                ChosenState.ModifyKnowledgeScore(NewGameState, CHOSEN_KNOWLEDGE_GAINS[1]);
                break;
        }
       
	    
    }
     */
    
    return ELR_NoInterrupt;
}

