class X2EventListener_Debug extends X2EventListener config(LW_Overhaul);

// var X2DownloadableContentInfo_LongWarOfTheChosen LWDLCInfo;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateDebugListeners());

	return Templates;
}

////////////////
/// Tactical ///
////////////////

static function CHEventListenerTemplate CreateDebugListeners()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'LWDebugListeners');
	Template.AddCHEvent('DrawDebugLabels', OnDrawDebugLabels, ELD_Immediate);
	`LWTrace("Creating debug listeners");

	Template.RegisterInTactical = true;

	return Template;
}

static function EventListenerReturn OnDrawDebugLabels(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local array<X2DownloadableContentInfo> DLCInfos;
	local X2DownloadableContentInfo DLCInfo;
	local X2DownloadableContentInfo_LongWarOfTheChosen LWDLCInfo;
	local Canvas kCanvas;
	
	kCanvas = Canvas(EventData);
	if (kCanvas == none)
		return ELR_NoInterrupt;

	// if (LWDLCInfo == none)
	// {
		//retrieve all active DLCs
		DLCInfos = `ONLINEEVENTMGR.GetDLCInfos(false);
		foreach DLCInfos(DLCInfo)
		{
			if (DLCInfo.DLCIdentifier == "LongWarOfTheChosen")
			{
				LWDLCInfo = X2DownloadableContentInfo_LongWarOfTheChosen(DLCInfo);
				break;
			}
		}
	// }

	if (LWDLCInfo.bDebugPodJobs)
	{
		`LWTrace("Drawing debug labels");
		`LWPODMGR.DrawDebugLabel(kCanvas);
	}

	return ELR_NoInterrupt;
}
