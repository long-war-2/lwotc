// Author: Tedster
// Brings in LW2's support for multiple VIPs in after action.

class UIInventory_VIPRecovered_LW extends UIInventory_VIPRecovered config(UI);

var array<XComUnitPawn> ActorPawns;
var array<StateObjectReference> RewardUnitRefs;

var config array<int> Vip_X_Offsets;
var config array<int> Vip_Y_Offsets;


simulated function PopulateData()
{
	local bool bDarkVIP;
	local string VIPIcon, StatusLabel;
	local EUIState VIPState;
	local EVIPStatus VIPStatus;
	local XComGameState_Unit Unit;
	local XComGameState_MissionSite Mission;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_HeadquartersResistance ResistanceHQ;
	local XComGameState_BattleData BattleData;
	local StateObjectReference RewardUnitReference;
	local XComGameState NewGameState;
    local int i;

	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
	ResistanceHQ = class'UIUtilities_Strategy'.static.GetResistanceHQ();
	Mission = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(XComHQ.MissionRef.ObjectID));
	BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));

	for(i = 0; i < BattleData.RewardUnits.Length; i++)
		{
			RewardUnitReference = BattleData.RewardUnits[i];
	
		if(RewardUnitReference.ObjectID <= 0)
		{
			`RedScreen("UIInventory_VIPRecovered did not get a valid Unit Reference.");
			return;
		}

		Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(RewardUnitReference.ObjectID));
		VIPStatus = EVIPStatus(Mission.GetRewardVIPStatus(Unit));
		bDarkVIP = Unit.GetMyTemplateName() == 'HostileVIPCivilian';

		if(Unit.IsEngineer() || Unit.GetMyTemplateName() == 'Engineer_VIP')
		{
			VIPIcon = class'UIUtilities_Image'.const.EventQueue_Engineer;
		}
		else if(Unit.IsScientist() || Unit.GetMyTemplateName() == 'Scientist_VIP')
		{
			VIPIcon = class'UIUtilities_Image'.const.EventQueue_Science;
		}
		else if(bDarkVIP)
		{
			VIPIcon = class'UIUtilities_Image'.const.EventQueue_Advent;
		}

		switch(VIPStatus)
		{
		case eVIPStatus_Awarded:
		case eVIPStatus_Recovered:
			VIPState = eUIState_Good;
			if (i == 0 || (i < Vip_X_Offsets.Length && i < Vip_Y_Offsets.Length))
            {
		        CreateVIPPawnLW(Unit, i);
                RewardUnitRefs.AddItem(RewardUnitReference);
            }
		default:
			VIPState = eUIState_Bad;
			break;
		}

		if(bDarkVIP)
			StatusLabel = m_strEnemyVIPStatus[VIPStatus];
		else
			StatusLabel = m_strVIPStatus[VIPStatus];

		AS_UpdateData(class'UIUtilities_Text'.static.GetColoredText(StatusLabel, VIPState), 
			class'UIUtilities_Text'.static.GetColoredText(Unit.GetFullName(), bDarkVIP ? eUIState_Bad : eUIState_Normal),
			VIPIcon, ResistanceHQ.VIPRewardsString);

		if (XComHQ.GetObjectiveStatus('XP0_M6_MoxReturns') == eObjectiveState_InProgress)
		{
				NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Trigger Event: Mox VIP Recovered");
			if (VIPStatus == eVIPStatus_Awarded || VIPStatus == eVIPStatus_Recovered)
			{
				`XEVENTMGR.TriggerEvent('MoxRescuedVIPRecovered', , , NewGameState);
			}		
			`XEVENTMGR.TriggerEvent('MoxRescuedComplete', , , NewGameState);
			`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
		}
	}
}


simulated function CreateVIPPawnLW(XComGameState_Unit Unit, int i)
{
	local PointInSpace PlacementActor;
    local Vector Loc;
    local XComUnitPawn Actor_Pawn;

	// Don't do anything if we don't have a valid UnitReference
	if(Unit == none) return;

	foreach WorldInfo.AllActors(class'PointInSpace', PlacementActor)
	{
		if (PlacementActor != none && PlacementActor.Tag == PawnLocationTag)
			break;
	}

	loc = PlacementActor.Location;
    loc.X += Vip_X_Offsets[i];
    loc.Y += Vip_Y_Offsets[i];

	Actor_Pawn = `HQPRES.GetUIPawnMgr().RequestPawnByState(self, Unit, Loc, PlacementActor.Rotation);
	Actor_Pawn.GotoState('CharacterCustomization');
	Actor_Pawn.EnableFootIK(false);
    ActorPawns.AddItem(Actor_Pawn);

	if (Unit.IsSoldier())
	{
		Actor_Pawn.CreateVisualInventoryAttachments(`HQPRES.GetUIPawnMgr(), Unit);
	}

	if(Unit.UseLargeArmoryScale())
	{
		Actor_Pawn.Mesh.SetScale(class'UIArmory'.default.LargeUnitScale);
	}
}

simulated function Cleanup()
{
	local XComGameState NewGameState;
	local XComGameState_HeadquartersResistance ResistanceHQ;
	local int i;

	if (RewardUnitRefs.Length == 0)
		return;

	for( i = 0; i < RewardUnitRefs.Length; ++i)
        `HQPRES.GetUIPawnMgr().ReleasePawn(self, RewardUnitRefs[i].ObjectID);

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Clear VIP Reward Data");
	ResistanceHQ = class'UIUtilities_Strategy'.static.GetResistanceHQ();
	ResistanceHQ = XComGameState_HeadquartersResistance(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersResistance', ResistanceHQ.ObjectID));
	ResistanceHQ.ClearVIPRewardsData();
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

	RewardUnitRefs.Length = 0;
    ActorPawns.Length = 0;
}