//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_SkirmisherInterrupt_LW.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: Makes interrupt behave a lot more consistently.
//---------------------------------------------------------------------------------------
class X2Effect_SkirmisherInterrupt_LW extends X2Effect_SkirmisherInterrupt config(LW_FactionBalance);

var config int MAX_INTERRUPTS;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMan;
	local Object EffectObj;

	EventMan = `XEVENTMGR;
	EffectObj = EffectGameState;
	EventMan.RegisterForEvent(EffectObj, 'ExhaustedActionPoints', InterruptListener_LW, ELD_OnStateSubmitted,,,, EffectGameState);
}


simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnit;
	local XComGameState_AIGroup GroupState;

	TargetUnit = XComGameState_Unit(kNewTargetState);
	GroupState = TargetUnit.GetGroupMembership();

	TargetUnit.SetUnitFloatValue('SkirmisherInterruptOriginalGroup', GroupState.ObjectID, eCleanup_BeginTactical);

	GroupState = XComGameState_AIGroup(NewGameState.CreateNewStateObject(class'XComGameState_AIGroup'));	
	GroupState.AddUnitToGroup(TargetUnit.ObjectID, NewGameState);
	GroupState.bSummoningSicknessCleared = true;
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameState_Unit TargetUnit;
	local XComGameState_AIGroup GroupState;
	local UnitValue GroupValue;

	TargetUnit = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', ApplyEffectParameters.TargetStateObjectRef.ObjectID));

    TargetUnit.SetUnitFloatValue('NumOfInterrupts', 0);

	GroupState = TargetUnit.GetGroupMembership();
	`assert(GroupState.m_arrMembers.Length == 1 && GroupState.m_arrMembers[0].ObjectID == TargetUnit.ObjectID);
	NewGameState.RemoveStateObject(GroupState.ObjectID);

	TargetUnit.GetUnitValue('SkirmisherInterruptOriginalGroup', GroupValue);
	GroupState = XComGameState_AIGroup(NewGameState.ModifyStateObject(class'XComGameState_AIGroup', GroupValue.fValue));
	GroupState.AddUnitToGroup(TargetUnit.ObjectID, NewGameState);
	TargetUnit.ClearUnitValue('SkirmisherInterruptOriginalGroup');
}

function ModifyTurnStartActionPoints(XComGameState_Unit UnitState, out array<name> ActionPoints, XComGameState_Effect EffectState)
{
	local UnitValue GroupValue;
	local XComGameState_AIGroup GroupState;

	GroupState = UnitState.GetGroupMembership();
	UnitState.GetUnitValue('SkirmisherInterruptOriginalGroup', GroupValue);

	if (GroupState.ObjectID != GroupValue.fValue && UnitState.IsAbleToAct())
	{
		ActionPoints.Length = 0;
		ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.SkirmisherInterruptActionPoint);
	}	
}


static function EventListenerReturn InterruptListener_LW(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_Unit TargetUnit, SourceUnit;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState NewGameState;
	local X2TacticalGameRuleset TacticalRules;
	local GameRulesCache_VisibilityInfo	VisInfo;
	local UnitValue NumOfInterrupts;
	local XComGameState_Effect EffectGameState;

	EffectGameState = XComGameState_Effect(CallbackData);

	TargetUnit = XComGameState_Unit(EventData);
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
	{
		SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
		`assert(SourceUnit != none);
		if( !SourceUnit.IsAbleToAct() )
		{
			`redscreen("@dkaplan: Skirmisher Interrupt was prevented due to the Skirmisher being Unable to Act.");
			return ELR_NoInterrupt;
		}
		SourceUnit.GetUnitValue('NumOfInterrupts', NumOfInterrupts);
		if (default.MAX_INTERRUPTS < 1 || default.MAX_INTERRUPTS > NumOfInterrupts.fValue)
		{
			if (SourceUnit.IsEnemyUnit(TargetUnit) && TargetUnit.GetTeam() != eTeam_TheLost)
			{
				TacticalRules = `TACTICALRULES;
				if (TacticalRules.VisibilityMgr.GetVisibilityInfo(SourceUnit.ObjectID, TargetUnit.ObjectID, VisInfo))
				{
					if (VisInfo.bClearLOS)
					{
						NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Interrupt Initiative");
						SourceUnit = XComGameState_Unit(NewGameState.ModifyStateObject(SourceUnit.Class, SourceUnit.ObjectID));
						SourceUnit.SetUnitFloatValue('NumOfInterrupts', NumOfInterrupts.fValue + 1, eCleanup_BeginTactical);
						TacticalRules.InterruptInitiativeTurn(NewGameState, SourceUnit.GetGroupMembership().GetReference());
						TacticalRules.SubmitGameState(NewGameState);
					}
				}
			}
		}
	}
	return ELR_NoInterrupt;
}

DefaultProperties
{
	EffectName = "SkirmisherInterrupt"
	DuplicateResponse = eDupe_Ignore
}