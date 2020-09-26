//---------------------------------------------------------------------------------------
//  FILE:    X2LWDarkEventsModTemplate.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Modifies existing dark event templates, disabling some of them, for
//           example, or rewiring them to use sit reps.
//---------------------------------------------------------------------------------------
class X2LWDarkEventsModTemplate extends X2LWTemplateModTemplate config(LW_Overhaul);

static function UpdateDarkEvents(X2StrategyElementTemplate Template, int Difficulty)
{
	local X2DarkEventTemplate DETemplate;

	DETemplate = X2DarkEventTemplate(Template);
	if (DETemplate == none)
		return;

	// This is added so no Dark Events show in the objective list, since it would get overwhelmed
	DETemplate.bNeverShowObjective = true;

	switch (DETemplate.DataName)
	{
		case 'DarkEvent_Barrier':
		case 'DarkEvent_HighAlert':
		case 'DarkEvent_Infiltrator':
		case 'DarkEvent_InfiltratorChryssalid':
		case 'DarkEvent_LostWorld':
		case 'DarkEvent_ReturnFire':
		case 'DarkEvent_SealedArmor':
		case 'DarkEvent_UndyingLoyalty':
		case 'DarkEvent_Vigilance':
			// Disable the normal dark event activation as these are handled by
			// sit reps now.
			DETemplate.OnActivatedFn = none;
			DETemplate.OnDeactivatedFn = none;
			DETemplate.ModifyTacticalStartStateFn = none;

			// 50% longer duration as you won't get them on every mission now and
			// some mission types won't even allow the corresponding sit rep.
			DETemplate.MinDurationDays = 42;
			DETemplate.MaxDurationDays = 42;
			break;

		case 'DarkEvent_NewConstruction':
		case 'DarkEvent_RuralCheckpoints':
		case 'DarkEvent_BendingReed':
		case 'DarkEvent_CollateralDamage':
		case 'DarkEvent_StilettoRounds':
		case 'DarkEvent_SignalJamming':
		case 'DarkEvent_GoneToGround':
		case 'DarkEvent_LightningReflexes': // WOTC version replaced with LW2 one for the moment
		case 'DarkEvent_Counterattack': // This conflicts with green and yellow alert reflex actions (and doesn't work as advertised)
		case 'DarkEvent_SpiderAndFly': // TODO: Consider restoring this once covert action Ambush missions are back
		case 'DarkEvent_WildHunt': // We don't use the vanilla spawning logic for Chosen
		case 'DarkEvent_DarkTower': // Doesn't work for our Will loss mechanic yet. TODO: maybe change that
			// Remove these from play
			DETemplate.StartingWeight = 0;
			DETemplate.MinWeight = 0;
			DETemplate.MaxWeight = 0;
			break;

		case 'DarkEvent_AlloyPadding':
			DETemplate.bInfiniteDuration = true;
			DETemplate.bRepeatable = false;
			DETemplate.CanActivateFn = class 'X2StrategyElement_DarkEvents_LW'.static.CanActivateCodexUpgrade;
			break;

		case 'DarkEvent_ViperRounds':
			DETemplate.bInfiniteDuration = true;
			DETemplate.bRepeatable = false;
			break;

		case 'DarkEvent_AlienCypher': 
			DETemplate.OnActivatedFn = class'X2StrategyElement_DarkEvents_LW'.static.ActivateAlienCypher_LW; 
			DETemplate.OnDeactivatedFn = class'X2StrategyElement_DarkEvents_LW'.static.DeactivateAlienCypher_LW;
			break;

		case 'DarkEvent_ResistanceInformant':
			DETemplate.MinDurationDays = 21;
			DETemplate.MaxDurationDays = 28;
			DETemplate.GetSummaryFn = GetResistanceInformantSummary;
			break;

		case 'DarkEvent_MinorBreakthrough':
			DETemplate.MinActivationDays = 15;
			DETemplate.MaxActivationDays = 20;
			DETemplate.MutuallyExclusiveEvents.AddItem('DarkEvent_MinorBreakthrough2');
			DETemplate.MutuallyExclusiveEvents.AddItem('DarkEvent_MajorBreakthrough2');
			DETemplate.CanActivateFn = class'X2StrategyElement_DarkEvents_LW'.static.CanActivateMinorBreakthroughAlt; // Will check for whether avatar project has been revealed
			DETemplate.OnActivatedFn = class'X2StrategyElement_DarkEvents_LW'.static.ActivateMinorBreakthroughMod;
			`LWTRACE("Redefined Minor Breakthrough Dark Event Template");
			break;

		case 'DarkEvent_MajorBreakthrough':
			DETemplate.MutuallyExclusiveEvents.AddItem('DarkEvent_MinorBreakthrough2');
			DETemplate.MutuallyExclusiveEvents.AddItem('DarkEvent_MajorBreakthrough2');
			DETemplate.CanActivateFn = class'X2StrategyElement_DarkEvents_LW'.static.CanActivateMajorBreakthroughAlt;
			DETemplate.OnActivatedFn = class'X2StrategyElement_DarkEvents_LW'.static.ActivateMajorBreakthroughMod;
			`LWTRACE("Redefined Major Breakthrough Dark Event Template");
			break;

		case 'DarkEvent_HunterClass':
			DETemplate.CanActivateFn = class'X2StrategyElement_DarkEvents_LW'.static.CanActivateHunterClass_LW;
			break;

		case 'DarkEvent_RapidResponse':
			DETemplate.CanActivateFn = class'X2StrategyElement_DarkEvents_LW'.static.CanActivateAdvCaptainM2Upgrade;
			DETemplate.bRepeatable = true;

			// Disable the normal dark event activation as this is handled by
			// a sit rep now.
			DETemplate.OnActivatedFn = none;
			DETemplate.OnDeactivatedFn = none;
			DETemplate.ModifyTacticalStartStateFn = none;
			break;

		case 'DarkEvent_TheCollectors':
		case 'DarkEvent_MadeWhole':
			// Remove these from play when the Chosen are all dead
			DETemplate.CanActivateFn = AlwaysFalse;
			break;

		default:
			break;
	}
}

//---------------------------------------------------------------------------------------
static function bool ChosenAliveCheck(XComGameState_DarkEvent DarkEventState)
{
	local XComGameStateHistory History;
	local XComGameState_AdventChosen ChosenState;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_AdventChosen', ChosenState)
	{
		if (ChosenState.bMetXCom && !ChosenState.bDefeated)
		{
			// At least one Chosen is alive
			return true;
		}
	}

	return false;
}

//---------------------------------------------------------------------------------------
static function string GetResistanceInformantSummary(string strSummaryText)
{
	local XGParamTag ParamTag;
	local float Divider, TempFloat;
	local int TempInt;

	ParamTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));

	Divider = class'X2LWActivityDetectionCalc_Terror'.default.RESISTANCE_INFORMANT_DETECTION_DIVIDER[`STRATEGYDIFFICULTYSETTING];
	Divider = 1.0f;
	TempInt = Round(Divider);
	if (float(TempInt) ~= Divider)
	{
		ParamTag.StrValue0 = string(TempInt);
	}
	else
	{
		TempFloat = Round(Divider * 10.0) / 10.0;
		ParamTag.StrValue0 = Repl(string(TempFloat), "0", "");
	}

	return `XEXPAND.ExpandString(strSummaryText);
}

defaultproperties
{
	StrategyElementTemplateModFn=UpdateDarkEvents
}
