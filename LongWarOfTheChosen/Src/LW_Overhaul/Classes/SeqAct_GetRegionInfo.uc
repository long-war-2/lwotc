
//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_GetRegionInfo.uc
//  AUTHOR:  tracktwo / LWS
//  PURPOSE: Gets info about the levels in the region in which the current battle is taking place
//---------------------------------------------------------------------------------------

class SeqAct_GetRegionInfo extends SequenceAction;

var int LocalAlertLevel;
var int LocalForceLevel;
var int LocalVigilanceLevel;
var bool Liberated;


event Activated()
{
    local XComGameState_WorldRegion_LWStrategyAI RegionAI;
    local XComGameState_WorldRegion Region;
    local XComGameState_MissionSite Mission;
    local XComGameStateHistory History;

    History = `XCOMHISTORY;
    Mission = XComGameState_MissionSite(History.GetGameStateForObjectID(`XCOMHQ.MissionRef.ObjectID));
    Region = XComGameState_WorldRegion(History.GetGameStateForObjectID(Mission.Region.ObjectID));
    RegionAI = class'XComGameState_WorldRegion_LWStrategyAI'.static.GetRegionalAI(Region);

    LocalAlertLevel = RegionAI.LocalAlertLevel;
    LocalForceLevel = RegionAI.LocalForceLevel;
    LocalVigilanceLevel = RegionAI.LocalVigilanceLevel;
    Liberated = RegionAI.bLiberated;
}

defaultproperties
{
	ObjCategory="LWOverhaul"
	ObjName="Get Regional AI Info"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	VariableLinks.Empty
    VariableLinks(0)=(ExpectedType=class'SeqVar_Int',LinkDesc="Force Level",PropertyName=LocalForceLevel,bWriteable=true)
    VariableLinks(1)=(ExpectedType=class'SeqVar_Int',LinkDesc="Alert Level",PropertyName=LocalAlertLevel,bWriteable=true)
    VariableLinks(2)=(ExpectedType=class'SeqVar_Int',LinkDesc="Vigilance Level",PropertyName=LocalVigilanceLevel,bWriteable=true)
    VariableLinks(3)=(ExpectedType=class'SeqVar_Bool',LinkDesc="Liberated",PropertyName=Liberated,bWriteable=true)
}
