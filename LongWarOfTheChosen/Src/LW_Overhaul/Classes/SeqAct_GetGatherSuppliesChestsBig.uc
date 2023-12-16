// Author - Tedster
// Version of SeqAct_GetGatherSuppliesChests to use a different config array for the chests

class SeqAct_GetGatherSuppliesChestsBig extends SequenceAction
	config(GameData);



// Defines a "rare chest". Rare chests are rolled on before pulling
// the rest of the chests from the shuffle bag in the ChestDistribution
struct RareChestEntry
{
	var name Type;
	var float Chance;
};

// Defines a complete "Chest Distribution".
struct ChestDistribution
{
	var int MinForceLevel;
	var int MaxForceLevel;

	var array<string> ChestTypeShuffleBag;
	var array<RareChestEntry> RareChests;
};

// Associates a type of chest with it's loot table and archetype
struct ChestDefinition
{
	var name Type;
	var string ArchetypePath;
	var name LootTable;
};



// Number of chests the user wants to generate
var protected int ChestCount;

// ini defined data
var const config array<ChestDistribution> BigChestDistributions;
var const config array<ChestDefinition> BigChestDefinitions;

event Activated()
{
	local XComGameStateHistory History; 
	local XComGameState_BattleData BattleData;
	local SeqVar_StringList List;
	local int ForceLevel;

	//`LWTrace("Big Supply Extract SeqAct activated.");

	History = `XCOMHISTORY;

	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	ForceLevel = BattleData.GetForceLevel();

	foreach LinkedVariables(class'SeqVar_StringList', List, "Out Chest Types")
	{
		List.arrStrings.Length = 0;
		SelectChests(ForceLevel, ChestCount, List.arrStrings);
	}
}

// Most of the logic lives here so that it can be tested from the cheat console without any kismet needed
static function SelectChests(int ForceLevel, int InChestCount, out array<string> OutChestTypes)
{
	local RareChestEntry RareChestChance;
	local array<string> ShuffledChests;
	local int Index;

	`LWTrace("SelectChests called with Force level" @ForceLevel);
	// find the correct bucket for our supplies
	for (Index = 0; Index < default.BigChestDistributions.Length; Index++)
	{
		if (ForceLevel >= default.BigChestDistributions[Index].MinForceLevel && ForceLevel <= default.BigChestDistributions[Index].MaxForceLevel)
		{
			break;
		}
	}

	//`LWTrace("Passed FL check");
	// validate that we found a distribution
	if (Index > default.BigChestDistributions.Length)
	{
		// no distribution matches this force level!
		`Redscreen("No valid Chest Distribution found for Force Level " $ ForceLevel);
		
		if(default.BigChestDistributions.Length == 0)
		{
			return; // no distributions at all, so we need to bail
		}

		Index = 0; // use the first definition as a fallback
	}

	// validate that our distribution has chests in it
	if (default.BigChestDistributions[Index].ChestTypeShuffleBag.Length == 0)
	{
		`Redscreen("ChestDistributionsBig[" $ Index $ "] contains no chests!");
		return;
	}

	// first roll on "rare crates". These come up very infrequently, and are meant to be
	// exciting for the player when they do. We select them first, and then fill out the rest of the
	// list from the normal crate shuffle bag
	foreach default.BigChestDistributions[Index].RareChests(RareChestChance)
	{
		if(OutChestTypes.Length < InChestCount && class'Engine'.static.SyncFRand("SeqAct_GetGatherSuppliesChests") < RareChestChance.Chance)
		{
			OutChestTypes.AddItem(string(RareChestChance.Type));
		}
	}

	// select crates from the shuffle bag until we have enough of them
	ShuffledChests = default.BigChestDistributions[Index].ChestTypeShuffleBag;
	while (OutChestTypes.Length < InChestCount)
	{
		ShuffledChests.RandomizeOrder();

		for (Index = 0; Index < ShuffledChests.Length && OutChestTypes.Length < InChestCount; Index++)
		{
			OutChestTypes.AddItem(ShuffledChests[Index]);
		}
	}

	// and do one final shuffle so that the rare chests are also randomly located
	OutChestTypes.RandomizeOrder();
}

static function bool GetChestDefinition(name ChestType, out ChestDefinition ChestDef)
{
	local int Index;

	//`LWTrace("Big Supply Extract GetChestDefinition Called");

	for (Index = 0; Index < default.BigChestDefinitions.Length; Index++)
	{
		if(default.BigChestDefinitions[Index].Type == ChestType)
		{
			ChestDef = default.BigChestDefinitions[Index];
			return true;
		}
	}

	return false;
}

static event int GetObjClassVersion()
{
	return super.GetObjClassVersion() + 1;
}

defaultproperties
{
	ObjCategory="Procedural Missions"
	ObjName="Get Gather Supplies Chests Big Version"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true
	bAutoActivateOutputLinks=true

	VariableLinks(0)=(ExpectedType=class'SeqVar_Int',LinkDesc="Count",PropertyName=ChestCount)
	VariableLinks(1)=(ExpectedType=class'SeqVar_StringList',LinkDesc="Out Chest Types",bWriteable=true)
}