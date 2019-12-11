//---------------------------------------------------------------------------------------
//  FILE:    X2LWModTemplate_FactionItems.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Modifies existing item templates related to faction soldiers.
//---------------------------------------------------------------------------------------
class X2LWModTemplate_FactionItems extends X2LWTemplateModTemplate;

static function UpdateItems(X2ItemTemplate Template, int Difficulty)
{
	local X2WeaponTemplate WeaponTemplate;

	WeaponTemplate = X2WeaponTemplate(Template);
	if (WeaponTemplate != none)
	{
		UpdateWeapons(WeaponTemplate, Difficulty);
	}
}

static function UpdateWeapons(X2WeaponTemplate WeaponTemplate, int Difficulty)
{
	switch (WeaponTemplate.DataName)
	{
	case 'Reaper_Claymore':
		WeaponTemplate.iRange = `METERSTOTILES(class'X2Ability_ReaperAbilitySet'.default.ClaymoreRange);
		break;
	}
}

defaultproperties
{
	ItemTemplateModFn=UpdateItems
}
