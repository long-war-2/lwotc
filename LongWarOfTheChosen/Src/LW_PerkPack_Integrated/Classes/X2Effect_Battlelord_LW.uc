class X2Effect_Battlelord_LW extends X2Effect_Battlelord;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMan;
	local Object EffectObj;

	EventMan = `XEVENTMGR;
	EffectObj = EffectGameState;
	EventMan.RegisterForEvent(EffectObj, 'UnitTakeEffectDamage', BattlelordListener_LW, ELD_OnStateSubmitted,,,, EffectGameState);
}




 static function EventListenerReturn BattlelordListener_LW(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_Unit TargetUnit, SourceUnit;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState NewGameState;
	local X2TacticalGameRuleset TacticalRules;
	local GameRulesCache_VisibilityInfo	VisInfo;
	local UnitValue BattlelordInterrupts;
	local XComGameState_Effect EffectState;

    TacticalRules = `TACTICALRULES;
    EffectState = XcomGameState_Effect(CallBackData);  
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	TargetUnit = XComGameState_Unit(EventData);

	if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
	{
		SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
		`assert(SourceUnit != none);
		if( !SourceUnit.IsAbleToAct() )
		{
			`redscreen("@dkaplan: Skirmisher Battlelord interruption was prevented due to the Skirmisher being Unable to Act.");
			return ELR_NoInterrupt;
		}
		SourceUnit.GetUnitValue('BattlelordInterrupts', BattlelordInterrupts);
		if (class'X2Ability_SkirmisherAbilitySet'.default.BATTLELORD_ACTIONS < 1 || class'X2Ability_SkirmisherAbilitySet'.default.BATTLELORD_ACTIONS > BattlelordInterrupts.fValue)
		{
			if (SourceUnit.IsFriendlyUnit(TargetUnit) || SourceUnit.ObjectID == TargetUnit.ObjectID)
			{
				TacticalRules = `TACTICALRULES;
				if (TacticalRules.VisibilityMgr.GetVisibilityInfo(SourceUnit.ObjectID, TargetUnit.ObjectID, VisInfo))
				{
					if (VisInfo.bClearLOS)
					{
						NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Battlelord Interrupt Initiative");
						SourceUnit = XComGameState_Unit(NewGameState.ModifyStateObject(SourceUnit.Class, SourceUnit.ObjectID));
						SourceUnit.SetUnitFloatValue('BattlelordInterrupts', BattlelordInterrupts.fValue + 1, eCleanup_BeginTactical);
						TacticalRules.InterruptInitiativeTurn(NewGameState, SourceUnit.GetGroupMembership().GetReference());
						TacticalRules.SubmitGameState(NewGameState);
					}
				}
			}
		}
	}

}


DefaultProperties
{
	DuplicateResponse = eDupe_Ignore
	EffectName = "Battlelord"
}