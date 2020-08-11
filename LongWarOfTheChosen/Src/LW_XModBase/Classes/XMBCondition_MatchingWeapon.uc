//---------------------------------------------------------------------------------------
//  FILE:    XMBCondition_MatchingWeapon.uc
//  AUTHOR:  xylthixlm
//
//  A condition that checks that another ability was used with the same weapon as the 
//  ability with this condition. This is used in effects that apply bonuses to a specific
//  weapon slot. This only works with other XModBase classes that take conditions, such
//  as XMBEffect_AbilityCostRefund, XMBEffect_ConditionalBonus, and
//  XMBAbilityTrigger_EventListener.
//
//  USAGE
//
//  XMBAbility provides a default instance of this class:
//
//  default.MatchingWeaponCondition		The ability matches the weapon of the ability 
//										defining the condition
//
//  EXAMPLES
//
//  The following examples in Examples.uc use this class:
//
//  Assassin
//  Magnum
//  SlamFire
//  Weaponmaster
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
class XMBCondition_MatchingWeapon extends X2Condition;