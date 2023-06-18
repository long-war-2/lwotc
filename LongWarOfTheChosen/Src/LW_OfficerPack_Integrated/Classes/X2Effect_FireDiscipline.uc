//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_FireDiscpline
//  AUTHOR:  Amineri  (Pavonis Interactive)
//  PURPOSE: Adds effect for FireDiscipline ability
//--------------------------------------------------------------------------------------- 
class X2Effect_FireDiscipline extends X2Effect_LWOfficerCommandAura
	config (LW_OfficerPack);

var config int FIREDISCIPLINE_REACTIONFIRE_BONUS;

simulated function ModifyReactionFireSuccess(XComGameState_Unit UnitState, XComGameState_Unit TargetState, out int Modifier)
{
	local XComGameState_Effect EffectState; //add Effect State so that this actually works
	EffectState = UnitState.GetUnitAffectedByEffectState(default.EffectName);
	if(EffectState != none)
	{
		if (IsEffectCurrentlyRelevant(EffectState, UnitState))
		{
			Modifier = default.FIREDISCIPLINE_REACTIONFIRE_BONUS;
		}
	}
}

defaultproperties
{
 	EffectName=FireDiscipline;
}