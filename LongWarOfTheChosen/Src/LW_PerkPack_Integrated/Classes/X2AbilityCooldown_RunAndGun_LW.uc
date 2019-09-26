//---------------------------------------------------------------------------------------
//  FILE:    X2AbilityCooldown_RunAndGun_LW.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//---------------------------------------------------------------------------------------
class X2AbilityCooldown_RunAndGun_LW extends X2AbilityCooldown config(LW_SoldierSkills);

//`include(LW_PerkPack_Integrated\LW_PerkPack.uci)

var config int RUN_AND_GUN_COOLDOWN;
var config int EXTRA_CONDITIONING_COOLDOWN_REDUCTION;

simulated function int GetNumTurns(XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	`PPTRACE ("GNT" @  default.RUN_AND_GUN_COOLDOWN);
	if (XComGameState_Unit(AffectState).HasSoldierAbility('ExtraConditioning'))
	{
		`PPTRACE ("GNT1" @ default.EXTRA_CONDITIONING_COOLDOWN_REDUCTION);
		return default.RUN_AND_GUN_COOLDOWN - default.EXTRA_CONDITIONING_COOLDOWN_REDUCTION;
	}
	`PPTRACE("GNT2");
	return default.RUN_AND_GUN_COOLDOWN;
}

