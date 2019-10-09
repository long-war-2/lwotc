//-----------------------------------------------------------
//	Class:	XCom_Perfect_Information_UIScreenListener
//	Author: tjnome
//	
//-----------------------------------------------------------

class XCom_Perfect_Information_UIScreenListener extends UIScreenListener;

// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen) 
{
	local UITacticalHUD MyScreen;
	MyScreen = UITacticalHUD(Screen);

	if (MyScreen.m_kShotHUD.Class == class'UITacticalHUD_ShotHUD')
	{
		MyScreen.m_kShotHUD.Remove();
		MyScreen.m_kShotHUD = MyScreen.Spawn(class'XCom_Perfect_Information_UITacticalHUD_ShotHUD', MyScreen).InitShotHUD();
	}

	if (MyScreen.m_kShotInfoWings.Class == class'UITacticalHUD_ShotWings')
	{
		MyScreen.m_kShotInfoWings.Remove();
		MyScreen.m_kShotInfoWings = MyScreen.Spawn(class'XCom_Perfect_Information_UITacticalHUD_ShotWings', MyScreen).InitShotWings();

		// LWOTC: These are currently disabled because they don't work properly/well
		// MyScreen.m_kTooltips.Remove();
		// MyScreen.m_kTooltips = MyScreen.Spawn(class'XCom_Perfect_Information_UITacticalHUD_Tooltips', MyScreen).InitTooltips();
		
		// MyScreen.m_kEnemyTargets.Remove();
		// MyScreen.m_kEnemyTargets = MyScreen.Spawn(class'XCom_Perfect_Information_UITacticalHUD_Enemies', MyScreen).InitEnemyTargets();
	}
}

defaultProperties
{
    ScreenClass=class'UITacticalHUD'
}
