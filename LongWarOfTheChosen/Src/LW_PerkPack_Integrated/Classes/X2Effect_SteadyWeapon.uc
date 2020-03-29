class X2Effect_SteadyWeapon extends X2Effect_Persistent config(GameData_SoldierSkills);

var int Aim_Bonus;
var int Crit_Bonus;

var config array<name> WEAPON_CATEGORIES_LOW_BONUS;
var config array<name> WEAPON_CATEGORIES_HIGH_BONUS;

var config float LOW_BONUS_MODIFIER;
var config float HIGH_BONUS_MODIFIER;
function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.SourceStateObjectRef.ObjectID));

	EventMgr.RegisterForEvent(EffectObj, 'AbilityActivated', SteadyWeaponActionListener, ELD_OnStateSubmitted, 50, UnitState,, EffectObj);
	//EventMgr.RegisterForEvent(EffectObj, 'UnitTakeEffectDamage', SteadyWeaponWoundListener, ELD_OnStateSubmitted, 51, UnitState,, EffectObj);
	EventMgr.RegisterForEvent(EffectObj, 'ImpairingEffect', SteadyWeaponWoundListener, ELD_OnStateSubmitted, 52, UnitState,, EffectObj);
}

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit UnitState;
	local UnitValue AttacksThisTurn;

	// This is a fix for Deep Cover triggering when you Steady Weapon
	UnitState = XComGameState_Unit(kNewTargetState);
	UnitState.GetUnitValue('AttacksThisTurn', AttacksThisTurn);
	AttacksThisTurn.fValue += float(1);
	UnitState.SetUnitFloatValue('AttacksThisTurn', AttacksThisTurn.fValue, eCleanup_BeginTurn);
	
	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

static function EventListenerReturn SteadyWeaponActionListener(Object EventData, Object EventSource, XComGameState GameState, name EventID, Object CallbackData)
{
	local XComGameState_Ability AbilityState;
	local XComGameState_Effect EffectState;
	local XComGameStateContext_EffectRemoved RemoveContext;
	local XComGameState NewGameState;
	local X2AbilityCost Cost;
	local bool CostlyAction;

	AbilityState = XComGameState_Ability(EventData);
	EffectState = XComGameState_Effect(CallbackData);
	if (AbilityState != none && EffectState != none)
	{
		foreach AbilityState.GetMyTemplate().AbilityCosts(Cost)
		{
			CostlyAction = false;
			if (Cost.IsA('X2AbilityCost_ActionPoints') && !X2AbilityCost_ActionPoints(Cost).bFreeCost)
				CostlyAction = true;
			if (Cost.IsA('X2AbilityCost_ReserveActionPoints') && !X2AbilityCost_ReserveActionPoints(Cost).bFreeCost)
				CostlyAction = true;
			if (Cost.IsA('X2AbilityCost_HeavyWeaponActionPoints') && !X2AbilityCost_HeavyWeaponActionPoints(Cost).bFreeCost)
				CostlyAction = true;
			if (Cost.IsA('X2AbilityCost_QuickdrawActionPoints') && !X2AbilityCost_QuickdrawActionPoints(Cost).bFreeCost)
				CostlyAction = true;
			if (AbilityState.GetMyTemplateName() == 'CloseCombatSpecialistAttack')
				CostlyAction = true;
			if (AbilityState.GetMyTemplateName() == 'BladestormAttack' || AbilityState.GetMyTemplateName() == 'TemplarBladestormAttack')
				CostlyAction = true;
			if (AbilityState.GetMyTemplateName() == 'LightningHands')
				CostlyAction = true;
			if (CostlyAction) 
			{
				if (AbilityState.GetMyTemplateName() == 'SteadyWeapon' || AbilityState.GetMyTemplateName() == 'Stock_LW_Bsc_Ability' ||  AbilityState.GetMyTemplateName() == 'Stock_LW_Adv_Ability' ||  AbilityState.GetMyTemplateName() == 'Stock_LW_Sup_Ability')
					return ELR_NoInterrupt;

				if (!EffectState.bRemoved)
				{								
					RemoveContext = class'XComGameStateContext_EffectRemoved'.static.CreateEffectRemovedContext(EffectState);
					NewGameState = `XCOMHISTORY.CreateNewGameState(true, RemoveContext);
					EffectState.RemoveEffect(NewGameState, GameState);
					`TACTICALRULES.SubmitGameState(NewGameState);
					return ELR_NoInterrupt;
				}
			}
		}
	}
	return ELR_NoInterrupt;
}

static function EventListenerReturn SteadyWeaponWoundListener(Object EventData, Object EventSource, XComGameState GameState, name EventID, Object CallbackData)
{
	local XComGameState_Ability AbilityState;
	local XComGameState_Effect EffectState;
	local XComGameStateContext_EffectRemoved RemoveContext;
	local XComGameState NewGameState;

	AbilityState = XComGameState_Ability(EventData);
	EffectState = XComGameState_Effect(CallbackData);
	if (AbilityState != none && EffectState != none && !EffectState.bRemoved)
	{
		RemoveContext = class'XComGameStateContext_EffectRemoved'.static.CreateEffectRemovedContext(EffectState);
		NewGameState = `XCOMHISTORY.CreateNewGameState(true, RemoveContext);
		EffectState.RemoveEffect(NewGameState, GameState);
		`TACTICALRULES.SubmitGameState(NewGameState);
		return ELR_NoInterrupt;
	}
	return ELR_NoInterrupt;
}

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ShotInfo_Aim;
	local ShotModifierInfo ShotInfo_Crit;
	local XComGameState_Item SourceWeaponState;

	SourceWeaponState = AbilityState.GetSourceWeapon();

	if (!bMelee && AbilityState.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef)
	{
		if (default.WEAPON_CATEGORIES_HIGH_BONUS.Find(SourceWeaponState.GetWeaponCategory()) != INDEX_NONE)
		{
			ShotInfo_Aim.Value = Aim_Bonus * default.HIGH_BONUS_MODIFIER;
			ShotInfo_Crit.Value = Crit_Bonus* default.HIGH_BONUS_MODIFIER;
		}
		else if (default.WEAPON_CATEGORIES_LOW_BONUS.Find(SourceWeaponState.GetWeaponCategory()) != INDEX_NONE)
		{
			ShotInfo_Aim.Value = Aim_Bonus * default.LOW_BONUS_MODIFIER;
			ShotInfo_Crit.Value = Crit_Bonus * default.LOW_BONUS_MODIFIER;
		}
		else
		{
			ShotInfo_Aim.Value = Aim_Bonus;
			ShotInfo_Crit.Value = Crit_Bonus;
		}

		ShotInfo_Aim.ModType = eHit_Success;
		ShotInfo_Aim.Reason = FriendlyName;
		ShotModifiers.AddItem(ShotInfo_Aim);

		ShotInfo_Crit.ModType = eHit_Crit;
		ShotInfo_Crit.Reason = FriendlyName;
		ShotModifiers.AddItem(ShotInfo_Crit);
	}

}

defaultproperties
{
	EffectName="SteadyWeapon"
}
