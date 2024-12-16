class X2Effect_Phosphorus extends X2Effect_Persistent config(LW_SoldierSkills);

var config int BONUS_CV_SHRED;
var config int BONUS_MG_SHRED;
var config int BONUS_BM_SHRED;

function int GetExtraShredValue(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData)
{
	local Name AbilityName;
	local XComGameState_Item SourceWeapon;
	local XComGameStateHistory History;
	`LOG ("TEsting New Phos Effect 1");
	History = `XCOMHISTORY;

	SourceWeapon = XComGameState_Item(History.GetGameStateForObjectID(AppliedData.ItemStateObjectRef.ObjectID));

	if(AbilityState == none)
		return 0;

	`LOG ("TEsting New Phos Effect 2");

	if (Attacker.HasSoldierAbility('PhosphorusPassive'))
	{
		`LOG ("TEsting New Phos Effect 3");		
		AbilityName = AbilityState.GetMyTemplateName();
		switch (AbilityName)
		{
			case 'LWFlamethrower':
			case 'Roust':
			case 'Firestorm':
			case 'FirestormActivation':
			case 'AdvPurifierFlamethrower':
			switch(X2WeaponTemplate(SourceWeapon.GetMyTemplate()).WeaponTech)
				{
					case 'conventional':
					return default.BONUS_CV_SHRED;

					case 'magnetic':
					return default.BONUS_MG_SHRED;

					case 'beam':
					return default.BONUS_BM_SHRED;

					default:
					break;
				}
			default:
				return 0;
		}
	}
	return 0;
}