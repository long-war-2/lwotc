//---------------------------------------------------------------------------------------
//  FILE:    XMBEffectInterface.uc
//  AUTHOR:  xylthixlm
//
//  This provides an interface which X2Effect subclasses can implement to interact with
//  XModBase classes. It is mostly used for defining ability tags that can be used in
//  localization files.
//
//  DEPENDENCIES
//
//  This doesn't depend on anything, but the provided functions will not function
//  without the classes in XModBase/Classes/ installed.
//---------------------------------------------------------------------------------------
interface XMBEffectInterface;


/////////////////////////
// Interface functions //
/////////////////////////

// This provides a way for an X2Effect to define its own localization tags. When an .int file such 
// as XComGame.int has an ability tag like "<Ability:ToHit/>", XMBAbilityTag will call GetTagValue
// on the effects of the associated ability. GetTagValue should either return true and put the
// string to replace the ability tag with in TagValue, or return false and leave TagValue 
// unchanged if it does not handle the tag.
//
// Tag: The tag type ('ToHit' in the example above).
// AbilityState: The current state of the associated ability if in tactical play, or none if in
// strategic play.
// TagValue: No meaning as input; the result should be stored here if this effect handles the tag.
function bool GetTagValue(name Tag, XComGameState_Ability AbilityState, out string TagValue);

// This function provides a way for XMB classes to communicate with each other. If given a Type
// it has no special handling for, it should do nothing and return false.
function bool GetExtModifiers(name Type, XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, optional ShotBreakdown ShotBreakdown, optional out array<ShotModifierInfo> ShotModifiers);

// This function provides a way for XMB classes to communicate with each other. If given a tuple
// it has no special handling for, it should do nothing and return false.
function bool GetExtValue(LWTuple Data);
