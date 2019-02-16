//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_LockedOn
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up LockedOn Perk Effect
//--------------------------------------------------------------------------------------- 

class X2Effect_LockedOn extends X2Effect_Persistent config (LW_SoldierSkills);

var config int LOCKEDON_AIM_BONUS;
var config int LOCKEDON_CRIT_BONUS;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Effect_LastShotDetails	LastShotDetails;
	local X2EventManager						EventMgr;
	local Object								ListenerObj;
	local XComGameState_Unit					UnitState;

	EventMgr = `XEVENTMGR;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(NewEffectState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	if (GetLastShotDetails(NewEffectState) == none)
	{
		LastShotDetails = XComGameState_Effect_LastShotDetails(NewGameState.CreateStateObject(class'XComGameState_Effect_LastShotDetails'));
		LastShotDetails.InitComponent();
		NewEffectState.AddComponentObject(LastShotDetails);
		NewGameState.AddStateObject(LastShotDetails);
	}
	ListenerObj = LastShotDetails;
	if (ListenerObj == none)
	{
		`Redscreen("LSD: Failed to find LSD Component when registering listener");
		return;
	}
    EventMgr.RegisterForEvent(ListenerObj, 'AbilityActivated', LastShotDetails.RecordShot, ELD_OnStateSubmitted, 50, UnitState);
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local XComGameState_BaseObject EffectComponent;
	local Object EffectComponentObj;
	
	super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);

	EffectComponent = GetLastShotDetails(RemovedEffectState);
	if (EffectComponent == none)
		return;

	EffectComponentObj = EffectComponent;
	`XEVENTMGR.UnRegisterFromAllEvents(EffectComponentObj);

	NewGameState.RemoveStateObject(EffectComponent.ObjectID);
}

static function XComGameState_Effect_LastShotDetails GetLastShotDetails(XComGameState_Effect Effect)
{
	if (Effect != none) 
		return XComGameState_Effect_LastShotDetails (Effect.FindComponentObject(class'XComGameState_Effect_LastShotDetails'));
	return none;
}

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local XComGameState_Item						SourceWeapon;
    local ShotModifierInfo							ShotInfo;
	local XComGameState_Effect_LastShotDetails		LastShot;

	if (XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID)) == none)
		return;
	if (AbilityState == none)
		return;
	LastShot = GetLastShotDetails(EffectState);
	if (!LastShot.b_AnyShotTaken)
		return;
    SourceWeapon = AbilityState.GetSourceWeapon();  
	if (SourceWeapon == Attacker.GetItemInSlot(eInvSlot_PrimaryWeapon))
	{
		if ((SourceWeapon != none) && (Target != none))
		{
			if (Target.ObjectID == LastShot.LSTObjID)
			{
				ShotInfo.ModType = eHit_Success;
				ShotInfo.Reason = FriendlyName;
				ShotInfo.Value = default.LOCKEDON_AIM_BONUS;
				ShotModifiers.AddItem(ShotInfo);
				ShotInfo.ModType = eHit_Crit;
				ShotInfo.Reason = FriendlyName;
				ShotInfo.Value = default.LOCKEDON_CRIT_BONUS;
				ShotModifiers.AddItem(ShotInfo);
			}
		}
    }    
}

defaultproperties
{
    DuplicateResponse=eDupe_Ignore
    EffectName="LockedOn"
}

