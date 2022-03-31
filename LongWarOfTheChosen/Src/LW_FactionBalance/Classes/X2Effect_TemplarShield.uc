class X2Effect_TemplarShield extends X2Effect_EnergyShield;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit UnitState;
	local int ShieldStrength;

	UnitState = XComGameState_Unit(kNewTargetState);
	ShieldStrength = GetShieldStrength(UnitState, NewGameState);
	if (UnitState != none)
	{
		m_aStatChanges.Length = 0;
		AddPersistentStatChange(eStat_ShieldHP, ShieldStrength);
	}

		UnitState.SetUnitFloatValue('TemplarShieldHP', ShieldStrength, eCleanup_BeginTactical);
		UnitState.SetUnitFloatValue('PreTemplarShieldHP', UnitState.GetCurrentStat(eStat_ShieldHP), eCleanup_BeginTactical);
	
	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local int TemplarGrantedShieldHP, PreTemplarShieldHP, PreRemovalShieldHP, FullyShieldedHP, ShieldHPDamage, NewShieldHP;
	local XComGameState_Unit UnitState;
	local UnitValue TemplarShieldShieldHP, OtherShieldHP;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	PreRemovalShieldHP = UnitState.GetCurrentStat(eStat_ShieldHP);

	super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	UnitState.GetUnitValue('TemplarShieldHP', TemplarShieldShieldHP);
	UnitState.GetUnitValue('PreTemplarShieldHP', OtherShieldHP);
	TemplarGrantedShieldHP = int(TemplarShieldShieldHP.fValue);		// How many you got
	PreTemplarShieldHP = int(OtherShieldHP.fValue);				// how many you had
	FullyShieldedHP = PreTemplarShieldHP + TemplarGrantedShieldHP;
	//ShieldHP = UnitState.GetCurrentStat(eStat_ShieldHP);						// how many you have now

	ShieldHPDamage = FullyShieldedHP - PreRemovalShieldHP;
	if (ShieldHPDamage > 0 && PreTemplarShieldHP > 0 && ShieldHPDamage < FullyShieldedHP)
	{
		NewShieldHP = Clamp(PreTemplarShieldHP + TemplarGrantedShieldHP - ShieldHPDamage, 0, PreTemplarShieldHP);
		UnitState = XComGameState_Unit(NewGameState.CreateStateObject(UnitState.Class, UnitState.ObjectID));
		UnitState.SetCurrentStat(estat_ShieldHP, NewShieldHP);
		NewGameState.AddStateObject(UnitState);
	}
}

private function OnShieldRemoved_BuildVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local X2Action_PlayAnimation		PlayAnimation;
	local XGUnit						Unit;
	local XComUnitPawn					UnitPawn;

	// Exit if the effect did not expire naturally.
	// We don't want the animation to play here if the effect was removed by damage, visualization for that is handled elsewhere.
	if (XComGameStateContext_TickEffect(VisualizeGameState.GetContext()) == none)
		return;

	Unit = XGUnit(ActionMetadata.VisualizeActor);
	if (Unit != none && Unit.IsAlive())
	{
		UnitPawn = Unit.GetPawn();
		if (UnitPawn != none && UnitPawn.GetAnimTreeController().CanPlayAnimation('HL_Shield_Fold'))
		{
			PlayAnimation = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
			PlayAnimation.Params.AnimName = 'HL_Shield_Fold';
			PlayAnimation.Params.BlendTime = 0.3f;
		}
	}
}

