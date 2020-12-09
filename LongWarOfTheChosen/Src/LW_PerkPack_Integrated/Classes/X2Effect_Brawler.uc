//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_Brawler
//  AUTHOR:  Grobobobo
//  PURPOSE: Sets up the DR bonus for brawler
//---------------------------------------------------------------------------------------
class X2Effect_Brawler extends X2Effect_Persistent config (LW_SoldierSkills);

var config float BRAWLER_DR_PCT;
var config int BRAWLER_MAX_TILES;


function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	local int   Tiles;

	Tiles = Attacker.TileDistanceBetween(XComGameState_Unit(TargetDamageable));       
	if (Tiles < default.BRAWLER_MAX_TILES)
	{
        return -CurrentDamage * default.BRAWLER_DR_PCT / 100;
    }
	
	return 0;
}

defaultproperties
{
	DuplicateResponse=eDupe_Ignore
	EffectName="Brawler"
	bDisplayInSpecialDamageMessageUI=true
}
