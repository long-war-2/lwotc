///---------------------------------------------------------------------------------------
//  FILE:    X2Effect_SmartMacrophages
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Implements effect for SmartMacrophages ability -- this allows healing of lowest hp at end of mission
//			similar to SmartMacrophages, but applies only to self, and always works (unless dead), and is independent of Field Surgeon
//--------------------------------------------------------------------------------------- 
//---------------------------------------------------------------------------------------
class X2Effect_SmartMacrophages extends X2Effect_Persistent config(LW_SoldierSkills);

//`include(LW_PerkPack_Integrated\LW_PerkPack.uci)

function UnitEndedTacticalPlay(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
	local XComGameStateHistory		History;
	local XComGameState_Unit		SourceUnitState; 

	History = `XCOMHISTORY;
	SourceUnitState = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	`PPTRACE("Smart Macrophages: TargetUnit=" $ UnitState.GetFullName() $ ", SourceUnit=" $ SourceUnitState.GetFullName());

	if(!SmartMacrophagesEffectIsValidForSource(SourceUnitState)) { return; }

	`PPTRACE("Smart Macrophages: Source Unit Valid.");

	if(UnitState == none) { return; }
	if(UnitState.IsDead()) { return; }
	if(UnitState.IsBleedingOut()) { return; }
	if(!CanBeHealed(UnitState)) { return; }

	`PPTRACE("Smart Macrophages: Target Unit Can Be Healed.");

	`PPTRACE("Smart Macrophages : Pre update LowestHP=" $ UnitState.LowestHP);
	UnitState.LowestHP += 1;
	`PPTRACE("Smart Macrophages : Post update LowestHP=" $ UnitState.LowestHP);
	UnitState.ModifyCurrentStat(eStat_HP, 1);

	super.UnitEndedTacticalPlay(EffectState, UnitState);
}

function bool CanBeHealed(XComGameState_Unit UnitState)
{
	 return (UnitState.LowestHP < UnitState.GetMaxStat(eStat_HP) && UnitState.LowestHP > 0);
}

function bool SmartMacrophagesEffectIsValidForSource(XComGameState_Unit SourceUnit)
{
	if(SourceUnit == none) { return false; }
	if(SourceUnit.IsDead()) { return false; }
	if(SourceUnit.bCaptured) { return false; }
	if(SourceUnit.LowestHP == 0) { return false; }
	return true;
}

DefaultProperties
{
	EffectName="SmartMacrophages"
	DuplicateResponse=eDupe_Ignore
}