class X2Effect_ApplyCanisterDamage extends X2Effect_ApplyWeaponDamage;

var name Element;
var float Scalar;
var int AddShred, AddPierce;

function WeaponDamageValue GetBonusEffectDamageValue(XComGameState_Ability AbilityState, XComGameState_Unit SourceUnit, XComGameState_Item SourceWeapon, StateObjectReference TargetRef)
{
	local WeaponDamageValue				DamageValue;
	local X2WeaponTemplate				WeaponTemplate;
	local XComGameStateHistory			History;
	local XComGameState_BaseObject		Target;
	local XComGameState_Unit			TargetUnit;

	History = `XCOMHISTORY;
	Target = History.GetGameStateForObjectID( TargetRef.ObjectID );
	TargetUnit = XComGameState_Unit(Target);
	WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());

	//uh oh. need to add a proper immunity check!
	if ( TargetUnit != none )
	{
		if ( WeaponTemplate == none || (Element != '' && TargetUnit.IsImmuneToDamage(Element)) || (Element == '' && TargetUnit.IsImmuneToDamage(WeaponTemplate.BaseDamage.DamageType)) )
		{
			return DamageValue;
		}
	}

	DamageValue.Damage = Round(Scalar*(WeaponTemplate.BaseDamage.Damage + GetBreakthroughBonus(WeaponTemplate)));
	DamageValue.Crit = Round(WeaponTemplate.BaseDamage.Crit * Scalar);
	DamageValue.Pierce = Round(WeaponTemplate.BaseDamage.Pierce * Scalar) + AddPierce;
	DamageValue.Shred = Round((WeaponTemplate.BaseDamage.Shred)*Scalar) + AddShred;
	DamageValue.Spread = Round(Scalar*WeaponTemplate.BaseDamage.Spread);

	DamageValue.PlusOne = Round(WeaponTemplate.BaseDamage.PlusOne * Scalar);
	//If it's over 100, that needs to be fixed. increasing the spread makes the damage range line up better to the expected value.
	While ( DamageValue.PlusOne > 99 )
	{
		DamageValue.Damage += 1;
		DamageValue.Spread += 1;
		DamageValue.PlusOne -= 100;
	}
	//If it's negative, that needs to be fixed.
	While ( DamageValue.PlusOne < 0 )
	{
		DamageValue.Damage -= 1;
		DamageValue.PlusOne += 100;
	}

	if ( Element != '' )
	{
		DamageValue.DamageType = Element;
	}
	else
	{
		DamageValue.DamageType = WeaponTemplate.BaseDamage.DamageType;
	}

	return DamageValue;

}

private function int GetBreakthroughBonus(X2WeaponTemplate WeaponTemplate)
{
	local XComGameState_HeadquartersXCom	XComHQ;
	local StateObjectReference				ObjRef;
	local X2TechTemplate					Tech;
	local X2BreakthroughCondition_WeaponType WeaponTypeCondition;
	local X2BreakthroughCondition_WeaponTech TechCondition;
	local int								Bonus;
	local XComGameStateHistory			History;

	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom( History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom') );

	Foreach XComHQ.TacticalTechBreakthroughs(ObjRef)
	{
		Tech = XComGameState_Tech(History.GetGameStateForObjectID(ObjRef.ObjectID)).GetMyTemplate();
		If ( Tech != none )
		{
			If ( Tech.RewardName == 'WeaponTypeBreakthroughBonus' )
			{
				WeaponTypeCondition = X2BreakthroughCondition_WeaponType(Tech.BreakthroughCondition);
				If (WeaponTypeCondition.WeaponTypeMatch == WeaponTemplate.WeaponCat)
				{
					Bonus +=1;
				}
			}
			else if ( Tech.RewardName == 'WeaponTechBreakthroughBonus')
			{
				TechCondition = X2BreakthroughCondition_WeaponTech(Tech.BreakthroughCondition);
				If (TechCondition.WeaponTechMatch == WeaponTemplate.WeaponTech)
				{
					Bonus +=1;
				}
			}
		}
	}

	return Bonus;
}


defaultproperties
{
	bIgnoreBaseDamage = true;
	Scalar = 1.0f
}