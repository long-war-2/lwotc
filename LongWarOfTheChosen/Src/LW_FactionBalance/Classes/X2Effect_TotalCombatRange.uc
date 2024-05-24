//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_Bombard.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Increases throw and launch range of grenades
//---------------------------------------------------------------------------------------
class X2Effect_TotalCombatRange extends X2Effect_Persistent;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local Object EffectObj;

	EffectObj = EffectGameState;

	// allows activation/deactivation of effect
	`XEVENTMGR.RegisterForEvent(EffectObj, 'OnGetItemRange', OnGetItemRange,,,,, EffectObj);
}

//this is triggered when checking range on an item
static final function EventListenerReturn OnGetItemRange(
	Object EventData,
	Object EventSource,
	XComGameState NewGameState,
	Name InEventID,
	Object CallbackData)
{
	local XComLWTuple				OverrideTuple;
	local XComGameState_Item		Item;
	local XComGameState_Ability		Ability;
	local XComGameState_Effect		EffectState;
	local XComGameState_Item		SourceWeapon;
	local X2WeaponTemplate			WeaponTemplate;

	OverrideTuple = XComLWTuple(EventData);
	if (OverrideTuple == none)
	{
		`REDSCREEN("OverrideGetPCSImage event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}

	Item = XComGameState_Item(EventSource);
	if (Item == none)
		return ELR_NoInterrupt;

	if (OverrideTuple.Id != 'GetItemRange')
		return ELR_NoInterrupt;

	Ability = XComGameState_Ability(OverrideTuple.Data[2].o);  // optional ability
	EffectState = XComGameState_Effect(CallbackData);

	//verify the owner of the item matches
	if (Item.OwnerStateObject != EffectState.ApplyEffectParameters.SourceStateObjectRef)
		return ELR_NoInterrupt;

	if (Ability == none)
		return ELR_NoInterrupt;

	//get the source weapon and weapon template
	SourceWeapon = Ability.GetSourceWeapon();
	WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());

	if (WeaponTemplate == none)
		return ELR_NoInterrupt;

	// make sure the weapon is either a grenade or a grenade launcher
	if (X2GrenadeTemplate(WeaponTemplate) != none || X2GrenadeLauncherTemplate(WeaponTemplate) != none ||
		WeaponTemplate.DataName == 'Battlescanner')
	{
		OverrideTuple.Data[1].i = class'X2LWModTemplate_SkirmisherAbilities'.default.TOTAL_COMBAT_BONUS_RANGE;
	}

	return ELR_NoInterrupt;
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
	EffectName="TotalCombatRange";
	bRemoveWhenSourceDies=true;
}