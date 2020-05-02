//---------------------------------------------------------------------------------------
//  FILE:    X2AbilityTarget_Cursor_LW.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Abilities that are added to enemy units as dark events.
//---------------------------------------------------------------------------------------

class X2AbilityTarget_Cursor_LW extends X2AbilityTarget_Cursor;

struct AbilityRangeModifier
{
    var name AbilityName;
    var float RangeModifierInMeters;
};

var array<AbilityRangeModifier> AbilityRangeModifiers;

simulated function float GetCursorRangeMeters(XComGameState_Ability AbilityState)
{
    local XComGameState_Unit UnitState;
    local float RangeInMeters;
    local int i;

    RangeInMeters = super.GetCursorRangeMeters(AbilityState);

	if (!bRestrictToWeaponRange)
	{
        UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));

        for (i = 0; i < AbilityRangeModifiers.Length; i++)
        {
            if (UnitState.FindAbility(AbilityRangeModifiers[i].AbilityName).ObjectID != 0)
            {
                RangeInMeters += AbilityRangeModifiers[i].RangeModifierInMeters;
            }
        }
    }

	return RangeInMeters;
}

function AddAbilityRangeModifier(name AbilityName, float RangeModifierInMeters)
{
    local AbilityRangeModifier Modifier;

    Modifier.AbilityName = AbilityName;
    Modifier.RangeModifierInMeters = RangeModifierInMeters;
    AbilityRangeModifiers.AddItem(Modifier);
}
