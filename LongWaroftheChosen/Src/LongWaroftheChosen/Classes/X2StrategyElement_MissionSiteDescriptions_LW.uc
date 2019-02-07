class X2StrategyElement_MissionSiteDescriptions_LW extends X2StrategyElement_DefaultMissionSiteDescriptions;

var localized string m_strLiberatedCityPrefix;

static function string GetCityCenterMissionSiteDescription_LW(string BaseString, XComGameState_MissionSite MissionSite)
{
    local string OutputString;
    local X2CityTemplate NearestCityTemplate;

    NearestCityTemplate = GetNearestCity(MissionSite.Location, MissionSite.GetWorldRegion());
    if(NearestCityTemplate != none)
    {
        OutputString = GenerateDistrictName(BaseString);
        OutputString = Repl(OutputString, "<AdventCity>", NearestCityTemplate.DisplayName);
		if (MissionSite.GeneratedMission.Mission.MissionName=='Invasion_LW')
		{
			OutPutString = default.m_strLiberatedCityPrefix @ NearestCityTemplate.DisplayName;
		}
    }
    return OutputString;
}
