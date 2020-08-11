//---------------------------------------------------------------------------------------
//  FILE:    XMBAbilityTrigger_EventListener.uc
//  AUTHOR:  xylthixlm
//
//  This will trigger an ability when a certain event is fired. It supports filtering
//  the events using X2Conditions.
//
//  USAGE
//
//  The following helper function in XMBAbility will create an ability template that uses
//  an XMBAbilityTrigger_EventListener:
//
//  SelfTargetTrigger
//
//  EXAMPLES
//
//  The following examples in Examples.uc use this class:
//
//  AdrenalineSurge
//  Assassin
//  BullRush
//  DeepCover
//  Focus
//  HitAndRun
//  InspireAgility
//  ReverseEngineering
//  SlamFire
//  ZeroIn
//
//  INSTALLATION
//
//  Install the XModBase core as described in readme.txt. Copy this file, and any files 
//  listed as dependencies, into your mod's Classes/ folder. You may edit this file.
//
//  DEPENDENCIES
//
//  None.
//---------------------------------------------------------------------------------------
class XMBAbilityTrigger_EventListener extends X2AbilityTrigger_EventListener;

////////////////////////
// Trigger properties //
////////////////////////

var bool bSelfTarget;
var bool bAsTarget;

//////////////////////////
// Condition properties //
//////////////////////////

var array<X2Condition> AbilityTargetConditions;		// Conditions on the target of the ability being checked.
var array<X2Condition> AbilityShooterConditions;	// Conditions on the shooter of the ability being checked.

simulated function RegisterListener(XComGameState_Ability AbilityState, Object FilterObject)
{
	local object TargetObj;

	TargetObj = AbilityState;

	`XEVENTMGR.RegisterForEvent(TargetObj, ListenerData.EventID, OnEvent, ListenerData.Deferral, ListenerData.Priority, FilterObject,, AbilityState );
}

static function EventListenerReturn OnEvent(Object EventData, Object EventSource, XComGameState GameState, Name EventID, object CallbackData)
{
	local XComGameState_Ability AbilityState, SourceAbilityState;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit SourceUnit, TargetUnit;
	local XComGameStateHistory History;
	local X2AbilityTrigger Trigger;
	local XMBAbilityTrigger_EventListener EventListener;
	local name AvailableCode;
	local bool bSuccess;

	History = `XCOMHISTORY;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if (EventId == 'AbilityActivated' && (AbilityContext == none || AbilityContext.InterruptionStatus == eInterruptionStatus_Interrupt))
		return ELR_NoInterrupt;

	AbilityState = XComGameState_Ability(EventData);
	if (AbilityState == none && AbilityContext != none)
	{
		AbilityState = XComGameState_Ability(GameState.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
		if (AbilityState == none)
			AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
	}

	TargetUnit = XComGameState_Unit(EventData);
	if (TargetUnit == none && AbilityContext != none)
	{
		TargetUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
	}

	SourceAbilityState = XComGameState_Ability(CallbackData);
	SourceAbilityState = XComGameState_Ability(History.GetGameStateForObjectID(SourceAbilityState.ObjectID));
	if (SourceAbilityState == none)
		return ELR_NoInterrupt;

	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(SourceAbilityState.OwnerStateObject.ObjectID));

	foreach SourceAbilityState.GetMyTemplate().AbilityTriggers(Trigger)
	{
		EventListener = XMBAbilityTrigger_EventListener(Trigger);
		if (EventListener != none && EventListener.ListenerData.EventID == EventID)
		{
			if (TargetUnit != none || EventListener.bSelfTarget)
			{
				AvailableCode = EventListener.ValidateAttack(SourceAbilityState, SourceUnit, TargetUnit, AbilityState);

				if (AbilityState != none)
				{
				`Log(SourceAbilityState.GetMyTemplate().DataName @ "event" @ EventID @ "(" $ AbilityState.GetMyTemplate().DataName $ ") =" @ AvailableCode);
				}
				else if (TargetUnit != none)
				{
				`Log(SourceAbilityState.GetMyTemplate().DataName @ "event" @ EventID @ "(" $ TargetUnit $ ") =" @ AvailableCode);
				}
				else
				{
				`Log(SourceAbilityState.GetMyTemplate().DataName @ "event" @ EventID @ "=" @ AvailableCode);
				}

				if (AvailableCode == 'AA_Success')
				{
					if (EventListener.bSelfTarget)
						bSuccess = SourceAbilityState.AbilityTriggerAgainstSingleTarget(SourceUnit.GetReference(), false);
					else
						bSuccess = SourceAbilityState.AbilityTriggerAgainstSingleTarget(TargetUnit.GetReference(), false);

					if (!bSuccess)
						`Log(SourceAbilityState.GetMyTemplate().DataName @ "event" @ EventID @ ": Activation failed! (" $ SourceAbilityState.CanActivateAbility(SourceUnit) $ ")");
				}
			}

			break;
		}			
	}

	return ELR_NoInterrupt;
}

function name ValidateAttack(XComGameState_Ability SourceAbilityState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState)
{
	local X2Condition kCondition;
	local XComGameState_Item SourceWeapon;
	local StateObjectReference ItemRef;
	local name AvailableCode;
		
	if (bAsTarget && Target.ObjectID != SourceAbilityState.OwnerStateObject.ObjectID)
		return 'AA_UnknownError';

	foreach AbilityTargetConditions(kCondition)
	{
		if (kCondition.IsA('XMBCondition_MatchingWeapon'))
		{
			SourceWeapon = AbilityState.GetSourceWeapon();
			if (SourceWeapon == none)
				return 'AA_UnknownError';

			ItemRef = SourceAbilityState.SourceWeapon;
			if (SourceWeapon.ObjectID != ItemRef.ObjectID && SourceWeapon.LoadedAmmo.ObjectID != ItemRef.ObjectID)
				return 'AA_UnknownError';

			continue;
		}

		AvailableCode = kCondition.AbilityMeetsCondition(AbilityState, Target);
		if (AvailableCode != 'AA_Success')
			return AvailableCode;

		AvailableCode = kCondition.MeetsCondition(Target);
		if (AvailableCode != 'AA_Success')
			return AvailableCode;
		
		AvailableCode = kCondition.MeetsConditionWithSource(Target, Attacker);
		if (AvailableCode != 'AA_Success')
			return AvailableCode;
	}

	foreach AbilityShooterConditions(kCondition)
	{
		AvailableCode = kCondition.MeetsCondition(Attacker);
		if (AvailableCode != 'AA_Success')
			return AvailableCode;
	}

	return 'AA_Success';
}
