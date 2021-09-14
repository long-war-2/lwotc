class X2Effect_ReadyForAnything extends X2Effect_Persistent config(LW_AlienPack);

var config array <name> RFA_VALID_ABILITIES;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local Object EffectObj;

	EffectObj = EffectGameState;

	`XEVENTMGR.RegisterForEvent(EffectObj, 'ReadyForAnythingTriggered', RFAListener, ELD_OnStateSubmitted,,,, EffectGameState);
}
function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local XComGameState_Ability					AbilityState;

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
		if (default.RFA_VALID_ABILITIES.Find(kAbility.GetMyTemplateName()) != INDEX_NONE)
		{
			if (SourceUnit.NumActionPoints() == 0)
			{
				`XEVENTMGR.TriggerEvent('ReadyForAnythingTriggered', AbilityState, SourceUnit, NewGameState);
				
			}
		}
	}
	return false;
}



static function EventListenerReturn RFAListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_Unit UnitState;
	local StateObjectReference OverwatchRef;
	local XComGameState_Ability OverwatchState;
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local name OverwatchAbilityName;
	local X2AbilityCost Cost;
	local XComGameState_Effect EffectState;
	local bool CanUseOverwatch;
	local XComGameState_Ability AbilityState;

	AbilityState = XcomGameState_Ability(EventData);


	EffectState = XComGameState_Effect(CallbackData);
	History = `XCOMHISTORY;

	if(AbilityState.OwnerStateObject.ObjectID != EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID)
		return ELR_NoInterrupt;

	UnitState = XComGameState_Unit(GameState.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	//`log("===End turn triggered:" @ ApplyEffectParameters.SourceStateObjectRef.ObjectID $ "===",, 'NewEverVigilant');

	if (UnitState == none)
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(EffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	if (UnitState.NumAllReserveActionPoints() == 0)     //  don't activate overwatch if the unit is potentially doing another reserve action
	{
			//`log("Ever vigilant conditions satisfied",, 'NewEverVigilant');
			//`log("CHECK:" @ class'X2Effect_EverVigilant'.default.OverwatchAbilities.Length,, 'NewEverVigilant');
			foreach class'X2Effect_EverVigilant'.default.OverwatchAbilities(OverwatchAbilityName)
			{
				//`log("CHECK:" @ OverwatchAbilityName,, 'NewEverVigilant');
				OverwatchRef = UnitState.FindAbility(OverwatchAbilityName);
				if (OverwatchRef.ObjectID != 0)
				{
					//`log("has overwatch ability",, 'NewEverVigilant');
					OverwatchState = XComGameState_Ability(History.GetGameStateForObjectID(OverwatchRef.ObjectID));
					if (OverwatchState.CanActivateAbility(UnitState,, true) == 'AA_Success')
					{
						//`log("Can activate without cost",, 'NewEverVigilant');
						CanUseOverwatch = true;
						foreach OverwatchState.GetMyTemplate().AbilityCosts(Cost)
						{
							if (X2AbilityCost_ActionPoints(Cost) == none) // non action point costs
							{
								if (Cost.CanAfford(OverwatchState, UnitState) != 'AA_Success')
								{
									//`log("one of the action cost is unsaisfied",, 'NewEverVigilant');
									CanUseOverwatch = false;
									break;
								}
								//`log("1 non action cost satisfied",, 'NewEverVigilant');
							}
						}
						if (CanUseOverwatch)
							break; // Can use ability, success!
						else
						{
							//`log("Ability cost not satisfied",, 'NewEverVigilant');
							OverwatchRef.ObjectID = 0;
							OverwatchState = none; // No such ability, next
						}
					}
					else
					{
						//`log("No overwatch ability",, 'NewEverVigilant');
						OverwatchRef.ObjectID = 0;
						OverwatchState = none; // No such ability, next
					}
				}
			}		
			
			if (OverwatchState != none)
			{
				//`log("Applying ever vigilant effect and use overwatch",, 'NewEverVigilant');
				NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));
				UnitState = XComGameState_Unit(NewGameState.CreateStateObject(UnitState.Class, UnitState.ObjectID));

				if (UnitState.NumActionPoints() == 0)
				{
					//  give the unit an action point so they can activate overwatch										
					UnitState.ActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);					
				}
				
				NewGameState.AddStateObject(UnitState);
				`TACTICALRULES.SubmitGameState(NewGameState);
				//`log("===Overwatch for" @ ApplyEffectParameters.SourceStateObjectRef.ObjectID $ "===",, 'NewEverVigilant');
				return OverwatchState.AbilityTriggerEventListener_Self(EventData, EventSource, GameState, EventID, CallbackData);
			}
	}
	
	//`log("===End turn triggered ended for " @ ApplyEffectParameters.SourceStateObjectRef.ObjectID $ "===",, 'NewEverVigilant');

	return ELR_NoInterrupt;
}
