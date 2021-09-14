
class X2Effect_BonusClipSize extends X2Effect_Persistent;


// Variables to pass into the effect:
var int			iClipSizeModifier;	//�� Modify weapon ammo by this ammount.
var int			iMinWeaponAmmo;		//�� Minimum amount of standard ammo - useful with negative clipsize modifiers.

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;
	local XComGameState_Unit EffectTargetUnit;
	local XComGameState_Item EffectTargetItem;
	local X2WeaponTemplate WeaponTemplate;

	EventMgr = `XEVENTMGR;
	EffectObj = EffectGameState;
	EffectTargetUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	EffectTargetItem = EffectTargetUnit.GetPrimaryWeapon();
	WeaponTemplate = X2WeaponTemplate(EffectTargetItem.GetMyTemplate());

	if (WeaponTemplate.iClipSize >= iMinWeaponAmmo)
	{
		EventMgr.RegisterForEvent(EffectObj, 'OverrideClipsize', OnOverrideClipsize, ELD_Immediate,,,, EffectObj);
	}
}


// EventListenerReturn function to modify weapon ammo count each time GetClipSize() is called (reloads, etc.)
static function EventListenerReturn OnOverrideClipsize(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComLWTuple								OverrideTuple;
	local XComGameState_Item						ExpectedItem;
	local XComGameState_Effect						EffectState;
	local X2Effect_BonusClipSize	Effect;

	EffectState = XComGameState_Effect(CallbackData);
	Effect = X2Effect_BonusClipSize(EffectState.GetX2Effect());
	ExpectedItem = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID));

	OverrideTuple = XComLWTuple(EventData);
	if (OverrideTuple == none)
		return ELR_NoInterrupt;

	if (OverrideTuple.Id != 'OverrideClipSize')
		return ELR_NoInterrupt;

	if (EventSource == none || XComGameState_Item(EventSource).ObjectID != ExpectedItem.ObjectID)
		return ELR_NoInterrupt;


	OverrideTuple.Data[0].i += Effect.iClipSizeModifier;

	return ELR_NoInterrupt;
}


defaultproperties
{
	DuplicateResponse = eDupe_Allow
}