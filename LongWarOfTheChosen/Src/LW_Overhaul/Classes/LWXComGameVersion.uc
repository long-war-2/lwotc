//---------------------------------------------------------------------------------------
//  FILE:    LWXComGameVersion.uc
//  AUTHOR:  tracktwo (Pavonis Interactive)
//  PURPOSE: Version information for the LW2 XComGame replacement. 
// 
//  Creates a template to hold the version number info for the LW2 XComGame replacement. 
//
//---------------------------------------------------------------------------------------
class LWXComGameVersion extends X2StrategyElement;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	local LWXComGameVersionTemplate XComGameVersion;

	`LWTrace("  >> LWXComGameVersion.CreateTemplates()");
	
	`CREATE_X2TEMPLATE(class'LWXComGameVersionTemplate', XComGameVersion, 'LWXComGameVersion');
	Templates.AddItem(XComGameVersion);

	return Templates;
}
