//---------------------------------------------------------------------------------------
//  FILE:   X2Effect_ApplyHeal.uc
//  AUTHOR:  Grobobobo/inspired by shadow ops
//  PURPOSE: Effect that heals stuff per turn.
//---------------------------------------------------------------------------------------
class X2Effect_ApplyHeal extends X2Effect;

var int HealAmount;
var int MaxHealAmount;          // if 0, value is ignored

var name HealthRegeneratedName; // if empty, healing will not be limited to MaxHealAmount

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit OldTargetState, NewTargetState;
	local UnitValue HealthRegenerated;
	local int AmountToHeal, Healed, NewHealthRegenerated;
	
	`LOG("X2Effect_ApplyHeal added");
	
	OldTargetState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	if (HealthRegeneratedName != '' && MaxHealAmount > 0)
	{
		OldTargetState.GetUnitValue(HealthRegeneratedName, HealthRegenerated);

		// If the unit has already been healed the maximum number of times, do not heal
		if (HealthRegenerated.fValue >= MaxHealAmount)
		{
			return;
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
	NewTargetState.ModifyCurrentStat(estat_HP, AmountToHeal);

	// If this health regen is being tracked, save how much the unit was healed
	if (HealthRegeneratedName != '')
	{
		Healed = NewTargetState.GetCurrentStat(eStat_HP) - OldTargetState.GetCurrentStat(eStat_HP);
		if (Healed > 0)
		{
			NewHealthRegenerated = HealthRegenerated.fValue + Healed;
			NewTargetState.SetUnitFloatValue(HealthRegeneratedName, NewHealthRegenerated, eCleanup_BeginTactical);
		}
	}
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local XComGameState_Unit OldUnit, NewUnit;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local int Healed;
	local string Msg;

	OldUnit = XComGameState_Unit(ActionMetadata.StateObject_OldState);
	NewUnit = XComGameState_Unit(ActionMetadata.StateObject_NewState);

	if (OldUnit != none && NewUnit != None)
	{
		Healed = NewUnit.GetCurrentStat(eStat_HP) - OldUnit.GetCurrentStat(eStat_HP);
	
		if (Healed != 0)
		{
			SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
			Msg = Repl(class'X2Effect_ApplyMedikitHeal'.default.HealedMessage, "<Heal/>", Healed);
			SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Msg, '', eColor_Good);
		}		
	}
}

simulated function AddX2ActionsForVisualization_Tick(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const int TickIndex, XComGameState_Effect EffectState)
{
	AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 'AA_Success');
}
