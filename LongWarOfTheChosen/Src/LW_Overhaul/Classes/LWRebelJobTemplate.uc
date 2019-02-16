//---------------------------------------------------------------------------------------
//  FILE:    X2RebelJobTemplate.uc
//  AUTHOR:  tracktwo / Pavonis Interactive
//	PURPOSE: Rebel job definitions template for allowing extensible rebel behavior in outposts.
//---------------------------------------------------------------------------------------

class LWRebelJobTemplate extends X2StrategyElementTemplate config(LW_Outposts);

// The job name as it appears in game
var localized string strJobName;

// Config vars for "simple" income schemes - daily income is (IncomePerRebel * NumRebelLevels) 
var config float IncomePerRebel;

// Configurable amount of a resource to grant on income events.
var config int ResourceIncomeAmount;

// Income modifiers: applied to the daily income of a job.
var array<LWRebelJobIncomeModifier> IncomeModifiers;

// A delegate for a more complex income scheme - used instead of the simple formula above if set to a non-none value.
var delegate<GetDailyIncome> GetDailyIncomeFn;

var delegate<IncomeThreshold> IncomeThresholdFn;
var delegate<IncomeEvent> IncomeEventFn;
var delegate<IncomeEventVisualization> IncomeEventVisualizationFn;

// Determine the income accumulated by the outpost for the day. Used for both true income and 'expected' income. Will be called
// twice per day with different parameters to reflect whether or not to consider faceless as rebels.
// RebelLevels - sum of all levels of rebels on this job.
// NumFaceless - Number of faceless on this job.
delegate float GetDailyIncome(XComGameState_LWOutpost Outpost, float rebelLevels, LWRebelJobTemplate MyTemplate);

// Determine whether or not we should award income. Optional: If the template doesn't define this it uses the default
// value of triggering income if the income pool is >= 100 and there is an income function defined.
delegate bool IncomeThreshold(XComGameState_LWOutpost Outpost, float CurrentValue, LWRebelJobTemplate MyTemplate);

// Give the player whatever reward they should get for having rebels assigned to this task.
// The event may add new states to the provided new game state, or update the Outpost. The
// outpost is already added to this new game state, so the income event may modify it directly
// without needing to create another new state.
delegate IncomeEvent(XComGameState_LWOutpost Outpost, XComGameState NewGameState, LWRebelJobTemplate MyTemplate);

// Perform visualization of the income event. This is called after the new state passed to the outpost has been submitted.
delegate IncomeEventVisualization(XComGameState_LWOutpost Outpost, LWRebelJobTemplate MyTemplate);
