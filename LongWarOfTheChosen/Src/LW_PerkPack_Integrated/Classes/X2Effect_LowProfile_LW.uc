//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_LowProfile_LW
//  AUTHOR:  John Lumpkin (Pavonis Interactive) / Firaxis
//  PURPOSE: Copies some of, and then finishes, implementation of Low Profile perk
//--------------------------------------------------------------------------------------- 

class X2Effect_LowProfile_LW extends X2Effect_Persistent;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit UnitState;

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);

	UnitState = XComGameState_Unit(kNewTargetState);
	if (UnitState != none)
	{
		UnitState.bTreatLowCoverAsHigh = true;
	}
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameState_Unit UnitState;

	super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	if (UnitState != none)
	{
		UnitState = XComGameState_Unit(NewGameState.CreateStateObject(UnitState.Class, UnitState.ObjectID));
		UnitState.bTreatLowCoverAsHigh = false;
		NewGameState.AddStateObject(UnitState);
	}
}

function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local GameRulesCache_VisibilityInfo			VisInfo;
    local ShotModifierInfo						ShotInfo;

	if (Target != none)
	{
		if(X2TacticalGameRuleset(XComGameInfo(class'Engine'.static.GetCurrentWorldInfo().Game).GameRuleset).VisibilityMgr.GetVisibilityInfo(Attacker.ObjectID, Target.ObjectID, VisInfo))
		{
			if (Target.CanTakeCover() && Target.bTreatLowCoverasHigh && VisInfo.TargetCover == CT_Midlevel)
			{
				ShotInfo.ModType = eHit_Success;
				ShotInfo.Reason = FriendlyName;
				ShotInfo.Value = -1 * (class'X2AbilityToHitCalc_StandardAim'.default.HIGH_COVER_BONUS - class'X2AbilityToHitCalc_StandardAim'.default.LOW_COVER_BONUS);
				ShotModifiers.AddItem(ShotInfo);
			}
		}
	}
}

