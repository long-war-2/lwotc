//---------------------------------------------------------------------------------------
//  FILE:    X2RebelJobIncomeModifier.uc
//  AUTHOR:  tracktwo / Pavonis Interactive
//  PURPOSE: Income modifier for active dark events.
//---------------------------------------------------------------------------------------

class LWRebelJobIncomeModifier_DarkEvent extends LWRebelJobIncomeModifier;

// The dark event to trigger on
var Name DarkEvent;

// The mod to apply if this dark event is active. 
var float Mod;

// If the corresponding dark event is active, return the configured mod, otherwise return 1.0.
simulated function float GetModifier(XComGameState_LWOutpost OutpostState)
{
    if (IsDarkEventActive(DarkEvent))
    {
        return Mod;
    }
    else
    {
        return 1.0f;
    }
}

function bool IsDarkEventActive(name DarkEventName)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_DarkEvent DarkEventState;
	
	History = `XCOMHISTORY;
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	foreach History.IterateByClassType(class'XComGameState_DarkEvent', DarkEventState)
	{
		if(DarkEventState.GetMyTemplateName() == DarkEventName)
		{
			if(AlienHQ.ActiveDarkEvents.Find('ObjectID', DarkEventState.ObjectID) != -1)
			{
				return true;
			}
		}
	}
	return false;
}

simulated function String GetDebugName()
{
    return "DarkEvent(" $ DarkEvent $ ")";
}

