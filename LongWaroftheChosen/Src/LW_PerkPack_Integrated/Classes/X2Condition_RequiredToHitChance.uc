//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_RequiredToHitChance.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Defines a new condition in which some minimal to-hit chance is required
//--------------------------------------------------------------------------------------- 
class X2Condition_RequiredToHitChance extends X2Condition config (LW_SoldierSkills);

`include(..\..\XComGame\Mods\LongWaroftheChosen\Src\LW_PerkPack_Integrated\LW_PerkPack.uci)

var int MinimumRequiredHitChance;
var array<name> ExcludedAbilities; // if target has any of these abilities, then the minimum requirement is ignored
var config int LowAbilityMinimumRequiredHitChance;
var config int MidAbilityMinimumRequiredHitChance;
var config int HighAbilityMinimumRequiredHitChance;
var config bool LIMIT_SHOTGUN_OW_RANGE;
var config int SHOTGUN_OW_RANGE;

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
	local XComGameStateHistory		History;
	local X2AbilityTemplate			AbilityTemplate;
	local X2AbilityToHitCalc		ToHitCalc;
	local int						HitChance, FinalMinimumRequiredHitChance;
	local AvailableTarget			Target;
	local StateObjectReference		AbilityRef;
	local XComGameState_Unit		kTargetUnit, AttackingUnit;
	local XComGameState_Ability		Ability;
	local name						AbilityName;
	//local X2WeaponTemplate			Weapon;
	local XComGameState_Item		WeaponItem;

	History = `XCOMHISTORY;
	kTargetUnit = XComGameState_Unit(kTarget);
	foreach ExcludedAbilities(AbilityName)
	{
		if (kTargetUnit != none)
		{
			AbilityRef = kTargetunit.FindAbility(AbilityName); //'LightningReflexes_LW');
			Ability = XComGameState_Ability(History.GetGameStateForObjectID(AbilityRef.ObjectID));
			if (Ability != none)
				return 'AA_Success'; 
		}
	}
	AbilityTemplate = kAbility.GetMyTemplate();
	
	//`PPDEBUG("RequiredToHitChance: Testing");

	FinalMinimumRequiredHitChance = MinimumRequiredHitChance;
	AttackingUnit = XComGameState_Unit(History.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));
	if (AttackingUnit !=none)
	{
		if (AttackingUnit.HasSoldierAbility('FireControl25'))
			FinalMinimumRequiredHitChance = LowAbilityMinimumRequiredHitChance;
		if (AttackingUnit.HasSoldierAbility('FireControl50'))
			FinalMinimumRequiredHitChance = MidAbilityMinimumRequiredHitChance;
		if (AttackingUnit.HasSoldierAbility('FireControl75'))
			FinalMinimumRequiredHitChance = HighAbilityMinimumRequiredHitChance;
	}

	ToHitCalc = AbilityTemplate.AbilityToHitCalc;	
	if(ToHitCalc != none)
	{
		Target.PrimaryTarget = kTarget.GetReference();
		HitChance = ToHitCalc.GetShotBreakdown(kAbility, Target);
		//`PPDEBUG("RequiredToHitChance: CurrentHitChance = " $ HitChance);
		if(HitChance < FinalMinimumRequiredHitChance)
		{
			return 'AA_NotInRange';
		}
	}

	WeaponItem = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(kAbility.SourceWeapon.ObjectID));
	//Weapon = X2WeaponTemplate(WeaponItem.GetMyTemplate());

	if (WeaponItem.GetWeaponCategory() == 'shotgun' && default.LIMIT_SHOTGUN_OW_RANGE)
	{
		if (AttackingUnit.TileDistanceBetween (kTargetUnit) > default.SHOTGUN_OW_RANGE)
		{
			return 'AA_NotInRange';
		}
	}
	return 'AA_Success'; 
}
