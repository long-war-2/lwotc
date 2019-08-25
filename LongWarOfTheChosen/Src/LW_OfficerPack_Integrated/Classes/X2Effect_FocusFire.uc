///---------------------------------------------------------------------------------------
//  FILE:    X2Effect_FocusFire
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Implements effect for FocusFire ability -- XCOM gets bonuses against designated target
//--------------------------------------------------------------------------------------- 
//---------------------------------------------------------------------------------------
class X2Effect_FocusFire extends X2Effect_BonusArmor config(LW_OfficerPack);

var config int FOCUSFIRE_ACTIONPOINTCOST;
var config int FOCUSFIRE_DURATION;
var config int FOCUSFIRE_COOLDOWN;
var config int ARMORPIERCINGEFFECT;
var config int AIMBONUSPERATTACK;
var config array<name> VALIDWEAPONCATEGORIES;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local Object EffectObj;

	EffectObj = EffectGameState;

	// allows activation/deactivation of effect
	`XEVENTMGR.RegisterForEvent(EffectObj, 'AbilityActivated', FocusFireCheck, ELD_OnStateSubmitted,,, true, EffectObj);
}

simulated protected function OnEffectAdded(
	const out EffectAppliedData ApplyEffectParameters,
	XComGameState_BaseObject kNewTargetState,
	XComGameState NewGameState,
	XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnit;

	TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if (TargetUnit == none)
		TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	
	// Initialise the attack count to 1 to get the initial 5% bonus
	TargetUnit.SetUnitFloatValue('FocusFireAttacks_LW', 1.0, eCleanup_BeginTurn);

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

static function EventListenerReturn FocusFireCheck(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState NewGameState;
	local XComGameState_Unit AttackingUnit, AbilityTargetUnit, FocussedUnit;
	local XComGameState_Effect EffectState;
	local XComGameStateHistory History;
	local XComGameState_Ability AbilityState;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Item SourceWeapon;
	local UnitValue AttackCount;

	AbilityState = XComGameState_Ability(EventData);
	if (AbilityState == none)
	{
		`RedScreen("FocusFireCheck: no ability");
		return ELR_NoInterrupt;
	}
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if (AbilityContext == none)
	{
		`RedScreen("FocusFireCheck: no context");
		return ELR_NoInterrupt;
	}

	EffectState = XComGameState_Effect(CallbackData);

	//  non-pre emptive, so don't process during the interrupt step
	if (AbilityContext.InterruptionStatus == eInterruptionStatus_Interrupt)
		return ELR_NoInterrupt;

	SourceWeapon = AbilityState.GetSourceWeapon();
	if ((SourceWeapon == none) || (class'X2Effect_FocusFire'.default.VALIDWEAPONCATEGORIES.Find(SourceWeapon.GetWeaponCategory()) == -1))
	{
		return ELR_NoInterrupt;
	}

	History = `XCOMHISTORY;
	AbilityTargetUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
	if (AbilityTargetUnit == none)
		AbilityTargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
	AttackingUnit = XComGameState_Unit(EventSource);
	FocussedUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if (FocussedUnit == none)
		FocussedUnit = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	if (AttackingUnit == none)
	{
		`RedScreen("FocusFireCheck: no attacking unit");
		return ELR_NoInterrupt;
	}
	if (AbilityTargetUnit == none)
	{
		`RedScreen("FocusFireCheck: no target unit");
		return ELR_NoInterrupt;
	}
	if (FocussedUnit == none) 
	{
		return ELR_NoInterrupt;
	}
	if (FocussedUnit != AbilityTargetUnit)
	{
		return ELR_NoInterrupt;
	}

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
	AbilityTargetUnit = XComGameState_Unit(NewGameState.ModifyStateObject(AbilityTargetUnit.Class, AbilityTargetUnit.ObjectID));
	AbilityTargetUnit.GetUnitValue('FocusFireAttacks_LW', AttackCount);
	AbilityTargetUnit.SetUnitFloatValue('FocusFireAttacks_LW', AttackCount.fValue + 1, eCleanup_BeginTurn);
	`TACTICALRULES.SubmitGameState(NewGameState);

	return ELR_NoInterrupt;
}

simulated function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo AccuracyInfo;
	local UnitValue AttackCount;

	Target.GetUnitValue('FocusFireAttacks_LW', AttackCount);

	AccuracyInfo.ModType = eHit_Success;
	AccuracyInfo.Value = default.AIMBONUSPERATTACK * Max(1, AttackCount.fValue);
	AccuracyInfo.Reason = FriendlyName;
	ShotModifiers.AddItem(AccuracyInfo);
}

function int GetArmorMitigation(XComGameState_Effect EffectState, XComGameState_Unit UnitState) { return -default.ARMORPIERCINGEFFECT; }
function int GetArmorChance(XComGameState_Effect EffectState, XComGameState_Unit UnitState) { return 100; }

simulated function AddX2ActionsForVisualization_Tick(XComGameState VisualizeGameState, out VisualizationActionMetadata BuildTrack, const int TickIndex, XComGameState_Effect EffectState)
{
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	
	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext(), false, BuildTrack.LastActionAdded));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, FriendlyName, '', eColor_Bad);
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
	EffectName="FocusFire";
	bRemoveWhenSourceDies=true;
}