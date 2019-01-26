//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_Aggression
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up crit bonus from Aggression perk
//--------------------------------------------------------------------------------------- 

class X2Effect_Aggression extends X2Effect_Persistent config (LW_SoldierSkills);

var config int AGGRESSION_CRIT_BONUS_PER_ENEMY;
var config int AGGRESSION_MAX_CRIT_BONUS;
var config bool AGG_SQUADSIGHT_ENEMIES_APPLY;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local XComGameState_Item	SourceWeapon;
    local ShotModifierInfo		ShotInfo;
	local int					BadGuys;
	local array<StateObjectReference> arrSSEnemies;

    SourceWeapon = AbilityState.GetSourceWeapon();    
    if(SourceWeapon != none)	
	{
		BadGuys = Attacker.GetNumVisibleEnemyUnits (true, false, false, -1, false, false);
		if (Attacker.HasSquadsight() && default.AGG_SQUADSIGHT_ENEMIES_APPLY)
		{
			class'X2TacticalVisibilityHelpers'.static.GetAllSquadsightEnemiesForUnit(Attacker.ObjectID, arrSSEnemies, -1, false);
			BadGuys += arrSSEnemies.length;
		}
		if (BadGuys > 0)
		{
			ShotInfo.ModType = eHit_Crit;
			ShotInfo.Reason = FriendlyName;
			ShotInfo.Value = Clamp (BadGuys * default.AGGRESSION_CRIT_BONUS_PER_ENEMY, 0, default.AGGRESSION_MAX_CRIT_BONUS);
			ShotModifiers.AddItem(ShotInfo);
		}
	}
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
    EffectName="Aggression"
}

//TEST WITH SQUADSIGHT
