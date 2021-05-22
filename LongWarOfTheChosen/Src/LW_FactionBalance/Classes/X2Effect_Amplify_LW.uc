//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_Amplify_LW.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: Updates the Amplify effect so that it's removed immediately after a single attack.
//---------------------------------------------------------------------------------------
class X2Effect_Amplify_LW extends X2Effect_Amplify;

function float GetPostDefaultDefendingDamageModifier_CH
(XComGameState_Effect EffectState,
 XComGameState_Unit SourceUnit,
  XComGameState_Unit TargetUnit,
   XComGameState_Ability AbilityState,
    const out EffectAppliedData ApplyEffectParameters,
	 float WeaponDamage, XComGameState NewGameState)
{
	local XComGameState_Effect_Amplify_LW AmplifyState;
	local float DamageMod;

	if (ApplyEffectParameters.AbilityInputContext.PrimaryTarget.ObjectID > 0 && class'XComGameStateContext_Ability'.static.IsHitResultHit(ApplyEffectParameters.AbilityResultContext.HitResult) && WeaponDamage != 0)
	{
		DamageMod = BonusDamageMult * WeaponDamage;
		if (DamageMod < MinBonusDamage)
			DamageMod = MinBonusDamage;

		//	if NewGameState was passed in, we are really applying damage, so update our counter or remove the effect if it's worn off
		if (NewGameState != none)
		{
			AmplifyState = XComGameState_Effect_Amplify_LW(EffectState);
			`assert(AmplifyState != none);
			if (AmplifyState.ShotsRemaining == 1)
			{
				AmplifyState.RemoveEffect(NewGameState, NewGameState);
			}
			else
			{
				AmplifyState = XComGameState_Effect_Amplify_LW(NewGameState.ModifyStateObject(AmplifyState.Class, AmplifyState.ObjectID));
				AmplifyState.ShotsRemaining -= 1;
			}
			NewGameState.GetContext().PostBuildVisualizationFn.AddItem(AmplifyDecrement_PostBuildVisualization);
		}
	}
	return DamageMod;
}

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	return 0;
}

static function AmplifyDecrement_PostBuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameState_Effect_Amplify_LW AmplifyState;
	local string FlyoverString;
	local VisualizationActionMetadata BuildTrack;
	local XComGameStateHistory History;
	local X2Action_PlaySoundAndFlyOver FlyOverAction;

	History = `XCOMHISTORY;
	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Effect_Amplify_LW', AmplifyState)
	{
		if (AmplifyState.bRemoved)
		{
			FlyoverString = default.AmplifyRemoved;
		}
		else
		{
			FlyoverString = repl(default.AmplifyCountdown, "%d", AmplifyState.ShotsRemaining);
		}
		BuildTrack.VisualizeActor = History.GetVisualizer(AmplifyState.ApplyEffectParameters.TargetStateObjectRef.ObjectID);
		History.GetCurrentAndPreviousGameStatesForObjectID(AmplifyState.ApplyEffectParameters.TargetStateObjectRef.ObjectID, BuildTrack.StateObject_OldState, BuildTrack.StateObject_NewState, , VisualizeGameState.HistoryIndex);
		if (BuildTrack.StateObject_NewState == none)
			BuildTrack.StateObject_NewState = BuildTrack.StateObject_OldState;
		else if (BuildTrack.StateObject_OldState == none)
			BuildTrack.StateObject_OldState = BuildTrack.StateObject_NewState;

		FlyOverAction = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext()));
		FlyOverAction.SetSoundAndFlyOverParameters(None, FlyoverString, '', eColor_Bad, "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Amplify");

		//	the effect is not removed through a normal effect removed context, so we need to visualize it here
		if (AmplifyState.bRemoved)
			AmplifyState.GetX2Effect().AddX2ActionsForVisualization_Removed(VisualizeGameState, BuildTrack, 'AA_Success', AmplifyState);

		break;
	}
}

DefaultProperties
{
	GameStateEffectClass = class'XComGameState_Effect_Amplify_LW'

}