//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_RapidDeployment.uc
//  AUTHOR:  Aminer (Pavonis Interactive)
//  PURPOSE: Grants an 1 turn effect that the next use of throw grenade for smoke or flash a free action
//--------------------------------------------------------------------------------------- 

class X2Effect_RapidDeployment extends X2Effect_Persistent config (LW_SoldierSkills);

`include(LW_PerkPack_Integrated\LW_PerkPack.uci)

var config int RAPID_DEPLOYMENT_COOLDOWN;
var config array<name> VALID_ABILITIES;
var config array<name> VALID_GRENADE_ABILITIES;
var config array<name> VALID_GRENADE_TYPES;

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local name						AbilityName;
	local name						TestName;
	local XComGameState_Ability		AbilityState;
	local bool						bFreeActivation;
	local XComGameState_Item		SourceWeapon;
	local X2WeaponTemplate			SourceWeaponAmmoTemplate;

	if(kAbility == none)
		return false;

	SourceWeapon = kAbility.GetSourceWeapon();
	AbilityName = kAbility.GetMyTemplateName();

	`PPTRACE("Rapid Deployment : AbilityName=" $ AbilityName $ ", SourceWeapon=" $ SourceWeapon.GetMyTemplateName());

	if (SourceWeapon == none)
		return false;

	`PPTRACE("Rapid Deployment : Found Valid Source Weapon");
	foreach default.VALID_ABILITIES(TestName)
	{
		`PPTRACE("Rapid Deployment : VALID_ABILITIES=" $ TestName);
	}
	if (default.VALID_ABILITIES.Find(AbilityName) != -1)
		bFreeActivation = true;

	foreach default.VALID_GRENADE_ABILITIES(TestName)
	{
		`PPTRACE("Rapid Deployment : VALID_GRENADE_ABILITIES=" $ TestName);
	}
	if(default.VALID_GRENADE_ABILITIES.Find(AbilityName) != -1)
	{
		`PPTRACE("Rapid Deployment : Found Valid Grenade Ability");
		foreach default.VALID_GRENADE_TYPES(TestName)
		{
			`PPTRACE("Rapid Deployment : VALID_GRENADE_TYPES=" $ TestName);
		}
		if (default.VALID_GRENADE_TYPES.Find(SourceWeapon.GetMyTemplateName()) != -1)
		{
			`PPTRACE("Rapid Deployment : Found Valid Grenade Weapon Type");
			bFreeActivation = true;
		}

		SourceWeaponAmmoTemplate = X2WeaponTemplate(SourceWeapon.GetLoadedAmmoTemplate(kAbility));
		`PPTRACE("Rapid Deployment : SourceWeaponAmmo=" $ SourceWeaponAmmoTemplate.DataName);
		if (SourceWeaponAmmoTemplate != none )
		{
			if (default.VALID_GRENADE_TYPES.Find(SourceWeaponAmmoTemplate.DataName) != -1)
			{
				`PPTRACE("Rapid Deployment : Found Valid Grenade Ammo Type");
				bFreeActivation = true;
			}
		}
	}
	if(bFreeActivation)
	{
		`PPTRACE("Rapid Deployment : Triggered Free Activation");
		if (SourceUnit.ActionPoints.Length != PreCostActionPoints.Length)
		{
			AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
			if (AbilityState != none)
			{
				SourceUnit.ActionPoints = PreCostActionPoints;
				EffectState.RemoveEffect(NewGameState, NewGameState);

				`XEVENTMGR.TriggerEvent('RapidDeployment', AbilityState, SourceUnit, NewGameState);

				return true;
			}
		}
	}
	return false;
}