//---------------------------------------------------------------------------------------
//  FILE:    X2AbilityTarget_Single_CCS
//  AUTHOR:  John Lumpkin / Amineri (Pavonis Interactive)
//  PURPOSE: Custom Single Target class to limit range of CCS reaction fire
//--------------------------------------------------------------------------------------- 

class X2AbilityTarget_Single_CCS extends X2AbilityTarget_Single config (LW_SoldierSkills);

var config int CCS_RANGE;
var config bool CCS_PROC_ON_OWN_TURN;

simulated function name GetPrimaryTargetOptions(const XComGameState_Ability Ability, out array<AvailableTarget> Targets)
{
	local XComGameState_Unit	CCS_ShooterUnit, TargetUnit;
	local int					i;
	local name					Code;
		
	Code = super.GetPrimaryTargetOptions(Ability,Targets);
	CCS_ShooterUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Ability.OwnerStateObject.ObjectID));

	for (i = Targets.Length - 1; i >= 0; --i)
	{
		TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Targets[i].PrimaryTarget.ObjectID));
		if (CCS_ShooterUnit.TileDistanceBetween(TargetUnit) > default.CCS_RANGE)
		{
			Targets.Remove(i,1);
		}								
	}	
	if ((Code == 'AA_Success') && (Targets.Length < 1))
	{
		return 'AA_NoTargets';
	}	
	return code;
}

simulated function bool ValidatePrimaryTargetOption(const XComGameState_Ability Ability, XComGameState_Unit SourceUnit, XComGameState_BaseObject TargetObject)
{
	local bool					b_valid;
	local XComGameState_Unit	TargetUnit;

	b_valid = Super.ValidatePrimaryTargetOption(Ability, SourceUnit, TargetObject);
	TargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(TargetObject.ObjectID));
	if (TargetUnit == none)
		return false;
	if (b_valid)
	{
		//`LOG ("CCS Target" @ TargetUnit.GetMyTemplateName() @ "TDB:" @ string(SourceUnit.TileDistanceBetween(TargetUnit)));
		if (SourceUnit.TileDistanceBetween(TargetUnit) > default.CCS_RANGE)
		{
			//`LOG ("NO SHOT! CCS Target TDB:" @ string(SourceUnit.TileDistanceBetween(TargetUnit)));
			return false;
		}
		if(!default.CCS_PROC_ON_OWN_TURN && X2TacticalGameRuleset(XComGameInfo(class'Engine'.static.GetCurrentWorldInfo().Game).GameRuleset).GetCachedUnitActionPlayerRef().ObjectID == SourceUnit.ControllingPlayer.ObjectID)
		{
			return false;
		}
	}
	return b_valid;
}

