class X2Action_SetGlobalTimeDilation extends X2Action;

var public float TimeDilation;

simulated state Executing
{
Begin:
	class'WorldInfo'.static.GetWorldInfo().TimeDilation = TimeDilation;
	CompleteAction();
}