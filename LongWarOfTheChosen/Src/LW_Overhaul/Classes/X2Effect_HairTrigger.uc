class X2Effect_HairTrigger extends X2Effect_Persistent;

var int To_Hit_Modifier;
var int Upgrade_Empower_Bonus;

function ModifyReactionFireSuccess_CH(XComGameState_Effect EffectState, XComGameState_Ability AbilityState, XComGameState_Unit UnitState, XComGameState_Unit TargetState, out int Modifier)
{
	local XComGameState_Item SourceWeapon;
	SourceWeapon = AbilityState.GetSourceWeapon();
	if (SourceWeapon != none && SourceWeapon.ObjectID == EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID)
	{
		Modifier = To_Hit_Modifier + (class'X2Item_DefaultUpgrades'.static.AreUpgradesEmpowered() ? Upgrade_Empower_Bonus : 0);
	}
}