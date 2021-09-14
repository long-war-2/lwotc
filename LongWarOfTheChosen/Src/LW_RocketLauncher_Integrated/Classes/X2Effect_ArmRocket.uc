class X2Effect_ArmRocket extends X2Effect;

// Primary unit value, it's used to track rockets Armed by the soldier on the previous turns. It lasts until the end of tactical.
var const name UnitValueName;

//	Secondary unit value. It's used to trick rockets that were armed this turn specifically. It lasts until the end of turn.
//	It's used by X2Effect Give Rocket so that if a soldier arms a rocket this turn, and then passes it to another soldier, the rocket will remain armed.
//	So if the rocket armed this turn is passed to a rocketeer, they can fire it right away, without having to arm it themselves.
//	For Nukes, lasts until end of tactical, so they can remain Armed even if Given on the following turns.
var const name ArmedThisTurnUnitValueName;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(kNewTargetState);
	
	if (UnitState != none)
	{
		//	disarm previously armed rocket, if any
		UnitState.ClearUnitValue(UnitValueName);
		UnitState.ClearUnitValue(ArmedThisTurnUnitValueName);

		ArmThisRocketForUnit(UnitState, ApplyEffectParameters.ItemStateObjectRef.ObjectID);
	}
}

public static function ArmThisRocketForUnit(out XComGameState_Unit UnitState, int ObjectID)
{	
	//	If the rocket that is being Armed is a Tactical Nuke, then Arm it permanently.
	if (class'X2Rocket_Nuke'.static.IsNuke(ObjectID))
	{
		UnitState.SetUnitFloatValue(default.UnitValueName, ObjectID, eCleanup_BeginTactical);
		UnitState.SetUnitFloatValue(default.ArmedThisTurnUnitValueName, ObjectID, eCleanup_BeginTactical);
	}
	else	//	If the rocket is not a Nuke
	{
		//	If soldier already has a rocket that was armed during one of the previous turns
		if (GetPermArmedRocketObjectID(UnitState) > 0)
		{
			// then Arm this rocket only until the end of turn.
			UnitState.SetUnitFloatValue(default.ArmedThisTurnUnitValueName, ObjectID, eCleanup_BeginTurn);
		}
		else
		{	
			//	Otherwise, Arm it permanently.
			UnitState.SetUnitFloatValue(default.UnitValueName, ObjectID, eCleanup_BeginTactical);
			UnitState.SetUnitFloatValue(default.ArmedThisTurnUnitValueName, ObjectID, eCleanup_BeginTurn);
		}
	}
}

private static function int GetPermArmedRocketObjectID(XComGameState_Unit UnitState)
{
	local UnitValue UV;

	if (UnitState.GetUnitValue(default.UnitValueName, UV))
	{
		return UV.fValue;
	}
	return -1;
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local X2Action_PlaySoundAndFlyOver	SoundAndFlyOver;
	local XComGameStateContext_Ability  Context;
	local XComGameState_Item			ItemState;
	local X2RocketTemplate				RocketTemplate;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

	//	Visualize flyover only if it's not a Nuke. Nukes have their own Flyover in Armed Nuke effect.
	if (!class'X2Rocket_Nuke'.static.IsNuke(Context.InputContext.ItemObject.ObjectID))
	{
		ItemState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(Context.InputContext.ItemObject.ObjectID));

		RocketTemplate = X2RocketTemplate(ItemState.GetMyTemplate());

		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, Context,  false,  ActionMetadata.LastActionAdded));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None,  RocketTemplate.ArmRocketFlyover,  '',  eColor_Good);
	}
	super.AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, EffectApplyResult);
}

defaultproperties
{
	UnitValueName="IRI_Rocket_Armed_Value"

	ArmedThisTurnUnitValueName="IRI_Rocket_Armed_This_Turn_Value"
}