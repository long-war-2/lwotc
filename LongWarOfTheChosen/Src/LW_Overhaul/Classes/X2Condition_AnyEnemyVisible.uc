class X2Condition_AnyEnemyVisible extends X2Condition;

var X2Condition_UnitProperty AliveUnitPropertyCondition;
var X2Condition_Visibility SquadsightVisibilityCondition;

event name CallMeetsCondition(XComGameState_BaseObject kTarget) 
{ 
	local int Index;
	local XComGameStateHistory History;
	local X2GameRulesetVisibilityManager VisibilityMgr;	
	local XComGameState_unit SourceState;
	local array<X2Condition> RequiredConditions;
	local array<StateObjectReference> VisibleUnits;
	History = `XCOMHISTORY;
	VisibilityMgr = `TACTICALRULES.VisibilityMgr;

	SourceState = XComGameState_Unit(History.GetGameStateForObjectID(kTarget.ObjectID, , ));

	RequiredConditions.AddItem(default.SquadsightVisibilityCondition);
	RequiredConditions.AddItem(default.AliveUnitPropertyCondition);

	VisibilityMgr.GetAllVisibleToSource(kTarget.ObjectID, VisibleUnits, class'XComGameState_Unit',, RequiredConditions);

	for( Index = VisibleUnits.Length - 1; Index > -1; --Index )
	{
		//Remove non-enemies from the list
		if( SourceState.TargetIsEnemy(VisibleUnits[Index].ObjectID, ) )
		{
			
			return 'AA_Success';
			
		}
	}

    return 'AA_NoTargets';


}

DefaultProperties
{	
	Begin Object Class=X2Condition_Visibility Name=DefaultSquadSightVisibilityCondition
	bRequireGameplayVisible=TRUE
	bAllowSquadsight=TRUE
	End Object	
	SquadsightVisibilityCondition = DefaultSquadSightVisibilityCondition


	Begin Object Class=X2Condition_UnitProperty Name=DefaultAliveUnitPropertyCondition
		ExcludeAlive=FALSE;
		ExcludeDead=TRUE;
		ExcludeRobotic=FALSE;
		ExcludeOrganic=FALSE;
		ExcludeHostileToSource=FALSE;
		ExcludeFriendlyToSource=FALSE;
	End Object
	AliveUnitPropertyCondition = DefaultAliveUnitPropertyCondition;

}