//-----------------------------------------------------------
//	Class:	XCom_Perfect_Information_UITacticalHUD_ShotWings
//	Author: tjnome, morionicidiot
//	
//-----------------------------------------------------------

class XCom_Perfect_Information_UITacticalHUD_ShotWings extends UITacticalHUD_ShotWings config(PerfectInformation);

var config bool SHOW_ALWAYS_SHOT_BREAKDOWN_HUD;
var config bool SHOW_AIM_ASSIST_BREAKDOWN_HUD;
var config bool SHOW_MISS_CHANCE_BREAKDOWN_HUD;

var localized string LOWER_DIFFICULTY_MSG;
var localized string MISS_STREAK_MSG;
var localized string SOLDIER_LOST_BONUS;

simulated function UITacticalHUD_ShotWings InitShotWings(optional name InitName, optional name InitLibID)
{
	bLeftWingOpen = !SHOW_ALWAYS_SHOT_BREAKDOWN_HUD;
	bRightWingOpen = !SHOW_ALWAYS_SHOT_BREAKDOWN_HUD;
	return super.InitShotWings(InitName, InitLibID);
}

simulated function RefreshData()
{
	local StateObjectReference	kEnemyRef;
	local StateObjectReference	Shooter, Target; 
	local AvailableAction       kAction;
	local AvailableTarget		kTarget;
	local XComGameState_Ability AbilityState;
	local ShotBreakdown         Breakdown;
	local UIHackingBreakdown    kHackingBreakdown;
	local int                   TargetIndex, iShotBreakdown, AimBonus, HitChance;
	local ShotModifierInfo      ShotInfo;
	local bool bMultiShots;
	local string TmpStr;
	local X2TargetingMethod     TargetingMethod;
	local array<UISummary_ItemStat> Stats;

	kAction = UITacticalHUD(Screen).m_kAbilityHUD.GetSelectedAction();
	kEnemyRef = XComPresentationLayer(Movie.Pres).GetTacticalHUD().m_kEnemyTargets.GetSelectedEnemyStateObjectRef();
	AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(kAction.AbilityObjectRef.ObjectID));

	// Bail if we have  nothing to show -------------------------------------
	if( AbilityState == none )
	{
		Hide();
		return; 
	}

	//Don't show this normal shot breakdown for the hacking action ------------
	AbilityState.GetUISummary_HackingBreakdown( kHackingBreakdown, kEnemyRef.ObjectID );
	if( kHackingBreakdown.bShow ) 
	{
		Hide();
		return; 
	}

	// Refresh game data  ------------------------------------------------------

	// If no targeted icon, we're actually hovering the shot "to hit" info field, 
	// so use the selected enemy for calculation.
	TargetingMethod = UITacticalHUD(screen).GetTargetingMethod();
	if (TargetingMethod != none)
		TargetIndex = TargetingMethod.GetTargetIndex();
	if( kAction.AvailableTargets.Length > 0 && TargetIndex < kAction.AvailableTargets.Length )
	{
		kTarget = kAction.AvailableTargets[TargetIndex];
	}

	Shooter = AbilityState.OwnerStateObject; 
	Target = kTarget.PrimaryTarget; 

	iShotBreakdown = AbilityState.LookupShotBreakdown(Shooter, Target, AbilityState.GetReference(), Breakdown);

	// Hide if requested -------------------------------------------------------
	if (Breakdown.HideShotBreakdown)
	{
		Hide();

		if(bLeftWingOpen)
		{
			bLeftWingWasOpen = true;
			OnWingButtonClicked(LeftWingButton);
		}

		if(bRightWingOpen)
		{
			bRightWingWasOpen = true;
			OnWingButtonClicked(RightWingButton);
		}

		LeftWingButton.Hide();
		RightWingButton.Hide();
		return; 
	}
	else
	{
		UITacticalHUD(screen).m_kShotHUD.MC.FunctionVoid( "ShowHit" );
		UITacticalHUD(screen).m_kShotHUD.MC.FunctionVoid( "ShowCrit" );

		// Fix the issue with vanilia.
		LeftWingButton.Show();
		RightWingButton.Show();

		// This should fix the issue. Since it now change the values around again.
		if (SHOW_ALWAYS_SHOT_BREAKDOWN_HUD) {
			if(!bLeftWingOpen)
				OnWingButtonClicked(LeftWingButton);

			if(!bRightWingOpen)
				OnWingButtonClicked(RightWingButton);

			bLeftWingWasOpen = false;
			bRightWingWasOpen = false;
		}
		else
		{
			if(bLeftWingWasOpen && !bLeftWingOpen) 
			{
				OnWingButtonClicked(LeftWingButton);
				bLeftWingWasOpen = false;
			}

			if(bRightWingWasOpen && !bRightWingOpen) 
			{
				OnWingButtonClicked(RightWingButton);
				bRightWingWasOpen = false;
			}
		}
	}

	if (Target.ObjectID == 0)
	{
		Hide();
		return; 
	}

	// Gameplay special hackery for multi-shot display. -----------------------
	if(iShotBreakdown != Breakdown.FinalHitChance)
	{
		bMultiShots = true;
		ShotInfo.ModType = eHit_Success;
		ShotInfo.Value = iShotBreakdown - Breakdown.FinalHitChance;
		ShotInfo.Reason = class'XLocalizedData'.default.MultiShotChance;
		Breakdown.Modifiers.AddItem(ShotInfo);
		Breakdown.FinalHitChance = iShotBreakdown;
	}

	// Now update the UI ------------------------------------------------------

	if (bMultiShots)
		HitLabel.SetHtmlText(class'UIUtilities_Text'.static.StyleText(class'XLocalizedData'.default.MultiHitLabel, eUITextStyle_Tooltip_StatLabel));
	else
		HitLabel.SetHtmlText(class'UIUtilities_Text'.static.StyleText(class'XLocalizedData'.default.HitLabel, eUITextStyle_Tooltip_StatLabel));
	
	//Lets sort from high to low
	Breakdown.Modifiers.Sort(SortModifiers);

	// Smart way to do things -Credit: Sectoidfodder 
	Stats = ProcessBreakdown(Breakdown, eHit_Success);
	AimBonus = 0;

	//VBN
	//HitChance = Clamp(((Breakdown.bIsMultishot) ? Breakdown.MultiShotHitChance : Breakdown.FinalHitChance), 0, 100);
	HitChance = ( (Breakdown.bIsMultishot) ? Breakdown.MultiShotHitChance : Breakdown.FinalHitChance);

	//Check for standarshot
	if (X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc) != None && SHOW_AIM_ASSIST_BREAKDOWN_HUD)
	{	
		AimBonus = GetModifiedHitChance(AbilityState, HitChance, Stats);
	}

	Stats.Sort(SortAfterValue);

	if (SHOW_MISS_CHANCE_BREAKDOWN_HUD)
		TmpStr = (100 - (AimBonus + HitChance)) $ "%";
	else
		TmpStr = (AimBonus + HitChance) $ "%";

	HitPercent.SetHtmlText(class'UIUtilities_Text'.static.StyleText(TmpStr, eUITextStyle_Tooltip_StatValue));
	HitStatList.RefreshData(Stats);

	if(Breakdown.ResultTable[eHit_Crit] >= 0)
	{
		CritLabel.SetHtmlText(class'UIUtilities_Text'.static.StyleText(class'XLocalizedData'.default.CritLabel, eUITextStyle_Tooltip_StatLabel));
		TmpStr = string(Breakdown.ResultTable[eHit_Crit]) $ "%";
		CritPercent.SetHtmlText(class'UIUtilities_Text'.static.StyleText(TmpStr, eUITextStyle_Tooltip_StatValue));
		CritStatList.RefreshData(ProcessBreakdown(Breakdown, eHit_Crit));
		RightWingArea.Show();
	}
	else
		RightWingArea.Hide();
}

