//---------------------------------------------------------------------------------------
//  FILE:    SeqEvent_UnitRemovedFromPlay.uc
//  AUTHOR:  tracktwo / LWS
//  PURPOSE: Invoked when a unit is removed from play.
//---------------------------------------------------------------------------------------
class SeqEvent_UnitRemovedFromPlay extends SeqEvent_GameEventTriggered;

var private XGPlayer LosingPlayer;
var() array<Name> TemplateNamesToExclude;

var private array<XGPlayer> FiredForPlayer;

defaultproperties
{
    EventID="UnitRemovedFromPlay"
	ObjName="(LW) Unit Removed From Play"
    ObjCategory="LWOverhaul"

    bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

    VariableLinks(0)=(ExpectedType=class'SeqVar_GameUnit',LinkDesc="Unit",PropertyName=RelevantUnit,bWriteable=TRUE)
}
