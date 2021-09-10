class X2Action_FireLockon extends X2Action_Fire;

function Init()
{
	local XComGameState_Unit PrimaryTargetState;

	super.Init();

	PrimaryTargetState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));

	if (SourceUnitState != none && PrimaryTargetState != none)
	{
		if (SourceUnitState.HasClearanceToMaxZ() && PrimaryTargetState.HasClearanceToMaxZ())
		{
			AnimParams.AnimName = 'FF_IRI_FireLockon';	//	fire animation for top attack, rocket that's fired from the launcher is entirely cosmetic and flies to the sky
		}
		else
		{
			AnimParams.AnimName = 'FF_IRI_LockAndFireLockon'; // fire animation with simple direct shot, the projectile from the launcher is real
		}
	}
}