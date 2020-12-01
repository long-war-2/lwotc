//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_RegenerationPCT.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: Regeneration, but considers % of hp instead of flat value
//--------------------------------------------------------------------------------------- 
class X2Effect_RegenerationPCT extends X2Effect_Persistent;

var float HealAmountPCT;
var int MaxHealAmount;
var name HealthRegeneratedName;
var name EventToTriggerOnHeal;

var localized string HealedMessage;

function bool RegenerationTicked(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication)
{
	local XComGameState_Unit OldTargetState, NewTargetState;
	local UnitValue HealthRegenerated;
	local int AmountToHeal, Healed;
	local int HealAmount;
    
	OldTargetState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
    
	HealAmount = OldTargetState.GetMaxStat(eStat_HP) * HealAmountPCT;
    
	if (HealthRegeneratedName != '' && MaxHealAmount > 0)
	{
		OldTargetState.GetUnitValue(HealthRegeneratedName, HealthRegenerated);

		// If the unit has already been healed the maximum number of times, do not regen
		if (HealthRegenerated.fValue >= MaxHealAmount)
		{
			return false;
		}
		else
		{
			// Ensure the unit is not healed for more than the maximum allowed amount
			AmountToHeal = min(HealAmount, (MaxHealAmount - HealthRegenerated.fValue));
		}
	}
	else
	{
		// If no value tracking for health regenerated is set, heal for the default amount
		AmountToHeal = HealAmount;
	}	

	// Perform the heal
	NewTargetState = XComGameState_Unit(NewGameState.ModifyStateObject(OldTargetState.Class, OldTargetState.ObjectID));
	NewTargetState.ModifyCurrentStat(eStat_HP, AmountToHeal);

	if (EventToTriggerOnHeal != '')
	{
		`XEVENTMGR.TriggerEvent(EventToTriggerOnHeal, NewTargetState, NewTargetState, NewGameState);
	}

	// If this health regen is being tracked, save how much the unit was healed
	if (HealthRegeneratedName != '')
	{
		Healed = NewTargetState.GetCurrentStat(eStat_HP) - OldTargetState.GetCurrentStat(eStat_HP);
		if (Healed > 0)
		{
			NewTargetState.SetUnitFloatValue(HealthRegeneratedName, HealthRegenerated.fValue + Healed, eCleanup_BeginTactical);
		}
	}

	return false;
}

simulated function AddX2ActionsForVisualization_Tick(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const int TickIndex, XComGameState_Effect EffectState)
{
	local XComGameState_Unit OldUnit, NewUnit;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local int Healed;
	local string Msg;

	OldUnit = XComGameState_Unit(ActionMetadata.StateObject_OldState);
	NewUnit = XComGameState_Unit(ActionMetadata.StateObject_NewState);

	Healed = NewUnit.GetCurrentStat(eStat_HP) - OldUnit.GetCurrentStat(eStat_HP);
	
	if (Healed > 0)
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		Msg = Repl(default.HealedMessage, "<Heal/>", Healed);
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Msg, '', eColor_Good);
	}
}

defaultproperties
{
	EffectName="Regeneration"
	EffectTickedFn=RegenerationTicked
}
