//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_LockedOn
//  AUTHOR:  John Lumpkin (Pavonis Interactive)
//  PURPOSE: Sets up LockedOn Perk Effect
//--------------------------------------------------------------------------------------- 

class X2Effect_LockedOn extends X2Effect_Persistent config (LW_SoldierSkills);

var config int LOCKEDON_AIM_BONUS;
var config int LOCKEDON_CRIT_BONUS;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;

	EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', class'XComGameState_Effect_LastShotDetails'.static.RecordShot, ELD_OnStateSubmitted,,,, EffectObj);
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
	LastShot = XComGameState_Effect_LastShotDetails(EffectState);
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
	GameStateEffectClass=class'XComGameState_Effect_LastShotDetails';
}
