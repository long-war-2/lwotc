class X2EventListener_Scatter extends X2EventListener;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(Create_ListenerTemplate());

	return Templates;
}

static function CHEventListenerTemplate Create_ListenerTemplate()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'X2EventListener_Scatter');

	Template.RegisterInTactical = true;
	Template.RegisterInStrategy = false;

	Template.AddCHEvent('PostModifyNewAbilityContext', ListenerEventFunction, ELD_Immediate);
	
	return Template;
}

static function EventListenerReturn ListenerEventFunction(Object EventData, Object EventSource, XComGameState NewGameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability	NewContext;

	NewContext = XComGameStateContext_Ability(EventData);

	//`LOG("Running modify new context event for:" @ NewContext.InputContext.AbilityTemplateName,, 'IRITEST');

	if (class'X2DownloadableContentInfo_LW_GrenadeScatter_Integrated'.default.SCATTER.Find('AbilityName', NewContext.InputContext.AbilityTemplateName) != INDEX_NONE)
	{
		//`LOG("Running scatter",, 'IRITEST');
		class'X2DownloadableContentInfo_LW_GrenadeScatter_Integrated'.static.GrenadeScatter_ModifyActivatedAbilityContext(NewContext);
	}
	return ELR_NoInterrupt;
}
