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
	EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', LockedOnListener, ELD_OnStateSubmitted, 99,,, EffectObj);
}

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local XComGameState_Item SourceWeapon;
	local ShotModifierInfo ShotMod;
	local UnitValue ShotsValue, TargetValue;
	local bool bValidWeapon;

	SourceWeapon = AbilityState.GetSourceWeapon();

	if (SourceWeapon != none)
	{
		if (EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID != 0)
		{
			if (AbilityState.SourceWeapon.ObjectID == EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID)
				bValidWeapon = true;
		}
		else if (SourceWeapon.InventorySlot == eInvSlot_PrimaryWeapon)
		{
			bValidWeapon = true;
		}
	}

	if (!bIndirectFire && bValidWeapon)
	{
		Attacker.GetUnitValue('LockedOnShots', ShotsValue);
		Attacker.GetUnitValue('LockedOnTarget', TargetValue);

		if (ShotsValue.fValue > 0 && TargetValue.fValue == Target.ObjectID)
		{
			ShotMod.ModType = eHit_Success;
			ShotMod.Reason = FriendlyName;
			ShotMod.Value = default.LOCKEDON_AIM_BONUS;
			ShotModifiers.AddItem(ShotMod);

			ShotMod.ModType = eHit_Crit;
			ShotMod.Reason = FriendlyName;
			ShotMod.Value = default.LOCKEDON_CRIT_BONUS;
			ShotModifiers.AddItem(ShotMod);
		}
	}
}

static function EventListenerReturn LockedOnListener(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Ability AbilityState;
	local XComGameState NewGameState;
	local XComGameState_Unit UnitState;
	local XComGameState_Unit LockedOnOwnerUnitState;
	local XComGameState_Item SourceWeapon;
	local XComGameState_Effect EffectGameState;
	local bool bValidWeapon;

	//`LWTrace("Locked on listener firing");

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());

	if(AbilityContext == none)
		return ELR_NoInterrupt;

	if (AbilityContext.InterruptionStatus == eInterruptionStatus_Interrupt)
		return ELR_NoInterrupt;

	AbilityState = XComGameState_Ability(EventData);
	if(AbilityState == none)
		return ELR_NoInterrupt;

	UnitState = XComGameState_Unit(EventSource);
	if(UnitState == none)
		return ELR_NoInterrupt;

	EffectGameState = XComGameState_Effect(CallbackData);
	if (EffectGameState == none)
		return ELR_NoInterrupt;

	LockedOnOwnerUnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	if (UnitState.ObjectID != LockedOnOwnerUnitState.ObjectID)
		return ELR_NoInterrupt;

	if (AbilityState.IsAbilityInputTriggered())
	{
		SourceWeapon = AbilityState.GetSourceWeapon();

		if (SourceWeapon != none)
		{
			if (EffectGameState.ApplyEffectParameters.ItemStateObjectRef.ObjectID != 0)
			{
				if (AbilityState.SourceWeapon.ObjectID == EffectGameState.ApplyEffectParameters.ItemStateObjectRef.ObjectID)
					bValidWeapon = true;
			}
			else if (SourceWeapon.InventorySlot == eInvSlot_PrimaryWeapon)
			{
				bValidWeapon = true;
			}

			if (AbilityState.GetMyTemplate().Hostility == eHostility_Offensive && bValidWeapon)
			{
				NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("LockedOn");
				UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(UnitState.Class, UnitState.ObjectID));
				UnitState.SetUnitFloatValue('LockedOnShots', 1, eCleanup_BeginTactical);
				UnitState.SetUnitFloatValue('LockedOnTarget', AbilityContext.InputContext.PrimaryTarget.ObjectID, eCleanup_BeginTactical);

				if (UnitState.ActionPoints.Length > 0)
				{
					//	show flyover for boost, but only if they have actions left to potentially use them
					NewGameState.ModifyStateObject(class'XComGameState_Ability', EffectGameState.ApplyEffectParameters.AbilityStateObjectRef.ObjectID);		//	create this for the vis function
					XComGameStateContext_ChangeContainer(NewGameState.GetContext()).BuildVisualizationFn = EffectGameState.TriggerAbilityFlyoverVisualizationFn;
				}
				`TACTICALRULES.SubmitGameState(NewGameState);
			}
		}

	}
	return ELR_NoInterrupt;
}

defaultproperties
{
	DuplicateResponse=eDupe_Ignore
	EffectName="LockedOn"
}
