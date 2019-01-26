//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    X2Ability_ToggleCommandRange.uc
//  AUTHOR:  Amineri (Long War Studio)
//  PURPOSE: Toggles Command Range for display
//---------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------- 

// CURRENTLY NOT USED -- PROBABALY WILL DEPRECATE

class X2Ability_ToggleCommandRange extends X2Ability;

//static function array<X2DataTemplate> CreateTemplates()
//{
	//local array<X2DataTemplate> Templates;
//
	//Templates.AddItem(ToggleCommandRangeAbility());
//
	//return Templates;
//}
//
//static function X2AbilityTemplate ToggleCommandRangeAbility()
//{
	//local X2AbilityTemplate             Template;
	//local X2AbilityCost_ActionPoints    ActionCost;
	//local X2Condition_BattleState       BattleCondition;
	//local X2AbilityTrigger_PlayerInput  PlayerInput;
	//local X2Effect_EnableGlobalAbility  GlobalAbility;
	//local X2Effect_Persistent           EvacDelay;
	//local X2Condition_UnitProperty      ShooterCondition;
//
	//`CREATE_X2ABILITY_TEMPLATE(Template, 'ToggleCommandRange');
//
	//Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); // Do not allow CommandRange Toggle in MP!
//
	//Template.AbilityToHitCalc = default.DeadEye;
	//Template.AbilityTargetStyle = default.SelfTarget;
	//Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_PlayerInput');
	//Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_LWOfficerCommandRange';
//
	//GlobalAbility = new class'X2Effect_EnableGlobalAbility';
	//GlobalAbility.GlobalAbility = 'ToggleCommandRange';
	//EvacDelay = new class'X2Effect_Persistent';
	//EvacDelay.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
	//EvacDelay.ApplyOnTick.AddItem(GlobalAbility);
	//Template.AddShooterEffect(EvacDelay);
	//
	//Template.Hostility = eHostility_Neutral;
//
	//Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_evac";
	//Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.EVAC_PRIORITY;
	//Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	//Template.HideErrors.AddItem('AA_AbilityUnavailable');
	//Template.AbilitySourceName = 'eAbilitySource_Commander';
//
	////Template.TargetingMethod = class'X2TargetingMethod_LWCommandRange'; Class no longer exists
//
	////NOTE: This ability does not require a build game state function because this is handled
	////      by the event listener and associated functionality when creating world tile effects
	//Template.BuildNewGameStateFn = Empty_BuildGameState;
	//Template.BuildVisualizationFn = ToggleCommandRange_BuildVisualization;
//
	//Template.bCommanderAbility = true; 
//
	//return Template;
//}
//
//function XComGameState Empty_BuildGameState( XComGameStateContext Context )
//{
	//return none;
//}
//
//
//simulated function ToggleCommandRange_BuildVisualization(XComGameState VisualizeGameState)
//{
	//local XComGameStateHistory History;
	//local XComGameStateContext_Ability  Context;
	//local StateObjectReference          InteractingUnitRef;
	//local XComGameState_Ability         Ability;
//
	//local VisualizationActionMetadata   EmptyTrack;
	//local VisualizationActionMetadata   BuildTrack;
//
	//local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
//
	//History = `XCOMHISTORY;
//
	//Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	//InteractingUnitRef = Context.InputContext.SourceObject;
//
	////Configure the visualization track for the shooter
	////****************************************************************************************
	//BuildTrack = EmptyTrack;
	//BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	//BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	//BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);
					//
	//Ability = XComGameState_Ability(History.GetGameStateForObjectID(Context.InputContext.AbilityRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1));
	//SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext(), false, BuildTrack.LastActionAdded));
	//SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Ability.GetMyTemplate().LocFlyOverText, '', eColor_Good);
//}
//
