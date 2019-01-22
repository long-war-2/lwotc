//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_ArcthrowerStun.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Stunning effect with tech dependendent stun duration
//---------------------------------------------------------------------------------------
class X2Effect_ArcthrowerStunned extends X2Effect_Stunned config(LW_SoldierSkills);

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Item		SourceWeapon;
	local X2WeaponTemplate			WeaponTemplate;

	StunLevel = 2;
	SourceWeapon = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(NewEffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID));
	if(SourceWeapon != none)
		WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());

	if(WeaponTemplate != none)
		StunLevel = WeaponTemplate.iClipSize;

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}