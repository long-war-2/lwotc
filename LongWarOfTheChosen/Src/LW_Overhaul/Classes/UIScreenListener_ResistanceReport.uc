//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_ResistanceReport.uc
//  AUTHOR:  amineri / Pavonis Interactive
//
//  PURPOSE: Applies changes to UIResistanceReport
//
//--------------------------------------------------------------------------------------- 

class UIScreenListener_ResistanceReport extends UIScreenListener config(LW_Activities);

var localized string m_strStaffingHelp;
var config array<name> RestrictedAvatarResistanceActivities;

// This event is triggered after a screen is initialized
event OnInit(UIScreen Screen)
{
	if (UIResistanceReport(Screen) == none)
		return;

	UpdateResistanceReport(Screen);
}

// This event is triggered after a screen receives focus
event OnReceiveFocus(UIScreen Screen)
{
	if (UIResistanceReport(Screen) == none)
		return;

	UpdateResistanceReport(Screen);
}

function UpdateResistanceReport(UIScreen Screen)
{
	local XComGameStateHistory History;
	local UIResistanceReport Report;
	local array<StateObjectReference> PersonnelRewards;
	local XComGameState_Reward ResReward;
	local array<string> arrNewStaffNames;
	local string strStaffName;
	local int idx, DeltaDoom;
	local XComGameState_BlackMarket BlackMarket;
	local XComGameState_HeadquartersAlien AlienHQ;
	local XComGameState_HeadquartersResistance ResHQ;
	local array<TResistanceActivity> arrActions;
	local String strAction, strActivityList;
	local int iAction;

	Report = UIResistanceReport(Screen);

	History = `XCOMHISTORY;
	PersonnelRewards = GetBlackMarketForSalePersonnel();
	ResHQ = Report.ResHQ();

	for (idx = 0; idx < 3; idx++)
	{
		ResReward = XComGameState_Reward(History.GetGameStateForObjectID(PersonnelRewards[idx].ObjectID));
		strStaffName = class'X2StrategyElement_DefaultRewards'.static.GetPersonnelName(ResReward);
		arrNewStaffNames.AddItem(strStaffName);
	}
	
	BlackMarket = XComGameState_BlackMarket(History.GetSingleGameStateObjectForClass(class'XComGameState_BlackMarket'));
	if (BlackMarket.bIsOpen)
		Report.AS_UpdateCouncilReportCardStaff(Report.m_strStaffAvailable, arrNewStaffNames[0], arrNewStaffNames[1], arrNewStaffNames[2], default.m_strStaffingHelp);
	else
		Report.AS_UpdateCouncilReportCardStaff("", "", "", "", "");

	// remove the alien Activity information if player hasn't completed liberation objective
	if( !class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('S0_RevealAvatarProject') )
	{
		arrActions = GetAlienMonthlyNonAvatarActivity(ResHQ);

		for (iAction = 0; iAction < arrActions.Length; iAction++)
		{ 
			strAction = class'UIUtilities_Text'.static.GetColoredText(arrActions[iAction].Title @ string(arrActions[iAction].Count), arrActions[iAction].Rating);
		
			strActivityList $= strAction;
			if (iAction < arrActions.Length - 1)
			{
				strActivityList $= ", ";
			}
		}

		Report.AS_UpdateCouncilReportCardAlienActivity(Report.m_strAlienActivity, strActivityList);
		Report.AS_UpdateCouncilReportCardAvatarProgress("", -1);
	}
	else
	{
		//this panel now will display the 
		AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));
		DeltaDoom = GetMonthlyAvatarProgress (ResHQ);
		if (AlienHQ != none && DeltaDoom > 0)
		{
			Report.AS_UpdateCouncilReportCardAvatarProgress(Report.m_strAvatarProgressLabel, DeltaDoom);
		}
		else
		{
			Report.AS_UpdateCouncilReportCardAvatarProgress("", -1);
		}
	}
}

simulated function int GetMonthlyAvatarProgress(XComGameState_HeadquartersResistance ResHQ)
{
	local TResistanceActivity ActivityStruct;
	local int idx, TotalAvatarProgress;

	TotalAvatarProgress = 0;
	for(idx = 0; idx < ResHQ.ResistanceActivities.Length; idx++)
	{
		ActivityStruct = ResHQ.ResistanceActivities[idx];

		if (ActivityStruct.ActivityTemplateName == 'ResAct_AvatarProgress')
		{
			TotalAvatarProgress += ActivityStruct.Count;
		}
		if (ActivityStruct.ActivityTemplateName == 'ResAct_AvatarProgressReduced')
		{
			TotalAvatarProgress -= ActivityStruct.Count;
		}
	}
	return TotalAvatarProgress;
}

simulated function array<TResistanceActivity> GetAlienMonthlyNonAvatarActivity(XComGameState_HeadquartersResistance ResHQ)
{
	local array<TResistanceActivity> arrActions;
	local TResistanceActivity ActivityStruct;
	local int idx;
	
	for(idx = 0; idx < ResHQ.ResistanceActivities.Length; idx++)
	{
		ActivityStruct = ResHQ.ResistanceActivities[idx];

		if(ActivityShouldAppearInNonAvatarReport(ActivityStruct))
		{
			ActivityStruct.Rating = ResHQ.GetActivityTextState(ActivityStruct);
			if (ActivityStruct.Rating == eUIState_Bad)
			{
				arrActions.AddItem(ActivityStruct);
			}
		}
	}

	return arrActions;
}

function bool ActivityShouldAppearInNonAvatarReport(TResistanceActivity ActivityStruct)
{
	local X2StrategyElementTemplateManager StratMgr;
	local X2ResistanceActivityTemplate ActivityTemplate;

	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	ActivityTemplate = X2ResistanceActivityTemplate(StratMgr.FindStrategyElementTemplate(ActivityStruct.ActivityTemplateName));

	if(ActivityTemplate != none)
	{
		if(ActivityStruct.Count == 0)
		{
			return false;
		}
		if ( default.RestrictedAvatarResistanceActivities.Find(ActivityStruct.ActivityTemplateName) != -1)
		{
			return false;
		}
		return true;
	}

	return false;
}

function array<StateObjectReference> GetBlackMarketForSalePersonnel()
{
	local XComGameStateHistory History;
	local XComGameState_BlackMarket BlackMarket;
	local array<StateObjectReference> PersonnelRewards;
	local Commodity ForSaleItem;
	local XComGameState_Reward RewardState;
	local name RewardName;

	History = `XCOMHISTORY;
	BlackMarket = XComGameState_BlackMarket(History.GetSingleGameStateObjectForClass(class'XComGameState_BlackMarket'));

	PersonnelRewards.Length = 0;
	foreach BlackMarket.ForSaleItems(ForSaleItem)
	{
		RewardState = XComGameState_Reward(History.GetGameStateForObjectID(ForSaleItem.RewardRef.ObjectID));
		if (RewardState == none)
			continue;

		RewardName = RewardState.GetMyTemplateName();
		switch (RewardName)
		{
			case 'Reward_Scientist':
			case 'Reward_Engineert':
			case 'Reward_Soldier':
				PersonnelRewards.AddItem(RewardState.GetReference());
				break;
			default:
				break;
		}
	}

	return PersonnelRewards;
}

// This event is triggered after a screen loses focus
//event OnLoseFocus(UIScreen Screen);

// This event is triggered when a screen is removed
//event OnRemoved(UIScreen Screen);

defaultproperties
{
	// Leave this none and filter in the handlers to handle class overrides
	ScreenClass = none;
}