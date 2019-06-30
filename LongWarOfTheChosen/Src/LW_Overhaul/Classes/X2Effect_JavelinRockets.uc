//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_JavelinRockets.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Increases range of rockets
//---------------------------------------------------------------------------------------
class X2Effect_JavelinRockets extends X2Effect_Persistent config(LW_SoldierSkills);

var config array<name> VALID_ABILITIES;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local Object EffectObj;

	EffectObj = EffectGameState;

	// allows activation/deactivation of effect
	`XEVENTMGR.RegisterForEvent(EffectObj, 'OnGetItemRange', OnGetItemRange,,,,, EffectObj);
}

//this is triggered when checking range on an item
static function EventListenerReturn OnGetItemRange(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComLWTuple				OverrideTuple;
	local XComGameState_Effect		EffectState;
	local XComGameState_Item		Item;
	local XComGameState_Ability		Ability;
	local name						AbilityName;
	local XComGameState_Item		SourceWeapon;
	local X2MultiWeaponTemplate		WeaponTemplate;

	OverrideTuple = XComLWTuple(EventData);
	if(OverrideTuple == none)
	{
		`REDSCREEN("OverrideGetPCSImage event triggered with invalid event data.");
		return ELR_NoInterrupt;
	}

	Item = XComGameState_Item(EventSource);
	if(Item == none)
		return ELR_NoInterrupt;
	//`LOG("OverrideTuple : EventSource valid.");

	if(OverrideTuple.Id != 'GetItemRange')
		return ELR_NoInterrupt;

	Ability = XComGameState_Ability(OverrideTuple.Data[2].o);  // optional ability
	EffectState = XComGameState_Effect(CallbackData);

	//verify the owner of the item matches
	if(Item.OwnerStateObject != EffectState.ApplyEffectParameters.SourceStateObjectRef)
		return ELR_NoInterrupt;

	if(Ability == none)
		return ELR_NoInterrupt;

	AbilityName = Ability.GetMyTemplateName();

	//get the source weapon and weapon template
	SourceWeapon = Ability.GetSourceWeapon();
	WeaponTemplate = X2MultiWeaponTemplate(SourceWeapon.GetMyTemplate());
	
	if(WeaponTemplate == none)
		return ELR_NoInterrupt;

	// make sure the weapon is a gauntlet and that we are using a rocket ability
	if(WeaponTemplate != none)
	{
		if(AbilityName == 'LWRocketLauncher' || AbilityName == 'LWBlasterLauncher' || default.VALID_ABILITIES.Find (AbilityName) != -1)
		{
			OverrideTuple.Data[1].i = class'X2Ability_LW_TechnicalAbilitySet'.default.JAVELIN_ROCKETS_BONUS_RANGE_TILES;
		}
	}

	return ELR_NoInterrupt;
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
	EffectName="JavelinRockets";
	bRemoveWhenSourceDies=true;
}
