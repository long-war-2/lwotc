class X2EventListener_Campaign extends X2EventListener;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateCampaignStartListeners());

	return Templates;
}

static function CHEventListenerTemplate CreateCampaignStartListeners()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'CampaignStartOptionsListeners');
	Template.AddCHEvent('OnSecondWaveChanged', SaveSecondWaveOptions, ELD_OnStateSubmitted);
	Template.RegisterInStrategy = true;
	Template.RegisterInTactical = true;

	return Template;
}

static function EventListenerReturn SaveSecondWaveOptions(
	Object EventData,
	Object EventSource,
	XComGameState NewGameState,
	Name InEventID,
	Object CallbackData)
{
	class'X2DownloadableContentInfo_LongWarOfTheChosen'.static.SaveSecondWaveOptions();
	return ELR_NoInterrupt;
}
