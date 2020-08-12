class X2Effect_PointBlank extends XMBEffect_ConditionalBonus;

var float RangePenaltyMultiplier;
var bool bShowNamedModifier;
var int BaseRange;
var bool bShortRange, bLongRange;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local XComGameState_Item SourceWeapon;
	local X2WeaponTemplate WeaponTemplate;
	local ShotModifierInfo Mod;
	local int Tiles, Modifier;

	if (ValidateAttack(EffectState, Attacker, Target, AbilityState) != 'AA_Success')
		return;

	SourceWeapon = AbilityState.GetSourceWeapon();	
	
	if (Attacker != none && Target != none && SourceWeapon != none)
	{
		WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());

		if (WeaponTemplate != none)
		{
			Tiles = Attacker.TileDistanceBetween(Target);
			if (Tiles < BaseRange && !bShortRange)
				return;
			if (Tiles > BaseRange && !bLongRange)
				return;

			if (WeaponTemplate.RangeAccuracy.Length > 0)
			{
				if (Tiles < WeaponTemplate.RangeAccuracy.Length)
					Modifier = WeaponTemplate.RangeAccuracy[Tiles];
				else  //  if this tile is not configured, use the last configured tile					
					Modifier = WeaponTemplate.RangeAccuracy[WeaponTemplate.RangeAccuracy.Length-1];

				if (BaseRange > 0)
				{
					if (BaseRange < WeaponTemplate.RangeAccuracy.Length)
						Modifier -= WeaponTemplate.RangeAccuracy[BaseRange];
					else  //  if this tile is not configured, use the last configured tile					
						Modifier -= WeaponTemplate.RangeAccuracy[WeaponTemplate.RangeAccuracy.Length-1];
				}
			}
		}
	
		if (Modifier < 0)
		{
			Mod.ModType = eHit_Success;
			if (bShowNamedModifier)
				Mod.Reason = FriendlyName;
			else
				Mod.Reason = class'XLocalizedData'.default.WeaponRange;
			Mod.Value = int(RangePenaltyMultiplier * Modifier);

			ShotModifiers.AddItem(Mod);
		}
	}
}


defaultproperties
{
	EffectName = "PointBlank"
	DuplicateResponse = eDupe_Refresh
}