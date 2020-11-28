//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_PaleHorse_LW
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Modified version of Pale Horse (Soul Harvest) that can apply to all
//           weapons and has a base crit bonus in addition to the per-kill bonus.
//---------------------------------------------------------------------------------------

class X2Effect_PaleHorse_LW extends X2Effect_PaleHorse;

var int BaseCritBonus;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ModInfo;
	local XComGameState_Effect_PaleHorse PaleHorseEffectState;

	PaleHorseEffectState = XComGameState_Effect_PaleHorse(EffectState);

	// Match the source weapon if the ability is tied to a weapon slot, otherwise
	// accept any weapon
	if (AbilityState.SourceWeapon == PaleHorseEffectState.ApplyEffectParameters.ItemStateObjectRef ||
		PaleHorseEffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID == 0)
	{
		ModInfo.ModType = eHit_Crit;
		ModInfo.Value = BaseCritBonus + PaleHorseEffectState.CurrentCritBoost;
		ModInfo.Reason = FriendlyName;
		ShotModifiers.AddItem(ModInfo);
	}
}
