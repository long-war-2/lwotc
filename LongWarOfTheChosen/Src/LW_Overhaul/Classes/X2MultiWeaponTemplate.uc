//---------------------------------------------------------------------------------------
//  FILE:    X2MultiWeaponTemplate.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Template to allow defining alt versions of (limited) stats for joining two weapons together into a single pawn
//---------------------------------------------------------------------------------------
class X2MultiWeaponTemplate extends X2WeaponTemplate config(LW_Overhaul);

//  Combat related stuff
var(X2MultiWeaponTemplate) config int      iAltEnvironmentDamage    <ToolTip = "damage to environmental effects; should be 50, 100, or 150.">;
var(X2MultiWeaponTemplate) config WeaponDamageValue AltBaseDamage;       
var(X2MultiWeaponTemplate) config array<WeaponDamageValue> AltExtraDamage;
var(X2MultiWeaponTemplate) int             iAltRange                 <ToolTip = "-1 will mean within the unit's sight, 0 means melee">;
var(X2MultiWeaponTemplate) int             iAltRadius                <ToolTip = "radius in METERS for AOE range">;

// new stats, used for stat checks (e.g. panic on flamethrower)
var(X2MultiWeaponTemplate) int				iStatStrength			<Tooltip="Stat strength for opposed checks of weapon">;
var(X2MultiWeaponTemplate) int				iAltStatStrength		<Tooltip="Stat strength for opposed checks of alt weapon">;

//These are all only handled in native targeting code, so would be a pain to override everywhere
//var(X2MultiWeaponTemplate) float           fAltCoverage              <ToolTip = "percentage of tiles within the radius to affect">;

//These aren't currently needed, so aren't configured
//var(X2MultiWeaponTemplate) int             iAltTypicalActionCost     <ToolTip = "typical cost in action points to fire the weapon (only used by some abilities)">;
//var(X2MultiWeaponTemplate) config int             iAltClipSize              <ToolTip="ammo amount before a reload is required">;
//var(X2MultiWeaponTemplate) config bool            AltInfiniteAmmo           <ToolTip="no reloading required!">;
//var(X2MultiWeaponTemplate) config int             AltAim;
//var(X2MultiWeaponTemplate) config int             AltCritChance;
//var(X2MultiWeaponTemplate) name            AltDamageTypeTemplateName <ToolTip = "Template name for the type of ENVIRONMENT damage this weapon does">;
//var(X2MultiWeaponTemplate) array<int>      AltRangeAccuracy          <ToolTip = "Array of accuracy modifiers, where index is tiles distant from target.">;
var(X2MultiWeaponTemplate) int             iAltSoundRange            <ToolTip="Range in Meters, for alerting enemies.  (Yellow alert)">;


function AddAltExtraDamage(const int _Damage, const int _Spread, const int _PlusOne, const name _Tag)
{
	local WeaponDamageValue NewVal;
	NewVal.Damage = _Damage;
	NewVal.Spread = _Spread;
	NewVal.PlusOne = _PlusOne;
	NewVal.Tag = _Tag;
	AltExtraDamage.AddItem(NewVal);
}