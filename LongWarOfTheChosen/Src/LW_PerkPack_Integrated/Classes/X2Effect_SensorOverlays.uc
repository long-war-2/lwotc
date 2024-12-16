class X2Effect_SensorOverlays extends XMBEffect_ConditionalBonus;

function protected name ValidateAttack(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, bool bAsTarget = false)
{
	local GameRulesCache_VisibilityInfo VisInfo;

	if (!`TACTICALRULES.VisibilityMgr.GetVisibilityInfo(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID, Target.ObjectID, VisInfo))
		return 'AA_NotInRange';
	if (!VisInfo.bVisibleGameplay)
		return 'AA_NotInRange';

	return 'AA_Success';
}

function ModifyUISummaryUnitStats(XComGameState_Effect EffectState, XComGameState_Unit UnitState, const ECharStatType Stat, out int StatValue)
{
	return;
}
