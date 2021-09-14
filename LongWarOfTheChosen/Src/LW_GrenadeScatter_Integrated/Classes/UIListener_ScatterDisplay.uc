class UIListener_ScatterDisplay extends UIScreenListener;

event OnInit (UIScreen Screen)
{
	if (UITacticalHUD(Screen) != none)
	{
		Screen.Spawn(class'ScatterDisplay');
	}
}

event OnRemoved (UIScreen Screen)
{
	local ScatterDisplay ScatterDisplay;
	
	if (UITacticalHUD(Screen) != none)
	{
		foreach Screen.AllActors(class'ScatterDisplay', ScatterDisplay)
		{
			ScatterDisplay.Destroy();
		}
	}
}