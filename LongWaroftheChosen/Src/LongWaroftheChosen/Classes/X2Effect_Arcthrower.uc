//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_Arcthrower.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Applies effect that prevents shots from grazing or critting
//---------------------------------------------------------------------------------------
class X2Effect_Arcthrower extends X2Effect_Persistent config(GameData_WeaponData);

function bool ChangeHitResultForAttacker(XComGameState_Unit Attacker, XComGameState_Unit TargetUnit, XComGameState_Ability AbilityState, const EAbilityHitResult CurrentResult, out EAbilityHitResult NewHitResult)
{
	local XComGameState_Item		SourceWeapon;

	SourceWeapon = AbilityState.GetSourceWeapon();
	if(SourceWeapon == none)
		return false;

	//  change any miss into a hit, if we haven't already done that this turn
	if (SourceWeapon.GetWeaponCategory() == 'arcthrower' && !class'XComGameStateContext_Ability'.static.IsHitResultMiss(CurrentResult))
	{
		NewHitResult = eHit_Success;
		return true;
	}

	return false;
}