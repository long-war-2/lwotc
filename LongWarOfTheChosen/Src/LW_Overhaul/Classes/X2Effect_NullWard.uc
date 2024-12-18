//---------------------------------------------------------------------------------------
//  FILE:   X2Effect_NullWard.uc
//  AUTHOR:  Grobobobo/Based on X2Effect_MindMerge
//  PURPOSE: Replaces the effect from Iridar's Null Ward ability so the shield can scale with the soldier's psi amp 
//---------------------------------------------------------------------------------------
class X2Effect_NullWard extends X2Effect_ModifyStats;

var int BaseShieldHPIncrease;
var int AmpMGShieldHPBonus;
var int AmpBMShieldHPBonus;

protected simulated function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local StatChange			ShieldHPChange;
	local XComGameState_Unit	Caster, Target;
	local XComGameState_Item	SourceItem;

	ShieldHPChange.StatType = eStat_ShieldHP;

	Caster = XComGameState_Unit (NewGameState.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	Target = XComGameState_unit(kNewTargetState);
	if (Caster == none)
	{
		Caster = XComGameState_Unit(class'XComGameStateHistory'.static.GetGameStateHistory().GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	}
	SourceItem = XComGameState_Item(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));
	if (SourceItem == none)
	{
		SourceItem = XComGameState_Item(class'XComGameStateHistory'.static.GetGameStateHistory().GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));
	}

	ShieldHPChange.StatAmount = BaseShieldHPIncrease;

	switch (SourceItem.GetWeaponTech())
	{
		case 'laser_lw':
		case 'magnetic':
			ShieldHPChange.StatAmount += AmpMGShieldHPBonus;
			break;
		case 'coilgun_lw':
		case 'beam':
			ShieldHPChange.StatAmount += AmpBMShieldHPBonus;
			break;
	}


	Target.SetUnitFloatValue('NullWardShieldHP', ShieldHPChange.StatAmount, eCleanup_BeginTactical);
	Target.SetUnitFloatValue('PreNullWardShieldHP', Target.GetCurrentStat(eStat_ShieldHP), eCleanup_BeginTactical);

	NewEffectState.StatChanges.AddItem(ShieldHPChange);

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local int NullWardGrantedShieldHP, PreNullWardShieldHP, PreRemovalShieldHP, FullyShieldedHP, ShieldHPDamage, NewShieldHP;
	local XComGameState_Unit UnitState;
	local UnitValue NullWardShieldHP, OtherShieldHP;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	PreRemovalShieldHP = UnitState.GetCurrentStat(eStat_ShieldHP);

	super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	UnitState.GetUnitValue('NullWardShieldHP', NullWardShieldHP);
	UnitState.GetUnitValue('PreNullWardShieldHP', OtherShieldHP);
	NullWardGrantedShieldHP = int(NullWardShieldHP.fValue);		// How many you got
	PreNullWardShieldHP = int(OtherShieldHP.fValue);				// how many you had
	FullyShieldedHP = PreNullWardShieldHP + NullWardGrantedShieldHP;
	//ShieldHP = UnitState.GetCurrentStat(eStat_ShieldHP);						// how many you have now

	ShieldHPDamage = FullyShieldedHP - PreRemovalShieldHP;
	if (ShieldHPDamage > 0 && PreNullWardShieldHP > 0 && ShieldHPDamage < FullyShieldedHP)
	{
		NewShieldHP = Clamp(PreNullWardShieldHP + NullWardGrantedShieldHP - ShieldHPDamage, 0, PreNullWardShieldHP);
		UnitState = XComGameState_Unit(NewGameState.CreateStateObject(UnitState.Class, UnitState.ObjectID));
		UnitState.SetCurrentStat(estat_ShieldHP, NewShieldHP);
		NewGameState.AddStateObject(UnitState);
	}
}

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	EffectObj = EffectGameState;

	EventMgr.RegisterForEvent(EffectObj, 'ShieldsExpended', EffectGameState.OnShieldsExpended, ELD_OnStateSubmitted, , UnitState);
}

defaultproperties
{
	EffectName="EnergyShieldEffect"
	DuplicateResponse=eDupe_Refresh
} 
