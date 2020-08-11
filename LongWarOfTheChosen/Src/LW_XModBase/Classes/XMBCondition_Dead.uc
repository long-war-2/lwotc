//---------------------------------------------------------------------------------------
//  FILE:    XMBCondition_Dead.uc
//  AUTHOR:  xylthixlm
//
//  A condition that requires that the target of an ability is dead. This is useful for
//  checks that happen after the ability has resolved, for example for checking whether
//  the ability killed the target in XMBEffect_AbilityCostRefund or 
//  XMBAbilityTrigger_EventListener.
//
//  USAGE
//
//  XMBAbility provides a default instance of this class:
//
//  default.DeadCondition					The target is dead
//
//  EXAMPLES
//
//  The following examples in Examples.uc use this class:
//
//  Assassin
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
class XMBCondition_Dead extends X2Condition;

event name CallMeetsCondition(XComGameState_BaseObject kTarget) 
{ 
	local XComGameState_Unit TargetUnit;

	TargetUnit = XComGameState_Unit(kTarget);
	if (TargetUnit == none)
		return 'AA_NotAUnit';

	if (!TargetUnit.IsDead())
		return 'AA_UnitIsAlive';

	return 'AA_Success';
}