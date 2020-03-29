//---------------------------------------------------------------------------------------
//  FILE:    X2LWAbilitiesModTemplate.uc
//  AUTHOR:  Peter Ledbrook
//	PURPOSE: Modifies existing ability templates.
//
//           In particular, it sets the final hit chance override delegate
//           on X2AbilityToHitCalc_StandardAim instances.
//---------------------------------------------------------------------------------------
class X2LWAbilitiesModTemplate extends X2LWTemplateModTemplate config(LW_Overhaul);

struct ToHitAdjustments
{
	var int ConditionalCritAdjust;	// reduction in bonus damage chance from it being conditional on hitting
	var int DodgeCritAdjust;		// reduction in bonus damage chance from enemy dodge
	var int DodgeHitAdjust;			// reduction in hit chance from dodge converting graze to miss
	var int FinalCritChance;
	var int FinalSuccessChance;
	var int FinalGrazeChance;
	var int FinalMissChance;
};

var localized string strCritReductionFromConditionalToHit;

var config bool ALLOW_NEGATIVE_DODGE;
var config bool DODGE_CONVERTS_GRAZE_TO_MISS;
var config bool GUARANTEED_HIT_ABILITIES_IGNORE_GRAZE_BAND;
var config bool DISABLE_LOST_HEADSHOT;
var config int SHADOW_CRIT_MODIFIER;

var config array<bool> HEADSHOT_ENABLED;

var config int TEAMWORK_LVL1_CHARGES;
var config int TEAMWORK_LVL2_CHARGES;
var config int TEAMWORK_LVL3_CHARGES;

var config int SUMMON_COOLDOWN;

var config float MEELE_DAMAGE_REDUCTION;
var config float EXPLOSIVE_DAMAGE_REDUCTION;

static function UpdateAbilities(X2AbilityTemplate Template, int Difficulty)
{
    // Override the FinalizeHitChance calculation for abilities that use standard aim
    if (ClassIsChildOf(Template.AbilityToHitCalc.Class, class'X2AbilityToHitCalc_StandardAim'))
    {
        Template.AbilityToHitCalc.OverrideFinalHitChanceFns.AddItem(OverrideFinalHitChance);
    }

	switch (Template.DataName)
	{
		case 'BondmateTeamwork':
		case 'BondmateTeamwork_Improved':
			UpdateTeamwork(Template);
			break;
		case 'LostHeadshotInit':
			DisableLostHeadshot(Template);
			break;
		case 'ShadowPassive':
			// Disabling the reduced crit chance when in Shadow for now, but
			// leaving the code in case we want to do something similar or
			// reintroduce it.
			// UpdateShadow(Template);
			break;
		case 'Bayonet':
			UpdateBayonet(Template);
			break;
		//I probably could just update it in the Alienpack, but it doesn't recognize the cooldown class there
		case 'BayonetCharge':
			UpdateBayonetCharge(Template);
			break;
		case 'ChosenExtractKnowledgeMove':
		case 'ChosenKidnapMove':
		case 'ChosenKidnap':
		case 'ChosenExtractKnowledge':
			UpdateExtractKnowledgeConditions(Template);
			break;
		case 'Revive':
			UpdateRevive(Template);
			break;
		//Remove some of the redundant daze/bleeding effects
		case 'PartingSilk':
			UpdatePartingSilk(Template);
			break;
			//A 4 turn cooldown instead of 1 time per encounter
		case 'ChosenSummonFollowers': 
			UpdateSummon(Template);
			break;
		case 'ChosenImmuneMelee':
			ReplaceWithDamageReductionMeele(Template);
			break;
		case 'BlastShield':
			ReplaceWithDamageReductionExplosive(Template);
			break;
		case 'PoisonSpit':
			AddImmuneConditionToPoisonSpit(Template);
			break;
		case 'AdvPurifierFlamethrower':
			UpdatePurifierFlamethrower(Template);
			break;
		case 'PriestStasis':
			MakePriestStasisNotEndTurn(Template);
			break;
		case 'HolyWarriorDeath':
			RemoveTheDeathFromHolyWarriorDeath(Template);
			break;
		case 'Sustain':
			UpdateSustainEffect(Template);
			break;
		case 'RevivalProtocol':
			AllowRevivalProtocolToRemoveStunned(Template);
			break;
		case 'RestorativeMist':
			AllowRestorativeMistToRemoveStunned(Template);
			break;
		default:
			break;
	}
}

