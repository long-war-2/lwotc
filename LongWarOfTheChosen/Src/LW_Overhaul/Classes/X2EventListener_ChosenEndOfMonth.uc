// Author: Tedster
// function to update chosen knowledge at month end

class X2EventListener_ChosenEndOfMonth extends X2EventListener config(LW_Overhaul);

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
    local XComGameState_HeadquartersAlien AlienHQ;
    local array<XComGameState_AdventChosen> AllChosen;
    local XComGameState_AdventChosen ChosenState;
    local int ChosenNum;
    local array<int> RandomChosenKnowledgeGains;


	AlienHQ = XComGameState_HeadquartersAlien(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));

    AllChosen = AlienHQ.GetAllChosen(NewGameState);

    
    //grab the randomized values from the array set up in the LWOverhaulOptions
    RandomChosenKnowledgeGains = `LWOVERHAULOPTIONS.GetChosenKnowledgeGains_Randomized();
    
    foreach AllChosen(ChosenState)
	{
	    ChosenState = XComGameState_AdventChosen(NewGameState.ModifyStateObject(class'XComGameState_AdventChosen', ChosenState.ObjectID));

        if(ChosenState.bMetXCom != true)
            continue;
        // Force assign the chosen a number in the array to use instead of just iterating over the AllChosenArray randomly
        switch (ChosenState.GetMyTemplateName())
        {
            case 'Chosen_Assassin':
                ChosenNum=0;
                break;
            case 'Chosen_Warlock':
                ChosenNum=1;
                break;
            case 'Chosen_Sniper':
                ChosenNum=2;
                break;
        }
        //actually add the chosen knowledge to the chosen
	    ChosenState.ModifyKnowledgeScore(NewGameState, RandomChosenKnowledgeGains[ChosenNum]);
    }
    
    return ELR_NoInterrupt;
}

