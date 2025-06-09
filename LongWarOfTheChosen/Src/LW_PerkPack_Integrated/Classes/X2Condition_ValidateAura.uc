//---------------------------------------------------------------------------------------
//  FILE:    X2Condition_ValidateAura.uc
//  AUTHOR:  Merist
//  PURPOSE: Condition for the auras that fails / succeeds if the ability that would reapply the effect can be triggered against the target
//           reapply the effect can be triggered against the target.
//           Made to avoid removing the effect when not needed.
//---------------------------------------------------------------------------------------
class X2Condition_ValidateAura extends X2Condition;

var name UpdateAbilityName;
var bool bFailIfAvailable;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{
    local XComGameState_Unit        TargetState, SourceState;
    local XComGameState_Ability     AbilityState;

    TargetState = XComGameState_Unit(kTarget);
    if (TargetState == none)
        return 'AA_NotAUnit';
        
    SourceState = XComGameState_Unit(kSource);
    if (SourceState == none)
        return 'AA_NotAUnit';

    AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(SourceState.FindAbility(UpdateAbilityName).ObjectID));
    if (AbilityState != none && AbilityState.CanActivateAbilityForObserverEvent(kTarget) == 'AA_Success')
    {
        // `LOG("Aura update ability can be activated against" $ XComGameState_Unit(kTarget).GetMyTemplateName(), true, 'MeristAuraCondition');
        return (bFailIfAvailable ? 'AA_AbilityUnavailable' : 'AA_Success');
    }

    // `LOG("Aura update ability cannot be activated agaisnt " $ XComGameState_Unit(kTarget).GetMyTemplateName(), true, 'MeristAuraCondition');
    return (bFailIfAvailable ? 'AA_Success' : 'AA_AbilityUnavailable');
}

defaultproperties
{
    bFailIfAvailable = true
}