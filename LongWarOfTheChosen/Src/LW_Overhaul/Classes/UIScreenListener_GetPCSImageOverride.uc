//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_GetPCSImageOverride.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Uses new XComGame TriggerEvent to override logic to add items to inventory
//---------------------------------------------------------------------------------------

class UIScreenListener_GetPCSImageOverride extends UIScreenListener config(LW_Overhaul) deprecated;

var bool bCreated;

// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
	//if(!bCreated)
	//{
		//InitListeners();
		//bCreated = true;
	//}
}

function InitListeners()
{
	local X2EventManager EventMgr;
	local Object ThisObj;

	ThisObj = self;
	EventMgr = `XEVENTMGR;
	EventMgr.RegisterForEvent(ThisObj, 'OnGetPCSImage', GetPCSImage,,,,true);
}

function EventListenerReturn GetPCSImage(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	//local XComLWTuple			OverridePCSImageTuple;
	//local string				ReturnImagePath;
	//local XComGameState_Item	ItemState;
	////local UIUtilities_Image		Utility;

	//OverridePCSImageTuple = XComLWTuple(EventData);
	//if(OverridePCSImageTuple == none)
	//{
		//`REDSCREEN("OverrideGetPCSImage event triggered with invalid event data.");
		//return ELR_NoInterrupt;
	//}
	////`LOG("OverridePCSImageTuple : Parsed XComLWTuple.");
//
	//ItemState = XComGameState_Item(EventSource);
	//if(ItemState == none)
		//return ELR_NoInterrupt;
	////`LOG("OverridePCSImageTuple : EventSource valid.");
//
	//if(OverridePCSImageTuple.Id != 'OverrideGetPCSImage')
		//return ELR_NoInterrupt;
//
	//switch (ItemState.GetMyTemplateName())
	//{
		//case 'DepthPerceptionPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_depthperception"; break;
		//case 'HyperReactivePupilsPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_hyperreactivepupils"; break;
		//case 'CombatAwarenessPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_threatassessment"; break;
		//case 'DamageControlPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_damagecontrol"; break;
		//case 'AbsorptionFieldsPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_impactfield"; break;
		//case 'BodyShieldPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_bodyshield"; break;
		//case 'EmergencyLifeSupportPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_emergencylifesupport"; break;
		//case 'IronSkinPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_ironskin"; break;
		//case 'SmartMacrophagesPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_smartmacrophages"; break;
		//case 'CombatRushPCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_combatrush"; break;
		//case 'CommonPCSDefense': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_defense"; break;
		//case 'RarePCSDefense': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_defense"; break;
		//case 'EpicPCSDefense': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_defense"; break;
		//case 'CommonPCSAgility': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_dodge"; break;
		//case 'RarePCSAgility': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_dodge"; break;
		//case 'EpicPCSAgility': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_dodge"; break;
		//case 'CommonPCSHacking': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_hacking"; break;
		//case 'RarePCSHacking': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_hacking"; break;
		//case 'EpicPCSHacking': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_hacking"; break;
		//case 'FireControl25PCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_firecontrol"; break;
		//case 'FireControl50PCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_firecontrol"; break;
		//case 'FireControl75PCS': OverridePCSImageTuple.Data[0].b = true; OverridePCSImageTuple.Data[1].s = "img:///UILibrary_LW_Overhaul.implants_firecontrol"; break;
//
		//default:  OverridePCSImageTuple.Data[0].b = false;
	//}
	//ReturnImagePath = OverridePCSImageTuple.Data[1].s;  // anything set by any other listener that went first
	//ReturnImagePath = ReturnImagePath;

	//`LOG("GetPCSImage Override : working!.");

	return ELR_NoInterrupt;
}

defaultproperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = UIAvengerHUD;
}