class X2Effect_AlloySpikesDamageModifier extends X2Effect_Persistent;

//	Used by Flechette Rocket, reduces damage against targets in cover.

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState) 
{ 
	local XComGameStateContext_Ability	AbilityContext;	
	local XComGameState_Unit			UnitState;
	local GameRulesCache_VisibilityInfo OutVisInfo;
	local TTile							ExplosionTile;
	local vector						ExplosionLocation;
	local vector						TargetLocation;
	local float							TargetCoverAngle;
	local ECoverType					Cover;
	local XComWorldData					WorldData;

	//	If the activated ability is attached to the same weapon that applied this damage modifier effect.
	if (AbilityState.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef)
	{
		if (NewGameState != none)
		{
			AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());
			UnitState = XComGameState_Unit(TargetDamageable);
			if (AbilityContext != none && UnitState != none)
			{
				if (!UnitState.GetMyTemplate().bCanTakeCover) 
				{
					return class'X2Rocket_Flechette'.default.DAMAGE_MODIFIER_TARGET_CANNOT_TAKE_COVER;
				}

				WorldData = `XWORLD;
				ExplosionLocation = AbilityContext.InputContext.TargetLocations[0];
				ExplosionTile = WorldData.GetTileCoordinatesFromPosition(ExplosionLocation);

				if (WorldData.CanSeeTileToTile(ExplosionTile, UnitState.TileLocation, OutVisInfo))
				{
					TargetLocation = WorldData.GetPositionFromTileCoordinates(UnitState.TileLocation);

					//	CanSeeTileToTile does not update TargetCover, have to check manually.
					Cover = WorldData.GetCoverTypeForTarget(ExplosionLocation, TargetLocation, TargetCoverAngle);

					switch (Cover)
					{
						case CT_None:
							return CurrentDamage * class'X2Rocket_Flechette'.default.DAMAGE_MODIFIER_NO_COVER;
						case CT_MidLevel:
							return CurrentDamage * class'X2Rocket_Flechette'.default.DAMAGE_MODIFIER_MID_COVER;
						case CT_Standing:
							return CurrentDamage * class'X2Rocket_Flechette'.default.DAMAGE_MODIFIER_FULL_COVER;
					}
				}
			}
		}
	}
	return 0; 
}