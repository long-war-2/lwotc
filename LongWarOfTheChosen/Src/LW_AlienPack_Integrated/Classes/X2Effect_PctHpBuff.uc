class X2Effect_PctHpBuff extends X2Effect_Persistent;

var float Pctbuff;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComGameState_Unit kTargetUnitState; 
    local int OriginalHP;
    super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);

	kTargetUnitState = XComGameState_Unit(kNewTargetState);

    if( kTargetUnitState != None )
    {

        OriginalHP = kTargetUnitState.GetMaxStat(eStat_HP); 

        kTargetUnitState.SetBaseMaxStat( eStat_HP, OriginalHP * Pctbuff);
        kTargetUnitState.SetCurrentStat( eStat_HP, kTargetUnitState.GetMaxStat(eStat_HP));
    }
}