//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_ControlCivilian.uc
//  AUTHOR:  tracktwo / LWS
//  PURPOSE: Swaps an approached civilian to the xcom team to be controllable for evac.
//---------------------------------------------------------------------------------------
 
class SeqAct_ControlCivilian extends SequenceAction;

var private XComGameState_Unit CivilianUnit;

event Activated()
{
    local XComGameState NewGameState;
    local XComGameState_Effect PanicEffect;

    if(CivilianUnit == none)
    {
        `Redscreen("SeqAct_RescueCivilian: Civilian Unit is none.");
        return;
    }

    if(CivilianUnit.GetTeam() != eTeam_Neutral)
    {
        `Redscreen("SeqAct_ControlCivilian: Attempting to rescue a non-civilian unit.");
        return;
    }

    // Swap teams
    `BATTLE.SwapTeams(CivilianUnit, eTeam_XCom);

    // Remove the panicked effect
    PanicEffect = CivilianUnit.GetUnitAffectedByEffectState(class'X2AbilityTemplateManager'.default.PanickedName);
    if (PanicEffect != none)
    {
        NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState( "Remove Civilian Panic" );
        PanicEffect.RemoveEffect(NewGameState, NewGameState, true);
        `TACTICALRULES.SubmitGameState(NewGameState);
    }
}

defaultproperties
{
    ObjName="Control Civilian"

    bConvertedForReplaySystem=true
    bCanBeUsedForGameplaySequence=true

    VariableLinks.Empty
    VariableLinks(0)=(ExpectedType=class'SeqVar_GameUnit',LinkDesc="Civilian Unit",PropertyName=CivilianUnit,bWriteable=TRUE)
}