static final function bool WasUnitFullyProtected(const XComGameState_Unit OldUnitState, const XComGameState_Unit NewUnitState)
{
	local UnitValue PreAblativeValue;

	NewUnitState.GetUnitValue('PreTemplarShieldHP',PreAblativeValue);

	//`LOG(GetFuncName() @ OldUnitState.GetFullName(),, 'TemplarParryRework');
	//`LOG("Old HP:" @ OldUnitState.GetCurrentStat(eStat_HP),, 'TemplarParryRework');
	//`LOG("New HP:" @ NewUnitState.GetCurrentStat(eStat_HP),, 'TemplarParryRework');
	//`LOG("Unit fully protected:" @ NewUnitState.GetCurrentStat(eStat_HP) >= OldUnitState.GetCurrentStat(eStat_HP),, 'TemplarParryRework');

	// Bleeding out check is required, because if the unit had 1 HP before the attack that made them start bleeding out, they will still have 1 HP while bleeding out.
	return NewUnitState.GetCurrentStat(eStat_HP) >= OldUnitState.GetCurrentStat(eStat_HP) && !NewUnitState.IsBleedingOut() && NewUnitState.GetCurrentStat(eStat_ShieldHP) >= PreAblativeValue.fvalue;
}

static final function bool WasShieldFullyConsumed(const XComGameState_Unit OldUnitState, const XComGameState_Unit NewUnitState)
{
	local UnitValue PreAblativeValue;

	NewUnitState.GetUnitValue('PreTemplarShieldHP',PreAblativeValue);

	return NewUnitState.GetCurrentStat(eStat_ShieldHP) <= PreAblativeValue.fvalue;
}

static final function int GetShieldStrength(const XComGameState_Unit UnitState, XComGameState CheckGameState)
{
	local XComGameState_Item	ItemState;
	local X2WeaponTemplate		WeaponTemplate;
	local int					Index;

	ItemState = UnitState.GetItemInSlot(eInvSlot_PrimaryWeapon, CheckGameState);
	if (ItemState == none)
		return 0;

	WeaponTemplate = X2WeaponTemplate(ItemState.GetMyTemplate());
	if (WeaponTemplate == none)
		return 0;

	Index = WeaponTemplate.ExtraDamage.Find('Tag', 'IRI_TemplarShield');
	if (Index == INDEX_NONE)
		return 0;

	return WeaponTemplate.ExtraDamage[Index].Damage;
}


