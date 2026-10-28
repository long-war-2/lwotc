class X2Effect_TracerRounds_LW extends X2Effect_TracerRounds config(LW_PerkPack);

var config int HoloAimMod;
var array<name> HoloTargetEffectNames;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ModInfo;
	local XComGameState_Item SourceWeapon;
    local name EffectName;
    local bool bHolotargeted;

	SourceWeapon = AbilityState.GetSourceWeapon();
	if (SourceWeapon != none && SourceWeapon.LoadedAmmo.ObjectID == EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID)
	{

		ModInfo.ModType = eHit_Success;
		ModInfo.Reason = FriendlyName;
		

		foreach HoloTargetEffectNames(EffectName)
		{
			if (Target.IsUnitAffectedByEffectName(EffectName))
			{
				bHolotargeted = true;
				break;
			}
		}

		if(bHolotargeted)
		{
		ModInfo.Value = default.AimMod + default.HoloAimMod;
		}
		else
		{
			ModInfo.Value = default.AimMod;
		}

		ShotModifiers.AddItem(ModInfo);
	}
}
