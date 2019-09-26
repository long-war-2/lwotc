///---------------------------------------------------------------------------------------
//  FILE:    X2Effect_Savior
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Implements effect for Savior ability -- this is a triggering effect that occurs when a medikit heal is applied
//--------------------------------------------------------------------------------------- 
//---------------------------------------------------------------------------------------
class X2Effect_Savior extends X2Effect_Persistent config(LW_SoldierSkills);

//`include(LW_PerkPack_Integrated\LW_PerkPack.uci)

var localized string strSavior_WorldMessage;
var config int SaviorBonusHealAmount;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;
	EventMgr.RegisterForEvent(EffectObj, 'XpHealDamage', OnMedikitHeal, ELD_OnStateSubmitted, 85,,, EffectObj);
}

//This is triggered by a Medikit heal
static function EventListenerReturn OnMedikitHeal(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_Unit SourceUnit, TargetUnit;
	local XpEventData XpEvent;
	local XComGameStateHistory History;
	local XComGameState_Effect EffectState;

	`PPTRACE("PerkPack(Savior): Event XpHealDamage Triggered");
	History = `XCOMHISTORY;
	XpEvent = XpEventData(EventData);
	if(XpEvent == none)
	{
		`REDSCREEN("Savior : XpHealDamage Event with invalid event data.");
		return ELR_NoInterrupt;
	}

	EffectState = XComGameState_Effect(CallbackData);
	if (EffectState == none || EffectState.bReadOnly)  // this indicates that this is a stale effect from a previous battle
		return ELR_NoInterrupt;


	`PPTRACE("PerkPack(Savior): Retrieving Source Unit");
	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(XpEvent.XpEarner.ObjectID));
	if(SourceUnit == none || SourceUnit != XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID)))
		return ELR_NoInterrupt;

	`PPTRACE("PerkPack(Savior): Retrieving Target Unit");
	TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(XpEvent.EventTarget.ObjectID));
	if(TargetUnit == none)
		return ELR_NoInterrupt;

	`PPTRACE("PerkPack(Savior): Activating extra healing on Target Unit.");
	TargetUnit.ModifyCurrentStat(eStat_HP, class'X2Effect_Savior'.default.SaviorBonusHealAmount);

	//visualization function	
	GameState.GetContext().PostBuildVisualizationFn.AddItem(Savior_BuildVisualization);

	return ELR_NoInterrupt;
}

static function Savior_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory				History;
	local XComGameStateContext_Ability		Context;
	local VisualizationActionMetadata		EmptyTrack, BuildTrack;
	local XComGameState_Unit				UnitState;
	local X2Action_PlaySoundAndFlyOver		MessageAction;
	local XGParamTag						kTag;
	local string							WorldMessage;

	History = `XCOMHISTORY;
	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
   
	`PPTRACE ("SAVIOR: Building Collector Track");
	BuildTrack = EmptyTrack;
	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(Context.InputContext.SourceObject.ObjectID));
	`PPTRACE ("SAVIOR: VisSoureUnit=" @ UnitState.GetFullName());
	BuildTrack.StateObject_NewState = UnitState;
	BuildTrack.StateObject_OldState = UnitState;
	BuildTrack.VisualizeActor = UnitState.GetVisualizer();
	MessageAction = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext(), false, BuildTrack.LastActionAdded));

	kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	if (kTag != none)
	{
		kTag.IntValue0 = class'X2Effect_Savior'.default.SaviorBonusHealAmount;
		WorldMessage = `XEXPAND.ExpandString(class'X2Effect_Savior'.default.strSavior_WorldMessage);
	} else {
		WorldMessage = "Placeholder Savior bonus (no XGParamTag)";
	}
	MessageAction.SetSoundAndFlyOverParameters(None, WorldMessage, '', eColor_Good);
}

defaultproperties
{
	DuplicateResponse=eDupe_Ignore
	EffectName="Savior";
	bRemoveWhenSourceDies=true;
}
