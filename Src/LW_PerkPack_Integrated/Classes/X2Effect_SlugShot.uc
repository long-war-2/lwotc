//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_SlugShot
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up range-based aim modifier (nullifying range table) for Slug Shot perk
//--------------------------------------------------------------------------------------- 

class X2Effect_SlugShot extends X2Effect_Persistent config (LW_SoldierSkills);

var int Pierce;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)

{
	local XComGameState_Item	SourceWeapon;
	local X2WeaponTemplate		WeaponTemplate;
	local ShotModifierInfo		ShotInfo;
    local int					Tiles, Modifier;
	local array<int>			RangeTable;

	if(AbilityState.GetMyTemplateName() == 'SlugShot')
	{
		SourceWeapon = AbilityState.GetSourceWeapon();    
		if(SourceWeapon != none)
		{
			WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
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
			if (Modifier > 0)
			{
				ShotInfo.Value = Modifier;
			}
			ShotInfo.ModType = eHit_Success;
            ShotInfo.Reason = FriendlyName;
            ShotModifiers.AddItem(ShotInfo);
        }
    }    
}

function int GetExtraArmorPiercing(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData)
{
    local XComGameState_Item SourceWeapon;

	if(AbilityState.GetMyTemplateName() == 'SlugShot')
	{
		SourceWeapon = AbilityState.GetSourceWeapon();
		if(SourceWeapon != none) 
		{
	        return Pierce;
		}
    }
    return 0;
}

defaultproperties
{
    EffectName="SlugShot"
}