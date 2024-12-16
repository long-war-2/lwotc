class UIInventory_LootRecovered_LW extends UIInventory_LootRecovered config(UI) dependson (UIInventory_VIPRecovered_LW);

struct ExtraVIPIcon
{
    var name TemplateName;
    var String Icon;
};

var config array<ExtraVIPIcon> ExtraVIPIcons;
var localized string m_strVIPRecovered;

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	local XComGameState_MissionSite Mission;

	super(UIInventory).InitScreen(InitController, InitMovie, InitName);
	
	SetInventoryLayout();
	PopulateData();

	Mission = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(XComHQ.MissionRef.ObjectID));
	if(Mission.HasRewardVIP())
	{
		VIPPanel = Spawn(class'UIInventory_VIPRecovered', self).InitVIPRecovered();
		VIPPanel.SetPosition(1300, 772); // position is based on guided out panel in Inventory.fla
        VIPPanel.Hide(); // But don't display it: we only want the pawn.
    }

	`XCOMGRI.DoRemoteEvent('CIN_HideArmoryStaff'); //Hide the staff in the armory so that they don't overlap with the soldiers

	ContinueAfterActionMatinee();
	`XCOMGRI.DoRemoteEvent('LootRecovered');
}

simulated function BuildScreen()
{
	super(UIInventory).BuildScreen();
    List.OnSelectionChanged = LootSelectedItemChanged;
	
	// Transition instantly to from UIAfterAction to UIInventory_LootRecovered
	if( bIsIn3D ) class'UIUtilities'.static.DisplayUI3D(DisplayTag, CameraTag, 0);
}

simulated function LootSelectedItemChanged(UIList ContainerList, int ItemIndex)
{
    local UIInventory_VIPListItem VIPListItem;

    VIPListItem = UIInventory_VIPListItem(ContainerList.GetItem(ItemIndex));
    if (VIPListItem != none)
    {
        ItemCard.Hide();
    }
    else
    {
        // Not a VIP. Use the superclass implementation
        super(UIInventory).SelectedItemChanged(ContainerList, ItemIndex);
    }
}

