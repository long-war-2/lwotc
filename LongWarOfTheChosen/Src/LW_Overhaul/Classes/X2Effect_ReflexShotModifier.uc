class X2Effect_ReflexShotModifier extends X2Effect_Persistent config(LW_SoldierSkills);

var config array<int> ReflexAimModifier;
var config array<int> ReflexCritModifier;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
    local ShotModifierInfo					ShotInfo;

	//`LOG ("Check 1" @ AbilityState.GetMyTemplateName());
	if (AbilityState.GetMyTemplateName() == 'StandardShot')
	{
		//`LOG ("Check 2");
		if (Attacker.ActionPoints.Find(class'XComGameState_LWListenerManager'.const.OffensiveReflexAction) != -1 || Attacker.ActionPoints.Find(class'XComGameState_LWListenerManager'.const.DefensiveReflexAction) != -1)
		{
			//`LOG ("Check 3");
			ShotInfo.ModType = eHit_Success;
			ShotInfo.Value = default.ReflexAimModifier[`TACTICALDIFFICULTYSETTING];
			ShotInfo.Reason = FriendlyName;
			ShotModifiers.AddItem(ShotInfo);

			ShotInfo.ModType = eHit_Crit;
			ShotInfo.Value = default.ReflexCritModifier[`TACTICALDIFFICULTYSETTING];
			ShotInfo.Reason = FriendlyName;
			ShotModifiers.AddItem(ShotInfo);
		}
	}
}
