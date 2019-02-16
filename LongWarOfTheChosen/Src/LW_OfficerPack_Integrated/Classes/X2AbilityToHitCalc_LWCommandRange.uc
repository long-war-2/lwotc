//---------------------------------------------------------------------------------------
//  FILE:    X2AbilityToHitCalc_LWCommandRange.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//	Purpose: Set range ring to limit when this ability triggers
//---------------------------------------------------------------------------------------
class X2AbilityToHitCalc_LWCommandRange extends X2AbilityToHitCalc config(LW_OfficerPack);

var config float COMMANDRANGEBUFFER;

function RollForAbilityHit(XComGameState_Ability kAbility, AvailableTarget kTarget, out AbilityResultContext ResultContext)
{
	local int MultiIndex;
	local ArmorMitigationResults NoArmor;
	local XComGameStateHistory History;
	local XComGameState_Unit TargetState, UnitState;
	local float CommandRange;

	History = `XCOMHISTORY;

	// LWCommandRange "hits" within a narrow band
	UnitState = XComGameState_Unit(History.GetGameStateForObjectID(kAbility.OwnerStateObject.ObjectID));
	TargetState = XComGameState_Unit(History.GetGameStateForObjectID(kTarget.PrimaryTarget.ObjectID));

	CommandRange = Sqrt(class'X2Ability_OfficerAbilitySet'.static.GetCommandRangeSq(UnitState));

	if (!class'Helpers'.static.IsTileInRange(UnitState.TileLocation, TargetState.TileLocation, (CommandRange + default.COMMANDRANGEBUFFER)*(CommandRange + default.COMMANDRANGEBUFFER)))
	{
		ResultContext.HitResult = eHit_Miss;
	} else {
		if (class'Helpers'.static.IsTileInRange(UnitState.TileLocation, TargetState.TileLocation, (CommandRange - default.COMMANDRANGEBUFFER)*(CommandRange - default.COMMANDRANGEBUFFER)))
		{
			ResultContext.HitResult = eHit_Miss;
		} else {
			ResultContext.HitResult = eHit_Success;
		}
	}

	for (MultiIndex = 0; MultiIndex < kTarget.AdditionalTargets.Length; ++MultiIndex)
	{
		ResultContext.MultiTargetHitResults.AddItem(ResultContext.HitResult);		
		ResultContext.MultiTargetArmorMitigation.AddItem(NoArmor);
		ResultContext.MultiTargetStatContestResult.AddItem(0);
	}
}

protected function int GetHitChance(XComGameState_Ability kAbility, AvailableTarget kTarget, optional out ShotBreakdown kBreakdown, optional bool bDebugLog=false)
{
	kBreakdown.HideShotBreakdown = true;
	kBreakdown.FinalHitChance = 100;
	return kBreakdown.FinalHitChance;
}