static function bool OverrideFinalHitChance(X2AbilityToHitCalc AbilityToHitCalc, out ShotBreakdown ShotBreakdown)
{
	local X2AbilityToHitCalc_StandardAim	StandardAim;
	local ToHitAdjustments					Adjustments;
	local ShotModifierInfo					ModInfo;

	StandardAim = X2AbilityToHitCalc_StandardAim(AbilityToHitCalc);
	if (StandardAim == none)
	{
		return false;
	}

	GetUpdatedHitChances(StandardAim, ShotBreakdown, Adjustments);

	// LWOTC Replacing the old FinalHitChance calculation with one that treats all graze
	// as a hit.
	// ShotBreakdown.FinalHitChance = ShotBreakdown.ResultTable[eHit_Success] + Adjustments.DodgeHitAdjust;
	ShotBreakdown.FinalHitChance = Adjustments.FinalSuccessChance + Adjustments.FinalGrazeChance + Adjustments.FinalCritChance;
	ShotBreakdown.ResultTable[eHit_Crit] = Adjustments.FinalCritChance;
	ShotBreakdown.ResultTable[eHit_Success] = Adjustments.FinalSuccessChance;
	ShotBreakdown.ResultTable[eHit_Graze] = Adjustments.FinalGrazeChance;
	ShotBreakdown.ResultTable[eHit_Miss] = Adjustments.FinalMissChance;

	if(Adjustments.DodgeHitAdjust != 0)
	{
		ModInfo.ModType = eHit_Success;
		ModInfo.Value   = Adjustments.DodgeHitAdjust;
		ModInfo.Reason  = class'XLocalizedData'.default.DodgeStat;
		ShotBreakdown.Modifiers.AddItem(ModInfo);
	}
	if(Adjustments.ConditionalCritAdjust != 0)
	{
		ModInfo.ModType = eHit_Crit;
		ModInfo.Value   = Adjustments.ConditionalCritAdjust;
		ModInfo.Reason  = default.strCritReductionFromConditionalToHit;
		ShotBreakdown.Modifiers.AddItem(ModInfo);
	}
	if(Adjustments.DodgeCritAdjust != 0)
	{
		ModInfo.ModType = eHit_Crit;
		ModInfo.Value   = Adjustments.DodgeCritAdjust;
		ModInfo.Reason  = class'XLocalizedData'.default.DodgeStat;
		ShotBreakdown.Modifiers.AddItem(ModInfo);
	}

	return true;
}

