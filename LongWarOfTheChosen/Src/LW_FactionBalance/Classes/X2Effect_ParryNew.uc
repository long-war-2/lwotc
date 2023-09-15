//from AngelRane
class X2Effect_ParryNew extends X2Effect_Persistent
	config(LW_FactionBalance);

var config int ParryReflectPerFocusChance, ParryReflectMinFocus, ParryReflectBaseChance;

function bool ChangeHitResultForTarget(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit TargetUnit, XComGameState_Ability AbilityState, bool bIsPrimaryTarget, const EAbilityHitResult CurrentResult, out EAbilityHitResult NewHitResult)
{
	local UnitValue ParryUnitValue;
	local int FocusLevel, Chance, RandRoll;

	`log("X2Effect_Parry::ChangeHitResultForTarget", , 'XCom_HitRolls');
	//	check for parry - if the unit value is set, then a parry is guaranteed
	if (TargetUnit.GetUnitValue('Parry', ParryUnitValue) && TargetUnit.IsAbleToAct())
	{
		if (ParryUnitValue.fValue > 0)
		{
			if (!AbilityState.IsMeleeAbility() && bIsPrimaryTarget)
			{
				FocusLevel = TargetUnit.GetTemplarFocusLevel();
				
				if (TargetUnit.HasSoldierAbility('Reflect') && FocusLevel >= default.ParryReflectMinFocus)
				{
					Chance = default.ParryReflectBaseChance + ((FocusLevel - 1) * default.ParryReflectPerFocusChance);
					RandRoll = `SYNC_RAND(100);
					if (RandRoll <= Chance)
					{
						`log("Reflect on Parry chance was" @ Chance @ "rolled" @ RandRoll @ "- success!", , 'XCom_HitRolls');
						NewHitResult = eHit_Reflect;
						TargetUnit.SetUnitFloatValue('Parry', ParryUnitValue.fValue - 1);
						return true;
					}
				}
			}
			`log("Parry available - using!", , 'XCom_HitRolls');
			NewHitResult = eHit_Parry;
			TargetUnit.SetUnitFloatValue('Parry', ParryUnitValue.fValue - 1);
			return true;
		}
	}
	
	`log("Parry not available.", , 'XCom_HitRolls');
	return false;
}

DefaultProperties
{
	DuplicateResponse = eDupe_Ignore
	EffectName = "Parry"
}