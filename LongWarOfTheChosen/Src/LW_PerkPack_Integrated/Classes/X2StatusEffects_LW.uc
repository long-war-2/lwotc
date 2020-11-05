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
