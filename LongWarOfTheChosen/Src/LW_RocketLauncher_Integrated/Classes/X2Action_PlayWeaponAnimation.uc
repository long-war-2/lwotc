class X2Action_PlayWeaponAnimation extends X2Action;

var name AnimName;

//	===================================
var private XComWeapon			Weapon;
var private XComWeapon			OldWeapon;
var private AnimNodeSequence	AnimSeq;
var private CustomAnimParams	Params;
var private bool				bProceed;

function Init()
{
	local XGWeapon				XG_Weapon;
	local XComGameState_Item	RocketState;
	local UnitValue				RocketValue;
	local XComGameState_Unit	UnitState;
	local XGUnitNativeBase		OwnerUnit;

	super.Init();

	Params.AnimName = AnimName;

	OldWeapon = XComWeapon(UnitPawn.Weapon);
	if (OldWeapon != none)
	{
		OwnerUnit = UnitPawn.GetGameUnit();
		if (OwnerUnit != none)
		{
			UnitState = OwnerUnit.GetVisualizedGameState();
			if (UnitState != none)
			{
				if (UnitState.GetUnitValue(class'X2Effect_ArmRocket'.default.UnitValueName, RocketValue))
				{
					RocketState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(RocketValue.fValue));
					if (RocketState != none)
					{
						RocketState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(RocketState.SoldierKitOwner.ObjectID));

						if (RocketState != none)
						{
							XG_Weapon = XGWeapon(RocketState.GetVisualizer());
							if (XG_Weapon != none)
							{
								Weapon = XComWeapon(XG_Weapon.m_kEntity);
								if (Weapon != none)
								{
									bProceed = true;	//	Set the bool flag only if the entire Init was completed successfully
								}
							}
						}
					}
				}
			}
		}
	}
}

simulated state Executing
{
Begin:
	if(bProceed)
	{
		UnitPawn.SetCurrentWeapon(Weapon);

		AnimSeq = UnitPawn.PlayWeaponAnim(Params);
		/*
		while (AnimSeq.bPlaying)
		{
			Sleep(0.1f);
		}*/

		UnitPawn.SetCurrentWeapon(OldWeapon);
	}
	CompleteAction();
}