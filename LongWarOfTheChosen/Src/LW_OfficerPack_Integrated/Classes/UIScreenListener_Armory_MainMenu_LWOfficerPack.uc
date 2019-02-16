//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_Armory_MainMenu_LWOfficerPack
//  AUTHOR:  Amineri
//
//  PURPOSE: Implements hooks to add button to List in order to invoke OfficerUI for viewing
//			deprecated in overhaul, as moddable Armory_MainMenu is incorporated into XComGame
//--------------------------------------------------------------------------------------- 

class UIScreenListener_Armory_MainMenu_LWOfficerPack extends UIScreenListener deprecated;

var localized string strOfficerMenuOption;
var localized string strOfficerTooltip;
var localized string OfficerListItemDescription;

defaultproperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = UIArmory_MainMenu;
}