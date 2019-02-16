//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_Armory_MainMenu_LW.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//
//  PURPOSE: This class updates the Rank string to include the squad name, and rolls for AWC abilities when needed
//---------------------------------------------------------------------------------------

class UIScreenListener_Armory_MainMenu_LW extends UIScreenListener config(LW_AWCPack);

var bool bRegisteredForEvents;

var localized string CannotModifyOnMissionSoldierTooltip;

event OnInit(UIScreen Screen)
{
	UpdateRankStringWithSquadName(Screen);
	RollAWCAbilitiesIfNeeded(Screen);
}

event OnReceiveFocus(UIScreen Screen)
{
	UpdateRankStringWithSquadName(Screen);
	RollAWCAbilitiesIfNeeded(Screen);
}

function UpdateRankStringWithSquadName(UIScreen Screen)
{
	local UIArmory Armory;
	local UISoldierHeader Header;
	local XComGameState_LWPersistentSquad SquadState;
	local string RankString;
	local XComGameState_Unit Unit;

	Armory = UIArmory(Screen);
	if (Armory == none)
		return;

	Header = Armory.Header;
	if (Header == none)
		return;

	if (`LWSQUADMGR.UnitIsInAnySquad(Armory.UnitReference, SquadState))
	{
		Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Header.UnitRef.ObjectID));
		if (Unit == none)
			return;

		//RankString = Armory.Header.MC.GetString("soldierTitleText.rankIcon.textField.htmlText");

		if (Unit.GetRank() == 0) // rookies have this stuff hidden, so we need to show it
		{
			Header.MC.ChildSetBool("soldierTitleText.rankIcon", "_visible", true);
			Header.MC.ChildSetBool("soldierTitleText.rankIcon.icon", "_visible", false);
			Header.MC.ChildSetBool("soldierTitleText.rankIcon.promote", "_visible", false);
		}
		else
		{
			RankString = Caps(Unit.IsSoldier() ? Unit.GetSoldierRankName() : "");
			RankString $= "    /     ";
		}
		RankString $= Caps(SquadState.GetSquadName());
		Header.MC.ChildSetString("soldierTitleText.rankIcon.textField", "text", RankString);
	}

}

function RollAWCAbilitiesIfNeeded(UIScreen Screen)
{
	/* WOTC TODO: Requires progress on AWC/training center abilities
	local UIArmory Armory;
	local UISoldierHeader Header;
	local XComGameState_Unit Unit, UpdatedUnit;
	local XComGameState_Unit_AWC_LW AWCState;
	local XComGameState NewGameState;
	local name SoldierClassName;

	Armory = UIArmory(Screen);
	if (Armory == none) { return; }

	Header = Armory.Header;
	if (Header == none) { return; }

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Header.UnitRef.ObjectID));
	if (Unit == none) { return; }
	SoldierClassName = Unit.GetSoldierClassTemplateName();
	if (SoldierClassName == class'X2SoldierClassTemplateManager'.default.DefaultSoldierClass) { return; }

	if (Unit.GetRank() > 0 && class'LWAWCUtilities'.default.ClassCannotGetAWCTraining.Find(SoldierClassName) == -1 && class'LWAWCUtilities'.static.GetAWCComponent(Unit) == none)
	{
		//Create the AWC Component and fill out the randomized ability progression
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("AWC State Create/Init");
		UpdatedUnit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', Unit.ObjectID));
		NewGameState.AddStateObject(UpdatedUnit);
		AWCState = XComGameState_Unit_AWC_LW(NewGameState.CreateStateObject(class'XComGameState_Unit_AWC_LW'));
		NewGameState.AddStateObject(AWCState);

		UpdatedUnit.AddComponentObject(AWCState);
		AWCState.ChooseSoldierAWCOptions(UpdatedUnit);

		`GAMERULES.SubmitGameState(NewGameState);
	}
	*/
}


defaultproperties
{
	// Leaving this assigned to none will cause every screen to trigger its signals on this class
	ScreenClass = none;
}
