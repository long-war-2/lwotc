//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_TemplarFocusStatBonuses
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Adds bonus stats to a Templar based on their focus level.
//--------------------------------------------------------------------------------------- 

class X2Effect_TemplarFocusStatBonuses extends X2Effect_ModifyStats;

// Variables and functions copied from X2Effect_TemplarFocus
var array<FocusLevelModifiers>	arrFocusModifiers;

function AddNextFocusLevel(const array<StatChange> NextStatChanges, const int NextArmorMitigation, const int NextWeaponDamage)
{
	local FocusLevelModifiers NextFocusLevel;

	NextFocusLevel.StatChanges = NextStatChanges;
	NextFocusLevel.ArmorMitigation = NextArmorMitigation;
	NextFocusLevel.WeaponDamage = NextWeaponDamage;
	arrFocusModifiers.AddItem(NextFocusLevel);
}

function FocusLevelModifiers GetFocusModifiersForLevel(int FocusLevel)
{
	local FocusLevelModifiers Modifiers;

	if (FocusLevel >= 0)
	{
		if (FocusLevel >= arrFocusModifiers.Length)
			Modifiers = arrFocusModifiers[arrFocusModifiers.Length - 1];
		else
			Modifiers = arrFocusModifiers[FocusLevel];
	}

	return Modifiers;
}
// End copied code

// Registers a listener that is called when the Templar's focus level changes,
// so we can update the stat bonuses provided by this effect.
function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local Object EffectObj;

	EffectObj = EffectGameState;

	`XEVENTMGR.RegisterForEvent(EffectObj, 'FocusLevelChanged', OnFocusLevelChanged, ELD_Immediate,,,, EffectGameState);
}

static function EventListenerReturn OnFocusLevelChanged(
	Object EventData,
	Object EventSource,
	XComGameState NewGameState,
	Name Event,
	Object CallbackData)
{
	local XComGameState_Effect_TemplarFocus TemplarFocusEffectState;
	local XComGameState_Effect EffectGameState;
	local XComGameState_Unit UnitState;
	local X2Effect_TemplarFocusStatBonuses FocusEffect;

	if (NewGameState.GetContext().InterruptionStatus == eInterruptionStatus_Interrupt)
		return ELR_NoInterrupt;

	TemplarFocusEffectState = XComGameState_Effect_TemplarFocus(EventData);
	if (TemplarFocusEffectState == none) return ELR_NoInterrupt;

	UnitState = XComGameState_Unit(EventSource);
	if (UnitState == none) return ELR_NoInterrupt;

	// Make sure we have the latest pending versions of various state objects.
	TemplarFocusEffectState = XComGameState_Effect_TemplarFocus(NewGameState.GetGameStateForObjectID(TemplarFocusEffectState.ObjectID));
	UnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(UnitState.ObjectID));
	EffectGameState = XComGameState_Effect(CallbackData);
	EffectGameState = XComGameState_Effect(NewGameState.ModifyStateObject(EffectGameState.Class, EffectGameState.ObjectID));
	FocusEffect = X2Effect_TemplarFocusStatBonuses(EffectGameState.GetX2Effect());

	// First remove any existing stat bonuses provided by this effect
	if (EffectGameState.StatChanges.Length > 0)
	{
		UnitState.UnApplyEffectFromStats(EffectGameState, NewGameState);
		EffectGameState.StatChanges.Length = 0;
	}

	// Now get the stat bonuses for the current focus level and apply them
	// (unless there are no stat bonuses).
	EffectGameState.StatChanges = FocusEffect.GetFocusModifiersForLevel(TemplarFocusEffectState.FocusLevel).StatChanges;
	if (EffectGameState.StatChanges.Length > 0)
	{
		UnitState.ApplyEffectToStats(EffectGameState, NewGameState);
	}

	return ELR_NoInterrupt;
}

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Effect_TemplarFocus FocusState;
	local bool FoundFocusState;

	// Try to get the Templar Focus effect game state for the unit.
	//
	// Start by looking in NewGameState
    foreach NewGameState.IterateByClassType(class'XComGameState_Effect_TemplarFocus', FocusState)
	{
		if (FocusState.ApplyEffectParameters.TargetStateObjectRef.ObjectID == kNewTargetState.ObjectID)
		{
			FoundFocusState = true;
			break;
		}
	}

	// If it's not there, try in History
	if (!FoundFocusState)
	{
		foreach `XCOMHISTORY.IterateByClassType(class'XComGameState_Effect_TemplarFocus', FocusState)
		{
			if (FocusState.ApplyEffectParameters.TargetStateObjectRef.ObjectID == kNewTargetState.ObjectID)
			{
				FoundFocusState = true;
				break;
			}
		}
	}

	// Finally, just create a new state so we can use its instance function
	// for getting the starting focus level. The function could be static as
	// it doesn't depend on the effect state. (This may be an unnecessary
	// precaution, but I don't know if there is guaranteed to be a focus
	// state at this point).
	if (!FoundFocusState)
	{
		FocusState = new class'XComGameState_Effect_TemplarFocus';
		FocusState.FocusLevel = FocusState.GetStartingFocus(XComGameState_Unit(kNewTargetState));
	}

	NewEffectState.StatChanges = GetFocusModifiersForLevel(FocusState.FocusLevel).StatChanges;
	if (NewEffectState.StatChanges.Length > 0)
		super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

defaultProperties
{
	EffectName = "TemplarOvercharge"
	GameStateEffectClass = class'XComGameState_Effect'
}
