class X2Effect_MatchingDamageBonus extends X2Effect_Persistent;

var int Bonus;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Item SourceWeapon;
	local name ThrowerType, CanisterType;

	if ( AppliedData.EffectRef.ApplyOnTickIndex > -1) {return 0; }

	SourceWeapon = AbilityState.GetSourceWeapon();
	if (SourceWeapon != none && ( X2WeaponTemplate(SourceWeapon.GetMyTemplate()).WeaponCat == 'lwchemthrower' || class'X2Item_ChemthrowerUpgrades'.default.Sparkthrowers.Find(SourceWeapon.GetMyTemplateName()) != INDEX_NONE) )
	{
		ThrowerType = X2WeaponTemplate(SourceWeapon.GetMyTemplate()).BaseDamage.DamageType;
		CanisterType = X2WeaponTemplate(XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID)).GetMyTemplate()).DamageTypeTemplateName;
		
		If ( ThrowerType == CanisterType )
		{
			return Bonus;
		}

		Switch (ThrowerType)
		{
			case 'Fire':
			case 'Napalm':
			case 'BlazingPinions':
				if ( CanisterType == 'Fire' || CanisterType == 'Napalm' || CanisterType == 'BlazingPinions' ) { return Bonus; }
				break;
			case 'Poison':
			case 'ParthenogenicPoison':
				if ( CanisterType == 'Poison' || CanisterType == 'ParthenogenicPoison' ) { return Bonus; }
				break;
			case 'Explosion':
			case 'NoFireExplosion':
				If (CanisterType == 'Explosion' || CanisterType == 'NoFireExplosion') { return Bonus; }
				break;
			case 'Mental':
			case 'Psi':
				If (CanisterType == 'Mental' || CanisterType == 'Psi' || CanisterType == 'Panic') { return Bonus; }
				break;
		}
	}

	return 0;
}