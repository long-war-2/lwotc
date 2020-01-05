//---------------------------------------------------------------------------------------
//  FILE:    X2LWCovertActionsModTemplate.uc
//  AUTHOR:  Peter Ledbrook
//	PURPOSE: Modifies existing Sit Rep templates, disabling some of them so they.
//           won't be picked for missions.
//---------------------------------------------------------------------------------------
class X2LWSitRepsModTemplate extends X2LWTemplateModTemplate config(LW_Overhaul);

var config array<name> VALID_SIT_REPS;

static function UpdateSitReps(X2SitRepTemplate SitRepTemplate, int Difficulty)
{
	// If this is *not* in the VALID_SIT_REPS array, exclude it from
	// strategy, i.e. prevent it from being attached to campaign missions.
	if (default.VALID_SIT_REPS.Find(SitRepTemplate.DataName) == INDEX_NONE)
	{
		SitRepTemplate.bExcludeFromStrategy = true;
	}
}

defaultproperties
{
	SitRepTemplateModFn=UpdateSitReps
}