// Custom sort
function int SortAfterValue(UISummary_ItemStat A, UISummary_ItemStat B)
{
    return (GetNumber(B.Value) > GetNumber(A.Value)) ? -1 : 0;
}

// This should give me only numbers.
static final function int GetNumber(string s)
{
	local string result;
	local int i, c;

	for (i = 0; i < Len(s); i++) {
		c = Asc(Right(s, Len(s) - i));
		if ( c == Clamp(c, 48, 57) ) // 0-9
			result = result $ Chr(c);
	}

	return int(result);
}

// Basicly same function as ModifiedHitChance from X2AbilityToHitCalc_StandardAim
function int GetModifiedHitChance(XComGameState_Ability AbilityState, int BaseHitChance, optional out array<UISummary_ItemStat> Stats)
{
	local int CurrentLivingSoldiers, ModifiedHitChance, SingleModifiedHitChance;
	local UISummary_ItemStat Item;

	local XComGameStateHistory History;
	local XComGameState_Unit UnitState, Unit;
	local StateObjectReference Shooter;
	local XComGameState_Player ShooterPlayer;
	local X2AbilityToHitCalc_StandardAim StandardAim;

	ModifiedHitChance = BaseHitChance;
	History = `XCOMHISTORY;

	Shooter = AbilityState.OwnerStateObject;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Shooter.ObjectID));
	ShooterPlayer = XComGameState_Player(`XCOMHISTORY.GetGameStateForObjectID(UnitState.GetAssociatedPlayerID()));
	StandardAim = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);

	if (BaseHitChance > StandardAim.MaxAimAssistScore) {
		return 0;
	}

	// XCom gets 20% bonus to hit for each consecutive miss made already this turn
	if(ShooterPlayer.TeamFlag == eTeam_XCom && !(`XENGINE.IsMultiplayerGame()))
	{

		foreach History.IterateByClassType(class'XComGameState_Unit', Unit)
		{
			if( Unit.GetTeam() == eTeam_XCom && !Unit.bRemovedFromPlay && Unit.IsAlive() && !Unit.GetMyTemplate().bIsCosmetic )
			{
				++CurrentLivingSoldiers;
			}
		}

		//Difficulty multiplier
		// ModifiedHitChance = BaseHitChance * StandardAim.AimAssistDifficulties[CurrentDifficulty].BaseXComHitChanceModifier; // 1.2
		// ModifiedHitChance = Clamp(ModifiedHitChance, 0, StandardAim.MaxAimAssistScore);
		// SingleModifiedHitChance = ModifiedHitChance - BaseHitChance;

		// DifficultyBonus
		// Fixing name issue later with localization
		// if (SingleModifiedHitChance > 0)
		// {
		// 	// Add to Stats (ProcessBreakDown)
		// 	if (SHOW_AIM_ASSIST_BREAKDOWN_HUD)
		// 	{
		// 		Item.Label = class'UIUtilities_Text'.static.GetColoredText(LOWER_DIFFICULTY_MSG, eUIState_Good );
		// 		Item.Value = class'UIUtilities_Text'.static.GetColoredText("+" $ SingleModifiedHitChance $ "%", eUIState_Good );
		// 		Stats.AddItem(Item);
		// 	}
		// }


		if(BaseHitChance >= StandardAim.ReasonableShotMinimumToEnableAimAssist) // 50
		{
			// SingleModifiedHitChance = ShooterPlayer.MissStreak * StandardAim.AimAssistDifficulties[CurrentDifficulty].MissStreakChanceAdjustment; // 20
			//Miss Bonus!
			// Fixing name issue later with localization
			SingleModifiedHitChance = Clamp(SingleModifiedHitChance, 0, StandardAim.MaxAimAssistScore - ModifiedHitChance);
			if (SingleModifiedHitChance > 0 && ModifiedHitChance <= StandardAim.MaxAimAssistScore)
			{
				// add the chance to total!
				ModifiedHitChance += SingleModifiedHitChance;
				
				// Add to Stats (ProcessBreakDown)
				if (SHOW_AIM_ASSIST_BREAKDOWN_HUD)
				{
					Item.Label = class'UIUtilities_Text'.static.GetColoredText(MISS_STREAK_MSG, eUIState_Good );
					Item.Value = class'UIUtilities_Text'.static.GetColoredText("+" $ SingleModifiedHitChance $ "%", eUIState_Good );
					Stats.AddItem(Item);
				}
			}

			// SingleModifiedHitChance = SoldiersLost * StandardAim.AimAssistDifficulties[CurrentDifficulty].SoldiersLostXComHitChanceAdjustment;

			// Squady lost bonus
			// Fixing name issue later with localization
			SingleModifiedHitChance = Clamp(SingleModifiedHitChance, 0, StandardAim.MaxAimAssistScore - ModifiedHitChance);
			if (SingleModifiedHitChance > 0 && ModifiedHitChance <= StandardAim.MaxAimAssistScore)
			{
				
				// add the chance to total!
				ModifiedHitChance += SingleModifiedHitChance;
				// Add to Stats (ProcessBreakDown)
				if (SHOW_AIM_ASSIST_BREAKDOWN_HUD)
				{
					Item.Label = class'UIUtilities_Text'.static.GetColoredText(SOLDIER_LOST_BONUS, eUIState_Good );
					Item.Value = class'UIUtilities_Text'.static.GetColoredText("+" $ SingleModifiedHitChance $ "%", eUIState_Good );
					Stats.AddItem(Item);
				}
			}

		}
	}

	ModifiedHitChance = Clamp(ModifiedHitChance, 0, StandardAim.MaxAimAssistScore);

	// Important to only get the change.
	return ModifiedHitChance - BaseHitChance;;
}

simulated function array<UISummary_ItemStat> ProcessBreakdown(ShotBreakdown Breakdown, int eHitType)
{
	local array<UISummary_ItemStat> Stats; 
	local UISummary_ItemStat Item; 
	local int i, Value; 
	local string strLabel, strValue, strPrefix; 
	local EUIState eState;

	for( i=0; i < Breakdown.Modifiers.Length; i++)
	{	
		if (SHOW_MISS_CHANCE_BREAKDOWN_HUD)
			Value = (100 - Breakdown.Modifiers[i].Value);
		else
			Value = (Breakdown.Modifiers[i].Value);
		
		if( Value < 0 )
		{
			eState = eUIState_Bad;
			strPrefix = "";
		}
		else
		{
			eState = eUIState_Good; 
			strPrefix = "+";
		}

		strLabel = class'UIUtilities_Text'.static.GetColoredText( Breakdown.Modifiers[i].Reason, eState );
		strValue = class'UIUtilities_Text'.static.GetColoredText( strPrefix $ string(Value) $ "%", eState );

		if (Breakdown.Modifiers[i].ModType == eHitType)
		{
			Item.Label = strLabel; 
			Item.Value = strValue;
			Stats.AddItem(Item);
		}
	}

	if( eHitType == eHit_Crit && Stats.length == 1 && Breakdown.ResultTable[eHit_Crit] == 0 )
		Stats.length = 0; 

	return Stats; 
}

defaultproperties
{
	Height = 160;
	bLeftWingOpen = false;
	bRightWingOpen = false;
	MCName = "shotWingsMC";
}