///---------------------------------------------------------------------------------------
//  FILE:    X2Effect_FocusFire
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Implements effect for FocusFire ability -- XCOM gets bonuses against designated target
//--------------------------------------------------------------------------------------- 
//---------------------------------------------------------------------------------------
class X2Effect_FocusFire extends X2Effect_BonusArmor config(LW_OfficerPack);

var config int FOCUSFIRE_ACTIONPOINTCOST;
var config int FOCUSFIRE_DURATION;
var config int FOCUSFIRE_COOLDOWN;
var config int ARMORPIERCINGEFFECT;
var config int AIMBONUSPERATTACK;
var config array<name> VALIDWEAPONCATEGORIES;

//add a component to XComGameState_Effect to track cumulative number of attacks
simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Effect_FocusFire FFEffectState;
	local X2EventManager EventMgr;
	local Object ListenerObj;

	EventMgr = `XEVENTMGR;

	if (GetFocusFireComponent(NewEffectState) == none)
	{
		//create component and attach it to GameState_Effect, adding the new state object to the NewGameState container
		FFEffectState = XComGameState_Effect_FocusFire(NewGameState.CreateStateObject(class'XComGameState_Effect_FocusFire'));
		FFEffectState.InitComponent();
		NewEffectState.AddComponentObject(FFEffectState);
		NewGameState.AddStateObject(FFEffectState);
	}

	//add listener to new component effect -- do it here because the RegisterForEvents call happens before OnEffectAdded, so component doesn't yet exist
	ListenerObj = FFEffectState;
	if (ListenerObj == none)
	{
		`Redscreen("FocusFire: Failed to find FocusFire Component when registering listener");
		return;
	}
	EventMgr.RegisterForEvent(ListenerObj, 'AbilityActivated', FFEffectState.FocusFireCheck, ELD_OnStateSubmitted,,,true);
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameState_BaseObject EffectComponent;
	local Object EffectComponentObj;
	
	super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);

	EffectComponent = GetFocusFireComponent(RemovedEffectState);
	if (EffectComponent == none)
		return;

	EffectComponentObj = EffectComponent;
	`XEVENTMGR.UnRegisterFromAllEvents(EffectComponentObj);

	NewGameState.RemoveStateObject(EffectComponent.ObjectID);
}

simulated function GetToHitAsTargetModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo AccuracyInfo;
	local XComGameState_Effect_FocusFire FFEffect;

	AccuracyInfo.ModType = eHit_Success;
	FFEffect = GetFocusFireComponent(EffectState);
	FFEffect = XComGameState_Effect_FocusFire(`XCOMHISTORY.GetGameStateForObjectID(FFEffect.ObjectID));
	if (FFEffect != none)
	{
		//`log("FocusFire : Found FocusFire component, CumulativeAttacks=" $ FFEffect.CumulativeAttacks);
		AccuracyInfo.Value = default.AIMBONUSPERATTACK * Max(1, FFEffect.CumulativeAttacks);
	} else {
		//`log("FocusFire : FocusFire component not found");
		AccuracyInfo.Value = default.AIMBONUSPERATTACK;
	}
	AccuracyInfo.Reason = FriendlyName;
	ShotModifiers.AddItem(AccuracyInfo);
}

function int GetArmorMitigation(XComGameState_Effect EffectState, XComGameState_Unit UnitState) { return -default.ARMORPIERCINGEFFECT; }
function int GetArmorChance(XComGameState_Effect EffectState, XComGameState_Unit UnitState) { return 100; }

simulated function AddX2ActionsForVisualization_Tick(XComGameState VisualizeGameState, out VisualizationActionMetadata BuildTrack, const int TickIndex, XComGameState_Effect EffectState)
{
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	
	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext(), false, BuildTrack.LastActionAdded));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, FriendlyName, '', eColor_Bad);
}

static function XComGameState_Effect_FocusFire GetFocusFireComponent(XComGameState_Effect Effect)
{
	if (Effect != none) 
		return XComGameState_Effect_FocusFire(Effect.FindComponentObject(class'XComGameState_Effect_FocusFire'));
	return none;
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
	EffectName="FocusFire";
	bRemoveWhenSourceDies=true;
}