simulated function PopulateData()
{
	local int i;
	local name TemplateName;
	local X2ItemTemplate ItemTemplate;
	local X2EquipmentTemplate EquipmentTemplate;
	local UIInventory_ListItem ListItem;
	local XComGameState_Item ItemState;
	local XComGameState_BattleData BattleData;
	local array<StateObjectReference> PrevUnlockedTechs, PrevUnlockedShadowProjects, UnlockedShadowProjects;
	local array<XComGameState_Item> ObjectiveItems;
	local array<XComGameState_Item> Artifacts;
	local array<XComGameState_Item> Loot, AutoLoot;
	local XComGameState_Tech TechState;
	local XComNarrativeMoment LootRecoveredNarrative;
	local array<StateObjectReference> LootList;
	local XComGameState NewGameState;
	local UIInventory_HeaderListItem HeaderListItem;

	super(UIInventory).PopulateData();

	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));

	// First try to unpack any item caches which were recovered
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Loot Recovered: Open Cache Items");
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	if (XComHQ.UnpackCacheItems(NewGameState))
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);	
	else
		`XCOMHISTORY.CleanupPendingGameState(NewGameState);
	
	// Issue #736
	/// HL-Docs: feature:AfterActionModifyRecoveredLoot; issue:736; tags:strategy
	/// The event is triggered after the cache items were unpacked but before any loot is shown in the UI.
	/// Part of the post-mission sequence. Inspect XComGameState_HeadquartersXCom.LootRecovered for the pending loot
	///
	/// ```unrealscript
	/// EventID: AfterActionModifyRecoveredLoot
	/// EventSource: UIInventory_LootRecovered (self)
	/// ```
	///
	/// No game state is passed, so make sure to use ELD_Immediate
	`XEVENTMGR.TriggerEvent('AfterActionModifyRecoveredLoot',, self);

	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ(true); // Refresh XComHQ
	LootList = XComHQ.LootRecovered;

    `LWTrace("LootList length:" @LootList.Length);

	for(i = 0; i < LootList.Length; i++)
	{
		ItemState = XComGameState_Item(History.GetGameStateForObjectID(LootList[i].ObjectID));

		if(ItemState != none)
		{
			ItemTemplate = ItemState.GetMyTemplate();

			if(!ItemTemplate.HideInLootRecovered)
			{
				TemplateName = ItemState.GetMyTemplateName();
				EquipmentTemplate = X2EquipmentTemplate(ItemTemplate);
				
				if ((ItemTemplate.ItemCat == 'goldenpath' || ItemTemplate.ItemCat == 'quest') && EquipmentTemplate == none) // Add non-equipment GP items to the Objective section
					ObjectiveItems.AddItem(ItemState);
				else if(ItemTemplate.IsObjectiveItemFn != none && ItemTemplate.IsObjectiveItemFn())
				{
					ObjectiveItems.AddItem(ItemState);
				}
				else if(BattleData.CarriedOutLootBucket.Find(TemplateName) != INDEX_NONE)
					Loot.AddItem(ItemState);
				else if(BattleData.AutoLootBucket.Find(TemplateName) != INDEX_NONE)
					AutoLoot.AddItem(ItemState);
				else
					Artifacts.AddItem(ItemState);
			}

			if (ItemState.GetMyTemplate().ItemRecoveredAsLootNarrative != "")
			{
				if (ItemState.GetMyTemplate().ItemRecoveredAsLootNarrativeReqsNotMet != "" && !XComHQ.MeetsAllStrategyRequirements(ItemState.GetMyTemplate().Requirements))
					LootRecoveredNarrative = XComNarrativeMoment(`CONTENT.RequestGameArchetype(ItemState.GetMyTemplate().ItemRecoveredAsLootNarrativeReqsNotMet));
				else
					LootRecoveredNarrative = XComNarrativeMoment(`CONTENT.RequestGameArchetype(ItemState.GetMyTemplate().ItemRecoveredAsLootNarrative));

				XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
				if (LootRecoveredNarrative != None && XComHQ.CanPlayLootNarrativeMoment(LootRecoveredNarrative))
				{
					NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Update Played Loot Narrative List");
					XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
					XComHQ.UpdatePlayedLootNarrativeMoments(LootRecoveredNarrative);
					`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

					`HQPRES.UINarrative(LootRecoveredNarrative);
				}
			}

			if (ItemState.GetMyTemplate().ItemRecoveredAsLootEventToTrigger != '')
			{
				NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Trigger Loot Recovered Event");
				`XEVENTMGR.TriggerEvent(ItemState.GetMyTemplate().ItemRecoveredAsLootEventToTrigger, , , NewGameState);
				`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
			}
		}
	}

	if(ObjectiveItems.Length > 0)
	{
		HeaderListItem = Spawn(class'UIInventory_HeaderListItem', List.ItemContainer);
		HeaderListItem.InitHeaderItem(class'UIUtilities_Image'.const.LootIcon_Objectives, m_strObjectiveItemsRecovered);
		HeaderListItem.DisableNavigation();
		
		for(i = 0; i < ObjectiveItems.Length; ++i)
			AddLootItem(ObjectiveItems[i]);
	}

	if(Loot.Length > 0)
	{
		HeaderListItem = Spawn(class'UIInventory_HeaderListItem', List.ItemContainer);
		HeaderListItem.InitHeaderItem(class'UIUtilities_Image'.const.LootIcon_Loot, m_strLootRecovered);
		HeaderListItem.DisableNavigation();
		for(i = 0; i < Loot.Length; ++i)
			AddLootItem(Loot[i]);
	}

	for(i = 0; i < AutoLoot.Length; i++)
	{
		Artifacts.AddItem(AutoLoot[i]);
	}

	if(Artifacts.Length > 0)
	{
		HeaderListItem = Spawn(class'UIInventory_HeaderListItem', List.ItemContainer);
		HeaderListItem.InitHeaderItem(class'UIUtilities_Image'.const.LootIcon_Artifacts, m_strArtifactRecovered, BattleData.AllTacticalObjectivesCompleted() ? m_strArtifactRecoveredSweep : m_strArtifactRecoveredEvac);
		HeaderListItem.DisableNavigation();
		for(i = 0; i < Artifacts.Length; ++i)
			AddLootItem(Artifacts[i]);
	}

    if(BattleData.RewardUnits.Length > 0)
    {
        Spawn(class'UIInventory_HeaderListItem', List.ItemContainer).InitHeaderItem("img:///UILibrary_Common.UIEvent_staff", m_strVIPRecovered);
        for(i = 0; i <  BattleData.RewardUnits.Length; ++i)
            AddVIPReward(BattleData.RewardUnits[i]);
    }

	SetCategory(List.ItemCount == 0 ? m_strNoLoot : "");

	if(List.ItemCount > 0)
	{
		i = 0;
		while(i < List.ItemCount)
		{

			ListItem = UIInventory_ListItem(List.GetItem(i));
			if (ListItem != none && ListItem.bIsNavigable)
			{
				List.SetSelectedItem(ListItem);
				PopulateItemCard(ListItem.ItemTemplate, ListItem.ItemRef);
				break;
			}
			i++;
		}
	}
	
	// Store available upgrades before adding new loot
	PrevUnlockedTechs = XComHQ.GetAvailableTechsForResearch();
	PrevUnlockedShadowProjects = XComHQ.GetAvailableTechsForResearch(true);

	class'XComGameStateContext_StrategyGameRule'.static.AddLootToInventory();

	`XSTRATEGYSOUNDMGR.PlaySoundEvent("LootMenu_LootPickup");

	// Get newly available available upgrades now that we added new loot
	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	UnlockedTechs = XComHQ.GetAvailableTechsForResearch();
	UnlockedShadowProjects = XComHQ.GetAvailableTechsForResearch(true);

	// Removed previously available techs from UnlockedTechs array to get new techs generated by the loot recovered
	for(i = 0; i < PrevUnlockedTechs.Length; ++i)
	{
		UnlockedTechs.RemoveItem(PrevUnlockedTechs[i]);
	}

	// Removed previously available shadow projects from the array to get new shadow projects generated by the loot recovered
	for(i = 0; i < PrevUnlockedShadowProjects.Length; ++i)
	{
		UnlockedShadowProjects.RemoveItem(PrevUnlockedShadowProjects[i]);
	}

	for(i = 0; i < UnlockedShadowProjects.Length; ++i)
	{
		UnlockedTechs.AddItem(UnlockedShadowProjects[i]);
	}

	for(i = 0; i < UnlockedTechs.Length; ++i)
	{
		TechState = XComGameState_Tech(`XCOMHISTORY.GetGameStateForObjectID(UnlockedTechs[i].ObjectID));

		if(TechState != None && TechState.TimesResearched > 0)
		{
			UnlockedTechs.Remove(i, 1);
			i--;
		}
	}
}


