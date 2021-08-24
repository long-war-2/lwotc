class X2Effect_InitCanisterAbility extends X2Effect;

var name CanisterAbility; // SparkCanisterAbility;
var name DamageType;
var array<name> Sparkthrowers;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local X2AbilityTemplateManager	AbilityManager;
	local X2AbilityTemplate			AbilityTemplate;
	local XComGameState_Unit		NewUnitState;
	local X2WeaponTemplate			WeaponTemplate;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	NewUnitState = XComGameState_Unit(kNewTargetState);

	WeaponTemplate = X2WeaponTemplate(NewUnitState.GetPrimaryWeapon().GetMyTemplate());

	if (WeaponTemplate.WeaponCat == 'lwchemthrower' || class'X2Item_ChemthrowerUpgrades'.default.Sparkthrowers.Find(NewUnitState.GetPrimaryWeapon().GetMyTemplateName()) != INDEX_NONE)
	{
		AbilityTemplate = AbilityManager.FindAbilityTemplate(CanisterAbility);
		if ( AbilityTemplate != none )
		{
			if ( !NewUnitState.HasSoldierAbility(CanisterAbility) )
			{
				//they don't already have it, so init it.
				`TACTICALRULES.InitAbilityForUnit(AbilityTemplate, NewUnitState, NewGameState, NewUnitState.GetPrimaryWeapon().GetReference());
			}
		}
	}
	/*
	else if ( Sparkthrowers.Find(NewUnitState.GetPrimaryWeapon().GetMyTemplateName()) != INDEX_NONE)
	{
		AbilityTemplate = AbilityManager.FindAbilityTemplate(CanisterAbility);
		if ( AbilityTemplate != none )
		{
			if ( !NewUnitState.HasSoldierAbility(SparkCanisterAbility) )
			{
				//they don't already have it, so init it.
				`TACTICALRULES.InitAbilityForUnit(AbilityTemplate, NewUnitState, NewGameState, NewUnitState.GetPrimaryWeapon().GetReference());
			}
		}
	}
	*/
}