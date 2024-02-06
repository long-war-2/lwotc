// Author: Tedster
// Extension of the base game class so that the damage boost only gets consumed on hit.

class X2Effect_DLC_3AbsorptionField_LW extends X2Effect_DLC_3AbsorptionField;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Effect_DLC_3AbsorptionField FieldEffectState;
	local XComGameState_Item SourceWeapon;
	local int BonusDamage;

	FieldEffectState = XComGameState_Effect_DLC_3AbsorptionField(EffectState);
	if (FieldEffectState != none)
	{
		SourceWeapon = AbilityState.GetSourceWeapon();
		if (SourceWeapon != none && SourceWeapon.InventorySlot == eInvSlot_PrimaryWeapon)
		{
			BonusDamage = min(FieldEffectState.EnergyAbsorbed, CurrentDamage * 2);      //  caps bonus at twice the incoming amount

			// Tedster - add hit result check here.
			if (NewGameState != none && BonusDamage > 0 && class'XComGameStateContext_Ability'.static.IsHitResultHit(AppliedData.AbilityResultContext.HitResult))           //  this means we are really attacking and not just previewing damage, so clear out the amount of energy used
			{
				FieldEffectState = XComGameState_Effect_DLC_3AbsorptionField(NewGameState.ModifyStateObject(FieldEffectState.Class, FieldEffectState.ObjectID));
				FieldEffectState.EnergyAbsorbed = 0;
				FieldEffectState.LastEnergyExpendedContext = NewGameState.GetContext();
			}
		}
	}
	else
	{
		`RedScreen("X2Effect_DLC_3AbsorptionField was given an EffectState" @ EffectState.ToString() @ "which is not the right class - should be XComGameState_Effect_DLC_3AbsorptionField! @gameplay @jbouscher");
	}
	return BonusDamage;
}

DefaultProperties
{
	EffectName = "DLC_3AbsorptionField"
	DuplicateResponse = eDupe_Ignore
	GameStateEffectClass = class'XComGameState_Effect_DLC_3AbsorptionField_LW';
	bDisplayInSpecialDamageMessageUI = true
}
