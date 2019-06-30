//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_RapidReaction
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Grants extra overwatch action points until you miss or hit a cap
//--------------------------------------------------------------------------------------- 

Class X2Effect_RapidReaction extends X2Effect_Persistent config (LW_SoldierSkills);

var config int RAPID_REACTION_USES_PER_TURN;
var config array<name> RAPID_REACTION_ABILITYNAMES;

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
	EventMgr.RegisterForEvent(EffectObj, 'RapidReactionTriggered', EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted,, UnitState);
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local X2EventManager EventMgr;
	local XComGameState_Ability AbilityState;       //  used for looking up our source ability (RapidReaction), not the incoming one that was activated
	local XComGameState_Effect_EffectCounter	CurrentRapidReactionCounter, UpdatedRapidReactionCounter;
	local XComGameState_Unit					TargetUnit;
	local name ValueName;

	CurrentRapidReactionCounter = XComGameState_Effect_EffectCounter(EffectState);
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
			UpdatedRapidReactionCounter = XComGameState_Effect_EffectCounter(NewGameState.ModifyStateObject(class'XComGameState_Effect_EffectCounter', CurrentRapidReactionCounter.ObjectID));
			UpdatedRapidReactionCounter.uses += 1;
			EventMgr = `XEVENTMGR;
			EventMgr.TriggerEvent('RapidReactionTriggered', AbilityState, SourceUnit, NewGameState);
		}
	}
	return false;
}

defaultproperties
{
	GameStateEffectClass=class'XComGameState_Effect_EffectCounter';
}
