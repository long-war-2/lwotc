//---------------------------------------------------------------------------------------
//  FILE:    SeqAct_ResetCivilians.uc
//  AUTHOR:  tracktwo / LWS
//  PURPOSE: Resets any civilian units (alive or dead!) to the neutral team. The retaliation
//           mission must perform this before ending the mission to ensure the mission summary
//           statistics correctly count the number of civilians as this is done by team, not template.
//---------------------------------------------------------------------------------------

class SeqAct_ResetCivilians extends SequenceAction config(LW_Overhaul);

var config array<Name> CharacterTemplatesToSwap;

event Activated()
{
	local XComGameState_Unit Unit;
	local XComGameStateHistory History;
	local XGBattle Battle;

	History = `XCOMHISTORY;
	Battle = `BATTLE;

	foreach History.IterateByClassType(class'XComGameState_Unit', Unit)
	{
		if (Unit.GetTeam() == eTeam_XCom && 
				CharacterTemplatesToSwap.Find(Unit.GetMyTemplateName()) >= 0)
		{
			Battle.SwapTeams(Unit, eTeam_Neutral);
		}
	}
}

defaultproperties
{
	ObjName="Reset Rebels to Neutral Team"

	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	VariableLinks.Empty
}
