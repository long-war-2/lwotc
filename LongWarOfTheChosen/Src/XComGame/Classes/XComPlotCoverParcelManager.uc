class XComPlotCoverParcelManager extends Object
	native(Core)
	config(PCPs)
	dependson(XComParcelManager);

var config array<PCPDefinition> arrAllPCPDefs;
var private array<PCPDefinition> arrPCPDefs;

var private string strPlotType;
var private string strBiomeType;

var bool bBlockingLoadParcels;

var private XComGameState_BattleData BattleData;

/// <summary>
/// Returns true if the given PCP definition matches the given missions objective tag requirements.
/// </summary>
private native function bool DoesPCPDefMeetObjectiveRequirements(const out PCPDefinition PCPDef, const out MissionDefinition MissionType);

/// <summary>
/// Returns true if the given PCP can accept the specified PCPDef.
/// </summary>
private native function bool MatchesPCPDef(const XComPlotCoverParcel PCP, const out PCPDefinition PCPDef);

/// <summary>
/// Selects the non-objective/non-periphery PCPs
/// </summary>
native function ChoosePCPs();

function CacheValidPCPDefs()
{
	local int idx;

	arrPCPDefs.Remove(0, arrPCPDefs.Length);

	// Narrow down PCPs to ones with the correct plot type
	for (idx = 0; idx < arrAllPCPDefs.Length; idx++)
	{
		if(arrAllPCPDefs[idx].arrPlotTypes.Length > 0 && arrAllPCPDefs[idx].arrPlotTypes.Find(strPlotType) == INDEX_NONE)
		{
			// this pcp is locked to a plot type and we don't support any of them
			continue;
		}

		if(BattleData.MapData.Biome != ""
			&& arrAllPCPDefs[idx].arrBiomeTypes.Length > 0 
			&& arrAllPCPDefs[idx].arrBiomeTypes.Find(BattleData.MapData.Biome) == INDEX_NONE)
		{
			// this pcp is locked to a biome and we are not the right kind of biome
			continue;
		}

		// skip advent checkpoints if the current alert level does not support having them
		if( arrAllPCPDefs[idx].bAdventCheckpoint && 
		   (BattleData.MapData.ActiveMission.DisallowCheckpointPCPs || !BattleData.AlertLevelSupportsPCPCheckpoints()) )
		{
			continue;
		}

		arrPCPDefs.AddItem(arrAllPCPDefs[idx]);
	}
}

function InitPlotCoverParcels(string strPlot, XComGameState_BattleData InBattleData)
{
	BattleData = InBattleData;

	strPlotType = strPlot;

	CacheValidPCPDefs();
	AssignLayerDistribution();
}

function array<PCPDefinition> GetValidObjectivePCPDefs(XComPlotCoverParcel kPCP, MissionDefinition MissionType)
{
	local int idx;
	local PCPDefinition PCPDef;
	local array<PCPDefinition> arrPCPDefsToReturn;
	local array<PCPDefinition> arrFailsafePCPDefsToReturn;
	local XComParcelManager ParcelManager;

	ParcelManager = `PARCELMGR;

	ParcelManager.ParcelGenerationAssert(kPCP.bCanBeObjective, "This PCP cannot be the objective, this is a serious code error.");

	for (idx = 0; idx < arrPCPDefs.Length; idx++)
	{
		PCPDef = arrPCPDefs[idx];

		if(DoesPCPDefMeetObjectiveRequirements(PCPDef, MissionType))
		{
			if(MatchesPCPDef(kPCP, PCPDef))
			{
				arrPCPDefsToReturn.AddItem(PCPDef);
			}
			else
			{
				arrFailsafePCPDefsToReturn.AddItem(PCPDef);
			}
		}
	}

	if(arrPCPDefsToReturn.Length > 0)
	{
		return arrPCPDefsToReturn;
	}
	else if(arrFailsafePCPDefsToReturn.Length > 0)
	{
		ParcelManager.ParcelGenerationAssert(false, "Could not find a matching objective pcp, get ready for trains in the streets.");
		return arrFailsafePCPDefsToReturn;
	}
	else
	{
		ParcelManager.ParcelGenerationAssert(false, "Could not find any mission matching pcp defs, the mission will likely fail to be completable!");
		return arrPCPDefs;
	}
}

function AssignLayerDistribution()
{
	local XComPlotCoverParcel kPCP;
	local string strLayerName;
	local int iSpawnChance;

	// 50% across the board until we figure out how this is controlled
	iSpawnChance = 50;

	foreach `XWORLDINFO.AllActors(class'XComPlotCoverParcel', kPCP)
	{
		foreach `PARCELMGR.arrLayers(strLayerName)
		{
			if(`SYNC_RAND_TYPED(100) > iSpawnChance)
			{
				kPCP.arrRequiredLayers.AddItem(strLayerName);
			}
		}
	}
}

function InitPeripheryPCPs()
{
	local int iIndex;
	local string strLevelName;
	local XComPlotCoverParcel kPCP;
	local StoredMapData_Parcel ParcelData;

	foreach `XWORLDINFO.AllActors(class'XComPlotCoverParcel', kPCP)
	{
		if (kPCP.bIsPeriphery && kPCP.arrLevelNames.Length > 0)
		{
			iIndex = `SYNC_RAND_TYPED(kPCP.arrLevelNames.Length);
			strLevelName = kPCP.arrLevelNames[iIndex];
			kPCP.strLevelName = strLevelName;

			if (strLevelName != "")
			{
				`MAPS.AddStreamingMap(strLevelName, kPCP.Location, kPCP.Rotation, bBlockingLoadParcels, true);
				
				ParcelData.Location = kPCP.Location;
				ParcelData.Rotation = kPCP.Rotation;
				ParcelData.MapName = strLevelName;
				BattleData.MapData.PlotCoverParcelData.AddItem(ParcelData);
			}
		}
	}
}

static function RelinkPCPDebugData(XComGameState_BattleData BattleDataState)
{
	local XComPlotCoverParcel PCP;
	local int Index;

	foreach class'WorldInfo'.static.GetWorldInfo().AllActors(class'XComPlotCoverParcel', PCP)
	{
		for (Index = 0; Index < BattleDataState.MapData.PlotCoverParcelData.Length; Index++)
		{
			if(PCP.Location == BattleDataState.MapData.PlotCoverParcelData[Index].Location)
			{
				PCP.strLevelName = BattleDataState.MapData.PlotCoverParcelData[Index].MapName;
				break;
			}
		}
	}
}

defaultproperties
{
	bBlockingLoadParcels=true
}
