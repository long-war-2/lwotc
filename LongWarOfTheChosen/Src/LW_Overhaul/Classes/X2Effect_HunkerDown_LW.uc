//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_HunkerDown_LW.uc
//  AUTHOR:  JL (Pavonis Interactive)
//  PURPOSE: Reworks Hunker Down so it doesn't apply bonii when flanked
//--------------------------------------------------------------------------------------- 

class X2Effect_HunkerDown_LW extends X2Effect_Persistent config (LW_SoldierSkills);

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local GameRulesCache_VisibilityInfo			VisInfo;
    local ShotModifierInfo						ShotInfo;

	if (Target != none)
	{
		if(X2TacticalGameRuleset(XComGameInfo(class'Engine'.static.GetCurrentWorldInfo().Game).GameRuleset).VisibilityMgr.GetVisibilityInfo(Attacker.ObjectID, Target.ObjectID, VisInfo))
		{
			if (Target.CanTakeCover() && (VisInfo.TargetCover == CT_Midlevel || VisInfo.TargetCover == CT_Standing))
			{
				ShotInfo.ModType = eHit_Success;
				ShotInfo.Reason = FriendlyName;
				ShotInfo.Value = -1 * (class'X2Ability_DefaultAbilitySet'.default.HUNKERDOWN_DEFENSE);
				ShotModifiers.AddItem(ShotInfo);

				ShotInfo.ModType = eHit_Graze;
				ShotInfo.Reason = FriendlyName;
				ShotInfo.Value = class'X2Ability_DefaultAbilitySet'.default.HUNKERDOWN_DODGE;
				ShotModifiers.AddItem(ShotInfo);
			}
		}
	}
}
