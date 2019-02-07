class X2AbilityCost_QuickdrawActionPoints_LW extends X2AbilityCost_QuickdrawActionPoints;

simulated function bool ConsumeAllPoints(XComGameState_Ability AbilityState, XComGameState_Unit AbilityOwner)
{
	if(AbilityOwner.HasSoldierAbility('Quickdraw'))
	{
		return false;
	}
    return super.ConsumeAllPoints(AbilityState, AbilityOwner);
}