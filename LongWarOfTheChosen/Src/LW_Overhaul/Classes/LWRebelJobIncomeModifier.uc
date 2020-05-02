//---------------------------------------------------------------------------------------
//  FILE:    X2RebelJobIncomeModifier.uc
//  AUTHOR:  tracktwo / Pavonis Interactive
//  PURPOSE: Base class for income modifiers.
//---------------------------------------------------------------------------------------

class LWRebelJobIncomeModifier extends Object abstract;

// If true this modifier should be applied to the visible "expected" income as well
// as the true income. If false it only affects true income.
var bool ApplyToExpectedIncome;

// Return the modifier to apply to the income.
simulated function float GetModifier(XComGameState_LWOutpost OutpostState) { return 1.0f; }

// Helper debug function for tracing to identify modifiers
simulated function String GetDebugName() { return string(self); }
