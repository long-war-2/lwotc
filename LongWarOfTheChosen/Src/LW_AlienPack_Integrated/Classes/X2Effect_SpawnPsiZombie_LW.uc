class X2Effect_SpawnPsiZombie_LW extends X2Effect_SpawnPsiZombie;


function name GetUnitToSpawnName(const out EffectAppliedData ApplyEffectParameters)
{
	local XComGameState_Unit TargetUnitState, SourceUnitState;
	local XComGameStateHistory History;
	local XComHumanPawn HumanPawn;
	local name UnitName;

	History = `XCOMHISTORY;

	SourceUnitState = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	TargetUnitState = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	`assert(TargetUnitState != none);

	UnitName = UnitToSpawnName;
	HumanPawn = XComHumanPawn(XGUnit(History.GetVisualizer(TargetUnitState.ObjectID)).GetPawn());
	if( HumanPawn != None )
	{
        switch(SourceUnitState.GetMyTemplateName())
        {
            case 'Sectoid':
                return 'PsiZombieHuman';
            case 'SectoidM2_LW':
                return 'PsiZombieHumanM2';
            case 'GateKeeper':
            case 'SectoidM3_LW':
                return 'PsiZombieHumanM3';
            case 'GateKeeperM2':
            case 'SectoidM4_LW':
                return 'PsiZombieHumanM4';
            case 'GateKeeperM3':
            case 'SectoidM5_LW':
                return 'PsiZombieHumanM5';
            default:                
                return 'PsiZombieHuman';
        }
		UnitName = AltUnitToSpawnName;
	}
    else
    {
        switch(SourceUnitState.GetMyTemplateName())
        {
            case 'Sectoid':
                return 'PsiZombie';
            case 'SectoidM2_LW':
                return 'PsiZombieM2';
            case 'GateKeeper':
            case 'SectoidM3_LW':
                return 'PsiZombieM3';
            case 'GateKeeperM2':
            case 'SectoidM4_LW':
                return 'PsiZombieM4';
            case 'GateKeeperM3':
            case 'SectoidM5_LW':
                return 'PsiZombieM5';
            default:                
            return 'PsiZombie';

        }
    }

	return UnitName;
}