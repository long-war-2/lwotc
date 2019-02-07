//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_CloseEncounters
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Grants action under certain conditions
//--------------------------------------------------------------------------------------- 

class X2Effect_CloseEncounters extends X2Effect_Persistent config (LW_SoldierSkills);

var config int CE_USES_PER_TURN;
var config array<name> CE_ABILITYNAMES;
var config int CE_MAX_TILES;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager			EventMgr;
	local XComGameState_Unit		UnitState;
	local Object					EffectObj;

	EventMgr = `XEVENTMGR;
	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	EventMgr.RegisterForEvent(EffectObj, 'CloseEncounters', EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted, , UnitState);
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local XComGameState_Ability					AbilityState;
	local XComGameState_Unit					TargetUnit;
	local UnitValue								CEUsesThisTurn;
	local int									iUsesThisTurn;
	
	if (SourceUnit.IsUnitAffectedByEffectName(class'X2Effect_Serial'.default.EffectName))
		return false;

	if (SourceUnit.IsUnitAffectedByEffectName(class'X2Effect_DeathfromAbove'.default.EffectName))
		return false;

	if (PreCostActionPoints.Find('RunAndGun') != -1)
		return false;

	if (kAbility == none)
		return false;

	if (kAbility.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
		return false;

	SourceUnit.GetUnitValue ('CloseEncountersUses', CEUsesThisTurn);
	iUsesThisTurn = int(CEUsesThisTurn.fValue);

	if (iUsesThisTurn >= default.CE_USES_PER_TURN)
		return false;

	TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));  	

	if (TargetUnit == none)
		return false;

	//`LOG (string (SourceUnit.TileDistanceBetween(TargetUnit)));
	//`LOG (string (default.CE_MAX_TILES));

	if (SourceUnit.TileDistanceBetween(TargetUnit) > default.CE_MAX_TILES + 1)
		return false;

	//`LOG ("CE7");

	if (XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID)) == none)
		return false;

	//`LOG ("CE8");

	AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));

	if (AbilityState != none)
	{
		if (default.CE_ABILITYNAMES.Find(kAbility.GetMyTemplateName()) != -1)
		{
			//`LOG ("CE9");
			
			if (SourceUnit.NumActionPoints() < 2 && PreCostActionPoints.Length > 0)
			{
				//`LOG ("CE10");
				SourceUnit.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
				SourceUnit.SetUnitFloatValue ('CloseEncountersUses', iUsesThisTurn + 1.0, eCleanup_BeginTurn);
				//NewGameState.AddStateObject(SourceUnit);
				`XEVENTMGR.TriggerEvent('CloseEncounters', AbilityState, SourceUnit, NewGameState);
			}
		}
	}
	return false;
}