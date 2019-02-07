//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_HardTarget
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up dodge bonuses for Hard Target -- Soldier gains +X dodge per target in view, up to a maximum 
//---------------------------------------------------------------------------------------
class X2Effect_HardTarget extends X2Effect_Persistent config (LW_SoldierSkills);

var config int HT_DODGE_BONUS_PER_ENEMY;
var config int HT_MAX_DODGE_BONUS;
var config bool HT_SQUADSIGHT_ENEMIES_APPLY;

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{

    local ShotModifierInfo				ShotInfo;
	local int							BadGuys;
	local array<StateObjectReference>	arrSSEnemies;

	if (Target.IsImpaired(false) || Target.IsBurning() || Target.IsPanicked())
		return;

	BadGuys = Target.GetNumVisibleEnemyUnits (true, false, false, -1, false, false);
	if (Target.HasSquadsight() && default.HT_SQUADSIGHT_ENEMIES_APPLY)
	{
		class'X2TacticalVisibilityHelpers'.static.GetAllSquadsightEnemiesForUnit(Target.ObjectID, arrSSEnemies, -1, false);
		BadGuys += arrSSEnemies.length;
	}
	if (BadGuys > 0)
	{
		ShotInfo.ModType = eHit_Graze;
		ShotInfo.Reason = FriendlyName;
		ShotInfo.Value = Clamp (BadGuys * default.HT_DODGE_BONUS_PER_ENEMY, 0, default.HT_MAX_DODGE_BONUS);
		ShotModifiers.AddItem(ShotInfo);
	}
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
    EffectName="HardTarget"
}

