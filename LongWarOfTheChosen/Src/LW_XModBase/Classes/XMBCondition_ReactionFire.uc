//---------------------------------------------------------------------------------------
//  FILE:    XMBCondition_ReactionFire.uc
//  AUTHOR:  xylthixlm
//
//  A condition that requires that an attack be considered reaction fire. This is
//  intended for use with persistent effects that check conditions, such as
//  XMBEffect_ConditionalBonus.
//
//  USAGE
//
//  XMBAbility provides a default instance of this class:
//
//  default.ReactionFireCondition		The attack is reaction fire
//
//  EXAMPLES
//
//  The following examples in Examples.uc use this class:
//
//  MovingTarget
//
//  INSTALLATION
//
//  Install the XModBase core as described in readme.txt. Copy this file, and any files 
//  listed as dependencies, into your mod's Classes/ folder. You may edit this file.
//
//  DEPENDENCIES
//
//  None.
//---------------------------------------------------------------------------------------
class XMBCondition_ReactionFire extends X2Condition;

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
	local X2AbilityToHitCalc_StandardAim StandardAim;

	StandardAim = X2AbilityToHitCalc_StandardAim(kAbility.GetMyTemplate().AbilityToHitCalc);
	if (StandardAim == none || !StandardAim.bReactionFire)
		return 'AA_NotReactionFire';  // NOTE: Nonstandard AA code

	return 'AA_Success';
}