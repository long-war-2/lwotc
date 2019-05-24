//---------------------------------------------------------------------------------------
//  FILE:    LWUpdateAlienCustomizationAction.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Actor started after loading tactical game to listen for aliens loading and updating their materials
//---------------------------------------------------------------------------------------
class LWUpdateAlienCustomizationAction extends Actor;

`include(LW_AlienPack_Integrated\LW_AlienPack.uci)

var array<XComGameState_Unit> UnitsToUpdate;
var XComGameStateHistory History;
var int Count; 

// This is the automatic state to execute.
auto state Idle
{
	//asembled the units that may need to be updated
	function BeginState(name PrevStateName)
	{
		local XComGameState_Unit Unit;
		local XComGameState_Unit_AlienCustomization AlienCustomization;

		History = `XCOMHISTORY;
		Count = 0;
		UnitsToUpdate.Length = 0;
		foreach History.IterateByClassType(class'XComGameState_Unit', Unit )
		{
			AlienCustomization = class'XComGameState_Unit_AlienCustomization'.static.GetCustomizationComponent(Unit);
			if(AlienCustomization != none)
			{
				UnitsToUpdate.AddItem(Unit);
			}
		}
	}

	//cycle through remaining aliens and update their materials if their pawns have loaded
	function TryToUpdateAllAliens()
	{
		local XComGameState_Unit Unit;
		local XComGameState_Unit_AlienCustomization AlienCustomization;

		foreach UnitsToUpdate(Unit)
		{
			AlienCustomization = class'XComGameState_Unit_AlienCustomization'.static.GetCustomizationComponent(Unit);
			if(AlienCustomization != none)
			{
				if(AlienCustomization.ApplyCustomization())
				{
					//UnitsToUpdate.RemoveItem(Unit);
				}
			}
		}
	}

Begin:
	`APTRACE( "Customization Idle Remaining aliens " $ UnitsToUpdate.Length  );
	TryToUpdateAllAliens();
	if(UnitsToUpdate.Length == 0 || ++ Count > 30)  // HAX: keep this around for a while to make sure that "doubled" XCOM variant weapons get correct materials applied to avoid z-fighting
		Destroy();
	sleep( 0.1 );
	goto 'Begin';
}
