//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_TemplarShieldCritDefense
//  AUTHOR:  Tedster - modified from Iago/bg
//  PURPOSE: Gives the unit some crit mitigation even when flanked.
//--------------------------------------------------------------------------------------- 
class X2Effect_TemplarShieldCritDefense extends X2Effect_Persistent config(LW_FactionBalance);

var config int CritReduction;

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ModInfo;

	if (bFlanking) //if flanked
		{

			ModInfo.ModType = eHit_Crit;
			ModInfo.Reason = FriendlyName;
			ModInfo.Value = 0 - default.CritReduction;

			ShotModifiers.AddItem(ModInfo);

		}
}

DefaultProperties
{
	EffectName = "TemplarCritReduction"
	DuplicateResponse = eDupe_Refresh;
	bApplyOnHit = true;
	bApplyOnMiss = true;
}
