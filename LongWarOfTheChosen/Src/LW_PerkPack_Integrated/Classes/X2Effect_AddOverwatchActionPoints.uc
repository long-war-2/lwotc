//---------------------------------------------------------------------------------------
//  FILE:   X2Effect_AddOverwatchActionPoints.uc
//  AUTHOR:  Favid
//  PURPOSE: Unlike ReserveOverwatch action points, this effect does not automatically end unit's turn.
//---------------------------------------------------------------------------------------
//Peter, When you get back to modifying hero class abilities, switching interrupt's OW effect with this one should fix the free cost but ends turn issue
class X2Effect_AddOverwatchActionPoints extends X2Effect_ReserveOverwatchPoints;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnitState;
	local int i;

	TargetUnitState = XComGameState_Unit(kNewTargetState);
	if( TargetUnitState != none )
	{
		for (i = 0; i < NumPoints; ++i)
		{
			TargetUnitState.ReserveActionPoints.AddItem(GetReserveType(ApplyEffectParameters, NewGameState));
		}
	}
}