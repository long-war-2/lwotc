//from AngelRane
class X2Effect_DeflectNew extends X2Effect_Persistent
	config(LW_FactionBalance);

var config int DeflectMinFocus, DeflectBaseChance, DeflectPerFocusChance;
var config int ReflectMinFocus, ReflectBaseChance;

var config bool bCanDeflectMelee, bCanDeflectArea;

function bool ChangeHitResultForTarget(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit TargetUnit, XComGameState_Ability AbilityState, bool bIsPrimaryTarget, const EAbilityHitResult CurrentResult, out EAbilityHitResult NewHitResult)
{
	local UnitValue ParryUnitValue;
	local int FocusLevel, Chance, RandRoll;
	local X2AbilityToHitCalc_StandardAim AttackToHit;

	//	don't respond to reaction fire
	AttackToHit = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
	if (AttackToHit != none && AttackToHit.bReactionFire)
		return false;

	//	don't change a natural miss
	if (!class'XComGameStateContext_Ability'.static.IsHitResultHit(CurrentResult))
		return false;

	if (!TargetUnit.IsAbleToAct())
		return false;

	`log("X2Effect_Deflect::ChangeHitResultForTarget", , 'XCom_HitRolls');
	//	check for parry first - if the unit value is set, then a parry is guaranteed, so do not check for deflect or reflect
	if (TargetUnit.HasSoldierAbility('Parry') && TargetUnit.GetUnitValue('Parry', ParryUnitValue))
	{
		if (ParryUnitValue.fValue > 0)
		{
		    // if Parry is available we will be resolving reflect there
			`log("Parry is available - not triggering deflect or reflect here!", , 'XCom_HitRolls');
			return false;
		}		
	}

	//	only parry can block melee abilities, so only check non-melee abilities
	if ((!AbilityState.IsMeleeAbility() || default.bCanDeflectMelee) && (bIsPrimaryTarget || default.bCanDeflectArea))
	{
		FocusLevel = TargetUnit.GetTemplarFocusLevel();

		if (FocusLevel >= default.DeflectMinFocus)
		{
			Chance = default.DeflectBaseChance + ((FocusLevel - 1) * default.DeflectPerFocusChance);
			RandRoll = `SYNC_RAND(100);
			if (RandRoll <= Chance)
			{
				`log("Deflect chance was" @ Chance @ "rolled" @ RandRoll @ "- success!", , 'XCom_HitRolls');
				if (TargetUnit.HasSoldierAbility('Reflect') && FocusLevel >= default.ReflectMinFocus && !AbilityState.IsMeleeAbility() && bIsPrimaryTarget)
				{
					Chance = default.ReflectBaseChance + ((FocusLevel - 1) * default.DeflectPerFocusChance);
					RandRoll = `SYNC_RAND(100);
					if (RandRoll <= Chance)
					{
						`log("Reflect chance was" @ Chance @ "rolled" @ RandRoll @ "- success!", , 'XCom_HitRolls');
						NewHitResult = eHit_Reflect;
						return true;
					}
					`log("Reflect chance was" @ Chance @ "rolled" @ RandRoll @ "- failed. Cannot Reflect.", , 'XCom_HitRolls');
				}
				`log("Unit does not have Reflect, or not enough Focus to trigger it.", , 'XCom_HitRolls');
				NewHitResult = eHit_Deflect;
				return true;
			}
			`log("Deflect chance was" @ Chance @ "rolled" @ RandRoll @ "- failed.", , 'XCom_HitRolls');
		}		
		else
		{
			`log("Unit does not have enough focus for Deflect.", , 'XCom_HitRolls');
		}
	}
	else
	{
		`log("Ability is a melee attack or an AOE attack - cannot be Reflected or Deflected.", , 'XCom_HitRolls');
	}

	return false;
}

DefaultProperties
{
	DuplicateResponse = eDupe_Ignore
	EffectName = "Deflect"
}