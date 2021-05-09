//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_ShieldGuard
//  AUTHOR:  Iago/bg
//  PURPOSE: Gives the unit low cover bonuses even when flanked.
//--------------------------------------------------------------------------------------- 
class X2Effect_ShieldGuard extends X2Effect_Persistent;


function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ModInfo;

	if (bFlanking) //if flanked
		{
			ModInfo.ModType = eHit_Success;
			ModInfo.Reason = FriendlyName;
			ModInfo.Value = 0 - class'X2AbilityToHitCalc_StandardAim'.default.LOW_COVER_BONUS;

			ShotModifiers.AddItem(ModInfo);

			ModInfo.ModType = eHit_Crit;
			ModInfo.Reason = FriendlyName;
			ModInfo.Value = 0 - Attacker.GetCurrentStat(eStat_FlankingCritChance);

			ShotModifiers.AddItem(ModInfo);

		}
}

DefaultProperties
{
	EffectName = "SimulatedCover"
	DuplicateResponse = eDupe_Refresh;
	bApplyOnHit = true;
	bApplyOnMiss = true;
}