function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;

	super.RegisterForEvents(EffectGameState);

	EventMgr = `XEVENTMGR;
	EffectObj = EffectGameState;

	EventMgr.RegisterForEvent(EffectObj, 'OverrideHitEffects', TemplarShield_OnOverrideHitEffects, ELD_Immediate, 40);
	EventMgr.RegisterForEvent(EffectObj, 'OverrideMetaHitEffect', TemplarShield_OnOverrideMetaHitEffect, ELD_Immediate, 40);

	// Has to be ELD_Immediate so that we can get the target Unit State from History before the ability has gone through and see if it had the Templar Shield effect.
	EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', TemplarShield_OnAbilityActivated, ELD_Immediate, 50, /*pre filter object*/,, /* callback data*/);
}


// Requires CHL Issue #1114 - create psionic flashes when projectiles hit the shield.
private static function EventListenerReturn TemplarShield_OnOverrideHitEffects(Object EventData, Object EventSource, XComGameState NullGameState, Name Event, Object CallbackData)
{
    local XComUnitPawn				Pawn;
    local XComLWTuple				Tuple;
	local XComAnimTreeController	AnimTreeController;

    Pawn = XComUnitPawn(EventSource);
	if (Pawn == none)
		return ELR_NoInterrupt;

	AnimTreeController = Pawn.GetAnimTreeController();
	if (AnimTreeController == none)
		return ELR_NoInterrupt;

	// If the pawn is currently playing one of these animations, it means the psionic shield is absorbing projectiles,
	// and the unit is not being wounded.
	if (AnimTreeController.IsPlayingCurrentAnimation('HL_Shield_Absorb') ||
		AnimTreeController.IsPlayingCurrentAnimation('HL_Shield_AbsorbAndFold'))
	{
		Tuple = XComLWTuple(EventData);
		if (Tuple == none)
			return ELR_NoInterrupt;

		Tuple.Data[0].b = false;		// Setting to *not* override the Hit Effect, cuz we want it to play.
										// Just in case some other listener disabled it.
		Tuple.Data[7].i = eHit_Reflect; // HitResult - Using eHit_Reflect to make hit effects spawn on the left hand. Purely visual change and only for this Hit Effect.
	}

    return ELR_NoInterrupt;
}

// Requires CHL Issue #1116 - remove blood gushing out of the target unit when projectiles hit the shield.
private static function EventListenerReturn TemplarShield_OnOverrideMetaHitEffect(Object EventData, Object EventSource, XComGameState NullGameState, Name Event, Object CallbackData)
{
    local XComUnitPawn				Pawn;
    local XComLWTuple				Tuple;
	local XComAnimTreeController	AnimTreeController;

    Pawn = XComUnitPawn(EventSource);
	if (Pawn == none)
		return ELR_NoInterrupt;

	AnimTreeController = Pawn.GetAnimTreeController();
	if (AnimTreeController == none)
		return ELR_NoInterrupt;

	if (AnimTreeController.IsPlayingCurrentAnimation('HL_Shield_Absorb') ||
		AnimTreeController.IsPlayingCurrentAnimation('HL_Shield_AbsorbAndFold'))
	{
		Tuple = XComLWTuple(EventData);
		if (Tuple == none)
			return ELR_NoInterrupt;

		Tuple.Data[0].b = false;
		Tuple.Data[5].i = eHit_Reflect;
	}

    return ELR_NoInterrupt;
}

private static function EventListenerReturn TemplarShield_OnAbilityActivated(Object EventData, Object EventSource, XComGameState NewGameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability	AbilityContext;
	local XComGameState_Unit			TargetUnit;
	local StateObjectReference			UnitRef;
	local XComGameStateHistory			History;
		
	AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());
	if (AbilityContext == none || AbilityContext.InterruptionStatus == eInterruptionStatus_Interrupt)
		return ELR_NoInterrupt;

	// Insert a Post Build Vis delegate whenever an ability targets a unit affected by Templar Shield

	History = `XCOMHISTORY;

	TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
	if (TargetUnit != none && TargetUnit.IsUnitAffectedByEffectName(class'X2Effect_TemplarShield'.default.EffectName))
	{
		if (AbilityContext.PostBuildVisualizationFn.Find(ReplaceHitAnimation_PostBuildVis) == INDEX_NONE)
		{
			AbilityContext.PostBuildVisualizationFn.AddItem(ReplaceHitAnimation_PostBuildVis);
		}
	}
	else
	{
		foreach AbilityContext.InputContext.MultiTargets(UnitRef)
		{
			TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));
			if (TargetUnit != none && TargetUnit.IsUnitAffectedByEffectName(class'X2Effect_TemplarShield'.default.EffectName))
			{
				if (AbilityContext.PostBuildVisualizationFn.Find(ReplaceHitAnimation_PostBuildVis) == INDEX_NONE)
				{
					AbilityContext.PostBuildVisualizationFn.AddItem(ReplaceHitAnimation_PostBuildVis);
				}
				break;
			}
		}
	}
		
	return ELR_NoInterrupt;
}

