class X2Effect_ItemWeight extends X2Effect_ModifyStats config(LW_Overhaul);

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Item SourceItem;
	local StatChange Change;
	local int i;
	local name CurrentItemName;

	Change.StatType = eStat_Mobility;
	Change.StatAmount = -1;
	
	SourceItem = XComGameState_Item(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));
    if(SourceItem == none)
    {
        SourceItem = XComGameState_Item(class'XComGameStateHistory'.static.GetGameStateHistory().GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));
    }
	for (i=0; i < class'LWTemplateMods'.default.ItemTable.Length; ++i)
	{
		CurrentItemName = class'LWTemplateMods'.default.ItemTable[i].ItemTemplateName;
		if (SourceItem.GetMyTemplateName() == CurrentItemName)
		{
			Change.StatAmount = -class'LWTemplateMods'.default.ItemTable[i].Weight;
		}
	}
    if(SourceItem != none)
    {
		if (SourceItem.MergedItemCount > 1)
		{
			Change.StatAmount = SourceItem.MergedItemCount * Change.StatAmount;
		}
	}
	NewEffectState.StatChanges.AddItem(Change);
    super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}