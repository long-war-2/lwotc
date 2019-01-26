//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_TacticalSense
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up defense bonus from Tactical Sense
//--------------------------------------------------------------------------------------- 

class X2Effect_TacticalSense extends X2Effect_Persistent config (LW_SoldierSkills);

var config int TACTICAL_SENSE_DEF_BONUS_PER_ENEMY;
var config int TACTICAL_SENSE_MAX_DEF_BONUS;
var config bool TS_SQUADSIGHT_ENEMIES_APPLY;

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{

    local ShotModifierInfo	ShotInfo;
	local int				BadGuys;
	local array<StateObjectReference> arrSSEnemies;

	if (Target.IsImpaired(false) || Target.IsBurning() || Target.IsPanicked())
		return;

	BadGuys = Target.GetNumVisibleEnemyUnits (true, false, false, -1, false, false);
	if (Target.HasSquadsight() && default.TS_SQUADSIGHT_ENEMIES_APPLY)
	{
		class'X2TacticalVisibilityHelpers'.static.GetAllSquadsightEnemiesForUnit(Target.ObjectID, arrSSEnemies, -1, false);
		BadGuys += arrSSEnemies.length;
	}
	if (BadGuys > 0)
	{
		ShotInfo.ModType = eHit_Success;
		ShotInfo.Reason = FriendlyName;
		ShotInfo.Value = -1 * (Clamp (BadGuys * default.TACTICAL_SENSE_DEF_BONUS_PER_ENEMY, 0, default.TACTICAL_SENSE_MAX_DEF_BONUS));
		ShotModifiers.AddItem(ShotInfo);
	}
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
    EffectName="TacticalSense"
}
