///---------------------------------------------------------------------------------------
//  FILE:    X2Effect_Savior
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Implements effect for Savior ability -- this is a triggering effect that occurs when a medikit heal is applied
//--------------------------------------------------------------------------------------- 
//---------------------------------------------------------------------------------------
class X2Effect_Savior extends X2Effect_Persistent;

`include(LW_PerkPack_Integrated\LW_PerkPack.uci)

var localized string strSavior_WorldMessage;
var int BonusHealAmount;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;
	EventMgr.RegisterForEvent(EffectObj, 'XpHealDamage', class'XComGameState_Effect_Savior'.static.OnMedikitHeal, ELD_OnStateSubmitted, 85,,, EffectObj);
}

defaultproperties
{
	EffectName="Savior";
	GameStateEffectClass=class'XComGameState_Effect_Savior';
	DuplicateResponse=eDupe_Ignore
	bRemoveWhenSourceDies=true;
}
