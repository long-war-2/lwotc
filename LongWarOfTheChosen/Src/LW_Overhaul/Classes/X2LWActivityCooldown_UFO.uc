//---------------------------------------------------------------------------------------
//  FILE:    X2LWActivityCooldown_UFO.uc
//  AUTHOR:  JohnnyLump / Pavonis Interactive
//	PURPOSE: Cooldown mechanics for creation of UFO activities; primarily here so we can have difficulty-specific 
//---------------------------------------------------------------------------------------
class X2LWActivityCooldown_UFO extends X2LWActivityCooldown_Global config(LW_Activities);



var config array<int> FORCE_UFO_COOLDOWN_DAYS;
var config array<int> ALERT_UFO_COOLDOWN_DAYS;

var bool UseForceTable;

function float GetCooldownHours()
{
	if (UseForceTable)
	{
		return (default.FORCE_UFO_COOLDOWN_DAYS[`STRATEGYDIFFICULTYSETTING] * 24) + (`SYNC_FRAND() * RandCooldown_Hours);
	}
	`LWTrACE ("Using UFO Alert Cooldown Table" @ ALERT_UFO_COOLDOWN_DAYS[`STRATEGYDIFFICULTYSETTING]);
	return (default.ALERT_UFO_COOLDOWN_DAYS[`STRATEGYDIFFICULTYSETTING] * 24) + (`SYNC_FRAND() * RandCooldown_Hours);
}