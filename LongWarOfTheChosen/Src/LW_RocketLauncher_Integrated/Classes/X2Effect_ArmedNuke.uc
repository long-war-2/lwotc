class X2Effect_ArmedNuke extends X2Effect_Persistent dependson(X2Condition_RocketArmedCheck);

var bool bGiveRocket;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit	SourceUnit, TargetUnit;
	local XComGameState_Effect	SourceEffectState;
	local EArmedRocketStatus	RocketStatus;

	// If we're giving a Nuke
	if (bGiveRocket)
	{
		SourceUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
		TargetUnit = XComGameState_Unit(kNewTargetState);
	
		if (TargetUnit != none && SourceUnit != none)
		{
			RocketStatus = class'X2Condition_RocketArmedCheck'.static.GetRocketArmedStatus(SourceUnit, ApplyEffectParameters.ItemStateObjectRef.ObjectID);
			SourceEffectState = SourceUnit.GetUnitAffectedByEffectState(EffectName);

			////`LOG("Giving Nuke, found effect state: " @ SourceEffectState != none @ "rocket status: " @ RocketStatus,, 'IRIROCK');

			//	And this nuke is armed
			if (SourceEffectState != none && RocketStatus > eRocketArmed_DoesNotRequireArming)
			{
				//	Apply the new effect to the target
				super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);

				//	Adjust the duration of the new effect on target based on the duration of the same effect on the soldier that is Giving this rocket.
				NewEffectState.iTurnsRemaining = SourceEffectState.iTurnsRemaining;

				//	cleanse the effect from the original soldier
				//	-- doesn't seem to be working?
				//SourceEffectState = XComGameState_Effect(NewGameState.ModifyStateObject(class'XComGameState_Effect', SourceEffectState.ObjectID));
				//SourceEffectState.RemoveEffect(NewGameState, NewGameState, true);

				//	Disarm the nuke on the original soldier.
				//	Done in Give Rocket instead
				//SourceUnit.ClearUnitValue(class'X2Effect_ArmRocket'.default.UnitValueName);
				//SourceUnit.ClearUnitValue(class'X2Effect_ArmRocket'.default.ArmedThisTurnUnitValueName);
			}
			else
			{
				//	Remove the effect right away if the Nuke we gave was not Armed.
				NewEffectState.RemoveEffect(NewGameState, NewGameState, true);
			}
		}
	}
	else	//	We're not Giving a Nuke, so we're just Arming one. Apply effect as normal.
	{
		super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
	}
}

/*

{
	local XComGameState_Unit	SourceUnit, TargetUnit;
	local XComGameState_Effect	SourceEffectState, NewEffectState;
	local name					AvailableCode;
	local EArmedRocketStatus	RocketStatus;

	//`LOG("ApplyEffectNative for X2Effect_ArmedNuke",, 'IRINUKE');
	
	//	If this effect would be applied by a rocket that is not a Nuke, then we don't apply the effect at all.
	if (class'X2Rocket_Nuke'.static.IsNuke(ApplyEffectParameters.ItemStateObjectRef.ObjectID))
	{
		//`LOG("Source rocket is a nuke.",, 'IRINUKE');
		// If we're giving a Nuke
		if (bGiveRocket)
		{
			//`LOG("We're giving it.",, 'IRINUKE');
			SourceUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
			TargetUnit = XComGameState_Unit(kNewTargetState);
	
			if (TargetUnit != none && SourceUnit != none)
			{
				RocketStatus = class'X2Condition_RocketArmedCheck'.static.GetRocketArmedStatus(SourceUnit, ApplyEffectParameters.ItemStateObjectRef.ObjectID);

				SourceEffectState = SourceUnit.GetUnitAffectedByEffectState(EffectName);

				//	And this nuke is armed
				if (SourceEffectState != none && RocketStatus > eRocketArmed_DoesNotRequireArming)
				{
					//	Apply the new effect to the target
					AvailableCode = ApplyEffect(ApplyEffectParameters, kNewTargetState, NewGameState);

					if (AvailableCode == 'AA_Success')
					{
						//`LOG("Transferring Armed Nuke effect, duration: " @ SourceEffectState.iTurnsRemaining,, 'IRIROCK');

						//	modify duration on the new effect
						NewEffectState = TargetUnit.GetUnitAffectedByEffectState(EffectName);
						NewEffectState = XComGameState_Effect(NewGameState.ModifyStateObject(class'XComGameState_Effect', NewEffectState.ObjectID));
						NewEffectState.iTurnsRemaining = SourceEffectState.iTurnsRemaining;
					}
				}
			}
		}	//	if we're not Giving a Nuke, then we're just Arming one, so apply effect as usual.
		else 
		{	
			//`LOG("We're arming it.",, 'IRINUKE');
			return ApplyEffect(ApplyEffectParameters, kNewTargetState, NewGameState);
		}
	}
	else return 'AA_EffectChanceFailed';
}
*/
static function NukeArmed_Visualization_Added(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local XComGameState_Effect	EffectState;
	local XComGameState_Unit	UnitState;
	local int					iDuration;
	local string				FlyoverMessage;

	if (EffectApplyResult == 'AA_Success')
	{
		//	Show the number of turns until detonation
		UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);
		FlyoverMessage = class'X2Rocket_Nuke'.default.str_NukeIsArmed;
		if (UnitState != none)
		{	
			EffectState = UnitState.GetUnitAffectedByEffectState('IRI_Nuke_Armed_Effect');
			if (EffectState != none)
			{
				iDuration = EffectState.iTurnsRemaining;
				iDuration++;
				FlyoverMessage = FlyoverMessage $ ": " $ iDuration;
			}
		}

		class'X2StatusEffects'.static.AddEffectCameraPanToAffectedUnitToTrack(ActionMetadata, VisualizeGameState.GetContext());
		class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(ActionMetadata, VisualizeGameState.GetContext(), FlyoverMessage, '', eColor_Good, class'UIUtilities_Image'.const.UnitStatus_BleedingOut);
		class'X2StatusEffects'.static.AddEffectMessageToTrack(
			ActionMetadata,
			FlyoverMessage,
			VisualizeGameState.GetContext(),
			FlyoverMessage,
			"img:///UILibrary_XPACK_Common.UIPerk_bleeding",
			eUIState_Normal);
		class'X2StatusEffects'.static.UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
	}
}

