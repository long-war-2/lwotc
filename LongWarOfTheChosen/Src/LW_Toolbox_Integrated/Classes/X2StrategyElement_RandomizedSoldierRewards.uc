//---------------------------------------------------------------------------------------
//  FILE:    X2StrategyElement_RandomizedSoldierRewards.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Methods for handling creation and rankups of randomized reward soldiers
//---------------------------------------------------------------------------------------
class X2StrategyElement_RandomizedSoldierRewards extends X2StrategyElement
	dependson(X2RewardTemplate);

//

static function GenerateCouncilSoldierReward(XComGameState_Reward RewardState, XComGameState NewGameState, optional float RewardScalar = 1.0, optional StateObjectReference RegionRef)
{
	local StateObjectReference CapturedSoldierRef;

	// first check if the aliens have captured one of our soldiers. If so, then they get to be the reward
	CapturedSoldierRef = PickCapturedSoldier(class'Helpers_LW'.static.FindAvailableCapturedSoldiers(NewGameState));
	if (CapturedSoldierRef.ObjectID != 0)
	{
		`LWTrace("[RescueSoldier] Rescue reward for captured soldier with ID " $ CapturedSoldierRef.ObjectID);
		RewardState.RewardObjectReference = CapturedSoldierRef;
	}
	else
	{
		// somehow the soldier to be rescued has been pulled out from under us! Generate one as a fallback.
		`LWTrace("[RescueSoldier] Failed to find a captured soldier to rescue!");
		
		// Tedster - Deprecating this one for the one from LWTemplateMods
		//GeneratePersonnelReward(RewardState, NewGameState, RewardScalar, RegionRef);
		GenerateRandomSoldierReward(RewardState, NewGameState, RewardScalar, RegionRef);
		
	}
}

// Copied from LWTemplateMods for now since I need a Static version
static function GenerateRandomSoldierReward(XComGameState_Reward RewardState, XComGameState NewGameState, optional float RewardScalar = 1.0, optional StateObjectReference RegionRef)
{
	local XComGameState_HeadquartersResistance ResistanceHQ;
	local XComGameStateHistory History;
	local XComGameState_Unit NewUnitState;
	local XComGameState_WorldRegion RegionState;
	local int idx, NewRank, i;
	local name nmCountry, SelectedClass, NeededClass;
	local array<name> arrActiveTemplates, NeededClasses;
	local X2SoldierClassTemplateManager ClassMgr;
	local array<X2SoldierClassTemplate> arrClassTemplates;
	local X2SoldierClassTemplate ClassTemplate;
	local XComGameState_HeadquartersAlien AlienHQ;

	History = `XCOMHISTORY;
	nmCountry = '';
	RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(RegionRef.ObjectID));

	//`LWTrace("LW GenerateRandomSoldierReward firing");

	if(RegionState != none)
	{
		nmCountry = RegionState.GetMyTemplate().GetRandomCountryInRegion();
	}

	//Use the character pool's creation method to retrieve a unit
	NewUnitState = `CHARACTERPOOLMGR.CreateCharacter(NewGameState, `XPROFILESETTINGS.Data.m_eCharPoolUsage, RewardState.GetMyTemplate().rewardObjectTemplateName, nmCountry);
	NewUnitState.RandomizeStats();
	NewGameState.AddStateObject(NewUnitState);

	ResistanceHQ = XComGameState_HeadquartersResistance(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));
	if(!NewGameState.GetContext().IsStartState())
	{
		ResistanceHQ = XComGameState_HeadquartersResistance(NewGameState.CreateStateObject(class'XComGameState_HeadquartersResistance', ResistanceHQ.ObjectID));
		NewGameState.AddStateObject(ResistanceHQ);
	}
	
	// Pick a random class
	ClassMgr = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();
	arrClassTemplates = ClassMgr.GetAllSoldierClassTemplates(true);
	foreach arrClassTemplates(ClassTemplate)
	{
		if (ClassTemplate.NuminDeck > 0)
		{
			for(i = 0; i < ClassTemplate.NumInDeck; ++i)
			{
				arrActiveTemplates.AddItem(ClassTemplate.DataName);
			}
		}
	}
	// weight towards needed ones by adding to deck.
	NeededClasses = `XCOMHQ.GetNeededSoldierClasses();

	foreach NeededClasses (NeededClass)
	{
		ClassTemplate = ClassMgr.FindSoldierClassTemplate(NeededClass);

		if (ClassTemplate.NuminDeck > 0)
		{
			for(i = 0; i < ClassTemplate.NumInDeck; ++i)
			{
				arrActiveTemplates.AddItem(ClassTemplate.DataName);
			}
		}
	}

	if (arrActiveTemplates.length > 0)
	{
		SelectedClass = arrActiveTemplates[`SYNC_RAND_STATIC(arrActiveTemplates.length)];
	}
	else
	{
		SelectedClass = ResistanceHQ.SelectNextSoldierClass();
	}
	
	NewUnitState.ApplyInventoryLoadout(NewGameState);

	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	NewRank = 1;

	for(idx = 0; idx < class'X2StrategyElement_DefaultRewards'.default.SoldierRewardForceLevelGates.Length; idx++)
	{
		if(AlienHQ.GetForceLevel() >= class'X2StrategyElement_DefaultRewards'.default.SoldierRewardForceLevelGates[idx])
		{
			NewRank++;
		}
	}

	NewUnitState.SetXPForRank(NewRank);
	NewUnitState.StartingRank = NewRank;
	for(idx = 0; idx < NewRank; idx++)
	{
		// Rank up to squaddie
		if(idx == 0)
		{
			NewUnitState.RankUpSoldier(NewGameState, SelectedClass);
			NewUnitState.ApplySquaddieLoadout(NewGameState);
			NewUnitState.bNeedsNewClassPopup = false;
		}
		else
		{
			NewUnitState.RankUpSoldier(NewGameState, NewUnitState.GetSoldierClassTemplate().DataName);
		}
	}   

	`XEVENTMGR.TriggerEvent('RewardUnitGenerated', NewUnitState, NewUnitState);

	//`LWTrace("RewardUnitGenerated fired");

	RewardState.RewardObjectReference = NewUnitState.GetReference();
}

