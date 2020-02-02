//---------------------------------------------------------------------------------------
//  FILE:    X2LWModTemplate_ReaperAbilities.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Modifies existing ability templates related to Reaper soldiers.
//---------------------------------------------------------------------------------------
class X2LWModTemplate_ReaperAbilities extends X2LWTemplateModTemplate config(LW_FactionBalance);

static function UpdateAbilities(X2AbilityTemplate Template, int Difficulty)
{
	switch (Template.DataName)
	{
	case 'ThrowClaymore':
	case 'ThrowDistraction':
		PatchClaymoreTargeting(Template);
		break;
	case 'HomingMineDetonation':
		AddDistractionToHomingMine(Template);
		break;
	case 'BloodTrail':
		AddBleedingToBloodTrail(Template);
		break;
	}
}

// Use a custom cursor targeting for Claymores so we can add Bombardier
// range bonus if the unit has the ability.
static function PatchClaymoreTargeting(X2AbilityTemplate Template)
{
	local X2AbilityTarget_Cursor ClaymoreTarget;
	local X2AbilityTarget_Cursor_LW NewClaymoreTarget;

	// Copy the essential values from the original targeting object
	ClaymoreTarget = X2AbilityTarget_Cursor(Template.AbilityTargetStyle);
	NewClaymoreTarget = new class'X2AbilityTarget_Cursor_LW';
	NewClaymoreTarget.bRestrictToWeaponRange = ClaymoreTarget.bRestrictToWeaponRange;
	NewClaymoreTarget.FixedAbilityRange = ClaymoreTarget.FixedAbilityRange;

	// Configure the new targeting so it grants the bonus range from
	// the Bombardier ability.
	NewClaymoreTarget.AddAbilityRangeModifier(
		'Bombard_LW',
		`TILESTOMETERS(class'X2Ability_PerkPackAbilitySet'.default.BOMBARD_BONUS_RANGE_TILES));
	Template.AbilityTargetStyle = NewClaymoreTarget;
}

// Allow Distraction to add the disorient effect to homing mines, not just
// Claymores.
static function AddDistractionToHomingMine(X2AbilityTemplate Template)
{
	local X2Effect_PersistentStatChange DisorientedEffect;
	local X2Condition_AbilityProperty DistractionCondition;

	DistractionCondition = new class'X2Condition_AbilityProperty';
	DistractionCondition.OwnerHasSoldierAbilities.AddItem('Distraction_LW');
	DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect(, , false);
	DisorientedEffect.TargetConditions.AddItem(DistractionCondition);
	Template.AddMultiTargetEffect(DisorientedEffect);
}

static function AddBleedingToBloodTrail(X2AbilityTemplate Template)
{
	Template.AddTargetEffect(new class'X2Effect_BloodTrailBleeding');
	Template.AdditionalAbilities.AddItem('ApplyBloodTrailBleeding');
}

defaultproperties
{
	AbilityTemplateModFn=UpdateAbilities
}