// This function alters the visualization tree for units affected by the Templar Shield effect when they are attacked.
private static function ReplaceHitAnimation_PostBuildVis(XComGameState VisualizeGameState)
{
	local XComGameStateContext_Ability						AbilityContext;
	local XComGameStateVisualizationMgr						VisMgr;
	local array<X2Action>									FindActions;
	local X2Action											FindAction;
	local X2Action											ChildAction;
	local VisualizationActionMetadata						ActionMetadata;
	local XComGameState_Unit								OldUnitState;
	local XComGameState_Unit								NewUnitState;
	local X2Action_ApplyWeaponDamageToUnit					DamageAction;
	local X2Action_PlayAnimation							AdditionalAnimationAction;
	local X2Action_TemplarShield_ApplyWeaponDamageToUnit	ReplaceAction;
	local X2Action_MarkerNamed								EmptyAction;
	local X2Action											ParentAction;
	local array<X2Action>									ExitCoverActions;
	local array<X2Action>									ExitCoverParentActions;
	local array<X2Action>									FireActions;
	local X2Action_PlayAnimation							PlayAnimation;
	local name												InputEvent;
	local X2Action_MoveTurn									MoveTurnAction;
	local XComGameState_Unit								SourceUnit;
	local XComGameState_Ability								AbilityState;
	local array<int>										HandledUnits;
	local X2AbilityTemplate									AbilityTemplate;
	local XComGameStateHistory								History;
	local X2Action											CycleAction;
	local X2Action_TimedWait								TimedWait;
	local bool												bGrenadeLikeAbility;
	local bool												bAreaTargetedAbility;
	local X2Action_WaitForAnotherAction						WaitForAction;
	local array<X2Action>									WaitForActions;
	local array<X2Action>									DamageUnitActions;

	AbilityContext = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	if (AbilityContext == none)
		return;

	History = `XCOMHISTORY;
	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
	if (AbilityState == none)
		return;

	AbilityTemplate = AbilityState.GetMyTemplate();
	if (AbilityTemplate == none)
		return;

	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
	if (SourceUnit == none)
		return;

	if (AbilityContext.InputContext.TargetLocations.Length > 0 && ClassIsChildOf(AbilityTemplate.TargetingMethod, class'X2TargetingMethod_Grenade'))
	{
		bAreaTargetedAbility = true;
		bGrenadeLikeAbility = AbilityTemplate.TargetingMethod.static.UseGrenadePath();	
	}
	
	// Cycle through all Damage Unit actions created by the ability. If the ability affected multiple units, all of them will be covered.
	// This is a bit noodly. Rather than cycling through units present in this game state, or getting them from the game state by their ObjectID recorded in Context,
	// we iterate over Damage Unit actions directly, since ultimately this is what we need to interact with.
	VisMgr = `XCOMVISUALIZATIONMGR;
	VisMgr.GetNodesOfType(VisMgr.BuildVisTree, class'X2Action_ApplyWeaponDamageToUnit', FindActions);
	foreach FindActions(FindAction)
	{
		ActionMetadata = FindAction.Metadata;
		OldUnitState = XComGameState_Unit(ActionMetadata.StateObject_OldState); // Unit State as it was before they were hit by the attack.
		NewUnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);

		if (OldUnitState == none || NewUnitState == none || HandledUnits.Find(OldUnitState.ObjectID) != INDEX_NONE)
			continue;

		HandledUnits.AddItem(OldUnitState.ObjectID); // Use a tracking array to make sure each unit's visualization is adjusted only once.

		if (!OldUnitState.IsUnitAffectedByEffectName(class'X2Effect_TemplarShield'.default.EffectName)) // Check the old unit state specifically, as the attack could have removed the effect from the target.
			continue;

		// Gather various action arrays we will need.
		DamageAction = X2Action_ApplyWeaponDamageToUnit(FindAction);

		// We might need all Damage Unit actions relevant to this unit later.
		DamageUnitActions.Length = 0;
		VisMgr.GetNodesOfType(VisMgr.BuildVisTree, class'X2Action_ApplyWeaponDamageToUnit', DamageUnitActions,, OldUnitState.ObjectID);

		// Parents of the Damage Unit action are Fire Actions (normally should be only one)
		FireActions = DamageAction.ParentActions;

		// Parents of the Fire Action are Exit Cover Actions (normally should be only one)
		ExitCoverActions.Length = 0;
		foreach FireActions(CycleAction)
		{
			foreach CycleAction.ParentActions(ParentAction)
			{
				ExitCoverActions.AddItem(ParentAction);
			}
		}
		ExitCoverParentActions.Length = 0;
		foreach ExitCoverActions(CycleAction)
		{
			foreach CycleAction.ParentActions(ParentAction)
			{
				ExitCoverParentActions.AddItem(ParentAction);
			}
		}

		// #1. START. Insert a Move Turn action to force the target unit to face the danger. 
		if (bAreaTargetedAbility) // If the ability is area-targeted, like a grenade throw, then face the target location (the epicenter of the explosion)
		{
			MoveTurnAction = X2Action_MoveTurn(class'X2Action_MoveTurn'.static.AddToVisualizationTree(ActionMetadata, AbilityContext, false,, ExitCoverParentActions));
			MoveTurnAction.m_vFacePoint = AbilityContext.InputContext.TargetLocations[0];
		}
		else // Otherwise face the attacker.
		{	 // In this case Move Turn action is specifically inserted between Exit Cover's parents and Exit Cover itself,
			 // so Exit Cover won't begin playing until Move Turn action finishes.
			 // This is necessary because some Fire Actions take very little time between the Fire Action starting and damage hitting the target, 
			 // so we have to make sure the target unit is already facing the source when the Fire Action begins.
			MoveTurnAction = X2Action_MoveTurn(class'X2Action_MoveTurn'.static.AddToVisualizationTree(ActionMetadata, AbilityContext, true,, ExitCoverParentActions));
			MoveTurnAction.m_vFacePoint = `XWORLD.GetPositionFromTileCoordinates(SourceUnit.TileLocation);
		}

		// Keep the target unit's visualizer occupied after turning is finished and until Exit Cover begins. This is done to prevent Idle State Machine from turning the unit away.
		WaitForActions.Length = 0;
		foreach ExitCoverActions(CycleAction)
		{
			WaitForAction = X2Action_WaitForAnotherAction(class'X2Action_WaitForAnotherAction'.static.AddToVisualizationTree(ActionMetadata, AbilityContext, false, MoveTurnAction));
			WaitForAction.ActionToWaitFor = CycleAction;
			WaitForActions.AddItem(WaitForAction);
		}
		// #1. END.

		// #2. START. Insert a Play Animation action for "unit shields themselves from the attack" animation.
		// If this ability uses a grenade path, it may take a while for the projectile to arrive to the target, so delay the animation action by amount of time that scales with distance between them.
			// For the animation to look smooth, at least 0.25 seconds must pass between Additional Animation starting playing and projectiles hitting the target,
			// but no more than 2 seconds, as shield is put away at that point.
			// Grenade takes 1.5 seconds to fly 10 tiles and explode after being thrown, though this doesn't take throw animation time into account.
		// This delay is added on top of the variable amount of time required for the Move Turn action. 
		if (bGrenadeLikeAbility)
		{
			//`LOG("Ability uses grenade path, inserting delay action for:" @ 0.05f * SourceUnit.TileDistanceBetween(NewUnitState) @ "seconds.",, 'TemplarParryRework');
			TimedWait = X2Action_TimedWait(class'X2Action_TimedWait'.static.AddToVisualizationTree(ActionMetadata, AbilityContext, false,, WaitForActions));
			TimedWait.DelayTimeSec = 0.075f * SourceUnit.TileDistanceBetween(NewUnitState); // So 0.75 second delay at 10 tile distance.

			AdditionalAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, AbilityContext,, TimedWait));
		}
		else
		{
			AdditionalAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, AbilityContext,,, WaitForActions));
		}
		AdditionalAnimationAction.Params.AnimName = 'HL_Shield_Absorb';

		// Make child actions of the original Damage Unit action become children of the animation action.
		foreach DamageAction.ChildActions(ChildAction)
		{
			VisMgr.ConnectAction(ChildAction, VisMgr.BuildVisTree, false, AdditionalAnimationAction);
		}
		// #2. END

		// If the attack missed, we stop here.
		// Note: this may need to be adjusted, because grazes count as a hit.
		if (!WasUnitHit(AbilityContext, OldUnitState.ObjectID))
		{
			continue;
		}

		// #3. START. 
		// If the unit did not receive health damage during this attack (i.e. shield took all the damage), then we don't need this unit to play any "unit was hit" animations.
		// So we replace all original Damage Unit actions for this unit with a custom version that does not play any animations,
		// and it also plays a different voiceover, since the attack, even if it damages shield HP, doesn't have a negative effect on the soldier.
		// Otherwise it functions identically and can do stuff like showing flyover.
		if (class'X2Effect_TemplarShield'.static.WasUnitFullyProtected(OldUnitState, NewUnitState))
		{
			foreach DamageUnitActions(CycleAction)
			{
				DamageAction = X2Action_ApplyWeaponDamageToUnit(CycleAction);
				ReplaceAction = X2Action_TemplarShield_ApplyWeaponDamageToUnit(class'X2Action_TemplarShield_ApplyWeaponDamageToUnit'.static.AddToVisualizationTree(ActionMetadata, AbilityContext,,, DamageAction.ParentActions));
				CopyActionProperties(ReplaceAction, DamageAction);

				foreach DamageAction.ChildActions(ChildAction)
				{
					VisMgr.ConnectAction(ChildAction, VisMgr.BuildVisTree, false, ReplaceAction);
				}

				// Nuke the original action out of the tree.
				EmptyAction = X2Action_MarkerNamed(class'X2Action'.static.CreateVisualizationActionClass(class'X2Action_MarkerNamed', DamageAction.StateChangeContext));
				EmptyAction.SetName("ReplaceDamageUnitAction");
				VisMgr.ReplaceNode(EmptyAction, DamageAction);
			}

			// If unit didn't take any damage, but the shield was fully depleted by the attack, then play a different "absorb damage" animation that puts the shield away at the end.
			if (class'X2Effect_TemplarShield'.static.WasShieldFullyConsumed(OldUnitState, NewUnitState))
			{	
				AdditionalAnimationAction.Params.AnimName = 'HL_Shield_AbsorbAndFold';
			}
		}
		else if (class'X2Effect_TemplarShield'.static.WasShieldFullyConsumed(OldUnitState, NewUnitState))
		{	 
			// If the unit did in fact take some health damage despite being shielded (i.e. damage broke through the shield),
			// Then we keep the original Damage Unit action in the tree. Its "unit hit" animation will interrupt the "absorb damage" animation from the additional action
			// whenever the attack connects with the unit.
			// We check the shield is actually gone, because the additive animation will stop the particle effect, hiding the shield from the unit.
			// In theory the unit can take health damage without the shield being broken.

			// Play an additive animation with particle effects of the shield blowing up at the same time as the unit being hit.
			PlayAnimation = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, AbilityContext,,, FireActions));
			PlayAnimation.Params.AnimName = 'ADD_Shield_Explode';
			PlayAnimation.Params.Additive = true;

			// Make this additive animation respond to the same input events as the damage action, so it plays when projectiles hit the unit.
			PlayAnimation.ClearInputEvents();
			foreach DamageAction.InputEventIDs(InputEvent)
			{
				PlayAnimation.AddInputEvent(InputEvent);
			}		

			foreach DamageAction.ChildActions(ChildAction)
			{
				VisMgr.ConnectAction(ChildAction, VisMgr.BuildVisTree, false, PlayAnimation);
			}
		}
		// #3. END
	}
}

