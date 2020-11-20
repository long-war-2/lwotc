//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_Unit_LWRandomizedStats.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: This is a component for the unit game state that stores and computes randomized stat information
//			All randomization use a triangle distribution (same as sum of two dice)
//---------------------------------------------------------------------------------------
class XComGameState_Unit_LWRandomizedStats extends XComGameState_BaseObject 
	dependson(X2TacticalGameRulesetDataStructures)
	config(LW_Toolbox);

//

struct StatSwap
{
	var ECharStatType StatUp;
	var float StatUp_Amount;
	var ECharStatType StatDown;
	var float StatDown_Amount;
	var float Weight;
	var bool DoesNotApplyToFirstMissionSoldiers;
};

struct StatCaps
{
	var ECharStatType Stat;
	var float Min;
	var float Max;
};

struct ComIntStatSwap
{
	var int ComIntStatchange;
	var ECharStatType StatSwapped;
	var float StatSwapped_Amount;
	var float Weight;
	var bool DoesNotApplyToFirstMissionSoldiers;
};
var bool bIsFirstMissionSoldier;

//initial randomized stats
var bool bInitialStatsRolled;
var bool bInitialStatsAppliedHasBeenSet; // compatibility bool to avoid breaking savegames
var bool bInitialStatsApplied;
var float CharacterInitialStats_Deltas[ECharStatType.EnumCount];
var float CharacterComIntDelta;
var config array<int> NUM_STAT_SWAPS;  // defines dice that are rolled to determine number of stat swaps applied
var config array<StatSwap> STAT_SWAPS;
var config array<Statcaps> STAT_CAPS;
var config array<ComIntStatSwap> COMINT_STAT_SWAPS;

var config int COMINT_BASE_SWAP_CHANCE;
//level-up randomized stats
var bool bRandomLevelUpActive;
var float CharacterStats_LastLevel[ECharStatType.EnumCount]; // DEPRECATED -- kept for backwards savegame compatibility
var config array<ECharStatType> RANDOMIZED_LEVELUP_STATS;

//DEPRECATED -- keeping for backwards compatibility
var XComGameState_Unit CachedUnit;

// ======= RANDOMIZED INITIAL STATS ======= // 

//fill out the class variable array with initial stat deltas
function RandomizeInitialStats(XComGameState_Unit Unit)
{
	local int idx, NumSwaps, iterations;
	local float TotalWeight, ComIntTotalWeight;
	local StatSwap Swap;
	local ComIntStatSwap ComIntSwap;
	local XComGameState_BattleData BattleData;
	local bool bIsFirstMission;

	BattleData = XComGameState_BattleData( `XCOMHISTORY.GetSingleGameStateObjectForClass( class'XComGameState_BattleData', true ));
	if(BattleData != none)
		bIsFirstMission = BattleData.m_bIsFirstMission;

	if(bIsFirstMission)
		bIsFirstMissionSoldier = Unit.IsInPlay();

	//clear the existing array
	for(idx=0; idx < ArrayCount(CharacterInitialStats_Deltas) ; idx++)
	{
		CharacterInitialStats_Deltas[idx] = 0;
	}
	CharacterComIntDelta = 0;


	//set up
	NumSwaps = RollNumStatSwaps();

	TotalWeight = 0.0f;
	foreach default.STAT_SWAPS(Swap)
	{
		TotalWeight += Swap.Weight;
	}

	ComIntTotalWeight = 0.0f;
	foreach default.COMINT_STAT_SWAPS(ComIntSwap)
	{
		ComIntTotalWeight += ComIntSwap.Weight;
	}

	//randomly apply a bunch of stat swaps to get starting stat offset
	for(idx = 0; idx < NumSwaps; idx++)
	{
		do {
			Swap = SelectRandomStatSwap(TotalWeight);
		} until (IsValidSwap(Swap, Unit) || (++iterations > 1000));

		CharacterInitialStats_Deltas[Swap.StatUp] += Swap.StatUp_Amount;
		CharacterInitialStats_Deltas[Swap.StatDown] -= Swap.StatDown_Amount;
	}
	//Roll a chance for a stat swap and don't roll combat intelligence for rebels
	if (`SYNC_RAND(100) < default.COMINT_BASE_SWAP_CHANCE && InStr(Unit.GetMyTemplateName(), "Rebel") != 0 )
	{
		do 
		{
			ComIntSwap = SelectComIntStatSwap(ComIntTotalWeight);
		} until (IsValidComIntSwap(ComIntSwap, Unit) || (++iterations > 1000));
		CharacterInitialStats_Deltas[ComIntSwap.StatSwapped] += ComIntSwap.StatSwapped_Amount;
		CharacterComIntDelta = ComIntSwap.ComIntStatchange;	
	}

	bInitialStatsRolled = true;
}

