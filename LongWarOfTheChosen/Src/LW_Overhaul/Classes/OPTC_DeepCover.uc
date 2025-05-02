class OPTC_DeepCover extends X2DownloadableContentInfo;

static event OnPostTemplatesCreated()
{
    local X2AbilityTemplateManager AbilityTemplateManager;

    AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

    PatchDeepCover(AbilityTemplateManager.FindAbilityTemplate('DeepCoverTrigger'));
}

static function PatchDeepCover(X2AbilityTemplate Template)
{
    local X2AbilityTrigger                  Trigger;
    local X2AbilityTrigger_EventListener    EventTrigger;
    local XComGameState_Ability             WhyIsThisAThing;

    if (Template != none)
    {
        WhyIsThisAThing = XComGameState_Ability(class'XComEngine'.static.GetClassDefaultObjectByName('XComGameState_Ability'));
        foreach Template.AbilityTriggers(Trigger)
        {
            EventTrigger = X2AbilityTrigger_EventListener(Trigger);
            if (EventTrigger != none)
            {
                if (EventTrigger.ListenerData.EventFn == WhyIsThisAThing.static.DeepCoverTurnEndListener)
                {
                    EventTrigger.ListenerData.EventFn = DeepCoverListener;
                }
            }
        }
    }
}

static function EventListenerReturn DeepCoverListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameStateHistory              History;
    local XComGameState                     NewGameState;
    local XComGameState_Unit                UnitState;
    local XComGameState_Ability             AbilityState;
    local X2AbilityTemplate                 AbilityTemplate;
    local StateObjectReference              HunkerDownRef;
    local XComGameState_Ability             HunkerDownState;
    local X2AbilityCost                     AbilityCost;
    local X2AbilityCost_ActionPoints        ActionPointCost;
    local UnitValue                         AttacksThisTurn;
    local bool                              bFoundDeepCoverCost;

    History = `XCOMHISTORY;
    AbilityState = XComGameState_Ability(CallbackData);
    UnitState = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
    if (UnitState == none)
        UnitState = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));

    if (UnitState != none && !UnitState.IsHunkeredDown())
    {
        if (!UnitState.GetUnitValue('AttacksThisTurn', AttacksThisTurn) || AttacksThisTurn.fValue == 0)
        {
            foreach UnitState.Abilities(HunkerDownRef)
            {
                HunkerDownState = XComGameState_Ability(History.GetGameStateForObjectID(HunkerDownRef.ObjectID));
                AbilityTemplate = HunkerDownState.GetMyTemplate();
                bFoundDeepCoverCost = false;
                foreach AbilityTemplate.AbilityCosts(AbilityCost)
                {
                    ActionPointCost = X2AbilityCost_ActionPoints(AbilityCost);
                    if (ActionPointCost != none &&
                        ActionPointCost.AllowedTypes.Find(class'X2CharacterTemplateManager'.default.DeepCoverActionPoint) != INDEX_NONE)
                    {
                        bFoundDeepCoverCost = true;
                        break;
                    }
                }
                if (bFoundDeepCoverCost && HunkerDownState.CanActivateAbility(UnitState, , true) == 'AA_Success')
                {
                    if (UnitState.NumActionPoints() == 0)
                    {
                        NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
                        UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(UnitState.Class, UnitState.ObjectID));
                        UnitState.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.DeepCoverActionPoint);
                        `TACTICALRULES.SubmitGameState(NewGameState);
                    }

                    return HunkerDownState.AbilityTriggerEventListener_Self(EventData, EventSource, GameState, EventID, CallbackData);
                }   
            }
        }
    }

    return ELR_NoInterrupt;
}