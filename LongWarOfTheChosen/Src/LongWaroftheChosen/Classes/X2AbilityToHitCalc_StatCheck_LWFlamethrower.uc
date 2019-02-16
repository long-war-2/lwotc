//---------------------------------------------------------------------------------------
//  FILE:    X2AbilityToHitCalc_StatCheck_LWFlamethrower.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//	PURPOSE: Stat check (using tech level?) of flamethrower against target stat
//---------------------------------------------------------------------------------------
class X2AbilityToHitCalc_StatCheck_LWFlamethrower extends X2AbilityToHitCalc_StatCheck;

var ECharStatType DefenderStat;

function int GetAttackValue(XComGameState_Ability kAbility, StateObjectReference TargetRef)
{
	local XComGameState_Item SourceItemState;
	local X2MultiWeaponTemplate MultiWeaponTemplate;

	SourceItemState = XComGameState_Item( `XCOMHISTORY.GetGameStateForObjectID( kAbility.SourceWeapon.ObjectID ) );
	MultiWeaponTemplate = X2MultiWeaponTemplate(SourceItemState.GetMyTemplate());
	if(MultiWeaponTemplate != none)
	{
		return MultiWeaponTemplate.iAltStatStrength;
	}
	`REDSCREEN("X2AbilityToHitCalc_StatCheck_LWFlamethrower : no MultiWeaponTemplate defined.");
	return 50;
}

function int GetDefendValue(XComGameState_Ability kAbility, StateObjectReference TargetRef)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(TargetRef.ObjectID));
	return UnitState.GetCurrentStat(DefenderStat);
}

function string GetAttackString() { return ""; } 
function string GetDefendString() { return class'X2TacticalGameRulesetDataStructures'.default.m_aCharStatLabels[DefenderStat]; }

DefaultProperties
{
	DefenderStat = eStat_Will
}