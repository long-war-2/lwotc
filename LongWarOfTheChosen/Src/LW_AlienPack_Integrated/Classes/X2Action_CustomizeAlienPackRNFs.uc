//---------------------------------------------------------------------------------------
//  FILE:    X2Action_CustomizeAlienPackRNFs.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Updates alien pawns that come from the LW2 Alien Pack so that they have
//           the correct parts.
//---------------------------------------------------------------------------------------
class X2Action_CustomizeAlienPackRNFs extends X2Action;

event bool BlocksAbilityActivation()
{
	return false;
}

function TryToUpdateAlien()
{
	local XComGameState_Unit UnitState;
	local XComGameState_Unit_AlienCustomization AlienCustomization;

	UnitState = XComGameState_Unit(Metadata.StateObject_NewState);
	`LWTrace("Executing state: Customizing alien " $ UnitState.GetMyTemplateName());

	AlienCustomization = class'XComGameState_Unit_AlienCustomization'.static.GetCustomizationComponent(UnitState);
	if (AlienCustomization != none)
	{
		AlienCustomization.ApplyCustomization();
	}
}

simulated state Executing
{
Begin:
	TryToUpdateAlien();
	
	CompleteAction();
}
