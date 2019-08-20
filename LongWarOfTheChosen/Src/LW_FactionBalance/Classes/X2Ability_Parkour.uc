//from NotSoLoneWolf
class X2Ability_Parkour extends X2Ability config (GameData_SoldierSkills);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(AddParkour());

	return Templates;
}

// This is a dud ability, it's only use is to exist. The X2AbilityCooldown_Grapple.uc file checks if a soldier has this dud ability

static function X2AbilityTemplate AddParkour()
{
	local X2AbilityTemplate                 Template;	
	Template = PurePassive('Parkour', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_parkour", false, 'eAbilitySource_Perk');
	Template.bCrossClassEligible = false;
	return Template;
}
