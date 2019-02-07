//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_BodyShield
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up damage mitigation from AF
//--------------------------------------------------------------------------------------- 

class X2Effect_BodyShield extends X2Effect_Persistent config (LW_SoldierSkills);

var int BodyShieldDefBonus;
var int BodyShieldCritMalus;

//function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{

    local ShotModifierInfo					ShotInfo1, ShotInfo2;
	local XComGameState_Unit				EffectSource;

	EffectSource = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	if(Target.ObjectID == EffectSource.ObjectID)
	{
		ShotInfo1.ModType = eHit_Success;
		ShotInfo1.Reason = FriendlyName;
		ShotInfo1.Value = -1 * BodyShieldDefBonus;
		ShotModifiers.AddItem(ShotInfo1);

		ShotInfo2.ModType = eHit_Crit;
		ShotInfo2.Reason = FriendlyName;
		ShotInfo2.Value = -1 * BodyShieldCritMalus;
		ShotModifiers.AddItem(ShotInfo2);
	}
}

