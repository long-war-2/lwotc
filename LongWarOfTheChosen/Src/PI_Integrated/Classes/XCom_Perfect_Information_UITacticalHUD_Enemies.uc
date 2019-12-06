//-----------------------------------------------------------
//	Class:	XCom_Perfect_Information_UITacticalHUD_Enemies
//	Author: tjnome
//	
//-----------------------------------------------------------

class XCom_Perfect_Information_UITacticalHUD_Enemies extends UITacticalHUD_Enemies config(PerfectInformation);

var config bool SHOW_AIM_ASSIST_OVER_ENEMY_ICON;
var config bool SHOW_MISS_CHANCE_OVER_ENEMY_ICON;

simulated function int GetHitChanceForObjectRef(StateObjectReference TargetRef)
{
	local AvailableAction Action;
	local ShotBreakdown Breakdown;
	local X2TargetingMethod TargetingMethod;
	local XComGameState_Ability AbilityState;
	local int AimBonus, HitChance;

	//If a targeting action is active and we're hoving over the enemy that matches this action, then use action percentage for the hover  
	TargetingMethod = XComPresentationLayer(screen.Owner).GetTacticalHUD().GetTargetingMethod();

	if( TargetingMethod != none && TargetingMethod.GetTargetedObjectID() == TargetRef.ObjectID )
	{	
		AbilityState = TargetingMethod.Ability;
	}
	else
	{			
		AbilityState = XComPresentationLayer(Movie.Pres).GetTacticalHUD().m_kAbilityHUD.GetCurrentSelectedAbility();

		if( AbilityState == None )
		{
			XComPresentationLayer(Movie.Pres).GetTacticalHUD().m_kAbilityHUD.GetDefaultTargetingAbility(TargetRef.ObjectID, Action, true);
			AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(Action.AbilityObjectRef.ObjectID));
		}
	}

	if( AbilityState != none )
	{
		AbilityState.LookupShotBreakdown(AbilityState.OwnerStateObject, TargetRef, AbilityState.GetReference(), Breakdown);
		
		if(!Breakdown.HideShotBreakdown)
		{
			AimBonus = 0;
			HitChance = Clamp(((Breakdown.bIsMultishot) ? Breakdown.MultiShotHitChance : Breakdown.ResultTable[eHit_Success] + Breakdown.ResultTable[eHit_Crit] + Breakdown.ResultTable[eHit_Graze]), 0, 100);

			if (SHOW_AIM_ASSIST_OVER_ENEMY_ICON) {
				AimBonus = XCom_Perfect_Information_UITacticalHUD_ShotWings(UITacticalHUD(Screen).m_kShotInfoWings).GetModifiedHitChance(AbilityState, HitChance);
			}

			if (SHOW_MISS_CHANCE_OVER_ENEMY_ICON)
				HitChance = 100 - (AimBonus + HitChance);
			else
				HitChance = AimBonus + HitChance;
				
			return min(HitChance, 100);
	    }
	}

	return -1;
}

simulated function UpdateVisibleEnemies(int HistoryIndex)
{
	local XGUnit kActiveUnit;
	local XComGameState_BaseObject TargetedObject;
	local XComGameState_Unit EnemyUnit, ActiveUnit;
	local X2VisualizerInterface Visualizer;
	local XComGameStateHistory History;
	local array<StateObjectReference> arrSSEnemies, arrCurrentlyAffectable;
	local StateObjectReference ActiveUnitRef;
	local int i, iVisibleEnemyCount, iPrevVisibleEnemyCount;
	local XComGameState_Ability CurrentAbilityState;
	local X2AbilityTemplate AbilityTemplate;

	kActiveUnit = XComTacticalController(PC).GetActiveUnit();
	if (kActiveUnit != none)
	{
		// DATA: -----------------------------------------------------------
		History = `XCOMHISTORY;
		ActiveUnit = XComGameState_Unit(History.GetGameStateForObjectID(kActiveUnit.ObjectID,, HistoryIndex));
		ActiveUnitRef.ObjectID = kActiveUnit.ObjectID;

		CurrentAbilityState = XComPresentationLayer(Movie.Pres).GetTacticalHUD().m_kAbilityHUD.GetCurrentSelectedAbility();
		AbilityTemplate = CurrentAbilityState != none ? CurrentAbilityState.GetMyTemplate() : none;

		iPrevVisibleEnemyCount = m_arrTargets.Length;
		
		if(AbilityTemplate != none && AbilityTemplate.AbilityTargetStyle.SuppressShotHudTargetIcons())
		{
			m_arrTargets.Length = 0;
		}
		else
		{
			ActiveUnit.GetUISummary_TargetableUnits(m_arrTargets, arrSSEnemies, arrCurrentlyAffectable, CurrentAbilityState, HistoryIndex);
		}

		// if the currently selected ability requires the list of ability targets be restricted to only the ones that can be affected by the available action, 
		// use that list of targets instead
		if( AbilityTemplate != none )
		{
			if( AbilityTemplate.bLimitTargetIcons )
			{
				m_arrTargets = arrCurrentlyAffectable;
			}
			else
			{
				//  make sure that all possible targets are in the targets list - as they may not be visible enemies
				for (i = 0; i < arrCurrentlyAffectable.Length; ++i)
				{
					if (m_arrTargets.Find('ObjectID', arrCurrentlyAffectable[i].ObjectID) == INDEX_NONE)
						m_arrTargets.AddItem(arrCurrentlyAffectable[i]);
				}
			}
		}

		iVisibleEnemyCount = m_arrTargets.Length;

		m_arrTargets.Sort(SortEnemies);

		// VISUALS: -----------------------------------------------------------
		// Now that the array is tidy, we can set the visuals from it.

		SetVisibleEnemies( iVisibleEnemyCount ); //Do this before setting data 

		for(i = 0; i < m_arrTargets.Length; i++)
		{
			TargetedObject = History.GetGameStateForObjectID(m_arrTargets[i].ObjectID, , HistoryIndex);
			if ( XComGameState_LootDrop(TargetedObject) != none ) {
				Visualizer = X2VisualizerInterface(ActiveUnit.GetVisualizer());
			}
			else {
				Visualizer = X2VisualizerInterface(TargetedObject.GetVisualizer());
			}

			EnemyUnit = XComGameState_Unit(TargetedObject);
			
			SetIcon( i, Visualizer.GetMyHUDIcon() );

			if( arrCurrentlyAffectable.Find('ObjectID', TargetedObject.ObjectID) > -1 )
			{
				SetBGColor(i, Visualizer.GetMyHUDIconColor());
				SetDisabled(i, false);
			}
			else
			{
				SetBGColor(i, eUIState_Disabled);
				SetDisabled(i, true);
			}
				
			if(arrSSEnemies.Find('ObjectID', TargetedObject.ObjectID) > -1)
				SetSquadSight(i, true);
			else
				SetSquadSight(i, false);

			if( EnemyUnit != none && EnemyUnit.IsFlanked(ActiveUnitRef, false, HistoryIndex) )
				SetFlanked(i, true);
			else
				SetFlanked(i, false);  // Flanking was leaking inappropriately! 
			
		}

		RefreshShine();

		if (iVisibleEnemyCount > iPrevVisibleEnemyCount)
			PlaySound( SoundCue'SoundFX.AlienInRangeCue' ); 
	}

	Movie.Pres.m_kTooltipMgr.ForceUpdateByPartialPath( string(MCPath) );

	// force set selected index, since updating the visible enemies resets the state of the selected target
	if(CurrentTargetIndex != -1)
		SetTargettedEnemy(CurrentTargetIndex, true);
}