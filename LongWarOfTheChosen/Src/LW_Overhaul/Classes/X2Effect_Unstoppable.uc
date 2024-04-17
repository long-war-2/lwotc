//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_Unstoppable.uc
//  AUTHOR:	 Musashi, modified by Grobobobo
//  PURPOSE: Creates an effect that can cap a stat to a certain point
//--------------------------------------------------------------------------------------- 

class X2Effect_Unstoppable extends X2Effect_PersistentStatChange;

var array<X2Condition> Conditions;

struct StatCap
{
	var ECharStatType StatType;
	var float StatCapValue;
	var bool IsMinimum; // If true, the cap means that the stat cannot go lower than the amount, if false, the higher
};

var array<StatCap> StatCaps; 

function AddStatCap(ECharStatType StatType, float StatCapValue, bool IsMinimum)
{
	local StatCap Cap;
	
	Cap.StatType = StatType;
	Cap.StatCapValue = StatCapValue;
	Cap.IsMinimum = IsMinimum;
	StatCaps.AddItem(Cap);
}

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
	EventMgr.RegisterForEvent(ListenerObj, 'UnitGroupTurnBegun', EventHandler, ELD_OnStateSubmitted, 25, UnitState,, EffectGameState);	
	EventMgr.RegisterForEvent(ListenerObj, 'UnitAttacked', EventHandler, ELD_OnStateSubmitted, 25,,, EffectGameState);
	//EventMgr.RegisterForEvent(ListenerObj, 'AbilityActivated', EventHandler, ELD_OnStateSubmitted, 150,,, EffectGameState);	

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

	`LWTrace("Unstoppable: listener started.");

	EffectState = XComGameState_Effect_CapStats(CallbackData);
	if (EffectState == none)
		return ELR_NoInterrupt;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	SourceUnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));

	EffectTemplate = X2Effect_Unstoppable(EffectState.GetX2Effect());

	bOldApplicable = EffectState.StatChanges.Length > 0;
	//bNewApplicable = class'XMBEffectUtilities'.static.CheckTargetConditions(EffectTemplate.Conditions, EffectState, SourceUnitState, UnitState, AbilityState) == 'AA_Success';

	foreach EffectState.m_aStatCaps(LocalStatCap)
	{
		`LWTrace("Unstoppable: Current stat value:" @UnitState.GetCurrentStat(LocalStatCap.StatType) @"; Base stat:" @UnitState.GetBaseStat(LocalStatCap.StatType));
		if(UnitState.GetCurrentStat(LocalStatCap.StatType) < LocalStatCap.StatCapValue || UnitState.GetCurrentStat(LocalStatCap.StatType) > UnitState.GetBaseStat(LocalStatCap.StatType))
		{
			bNewApplicable = true;
		}
	}

	if(bNewApplicable)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Unstoppable Stat Change");

		NewUnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', UnitState.ObjectID));
		NewEffectState = XComGameState_Effect_CapStats(NewGameState.ModifyStateObject(class'XComGameState_Effect', EffectState.ObjectID));

		foreach EffectState.m_aStatCaps(LocalStatCap)
		{
			`LWTrace("Unstoppable: statcap loop:" @LocalStatCap.StatType);
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
					`LWTrace("Unstoppable: adding stat mod for stattype:" @LocalStatCap.StatType @"value:" @NewStatAmount);
					LocalStatChange.StatType = LocalStatCap.StatType;
					LocalStatChange.StatAmount = NewStatAmount;
					LocalStatChange.ModOp = MODOP_Addition;
					LocalStatChanges.AddItem(LocalStatChange);
				}
			}
		}

		if (LocalStatChanges.Length > 0)
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


// From X2Effect_Persistent.
function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
	return EffectGameState.StatChanges.Length > 0;
}

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local StatCap LocalStatCap;
	local XComGameState_Effect_CapStats EffectState;


	EffectState = XComGameState_Effect_CapStats(NewEffectState);

	foreach StatCaps(LocalStatCap)
	{
		EffectState.AddCap(LocalStatCap);
	}


	super(X2Effect_Persistent).OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}


defaultproperties
{
	GameStateEffectClass = class'XComGameState_Effect_CapStats'
}