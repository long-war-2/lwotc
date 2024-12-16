class X2Effect_RemoveTurnStartActionPoints extends X2Effect_Persistent;


function ModifyTurnStartActionPoints(XComGameState_Unit UnitState, out array<name> ActionPoints, XComGameState_Effect EffectState)
{
	ActionPoints.Length = 0;
}