class X2StatusEffects_LW extends Object config(GameCore);

var localized string HeavyDazedFriendlyName;
var localized string HeavyDazedFriendlyDesc;
var localized string HeavyDazedEffectAcquiredString;
var localized string HeavyDazedEffectTickedString;
var localized string HeavyDazedEffectLostString;
var localized string HeavyDazedPerActionFriendlyName;
var localized string HeavyDazedTitle;
var localized name HeavyDazedName;

var localized string MaimedFriendlyName;
var localized string MaimedFriendlyDesc;

var config int HEAVY_DAZED_HIERARCHY_VALUE;
var config string HeavyDazedParticle_Name;
var config name HeavyDazedSocket_Name;
var config name HeavyDazedSocketsArray_Name;

static function X2Effect_HeavyDazed CreateHeavyDazedStatusEffect(int StunLevel, int Chance)
{
	local X2Effect_HeavyDazed DazedEffect;
	local X2Condition_UnitProperty UnitPropCondition;

	DazedEffect = new class'X2Effect_HeavyDazed';
	DazedEffect.BuildPersistentEffect(1, true, true, false, eGameRule_UnitGroupTurnBegin);
	DazedEffect.ApplyChance = Chance;
	DazedEffect.StunLevel = StunLevel;
	DazedEffect.bIsImpairing = true;
	DazedEffect.EffectHierarchyValue = default.HEAVY_DAZED_HIERARCHY_VALUE;
	DazedEffect.EffectName = default.HeavyDazedName;
	DazedEffect.VisualizationFn = DazedVisualization;
	DazedEffect.EffectTickedVisualizationFn = DazedVisualizationTicked;
	DazedEffect.EffectRemovedVisualizationFn = DazedVisualizationRemoved;
	DazedEffect.bRemoveWhenTargetDies = true;
	DazedEffect.bCanTickEveryAction = true;
	DazedEffect.DamageTypes.AddItem('HeavyMental');

	if (default.HeavyDazedParticle_Name != "")
	{
		DazedEffect.VFXTemplateName = default.HeavyDazedParticle_Name;
		DazedEffect.VFXSocket = default.HeavyDazedSocket_Name;
		DazedEffect.VFXSocketsArrayName = default.HeavyDazedSocketsArray_Name;
	}

	UnitPropCondition = new class'X2Condition_UnitProperty';
	UnitPropCondition.ExcludeFriendlyToSource = true;
	UnitPropCondition.FailOnNonUnits = true;
	UnitPropCondition.ExcludeRobotic = true;
	DazedEffect.TargetConditions.AddItem(UnitPropCondition);

	return DazedEffect;
}

private static function string GetDazedFlyoverText(XComGameState_Unit TargetState, bool FirstApplication)
{
	local XComGameState_Effect EffectState;
	local X2AbilityTag AbilityTag;
	local string ExpandedString; // bsg-dforrest (7.27.17): need to clear out ParseObject

	EffectState = TargetState.GetUnitAffectedByEffectState(default.HeavyDazedName);
	if (FirstApplication || (EffectState != none && EffectState.GetX2Effect().IsTickEveryAction(TargetState)))
	{
		AbilityTag = X2AbilityTag(`XEXPANDCONTEXT.FindTag("Ability"));
		AbilityTag.ParseObj = TargetState;
		// bsg-dforrest (7.27.17): need to clear out ParseObject
		ExpandedString = `XEXPAND.ExpandString(default.HeavyDazedPerActionFriendlyName);
		AbilityTag.ParseObj = none;
		return ExpandedString;
		// bsg-dforrest (7.27.17): end
	}
	else
	{
		return default.HeavyDazedFriendlyName;
	}
}

static function DazedVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local XComGameState_Unit TargetState;

	if (EffectApplyResult != 'AA_Success')
	{
		return;
	}

	TargetState = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(ActionMetadata.StateObject_NewState.ObjectID));
	if (TargetState == none)
		return;

	class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(ActionMetadata, VisualizeGameState.GetContext(), GetDazedFlyoverText(TargetState, true), '', eColor_Bad, class'UIUtilities_Image'.const.UnitStatus_Stunned);
	class'X2StatusEffects'.static.AddEffectMessageToTrack(ActionMetadata,
														  default.HeavyDazedEffectAcquiredString,
														  VisualizeGameState.GetContext(),
														  default.HeavyDazedTitle,
														  class'UIUtilities_Image'.const.UnitStatus_Stunned,
														  eUIState_Bad);
	class'X2StatusEffects'.static.UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
}

static function DazedVisualizationTicked(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(ActionMetadata.StateObject_NewState.ObjectID));
	if (UnitState == none)
		return;

	// dead units should not be reported
	if (!UnitState.IsAlive())
	{
		return;
	}

	class'X2StatusEffects'.static.AddEffectCameraPanToAffectedUnitToTrack(ActionMetadata, VisualizeGameState.GetContext());
	class'X2StatusEffects'.static.AddEffectSoundAndFlyOverToTrack(ActionMetadata, VisualizeGameState.GetContext(), GetDazedFlyoverText(UnitState, false), '', eColor_Bad, class'UIUtilities_Image'.const.UnitStatus_Stunned);
	class'X2StatusEffects'.static.AddEffectMessageToTrack(ActionMetadata,
														  default.HeavyDazedEffectTickedString,
														  VisualizeGameState.GetContext(),
														  default.HeavyDazedTitle,
														  class'UIUtilities_Image'.const.UnitStatus_Stunned,
														  eUIState_Warning);
	class'X2StatusEffects'.static.UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
}

static function DazedVisualizationRemoved(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);
	if (UnitState == none)
		return;

	// dead units should not be reported
	if (!UnitState.IsAlive())
	{
		return;
	}

	class'X2StatusEffects'.static.AddEffectMessageToTrack(ActionMetadata,
														  default.HeavyDazedEffectLostString,
														  VisualizeGameState.GetContext(),
														  default.HeavyDazedTitle,
														  class'UIUtilities_Image'.const.UnitStatus_Stunned,
														  eUIState_Good);
	class'X2StatusEffects'.static.UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());
}

static function X2Effect_Persistent CreateMaimedStatusEffect(optional int NumTurns = 1, optional name AbilitySourceName = 'eAbilitySource_Standard')
{
	local X2Effect_PersistentStatChange Effect;

	Effect = new class'X2Effect_Immobilize';
	Effect.EffectName = 'Maim_Immobilize';
	Effect.DuplicateResponse = eDupe_Refresh;
	Effect.BuildPersistentEffect(NumTurns, false, true, , eGameRule_PlayerTurnEnd);
	Effect.AddPersistentStatChange(eStat_Mobility, 0, MODOP_Multiplication);
	Effect.SetDisplayInfo(ePerkBuff_Penalty, default.MaimedFriendlyName, default.MaimedFriendlyDesc,
			"img:///UILibrary_XPerkIconPack.UIPerk_move_blossom", true, , AbilitySourceName);
	Effect.VisualizationFn = class'XMBAbility'.static.EffectFlyOver_Visualization;

	return Effect;
}
