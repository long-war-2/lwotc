class X2Effect_BloodThirst extends X2Effect_Persistent config(LW_SoldierSkills);

var float BloodThirstDMGPCT;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Unit TargetUnit;
	

		if(AppliedData.AbilityResultContext.HitResult != eHit_Miss)
		{
			if( AbilityState.SourceWeapon == EffectState.ApplyEffectParameters.ItemStateObjectRef )
			{
				TargetUnit = XComGameState_Unit(TargetDamageable);
				if(TargetUnit != none)
				{
					return int (CurrentDamage * (BloodThirstDMGPCT / 100));
				}
            }
        }
    return 0;
}



defaultproperties
{
    BloodThirstDMGPCT=34
}