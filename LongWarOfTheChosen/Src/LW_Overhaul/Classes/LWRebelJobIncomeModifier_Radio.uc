//---------------------------------------------------------------------------------------
//  FILE:    X2RebelJobIncomeModifier_Radio.uc
//  AUTHOR:  tracktwo / Pavonis Interactive
//  PURPOSE: Income modifier for regions with radio relays
//---------------------------------------------------------------------------------------

class LWRebelJobIncomeModifier_Radio extends LWRebelJobIncomeModifier
    config(LW_Outposts);

var config float RADIO_RELAY_BONUS;

simulated function float GetModifier(XComGameState_LWOutpost OutpostState)
{
    local XComGameState_WorldRegion WorldRegion;

    WorldRegion = XComGameState_WorldRegion(`XCOMHISTORY.GetGameStateForObjectID(OutpostState.Region.ObjectID));
    if (WorldRegion.ResistanceLevel >= eResLevel_Outpost)
        return 1.0f + RADIO_RELAY_BONUS;

    return 1.0;
}

simulated function String GetDebugName()
{
    return "Radio Relay";
}

defaultproperties
{
    ApplyToExpectedIncome=true
}

