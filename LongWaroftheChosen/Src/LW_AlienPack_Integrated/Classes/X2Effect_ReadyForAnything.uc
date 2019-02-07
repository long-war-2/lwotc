class X2Effect_ReadyForAnything extends X2Effect_Persistent;

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local XComGameState_Ability					AbilityState;
	local XComGameState_Item					PrimaryWeapon;

	if (XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID)) == none)
		return false;

	if (SourceUnit.AffectedByEffectNames.Find(class'X2Effect_Suppression'.default.EffectName) != -1)
		return false;

	if (SourceUnit.AffectedByEffectNames.Find(class'X2Effect_AreaSuppression'.default.EffectName) != -1)
		return false;

	if (SourceUnit.AffectedByEffectNames.Find(class'X2AbilityTemplateManager'.default.DisorientedName) != -1)
		return false;

	if (SourceUnit.IsPanicked())
		return false;

	if (SourceUnit.IsImpaired(false))
		return false;

	if (SourceUnit.IsDead())
		return false;

	if (SourceUnit.IsIncapacitated())
		return false;

	AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
	if (AbilityState != none)
	{
		if (kAbility.GetMyTemplateName() == 'StandardShot')
		{
			if (SourceUnit.NumActionPoints() == 0)
			{
				PrimaryWeapon = SourceUnit.GetItemInSlot(eInvSlot_PrimaryWeapon);
				if (PrimaryWeapon.Ammo > 1)
				{
					SourceUnit.ReserveActionPoints.AddItem(class'X2CharacterTemplateManager'.default.OverwatchReserveActionPoint);
					NewGameState.AddStateObject(SourceUnit);
					`XEVENTMGR.TriggerEvent('ReadyForAnythingTriggered', AbilityState, SourceUnit, NewGameState);
				}
			}
		}
	}
	return false;
}