// Used by Tedster with permission from NotSoLoneWolf

class X2Effect_LayeredArmour_LW extends X2Effect_BonusArmor;

var float MaxDamage;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	local int DamageMod;
	local int FinalDamage;
	local int MaxHealth;
	local int HealthGate;
	local XComGameState_Unit TargetState;
	local ArmorMitigationResults FakeArmor;

	if (CurrentDamage <= 0)
		return 0;

	TargetState = XComGameState_Unit(TargetDamageable);

	if (TargetState == none)
		return 0;

	MaxHealth = TargetState.GetMaxStat(eStat_HP);

	if (MaxHealth <= 1)
		return 0;

	HealthGate = Round(MaxHealth * MaxDamage);

	FinalDamage = CurrentDamage;
	FinalDamage -= TargetState.GetArmorMitigation(FakeArmor);
	
	if (FinalDamage >= HealthGate)
	{
		DamageMod = FinalDamage - HealthGate;
		DamageMod = -DamageMod;
		return DamageMod;
	}

	return 0;
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local string Message;

	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
	Message = "Layered Armour";
	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Message, '', eColor_Good, "img:///UILibrary_MW.UIPerk_intimidate");
}

simulated function AddX2ActionsForVisualization_Tick(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const int TickIndex, XComGameState_Effect EffectState)
{
	AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 'AA_Success');
}

DefaultProperties
{
	DuplicateResponse = eDupe_Refresh
}