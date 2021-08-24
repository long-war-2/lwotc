class X2EventListener_RocketRange extends X2EventListener config(GameData_SoldierSkills);

var config array<name> JAVELIN_ROCKETS_VALID_ABILITIES;
var config int JAVELIN_ROCKETS_BONUS_RANGE_TILES;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateOnItemRangeListenerTemplate());
	Templates.AddItem(CreateOnGetLocalizedCategoryListenerTemplate());

	return Templates;
}

static function CHEventListenerTemplate CreateOnItemRangeListenerTemplate()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'IRI_RocketsOverrideItemRange');

	Template.RegisterInTactical = true;

	Template.AddCHEvent('OnGetItemRange', OnJavelinRocketsOverrideItemRange, ELD_Immediate);
	return Template;
}

static function CHEventListenerTemplate CreateOnGetLocalizedCategoryListenerTemplate()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'IRI_RocketsGetLocalizedCategory');

	Template.RegisterInTactical = true;
	Template.RegisterInStrategy = true;

	Template.AddCHEvent('GetLocalizedCategory', OnGetLocalizedCategory, ELD_Immediate);
	return Template;
}

static function EventListenerReturn OnJavelinRocketsOverrideItemRange(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComLWTuple				OverrideTuple;
	local XComGameState_Item		Item;
	local XComGameState_Ability		Ability;
	local XComGameState_Item		SourceWeapon;
	local X2WeaponTemplate			WeaponTemplate;
	local XComGameState_Unit		UnitState;

	//`LOG("OnJavelinRocketsOverrideItemRange triggered",, 'IRIJAV');
	
	OverrideTuple = XComLWTuple(EventData);
	if(OverrideTuple == none)
		return ELR_NoInterrupt;

	Item = XComGameState_Item(EventSource);
	if(Item == none)
		return ELR_NoInterrupt;

	if(OverrideTuple.Id != 'GetItemRange')
		return ELR_NoInterrupt;

	Ability = XComGameState_Ability(OverrideTuple.Data[2].o);  // optional ability
	if(Ability == none)
		return ELR_NoInterrupt;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Item.OwnerStateObject.ObjectID));
	if(!UnitState.HasSoldierAbility('JavelinRockets'))
		return ELR_NoInterrupt;

	SourceWeapon = Ability.GetSourceWeapon();
	WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
	
	if(WeaponTemplate != none && (WeaponTemplate.WeaponCat == 'iri_rocket_launcher' || WeaponTemplate.WeaponCat == 'rocket'))
	{
		if(default.JAVELIN_ROCKETS_VALID_ABILITIES.Find(Ability.GetMyTemplateName()) != INDEX_NONE)
		{
			OverrideTuple.Data[1].i += default.JAVELIN_ROCKETS_BONUS_RANGE_TILES;
		}
	}
	return ELR_NoInterrupt;
}

static function EventListenerReturn OnGetLocalizedCategory(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
    local XComLWTuple Tuple;
    local X2WeaponTemplate Template;

    Tuple = XComLWTuple(EventData);
    Template = X2WeaponTemplate(EventSource);

    switch (Template.WeaponCat)
    {
        case 'rocket':
            Tuple.Data[0].s = class'X2DownloadableContentInfo_LW_RocketLauncher_Integrated'.default.RocketsWeaponCategory;
            break;
		case 'iri_rocket_launcher':
            Tuple.Data[0].s = class'X2DownloadableContentInfo_LW_RocketLauncher_Integrated'.default.RocketLaunchersWeaponCategory;
            break;
		default:
			break;
    }
    return ELR_NoInterrupt;
}