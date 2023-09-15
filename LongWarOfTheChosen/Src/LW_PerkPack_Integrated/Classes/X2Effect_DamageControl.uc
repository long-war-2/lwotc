//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_DamageControl
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up armor bonuses for Damage Control effect
//---------------------------------------------------------------------------------------
class X2Effect_DamageControl extends X2Effect_BonusArmor;

var int BonusArmor;

function int GetArmorChance(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
    return 100;
}

function int GetArmorMitigation(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
    return BonusArmor;
}