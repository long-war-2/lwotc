//---------------------------------------------------------------------------------------
//  FILE:    X2RebelJobIncomeModifier_Liaison.uc
//  AUTHOR:  tracktwo / Pavonis Interactive
//  PURPOSE: Income modifier for haven liaisons
//---------------------------------------------------------------------------------------

class LWRebelJobIncomeModifier_SoldierLiaison extends LWRebelJobIncomeModifier
    config(LW_Outposts);

var config float SOLDIER_LIAISON_RANK_MULTIPLIER;

simulated function float GetModifier(XComGameState_LWOutpost OutpostState)
{
    local StateObjectReference LiaisonRef;
    local XComGameState_Unit Liaison;

    // No liaison? No bonus
    if (!OutpostState.HasLiaisonOfKind('Soldier'))
    {
        return 1.0;
    }

    LiaisonRef = OutpostState.GetLiaison();
    Liaison = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(LiaisonRef.ObjectID));

    return 1.0f + SOLDIER_LIAISON_RANK_MULTIPLIER * (Liaison.GetRank()-1);
}

simulated function String GetDebugName()
{
    return "SoldierLiaison()";
}