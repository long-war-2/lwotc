//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_Effect_Bombard.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: This is an effect component extension listening for OnGetItemRange to add range to thrown or launched grenades
//---------------------------------------------------------------------------------------

class XComGameState_Effect_Bombard extends XComGameState_BaseObject;

function XComGameState_Effect_Bombard InitComponent()
{
	return self;
}

function XComGameState_Effect GetOwningEffect()
{
	return XComGameState_Effect(`XCOMHISTORY.GetGameStateForObjectID(OwningObjectId));
}

//this is triggered when checking range on an item
function EventListenerReturn OnGetItemRange(
		Object EventData,
		Object EventSource,
		XComGameState NewGameState,
		Name InEventID,
		Object CallbackData)
{
	local XComLWTuple				OverrideTuple;
	local XComGameState_Item		Item;
	//local int						Range;  // in tiles -- either bonus or override
	local XComGameState_Ability		Ability;
	//local bool						bOverride; // if true, replace the range, if false, just add to it
	local XComGameState_Item		SourceWeapon;
	local X2WeaponTemplate			WeaponTemplate;

	OverrideTuple = XComLWTuple(EventData);
	if(OverrideTuple == none)
	{
		`REDSCREEN("OverrideGetPCSImage event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}

	Item = XComGameState_Item(EventSource);
	if(Item == none)
		return ELR_NoInterrupt;

	if(OverrideTuple.Id != 'GetItemRange')
		return ELR_NoInterrupt;

	Ability = XComGameState_Ability(OverrideTuple.Data[2].o);  // optional ability

	//verify the owner of the item matches
	if(Item.OwnerStateObject != GetOwningEffect().ApplyEffectParameters.SourceStateObjectRef)
		return ELR_NoInterrupt;

	if(Ability == none)
		return ELR_NoInterrupt;

	//get the source weapon and weapon template
	SourceWeapon = Ability.GetSourceWeapon();
	WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
	
	if(WeaponTemplate == none)
		return ELR_NoInterrupt;

	// make sure the weapon is either a grenade or a grenade launcher
	if(X2GrenadeTemplate(WeaponTemplate) != none || X2GrenadeLauncherTemplate(WeaponTemplate) != none || WeaponTemplate.DataName == 'Battlescanner')
	{
		OverrideTuple.Data[1].i += class'X2Ability_LW_GrenadierAbilitySet'.default.BOMBARD_BONUS_RANGE_TILES;
	}

	return ELR_NoInterrupt;
}
