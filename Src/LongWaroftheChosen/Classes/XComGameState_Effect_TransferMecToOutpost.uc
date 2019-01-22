//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_Effect_TransferMecToOutpost.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Effect extension to allow adding an effect listener for cleaning up permanent mind-control
//---------------------------------------------------------------------------------------
class XComGameState_Effect_TransferMecToOutpost extends XComGameState_Effect
    config(GameData_SoldierSkills);

var int EnergyAbsorbed;
var transient XComGameStateContext LastEnergyExpendedContext;
var config array<config name> AbsorbedAbilities;

function EventListenerReturn UnitRemovedListener(Object EventData, Object EventSource, XComGameState GameState, name EventID, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_Unit TargetUnit;

	History = `XCOMHISTORY;

	// Any robot can be affected by full override, but only a subset of these can be transferred to the haven. Those that
	// can are given the evac ability and the player is responsible for either killing all the aliens (on appropriate missions)
	// or evacing the unit if they are to be transfered. Those that cannot be transfered need to be handled so that the mission
	// can end.
	//
	// If the human player has no units left except those that are affected by full override and that cannot evac, and the 
	// alien player has no units that are mind-controlled, we need to consider all XCOM units to be gone so the mission
	// can end. Implement this by simply killing any unit with this effect that is still in play.
	if (DidPlayerRunOutOfPlayableUnits())
	{
		TargetUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
		if (TargetUnit == none)
		{
			TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
		}

		// Remove the unit from play. This ensures that the hacked unit won't still be considered an active unit on the player's
		// team, allowing the mission to end if we got here because there are no other XCOM units remaining.
		if (!TargetUnit.bRemovedFromPlay && TargetUnit.IsAlive() && !TargetUnit.IsIncapacitated())
		{
			// Swap the unit back to the alien team before killing it, so the AAR screen shows the expected number of dead aliens
			// and XCOM units.
			`BATTLE.SwapTeams(TargetUnit, eTeam_Alien);
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Destroying remainining mastered robots");
			TargetUnit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', TargetUnit.ObjectID));
			NewGameState.AddStateObject(TargetUnit);
			TargetUnit.SetCurrentStat(eStat_HP, 0);
			`TACTICALRULES.SubmitGameState(NewGameState);
		}

		UnregisterFromEvents();
		return ELR_NoInterrupt;
	}

	return ELR_NoInterrupt;
}

function UnregisterFromEvents()
{
	local Object EffectObj;

	EffectObj = self;

	// unregister this object
	`XEVENTMGR.UnRegisterFromAllEvents(EffectObj);
}

// Checks whether the player has any playable units left. Based on KismetGameRulesetEventObserver function of same name
// Modified to not count mind-controlled unit that do not have evac ability
protected function bool DidPlayerRunOutOfPlayableUnits()
{	
	local XComGameStateHistory History;
	local XComGameState_Unit Unit;
	local bool FoundXComUnit;
	local bool FoundControlledUnit;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_Unit', Unit)
	{
		if( !Unit.GetMyTemplate().bIsCosmetic && !Unit.IsTurret() && !Unit.GetMyTemplate().bNeverSelectable )
		{
			if( Unit.IsAlive() && !Unit.bRemovedFromPlay && !Unit.IsIncapacitated() )
			{
				if (Unit.GetTeam() == eTeam_XCom)
				{
					FoundXComUnit = true;
					// If we have a unit left on the xcom team that has the evac ability, we aren't done yet:
					// For evac missions they can evac, and for non-evac missions they can kill bad guys.
					if (UnitHasEvacAbility(Unit))
					{
						return false;
					}
				}
				else if (Unit.GetTeam() == eTeam_Alien)
				{
					// If the alien team has a mind-controlled unit we aren't done yet.
					if (UnitIsMindControlled(Unit))
					{
						FoundControlledUnit = true;
					}
				}
			}
		}

	}

	// If we get here then we don't have any evac-able xcom controlled units. But, if we have *any*
	// xcom units (even those that can't evac) and we have an xcom unit currently MC'd by the aliens,
	// also don't end: The mastered unit can kill whoever is controlling the xcom unit allowing them to
	// be recovered.
	if (FoundXComUnit && FoundControlledUnit)
		return false;

	return true;
}

function bool UnitIsMindControlled(XComGameState_Unit UnitState)
{
	return UnitState.AffectedByEffectNames.Find(class'X2Effect_MindControl'.default.EffectName) != -1;
}

function bool UnitHasEvacAbility(XComGameState_Unit UnitState)
{
	return UnitState.FindAbility('Evac').ObjectID > 0;
}

function bool AnyPendingReinforcements()
{
	local XComGameState_AIReinforcementSpawner AISPawnerState;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_AIReinforcementSpawner', AISPawnerState)
	{
		break;
	}

	// true if there are any active reinforcement spawners
	return (AISPawnerState != None);
}
