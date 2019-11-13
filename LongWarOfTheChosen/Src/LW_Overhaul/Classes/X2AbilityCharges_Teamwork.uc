//---------------------------------------------------------------------------------------
//  FILE:    X2AbilityCharges_Teamwork.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Sets the number of charges for Teamwork/Advanced Teamwork based on the
//           bond level.
//---------------------------------------------------------------------------------------
class X2AbilityCharges_Teamwork extends X2AbilityCharges;

var array<int> Charges;

function int GetInitialCharges(XComGameState_Ability Ability, XComGameState_Unit Unit)
{
	local SoldierBond BondData;
	local StateObjectReference BondmateRef;

    Unit.HasSoldierBond(BondmateRef, BondData);
    return Charges[BondData.BondLevel - 1];
}

