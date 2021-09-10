class X2Condition_RocketArmedCheck extends X2Condition;

enum EArmedRocketStatus
{
	eRocketArmed_Unknown,
	eRocketArmed_NotArmed, 
	eRocketArmed_DoesNotRequireArming,
	eRocketArmed_ArmedPerm,
	eRocketArmed_ArmedTemp,
	eRocketArmed_ArmedPermAndTemp
};

//	enum values have this specific order for a reason. The higher the number goes, the more recent was this rocket armed, basically. 
//	if (RocketStatus > eRocketArmed_DoesNotRequireArming) = this rocket requires arming and it is armed.
//	if (RocketStatus > eRocketArmed_ArmedPerm) = this rocket requires arming and was armed this turn.

var bool bFailByDefault;
var bool bCheckForArmedNukes;
var array<EArmedRocketStatus> RequiredStatus;
var array<EArmedRocketStatus> ExcludedStatus;

static public function EArmedRocketStatus GetRocketArmedStatus(XComGameState_Unit UnitState, int ObjectID)
{
	local XComGameState_Item	RocketState;
	local X2RocketTemplate		RocketTemplate;
	local UnitValue				UV1, UV2;

	RocketState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(ObjectID));

	if (RocketState != none)
	{
		RocketTemplate = X2RocketTemplate(RocketState.GetMyTemplate());

		if(!RocketTemplate.RequireArming)
		{
			return eRocketArmed_DoesNotRequireArming;
		}
	}
	else
	{
		`redscreen("X2Condition_RocketArmedCheck -> could not retrieve Item State for Rocket. -Iridar");
	}

	UnitState.GetUnitValue(class'X2Effect_ArmRocket'.default.UnitValueName, UV1);
	UnitState.GetUnitValue(class'X2Effect_ArmRocket'.default.ArmedThisTurnUnitValueName, UV2);

	if (UV1.fValue == ObjectID && UV2.fValue == ObjectID)
	{
		return eRocketArmed_ArmedPermAndTemp;
	}

	if (UV1.fValue == ObjectID)
	{
		return eRocketArmed_ArmedPerm;
	}

	if (UV2.fValue == ObjectID)
	{
		return eRocketArmed_ArmedTemp;
	}

	return eRocketArmed_NotArmed;
}




event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{	
	local XComGameState_Unit	UnitState;
	local EArmedRocketStatus	RocketStatus;
	
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));
	if (UnitState != none)
	{
		RocketStatus = GetRocketArmedStatus(UnitState, kAbility.SourceWeapon.ObjectID);

		if (RequiredStatus.Length > 0 && RequiredStatus.Find(RocketStatus) != INDEX_NONE)
		{
			return 'AA_Success';
		}

		if (ExcludedStatus.Length > 0 && ExcludedStatus.Find(RocketStatus) != INDEX_NONE)
		{
			return 'AA_WeaponIncompatible';
		}

		//	Separate part of condition, used to check if the soldier has any Armed Nukes (so we can prohibit to Arm any other rockets).
		if (bCheckForArmedNukes)
		{
			if (DoesSoldierHasArmedNukes(UnitState))
			{
				if (bFailByDefault) return 'AA_WeaponIncompatible';
				else return 'AA_Success';
			}
			else
			{
				if (bFailByDefault) return 'AA_Success';
				else return 'AA_WeaponIncompatible';
			}
		}


		if (bFailByDefault) return 'AA_WeaponIncompatible';
		else return 'AA_Success';
	}
	return 'AA_NotAUnit';
}

public static function bool DoesSoldierHasArmedNukes(XComGameState_Unit UnitState)
{
	local UnitValue UV1, UV2;

	////`LOG("Checking if unit: " @ UnitState.GetFullName() @ "has a nuke armed",, 'IRINUKE');

	UnitState.GetUnitValue(class'X2Effect_ArmRocket'.default.UnitValueName, UV1);
	UnitState.GetUnitValue(class'X2Effect_ArmRocket'.default.ArmedThisTurnUnitValueName, UV2);

	if (UV1.fValue > 0 && class'X2Rocket_Nuke'.static.IsNuke(UV1.fValue) ||
		UV2.fValue > 0 && class'X2Rocket_Nuke'.static.IsNuke(UV2.fValue))
	{
		// Soldier has a nuke Armed
		////`LOG("true",, 'IRINUKE');
		return true;
	}
	// Soldier does not have nuke armed.
	////`LOG("false",, 'IRINUKE');
	return false;
}