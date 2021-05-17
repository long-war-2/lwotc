//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_Effect_Amplify.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: Makes the amplify effect have a flat amount of ticks
//---------------------------------------------------------------------------------------
class XComGameState_Effect_Amplify_LW extends XComGameState_Effect;

var int ShotsRemaining;

function PostCreateInit(EffectAppliedData InApplyEffectParameters, GameRuleStateChange WatchRule, XComGameState NewGameState)
{
	local XComGameState_Unit SourceUnit;

	super.PostCreateInit(InApplyEffectParameters, WatchRule, NewGameState);

	SourceUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(InApplyEffectParameters.SourceStateObjectRef.ObjectID));
	if (SourceUnit == none)
		SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(InApplyEffectParameters.SourceStateObjectRef.ObjectID));
	`assert(SourceUnit != none);

	ShotsRemaining = class'X2Ability_TemplarAbilitySet_LW'.default.AMPLIFY_SHOTS;
}