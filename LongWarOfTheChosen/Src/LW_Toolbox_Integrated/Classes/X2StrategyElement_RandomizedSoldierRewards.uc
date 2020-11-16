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
	local XComGameStateHistory History;
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_Unit NewUnitState;
	local StateObjectReference CapturedSoldierRef;

	History = `XCOMHISTORY;

	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));

	// first check if the aliens have captured one of our soldiers. If so, then they get to be the reward
	CapturedSoldierRef = FindAvailableCapturedSoldier(AlienHQ.CapturedSoldiers);
	if (CapturedSoldierRef.ObjectID != 0)
	{
		// mark the soldier is uncaptured
		NewUnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', CapturedSoldierRef.ObjectID));
		NewUnitState.bCaptured = false;

		// remove the soldier from the captured unit list
		AlienHQ = XComGameState_HeadquartersAlien(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersAlien', AlienHQ.ObjectID));
		AlienHQ.CapturedSoldiers.RemoveItem(CapturedSoldierRef);

		RewardState.RewardObjectReference = NewUnitState.GetReference();
	}
	else
	{
		// somehow the soldier to be rescued has been pulled out from under us! Generate one as a fallback.
		GeneratePersonnelReward(RewardState, NewGameState, RewardScalar, RegionRef);
	}
}

// Attempts to pick a soldier at random from the given array. If the first attempt
// produces a soldier that can already be rescued from an existing mission or covert
// action, then this iterates through all the soldiers and tries each one.
//
// If no such soldier can be found, this returns an empty reference, i.e. the `ObjectID`
// is zero. This is also the result if the given array is empty.
static function StateObjectReference FindAvailableCapturedSoldier(array<StateObjectReference> CapturedSoldiers)
{
	local StateObjectReference EmptyStateRef;
	local int CapturedSoldierIndex;

	if (CapturedSoldiers.Length == 0) return EmptyStateRef;

	// Pick a soldier to rescue
	CapturedSoldierIndex = class'Engine'.static.GetEngine().SyncRand(CapturedSoldiers.Length, "GenerateSoldierReward");

	// Check whether the soldier is already attached as a mission or covert action reward
	if (!class'Helpers_LW'.static.IsRescueMissionAvailableForSoldier(CapturedSoldiers[CapturedSoldierIndex]))
	{
		return CapturedSoldiers[CapturedSoldierIndex];
	}

	// This soldier is already linked to a rescue mission/CA, so try the others
	for (CapturedSoldierIndex = 0; CapturedSoldierIndex < CapturedSoldiers.Length; CapturedSoldierIndex++)
	{
		if (!class'Helpers_LW'.static.IsRescueMissionAvailableForSoldier(CapturedSoldiers[CapturedSoldierIndex]))
			return CapturedSoldiers[CapturedSoldierIndex];
	}

	return EmptyStateRef;
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
	NewUnitState = `CHARACTERPOOLMGR.CreateCharacter(NewGameState, class'XComGameState_HeadquartersXCom'.default.RewardUnitCharacterPoolSelectionMode, RewardState.GetMyTemplate().rewardObjectTemplateName, nmCountry);
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

	RewardState.RewardObjectReference = NewUnitState.GetReference();
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