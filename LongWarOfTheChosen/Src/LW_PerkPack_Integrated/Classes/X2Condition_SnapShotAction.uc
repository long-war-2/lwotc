//---------------------------------------------------------------------------------------
//  FILE:    X2Condition_SnapShotAction.uc
//  AUTHOR:  Merist
//  PURPOSE: Condition for Snap Shot abilities that fails if the soldier has enough
//           action points to use the normal one.
//---------------------------------------------------------------------------------------
class X2Condition_SnapShotAction extends X2Condition;

var name StandardAbilityName;
var bool bRequireStandardAbility;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
    local XComGameState_Unit        TargetState;
    local XComGameState_Ability     AbilityState;
    local X2AbilityTemplate         AbilityTemplate;
    local X2AbilityCost             Cost;
    local name AvailableCode;

    TargetState = XComGameState_Unit(kTarget);
    if (TargetState == none)
        return 'AA_NotAUnit';

    AbilityState = XComGameState_Ability(
        `XCOMHISTORY.GetGameStateForObjectID(TargetState.FindAbility(StandardAbilityName).ObjectID));

    if (AbilityState == none)
        return (bRequireStandardAbility ? 'AA_AbilityUnavailable' : 'AA_Success');

    AbilityTemplate = AbilityState.GetMyTemplate();

    foreach AbilityTemplate.AbilityCosts(Cost)
    {
        if (X2AbilityCost_ActionPoints(Cost) != none)
        {
            AvailableCode = Cost.CanAfford(AbilityState, TargetState);
            if (AvailableCode != 'AA_Success')
            {
                return 'AA_Success';
            }
        }
    }

    return 'AA_AbilityUnavailable';
}

defaultproperties
{
    bRequireStandardAbility = true
}