//---------------------------------------------------------------------------------------
//  FILE:    X2LWSitRepEffectsModTemplate.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Modifies existing Sit Rep Effect templates.
//---------------------------------------------------------------------------------------
class X2LWSitRepEffectsModTemplate extends X2LWTemplateModTemplate config(LW_Overhaul);

static function UpdateSitRepEffects(X2SitRepEffectTemplate EffectTemplate, int Difficulty)
{
	switch (EffectTemplate.DataName)
	{
		case 'ExtraLootChestsEffect':
			EffectTemplate.DifficultyModifier = 0;
			break;
		default:
			break;
	}
}

defaultproperties
{
	SitRepEffectTemplateModFn=UpdateSitRepEffects
}
