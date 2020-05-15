//---------------------------------------------------------------------------------------
//  FILE:    X2LWCovertActionsModTemplate.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Modifies existing Sit Rep templates, disabling some of them so they.
//           won't be picked for missions.
//---------------------------------------------------------------------------------------
class X2LWSitRepsModTemplate extends X2LWTemplateModTemplate config(LW_Overhaul);

var config array<name> SIT_REP_EXCLUSIONS;

static function UpdateSitReps(X2SitRepTemplate SitRepTemplate, int Difficulty)
{
	// If this is in the SIT_REP_EXCLUSIONS array, exclude it from
	// strategy, i.e. prevent it from being attached to campaign missions.
	if (default.SIT_REP_EXCLUSIONS.Find(SitRepTemplate.DataName) != INDEX_NONE)
	{
		SitRepTemplate.bExcludeFromStrategy = true;
	}
}

defaultproperties
{
	SitRepTemplateModFn=UpdateSitReps
}