//tests to see whether the given stat swap will exceed any of the configured limits
function bool IsValidSwap(StatSwap Swap, XComGameState_Unit Unit)
{
	local StatCaps Cap;

	if(Swap.DoesNotApplyToFirstMissionSoldiers && bIsFirstMissionSoldier)
		return false;

    // Make sure the swap wouldn't bring HP down to zero or lower
    if (Swap.StatDown == eStat_HP &&
        (Unit.GetBaseStat(eStat_HP) - Swap.StatDown_Amount - CharacterInitialStats_Deltas[eStat_HP]) <= 0)
    {
        return false;
    }

	foreach default.STAT_CAPS(Cap)
	{
		if((Cap.Stat == Swap.StatUp)  && (CharacterInitialStats_Deltas[Swap.StatUp] + Swap.StatUp_Amount > Cap.Max))
			return false;
		if((Cap.Stat == Swap.StatDown) && (CharacterInitialStats_Deltas[Swap.StatDown] - Swap.StatDown_Amount < Cap.Min))
			return false;
	}
	return true;
}

//apply the randomized initial stat offsets, generating them if they don't already exist
function ApplyRandomInitialStats(XComGameState_Unit Unit, optional bool Apply = true)
{

	if(!bInitialStatsRolled)
	{
		RandomizeInitialStats(Unit);
		bInitialStatsApplied = false;
		bInitialStatsAppliedHasBeenSet = true;
	}

	// backwards compatibility for saves that didn't have bool bInitialStatsApplied
	if(!bInitialStatsAppliedHasBeenSet) 
	{
		bInitialStatsApplied = ! Apply;
		bInitialStatsAppliedHasBeenSet = true;
	}

	// helps handle cases where only some soldiers have gotten out of sync with the setting -- only update stats when needed
	if(Apply && bInitialStatsApplied)
		return;

	if(!Apply && !bInitialStatsApplied)
		return;

    ApplyDeltas(Unit, Apply);
	bInitialStatsApplied = Apply;
	bInitialStatsAppliedHasBeenSet = true;
}

