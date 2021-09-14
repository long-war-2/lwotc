class X2Effect_DisarmRocket extends X2Effect_RemoveEffects dependson(X2Condition_RocketArmedCheck);

//	This effect will disarm this rocket, if it was armed previously

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit		UnitState;
	
	UnitState = XComGameState_Unit(kNewTargetState);
	
	if (UnitState != none)
	{
		DisarmThisRocketForUnit(UnitState, ApplyEffectParameters.ItemStateObjectRef.ObjectID);

		// If this rocket was a Nuke, then also Cleanse the tracking effect.
		if (class'X2Rocket_Nuke'.static.IsNuke(ApplyEffectParameters.ItemStateObjectRef.ObjectID)) 
		{
			EffectNamesToRemove.AddItem('IRI_Nuke_Armed_Effect');
		}

		super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
	}
}

public static function DisarmThisRocketForUnit(out XComGameState_Unit UnitState, int ObjectID)
{	
	local EArmedRocketStatus		RocketStatus;
	local int						TempArmedRocketObjectID;

	RocketStatus = class'X2Condition_RocketArmedCheck'.static.GetRocketArmedStatus(UnitState, ObjectID);
		
	switch (RocketStatus)
	{
		//	This rocket is Armed and it was Armed this turn. 
		//	Clear both Unit Values.
		case eRocketArmed_ArmedPermAndTemp:
			UnitState.ClearUnitValue(class'X2Effect_ArmRocket'.default.UnitValueName);
			UnitState.ClearUnitValue(class'X2Effect_ArmRocket'.default.ArmedThisTurnUnitValueName);
			return;

		//	This rocket was armed during one of the previous turns.
		//	Disarm it, then check if the soldier has a rocket that was Armed this turn. If there is one, make it Armed permanently.
		case eRocketArmed_ArmedPerm:
			UnitState.ClearUnitValue(class'X2Effect_ArmRocket'.default.UnitValueName);

			TempArmedRocketObjectID = GetTempArmedRocketObjectID(UnitState);
			if (TempArmedRocketObjectID > 0)
			{
				UnitState.SetUnitFloatValue(class'X2Effect_ArmRocket'.default.UnitValueName, TempArmedRocketObjectID, eCleanup_BeginTactical);
			}
			return;

		//	This rocket was Armed just this turn, and likely Given to this soldier by another soldier. 
		case eRocketArmed_ArmedTemp:
			UnitState.ClearUnitValue(class'X2Effect_ArmRocket'.default.ArmedThisTurnUnitValueName);
			return;

		default:
			return;
	}
}

private static function int GetTempArmedRocketObjectID(XComGameState_Unit UnitState)
{
	local UnitValue UV;

	if (UnitState.GetUnitValue(class'X2Effect_ArmRocket'.default.ArmedThisTurnUnitValueName, UV))
	{
		return UV.fValue;
	}
	return -1;
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, name EffectApplyResult)
{
	local X2Action_UpdateFOW FOWUpdate;

	super.AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, EffectApplyResult);

	if( (EffectApplyResult == 'AA_Success') &&
		(XComGameState_Unit(ActionMetadata.StateObject_NewState) != none) )
	{
		FOWUpdate = X2Action_UpdateFOW(class'X2Action_UpdateFOW'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext() , false, ActionMetadata.LastActionAdded));
		FOWUpdate.ForceUpdate = true;
	}
}


defaultproperties
{
	bCleanse = true
	EffectNamesToRemove(0)="IRI_Rocket_Reveal_FoW_Effect"
}

/*
simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local X2Action_PlaySoundAndFlyOver	SoundAndFlyOver;
	local XComGameStateContext_Ability  Context;
	local XComGameState_Item			ItemState;
	local X2RocketTemplate				RocketTemplate;
	local X2Action_PlayEffect			PlayParticleEffectAction;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

	ItemState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(Context.InputContext.ItemObject.ObjectID));

	RocketTemplate = X2RocketTemplate(ItemState.GetMyTemplate());

	PlayParticleEffectAction = X2Action_PlayEffect(class'X2Action_PlayEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
	PlayParticleEffectAction.EffectName = "IRI_RocketLaunchers.PFX.Armed_Rocket_Blinking";
	PlayParticleEffectAction.AttachToSocketName = 'RocketClip1';
	PlayParticleEffectAction.AttachToUnit = true;
	PlayParticleEffectAction.bStopEffect = true;

	super.AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, EffectApplyResult);
}*/