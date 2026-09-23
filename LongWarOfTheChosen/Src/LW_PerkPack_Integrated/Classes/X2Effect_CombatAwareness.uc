//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_CombatAwareness
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up armor and defense bonuses for Combat Awareness; template definition
//	specifies effect as conditional on having an OW point
//---------------------------------------------------------------------------------------
class X2Effect_CombatAwareness extends X2Effect_BonusArmor config (LW_SoldierSkills);

var config int COMBAT_AWARENESS_BONUS_ARMOR;
var config int COMBAT_AWARENESS_BONUS_DEFENSE;
var config bool COMBAT_AWARENESS_APPLY_TO_SUPPRESSION;
// DEPRECATED
// var config int COMBAT_AWARENESS_BONUS_ARMOR_CHANCE;

var int ArmorBonus;
var int DefenseBonus;
var array<name> AllowedActionPointTypes;

function bool ValidateReservePoints(XComGameState_Unit UnitState)
{
	local name ActionPointName;
	if (AllowedActionPointTypes.Length > 0)
	{
		foreach UnitState.ReserveActionPoints(ActionPointName)
		{
			if (AllowedActionPointTypes.Find(ActionPointName) != INDEX_NONE)
			{
				return true;
			}
		}
		return false;
	}

	return UnitState.ReserveActionPoints.Length > 0;
}

function int GetArmorMitigation(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
	if (UnitState.IsImpaired(false, false) || UnitState.IsBurning() || UnitState.IsPanicked())
	{
		return 0;
	}
	if (ValidateReservePoints(UnitState))
	{
		return ArmorBonus;
	}
	return 0;
}
	
function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ShotInfo;

	if (Target.IsImpaired(false, false) || Target.IsBurning() || Target.IsPanicked())
	{
		return;
	}

	if (ValidateReservePoints(Target))
	{
		ShotInfo.ModType = eHit_Success;
		ShotInfo.Reason = FriendlyName;
		ShotInfo.Value = -1 * DefenseBonus;
		ShotModifiers.AddItem(ShotInfo);
	}
}

defaultproperties
{
	EffectName = "CombatAwareness"
	DuplicateResponse = eDupe_Ignore
}