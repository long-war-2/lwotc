class X2StatusEffects_LW extends Object config(GameCore);

var config int MAIMED_TURNS;

var localized string MaimedFriendlyName;
var localized string MaimedFriendlyDesc;

static function X2Effect_Persistent CreateMaimedStatusEffect(optional int NumTurns = default.MAIMED_TURNS, optional name AbilitySourceName = 'eAbilitySource_Standard')
{
	local X2Effect_PersistentStatChange Effect;

	Effect = new class'X2Effect_Immobilize';
	Effect.EffectName = 'Maim_Immobilize';
	Effect.DuplicateResponse = eDupe_Refresh;
	Effect.BuildPersistentEffect(NumTurns, false, false, , eGameRule_PlayerTurnBegin);
	Effect.SetDisplayInfo(ePerkBuff_Penalty, default.MaimedFriendlyName, default.MaimedFriendlyDesc,
			"img:///UILibrary_XPerkIconPack.UIPerk_move_blossom", true, , AbilitySourceName);
	Effect.VisualizationFn = class'XMBAbility'.static.EffectFlyOver_Visualization;

	return Effect;
}
