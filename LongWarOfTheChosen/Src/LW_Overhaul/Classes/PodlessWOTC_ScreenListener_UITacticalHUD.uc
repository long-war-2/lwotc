// This code is based on the All Pods Active mod, created by Axio.

class PodlessWOTC_ScreenListener_UITacticalHUD extends UIScreenListener config (PodlessWOTC);

event OnInit(UIScreen screen)
{
    `XCOMHISTORY.RegisterOnNewGameStateDelegate(OnNewGameState);
}

event OnRemoved(UIScreen screen)
{
    `XCOMHISTORY.UnRegisterOnNewGameStateDelegate(OnNewGameState);
}

private function OnNewGameState(XComGameState newGameState)
{
    local XComGameStateContext context;
    context = newGameState.GetContext();
    
    if(context.IsA('XComGameStateContext_ChangeContainer'))
    {
        //`redscreen("New game state:"$XComGameStateContext_ChangeContainer(context).ChangeInfo);
        if(XComGameStateContext_ChangeContainer(context).ChangeInfo == "Unit Concealment Broken")
        {
            AlertIfPlayerRevealed(newGameState);
        }
        else if(XComGameStateContext_ChangeContainer(context).ChangeInfo == "ResetHitCountersOnPlayerTurnBegin")
        {
            AlertIfPlayerRevealed(newGameState);
        }
    }
}

defaultProperties
{
    ScreenClass = UITacticalHUD
}


function  AlertIfPlayerRevealed(XComGameState newGameState) {
    local XComGameStateHistory History;
    local XComGameState_Unit UnitState;
    
    History = `XCOMHISTORY;
    foreach History.IterateByClassType(class'XComGameState_Unit', UnitState)
    {
        if (!UnitState.ControllingPlayerIsAI()  
            && !UnitState.bRemovedFromPlay
            && UnitState.IsAlive()
            && !UnitState.IsConcealed())
        {
            AlertAllUnits(UnitState, newGameState);
            break;
        }
    }
}		

function AlertAllUnits(XComGameState_Unit Unit, XComGameState newGameState)
{
    local XComGameStateHistory History;
    local XComGameState_AIGroup AIGroupState;
    local array<int> LivingUnits;
    local XComGameState_Unit Member;
    local int Id;
    local bool UnitSeen;

    History = `XCOMHISTORY;

    if (class'X2TacticalVisibilityHelpers'.static.GetNumVisibleEnemyTargetsToSource(Unit.ObjectID) > 0)
    {
        UnitSeen = true;
    }
    else {
        UnitSeen = false;
    }

    foreach History.IterateByClassType(class'XComGameState_AIGroup', AIGroupState)
    {
        AIGroupState.ApplyAlertAbilityToGroup(eAC_SeesSpottedUnit);
	    AIGroupState.InitiateReflexMoveActivate(Unit, eAC_SeesSpottedUnit);
        
        if (UnitSeen == true)
        {
            AIGroupState.GetLivingMembers(LivingUnits);
            foreach LivingUnits(Id)
            {
                Member = XComGameState_Unit(History.GetGameStateForObjectID(Id));
                class'XComGameState_Unit'.static.UnitAGainsKnowledgeOfUnitB(Member, Unit, newGameState, eAC_SeesSpottedUnit, false);
            }
        }
    }
}