static function NukeArmed_Visualization_Ticked(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local XComGameState_Effect	EffectState;
	local XComGameState_Unit	UnitState;
	local int					iDuration;
	local string				FlyoverMessage;
	local X2Action_PlayWeaponAnimation PlayWeaponAnimation;

	//	Show the number of turns until detonation
	UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);
	FlyoverMessage = class'X2Rocket_Nuke'.default.str_NukeIsArmed;
	if (UnitState != none)
	{	
		EffectState = UnitState.GetUnitAffectedByEffectState('IRI_Nuke_Armed_Effect');
		if (EffectState != none)
		{
			iDuration = EffectState.iTurnsRemaining;
			FlyoverMessage = FlyoverMessage $ ": " $ iDuration;
		}
	}

	class'X2StatusEffects'.static.AddEffectCameraPanToAffectedUnitToTrack(ActionMetadata, VisualizeGameState.GetContext());
	class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(ActionMetadata, VisualizeGameState.GetContext(), FlyoverMessage, '', eColor_Bad, class'UIUtilities_Image'.const.UnitStatus_BleedingOut);
	class'X2StatusEffects'.static.AddEffectMessageToTrack(
		ActionMetadata,
		FlyoverMessage,
		VisualizeGameState.GetContext(),
		FlyoverMessage,
		"img:///UILibrary_XPACK_Common.UIPerk_bleeding",
		eUIState_Normal);
	class'X2StatusEffects'.static.UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());

	PlayWeaponAnimation = X2Action_PlayWeaponAnimation(class'X2Action_PlayWeaponAnimation'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext()));
	PlayWeaponAnimation.AnimName = name('ArmRocket_' $ iDuration);
}

simulated function NukeArmed_Visualization_Removed(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local X2Action_PlayWeaponAnimation PlayWeaponAnimation;

	class'X2StatusEffects'.static.AddEffectCameraPanToAffectedUnitToTrack(ActionMetadata, VisualizeGameState.GetContext());
	class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(ActionMetadata, VisualizeGameState.GetContext(), class'X2Rocket_Nuke'.default.str_NukeDetonationImminent, '', eColor_Bad, class'UIUtilities_Image'.const.UnitStatus_BleedingOut);
	class'X2StatusEffects'.static.AddEffectMessageToTrack(
		ActionMetadata,
		class'X2Rocket_Nuke'.default.str_NukeDetonationImminent,
		VisualizeGameState.GetContext(),
		class'X2Rocket_Nuke'.default.str_NukeDetonationImminent,
		"img:///UILibrary_XPACK_Common.UIPerk_bleeding",
		eUIState_Bad);
	class'X2StatusEffects'.static.UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());

	PlayWeaponAnimation = X2Action_PlayWeaponAnimation(class'X2Action_PlayWeaponAnimation'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext()));
	PlayWeaponAnimation.AnimName = 'ArmRocket_1';
}

//	Play nothing if the effect is cleansed, which happens if the rocket is fired or given away.
simulated function NukeArmed_Visualization_Cleansed(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	//	Do nothing. This function is necessary, if it's not set explicitly, the gamme will default to NukeArmed_Visualization_Removed
}

defaultproperties
{
	bTickWhenApplied = false
	EffectName = "IRI_Nuke_Armed_Effect"
	VisualizationFn = NukeArmed_Visualization_Added
	EffectTickedVisualizationFn = NukeArmed_Visualization_Ticked
	EffectRemovedVisualizationFn = NukeArmed_Visualization_Removed
	CleansedVisualizationFn = NukeArmed_Visualization_Cleansed
	DuplicateResponse = eDupe_Ignore
	bInfiniteDuration = false;
	bRemoveWhenSourceDies = false;
	bIgnorePlayerCheckOnTick = false;	
	WatchRule = eGameRule_PlayerTurnBegin
}