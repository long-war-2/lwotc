//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_ReactionFireAntiCover
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Reduces the effectiveness of cover when the unit is shot at by reaction
//           fire.
//---------------------------------------------------------------------------------------
class X2Effect_ReactionFireAntiCover extends X2Effect_Persistent;

var int AimBonus;

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local GameRulesCache_VisibilityInfo VisInfo;
	local X2AbilityToHitCalc_StandardAim ToHitCalc;
	local ShotModifierInfo ModInfo;
	local int CoverValue;

	// Don't apply the bonus if this isn't a reaction fire attack or if
	// cover bonuses are ignored
	ToHitCalc = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
	if (ToHitCalc == none || !ToHitCalc.bReactionFire || ToHitCalc.bMeleeAttack)
		return;

	if (`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(Attacker.ObjectID, Target.ObjectID, VisInfo))
	{
		if (Target.CanTakeCover() && VisInfo.TargetCover != CT_None)
		{
			// Target has cover relative to attacker, so apply Aim bonus
			switch (VisInfo.TargetCover)
			{
			case CT_MidLevel:           //  half cover
				CoverValue = class'X2AbilityToHitCalc_StandardAim'.default.LOW_COVER_BONUS;
				break;
			case CT_Standing:           //  full cover
				CoverValue = class'X2AbilityToHitCalc_StandardAim'.default.HIGH_COVER_BONUS;
				break;
			}

			ModInfo.ModType = eHit_Success;
			ModInfo.Reason = FriendlyName;
			ModInfo.Value = Min(CoverValue, AimBonus);
			ShotModifiers.AddItem(ModInfo);
		}
	}
}
