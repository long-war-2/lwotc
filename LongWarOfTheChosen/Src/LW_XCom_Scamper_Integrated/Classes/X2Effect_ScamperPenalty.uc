class X2Effect_ScamperPenalty extends X2Effect_PersistentStatChange config(Scamper);

var config bool EnableScamperPenalty;
var config float MobilityMultipler;

var localized string FriendlyEffectName;
var localized string FriendlyEffectDescription;
var localized string RemovedFlyoutText;

event X2Effect_Persistent GetPersistantTemplate()
{
	local X2Effect_ScamperPenalty Effect;

	// Most of options are defined in defaultproperties, here only the config/loc stuff is copied over
	Effect = new class'X2Effect_ScamperPenalty';
	Effect.AddPersistentStatChange(eStat_Mobility, MobilityMultipler, MODOP_Multiplication);
	Effect.FriendlyName = FriendlyEffectName;
	Effect.FriendlyDescription = FriendlyEffectDescription;

	return Effect;
}

static function VisualizeEffectRemoved(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local X2Action_CameraLookAt LookAtAction;
	local X2Action_UpdateUI UIUpdate;
	local XComGameState_Unit Unit;
	local X2Action_Delay Delay;
	
	Unit = XComGameState_Unit(ActionMetadata.StateObject_NewState);

	if (!Unit.IsAbleToAct())
	{
		// RIP
		return;
	}

	LookAtAction = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext()));
	LookAtAction.LookAtObject = ActionMetadata.StateObject_NewState;
	LookAtAction.UseTether = true;
	LookAtAction.LookAtDuration = 0.2f;
	LookAtAction.BlockUntilFinished = true;

	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(),, LookAtAction));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(none, default.RemovedFlyoutText, '', eColor_Good,, 0.4, true);

	// Do not show the change instantly, but wait for flyout to animate in
	Delay = X2Action_Delay(class'X2Action_Delay'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(),, LookAtAction));
	Delay.Duration = 0.2;
	Delay.bIgnoreZipMode = true;

	UIUpdate = X2Action_UpdateUI(class'X2Action_UpdateUI'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(),, Delay));
	UIUpdate.UpdateType = EUIUT_UnitFlag_Buffs;
	UIUpdate.SpecificID = ActionMetadata.StateObject_NewState.ObjectID;
}

defaultproperties
{
	EffectName = "XComScamperPenalty"
	DuplicateResponse = eDupe_Refresh
	EffectRemovedVisualizationFn = VisualizeEffectRemoved;

	// Duration
	iNumTurns = 1
	bInfiniteDuration = false
	bRemoveWhenSourceDies = false // No source really
	bIgnorePlayerCheckOnTick = false
	WatchRule = eGameRule_PlayerTurnEnd // Allow full mobility during enemies' turn

	// UI
	BuffCategory = ePerkBuff_Penalty
	IconImage = "UILibrary_XPACK_Common.PerkIcons.weak_achilles"
	bDisplayInUI = true
}