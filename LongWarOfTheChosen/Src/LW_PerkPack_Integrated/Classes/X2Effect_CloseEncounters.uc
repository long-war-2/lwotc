//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_CloseEncounters
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Grants action under certain conditions
//--------------------------------------------------------------------------------------- 

class X2Effect_CloseEncounters extends X2Effect_Persistent;

var name TriggerEventName;
var name UsesCounterName;
var int MaxUsesPerTurn;
var int MaxTiles;
var array<name> ApplicableAbilities;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager			EventMgr;
	local XComGameState_Unit		UnitState;
	local Object					EffectObj;

	EventMgr = `XEVENTMGR;
	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	EventMgr.RegisterForEvent(EffectObj, TriggerEventName, EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted, , UnitState);
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local XComGameState_Ability					AbilityState;
	local XComGameState_Unit					TargetUnit;
	local UnitValue								CEUsesThisTurn, HnRUsesThisTurn, CheapShotUsesThisTurn;
	local int									iUsesThisTurn;
	
	if (SourceUnit.IsUnitAffectedByEffectName(class'X2Effect_Serial'.default.EffectName))
		return false;

	if (SourceUnit.IsUnitAffectedByEffectName(class'X2Effect_DeathfromAbove'.default.EffectName))
		return false;

	if (PreCostActionPoints.Find('RunAndGun') != -1)
		return false;

	// Don't proc on a Skirmisher interrupt turn (for example with Battle Lord)
	if (class'Helpers_LW'.static.IsUnitInterruptingEnemyTurn(SourceUnit))
		return false;
	
	if (kAbility == none)
		return false;

	if (kAbility.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
		return false;

	SourceUnit.GetUnitValue (UsesCounterName, CEUsesThisTurn);
	iUsesThisTurn = int(CEUsesThisTurn.fValue);

	if (iUsesThisTurn >= MaxUsesPerTurn)
		return false;

	SourceUnit.GetUnitValue (class'X2Effect_HitandRun'.default.HNRUsesName, HnRUsesThisTurn);
	iUsesThisTurn = int(HnRUsesThisTurn.fValue);

	if (iUsesThisTurn >= 1)
		return false;

	SourceUnit.GetUnitValue (class'X2Effect_CheapShot'.default.CheapShotUsesName, CheapShotUsesThisTurn);
	iUsesThisTurn = int(CheapShotUsesThisTurn.fValue);
	if (iUsesThisTurn >= 1)
		return false;

	TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));  	

	if (TargetUnit == none)
		return false;

	//`LOG (string (SourceUnit.TileDistanceBetween(TargetUnit)));
	//`LOG (string (MaxTiles));

	if (SourceUnit.TileDistanceBetween(TargetUnit) > MaxTiles + 1)
		return false;

	//`LOG ("CE7");

	if (XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID)) == none)
		return false;

	//`LOG ("CE8");

	AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));

	if (AbilityState != none)
	{
		if (ApplicableAbilities.Find(kAbility.GetMyTemplateName()) != -1)
		{
			//`LOG ("CE9");
			
			if (SourceUnit.NumActionPoints() < 2 && PreCostActionPoints.Length > 0)
			{
				//`LOG ("CE10");
				SourceUnit.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
				SourceUnit.SetUnitFloatValue (UsesCounterName, iUsesThisTurn + 1.0, eCleanup_BeginTurn);
				//NewGameState.AddStateObject(SourceUnit);
				`XEVENTMGR.TriggerEvent(TriggerEventName, AbilityState, SourceUnit, NewGameState);
			}
		}
	}
	return false;
}

defaultproperties
{
	TriggerEventName = "CloseEncounters"
	UsesCounterName = "CloseEncountersUses"
	MaxUsesPerTurn = 1
	MaxTiles = 4
}
