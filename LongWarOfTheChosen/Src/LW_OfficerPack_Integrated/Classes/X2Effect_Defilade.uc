//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_Defilade
//  AUTHOR:  John Lumpkin / Pavonis Interactive
//  PURPOSE: Adds effect for Defilade ability
//--------------------------------------------------------------------------------------- 
Class X2Effect_Defilade extends X2Effect_LWOfficerCommandAura
	config (LW_OfficerPack);

var config int DEFILADE_DEFENSE_BONUS;

//Implements Defilade ability

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo					ModInfo;
	local GameRulesCache_VisibilityInfo		VisInfo;

 //swapped attacker to target to fix #1554 in LWOTC repository
	if (IsEffectCurrentlyRelevant(EffectState, Target))
	{
		if((Target.CanTakeCover()) && (!bFlanking) && (X2TacticalGameRuleset(XComGameInfo(class'Engine'.static.GetCurrentWorldInfo().Game).GameRuleset).VisibilityMgr.GetVisibilityInfo(Attacker.ObjectID, Target.ObjectID, VisInfo)))
		{
			if (VisInfo.TargetCover != 0)
			{
				ModInfo.ModType = eHit_Success;
				ModInfo.Reason = FriendlyName;
				ModInfo.Value = -default.DEFILADE_DEFENSE_BONUS;
				ShotModifiers.AddItem(ModInfo);
			}
		}
	}
}

defaultproperties
{
	EffectName=Defilade;
}