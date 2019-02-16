//---------------------------------------------------------------------------------------
//  FILE:    X2LWActivityCooldown_Global.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//	PURPOSE: Global cooldown mechanics for creation of alien activities
//---------------------------------------------------------------------------------------
class X2LWActivityCooldown_Global extends X2LWActivityCooldown;

simulated function ApplyCooldown(XComGameState_LWAlienActivity ActivityState, XComGameState NewGameState)
{
	local XComGameState_LWAlienActivityManager ActivityManager;
	local ActivityCooldownTimer Cooldown;

	foreach NewGameState.IterateByClassType(class'XComGameState_LWAlienActivityManager', ActivityManager)
	{
		break;
	}
	if(ActivityManager == none)
	{
		ActivityManager = class'XComGameState_LWAlienActivityManager'.static.GetAlienActivityManager();
		ActivityManager = XComGameState_LWAlienActivityManager(NewGameState.CreateStateObject(class'XComGameState_LWAlienActivityManager', ActivityManager.ObjectID));
		NewGameState.AddStateObject(ActivityManager);
	}
	Cooldown.ActivityName = ActivityState.GetMyTemplateName();
	Cooldown.CooldownDateTime = GetCooldownDateTime();

	ActivityManager.GlobalCooldowns.AddItem(Cooldown);
}