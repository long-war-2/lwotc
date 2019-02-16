class robojumper_SquadSelectControllerMap extends UIControllerMap;

// Callback from Flash
simulated function OnInit()
{

	super(UIScreen).OnInit();

	AS_Set360GamePadLayout();   // PC & 360

	LoadDefaultSquadSelect();

	InjectImages();

	Realize();
}

simulated function LoadDefaultSquadSelect()
{

	UIGamePad[0].label = class'UIUtilities_Text'.default.m_strGenericSelect;
	UIGamePad[2].label = class'UINavigationHelp'.default.m_strBackButtonLabel;

	UIGamePad[1].label = class'UISquadSelect_ListItem'.default.m_strEdit;

	UIGamePad[3].label = class'UISquadSelect_ListItem'.default.m_strDismiss;
	UIGamePad[4].label = class'UIUtilities_Text'.default.m_strGenericNavigate;
	UIGamePad[5].label = class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(m_sPanCameraHQ);
	UIGamePad[6].label = class'UIUtilities_Text'.default.m_strGenericNavigate;           // dpad left/right
	UIGamePad[7].label = class'robojumper_UISquadSelect'.default.strCycleLists;
	UIGamePad[8].label = class'UISquadSelect'.default.m_strLaunch @ class'UISquadSelect'.default.m_strMission;
	UIGamePad[9].label = class'UISquadSelect'.default.m_strBuildItems;
	UIGamePad[10].label = class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(class'robojumper_UISquadSelect'.default.strSwitchPerspective);
	UIGamePad[11].label = class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(class'UIManageEquipmentMenu'.default.m_strTitleLabel);
	UIGamePad[12].label = class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(class'robojumper_UISquadSelect'.default.m_strBoostSoldier);
	UIGamePad[13].label = m_sUnused;
	UIGamePad[14].label = class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(class'UIPauseMenu'.default.m_sControllerMap);
	UIGamePad[15].label = class'UIUtilities_Text'.default.m_strGenericNavigate;
	//</workshop>
}

simulated function Realize()
{
	local int i;


	AS_SetTitle(m_sControllerMap);
	
	MC.FunctionString("SetSubtitle", "Squad Select");

	AS_SetHelp( 
		class'UIUtilities_Input'.static.GetBackButtonIcon(), m_sDone, 
		"", "", 
		"", "" );

	for( i = 0; i < 16; i++ )
	{
		AS_SetControl(i, UIGamePad[i].label );
	}
}
