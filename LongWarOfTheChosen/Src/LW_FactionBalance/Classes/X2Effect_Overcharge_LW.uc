//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_Overcharge_LW
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Grants a unit bonuses to aim and crit chance based on the unit's focus
//           level.
//---------------------------------------------------------------------------------------

class X2Effect_Overcharge_LW extends X2Effect_Persistent;

var int AimBonusPerFocus;
var int CritBonusPerFocus;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo ShotInfo;
    local int CurrentFocus;

	CurrentFocus = Attacker.GetTemplarFocusLevel();

	if (CurrentFocus > 0)
	{
		ShotInfo.ModType = eHit_Success;
		ShotInfo.Reason = FriendlyName;
		ShotInfo.Value = AimBonusPerFocus * CurrentFocus;
		ShotModifiers.AddItem(ShotInfo);

		ShotInfo.ModType = eHit_Crit;
		ShotInfo.Reason = FriendlyName;
		ShotInfo.Value = CritBonusPerFocus * CurrentFocus;
		ShotModifiers.AddItem(ShotInfo);
	}
}
