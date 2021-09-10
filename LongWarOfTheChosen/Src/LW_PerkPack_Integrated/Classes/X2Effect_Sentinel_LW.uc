class X2Effect_Sentinel_LW extends X2Effect_Persistent config (LW_SoldierSkills);

var config int SENTINEL_LW_USES_PER_TURN;
var config array<name> SENTINEL_LW_ABILITYNAMES;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	if (UnitState.GetTeam() == eTeam_XCom)
	{
		EventMgr.RegisterForEvent(EffectObj, 'XComTurnBegun', class'XComGameState_Effect_EffectCounter'.static.ResetUses, ELD_OnStateSubmitted,,,, EffectObj);
	}
	else if (UnitState.GetTeam() == eTeam_Alien)
	{
		EventMgr.RegisterForEvent(EffectObj, 'AlienTurnBegun', class'XComGameState_Effect_EffectCounter'.static.ResetUses, ELD_OnStateSubmitted,,,, EffectObj);
	}
	EventMgr.RegisterForEvent(EffectObj, 'Sentinel_LWTriggered', EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted,, UnitState);
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local X2EventManager						EventMgr;
	local XComGameState_Ability					AbilityState;       //  used for looking up our source ability (Sentinel_LW), not the incoming one that was activated
	local XComGameState_Effect_EffectCounter	CurrentSentinelCounter, UpdatedSentinelCounter;
	local XComGameState_Unit					TargetUnit;
	local name ValueName;

	CurrentSentinelCounter = XComGameState_Effect_EffectCounter(EffectState);
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
			UpdatedSentinelCounter = XComGameState_Effect_EffectCounter(NewGameState.ModifyStateObject(class'XComGameState_Effect_EffectCounter', CurrentSentinelCounter.ObjectID));
			UpdatedSentinelCounter.uses += 1;
			EventMgr = `XEVENTMGR;
			EventMgr.TriggerEvent('Sentinel_LWTriggered', AbilityState, SourceUnit, NewGameState);
		}
	}
	return false;
}

defaultproperties
{
	GameStateEffectClass=class'XComGameState_Effect_EffectCounter';
}
