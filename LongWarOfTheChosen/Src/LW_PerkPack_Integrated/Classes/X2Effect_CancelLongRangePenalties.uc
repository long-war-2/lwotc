//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_CancelLongRangePenalty
//  AUTHOR:  John Lumpkin (Pavonis Interactive) / Tedster
//  PURPOSE: Sets up range-based aim modifier for provided weapon categories and modifier value.
//--------------------------------------------------------------------------------------- 

class X2Effect_CancelLongRangePenalties extends X2Effect_Persistent;

var float NULLIFY_LONG_RANGE_PENALTY_MODIFIER;

var array<name>ValidWeaponCats;

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
			if (ValidWeaponCats.Find(WeaponTemplate.WeaponCat) != INDEX_NONE )
			{
                
				RangeTable = WeaponTemplate.RangeAccuracy;
				Tiles = Attacker.TileDistanceBetween(Target);
				if(Tiles < RangeTable.Length)
				{
					Modifier = -RangeTable[Tiles];
				}
				else //Use last value
				{
					Modifier = -RangeTable[RangeTable.Length - 1];
				}
				Modifier *= NULLIFY_LONG_RANGE_PENALTY_MODIFIER;
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