// doesn't actually assign anything to the ToHitCalc, just computes relative to-hit adjustments
static function GetUpdatedHitChances(X2AbilityToHitCalc_StandardAim ToHitCalc, out ShotBreakdown ShotBreakdown, out ToHitAdjustments Adjustments)
{
	local ShotModifierInfo ModInfo;
	local int GrazeBand;
	local int CriticalChance, DodgeChance;
	local int MissChance, HitChance, CritChance;
	local int GrazeChance, GrazeChance_Hit, GrazeChance_Miss;
	local int CritPromoteChance_HitToCrit;
	local int CritPromoteChance_GrazeToHit;
	local int DodgeDemoteChance_CritToHit;
	local int DodgeDemoteChance_HitToGraze;
	local int DodgeDemoteChance_GrazeToMiss;
	local int i;
	local EAbilityHitResult HitResult;
	local bool bLogHitChance;

	bLogHitChance = false;

	if(bLogHitChance)
	{
		`LWTRACE("==" $ GetFuncName() $ "==\n");
		`LWTRACE("Starting values...", bLogHitChance);
		for (i = 0; i < eHit_MAX; ++i)
		{
			HitResult = EAbilityHitResult(i);
			`LWTRACE(HitResult $ ":" @ ShotBreakdown.ResultTable[i]);
		}
	}

	// STEP 1 "Band of hit values around nominal to-hit that results in a graze
	GrazeBand = `LWOVERHAULOPTIONS.GetGrazeBand();

	// options to zero out the band for certain abilities -- either GuaranteedHit or an ability-by-ability
	if (default.GUARANTEED_HIT_ABILITIES_IGNORE_GRAZE_BAND && ToHitCalc.bGuaranteedHit)
	{
		GrazeBand = 0;
	}

	HitChance = ShotBreakdown.ResultTable[eHit_Success];
	// LWOTC: If hit chance is within grazeband of either 0 or 100%, then adjust
	// the band so that 100% is a hit and 0% is a miss.
	if (HitChance < GrazeBand)
	{
		GrazeBand = Max(0, HitChance);
	}
	else if (HitChance > (100 - GrazeBand))
	{
		GrazeBand = Max(0, 100 - HitChance);
	}
	// End LWOTC change

	GrazeChance_Hit = Clamp(HitChance, 0, GrazeBand); // captures the "low" side where you just barely hit
	GrazeChance_Miss = Clamp(100 - HitChance, 0, GrazeBand);  // captures the "high" side where  you just barely miss
	GrazeChance = GrazeChance_Hit + GrazeChance_Miss;

	if (GrazeChance_Hit > 0)
	{
		ModInfo.ModType = eHit_Success;
		ModInfo.Value   = GrazeChance_Hit;
		ModInfo.Reason  = class'X2TacticalGameRulesetDataStructures'.default.m_aAbilityHitResultStrings[eHit_Graze];
		Shotbreakdown.Modifiers.AddItem(ModInfo);
	}

	if (bLogHitChance)
	{
		`LWTRACE("Graze Chance from band = " $ GrazeChance, bLogHitChance);
	}

	//STEP 2 Update Hit Chance to remove GrazeChance -- for low to-hits this can be zero
	HitChance = Clamp(Min(100, HitChance)-GrazeChance_Hit, 0, 100-GrazeChance);
	if(bLogHitChance)
		`LWTRACE("HitChance after graze graze band removal = " $ HitChance, bLogHitChance);

	//STEP 3 "Crits promote from graze to hit, hit to crit
	CriticalChance = ShotBreakdown.ResultTable[eHit_Crit];
	if (default.ALLOW_NEGATIVE_DODGE && ShotBreakdown.ResultTable[eHit_Graze] < 0)
	{
		// negative dodge acts like crit, if option is enabled
		CriticalChance -= ShotBreakdown.ResultTable[eHit_Graze];
	}
	CriticalChance = Clamp(CriticalChance, 0, 100);
	CritPromoteChance_HitToCrit = Round(float(HitChance) * float(CriticalChance) / 100.0);

	CritPromoteChance_GrazeToHit = Round(float(GrazeChance) * float(CriticalChance) / 100.0);
	if(bLogHitChance)
	{
		`LWTRACE("CritPromoteChance_HitToCrit = " $ CritPromoteChance_HitToCrit, bLogHitChance);
		`LWTRACE("CritPromoteChance_GrazeToHit = " $ CritPromoteChance_GrazeToHit, bLogHitChance);
	}

	CritChance = CritPromoteChance_HitToCrit; // crit chance is the chance you promoted to crit
	HitChance = HitChance + CritPromoteChance_GrazeToHit - CritPromoteChance_HitToCrit;  // add chance for promote from dodge, remove for promote to crit
	GrazeChance = GrazeChance - CritPromoteChance_GrazeToHit; // remove chance for promote to hit
	if(bLogHitChance)
	{
		`LWTRACE("PostCrit:", bLogHitChance);
		`LWTRACE("CritChance  = " $ CritChance, bLogHitChance);
		`LWTRACE("HitChance   = " $ HitChance, bLogHitChance);
		`LWTRACE("GrazeChance = " $ GrazeChance, bLogHitChance);
	}

	//save off loss of crit due to conditional on to-hit
	Adjustments.ConditionalCritAdjust = -(CriticalChance - CritPromoteChance_HitToCrit);

	//STEP 4 "Dodges demotes from crit to hit, hit to graze, (optional) graze to miss"
	if (ShotBreakdown.ResultTable[eHit_Graze] > 0)
	{
		DodgeChance = Clamp(ShotBreakdown.ResultTable[eHit_Graze], 0, 100);
		DodgeDemoteChance_CritToHit = Round(float(CritChance) * float(DodgeChance) / 100.0);
		DodgeDemoteChance_HitToGraze = Round(float(HitChance) * float(DodgeChance) / 100.0);
		if(default.DODGE_CONVERTS_GRAZE_TO_MISS)
		{
			DodgeDemoteChance_GrazeToMiss = Round(float(GrazeChance) * float(DodgeChance) / 100.0);
		}
		CritChance = CritChance - DodgeDemoteChance_CritToHit;
		HitChance = HitChance + DodgeDemoteChance_CritToHit - DodgeDemoteChance_HitToGraze;
		GrazeChance = GrazeChance + DodgeDemoteChance_HitToGraze - DodgeDemoteChance_GrazeToMiss;

		if(bLogHitChance)
		{
			`LWTRACE("DodgeDemoteChance_CritToHit   = " $ DodgeDemoteChance_CritToHit);
			`LWTRACE("DodgeDemoteChance_HitToGraze  = " $ DodgeDemoteChance_HitToGraze);
			`LWTRACE("DodgeDemoteChance_GrazeToMiss = " $DodgeDemoteChance_GrazeToMiss);
			`LWTRACE("PostDodge:");
			`LWTRACE("CritChance  = " $ CritChance);
			`LWTRACE("HitChance   = " $ HitChance);
			`LWTRACE("GrazeChance = " $ GrazeChance);
		}

		//save off loss of crit due to dodge demotion
		Adjustments.DodgeCritAdjust = -DodgeDemoteChance_CritToHit;

		//save off loss of to-hit due to dodge demotion of graze to miss
		Adjustments.DodgeHitAdjust = -DodgeDemoteChance_GrazeToMiss;
	}

	//STEP 5 Store
	Adjustments.FinalCritChance = CritChance;
	Adjustments.FinalSuccessChance = HitChance;
	Adjustments.FinalGrazeChance = GrazeChance;

	//STEP 6 Miss chance is what is left over
	MissChance = 100 - (CritChance + HitChance + GrazeChance);
	Adjustments.FinalMissChance = MissChance;
	if(MissChance < 0)
	{
		//This is an error so flag it
		`REDSCREEN("OverrideToHit : Negative miss chance!");
	}
}

static function DisableLostHeadshot(X2AbilityTemplate Template)
{
	local X2Effect_TheLostHeadshot				HeadshotEffect;
	local X2Condition_HeadshotEnabled           HeadshotCondition;
	local int									i;

	`LWTrace("Disabling Headshot mechanic");

	for (i = Template.AbilityTargetEffects.Length-1; i >= 0; i--)
	{
		HeadshotEffect = X2Effect_TheLostHeadshot(Template.AbilityTargetEffects[i]);
		if (HeadshotEffect != none)
		{
			HeadshotCondition = new class'X2Condition_HeadshotEnabled';
			HeadshotCondition.EnabledForDifficulty = default.HEADSHOT_ENABLED;
			HeadshotEffect.TargetConditions.AddItem(HeadshotCondition);
			break;
		}
	}
}

static function UpdateTeamwork(X2AbilityTemplate Template)
{
	local X2Effect Effect;
	local X2Condition Condition;
	local X2Effect_GrantActionPoints ActionPointEffect;
	local X2Condition_Bondmate BondmateCondition;
	local X2Condition_Visibility TargetVisibilityCondition;
	local X2AbilityCharges_Teamwork AbilityCharges;

	// Change the charges for each level of Teamwork
	AbilityCharges = new class'X2AbilityCharges_Teamwork';
	AbilityCharges.Charges.AddItem(default.TEAMWORK_LVL1_CHARGES);
	AbilityCharges.Charges.AddItem(default.TEAMWORK_LVL2_CHARGES);
	AbilityCharges.Charges.AddItem(default.TEAMWORK_LVL3_CHARGES);

	if (Template.DataName == 'BondmateTeamwork')
	{
		// Change the lvl 1 Teamwork to granting a move action rather than a standard one
		foreach Template.AbilityTargetEffects(Effect)
		{
			ActionPointEffect = X2Effect_GrantActionPoints(Effect);
			if (ActionPointEffect != none)
			{
				ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.MoveActionPoint;
				break;
			}
		}

		// Only apply lvl 1 Teamwork to lvl 1 bonds (not lvl 2)
		foreach Template.AbilityShooterConditions(Condition)
		{
			BondmateCondition = X2Condition_Bondmate(Condition);
			if (BondmateCondition != none)
			{
				BondmateCondition.MaxBondLevel = 1;
				break;
			}
		}

		Template.AbilityCharges = AbilityCharges;
	}
	else if (Template.DataName == 'BondmateTeamwork_Improved')
	{
		// Only apply lvl 1 Teamwork to lvl 1 bonds (not lvl 2)
		foreach Template.AbilityShooterConditions(Condition)
		{
			BondmateCondition = X2Condition_Bondmate(Condition);
			if (BondmateCondition != none)
			{
				BondmateCondition.MaxBondLevel = 1;
			}
		}

		// Apply Advanced Teamwork to lvl 2 and 3 bonds
		foreach Template.AbilityShooterConditions(Condition)
		{
			BondmateCondition = X2Condition_Bondmate(Condition);
			if (BondmateCondition != none)
			{
				BondmateCondition.MinBondLevel = 2;
				BondmateCondition.MaxBondLevel = 3;
			}
		}

		Template.AbilityCharges = AbilityCharges;
	}

	// Limit Teamwork to line of sight
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bRequireBasicVisibility=true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
}

// Make Shadow apply a debuff to crit chance when the Reaper is in concealment.
static function UpdateShadow(X2AbilityTemplate Template)
{
	local X2Effect_ToHitModifier ToHitModifier;
	local X2Condition_UnitProperty ConcealedCondition;
	local X2Condition_Visibility VisCondition;

	VisCondition = new class'X2Condition_Visibility';
	VisCondition.bExcludeGameplayVisible = true;

	ConcealedCondition = new class'X2Condition_UnitProperty';
	ConcealedCondition.IsConcealed = true;

	ToHitModifier = new class'X2Effect_ToHitModifier';
	ToHitModifier.BuildPersistentEffect(1, true, false, false);
	ToHitModifier.AddEffectHitModifier(eHit_Crit, default.SHADOW_CRIT_MODIFIER, Template.LocFriendlyName,, false /* Melee */);
	ToHitModifier.ToHitConditions.AddItem(VisCondition);
	ToHitModifier.ToHitConditions.AddItem(ConcealedCondition);

	Template.AddTargetEffect(ToHitModifier);
}

static function UpdateBayonet(X2AbilityTemplate Template)
{
	local X2AbilityCooldown_Shared	Cooldown;

	Cooldown = new class'X2AbilityCooldown_Shared';
	Cooldown.iNumTurns = class'X2Ability_LWAlienAbilities'.default.BAYONET_COOLDOWN;
	Cooldown.SharingCooldownsWith.AddItem('BayonetCharge'); //Now shares the cooldown with Bayonet charge
	Template.AbilityCooldown = Cooldown;

}

static function UpdateBayonetCharge(X2AbilityTemplate Template)
{
	local X2AbilityCooldown_Shared	Cooldown;

	Cooldown = new class'X2AbilityCooldown_Shared';
	Cooldown.iNumTurns = class'X2Ability_LWAlienAbilities'.default.BAYONET_COOLDOWN;
	Cooldown.SharingCooldownsWith.AddItem('Bayonet'); //Now shares the cooldown with Bayonet
	Template.AbilityCooldown = Cooldown;
}

static function UpdateExtractKnowledgeConditions(X2AbilityTemplate Template)
{
	local X2Condition_TargetHasOneOfTheEffects NeedOneOfTheEffects;
	local int i;

	for(i=0;i<Template.AbilityTargetConditions.length;i++)
	{
		if(Template.AbilityTargetConditions[i].isA(class'X2Condition_UnitEffects'.name))
			if(X2Condition_UnitEffects(Template.AbilityTargetConditions[i]).RequireEffects[0].EffectName==class'X2AbilityTemplateManager'.default.DazedName)
			X2Condition_UnitEffects(Template.AbilityTargetConditions[i]).RemoveRequireEffect(class'X2AbilityTemplateManager'.default.DazedName);
	}
	NeedOneOfTheEffects=new class'X2Condition_TargetHasOneOfTheEffects';
	NeedOneOfTheEffects.EffectNames.AddItem(class'X2AbilityTemplateManager'.default.DazedName);
	NeedOneOfTheEffects.EffectNames.AddItem(class'X2StatusEffects_LW'.default.HeavyDazedName);
	Template.AbilityTargetConditions.AddItem(NeedOneOfTheEffects);

}


static function UpdatePartingSilk(X2AbilityTemplate Template)
{
	local X2Effect_DodgeModifier Effect;
	Effect= new class'X2Effect_DodgeModifier';
	Effect.ANTIDODGE_BONUS=100;
	RemoveAbilityTargetEffect(Template,'X2Effect_Dazed');
	Template.AddTargetEffect(Effect);
}



static function RemoveAbilityTargetEffect(X2AbilityTemplate Template, name EffectName)
{
	local X2Effect TargetEffect;
	foreach Template.AbilityTargetEffects(TargetEffect)
	{
		if (TargetEffect.IsA(EffectName))
		{
			Template.AbilityTargetEffects.RemoveItem(TargetEffect);
		}
	}
}
static function RemoveAbilityShooterEffect(X2AbilityTemplate Template, name EffectName)
{
	local X2Effect ShooterEffect;
	foreach Template.AbilityShooterEffects(ShooterEffect)
	{
		if (ShooterEffect.IsA(EffectName))
		{
			Template.AbilityShooterEffects.RemoveItem(ShooterEffect);
		}
	}
}
static function UpdateSummon(X2AbilityTemplate Template)
{
	local X2AbilityCooldown					Cooldown;

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;

	//Screw it, I have no idea how to do it cleanly and no other mod touches it anyway
	Template.AbilityShooterConditions.Remove(2,1);
	RemoveAbilityShooterEffect(Template,'X2Effect_SetUnitValue');

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.SUMMON_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	Template.BuildNewGameStateFn = class'X2Ability_LW_ChosenAbilities'.static.ChosenSummonFollowers_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_LW_ChosenAbilities'.static.ChosenSummonFollowers_BuildVisualization;
}

static function ReplaceWithDamageReductionExplosive(X2AbilityTemplate Template)
{
	local X2Effect_Formidable	PaddingEffect;
	RemoveAbilityTargetEffect(Template,'X2Effect_BlastShield');
	PaddingEffect=new class'X2Effect_Formidable';
	PaddingEffect.ExplosiveDamageReduction=default.EXPLOSIVE_DAMAGE_REDUCTION;
	PaddingEffect.Armor_Mitigation = 0;
	Template.AddTargetEffect(PaddingEffect);
}

static function ReplaceWithDamageReductionMeele(X2AbilityTemplate Template)
{
	local X2Effect_DefendingMeeleDamageModifier DamageMod;
	RemoveAbilityTargetEffect(Template,'X2Effect_DamageImmunity');
	DamageMod=new class'X2Effect_DefendingMeeleDamageModifier';
	DamageMod.DamageMod=default.MEELE_DAMAGE_REDUCTION;
	DamageMod.BuildPersistentEffect(1, true, false, true);
	DamageMod.SetDisplayInfo (ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);

	Template.AddTargetEffect(DamageMod);
}
static function UpdateRevive(X2AbilityTemplate Template)
{
	local X2Condition_UnitEffects ExcludeEffects;
	ExcludeEffects = new class'X2Condition_UnitEffects';
	ExcludeEffects.AddExcludeEffect(class'X2AbilityTemplateManager'.default.DisorientedName, 'AA_UnitIsDisoriented');
	ExcludeEffects.AddExcludeEffect(class'X2StatusEffects'.default.BurningName, 'AA_UnitIsBurning');
	Template.AbilityShooterConditions.AddItem(ExcludeEffects);
}
static function AddImmuneConditionToPoisonSpit(X2AbilityTemplate Template)
{
	local X2Condition_UnitImmunities UnitImmunityCondition;
	
	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Poison');
	Template.AbilityMultiTargetConditions.AddItem(UnitImmunityCondition);
}

static function AddImmuneConditionToFlamethrower(X2AbilityTemplate Template)
{
	local X2Condition_UnitImmunities UnitImmunityCondition;
	
	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Fire');
	Template.AbilityMultiTargetConditions.AddItem(UnitImmunityCondition);
}

static function UpdatePurifierFlamethrower(X2AbilityTemplate Template)
{
	local X2AbilityMultiTarget_Cone_LWFlamethrower	ConeMultiTarget;
	local X2AbilityToHitCalc_StandardAim			StandardAim;
	local array<name>                       		SkipExclusions;
	local X2Condition 								Condition;

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bAllowCrit = false;
	StandardAim.bGuaranteedHit = true;
	Template.AbilityToHitCalc = StandardAim;

	foreach Template.AbilityShooterConditions(Condition)
	{
		if(Condition.isA(class'X2Condition_UnitEffects'.name))
		{
			X2Condition_UnitEffects(Condition).RemoveExcludeEffect(class'X2AbilityTemplateManager'.default.DisorientedName);
		}
	}

	Template.TargetingMethod = class'X2TargetingMethod_Cone_Flamethrower_LW';

	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone_LWFlamethrower';
	ConeMultiTarget.bUseWeaponRadius = true;

	ConeMultiTarget.ConeEndDiameter = class'X2Ability_AdvPurifier'.default.ADVPURIFIER_FLAMETHROWER_TILE_WIDTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.ConeLength = class'X2Ability_AdvPurifier'.default.ADVPURIFIER_FLAMETHROWER_TILE_LENGTH * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.AddConeSizeMultiplier('Incinerator', class'X2Ability_LW_TechnicalAbilitySet'.default.INCINERATOR_RANGE_MULTIPLIER, class'X2Ability_LW_TechnicalAbilitySet'.default.INCINERATOR_RADIUS_MULTIPLIER);
	// Next line used for vanilla targeting
	// ConeMultiTarget.AddConeSizeMultiplier('Incinerator', default.INCINERATOR_CONEEND_DIAMETER_MODIFIER, default.INCINERATOR_CONELENGTH_MODIFIER);
	ConeMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	Template.bCheckCollision = true;
	Template.bAffectNeighboringTiles = true;
	Template.bFragileDamageOnly = true;

	// For vanilla targeting
	// Template.ActionFireClass = class'X2Action_Fire_Flamethrower';
	Template.PostActivationEvents.AddItem('FlamethrowerActivated');
	Template.ActionFireClass = class'X2Action_Fire_Flamethrower_LW';

	Template.BuildVisualizationFn = class'X2Ability_LW_TechnicalAbilitySet'.static.LWFlamethrower_BuildVisualization;

}

static function MakePriestStasisNotEndTurn(X2AbilityTemplate Template)
{
	local X2AbilityCost_ActionPoints        ActionPointCost;
	Template.AbilityCosts.Length = 0;
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);
}

static function RemoveTheDeathFromHolyWarriorDeath(X2AbilityTemplate Template)
{
	local X2Effect Effect;

	foreach Template.AbilityMultiTargetEffects(Effect)
	{
		if(Effect.IsA(class'X2Effect_HolyWarriorDeath'.name))
		{
			Template.AbilityMultiTargetEffects.RemoveItem(Effect);
		}
	}
}

static function UpdateSustainEffect(X2AbilityTemplate Template)
{
	local X2Effect_Sustain_LW SustainEffect;

	RemoveAbilityTargetEffect(Template,'X2Effect_Sustain');

	SustainEffect = new class'X2Effect_Sustain_LW';
	SustainEffect.BuildPersistentEffect(1, true, true);
	SustainEffect.EffectName='Sustain';
	SustainEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddTargetEffect(SustainEffect);
}

static function AllowRevivalProtocolToRemoveStunned(X2AbilityTemplate Template)
{
	local X2Effect_RestoreActionPoints RestoreAPEffect;
	local X2Effect_RemoveEffects RemoveEffects;
	local X2Effect_StunRecover StunRecoverEffect;
	local int i;

	// Replace the standard Revival Protocol targeting condition with one that also
	// targets stunned units.
	for (i = 0; i < Template.AbilityTargetConditions.Length; i++)
	{
		if (X2Condition_RevivalProtocol(Template.AbilityTargetConditions[i]) != none)
		{
			Template.AbilityTargetConditions[i] = new class'X2Condition_RevivalProtocol_LW';
		}
	}

	for (i = 0; i < Template.AbilityTargetEffects.Length; i++)
	{
		// Make sure X2Effect_RestoreActionPoints only applies if the target unit is
		// *not* stunned (since X2Effect_StunRecover also restores action points). It
		// should also not apply if the unit is only disoriented.
		RestoreAPEffect = X2Effect_RestoreActionPoints(Template.AbilityTargetEffects[i]);
		if (RestoreAPEffect != none)
		{
			RestoreApEffect.TargetConditions.AddItem(new class'X2Condition_RevivalProtocolRestoreActionPoints_LW');
		}

		// Also make sure that the stunned effect is cleared.
		RemoveEffects = X2Effect_RemoveEffects(Template.AbilityTargetEffects[i]);
		if (RemoveEffects != none)
		{
			RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.StunnedName);
		}
	}

	// Add X2Effect_StunRecover so that units recover properly from stunned, but
	// only apply this effect if the unit actually *is* stunned. This effect is
	// mutually exclusive with X2Effect_RestoreActionPoints.
	StunRecoverEffect = class'X2StatusEffects'.static.CreateStunRecoverEffect();
	StunRecoverEffect.TargetConditions.AddItem(new class'X2Condition_IsStunned_LW');
	Template.AddTargetEffect(StunRecoverEffect);
}

static function AllowRestorativeMistToRemoveStunned(X2AbilityTemplate Template)
{
	local X2Effect_RestoreActionPoints RestoreAPEffect;
	local X2Effect_RemoveEffects RemoveEffects;
	local X2Effect_StunRecover StunRecoverEffect;
	local int i, j;

	for (i = 0; i < Template.AbilityMultiTargetEffects.Length; i++)
	{
		// Make sure X2Effect_RestoreActionPoints doesn't apply if the unit is only disoriented.
		RestoreAPEffect = X2Effect_RestoreActionPoints(Template.AbilityMultiTargetEffects[i]);
		if (RestoreAPEffect != none)
		{
			for (j = 0; j < RestoreAPEffect.TargetConditions.Length; j++)
			{
				// Replace the RevivalProtocol condition, which returns true if the target
				// is disoriented, with out custom condition that excludes disoriented units,
				// since we don't want those to get action points back.
				if (X2Condition_RevivalProtocol(RestoreAPEffect.TargetConditions[j]) != none)
				{
					RestoreAPEffect.TargetConditions[j] = new class'X2Condition_RevivalProtocolRestoreActionPoints_LW';
				}
			}
		}

		// Also make sure that the stunned effect is cleared.
		RemoveEffects = X2Effect_RemoveEffects(Template.AbilityMultiTargetEffects[i]);
		if (RemoveEffects != none)
		{
			RemoveEffects.EffectNamesToRemove.AddItem(class'X2AbilityTemplateManager'.default.StunnedName);
		}
	}

	// Add X2Effect_StunRecover so that units recover properly from stunned, but
	// only apply this effect if the unit actually *is* stunned. This effect is
	// mutually exclusive with X2Effect_RestoreActionPoints.
	//
	// Note that we still need to include the standard Revival Protocol condition
	// to handle units that can't be revived.
	StunRecoverEffect = class'X2StatusEffects'.static.CreateStunRecoverEffect();
	StunRecoverEffect.TargetConditions.AddItem(new class'X2Condition_RevivalProtocol_LW');
	StunRecoverEffect.TargetConditions.AddItem(new class'X2Condition_IsStunned_LW');
	Template.AddMultiTargetEffect(StunRecoverEffect);
}

defaultproperties
{
	AbilityTemplateModFn=UpdateAbilities
}

