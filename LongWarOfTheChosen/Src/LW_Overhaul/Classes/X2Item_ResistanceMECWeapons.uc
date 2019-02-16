//--------------------------------------------------------------------------------------- 
//  FILE:    X2Item_ResistanceMECWeapons.uc
//  AUTHOR:	 Amineri (Pavonis Interactive)
//  PURPOSE: Defines weapons for ResistanceMEC
//--------------------------------------------------------------------------------------- 
class X2Item_ResistanceMECWeapons extends X2Item config(GameData_WeaponData);

var config WeaponDamageValue ResistanceMEC_MicroMissiles_BaseDamage;
var config int ResistanceMEC_MicroMissiles_Clipsize;
var config int ResistanceMEC_MicroMissiles_EnvironmentDamage;
var config int ResistanceMEC_MicroMissiles_RANGE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	`LWTrace("  >> X2Item_ResistanceMECWeapons.CreateTemplates()");
	
	Templates.AddItem(CreateTemplate_ResistanceMEC_Shoulder_WPN());

	return Templates;
}

static function X2DataTemplate CreateTemplate_ResistanceMEC_Shoulder_WPN()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'ResistanceMEC_Shoulder_WPN');
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'shoulder_launcher';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventMecGun";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.ResistanceMEC_MicroMissiles_BaseDamage;
	Template.iClipSize = default.ResistanceMEC_MicroMissiles_Clipsize;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ResistanceMEC_MicroMissiles_EnvironmentDamage;
	Template.iRange = default.ResistanceMEC_MicroMissiles_RANGE;
	Template.iIdealRange = default.ResistanceMEC_MicroMissiles_RANGE;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('MicroMissiles');
	Template.Abilities.AddItem('MicroMissileFuse');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWResistanceMEC.Archetypes.WP_ResistanceLauncher"; 
	//Template.GameArchetype = "WP_AdvMec_Launcher.WP_AdvMecLauncher"; 

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;


	// This controls how much arc this projectile may have and how many times it may bounce
	Template.WeaponPrecomputedPathData.InitialPathTime = 1.5;
	Template.WeaponPrecomputedPathData.MaxPathTime = 2.5;
	Template.WeaponPrecomputedPathData.MaxNumberOfBounces = 0;

	Template.DamageTypeTemplateName = 'Explosion';

	return Template;
}