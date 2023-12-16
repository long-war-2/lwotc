class X2Effect_MindMerge extends X2Effect_ModifyStats;

var int BaseShieldHPIncrease;
var int BaseWillIncrease;
var int BaseCritIncrease;

var int AmpMGShieldHPBonus;
var int AmpMGWillBonus;
var int AmpMGCritBonus;

var int AmpBMShieldHPBonus;
var int AmpBMWillBonus;
var int AmpBMCritBonus;

var float MindMergeShieldHPDivisor;
var float MindMergeWillDivisor;
var float MindMergeCritDivisor;

var float SoulMergeShieldHPDivisor;
var float SoulMergeWillDivisor;
var float SoulMergeCritDivisor;

protected simulated function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local StatChange			WillChange;
	local StatChange			ShieldHPChange;
	local StatChange			CritChange;
	local XComGameState_Unit	Caster, Target;
	local XComGameState_Item	SourceItem;
	local StateObjectReference	SoulMergeRef;
	//local UnitValue				MindMergeShieldHP;

	WillChange.StatType = eStat_Will;
	ShieldHPChange.StatType = eStat_ShieldHP;
	CritChange.StatType = eStat_CritChance;

	Caster = XComGameState_Unit (NewGameState.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	Target = XComGameState_unit (kNewTargetState);
	if(Caster == none)
	{
		Caster = XComGameState_Unit(class'XComGameStateHistory'.static.GetGameStateHistory().GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	}
	SourceItem = XComGameState_Item(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));
	if(SourceItem == none)
	{
		SourceItem = XComGameState_Item(class'XComGameStateHistory'.static.GetGameStateHistory().GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));
	}

	// Add flat bonuses
	ShieldHPChange.StatAmount = BaseShieldHPIncrease;
	WillChange.StatAmount = BaseWillIncrease;
	CritChange.StatAmount = BaseCritIncrease;

	// Add mag tier bonuses
	if (SourceItem.GetMyTemplateName() == 'PsiAmp_MG')
	{
		ShieldHPChange.StatAmount += AmpMGShieldHPBonus;
		WillChange.StatAmount += AmpMGWillBonus;
		CritChange.StatAmount += AmpMGCritBonus;
	}

	// Add beam tier bonuses
	if (SourceItem.GetMyTemplateName() == 'PsiAmp_BM')
	{
		ShieldHPChange.StatAmount += AmpBMShieldHPBonus;
		WillChange.StatAmount += AmpBMWillBonus;
		CritChange.StatAmount += AmpBMCritBonus;
	}

	// Add per psi offense bonuses
	SoulMergeRef = Caster.FindAbility('SoulMerge');
	if (SoulMergeRef.ObjectID == 0)
	{
		if (MindMergeShieldHPDivisor > 0)
		{
			ShieldHPChange.StatAmount += Caster.GetCurrentStat(eStat_PsiOffense) / MindMergeShieldHPDivisor;
		}
		if (MindMergeWillDivisor > 0)
		{
			WillChange.StatAmount += Caster.GetCurrentStat(eStat_PsiOffense) / MindMergeWillDivisor;
		}
		if (MindMergeCritDivisor > 0)
		{
			CritChange.StatAmount += Caster.GetCurrentStat(eStat_PsiOffense) / MindMergeCritDivisor;
		}
	}
	else
	{
		if (SoulMergeShieldHPDivisor > 0)
		{
			ShieldHPChange.StatAmount += (Caster.GetCurrentStat(eStat_PsiOffense) / SoulMergeShieldHPDivisor);
		}
		if (SoulMergeWillDivisor > 0)
		{
			WillChange.StatAmount += (Caster.GetCurrentStat(eStat_PsiOffense) / SoulMergeWillDivisor);
		}
		if (SoulMergeCritDivisor > 0)
		{
			CritChange.StatAmount += (Caster.GetCurrentStat(eStat_PsiOffense) / SoulMergeCritDivisor);
		}
	}

	Target.SetUnitFloatValue('MindMergeShieldHP', ShieldHPChange.StatAmount, eCleanup_BeginTactical);
	Target.SetUnitFloatValue('PreMindMergeShieldHP', Target.GetCurrentStat(eStat_ShieldHP), eCleanup_BeginTactical);

	NewEffectState.StatChanges.AddItem(ShieldHPChange);
	NewEffectState.StatChanges.AddItem(WillChange);
	NewEffectState.StatChanges.AddItem(CritChange);

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
{
	local int MindMergeGrantedShieldHP, PreMindMergeShieldHP, PreRemovalShieldHP, FullyShieldedHP, ShieldHPDamage, NewShieldHP;
	local XComGameState_Unit UnitState;
	local UnitValue MindMergeShieldHP, OtherShieldHP;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	PreRemovalShieldHP = UnitState.GetCurrentStat(eStat_ShieldHP);

	super.OnEffectRemoved(ApplyEffectParameters, NewGameState, bCleansed, RemovedEffectState);

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	UnitState.GetUnitValue('MindMergeShieldHP', MindMergeShieldHP);
	UnitState.GetUnitValue('PreMindMergeShieldHP', OtherShieldHP);
	MindMergeGrantedShieldHP = int(MindMergeShieldHP.fValue);		// How many you got
	PreMindMergeShieldHP = int(OtherShieldHP.fValue);				// how many you had
	FullyShieldedHP = PreMindMergeShieldHP + MindMergeGrantedShieldHP;
	//ShieldHP = UnitState.GetCurrentStat(eStat_ShieldHP);						// how many you have now

	ShieldHPDamage = FullyShieldedHP - PreRemovalShieldHP;
	if (ShieldHPDamage > 0 && PremindMergeShieldHP > 0 && ShieldHPDamage < FullyShieldedHP)
	{
		NewShieldHP = Clamp (PreMindMergeShieldHP + MindMergeGrantedShieldHP - ShieldHPDamage, 0, PreMindMergeShieldHP);
		UnitState = XComGameState_Unit(NewGameState.CreateStateObject(UnitState.Class, UnitState.ObjectID));
		UnitState.SetCurrentStat(estat_ShieldHP, NewShieldHP);
		NewGameState.AddStateObject(UnitState);
	}
}
