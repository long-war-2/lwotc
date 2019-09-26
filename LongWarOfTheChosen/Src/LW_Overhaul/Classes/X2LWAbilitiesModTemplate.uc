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

static function UpdateAbilities(X2AbilityTemplate Template, int Difficulty)
{
    // Override the FinalizeHitChance calculation for abilities that use standard aim
    if (ClassIsChildOf(Template.AbilityToHitCalc.Class, class'X2AbilityToHitCalc_StandardAim'))
    {
        Template.AbilityToHitCalc.OverrideFinalHitChanceFns.AddItem(OverrideFinalHitChance);
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
		`LWTrACE("==" $ GetFuncName() $ "==\n");
		`LWTrACE("Starting values...", bLogHitChance);
		for (i = 0; i < eHit_MAX; ++i)
		{
			HitResult = EAbilityHitResult(i);
			`LWTrACE(HitResult $ ":" @ ShotBreakdown.ResultTable[i]);
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
		`LWTrACE("Graze Chance from band = " $ GrazeChance, bLogHitChance);
	}

	//STEP 2 Update Hit Chance to remove GrazeChance -- for low to-hits this can be zero
	HitChance = Clamp(Min(100, HitChance)-GrazeChance_Hit, 0, 100-GrazeChance);
	if(bLogHitChance)
		`LWTrACE("HitChance after graze graze band removal = " $ HitChance, bLogHitChance);

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
		`LWTrACE("CritPromoteChance_HitToCrit = " $ CritPromoteChance_HitToCrit, bLogHitChance);
		`LWTrACE("CritPromoteChance_GrazeToHit = " $ CritPromoteChance_GrazeToHit, bLogHitChance);
	}

	CritChance = CritPromoteChance_HitToCrit; // crit chance is the chance you promoted to crit
	HitChance = HitChance + CritPromoteChance_GrazeToHit - CritPromoteChance_HitToCrit;  // add chance for promote from dodge, remove for promote to crit
	GrazeChance = GrazeChance - CritPromoteChance_GrazeToHit; // remove chance for promote to hit
	if(bLogHitChance)
	{
		`LWTrACE("PostCrit:", bLogHitChance);
		`LWTrACE("CritChance  = " $ CritChance, bLogHitChance);
		`LWTrACE("HitChance   = " $ HitChance, bLogHitChance);
		`LWTrACE("GrazeChance = " $ GrazeChance, bLogHitChance);
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
			`LWTrACE("DodgeDemoteChance_CritToHit   = " $ DodgeDemoteChance_CritToHit);
			`LWTrACE("DodgeDemoteChance_HitToGraze  = " $ DodgeDemoteChance_HitToGraze);
			`LWTrACE("DodgeDemoteChance_GrazeToMiss = " $DodgeDemoteChance_GrazeToMiss);
			`LWTrACE("PostDodge:");
			`LWTrACE("CritChance  = " $ CritChance);
			`LWTrACE("HitChance   = " $ HitChance);
			`LWTrACE("GrazeChance = " $ GrazeChance);
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

defaultproperties
{
	AbilityTemplateModFn=UpdateAbilities
}
