class X2Effect_ReadyForAnything extends X2Effect_Persistent config(LW_AlienPack);

var config array<name> RFA_VALID_ABILITIES;
var config int RFA_ACTIVATIONS_PER_TURN;
var privatewrite bool bMatchSourceWeapon;
var privatewrite name CounterName;

static function EventListenerReturn AbilityTriggerEventListener_ReadyForAnything(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
    local XComGameState_Ability             EventAbilityState;
    local XComGameState_Ability             CallbackAbilityState;
    local XComGameStateContext_Ability      AbilityContext;

    EventAbilityState = XComGameState_Ability(EventData);
    CallbackAbilityState = XComGameState_Ability(CallbackData);
    AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

    if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
    {
        if (EventAbilityState != none && CallbackAbilityState != none)
        {
            if (default.bMatchSourceWeapon && CallbackAbilityState.SourceWeapon.ObjectID != 0 && CallbackAbilityState.SourceWeapon.ObjectID != AbilityContext.InputContext.ItemObject.ObjectID)
            {
                return ELR_NoInterrupt;
            }

            if (default.RFA_VALID_ABILITIES.Find(EventAbilityState.GetMyTemplateName()) != INDEX_NONE)
            {
                return CallbackAbilityState.AbilityTriggerEventListener_Self(EventData, EventSource, GameState, EventID, CallbackData);
            }
        }
    }

    return ELR_NoInterrupt;
}

defaultproperties
{
    bMatchSourceWeapon = true
    CounterName = ReadyForAnything_LW_Counter
}