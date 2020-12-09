//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_InstantReactionTime
//  AUTHOR:  Grobobobo
//  PURPOSE: Sets up dodge bonuses for IRT
//---------------------------------------------------------------------------------------
class X2Effect_InstantReactionTime extends X2Effect_Persistent config (LW_SoldierSkills);

var config int IRT_DODGE_PER_TILE;

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo				ShotInfo;
	local int							Tiles;

	Tiles = Attacker.TileDistanceBetween(Target);       

	ShotInfo.ModType = eHit_Graze;
	ShotInfo.Reason = FriendlyName;
	ShotInfo.Value = default.IRT_DODGE_PER_TILE * Tiles;
	ShotModifiers.AddItem(ShotInfo);
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
    EffectName="InstantReactionTime"
}
