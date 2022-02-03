class X2Condition_OwnerDoesNotHaveAbility extends X2Condition;

var name AbilityName;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{
    local XComGameState_Unit Source;

    Source = XComGameState_Unit(kSource);

    if (Source != None)
    {
        if (!Source.HasSoldierAbility(AbilityName))
        {
            return 'AA_Success';
        }
    }
    return 'AA_AbilityUnavailable';
}
