//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_CombatAwareness
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up armor and defense bonuses for Combat Awareness; template definition
//	specifies effect as conditional on having an OW point
//---------------------------------------------------------------------------------------
class X2Effect_CombatAwareness extends X2Effect_BonusArmor config (LW_SoldierSkills);

var config int COMBAT_AWARENESS_BONUS_ARMOR;
var config int COMBAT_AWARENESS_BONUS_ARMOR_CHANCE;
var config int COMBAT_AWARENESS_BONUS_DEFENSE;

function int GetArmorChance(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
	if (UnitState.ReserveActionPoints.Length > 0)
	{
	    return default.COMBAT_AWARENESS_BONUS_ARMOR_CHANCE;
	}
	return 0;
}

function int GetArmorMitigation(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
	if (UnitState.ReserveActionPoints.Length > 0)
	{
	    return default.COMBAT_AWARENESS_BONUS_ARMOR;		
	}
	return 0;
}
	
function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo ShotInfo;

	if (Target.IsImpaired(false) || Target.IsBurning() || Target.IsPanicked())
		return;

	if (Target.ReserveActionPoints.Length > 0)
	{
		ShotInfo.ModType = eHit_Success;
		ShotInfo.Reason = FriendlyName;
		ShotInfo.Value = -default.COMBAT_AWARENESS_BONUS_DEFENSE;
		ShotModifiers.AddItem(ShotInfo);
	}
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
    EffectName="CombatAwareness"
}