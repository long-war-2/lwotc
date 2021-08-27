class X2Effect_Suppression_LW extends X2Effect_Suppression config(GameCore);


function ModifyTurnStartActionPoints(XComGameState_Unit UnitState, out array<name> ActionPoints, XComGameState_Effect EffectState)
{

	if(UnitState.CanTakeCover())
	{	
		if(ActionPoints.Length > 1) //Make so multiple suppressions don't completely disable an enemy
		{
			ActionPoints.Remove(0, 1);
		}
	}

}