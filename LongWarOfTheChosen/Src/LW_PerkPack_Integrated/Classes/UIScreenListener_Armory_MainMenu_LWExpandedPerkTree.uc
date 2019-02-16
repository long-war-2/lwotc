//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_Armory_MainMenu_LWExpandedPerkTree
//  AUTHOR:  Amineri
//
//  PURPOSE: Implements hooks to add button to List in order to invoke Expanded Perk Tree for testing
//		deprecated in overhaul, as new Armory_MainMenu design incorporated into XComGame
//--------------------------------------------------------------------------------------- 

class UIScreenListener_Armory_MainMenu_LWExpandedPerkTree extends UIScreenListener deprecated;

`include(LW_PerkPack_Integrated\LW_PerkPack.uci)

var localized string strExpandedMenuOption;
var localized string strExpandedTooltip;
var localized string ExpandedListItemDescription;

static function DisableSoldierIntros()
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState NewGameState;
	`PPTrace("Disabling soldier intros");

	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	`PPTrace("Checking for first soldier of each type");
	if(!XComHQ.bHasSeenFirstGrenadier)
	{
		`PPTrace("This is the first grenadier");
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Soldier Class Movie");
		XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
		NewGameState.AddStateObject(XComHQ);
		XComHQ.bHasSeenFirstGrenadier = true;
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
	if(!XComHQ.bHasSeenFirstPsiOperative)
	{
		`PPTrace("This is the first PsiOp");
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Soldier Class Movie");
		XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
		NewGameState.AddStateObject(XComHQ);
		XComHQ.bHasSeenFirstPsiOperative = true;
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
	if(!XComHQ.bHasSeenFirstRanger)
	{
		`PPTrace("This is the first Ranger");
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Soldier Class Movie");
		XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
		NewGameState.AddStateObject(XComHQ);
		XComHQ.bHasSeenFirstRanger = true;
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
	if(!XComHQ.bHasSeenFirstSharpshooter)
	{
		`PPTrace("This is the first Sharpshooter");
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Soldier Class Movie");
		XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
		NewGameState.AddStateObject(XComHQ);
		XComHQ.bHasSeenFirstSharpshooter = true;
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
	if(!XComHQ.bHasSeenFirstSpecialist)
	{
		`PPTrace("This is the first Specialist");
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Soldier Class Movie");
		XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
		NewGameState.AddStateObject(XComHQ);
		XComHQ.bHasSeenFirstSpecialist = true;
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
	
    `PPTrace("    Done!");
}

defaultproperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = UIArmory_MainMenu;
}