class X2StatusEffects_LW extends Object config(GameCore);

var config int MAIMED_TURNS;

var localized string MaimedFriendlyName;
var localized string MaimedFriendlyDesc;

// Creates the Maimed status effect, which is in fact *two* effects,
// one for normal enemies and a one for the Chosen.
static function X2Effect_Immobilize CreateMaimedStatusEffect(optional int NumTurns = default.MAIMED_TURNS, optional name AbilitySourceName = 'eAbilitySource_Standard')
{
	local X2Effect_Immobilize ImmobilizeEffect;

	ImmobilizeEffect = new class'X2Effect_Immobilize';
	ImmobilizeEffect.EffectName = 'Maim_Immobilize';
	ImmobilizeEffect.DuplicateResponse = eDupe_Refresh;
	ImmobilizeEffect.BuildPersistentEffect(NumTurns, false, false, , eGameRule_PlayerTurnBegin);
	ImmobilizeEffect.SetDisplayInfo(ePerkBuff_Penalty, default.MaimedFriendlyName, default.MaimedFriendlyDesc,
			"img:///UILibrary_XPerkIconPack_LW.UIPerk_move_blossom", true, , AbilitySourceName);
	ImmobilizeEffect.AddPersistentStatChange(eStat_Mobility, 0.0f, MODOP_PostMultiplication);
	ImmobilizeEffect.VisualizationFn = class'XMBAbility'.static.EffectFlyOver_Visualization;

	return ImmobilizeEffect;
}
