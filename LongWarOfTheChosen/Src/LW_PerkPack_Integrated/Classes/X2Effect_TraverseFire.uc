class X2Effect_TraverseFire extends X2Effect_Persistent config (LW_SoldierSkills);

var config int TF_USES_PER_TURN;
var config array<name> TF_ABILITYNAMES;
var name CounterName;
var name EventName;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local XComGameState_Unit		UnitState;
	local Object					EffectObj;

	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	`XEVENTMGR.RegisterForEvent(EffectObj, EventName, EffectGameState.TriggerAbilityFlyover, ELD_OnStateSubmitted, 40, UnitState);
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local XComGameState_Ability					AbilityState;
	local int									iCounter;
	local UnitValue								UnitValue;

	if (SourceUnit.IsUnitAffectedByEffectName(class'X2Effect_Serial'.default.EffectName))
		return false;

	if (class'Helpers_LW'.static.IsUnitInterruptingEnemyTurn(SourceUnit))
		return false;

	SourceUnit.GetUnitValue(CounterName, UnitValue);
	iCounter = int(UnitValue.fValue);

	if (iCounter >= default.TF_USES_PER_TURN)
		return false;

	AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));

    if (AbilityState != none)
    {
        if (default.TF_ABILITYNAMES.Find(kAbility.GetMyTemplateName()) != -1)
        {
			if (kAbility.SourceWeapon != EffectState.ApplyEffectParameters.ItemStateObjectRef)
				return false;

			SourceUnit.SetUnitFloatValue(CounterName, iCounter + 1.0, eCleanup_BeginTurn);
			SourceUnit.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.RunAndGunActionPoint);
			`XEVENTMGR.TriggerEvent(EventName, AbilityState, SourceUnit, NewGameState);
		}
		else
		{
			if (kAbility.IsAbilityInputTriggered()) {
				if (kAbility.GetMyTemplate().Hostility == eHostility_Offensive || PreCostActionPoints.Length - SourceUnit.ActionPoints.Length > 0) {
					SourceUnit.SetUnitFloatValue(CounterName, iCounter + 1.0, eCleanup_BeginTurn);
				}
			}
		}
    }
	return false;
}

defaultproperties
{
	DuplicateResponse = eDupe_Ignore
	EffectName = "LW_TraverseFire"
    CounterName = LW_TraverseFire
	EventName = LW_TraverseFire
}
