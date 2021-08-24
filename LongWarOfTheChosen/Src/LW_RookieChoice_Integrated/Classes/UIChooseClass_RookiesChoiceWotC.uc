class UIChooseClass_RookiesChoiceWotC extends UIChooseClass;

var UIArmory_MainMenu ParentScreen;
var XcomGameState_Unit Unit;
//var array<X2SoldierClassTemplate> m_arrClasses;


//-------------- EVENT HANDLING --------------------------------------------------------
simulated function OnPurchaseClicked(UIList kList, int itemIndex)
{
	if (itemIndex != iSelectedItem)
	{
		iSelectedItem = itemIndex;
	}

	else
	{
		OnClassSelected(iSelectedItem);
		Movie.Stack.Pop(self);
		//UpdateData();
	}

}

simulated function InitScreen(XComPlayerController InitController, UIMovie InitMovie, optional name InitName)
{
	super.InitScreen(InitController, InitMovie, InitName);

	ItemCard.Hide();
}

simulated function PopulateData()
{
	local Commodity Template;
	local int i;

	List.ClearItems();
	List.bSelectFirstAvailable = false;
	
	for(i = 0; i < arrItems.Length; i++)
	{
		Template = arrItems[i];
		if(i < m_arrRefs.Length)
		{
			Spawn(class'UIInventory_ClassListItem', List.itemContainer).InitInventoryListCommodity(Template, m_arrRefs[i], GetButtonString(i), m_eStyle, , 126);
		}
		else
		{
			Spawn(class'UIInventory_ClassListItem', List.itemContainer).InitInventoryListCommodity(Template, , GetButtonString(i), m_eStyle, , 126);
		}
	}
}

simulated function PopulateResearchCard(optional Commodity ItemCommodity, optional StateObjectReference ItemRef)
{
}

//-------------- GAME DATA HOOKUP --------------------------------------------------------
simulated function GetItems()
{
	arrItems = ConvertClassesToCommodities();
}

simulated function array<Commodity> ConvertClassesToCommodities()
{
	local X2SoldierClassTemplate ClassTemplate;
	local int iClass;
	local array<Commodity> arrCommodoties;
	local Commodity ClassComm;
	
	m_arrClasses.Remove(0, m_arrClasses.Length);
	m_arrClasses = GetClasses();
	m_arrClasses.Sort(SortClassesByName);

	for (iClass = 0; iClass < m_arrClasses.Length; iClass++)
	{
		ClassTemplate = m_arrClasses[iClass];
		
		ClassComm.Title = ClassTemplate.DisplayName;
		ClassComm.Image = ClassTemplate.IconImage;
		ClassComm.Desc = ClassTemplate.ClassSummary;
		//ClassComm.OrderHours = XComHQ.GetTrainRookieDays() * 24;
		`log("RookiesChoiceWotC Default Option ID:" @iClass @m_arrClasses[iClass]);

		arrCommodoties.AddItem(ClassComm);
	}

	return arrCommodoties;
}

//-----------------------------------------------------------------------------

//This is overwritten in the research archives. 
simulated function array<X2SoldierClassTemplate> GetClasses()
{
	local X2SoldierClassTemplateManager SoldierClassTemplateMan;
	local SuperClass SuperClassTemplate;
	local array<X2SoldierClassTemplate> ClassTemplates;
	local X2SoldierClassTemplate SoldierClassTemplate;
	local name SoldierClassName;
	
	SoldierClassTemplateMan = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();

	SuperClassTemplate = class'ConfigOptions'.default.SuperClasses[`SYNC_RAND(class'ConfigOptions'.default.SuperClasses.Length)];

	foreach SuperClassTemplate.PossibleClasses(SoldierClassName)
	{
		SoldierClassTemplate = SoldierClassTemplateMan.FindSoldierClassTemplate(SoldierClassName);
		ClassTemplates.AddItem(SoldierClassTemplate);
	}

	

	return ClassTemplates;
}

function int SortClassesByName(X2SoldierClassTemplate ClassA, X2SoldierClassTemplate ClassB)
{	
	if (ClassA.DisplayName < ClassB.DisplayName)
	{
		return 1;
	}
	else if (ClassA.DisplayName > ClassB.DisplayName)
	{
		return -1;
	}
	else
	{
		return 0;
	}
}

function bool OnClassSelected(int iOption)
{
	local XComGameState NewGameState;
	local name NewClass;
	local int iClass;

	NewClass=m_arrClasses[iOption].DataName;

	`log("RookiesChoiceWotC chosen class:" @iOption @NewClass);
	for (iClass = 0; iClass < m_arrClasses.Length; iClass++) {
		`log("RookiesChoiceWotC chosen Option ID:" @iClass @m_arrClasses[iClass]);
	}

	if(Unit.GetSoldierClassTemplate().DataName==NewClass) //if trying to change into class the unit already is return
		return false;

	NewGameState=class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Ranking up Unit in chosen Class");

	Unit.MakeItemsAvailable(NewGameState, False);
	Unit.RankUpSoldier(NewGameState, NewClass);
	Unit.ApplySquaddieLoadout(NewGameState);

	`XSTRATEGYSOUNDMGR.PlaySoundEvent("StrategyUI_Recruit_Soldier");
	`XCOMHISTORY.AddGameStateToHistory(NewGameState);
	`HQPRES.UIArmory_Promotion(Unit.GetReference());
	ParentScreen.PopulateData();

	return true;
}

simulated function RefreshFacility()
{
	local UIScreen QueueScreen;

	QueueScreen = Movie.Stack.GetScreen(class'UIFacility_Armory');
	if (QueueScreen != None)
		UIFacility_Armory(QueueScreen).RealizeFacility();
}

//----------------------------------------------------------------
simulated function OnCancelButton(UIButton kButton) { OnCancel(); }
simulated function OnCancel()
{
	CloseScreen();
}

//==============================================================================

simulated function OnLoseFocus()
{
	super.OnLoseFocus();
	`HQPRES.m_kAvengerHUD.NavHelp.ClearButtonHelp();
}

simulated function OnReceiveFocus()
{
	super.OnReceiveFocus();
	`HQPRES.m_kAvengerHUD.NavHelp.ClearButtonHelp();
	`HQPRES.m_kAvengerHUD.NavHelp.AddBackButton(OnCancel);
}

defaultproperties
{
	InputState = eInputState_Consume;

	bHideOnLoseFocus = true;
	bConsumeMouseEvents = true;

	DisplayTag="UIBlueprint_Promotion"
	CameraTag="UIBlueprint_Promotion"
}