function ApplyDeltas(XComGameState_Unit Unit, bool Apply)
{
    local int idx;
	local float OldValue, OldCurrentValue, NewValue;
	local UnitValue HPValue;

	`LOG("Applying Random Stats to Unit " $ Unit.GetFullName());
	for(idx=0; idx < ArrayCount(CharacterInitialStats_Deltas) ; idx++)
	{
		if (ECharStatType(idx) == eStat_Will && Unit.bIsShaken)
			OldValue = Unit.SavedWillValue;
		else
			OldValue = Unit.GetBaseStat(ECharStatType(idx));

		OldCurrentValue = Unit.GetCurrentStat(ECharStatType(idx));
		NewValue = OldValue;
		if(CharacterInitialStats_Deltas[idx] != 0)
		{
			if(Apply)
			{
				NewValue += CharacterInitialStats_Deltas[idx];
			}
			else
			{
				NewValue -= CharacterInitialStats_Deltas[idx];
			}

			if (ECharStatType(idx) == eStat_Will && Unit.bIsShaken) 
			{
				Unit.SavedWillValue = NewValue;
			}
			else
			{
				if(ECharStatType(idx) == eStat_HP)
				{
					if(`TACTICALRULES != none && `TACTICALRULES.TacticalGameIsInPlay()) // need to adjust lowest/highest HP if in tactical
					{
						Unit.GetUnitValue('LW_MaxHP', HPValue);
						if(Apply)
						{
							Unit.LowestHP += CharacterInitialStats_Deltas[idx];
							Unit.HighestHP += CharacterInitialStats_Deltas[idx];
							HPValue.fValue += CharacterInitialStats_Deltas[idx];
						}
						else
						{
							Unit.LowestHP -= CharacterInitialStats_Deltas[idx];
							Unit.HighestHP -= CharacterInitialStats_Deltas[idx];
							HPValue.fValue -= CharacterInitialStats_Deltas[idx];
						}
						Unit.SetBaseMaxStat(ECharStatType(idx), NewValue);
						Unit.SetUnitFloatValue('LW_MaxHP', HPValue.fValue, eCleanup_BeginTactical);
					}
					else // not in tactical 
					{
						Unit.SetBaseMaxStat(ECharStatType(idx), NewValue, ECSMAR_None);  // don't adjust current
						if (OldValue == OldCurrentValue)
						{
							Unit.SetCurrentStat(ECharStatType(idx), NewValue); // only adjust current HP if at max
						}
					}
				}
				else // non HP
				{
					Unit.SetBaseMaxStat(ECharStatType(idx), NewValue);
				}
			}
		}
		//`LOG("RandomStats (" $ string(ECharStatType(idx)) $ ") : Old=" $ OldValue $ ", New=" $ NewValue,, 'LW_Toolbox');
	}
	if (Apply)
	{
		ChangeUnitsCombatIntelligence(Unit, CharacterComIntDelta);
	}
	else
	{
		ChangeUnitsCombatIntelligence(Unit, -CharacterComIntDelta);
	}
}

function int RollNumStatSwaps()
{
	local int Total, StatRoll;

	foreach default.NUM_STAT_SWAPS(StatRoll)
	{
		Total += 1 + `SYNC_RAND(StatRoll);
	}
	`LOG("Randomized Stats: NumStatSwaps rolled=" $ Total,, 'LW_Toolbox');
	return Total;
}

function StatSwap SelectRandomStatSwap(float TotalWeight)
{
	local float finder, selection;
	local StatSwap Swap, ReturnSwap;

	if(default.STAT_SWAPS.Length == 0)
		return Swap;

	finder = 0.0f;
	selection = `SYNC_FRAND * TotalWeight;
	foreach default.STAT_SWAPS(Swap)
	{
		finder += Swap.Weight;
		if(finder > selection)
		{
			break;
		}
	}
	//Swap = default.STAT_SWAPS[default.STAT_SWAPS.Length-1];
	if(`SYNC_RAND(2) == 1)
	{
		ReturnSwap.StatUp = Swap.StatDown;
		ReturnSwap.StatUp_Amount = Swap.StatDown_Amount;
		ReturnSwap.StatDown = Swap.StatUp;
		ReturnSwap.StatDown_Amount = Swap.StatUp_Amount;
		ReturnSwap.DoesNotApplyToFirstMissionSoldiers = Swap.DoesNotApplyToFirstMissionSoldiers;
		return ReturnSwap;
	}
	return Swap;
}

