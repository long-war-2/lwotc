//---------------------------------------------------------------------------------------
//  FILE:    X2LWMissionDetectionModifierTemplate.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Template class for modifiers to mission detection. Unlike
//           LWRebelJobIncomeModifier, these modifiers can adjust the detection
//           chance based on the activity whose detection is being checked.
//---------------------------------------------------------------------------------------

class X2LWMissionDetectionModifierTemplate extends X2StrategyElementTemplate config(LW_Overhaul);

var config float FlatDetectionIncomeChange;
var config float DetectionIncomeMultiplier;  // Applies to just the base income, not any flat change from this modifier template
var config int ModifierDurationHours;   // <= 0 means the modifier lasts indefinitely

var array<X2Condition> Conditions;

//required delegate functions
var delegate<GetModifierDelegate> GetModifierFn;

delegate float GetModifierDelegate(XComGameState_LWOutpost OutpostState, XComGameState_LWAlienActivity ActivityState, float BaseModifier);

function XComGameState_LWMissionDetectionModifier CreateInstanceFromTemplate(StateObjectReference OutpostRef, XComGameState NewGameState)
{
	local XComGameState_LWMissionDetectionModifier ModifierState;

	ModifierState = XComGameState_LWMissionDetectionModifier(NewGameState.CreateNewStateObject(class'XComGameState_LWMissionDetectionModifier', self));
	ModifierState.PostCreateInit(NewGameState, OutpostRef);

	return ModifierState;
}

// Return the modifier to apply to the income.
function float GetModifier(
	XComGameState_LWOutpost OutpostState,
	XComGameState_LWAlienActivity ActivityState,
	float BaseModifier)
{
	local X2Condition CurrCondition;

	foreach Conditions(CurrCondition)
	{
		if (CurrCondition.MeetsConditionWithSource(ActivityState, OutpostState) != 'AA_Success')
		{
			return 0.0;
		}
	}

	return GetModifierFn(OutpostState, ActivityState, BaseModifier);
}

function float DefaultGetModifier(
	XComGameState_LWOutpost OutpostState,
	XComGameState_LWAlienActivity ActivityState,
	float BaseModifier)
{
	local float Modifier;

	Modifier = BaseModifier * DetectionIncomeMultiplier;
	Modifier += FlatDetectionIncomeChange;
	return Modifier;
}

// Helper debug function for tracing to identify modifiers
function String GetDebugName() { return string(self); }

defaultproperties
{
	GetModifierFn = DefaultGetModifier
}
