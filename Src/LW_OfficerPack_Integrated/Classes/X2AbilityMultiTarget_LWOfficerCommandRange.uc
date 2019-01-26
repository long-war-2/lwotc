//---------------------------------------------------------------------------------------
//  FILE:    X2AbilityMultiTarget_LWOfficerCommandRange
//  AUTHOR:  Amineri (Pavonis Interactive)
//
//  PURPOSE: Custom MultiTarget class for actively applied officer abilities that use dynamic CommandRange
//
//--------------------------------------------------------------------------------------- 
class X2AbilityMultiTarget_LWOfficerCommandRange extends X2AbilityMultiTarget_Radius;

// ----------- Have to override this native function in X2AbilityMultiTargetStyle, as all others are native-to-native calls and cannot be intercepted -----------------
/**
 * GetMultiTargetOptions
 * @param Targets will have valid PrimaryTarget filled out already
 * @return Targets with AdditionalTargets filled out given the PrimaryTarget in each element
 */
simulated function GetMultiTargetOptions(const XComGameState_Ability Ability, out array<AvailableTarget> Targets)
{
	//local XComGameState_HeadquartersXCom XComHQ;
	local XComGameStateHistory History;
	local XComGameState_Unit OfficerUnit, UnitState; //, SourceUnit;
	//local array<XComGameState_Unit> UnitList;
	//local StateObjectReference UnitRef;
	local AvailableTarget Target;
	local StateObjectReference AdditionalTarget;
	//local bool bSkipTurrets, bSkipPanicked;

	History = `XCOMHISTORY;
	//XComHQ = `XCOMHQ;

	if (Targets.length == 0)
	{
		`Redscreen("LW Officer Pack: Empty Targets array\n" $ GetScriptTrace());
		return;
	}
	if (Targets.length > 1)
	{
		`Redscreen("LW Officer Pack: Multiple primary targets for command range ability (nonfatal)\n" $ GetScriptTrace());
	}
	OfficerUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Targets[0].PrimaryTarget.ObjectID));

	UpdateTargetRadius(Ability, OfficerUnit);
	//super.GetMultiTargetOptions(Ability, Targets);

	//add each member of the squad that is in range of the officer
    foreach History.IterateByClassType(class'XComGameState_Unit', UnitState)
    {
        if (UnitState.ControllingPlayer.ObjectID == OfficerUnit.ControllingPlayer.ObjectID // same player owns officer and current unit
            && !UnitState.bRemovedFromPlay && UnitState.IsAlive())
        {
			if (UnitState.ObjectID != OfficerUnit.ObjectID) // don't apply effects to officer
			{
				if (class'Helpers'.static.IsTileInRange(OfficerUnit.TileLocation, UnitState.TileLocation, class'X2Ability_OfficerAbilitySet'.static.GetCommandRangeSq(OfficerUnit), 10))
				{
					Targets[0].AdditionalTargets.AddItem(UnitState.GetReference());
					//Target.PrimaryTarget = UnitRef;
					//Targets.AddItem(Target);
				}
			}
        }
    }


	foreach Targets(Target)
	{
		`Log("CommandRangeMultiTarget (Primary): " $ XComGameState_Unit(History.GetGameStateForObjectID(Target.PrimaryTarget.ObjectID)).GetFullName()); 
		foreach Target.AdditionalTargets(AdditionalTarget)
		{
			`Log("CommandRangeMultiTarget (Additional): " $ XComGameState_Unit(History.GetGameStateForObjectID(AdditionalTarget.ObjectID)).GetFullName()); 
		}
	}
}

simulated function GetMultiTargetsForLocation(const XComGameState_Ability Ability, const vector Location, out AvailableTarget Target)
{
	local XComGameState_Unit SourceUnit;

	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Target.PrimaryTarget.ObjectID));
	UpdateTargetRadius(Ability, SourceUnit);
	return;
	super.GetMultiTargetsForLocation(Ability, Location, Target);
}


simulated function GetValidTilesForLocation(const XComGameState_Ability Ability, const vector Location, out array<TTile> ValidTiles)
{
	local XComGameState_Unit SourceUnit;

	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Ability.OwnerStateObject.ObjectID));
	UpdateTargetRadius(Ability, SourceUnit);
	return;
	super.GetValidTilesForLocation(Ability, Location, ValidTiles);
}

simulated function float GetTargetRadius(const XComGameState_Ability Ability)
{
	local XComGameState_Unit SourceUnit;

	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Ability.OwnerStateObject.ObjectID));
	UpdateTargetRadius(Ability, SourceUnit);
	return(`METERSTOUNITS(fTargetRadius));
}

simulated function float GetActiveTargetRadiusScalar(const XComGameState_Ability Ability)
{
	local XComGameState_Unit SourceUnit;

	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Ability.OwnerStateObject.ObjectID));
	UpdateTargetRadius(Ability, SourceUnit);
	return(`METERSTOUNITS(fTargetRadius));
}

simulated function float GetTargetCoverage(const XComGameState_Ability Ability)
{
	local XComGameState_Unit SourceUnit;

	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Ability.OwnerStateObject.ObjectID));
	UpdateTargetRadius(Ability, SourceUnit);
	return(`METERSTOUNITS(fTargetRadius));
}

function UpdateTargetRadius(const XComGameState_Ability Ability, XComGameState_Unit SourceUnit)
{
	if (SourceUnit == none)
	{
		`Redscreen("LW Officer Pack: Unable to find source unit\n" $ GetScriptTrace());
		return;
	}
	fTargetRadius = `UNITSTOMETERS(`TILESTOUNITS(Sqrt(class'X2Ability_OfficerAbilitySet'.static.GetCommandRangeSq(SourceUnit))));
}

defaultProperties
{
	bUseWeaponRadius=false
	bIgnoreBlockingCover=true  // unused here, but kept for reference
	//fTargetRadius;          //  Meters! (for now) If bUseWeaponRadius is true, this value is added on.
	//fTargetCoveragePercentage;
	bAddPrimaryTargetAsMultiTarget=false     //unused here, but kept for reference -- GetMultiTargetOptions & GetMultiTargetsForLocation will remove the primary target and add it to the multi target array.
	bAllowDeadMultiTargetUnits=false	//unused here, but kept for reference
	bAllowSameTarget=false
}