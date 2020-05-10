//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_SilentKiller_LW
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Modifies Silent Killer to always retain concealment on a kill, instead
//           of simply not increasing the modifier. In other words, if a concealment
//           roll has already failed, then the old Silent Killer would still have a
//           chance to lose concealment. This does not.
//
//           This effect also triggers a 'SilentKillerActivated' event, so other code
//           knows when it procs. This is to enable Shadow cooldown reduction on kills.
//---------------------------------------------------------------------------------------

class X2Effect_SilentKiller_LW extends X2Effect_SilentKiller;

function bool AdjustSuperConcealModifier(XComGameState_Unit UnitState, XComGameState_Effect EffectState, XComGameState_Ability AbilityState, XComGameState RespondToGameState, const int BaseModifier, out int Modifier)
{
	local XComGameState SuperConcealedState;

	if (super.AdjustSuperConcealModifier(UnitState, EffectState, AbilityState, RespondToGameState, BaseModifier, Modifier))
	{
		// Always guarantee retaining concealment by resetting the super concealment
		// loss for the soldier.
		if (UnitState.SuperConcealmentLoss != 0)
		{
			SuperConcealedState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Silent Killer super concealment reset");
			UnitState = XComGameState_Unit(SuperConcealedState.ModifyStateObject(UnitState.Class, UnitState.ObjectID));
			UnitState.SuperConcealmentLoss = 0;
			`TACTICALRULES.SubmitGameState(SuperConcealedState);
		}

		`XEVENTMGR.TriggerEvent('SilentKillerActivated', UnitState, UnitState, RespondToGameState);
		return true;
	}
	else
	{
		return false;
	}
}
