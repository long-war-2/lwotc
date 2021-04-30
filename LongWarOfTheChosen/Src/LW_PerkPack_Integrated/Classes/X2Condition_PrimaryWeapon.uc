//---------------------------------------------------------------------------------------
//  FILE:    X2Condition_PrimaryWeapon
//  AUTHOR:  Favid
//  PURPOSE: Condition that checks the unit's primary weapon.
//--------------------------------------------------------------------------------------- 
class X2Condition_PrimaryWeapon extends X2Condition;

var() bool WantsReload;
var() bool CheckAmmo;
var() CheckConfig CheckAmmoData;
var() name MatchWeaponTemplate;              //  requires exact match to weapon's template's DataName
var() bool RequirePrimary; // Condition that checks if the ability is using the primary weapon
function AddAmmoCheck(int Value, optional EValueCheck CheckType=eCheck_Exact, optional int ValueMax=0, optional int ValueMin=0)
{
	CheckAmmo = true;
	CheckAmmoData.Value = Value;
	CheckAmmoData.CheckType = CheckType;
	CheckAmmoData.ValueMax = ValueMax;
	CheckAmmoData.ValueMin = ValueMin;
}

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
	local XComGameState_Unit UnitState;
	local XComGameState_Item PrimaryWeapon;
	local name AmmoResult;



	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));
	PrimaryWeapon = UnitState.GetItemInSlot(eInvSlot_PrimaryWeapon);

	if (PrimaryWeapon != none)
	{
		if (WantsReload)
		{
			if (PrimaryWeapon.Ammo == PrimaryWeapon.GetClipSize())
				return 'AA_AmmoAlreadyFull';
		}

		if (CheckAmmo)
		{
			AmmoResult = PerformValueCheck(PrimaryWeapon.Ammo, CheckAmmoData);                                                                                                                          
			if (AmmoResult != 'AA_Success')
				return AmmoResult;
		}

		if (MatchWeaponTemplate != '')
		{
			if (PrimaryWeapon.GetMyTemplateName() != MatchWeaponTemplate)
				return 'AA_WeaponIncompatible';
		}

		if(RequirePrimary)
		{	if(kAbility.SourceWeapon.ObjectID != PrimaryWeapon.ObjectID)
			{
				return 'AA_WeaponIncompatible';
			}
		}
	}

	return 'AA_Success';
}