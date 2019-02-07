//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_CoupDeGrace.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Sets up Damage bonus and flyover for CoupDeGrace
//---------------------------------------------------------------------------------------
// deprecated for 1.3

class X2Effect_CoupDeGrace extends X2Effect_Persistent;

var int DisorientedChance;
var int StunnedChance;
var int UnconsciousChance;
var int TargetDamageChanceMultiplier;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
    local XComGameState_Item SourceWeapon;
    local XComGameState_Unit TargetUnit, UpdatedTargetUnit;
	local int PctChance, iRoll;
	local float PctLostHealth;
	local StateObjectReference AbilityRef;

	if (AbilityState.GetMyTemplateName() == 'CoupDeGrace' && AppliedData.AbilityResultContext.CalculatedHitChance > 0)  // is CoupDeGrace and not a preview check
	{
	    if(AppliedData.AbilityResultContext.HitResult == eHit_Crit || AppliedData.AbilityResultContext.HitResult == eHit_Success)
		{
			SourceWeapon = AbilityState.GetSourceWeapon();
			if(SourceWeapon != none) 
			{
				TargetUnit = XComGameState_Unit(TargetDamageable);
				if(TargetUnit != none)
				{
					AbilityRef = TargetUnit.FindAbility('AlienRulerPassive');
					if (AbilityRef.ObjectID != 0)
					{
						return (CurrentDamage);
					}
					if(TargetUnit.IsDisoriented())
						PctChance = DisorientedChance;
					if(TargetUnit.IsStunned())
						PctChance = StunnedChance;
					if(TargetUnit.IsUnconscious())
						PctChance = UnconsciousChance;

					PctLostHealth = 1.0 - (TargetUnit.GetCurrentStat(eStat_HP) / TargetUnit.GetMaxStat(eStat_HP));
					PctChance += PctLostHealth * TargetDamageChanceMultiplier;

					iRoll = `SYNC_RAND(100);
					`LOG("Coup de Grace : Chance=" $ PctChance $ ", Roll=" $ iRoll);

					if(iRoll < PctChance)
					{
						if (NewGameState != none)
						{
							UpdatedTargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(TargetUnit.ObjectID));
							if (UpdatedTargetUnit == none)
							{
								UpdatedTargetUnit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', TargetUnit.ObjectID));
								NewGameState.AddStateObject(UpdatedTargetUnit);
							}
							UpdatedTargetUnit.SetUnitFloatValue('CoupDeGrace_Executed', 1);
						}
						return int(TargetUnit.GetCurrentStat(eStat_HP)+TargetUnit.GetCurrentStat(eStat_ShieldHP));
					}
				}
            }
        }
	}
    return 0;
}

function bool PostAbilityCostPaid(XComGameState_Effect EffectState, XComGameStateContext_Ability AbilityContext, XComGameState_Ability kAbility, XComGameState_Unit SourceUnit, XComGameState_Item AffectWeapon, XComGameState NewGameState, const array<name> PreCostActionPoints, const array<name> PreCostReservePoints)
{
	local XComGameState_Unit	TargetUnit, UpdatedTargetUnit;
	local XComGameStateHistory History;
	local UnitValue CoupDeGraceValue;

	if (kAbility.GetMyTemplateName() != 'CoupDeGrace')
		return false;

	if (kAbility.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef)
	{
		History = `XCOMHISTORY;
		TargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
		if (TargetUnit == none)
			TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
		if(TargetUnit != none)		
		{
			TargetUnit.GetUnitValue('CoupDeGrace_Executed', CoupDeGraceValue);
			if (CoupDeGraceValue.fValue != 0)
			{
				UpdatedTargetUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(TargetUnit.ObjectID));
				if (UpdatedTargetUnit == none)
				{
					UpdatedTargetUnit = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', TargetUnit.ObjectID));
					NewGameState.AddStateObject(UpdatedTargetUnit);
				}
				
				UpdatedTargetUnit.DamageResults[TargetUnit.DamageResults.Length - 1].bFreeKill = true;
				UpdatedTargetUnit.ClearUnitValue('CoupDeGrace_Executed');
			}
		}
	}
	return false;
}