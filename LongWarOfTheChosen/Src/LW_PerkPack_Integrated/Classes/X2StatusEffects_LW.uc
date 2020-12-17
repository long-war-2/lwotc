class X2StatusEffects_LW extends Object config(GameCore);

var config int MAIMED_TURNS;

var localized string MaimedFriendlyName;
var localized string MaimedFriendlyDesc;

// Creates the Maimed status effect, which is in fact *two* effects,
// one for normal enemies and a one for the Chosen.
static function array<X2Effect_Persistent> CreateMaimedStatusEffects(optional int NumTurns = default.MAIMED_TURNS, optional name AbilitySourceName = 'eAbilitySource_Standard')
{
	local X2Effect_PersistentStatChange ImmobilizeEffect;
	local X2Effect_PersistentStatChange ChosenEffect;
	local X2Condition_UnitType ChosenCondition;
	local array<X2Effect_Persistent> MaimedEffects;

	ChosenCondition = new class'X2Condition_UnitType';
	ChosenCondition.ExcludeTypes.AddItem('ChosenSniper');
	ChosenCondition.ExcludeTypes.AddItem('ChosenWarlock');
	ChosenCondition.ExcludeTypes.AddItem('ChosenAssassin');

	ImmobilizeEffect = new class'X2Effect_Immobilize';
	ImmobilizeEffect.EffectName = 'Maim_Immobilize';
	ImmobilizeEffect.DuplicateResponse = eDupe_Refresh;
	ImmobilizeEffect.BuildPersistentEffect(NumTurns, false, false, , eGameRule_PlayerTurnBegin);
	ImmobilizeEffect.SetDisplayInfo(ePerkBuff_Penalty, default.MaimedFriendlyName, default.MaimedFriendlyDesc,
			"img:///UILibrary_XPerkIconPack.UIPerk_move_blossom", true, , AbilitySourceName);
	ImmobilizeEffect.AddPersistentStatChange(eStat_Mobility, 0.0f, MODOP_PostMultiplication);
	ImmobilizeEffect.VisualizationFn = class'XMBAbility'.static.EffectFlyOver_Visualization;
	ImmobilizeEffect.TargetConditions.AddItem(ChosenCondition);
	MaimedEffects.AddItem(ImmobilizeEffect);

	ChosenCondition = new class'X2Condition_UnitType';
	ChosenCondition.IncludeTypes.AddItem('ChosenSniper');
	ChosenCondition.IncludeTypes.AddItem('ChosenWarlock');
	ChosenCondition.IncludeTypes.AddItem('ChosenAssassin');

	ChosenEffect = new class'X2Effect_PersistentStatChange';
	ChosenEffect.EffectName = 'Maim_Chosen';
	ChosenEffect.DuplicateResponse = eDupe_Refresh;
	ChosenEffect.BuildPersistentEffect(NumTurns, false, false, , eGameRule_PlayerTurnBegin);
	ChosenEffect.SetDisplayInfo(ePerkBuff_Penalty, default.MaimedFriendlyName, default.MaimedFriendlyDesc,
			"img:///UILibrary_XPerkIconPack.UIPerk_move_blossom", true, , AbilitySourceName);
	ChosenEffect.AddPersistentStatChange(eStat_Mobility, 0.5f, MODOP_PostMultiplication);
	ChosenEffect.VisualizationFn = class'XMBAbility'.static.EffectFlyOver_Visualization;
	ChosenEffect.TargetConditions.AddItem(ChosenCondition);
	MaimedEffects.AddItem(ChosenEffect);

	return MaimedEffects;
}
