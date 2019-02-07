//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_SimpleHeal.uc
//  AUTHOR:	 John Lumpkin (Pavonis Interactive)
//  PURPOSE: 
//--------------------------------------------------------------------------------------- 

class X2Effect_SimpleHeal extends X2Effect;

//var int HEAL_AMOUNT;

protected simulated function OnEffectAdded (const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameStateHistory		History;
	local XComGameState_Ability		Ability;
	local XComGameState_Item		SourceWeapon;
	local XComGameState_Unit		SourceUnit;
	local XComGameState_Unit		TargetUnit;
	local X2WeaponTemplate			WeaponTemplate;

	History = `XCOMHISTORY;
	Ability = XComGameState_Ability(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
	if (Ability == none)
		Ability = XComGameState_Ability(History.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
	TargetUnit = XComGameState_Unit(kNewTargetState);

	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	SourceWeapon = XComGameState_Item(History.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));
	if(SourceWeapon != none)
		WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());

	if(WeaponTemplate == none)
	{
		`REDSCREEN("X2Effect_SimpleHeal : Invalid WeaponTemplate.");
		return;
	}
	if(SourceUnit == none)
	{
		`REDSCREEN("X2Effect_SimpleHeal : Invalid SourceUnit.");
		return;
	}
	if(Ability == none)
	{
		`REDSCREEN("X2Effect_SimpleHeal : Invalid Ability.");
		return;
	}
	if(TargetUnit == none)
	{
		`REDSCREEN("X2Effect_SimpleHeal : Invalid TargetUnit.");
		return;
	}
	TargetUnit.ModifyCurrentStat(eStat_HP, WeaponTemplate.BaseDamage.Damage);
}
