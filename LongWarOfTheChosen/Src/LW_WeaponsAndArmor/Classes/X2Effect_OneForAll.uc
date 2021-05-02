//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_OneForAll.uc
//  AUTHOR:  Grobobobo
//  PURPOSE: Grants ablative on use, scalses with shield
//---------------------------------------------------------------------------------------

class X2Effect_OneForAll extends X2Effect_ModifyStats;

var int BaseShieldHPIncrease;
var int MK2ShieldIncrease;
var int MK3ShieldIncrease;

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
		Caster = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	}
	SourceItem = XComGameState_Item(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));
	if (SourceItem == none)
	{
		SourceItem = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));
	}

	ShieldHPChange.StatAmount = BaseShieldHPIncrease;

	if (SourceItem.GetMyTemplateName() == 'TemplarBallisticShield_MG')
	{
		ShieldHPChange.StatAmount += MK2ShieldIncrease;
	}
	if (SourceItem.GetMyTemplateName() == 'TemplarBallisticShield_BM')
	{
		ShieldHPChange.StatAmount += MK3ShieldIncrease;
	}

	Target.SetUnitFloatValue('OFAShieldHP', ShieldHPChange.StatAmount, eCleanup_BeginTactical);
	Target.SetUnitFloatValue('PreOFAShieldHP', Target.GetCurrentStat(eStat_ShieldHP), eCleanup_BeginTactical);

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
	UnitState.GetUnitValue('OFAShieldHP', NullWardShieldHP);
	UnitState.GetUnitValue('PreOFAShieldHP', OtherShieldHP);
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


defaultproperties
{
	DuplicateResponse=eDupe_Refresh
} 
