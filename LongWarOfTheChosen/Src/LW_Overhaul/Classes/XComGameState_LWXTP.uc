//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_LWXTP.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: Singleton state for checking the time for updating XTP
//---------------------------------------------------------------------------------------

class XComGameState_LWXTP extends XComGameState_GeoscapeEntity;

var TDateTime NextUpdateTime;

event OnCreation(optional X2DataTemplate InitTemplate)
{
	NextUpdateTime = class'UIUtilities_Strategy'.static.GetGameTime().CurrentTime;
}

static function XComGameState_LWXTP CreateXTPState(optional XComGameState StartState)
{
	local XComGameState_LWXTP XTPState;
	local XComGameState NewGameState;

	//first check that there isn't already a singleton instance of this manager
	XTPState = GetXTPState(true);
	if (XTPState != none)
	{
		return XTPState;
	}

	if(StartState != none)
	{
		XTPState = XComGameState_LWXTP(StartState.CreateNewStateObject(class'XComGameState_LWXTP'));
	}
	else
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Creating LW Alien Activity Manager Quasi-singleton");
		XTPState = XComGameState_LWXTP(NewGameState.CreateNewStateObject(class'XComGameState_LWXTP'));
	}

	return XTPState;
}


static function XComGameState_LWXTP GetXTPState(optional bool AllowNULL = false)
{
    return XComGameState_LWXTP(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_LWXTP', AllowNULL));
}
