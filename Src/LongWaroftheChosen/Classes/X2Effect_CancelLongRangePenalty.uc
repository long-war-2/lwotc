//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_CancelLongRangePenalty
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up range-based aim modifier (nullifying range table at SS range) for 
//--------------------------------------------------------------------------------------- 

class X2Effect_CancelLongRangePenalty extends X2Effect_Persistent config (LW_SoldierSkills);

var config float NULLIFY_LONG_RANGE_PENALTY_MODIFIER;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local XComGameState_Item	SourceWeapon;
	local X2WeaponTemplate		WeaponTemplate;
	local ShotModifierInfo		ShotInfo;
    local int					Tiles, Modifier;
	local array<int>			RangeTable;

	if(AbilityState != none)
	{
		SourceWeapon = AbilityState.GetSourceWeapon();    
		if(SourceWeapon != none)
		{
			WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
			if (WeaponTemplate.WeaponCat == 'sniper_rifle')
			{
				RangeTable = WeaponTemplate.RangeAccuracy;
				Tiles = Attacker.TileDistanceBetween(Target); 
				if (Tiles > int((Attacker.GetVisibilityRadius() * 64.0) / 96.0))
				{
					if(Tiles < RangeTable.Length)
					{
						Modifier = -RangeTable[Tiles];
					}
					else //Use last value
					{
						Modifier = -RangeTable[RangeTable.Length - 1];
					}
				}

				Modifier *= default.NULLIFY_LONG_RANGE_PENALTY_MODIFIER;
				
				if (Modifier > 0)
				{
					ShotInfo.Value = Modifier;
					ShotInfo.ModType = eHit_Success;
					ShotInfo.Reason = FriendlyName;
					ShotModifiers.AddItem(ShotInfo);
				}
			}
        }
    }    
}

defaultproperties
{
    EffectName="CancelLongRangePenalty"
}