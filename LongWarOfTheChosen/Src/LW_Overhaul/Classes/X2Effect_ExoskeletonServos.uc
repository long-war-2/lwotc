//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_ExoskeletonServos.uc
//  AUTHOR:	  Grobobobo
//  PURPOSE: Creates an effect that can cap a stat to a certain point
//--------------------------------------------------------------------------------------- 

class X2Effect_ExoskeletonServos extends X2Effect_Unstoppable;


function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local XComGameState_Unit UnitState;
	local X2EventManager EventMgr;
	local Object ListenerObj;

	EventMgr = `XEVENTMGR;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	ListenerObj = EffectGameState;

	// Register to tick after EVERY action.
	EventMgr.RegisterForEvent(ListenerObj, 'OnUnitBeginPlay', EventHandler, ELD_OnStateSubmitted, 25, UnitState,, EffectGameState);	
	//EventMgr.RegisterForEvent(ListenerObj, 'UnitAttacked', EventHandler, ELD_OnStateSubmitted, 25,,, EffectGameState);
	EventMgr.RegisterForEvent(ListenerObj, 'AbilityActivated', EventHandler, ELD_OnStateSubmitted, 150,,, EffectGameState);	

}

static function EventListenerReturn EventHandler(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_Unit UnitState, SourceUnitState, NewUnitState;
	local XComGameState_Effect_CapStats NewEffectState;
	local XComGameState_Ability AbilityState;
	local XComGameState NewGameState;
	local X2Effect_Unstoppable EffectTemplate;
	local XComGameState_Effect_CapStats EffectState;
	local bool bOldApplicable, bNewApplicable;
	local array<StatChange> LocalStatChanges;
	local StatChange LocalStatChange;
	local StatCap LocalStatCap;
	local int AppliedStatChangeIndex, StatChangeOther;
	local float AppliedStatChange, CappedStat, NewStatAmount;
	local UnitValue ImmobilizeValue;

	EffectState = XComGameState_Effect_CapStats(CallbackData);
	if (EffectState == none)
		return ELR_NoInterrupt;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	SourceUnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));

	EffectTemplate = X2Effect_Unstoppable(EffectState.GetX2Effect());

	bOldApplicable = EffectState.StatChanges.Length > 0;
	bNewApplicable = class'XMBEffectUtilities'.static.CheckTargetConditions(EffectTemplate.Conditions, EffectState, SourceUnitState, UnitState, AbilityState) == 'AA_Success';

	if (bOldApplicable != bNewApplicable)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Conditional Stat Change");

		NewUnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', UnitState.ObjectID));
		NewEffectState = XComGameState_Effect_CapStats(NewGameState.ModifyStateObject(class'XComGameState_Effect', EffectState.ObjectID));

		foreach EffectState.m_aStatCaps(LocalStatCap)
		{
			AppliedStatChangeIndex = NewEffectState.StatChanges.Find('StatType', LocalStatCap.StatType);
			AppliedStatChange = (AppliedStatChangeIndex != INDEX_NONE) ?
				NewEffectState.StatChanges[AppliedStatChangeIndex].StatAmount :
				0.0;

				StatChangeOther = NewUnitState.GetCurrentStat(LocalStatCap.StatType) - AppliedStatChange;


			CappedStat = LocalStatCap.IsMinimum ? 
			Max(StatChangeOther, LocalStatCap.StatCapValue):
			Min(StatChangeOther, LocalStatCap.StatCapValue);


			NewStatAmount = CappedStat - StatChangeOther;
			if (NewStatAmount != 0.0)
			{
				//Check for maim
				NewUnitState.GetUnitValue(class'X2Ability_DefaultAbilitySet'.default.ImmobilizedValueName, ImmobilizeValue);

				if(ImmobilizeValue.fValue == 0)
				{
					LocalStatChange.StatType = LocalStatCap.StatType;
					LocalStatChange.StatAmount = NewStatAmount;
					LocalStatChange.ModOp = MODOP_Addition;
					LocalStatChanges.AddItem(LocalStatChange);

				}
			}
		}

		if (bNewApplicable)
		{
			NewEffectState.StatChanges = LocalStatChanges;

			// Note: ApplyEffectToStats crashes the game if the state objects aren't added to the game state yet
			NewUnitState.ApplyEffectToStats(NewEffectState, NewGameState);
		}
		else
		{
			NewUnitState.UnApplyEffectFromStats(NewEffectState, NewGameState);
			NewEffectState.StatChanges.Length = 0;
		}

		`GAMERULES.SubmitGameState(NewGameState);
	}

	return ELR_NoInterrupt;
}

defaultproperties
{
	GameStateEffectClass = class'XComGameState_Effect_CapStats'
}