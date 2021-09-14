class X2Condition_RocketTechLevel extends X2Condition config (RocketLaunchers);

//	makes it possible to fire a rocket only from a launcher with the same tech level or higher
//	Also checks whether the secondary weapon is a proper rocket launcher.

var config bool MATCH_ROCKET_TECH_LEVEL_TO_LAUNCHER;
var config bool ROCKETS_ARE_BACKWARDS_COMPATIBLE;
var config array<name> ALWAYS_COMPATIBLE_LAUNCHERS;

//	Can't do CanEverBeValid check, since no SourceWeapon there.

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
	local XComGameState_Item		RocketState;
	local XComGameState_Item		RocketLauncherState;
	local XComGameState_Unit		UnitState;
	local X2GrenadeLauncherTemplate RocketLauncherTemplate;
	local X2RocketTemplate			RocketTemplate;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));

	//`redscreen(UnitState.GetFullName());

	//	Fail condition if no Unit State.
	if (UnitState == none)	return 'AA_NotAUnit';

	RocketLauncherState = UnitState.GetItemInSlot(eInvSlot_SecondaryWeapon);

	//	Fail condition if there's no weapon in secondary slot.
	if (RocketLauncherState == none) return 'AA_WeaponIncompatible';
	
	RocketLauncherTemplate = X2GrenadeLauncherTemplate(RocketLauncherState.GetMyTemplate());

	RocketState = kAbility.GetSourceWeapon();

	//	Fail condition if the ability doesn't come from an item
	if (RocketState == none) return 'AA_WeaponIncompatible';

	RocketTemplate = X2RocketTemplate(RocketState.GetMyTemplate());

	//	Fail condition if the ability comes from an item that's not a rocket
	if (RocketTemplate == none) return 'AA_WeaponIncompatible';

	return CheckWeaponForCompatibility(RocketLauncherTemplate, RocketTemplate);
}

static function name CheckWeaponForCompatibility(X2GrenadeLauncherTemplate RocketLauncherTemplate, X2RocketTemplate	RocketTemplate)
{		
	//	Fail condition if the weapon in secondary slot doesn't respond to grenade launcher template
	if (RocketLauncherTemplate  == none) return 'AA_WeaponIncompatible';

	//	Fail condition if the weapon in secondary slot is not a rocket launcher-- Weapon category check is unnecessary. Either the launcher is compatible with all rockets (or this specific rocket), or it isn't.
	//if (RocketLauncherTemplate.WeaponCat != 'iri_rocket_launcher') return 'AA_WeaponIncompatible';

	//	Fail condition if the rocket launcher is not on the list of compatible launchers for this rocket
	//	Launchers from this mod are always compatible, so this exists just in case another mod adds launchers
	//	specialized for firing only specific rockets

	if (default.ALWAYS_COMPATIBLE_LAUNCHERS.Find(RocketLauncherTemplate.DataName) == INDEX_NONE)
	{
		if(RocketTemplate.COMPATIBLE_LAUNCHERS.Find(RocketLauncherTemplate.DataName) == INDEX_NONE)
		{
			return 'AA_WeaponIncompatible';
		}
	}

	//	If configured, condition will pass if the rocket's WeaponTech is equal to launcher's WeaponTech
	if (default.MATCH_ROCKET_TECH_LEVEL_TO_LAUNCHER)
	{
		if (RocketLauncherTemplate.WeaponTech == RocketTemplate.WeaponTech) 
		{
			return 'AA_Success';
		}
		else
		{
			return 'AA_WeaponIncompatible';
		}
	}
	//	If configured, condition will pass if the launcher's Weapon Tech is equal or higher to rocket's Weapon Tech
	if (default.ROCKETS_ARE_BACKWARDS_COMPATIBLE)
	{
		if (GetTechLevel(RocketLauncherTemplate.WeaponTech) >= GetTechLevel(RocketTemplate.WeaponTech)) 
		{
			return 'AA_Success';
		}
		else
		{
			return 'AA_WeaponIncompatible';
		}
	}	

	//	condition automatically passes if not configured to do other checks beyond confirming the weapon.
	return 'AA_Success';
}

//	A helper function to convert the name of the weapon's tech level into a number
//	... an indian coding approach would be convert the name to a string and then compare their length...
static function int GetTechLevel(name WeaponTech)
{
	switch (WeaponTech)
	{
		case 'conventional':
			return 1;
		case 'magnetic':
			return 2;
		case 'beam':
			return 3;
		default:
			return 0;
	}
}

