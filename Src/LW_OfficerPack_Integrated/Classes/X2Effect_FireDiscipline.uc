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
	if (IsEffectCurrentlyRelevant(none, UnitState))
	{
		Modifier = default.FIREDISCIPLINE_REACTIONFIRE_BONUS;
	}
}

defaultproperties
{
 	EffectName=FireDiscipline;
}