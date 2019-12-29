class X2Item_HeavyDazedDamageType extends X2Item;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> DamageTypes;

	DamageTypes.AddItem(CreateHeavyMentalDamageType());

    return DamageTypes;
}

    static function X2DamageTypeTemplate CreateHeavyMentalDamageType()
{
	local X2DamageTypeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2DamageTypeTemplate', Template, 'HeavyMental');

	Template.bCauseFracture = false;
	Template.MaxFireCount = 0;
	Template.bAllowAnimatedDeath = true;

	return Template;
}