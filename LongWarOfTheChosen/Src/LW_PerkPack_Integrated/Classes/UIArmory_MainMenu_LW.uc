//---------------------------------------------------------------------------------------
//  FILE:    UIArmory_MainMenu_LW
//  AUTHOR:  Amineri (Pavonis Interactive)
//
//  PURPOSE: Rewritten to enable mods to more easily add/change/remove buttons from the armory list
//			For overhaul, deprecated as class override and moved into XComGame, but keeping for config value
//--------------------------------------------------------------------------------------- 

class UIArmory_MainMenu_LW extends UIArmory_MainMenu config(LW_PerkPack);

var config bool bUse2WideAbilityTree;

