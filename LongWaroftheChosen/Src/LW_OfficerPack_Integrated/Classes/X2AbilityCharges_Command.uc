class X2AbilityCharges_Command extends X2AbilityCharges;

var int LT2Charges;
var int LT1Charges;
var int CAPTCharges;
var int MAJCharges;
var int LTCCharges;
var int COLCharges;
var int CMDRCharges;

function int GetInitialCharges(XComGameState_Ability Ability, XComGameState_Unit Unit)
{
	local int TotalCharges, Rank;
	local XComGameState_Unit_LWOfficer OfficerState;

	TotalCharges = LT2Charges;
	OfficerState = class'LWOfficerUtilities'.static.GetOfficerComponent(Unit);
	if (OfficerState != none)
	{
		Rank = OfficerState.GetOfficerRank();
		if (Rank > 1)
			TotalCharges += LT1Charges;
		if (Rank > 2)
			TotalCharges += CAPTCharges;
		if (Rank > 3)
			TotalCharges += MAJCharges;
		if (Rank > 4)
			TotalCharges += LTCCharges;
		if (Rank > 5)
			TotalCharges += COLCharges;
		if (Rank > 6)
			TotalCharges += CMDRCharges;
	}
	return TotalCharges;
}

