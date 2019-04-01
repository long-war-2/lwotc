class MoreDetailsManager extends UIPanel;

var bool IsMoreDetails;

var localized string m_strToggleDetails;

static function MoreDetailsManager GetParentDM(UIPanel ChildPanel)
{
	local MoreDetailsManager MDMgr;

	MDMgr = MoreDetailsManager(ChildPanel.Screen.GetChildByName('DSL_MoreDetailsMgr', false));

	if (MDMgr != none)
		return MDMgr;
}

static function MoreDetailsManager GetOrSpawnParentDM(UIPanel ChildPanel)
{
	local MoreDetailsManager MDMgr;
	local MoreDetailsNavigatorWrapper NewNavMgr;

	MDMgr = GetParentDM(ChildPanel);

	if (MDMgr != none)
	{
		return MDMgr;
	}

	MDMgr = ChildPanel.Screen.Spawn(class'MoreDetailsManager', ChildPanel.Screen);
	MDMgr.InitPanel('DSL_MoreDetailsMgr');
	NewNavMgr = new(ChildPanel.Screen) class'MoreDetailsNavigatorWrapper' (ChildPanel.Screen.Navigator);
	NewNavMgr.InitNavigator(ChildPanel.Screen);
	NewNavMgr.ChildNavigator = ChildPanel.Screen.Navigator;
	ChildPanel.Screen.Navigator = NewNavMgr;

	return MDMgr;
}

simulated function UIPanel InitPanel(optional name InitName, optional name InitLibID)
{
	super.InitPanel(InitName, InitLibID);

	AddHelp();

	return self;
}

simulated function AddHelp()
{
	local UINavigationHelp NavHelp;

	NavHelp = `HQPRES.m_kAvengerHUD.NavHelp;
	if(`SCREENSTACK.IsTopScreen(Screen) && NavHelp.m_arrButtonClickDelegates.Length > 0 && NavHelp.m_arrButtonClickDelegates.Find(OnToggleDetails) == INDEX_NONE)
	{
		NavHelp.AddCenterHelp(m_strToggleDetails, class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_RT_R2, OnToggleDetails, false, "");
	}
	if (`SCREENSTACK.IsInStack(Screen.class))
	{
		Screen.SetTimer(1.0f, false, nameof(AddHelp), self);
	}
}

simulated function OnToggleDetails()
{
	local array<UIPanel> AllChildren;
	local UIPanel OnePanel;
	local UIPersonnel_SoldierListItemDetailed ChildPanel;
	IsMoreDetails = !IsMoreDetails;

	Screen.GetChildrenOfType(class'UIPersonnel_SoldierListItemDetailed', AllChildren);

	foreach AllChildren(OnePanel)
	{
		ChildPanel = UIPersonnel_SoldierListItemDetailed(OnePanel);
		if (ChildPanel != none)
		{
			ChildPanel.ShowDetailed(IsMoreDetails);
		}
	}
}

//simulated function bool OnUnrealCommand(int cmd, int arg)
//{
	//local bool bHandled;
	//local int tempCurrentTab;
//
	//if( !CheckInputIsReleaseOrDirectionRepeat(cmd, arg) )
		//return false;
//
	//bHandled = true;
//
	//`log("Unreal command hooked" @ cmd @ arg,, 'MoreSoldierDetails');
//
	//switch( cmd )
	//{
		//default:
			//bHandled = false;
			//break;
	//}
//
//
	//if (bHandled)
	//{
		//return true;
	//}
//
	//return super.OnUnrealCommand(cmd, arg);
//}