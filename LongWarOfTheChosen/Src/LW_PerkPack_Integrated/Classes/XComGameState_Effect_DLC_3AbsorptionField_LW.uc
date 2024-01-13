class XComGameState_Effect_DLC_3AbsorptionField_LW extends XComGameState_Effect_DLC_3AbsorptionField
	config(GameData_SoldierSkills);


function EventListenerReturn AbilityActivatedListener(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Ability AbilityState;
	local XComGameState_Unit UnitState;
	local XComGameState NewGameState;
	local XComGameState_Effect_DLC_3AbsorptionField NewEffectState;
	local XComGameStateHistory History;
	local XComGameState_Item SourceWeapon;
	local bool bRedirected;
	local int i;

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if (AbilityContext != none && AbilityContext.InterruptionStatus != eInterruptionStatus_Interrupt)
	{
		//  screw the ability list, check for hostility instead, which it does below already.
		/*if (default.AbsorbedAbilities.Find(AbilityContext.InputContext.AbilityTemplateName) == INDEX_NONE)
			return ELR_NoInterrupt;
		*/

		//  check for redirection 
		for (i = 0; i < AbilityContext.ResultContext.EffectRedirects.Length; ++i)
		{
			if (AbilityContext.ResultContext.EffectRedirects[i].RedirectedToTargetRef.ObjectID == ApplyEffectParameters.TargetStateObjectRef.ObjectID)
			{
				if (AbilityContext.ResultContext.EffectRedirects[i].OriginalTargetRef.ObjectID == AbilityContext.InputContext.PrimaryTarget.ObjectID)
				{
					bRedirected = true;
					break;
				}
			}
		}
		//  check for being shot at
		if (bRedirected || (AbilityContext.InputContext.PrimaryTarget.ObjectID == ApplyEffectParameters.TargetStateObjectRef.ObjectID))
		{
			AbilityState = XComGameState_Ability(EventData);
			if (AbilityState != none && AbilityState.GetMyTemplate().Hostility == eHostility_Offensive)
			{
				History = `XCOMHISTORY;
				UnitState = XComGameState_Unit(GameState.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
				if (UnitState == none)
					UnitState = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
				if (UnitState != none && UnitState.IsAlive())
				{
					NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Absorption Field - Energy Absorbed");
					NewEffectState = XComGameState_Effect_DLC_3AbsorptionField(NewGameState.ModifyStateObject(Class, ObjectID));
					NewEffectState.EnergyAbsorbed++;
					//  add new unit and ability state for visualization
					UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(UnitState.Class, UnitState.ObjectID));
					//  get the absorption field ability, not the attacking ability
					AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
					`assert(AbilityState != None);
					AbilityState = XComGameState_Ability(NewGameState.ModifyStateObject(AbilityState.Class, AbilityState.ObjectID));
					XComGameStateContext_ChangeContainer(NewGameState.GetContext()).BuildVisualizationFn = TriggerAbilityFlyoverVisualizationFn;
					NewGameState.GetContext().SetDesiredVisualizationBlockIndex(GameState.HistoryIndex);
					`TACTICALRULES.SubmitGameState(NewGameState);
				}
			}
		}
		/*
		//  check for shooting
		else if (AbilityContext.InputContext.SourceObject.ObjectID == ApplyEffectParameters.TargetStateObjectRef.ObjectID)
		{
			AbilityState = XComGameState_Ability(EventData);
			SourceWeapon = AbilityState.GetSourceWeapon();
			if (SourceWeapon != none && SourceWeapon.InventorySlot == eInvSlot_PrimaryWeapon)
			{
				//  reduce energy in the event of a miss.
				//  a hit will reduce energy once the bonus damage has been added.
				if (AbilityContext.IsResultContextMiss())
				{
					NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Absorption Field - Energy Expended on Miss");
					NewEffectState = XComGameState_Effect_DLC_3AbsorptionField(NewGameState.ModifyStateObject(Class, ObjectID));
					NewEffectState.EnergyAbsorbed = 0;
					NewEffectState.LastEnergyExpendedContext = AbilityContext;
					`TACTICALRULES.SubmitGameState(NewGameState);
				}
			}
		}
		*/
	}

	return ELR_NoInterrupt;
}