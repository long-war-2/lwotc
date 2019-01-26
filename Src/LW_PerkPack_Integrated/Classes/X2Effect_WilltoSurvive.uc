//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_WilltoSurvive
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up bonus armor from W2S
//--------------------------------------------------------------------------------------- 

class X2Effect_WilltoSurvive extends X2Effect_BonusArmor config (LW_SoldierSkills);

var config int W2S_HIGH_COVER_ARMOR_BONUS;
var config int W2S_LOW_COVER_ARMOR_BONUS;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	local XComGameState_Unit					Target;
	local GameRulesCache_VisibilityInfo			MyVisInfo;
	local array<GameRulesCache_VisibilityInfo>	VisInfoArray;
	local X2AbilityToHitCalc_StandardAim		StandardHit;
	local XComGameStateContext_Ability			AbilityContext;
	local Vector								SourceLocation;
	local int									k;
	local XComGameStateHistory					History;	
	local X2AbilityTarget_Cursor				TargetStyle;
	local X2AbilityMultiTarget_Radius			MultiTargetStyle;

	Target = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	if (Target.IsImpaired(false) || Target.IsBurning() || Target.IsPanicked())
		return 0;

	StandardHit = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);	
	TargetStyle = X2AbilityTarget_Cursor(AbilityState.GetMyTemplate().AbilityTargetStyle);
	MultiTargetStyle = X2AbilityMultiTarget_Radius(AbilityState.GetMyTemplate().AbilityMultiTargetStyle);
	AbilityContext=class'XComGameStateContext_Ability'.static.BuildContextFromAbility(AbilityState, EffectState.ApplyEffectParameters.TargetStateObjectRef.ObjectID);
	if((StandardHit != none && StandardHit.bIndirectFire) || (TargetStyle != none && MultiTargetStyle != none))
	{
		History = `XCOMHISTORY;
		SourceLocation = AbilityContext.InputContext.ProjectileTouchEnd;				
		class'X2TacticalVisibilityHelpers'.static.GetAllVisibleEnemiesForLocation(SourceLocation, Attacker.ControllingPlayer.ObjectID, VisInfoArray, true);
		for( k = 0; k < VisInfoArray.Length; ++k )
		{
			if (XComGameState_Unit(History.GetGameStateForObjectID(VisInfoArray[k].SourceID,,-1)) == Target)
			{
				MyVisInfo = VisInfoArray[k];	
				break;
			}
		}
		if (MyVisInfo.TargetCover == CT_None)
			return 0;
		if (MyVisInfo.TargetCover == CT_Midlevel)
			return -W2S_LOW_COVER_ARMOR_BONUS;
		if (MyVisInfo.TargetCover == CT_Standing)
			return -W2S_HIGH_COVER_ARMOR_BONUS;
	}
	else
	{
		if(X2TacticalGameRuleset(XComGameInfo(class'Engine'.static.GetCurrentWorldInfo().Game).GameRuleset).VisibilityMgr.GetVisibilityInfo(Attacker.ObjectID, Target.ObjectID, MyVisInfo))
		{
			if (MyVisInfo.TargetCover == CT_None) 
				return 0;
			if (MyVisInfo.TargetCover == CT_Midlevel)
				return -W2S_LOW_COVER_ARMOR_BONUS;
			if (MyVisInfo.TargetCover == CT_Standing)
				return -W2S_HIGH_COVER_ARMOR_BONUS;				
		}
	}
    return 0;     
}
