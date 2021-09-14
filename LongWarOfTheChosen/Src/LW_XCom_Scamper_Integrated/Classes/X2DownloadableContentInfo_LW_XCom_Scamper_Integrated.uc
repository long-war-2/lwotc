class X2DownloadableContentInfo_LW_XCom_Scamper_Integrated extends X2DownloadableContentInfo;

static event OnPostTemplatesCreated()
{
	local X2TacticalGameRuleset TacticalRulesCDO;

	TacticalRulesCDO = X2TacticalGameRuleset(class'XComEngine'.static.GetClassDefaultObject(class'X2TacticalGameRuleset'));
	TacticalRulesCDO.EventObserverClasses.AddItem(class'X2TacticalGameRuleset_XComScamperObserver');
}

exec function ScamperDumpContextHistory (int Limit = 100)
{
	local XComGameStateHistory History;
	local XComGameStateContext Context;
	local int DumpedCount;

	History = `XCOMHISTORY;

	`log("Starting",, 'ScamperDumpContextHistory');

	foreach History.IterateContextsByClassType(class'XComGameStateContext', Context)
	{
		`log(Context.AssociatedState.HistoryIndex @ string(Context.Class.Name) @ "-" @ Context.SummaryString(),, 'ScamperDumpContextHistory');

		DumpedCount++;
		if (DumpedCount >= Limit) break;
	}

	`log("Finished",, 'ScamperDumpContextHistory');
}