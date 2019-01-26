class X2Effect_SteadyWeapon extends X2Effect_Persistent;

var int Aim_Bonus;
var int Crit_Bonus;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local X2EventManager								EventMgr;
    local XComGameState_Unit							UnitState;
    local Object										ListenerObj;
	local XComGameState_Effect_SteadyWeaponListener		SteadyWeaponListenerComponent;
 	local UnitValue AttacksThisTurn;

	EventMgr = `XEVENTMGR;
	UnitState = XComGameState_Unit(kNewTargetState);
	if (SteadyWeaponEffectComponent(NewEffectState) == none)
	{
		SteadyWeaponListenerComponent = XComGameState_Effect_SteadyWeaponListener(NewGameState.CreateStateObject(class'XComGameState_Effect_SteadyWeaponListener'));
		SteadyWeaponListenerComponent.InitComponent();
		NewEffectState.AddComponentObject(SteadyWeaponListenerComponent);
		NewGameState.AddStateObject(SteadyWeaponListenerComponent);
	}
	ListenerObj = SteadyWeaponListenerComponent;
	if (ListenerObj == none)
	{
		`Redscreen("SWLC: Failed to find Component when registering listener");
		return;
	}

	// This is a fix for Deep Cover triggering when you Steady Weapon
    UnitState.GetUnitValue('AttacksThisTurn', AttacksThisTurn);
    AttacksThisTurn.fValue += float(1);
    UnitState.SetUnitFloatValue('AttacksThisTurn', AttacksThisTurn.fValue, eCleanup_BeginTurn);

    EventMgr.RegisterForEvent(ListenerObj, 'AbilityActivated', SteadyWeaponListenerComponent.SteadyWeaponActionListener, ELD_OnStateSubmitted, 50, UnitState);
	EventMgr.RegisterForEvent(ListenerObj, 'UnitTakeEffectDamage', SteadyWeaponListenerComponent.SteadyWeaponWoundListener, ELD_OnStateSubmitted, 51, UnitState);
	EventMgr.RegisterForEvent(ListenerObj, 'ImpairingEffect', SteadyWeaponListenerComponent.SteadyWeaponWoundListener, ELD_OnStateSubmitted, 52, UnitState);
}

static function XComGameState_Effect_SteadyWeaponListener SteadyWeaponEffectComponent(XComGameState_Effect Effect)
{
	if (Effect != none)
		return XComGameState_Effect_SteadyWeaponListener (Effect.FindComponentObject(class'XComGameState_Effect_SteadyWeaponListener'));
	return none;
}


function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo ShotInfo;

    if(!bMelee && AbilityState.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef)
    {
        ShotInfo.ModType = eHit_Success;
        ShotInfo.Reason = FriendlyName;
        ShotInfo.Value = Aim_Bonus;
        ShotModifiers.AddItem(ShotInfo);

		ShotInfo.ModType = eHit_Crit;
		ShotInfo.Reason = FriendlyName;
		ShotInfo.Value = Crit_Bonus;
		ShotModifiers.AddItem(ShotInfo);
    }

}

static function XComGameState_Effect_SteadyWeaponListener GetEffectComponent(XComGameState_Effect Effect)
{
	if (Effect != none)
		return XComGameState_Effect_SteadyWeaponListener(Effect.FindComponentObject(class'XComGameState_Effect_SteadyWeaponListener'));
	return none;
}


simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameState_BaseObject EffectComponent;
	local Object EffectComponentObj;

	super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);

	EffectComponent = GetEffectComponent(RemovedEffectState);
	if (EffectComponent == none)
		return;

	EffectComponentObj = EffectComponent;
	`XEVENTMGR.UnRegisterFromAllEvents(EffectComponentObj);

	NewGameState.RemoveStateObject(EffectComponent.ObjectID);
}

defaultproperties
{
    EffectName="SteadyWeapon"
}
