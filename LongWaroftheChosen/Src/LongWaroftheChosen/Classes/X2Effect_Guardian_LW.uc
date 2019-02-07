class X2Effect_Guardian_LW extends X2Effect_Guardian;

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local X2EventManager EventMgr;
	local XComGameState_Ability AbilityState;       //  used for looking up our source ability (Guardian), not the incoming one that was activated
	local int RandRoll;
	local XComGameState_Unit TargetUnit;
	local name ValueName;

	if (SourceUnit.ReserveActionPoints.Length != PreCostReservePoints.Length && AbilityContext.IsResultContextHit() && AllowedAbilities.Find(kAbility.GetMyTemplate().DataName) != INDEX_NONE)
	{
		AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
		if (AbilityState != none)
		{
			RandRoll = `SYNC_RAND(100);
			if (RandRoll < ProcChance)
			{
				`COMBATLOG("Guardian Effect rolled" @ RandRoll @ " - bonus Overwatch!");
				SourceUnit.ReserveActionPoints = PreCostReservePoints;

				EventMgr = `XEVENTMGR;
				EventMgr.TriggerEvent('GuardianTriggered', AbilityState, SourceUnit, NewGameState);

				TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
				ValueName = name("OverwatchShot" $ TargetUnit.ObjectID);
				SourceUnit.SetUnitFloatValue (ValueName, 1.0, eCleanup_BeginTurn);

				return true;
			}
			`COMBATLOG("Guardian Effect rolled" @ RandRoll @ " - no bonus shot");
		}
	}
	return false;
}