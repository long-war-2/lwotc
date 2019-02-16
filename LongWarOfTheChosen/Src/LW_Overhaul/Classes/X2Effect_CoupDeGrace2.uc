class X2Effect_CoupDeGrace2 extends X2Effect_Persistent;

var int To_Hit_Modifier;
var int Crit_Modifier;
var int Damage_Bonus;
var bool Half_for_Disoriented;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Unit				Target;
	local XComGameState_Item				SourceWeapon;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;
	
	WeaponDamageEffect = X2Effect_ApplyWeaponDamage(class'X2Effect'.static.GetX2Effect(AppliedData.EffectRef));
	if (WeaponDamageEffect != none)
	{			
		if (WeaponDamageEffect.bIgnoreBaseDamage)
		{	
			return 0;		
		}
	}

	SourceWeapon = AbilityState.GetSourceWeapon();
	if(SourceWeapon != none && SourceWeapon.ObjectID == EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID)
	{
		Target = XComGameState_Unit(TargetDamageable);
		if (Target.IsStunned() || Target.IsDisoriented() || Target.IsPanicked() || Target.IsUnconscious())
		{
			if (Target.IsDisoriented() && Half_For_Disoriented)
				return Max (Damage_Bonus / 2, 1);
			return Damage_Bonus;
		}
	}
	return 0;
}

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local XComGameState_Item				SourceWeapon;
    local ShotModifierInfo					ShotInfo;
	local X2AbilityToHitCalc_StandardAim	StandardToHit;

	SourceWeapon = AbilityState.GetSourceWeapon();
	if(SourceWeapon != none && SourceWeapon.ObjectID == EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID)
	{
        StandardToHit = X2AbilityToHitCalc_StandardAim(AbilityState.GetMyTemplate().AbilityToHitCalc);
		if (StandardToHit != none && (Target.IsStunned() || Target.IsDisoriented() || Target.IsPanicked() || Target.IsUnconscious()))
		{
			ShotInfo.ModType = eHit_Success;
			ShotInfo.Reason = FriendlyName;
			if (Target.IsDisoriented() && Half_For_Disoriented)
			{
				ShotInfo.Value = To_Hit_Modifier / 2;
			}
			else
			{
				ShotInfo.Value = To_Hit_Modifier;
			}
			ShotModifiers.AddItem(ShotInfo);
			ShotInfo.ModType = eHit_Crit;
			ShotInfo.Reason = FriendlyName;
			if (Target.IsDisoriented() && Half_For_Disoriented)
			{
				ShotInfo.Value = Crit_Modifier / 2;
			}
			else
			{
				ShotInfo.Value = Crit_Modifier;
			}
			ShotModifiers.AddItem(ShotInfo);
		}
	}
}


