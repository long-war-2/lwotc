//---------------------------------------------------------------------------------------
//  FILE:   X2Action_IRI_PsiPinion.uc
//  AUTHOR:  Iridar
//  PURPOSE: Soul Storm's environmental damage effect
//---------------------------------------------------------------------------------------
class X2Effect_IRI_SoulStorm extends X2Effect_ApplyDirectionalWorldDamage;

simulated function ApplyDirectionalDamageToTarget(XComGameState_Unit SourceUnit, XComGameState_Unit TargetUnit, XComGameState NewGameState)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_EnvironmentDamage DamageEvent;
	local XComGameState_Item ItemState;
	local X2WeaponTemplate WeaponTemplate;
	local XComWorldData WorldData;
	local Vector DamageDirection;
	local Vector SourceLocation, TargetLocation;
	local TTile  SourceTile, TargetTile;
	local DestructibleTileData DestructData;
	local XComDestructibleActor DestructActor;
	local int i;

	EnvironmentalDamageAmount = class'X2Ability_LW_PsiOperativeAbilitySet'.default.SOULSTORM_ENVIRONMENAL_DAMAGE;
	DamageTypeTemplateName = 'Psi';
	//PlusNumZTiles = class'XComWorldData'.const.WORLD_TotalLevels;
	bUseWeaponEnvironmentalDamage = false;
	bUseWeaponDamageType = false;
	bHitSourceTile = false;
	bHitTargetTile = class'X2Ability_LW_PsiOperativeAbilitySet'.default.SOULSTORM_SPARES_CEILINGS;
	bHitAdjacentDestructibles = true;
	bAllowDestructionOfDamageCauseCover = true;

	if (SourceUnit == None || TargetUnit == None)
		return;

	AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());
	if( AbilityContext != none )
	{
		WorldData = `XWORLD;

		SourceUnit.GetKeystoneVisibilityLocation(SourceTile);
		SourceLocation = WorldData.GetPositionFromTileCoordinates(SourceTile);

		TargetUnit.GetKeystoneVisibilityLocation(TargetTile);
		TargetLocation = WorldData.GetPositionFromTileCoordinates(TargetTile);

		if (bHitSourceTile)
		{
			DamageDirection = TargetLocation - SourceLocation;
			DamageDirection.Z = 0.0f;
			DamageDirection = Normal(DamageDirection);
		}
		else if (bHitTargetTile)
		{
			DamageDirection = SourceLocation - TargetLocation;
			DamageDirection.Z = 0.0f;
			DamageDirection = Normal(DamageDirection);
		}

		DamageEvent = XComGameState_EnvironmentDamage(NewGameState.CreateNewStateObject(class'XComGameState_EnvironmentDamage'));
		DamageEvent.DEBUG_SourceCodeLocation = "UC: X2Effect_ApplyDirectionalWorldDamage:ApplyEffectToWorld";
		DamageEvent.DamageAmount = EnvironmentalDamageAmount;
		DamageEvent.DamageTypeTemplateName = DamageTypeTemplateName;

		if (bHitAdjacentDestructibles)
		{
			WorldData.GetAdjacentDestructibles(bHitSourceTile ? SourceUnit : TargetUnit, DestructData, DamageDirection, bHitSourceTile ? TargetUnit : SourceUnit);
			for (i = 0; i < DestructData.DestructibleActors.Length; ++i)
			{
				DestructActor = XComDestructibleActor(DestructData.DestructibleActors[i]);
				if (DestructActor != none)
				{
					if (DestructActor.Toughness != none && DestructActor.Toughness.bInvincible)
						continue;

					DamageEvent.DestroyedActors.AddItem(DestructActor.GetActorId());
				}					
			}
		}

		if (bUseWeaponDamageType || bUseWeaponEnvironmentalDamage)
		{
			ItemState = XComGameState_Item(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.ItemObject.ObjectID));
			if (ItemState != none)
			{
				WeaponTemplate = X2WeaponTemplate(ItemState.GetMyTemplate());
				if (WeaponTemplate != none)
				{
					if (bUseWeaponDamageType)
						DamageEvent.DamageTypeTemplateName = WeaponTemplate.DamageTypeTemplateName;
					if (bUseWeaponEnvironmentalDamage)
						DamageEvent.DamageAmount = WeaponTemplate.iEnvironmentDamage;
				}
			}
		}

		if (bHitSourceTile)
			DamageEvent.HitLocation = SourceLocation;
		else
			DamageEvent.HitLocation = TargetLocation;
		DamageEvent.Momentum = DamageDirection;
		DamageEvent.DamageDirection = DamageDirection; //Limit environmental damage to the attack direction( ie. spare floors )
		DamageEvent.PhysImpulse = 100;
		DamageEvent.DamageRadius = class'X2Ability_LW_PsiOperativeAbilitySet'.default.SOULSTORM_ENVIRONMENAL_RADIUS;	
		DamageEvent.DamageCause = SourceUnit.GetReference();
		DamageEvent.DamageSource = DamageEvent.DamageCause;
		DamageEvent.bRadialDamage = false;
		DamageEvent.bAllowDestructionOfDamageCauseCover = bAllowDestructionOfDamageCauseCover;

		if (bHitSourceTile)
		{
			DamageEvent.DamageTiles.AddItem(SourceTile);

			for( i = 0; i < PlusNumZTiles; ++i)
			{
				SourceTile.Z++;
				DamageEvent.DamageTiles.AddItem(SourceTile);
			}
		}
		if (bHitTargetTile)
		{
			DamageEvent.DamageTiles.AddItem(TargetTile);
			
			for (i = 0; i < PlusNumZTiles; ++i)
			{
				TargetTile.Z++;
				DamageEvent.DamageTiles.AddItem(TargetTile);
			}
		}
	}
}