simulated function AddVIPReward(StateObjectReference UnitRef)
{
    local XComGameState_Unit Unit;
    local string VIPIcon, StatusLabel, VIPString;
    local EUIState VIPState;
    local EVIPStatus VIPStatus;
    local XComGameState_MissionSite Mission;
    local bool bDarkVIP;
    local int i;

    Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitRef.ObjectID));
    Mission = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(XComHQ.MissionRef.ObjectID));

	VIPStatus = EVIPStatus(Mission.GetRewardVIPStatus(Unit));
	bDarkVIP = Unit.GetMyTemplateName() == 'HostileVIPCivilian';

	if(Unit.IsEngineer())
	{
    	VIPIcon = class'UIUtilities_Image'.const.EventQueue_Engineer;
	}
	else if(Unit.IsScientist())
	{
		VIPIcon = class'UIUtilities_Image'.const.EventQueue_Science;
	}
	else if(bDarkVIP)
	{
		VIPIcon = class'UIUtilities_Image'.const.EventQueue_Advent;
	}
    else
    {
        // Check our extra icon array
        i = ExtraVIPIcons.Find('TemplateName', Unit.GetMyTemplateName());
        if (i != -1)
        {
            VIPIcon = ExtraVIPIcons[i].Icon;
        }
    }

	switch(VIPStatus)
	{
	case eVIPStatus_Awarded:
	case eVIPStatus_Recovered:
		VIPState = eUIState_Good;
		break;
	default:
		VIPState = eUIState_Bad;
		break;
	}

	if(bDarkVIP)
		StatusLabel = class'UIInventory_VIPRecovered'.default.m_strEnemyVIPStatus[VIPStatus];
	else
		StatusLabel = class'UIInventory_VIPRecovered'.default.m_strVIPStatus[VIPStatus];
    
    if (VIPIcon != "")
    {
        VIPString = class'UIUtilities_Text'.static.InjectImage(VIPIcon, 24, 24);
    }
    VIPString = VIPString $ Unit.GetFullName();
    Spawn(class'UIInventory_VIPListItem', List.ItemContainer).InitVIPListItem(class'UIUtilities_Text'.static.GetSizedText(VIPstring, 24), class'UIUtilities_Text'.static.GetColoredText(StatusLabel, VIPState, , "RIGHT"));

}
