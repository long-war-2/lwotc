//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_ScreenUpdates.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//
//  PURPOSE: Handles updates to screens when they fail to register because of class override
//			 Added capturing default weapon BaseDamage info, for Damage Randomization robustness
//--------------------------------------------------------------------------------------- 

class UIScreenListener_ScreenUpdates extends UIScreenListener dependson(X2DownloadableContentInfo_LWToolbox);

var bool bCapturedDefaultBaseDamage;

// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
	if(UIShell(Screen) != none && !bCapturedDefaultBaseDamage)  // this captures UIShell and UIFinalShell
	{
		// capture default spread settings for all weapons
		StoreDefaultWeaponBaseDamageValues();
		bCapturedDefaultBaseDamage = true;
	}
}

function StoreDefaultWeaponBaseDamageValues()
{
	local X2ItemTemplateManager ItemTemplateManager;
	local X2WeaponTemplate Template;
	local array<X2WeaponTemplate> AllWeaponTemplates;
	local DefaultBaseDamageEntry BaseDamageEntry;
	local X2DownloadableContentInfo_LWToolbox ToolboxInfo;

	ToolboxInfo = class'X2DownloadableContentInfo_LWToolbox'.static.GetThisDLCInfo();
	if (ToolboxInfo == none)
	{
		`REDSCREEN("Unable to find X2DLCInfo");
		return;
	}

	//get access to item element template manager
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	if (ItemTemplateManager == none) {
		`Redscreen("LW Toolbox : failed to retrieve ItemTemplateManager to capture Spread");
		return;
	}

	ToolboxInfo.arrDefaultBaseDamage.Length = 0;

	AllWeaponTemplates = ItemTemplateManager.GetAllWeaponTemplates();
	
	foreach AllWeaponTemplates(Template)
	{
		BaseDamageEntry.WeaponTemplateName = Template.DataName;
		BaseDamageEntry.BaseDamage = Template.BaseDamage;
		ToolboxInfo.arrDefaultBaseDamage.AddItem(BaseDamageEntry);
	}
}

simulated function UIScreen GetScreen(name TestScreenClass )
{
	local UIScreenStack ScreenStack;
	local int Index;

	ScreenStack = `SCREENSTACK;
	for(Index = 0; Index < ScreenStack.Screens.Length;  ++Index)
	{
		if(ScreenStack.Screens[Index].IsA(TestScreenClass))
			return ScreenStack.Screens[Index];
	}
	return none; 
}

defaultproperties
{
	// Leave this none so it can be triggered anywhere, gate inside the OnInit
	ScreenClass = none;
}
