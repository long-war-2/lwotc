//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_RapidReaction
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Grants extra overwatch action points until you miss or hit a cap
//--------------------------------------------------------------------------------------- 

Class X2Effect_RapidReaction extends X2Effect_Persistent config (LW_SoldierSkills);

var config int RAPID_REACTION_USES_PER_TURN;
var config array<name> RAPID_REACTION_ABILITYNAMES;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Effect_EffectCounter	RapidReactionEffectState;
	local X2EventManager						EventMgr;
	local Object								ListenerObj, EffectObj;
	local XComGameState_Unit					UnitState;

	EventMgr = `XEVENTMGR;
	EffectObj = NewEffectState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(NewEffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	if (GetRapidReactionCounter(NewEffectState) == none)
	{
		RapidReactionEffectState = XComGameState_Effect_EffectCounter(NewGameState.CreateStateObject(class'XComGameState_Effect_EffectCounter'));
		RapidReactionEffectState.InitComponent();
		NewEffectState.AddComponentObject(RapidReactionEffectState);
		NewGameState.AddStateObject(RapidReactionEffectState);
	}
	ListenerObj = RapidReactionEffectState;
	if (ListenerObj == none)
	{
		`Redscreen("RapidReaction: Failed to find RapidReaction Component when registering listener");
		return;
	}

	if (UnitState.GetTeam() == eTeam_XCom)
	{
		EventMgr.RegisterForEvent(ListenerObj, 'XComTurnBegun', RapidReactionEffectState.ResetUses, ELD_OnStateSubmitted);
	}
	else
	{
		if (UnitState.GetTeam() == eTeam_Alien)
		{
			EventMgr.RegisterForEvent(ListenerObj, 'AlienTurnBegun', RapidReactionEffectState.ResetUses, ELD_OnStateSubmitted);
		}
	}
	EventMgr.RegisterForEvent(EffectObj, 'RapidReactionTriggered', NewEffectState.TriggerAbilityFlyover, ELD_OnStateSubmitted, , UnitState);
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameState_BaseObject EffectComponent;
	local Object EffectComponentObj;
	
	super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);

	EffectComponent = GetRapidReactionCounter(RemovedEffectState);
	if (EffectComponent == none)
		return;

	EffectComponentObj = EffectComponent;
	`XEVENTMGR.UnRegisterFromAllEvents(EffectComponentObj);

	NewGameState.RemoveStateObject(EffectComponent.ObjectID);
}

static function XComGameState_Effect_EffectCounter GetRapidReactionCounter(XComGameState_Effect Effect)
{
	if (Effect != none) 
		return XComGameState_Effect_EffectCounter(Effect.FindComponentObject(class'XComGameState_Effect_EffectCounter'));
	return none;
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local X2EventManager EventMgr;
	local XComGameState_Ability AbilityState;       //  used for looking up our source ability (RapidReaction), not the incoming one that was activated
	local XComGameState_Effect_EffectCounter	CurrentRapidReactionCounter, UpdatedRapidReactionCounter;
	local XComGameState_Unit					TargetUnit;
	local name ValueName;

	CurrentRapidReactionCounter = GetRapidReactionCounter(EffectState);
	If (CurrentRapidReactionCounter != none)	 
	{
		if (CurrentRapidReactionCounter.uses >= default.RAPID_REACTION_USES_PER_TURN)		
			return false;
	}
	if (XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID)) == none)
		return false;
	if (!AbilityContext.IsResultContextHit())
		return false;
	if (SourceUnit.ReserveActionPoints.Length != PreCostReservePoints.Length && default.RAPID_REACTION_ABILITYNAMES.Find(kAbility.GetMyTemplateName()) != -1)
	{
		AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
		if (AbilityState != none)
		{
			TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
			ValueName = name("OverwatchShot" $ TargetUnit.ObjectID);
			SourceUnit.SetUnitFloatValue (ValueName, 1.0, eCleanup_BeginTurn);
			SourceUnit.ReserveActionPoints = PreCostReservePoints;
			UpdatedRapidReactionCounter = XComGameState_Effect_EffectCounter(NewGameState.CreateStateObject(class'XComGameState_Effect_EffectCounter', CurrentRapidReactionCounter.ObjectID));
			UpdatedRapidReactionCounter.uses += 1;
			NewGameState.AddStateObject(UpdatedRapidReactionCounter);
			NewGameState.AddStateObject(SourceUnit);
			EventMgr = `XEVENTMGR;
			EventMgr.TriggerEvent('RapidReactionTriggered', AbilityState, SourceUnit, NewGameState);
		}
	}
	return false;
}