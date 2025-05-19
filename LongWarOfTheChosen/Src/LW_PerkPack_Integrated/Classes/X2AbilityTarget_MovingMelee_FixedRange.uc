//---------------------------------------------------------------------------------------
//  FILE:    X2AbilityTarget_MovingMelee_FixedRange.uc
//  AUTHOR:  Merist
//  PURPOSE: Targeting style for melee abilities with fixed range
//---------------------------------------------------------------------------------------
class X2AbilityTarget_MovingMelee_FixedRange extends X2AbilityTarget_MovingMelee;

// X2AbilityTarget_MovingMelee is a native method that relies on MovementRangeAdjustment
// to imitate the action cost for a dashing melee attacks.
// Since we update MovementRangeAdjustment, we need a different variable to store the fixed range.
var int iFixedRange;

simulated function name GetPrimaryTargetOptions(const XComGameState_Ability Ability, out array<AvailableTarget> Targets)
{
    UpdateParameters(Ability);
    return super.GetPrimaryTargetOptions(Ability, Targets);
}

simulated function bool ValidatePrimaryTargetOption(const XComGameState_Ability Ability, XComGameState_Unit SourceUnit, XComGameState_BaseObject TargetObject)
{
    UpdateParameters(Ability);
    return super.ValidatePrimaryTargetOption(Ability, SourceUnit, TargetObject);
}

simulated function UpdateParameters(XComGameState_Ability Ability)
{
    local XComGameState_Unit SourceUnit; 

    SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Ability.OwnerStateObject.ObjectID));
    
    if (SourceUnit == none)
        return;
    
    // Sanity check
    // Negative MovementRangeAdjustment won't do anything anyway
    MovementRangeAdjustment = Max(0, SourceUnit.NumActionPointsForMoving() - iFixedRange);

    // `LOG("Adjusting MovementRangeAdjustment: " $ MovementRangeAdjustment, true, 'X2AbilityTarget_MovingMelee_FixedRange');
}