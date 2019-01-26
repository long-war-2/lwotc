Class X2Effect_Sentinel_LW extends X2Effect_Persistent config (LW_SoldierSkills);

var config int SENTINEL_LW_USES_PER_TURN;
var config array<name> SENTINEL_LW_ABILITYNAMES;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Effect_EffectCounter	Sentinel_LWEffectState;
	local X2EventManager						EventMgr;
	local Object								ListenerObj, EffectObj;
	local XComGameState_Unit					UnitState;

	EventMgr = `XEVENTMGR;
	EffectObj = NewEffectState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(NewEffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	if (GetSentinel_LWCounter(NewEffectState) == none)
	{
		Sentinel_LWEffectState = XComGameState_Effect_EffectCounter(NewGameState.CreateStateObject(class'XComGameState_Effect_EffectCounter'));
		Sentinel_LWEffectState.InitComponent();
		NewEffectState.AddComponentObject(Sentinel_LWEffectState);
		NewGameState.AddStateObject(Sentinel_LWEffectState);
	}
	ListenerObj = Sentinel_LWEffectState;
	if (ListenerObj == none)
	{
		`Redscreen("Sentinel_LW: Failed to find Sentinel_LW Component when registering listener");
		return;
	}

	if (UnitState.GetTeam() == eTeam_XCom)
	{
		EventMgr.RegisterForEvent(ListenerObj, 'XComTurnBegun', Sentinel_LWEffectState.ResetUses, ELD_OnStateSubmitted);
	}
	else
	{
		if (UnitState.GetTeam() == eTeam_Alien)
		{
			EventMgr.RegisterForEvent(ListenerObj, 'AlienTurnBegun', Sentinel_LWEffectState.ResetUses, ELD_OnStateSubmitted);
		}
	}
	
	EventMgr.RegisterForEvent(EffectObj, 'Sentinel_LWTriggered', NewEffectState.TriggerAbilityFlyover, ELD_OnStateSubmitted, , UnitState);
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameState_BaseObject EffectComponent;
	local Object EffectComponentObj;
	
	super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);

	EffectComponent = GetSentinel_LWCounter(RemovedEffectState);
	if (EffectComponent == none)
		return;

	EffectComponentObj = EffectComponent;
	`XEVENTMGR.UnRegisterFromAllEvents(EffectComponentObj);

	NewGameState.RemoveStateObject(EffectComponent.ObjectID);
}

static function XComGameState_Effect_EffectCounter GetSentinel_LWCounter(XComGameState_Effect Effect)
{
	if (Effect != none) 
		return XComGameState_Effect_EffectCounter(Effect.FindComponentObject(class'XComGameState_Effect_EffectCounter'));
	return none;
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local X2EventManager						EventMgr;
	local XComGameState_Ability					AbilityState;       //  used for looking up our source ability (Sentinel_LW), not the incoming one that was activated
	local XComGameState_Effect_EffectCounter	CurrentSentinelCounter, UpdatedSentinelCounter;
	local XComGameState_Unit					TargetUnit;
	local name ValueName;

	CurrentSentinelCounter = GetSentinel_LWCounter(EffectState);
	If (CurrentSentinelCounter != none)	 
	{
		if (CurrentSentinelCounter.uses >= default.SENTINEL_LW_USES_PER_TURN)		
			return false;
	}
	if (XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID)) == none)
		return false;
	if (SourceUnit.ReserveActionPoints.Length != PreCostReservePoints.Length && default.SENTINEL_LW_ABILITYNAMES.Find(kAbility.GetMyTemplateName()) != -1)
	{
		AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));		
		if (AbilityState != none)
		{
			TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
			ValueName = name("OverwatchShot" $ TargetUnit.ObjectID);
			SourceUnit.SetUnitFloatValue (ValueName, 1.0, eCleanup_BeginTurn);
			//`LOG ("RR Code setting" @ ValueName);
			SourceUnit.ReserveActionPoints = PreCostReservePoints;
			UpdatedSentinelCounter = XComGameState_Effect_EffectCounter(NewGameState.CreateStateObject(class'XComGameState_Effect_EffectCounter', CurrentSentinelCounter.ObjectID));
			UpdatedSentinelCounter.uses += 1;
			NewGameState.AddStateObject(UpdatedSentinelCounter);
			NewGameState.AddStateObject(SourceUnit);
			EventMgr = `XEVENTMGR;
			EventMgr.TriggerEvent('Sentinel_LWTriggered', AbilityState, SourceUnit, NewGameState);
		}
	}
	return false;
}