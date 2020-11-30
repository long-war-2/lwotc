//---------------------------------------------------------------------------------------
//  FILE:	 X2EventListener_UpdateResources_RecruitScreen.uc
//  AUTHOR:	 KDM
//  PURPOSE: UIAvengerHUD updates its resource display based upon the screen being shown; unfortunately, 
//	it will update itself for the base Recruit Screen, UIRecruitSoldiers, but not our custom variant, UIRecruitSoldiers_LWOTC. 
//	Therefore, we need to create a listener which listens for the Community Highlander event 'UpdateResources', 
//	so we can set up the resource display ourself.
//--------------------------------------------------------------------------------------- 

class X2EventListener_UpdateResources_RecruitScreen extends X2EventListener;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateListenerTemplate_OnUpdateResources_RecruitScreen());
	
	return Templates;
}

static function CHEventListenerTemplate CreateListenerTemplate_OnUpdateResources_RecruitScreen()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'UpdateResources_RecruitScreen');

	Template.RegisterInTactical = false;
	Template.RegisterInStrategy = true;

	Template.AddCHEvent('UpdateResources', OnUpdateResources_RecruitScreen, ELD_Immediate);

	return Template;
}

static function EventListenerReturn OnUpdateResources_RecruitScreen(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComHQPresentationLayer HQPres;

	HQPres = `HQPRES;

	// KDM : We are only interested when our custom Recruit Screen is on the top of the screen stack.
	if (HQPres.ScreenStack.GetCurrentClass() == class'UIRecruitSoldiers_LWOTC')
	{
		// KDM : Display the same information a normal Recruit Screen would show.
		HQPres.m_kAvengerHUD.UpdateMonthlySupplies();
		HQPres.m_kAvengerHUD.UpdateSupplies();
		HQPres.m_kAvengerHUD.ShowResources();
	}

	return ELR_NoInterrupt;
}