// Attempts to pick a soldier at random from the given array. The result
// is an empty reference, i.e. ObjectID == 0, if the given array is empty.
static function StateObjectReference PickCapturedSoldier(array<StateObjectReference> CapturedSoldiers)
{
	local StateObjectReference EmptyStateRef;
	local int CapturedSoldierIndex;

	if (CapturedSoldiers.Length == 0)
	{
		`LWTrace("[RescueSoldier] Trying to pick a soldier from an empty array");
		return EmptyStateRef;
	 }

	// Pick a soldier to rescue
	CapturedSoldierIndex = class'Engine'.static.GetEngine().SyncRand(CapturedSoldiers.Length, "GenerateSoldierReward");
	return CapturedSoldiers[CapturedSoldierIndex];
}

static function GeneratePersonnelReward(XComGameState_Reward RewardState, XComGameState NewGameState, optional float RewardScalar = 1.0, optional StateObjectReference RegionRef)
{
	local XComGameState_HeadquartersResistance ResistanceHQ;
	local XComGameStateHistory History;
	local XComGameState_Unit NewUnitState;
	local XComGameState_WorldRegion RegionState;
	local int i, idx, NewRank;
	local name nmCountry;

	History = `XCOMHISTORY;

	// Grab the region and pick a random country
	nmCountry = '';
	RegionState = XComGameState_WorldRegion(History.GetGameStateForObjectID(RegionRef.ObjectID));

	if(RegionState != none)
	{
		nmCountry = RegionState.GetMyTemplate().GetRandomCountryInRegion();
	}

	//Use the character pool's creation method to retrieve a unit
	NewUnitState = `CHARACTERPOOLMGR.CreateCharacter(NewGameState, `XPROFILESETTINGS.Data.m_eCharPoolUsage, RewardState.GetMyTemplate().rewardObjectTemplateName, nmCountry);
	`XEVENTMGR.TriggerEvent( 'SoldierCreatedEvent', NewUnitState, NewUnitState, NewGameState );
	NewUnitState.RandomizeStats();
	NewUnitState.GiveRandomPersonality();
	NewGameState.AddStateObject(NewUnitState);

	if(RewardState.GetMyTemplate().rewardObjectTemplateName == 'Soldier')
	{
		ResistanceHQ = XComGameState_HeadquartersResistance(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersResistance'));

		if(!NewGameState.GetContext().IsStartState())
		{
			ResistanceHQ = XComGameState_HeadquartersResistance(NewGameState.CreateStateObject(class'XComGameState_HeadquartersResistance', ResistanceHQ.ObjectID));
			NewGameState.AddStateObject(ResistanceHQ);
		}
		
		NewUnitState.ApplyInventoryLoadout(NewGameState);
		NewRank = GetPersonnelRewardRank(true, (RewardState.GetMyTemplateName() == 'Reward_Rookie'));
		NewUnitState.SetXPForRank(NewRank);
		NewUnitState.StartingRank = NewRank;
		for(idx = 0; idx < NewRank; idx++)
		{
			// Rank up to squaddie
			if(idx == 0)
			{
				NewUnitState.RankUpSoldier(NewGameState, ResistanceHQ.SelectNextSoldierClass());
				NewUnitState.ApplySquaddieLoadout(NewGameState);
				for(i = 0; i < NewUnitState.GetSoldierClassTemplate().GetAbilitySlots(0).Length; ++i)
				{
					NewUnitState.BuySoldierProgressionAbility(NewGameState, 0, i);
				}
			}
			else
			{
				NewUnitState.RankUpSoldier(NewGameState, NewUnitState.GetSoldierClassTemplate().DataName);
			}
			`XEVENTMGR.TriggerEvent( 'RankUpEvent', NewUnitState, NewUnitState, NewGameState );
		}
	}
	else
	{
		NewUnitState.SetSkillLevel(GetPersonnelRewardRank(false));
	}

	`XEVENTMGR.TriggerEvent('RewardUnitGenerated', NewUnitState, NewUnitState);

	RewardState.RewardObjectReference = NewUnitState.GetReference();
}

static function CleanUpUnitRewardIfDead(XComGameState NewGameState, XComGameState_Reward RewardState)
{
	local XComGameState_Unit UnitState;
	local XComGameState_AdventChosen ChosenState;

	UnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
	if (UnitState == none)
	{
		UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(RewardState.RewardObjectReference.ObjectID));
	}

	if (UnitState != none)
	{
		// If the unit died while trying to rescue them, we should yeet them so they don't come back again.
		if (UnitState.GetCurrentStat(eStat_HP) == 0)
		{
			// First remove the units items
			UnitState.BlastLoadout(NewGameState);
		
			// Then remove the actual unit
			NewGameState.RemoveStateObject(UnitState.ObjectID);

			// Remove from any captured lists.
			class'XComGameState_LWToolboxOptions'.static.ReleaseSoldierFromAlienHQ(NewGameState, UnitState.GetReference());

			ChosenState = XComGameState_AdventChosen(NewGameState.GetGameStateForObjectID(UnitState.ChosenCaptorRef.ObjectID));
			if (ChosenState == none)
			{
				ChosenState = XComGameState_AdventChosen(NewGameState.ModifyStateObject(class'XComGameState_AdventChosen', UnitState.ChosenCaptorRef.ObjectID));
			}

			// Release the soldier from the Chosen's captured unit list
			// Also updates the Chosen's Hunt XCOM score, so should only be called when the reward is actually given (ie: mission completed)
			ChosenState.ReleaseSoldier(NewGameState, UnitState.GetReference());

		}
	}
}

static function int GetPersonnelRewardRank(bool bIsSoldier, optional bool bIsRookie = false)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersAlien AlienHQ;
	local int NewRank, idx;

	History = `XCOMHISTORY;
	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
	NewRank = 1;

	if(bIsSoldier)
	{
		if (bIsRookie)
		{
			return 0;
		}

		for(idx = 0; idx < class'X2StrategyElement_DefaultRewards'.default.SoldierRewardForceLevelGates.Length; idx++)
		{
			if(AlienHQ.GetForceLevel() >= class'X2StrategyElement_DefaultRewards'.default.SoldierRewardForceLevelGates[idx])
			{
				NewRank++;
			}
		}
	}
	else
	{
		for(idx = 0; idx < class'X2StrategyElement_DefaultRewards'.default.CrewRewardForceLevelGates.Length; idx++)
		{
			if(AlienHQ.GetForceLevel() >= class'X2StrategyElement_DefaultRewards'.default.CrewRewardForceLevelGates[idx])
			{
				NewRank++;
			}
		}
	}

	return NewRank;
}