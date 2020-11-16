//---------------------------------------------------------------------------------------
//	FILE:		X2EventListener_WorldRegion.uc
//	AUTHOR:		KDM
//	PURPOSE:	When using a controller, and on the strategy map, selectable regions/havens are associated with a 3D mesh.
//				Unfortunately, Long War 2 introduced states which were not taken into account in the
//				base game; consequently, selectable regions/havens could be associated with no 3D mesh.
//				These issues are rectified here.
//---------------------------------------------------------------------------------------

class X2EventListener_WorldRegion extends X2EventListener config(LW_Overhaul);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateWorldRegionListeners());
	
	return Templates;
}

static function CHEventListenerTemplate CreateWorldRegionListeners()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'WorldRegionListeners');
	Template.AddCHEvent('WorldRegionGetStaticMesh', OnWorldRegionGetStaticMesh, ELD_Immediate);
	Template.AddCHEvent('WorldRegionGetMeshScale', OnWorldRegionGetMeshScale, ELD_Immediate);
	
	Template.RegisterInStrategy = true;

	return Template;
}

static function bool CanMakeContact(XComGameState_WorldRegion WorldRegion)
{
	return (class'UIUtilities_Strategy'.static.GetXComHQ().IsContactResearched() && (WorldRegion.ResistanceLevel == eResLevel_Unlocked));
}

static function bool IsContacted(XComGameState_WorldRegion WorldRegion)
{
	return ((WorldRegion.ResistanceLevel == eResLevel_Contact) || (WorldRegion.ResistanceLevel == eResLevel_Outpost));
}

static function EventListenerReturn OnWorldRegionGetStaticMesh(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComGameState_WorldRegion WorldRegion;
	local XComLWTuple Tuple;
	
	Tuple = XComLWTuple(EventData);
	WorldRegion = XComGameState_WorldRegion(EventSource);

	if (Tuple != none && WorldRegion != none)
	{
		// KDM : When using a controller :
		// 1.]	A radio relay mesh is displayed when a region is contactable, regardless of its scanning status. 
		//		It is also displayed when a haven has been contacted, regardless of its radio relay status.
		// 2.]	No mesh will be shown if a region can't be contacted due to tech level or location on the map.
		//
		// Note : Originally I had contactable regions display as signal tower meshes (StaticMesh'XB0_XCOM2_OverworldIcons.SingnalInterception').
		// However, this led to visual problems when switching between the 2, since signal tower meshes are animated while 
		// radio relay meshes are not. 
		if (CanMakeContact(WorldRegion) || IsContacted(WorldRegion))
		{
			Tuple.Data[0].o = StaticMesh'UI_3D.Overwold_Final.RadioTower';
		}
	}

	return ELR_NoInterrupt;
}

static function EventListenerReturn OnWorldRegionGetMeshScale(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComGameState_WorldRegion WorldRegion;
	local XComLWTuple Tuple;
	
	Tuple = XComLWTuple(EventData);
	WorldRegion = XComGameState_WorldRegion(EventSource);

	if (Tuple != none && WorldRegion != none)
	{
		// KDM : When using a controller, make sure the static mesh associated with a region/haven is the correct size.
		if (CanMakeContact(WorldRegion) || IsContacted(WorldRegion))
		{
			Tuple.Data[0].v = vect(1.0, 1.0, 1.0);
		}
	}

	return ELR_NoInterrupt;
}
