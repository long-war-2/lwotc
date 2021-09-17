class X2Effect_SabotHitBonus extends X2Effect_Persistent;

var int ScalingAimBonus;
var int ScalingCritBonus;
var bool InverseCritScaling;
var array<name> ValidAbilities;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo ModInfo;

	if (ValidAbilities.Find(AbilityState.GetMyTemplateName()) != INDEX_NONE)
	{
		ModInfo.ModType = eHit_Success;
		ModInfo.Reason = FriendlyName;
		ModInfo.Value = ScalingAimBonus * Target.UnitSize * Target.UnitHeight;
		ShotModifiers.AddItem(ModInfo);

		ModInfo.ModType = eHit_Crit;
		ModInfo.Reason = FriendlyName;

		if (InverseCritScaling) 
		{
			ModInfo.Value = ScalingCritBonus / (Target.UnitSize * Target.UnitHeight);
		}
		else
		{	
			ModInfo.Value = ScalingCritBonus * Target.UnitSize * Target.UnitHeight;
		}
		ShotModifiers.AddItem(ModInfo);
	}
}