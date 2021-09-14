class X2AbilityTarget_IRI_Rocket extends X2AbilityTarget_Cursor;

//	Target Style that increases rocket range based on the rocket launcher

simulated function float GetCursorRangeMeters(XComGameState_Ability AbilityState)
{
	local XComGameState_Item	SourceWeapon;
	local XComGameState_Unit	UnitState;
	local XComGameState			GameState;
	local XComGameState_Item	RocketLauncherState;

	local int RangeInTiles;
	local float RangeInMeters;

	GameState = AbilityState.GetParentGameState();
	if (GameState != none) 
	{
		UnitState = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
		if (UnitState != none) 
		{
			RocketLauncherState = UnitState.GetItemInSlot(eInvSlot_SecondaryWeapon, GameState);
			SourceWeapon = AbilityState.GetSourceWeapon();

			if (SourceWeapon != none && RocketLauncherState != none)
			{
				//	get weapon range from the rocket
				RangeInTiles = SourceWeapon.GetItemRange(AbilityState);
				//	increase it by the Range Increase value from the Rocket Launcher
				RangeInTiles += X2GrenadeLauncherTemplate(RocketLauncherState.GetMyTemplate()).IncreaseGrenadeRange;

				if( RangeInTiles == 0 )
				{
					// This is melee range
					RangeInMeters = class'XComWorldData'.const.WORLD_Melee_Range_Meters;
				}
				else
				{
					RangeInMeters = `UNITSTOMETERS(`TILESTOUNITS(RangeInTiles));
				}
				return RangeInMeters;
			}
		}
	}
	return FixedAbilityRange;
}