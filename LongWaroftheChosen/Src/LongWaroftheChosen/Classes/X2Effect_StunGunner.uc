//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_StunGunner.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Grants a bonus to hit based on tech level to archthrower shots
//---------------------------------------------------------------------------------------
class X2Effect_StunGunner extends X2Effect_Persistent config(LW_SoldierSkills);

var name WeaponCategory;

var config int STUNGUNNER_BONUS_CV;
var config int STUNGUNNER_BONUS_MG;
var config int STUNGUNNER_BONUS_BM;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo			ModInfo;
	local XComGameState_Item		SourceWeapon;
	local X2WeaponTemplate			WeaponTemplate;
	local int						Bonus;

	SourceWeapon = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.SourceWeapon.ObjectID));
	if(SourceWeapon != none)
		WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
	if(WeaponTemplate != none)
	{
		if(WeaponTemplate.WeaponCat == WeaponCategory)
		{
			Bonus = default.STUNGUNNER_BONUS_CV;
			switch (WeaponTemplate.WeaponTech)
			{
				case 'Conventional':	Bonus = default.STUNGUNNER_BONUS_CV; break;
				case 'Magnetic':		Bonus = default.STUNGUNNER_BONUS_MG; break;
				case 'Beam':			Bonus = default.STUNGUNNER_BONUS_BM; break;
				default: break;
			}
			ModInfo.ModType = eHit_Success;
			ModInfo.Reason = FriendlyName;
			ModInfo.Value = Bonus;
			ShotModifiers.AddItem(ModInfo);
		}
	}
}