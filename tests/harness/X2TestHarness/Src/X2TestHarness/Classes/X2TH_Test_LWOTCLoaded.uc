// Smoke test: LWOTC's script packages loaded and its templates were created.
class X2TH_Test_LWOTCLoaded extends X2TH_Test;

function Run()
{
	T.Check(class'Engine'.static.FindClassType("LW_Overhaul.X2DownloadableContentInfo_LongWarOfTheChosen") != none,
		"LWOTC script package is loaded");
	T.Check(class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate('ArcthrowerStun') != none,
		"LWOTC ability templates exist");
}
