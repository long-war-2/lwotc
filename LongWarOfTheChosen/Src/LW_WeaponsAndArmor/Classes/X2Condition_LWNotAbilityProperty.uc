class X2Condition_LWNotAbilityProperty extends X2Condition_AbilityProperty;


event name AbilityMeetsCondition(XComGameState_Ability kAbility,XComGameState_BaseObject kTarget)
{
   local name previousResult;

    previousResult = super.AbilityMeetsCondition(kAbility, kTarget);

    if(previousResult != 'AA_Success')
    {
        return 'AA_Success';
    }
    else
    {
        return 'AA_AbilityUnavailable';
    }
}