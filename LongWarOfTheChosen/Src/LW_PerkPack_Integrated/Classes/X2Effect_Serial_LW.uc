class X2Effect_Serial_LW extends X2Effect_Serial;


function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local XComGameState_Unit TargetUnit;
	local X2EventManager EventMgr;
	local XComGameState_Ability AbilityState;
	local int i;
	//  match the weapon associated with Serial to the attacking weapon
	if (kAbility.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef)
	{
		//  check for a direct kill shot
		TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
		if (TargetUnit != none && TargetUnit.IsDead())
		{
			AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
			if (AbilityState != none)
			{
				SourceUnit.ActionPoints = PreCostActionPoints;
                  for (i = 0; i < PreCostActionPoints.Length; i++)
                 {
                      SourceUnit.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
                }
				EventMgr = `XEVENTMGR;
				EventMgr.TriggerEvent('SerialKiller', AbilityState, SourceUnit, NewGameState);
				return true;
			}
			
		}
	}
	return false;
}