// X2Action::Init() runs right before action starts playing, so we can't get this info from the action itself.
private static function bool WasUnitHit(const XComGameStateContext_Ability AbilityContext, const int ObjectID)
{
	local int Index;

	if (AbilityContext.InputContext.PrimaryTarget.ObjectID == ObjectID)
	{
		return AbilityContext.IsResultContextHit();
	}

	Index = AbilityContext.InputContext.MultiTargets.Find('ObjectID', ObjectID);
	if (Index != INDEX_NONE)
	{
		return AbilityContext.IsResultContextMultiHit(Index);
	}
	return false;
}

private static function CopyActionProperties(out X2Action_TemplarShield_ApplyWeaponDamageToUnit ReplaceAction, out X2Action_ApplyWeaponDamageToUnit DamageAction)
{
	ReplaceAction.AbilityTemplate = DamageAction.AbilityTemplate;
	ReplaceAction.DamageDealer = DamageAction.DamageDealer;
	ReplaceAction.SourceUnitState = DamageAction.SourceUnitState;
	ReplaceAction.m_iDamage = DamageAction.m_iDamage;
	ReplaceAction.m_iMitigated = DamageAction.m_iMitigated;
	ReplaceAction.m_iShielded = DamageAction.m_iShielded;
	ReplaceAction.m_iShredded = DamageAction.m_iShredded;
	ReplaceAction.DamageResults = DamageAction.DamageResults;
	ReplaceAction.HitResults = DamageAction.HitResults;
	ReplaceAction.DamageTypeName = DamageAction.DamageTypeName;
	ReplaceAction.m_vHitLocation = DamageAction.m_vHitLocation;
	ReplaceAction.m_vMomentum = DamageAction.m_vMomentum;
	ReplaceAction.bGoingToDeathOrKnockback = DamageAction.bGoingToDeathOrKnockback;
	ReplaceAction.bWasHit = DamageAction.bWasHit;
	ReplaceAction.bWasCounterAttack = DamageAction.bWasCounterAttack;
	ReplaceAction.bCounterAttackAnim = DamageAction.bCounterAttackAnim;
	ReplaceAction.AbilityContext = DamageAction.AbilityContext;
	ReplaceAction.AnimParams = DamageAction.AnimParams;
	ReplaceAction.HitResult = DamageAction.HitResult;
	ReplaceAction.TickContext = DamageAction.TickContext;
	ReplaceAction.AreaDamageContext = DamageAction.AreaDamageContext;
	ReplaceAction.FallingContext = DamageAction.FallingContext;
	ReplaceAction.WorldEffectsContext = DamageAction.WorldEffectsContext;
	ReplaceAction.TickIndex = DamageAction.TickIndex;
	ReplaceAction.PlayingSequence = DamageAction.PlayingSequence;
	ReplaceAction.OriginatingEffect = DamageAction.OriginatingEffect;
	ReplaceAction.AncestorEffect = DamageAction.AncestorEffect;
	ReplaceAction.bHiddenAction = DamageAction.bHiddenAction;
	ReplaceAction.CounterAttackTargetRef = DamageAction.CounterAttackTargetRef;
	ReplaceAction.bDoOverrideAnim = DamageAction.bDoOverrideAnim;
	ReplaceAction.OverrideOldUnitState = DamageAction.OverrideOldUnitState;
	ReplaceAction.OverridePersistentEffectTemplate = DamageAction.OverridePersistentEffectTemplate;
	ReplaceAction.OverrideAnimEffectString = DamageAction.OverrideAnimEffectString;
	ReplaceAction.bPlayDamageAnim = DamageAction.bPlayDamageAnim;
	ReplaceAction.bIsUnitRuptured = DamageAction.bIsUnitRuptured;
	ReplaceAction.bShouldContinueAnim = DamageAction.bShouldContinueAnim;
	ReplaceAction.bMoving = DamageAction.bMoving;
	ReplaceAction.bSkipWaitForAnim = DamageAction.bSkipWaitForAnim;
	ReplaceAction.RunningAction = DamageAction.RunningAction;
	ReplaceAction.HitReactDelayTimeToDeath = DamageAction.HitReactDelayTimeToDeath;
	ReplaceAction.UnitState = DamageAction.UnitState;
	ReplaceAction.GroupState = DamageAction.GroupState;
	ReplaceAction.ScanGroup = DamageAction.ScanGroup;
	ReplaceAction.ScanUnit = DamageAction.ScanUnit;
	ReplaceAction.kPerkContent = DamageAction.kPerkContent;
	ReplaceAction.TargetAdditiveAnims = DamageAction.TargetAdditiveAnims;
	ReplaceAction.bShowFlyovers = DamageAction.bShowFlyovers;
	ReplaceAction.bCombineFlyovers = DamageAction.bCombineFlyovers;
	ReplaceAction.EffectHitEffectsOverride = DamageAction.EffectHitEffectsOverride;
	ReplaceAction.CounterattackedAction = DamageAction.CounterattackedAction;
}


defaultproperties
{
	EffectName = "IRI_TemplarShield_Effect"
	EffectRemovedVisualizationFn = OnShieldRemoved_BuildVisualization
}