/*
How this should work: Since ComInt Is not an ENUM stat, It can't be properly part of the NCE stat swap table, but since it's just one stat, 
Just putting 0-1 comint swaps on top of existing ones should be enough to properly diversify it.
*/
function ComIntStatSwap SelectComIntStatSwap(float TotalWeight)
{
	local float finder, selection;
	local ComIntStatSwap Swap, ReturnSwap;

	if (default.COMINT_STAT_SWAPS.Length == 0)
		return Swap;

	finder = 0.0f;
	selection = `SYNC_FRAND * TotalWeight;
	foreach default.COMINT_STAT_SWAPS(Swap)
	{
		finder += Swap.Weight;
		if (finder > selection)
		{
			break;
		}
	}
	//Swap = default.STAT_SWAPS[default.STAT_SWAPS.Length-1];
	if (`SYNC_RAND(2) == 1)
	{
		ReturnSwap.ComIntStatchange = Swap.ComIntStatchange * -1.0f;
		ReturnSwap.StatSwapped = Swap.StatSwapped;
		ReturnSwap.StatSwapped_Amount = Swap.StatSwapped_Amount * -1.0f;
		ReturnSwap.Weight = Swap.Weight;

		return ReturnSwap;
	}
	return Swap;
}


function bool IsValidComIntSwap(ComIntStatSwap Swap, XComGameState_Unit Unit)
{
	local StatCaps Cap;

	if (Swap.DoesNotApplyToFirstMissionSoldiers && bIsFirstMissionSoldier)
		return false;

    // Make sure the swap wouldn't bring HP down to zero or lower
    if (Swap.StatSwapped == eStat_HP &&
        (Unit.GetBaseStat(eStat_HP) + Swap.StatSwapped_Amount - CharacterInitialStats_Deltas[eStat_HP]) <= 0)
    {
        return false;
    }

	foreach default.STAT_CAPS(Cap)
	{
		if ((Cap.Stat == Swap.StatSwapped)  && (CharacterInitialStats_Deltas[Swap.StatSwapped] + Swap.StatSwapped_Amount > Cap.Max)
		 || (Cap.Stat == Swap.StatSwapped)  && CharacterInitialStats_Deltas[Swap.StatSwapped] + Swap.StatSwapped_Amount < Cap.Min)
			return false;
	}

	if (ECombatIntelligence(Unit.ComInt + Swap.ComIntStatchange) > eComInt_Savant || ECombatIntelligence(Unit.ComInt + Swap.ComIntStatchange) < eComInt_Standard)
	{
		return false;
	}
	return true;
}


static function ChangeUnitsCombatIntelligence(XcomGameState_Unit Unit, int Amount)
{
	local int iRank, APChange;
		
	if (ECombatIntelligence(Unit.ComInt + Amount) <= eComInt_Savant && ECombatIntelligence(Unit.ComInt + Amount) >= eComInt_Standard)
	{
		Unit.ComInt = ECombatIntelligence(Unit.ComInt + Amount);
	}
	// We should Provide additional AP as if the soldier had the higher ComInt the entire time just in case someone 
	// switches between NCE on and off. Even then, it can't be 100% perfect because if you spend abilities with 
	// above average comint and turn NCE off afterwards Soldier AP would have to become negative, and That sounds like a really bad idea
	//Currently the AP adjusts itself accordingly, but comint does not
	APChange = 0;
	for (iRank = Unit.GetSoldierRank(); iRank >= 2; iRank--)
	{
		if (Unit.IsResistanceHero())
		{			
			APChange += (Unit.GetResistanceHeroAPAmount(iRank, Unit.ComInt) - Unit.GetResistanceHeroAPAmount(iRank, ECombatIntelligence(Unit.ComInt - Amount)));
		}
		else
		{
			APChange += (Unit.GetBaseSoldierAPAmount(Unit.ComInt) - Unit.GetBaseSoldierAPAmount(ECombatIntelligence(Unit.ComInt - Amount)));
		}
	}
	Unit.AbilityPoints = Max(0, Unit.AbilityPoints + Round(APChange));
	
}

//DEPRECATED - kept for backwards compatibility to prevent issues with registered listeners
function EventListenerReturn OnUnitLeveledUp(Object EventData, Object EventSource, XComGameState GameState, Name EventID)
{
	return ELR_NoInterrupt;
}
