//---------------------------------------------------------------------------------------
//  FILE:    X2RebelJobIncomeModifier_Liaison.uc
//  AUTHOR:  tracktwo / Pavonis Interactive
//  PURPOSE: Income modifier for haven liaisons
//---------------------------------------------------------------------------------------

class LWRebelJobIncomeModifier_Liaison extends LWRebelJobIncomeModifier
    config(LW_Outposts);

// The bonus to add if this modifier is to apply.
var float Mod;

// If the template name of the liaison in the outpost matches this name, the bonus will be granted.
var Name TemplateName;

simulated function float GetModifier(XComGameState_LWOutpost OutpostState)
{
    local StateObjectReference LiaisonRef;
    local XComGameState_Unit Liaison;

    // No liaison? No bonus
    if (!OutpostState.HasLiaison())
    {
        return 1.0;
    }

    LiaisonRef = OutpostState.GetLiaison();
    Liaison = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(LiaisonRef.ObjectID));

    if (Liaison.GetMyTemplateName() == TemplateName)
        return Mod;

    return 1.0f;
}

simulated function String GetDebugName()
{
    return "Liaison(" $ TemplateName $ ")";
}