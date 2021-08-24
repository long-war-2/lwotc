class X2Effect_ApplySpecialAcidToWorld extends X2Effect_ApplyAcidToWorld;

event array<X2Effect> GetTileEnteredEffects()
{
	local array<X2Effect> TileEnteredEffectsUncached;

	TileEnteredEffectsUncached.AddItem(class'X2Rocket_Acid'.static.CreateAcidBurningStatusEffect(class'X2Rocket_Acid'.default.DURATION_TURNS));

	return TileEnteredEffectsUncached;
}