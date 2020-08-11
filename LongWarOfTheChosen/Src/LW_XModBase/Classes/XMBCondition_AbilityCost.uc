//---------------------------------------------------------------------------------------
//  FILE:    XMBCondition_AbilityCost.uc
//  AUTHOR:  xylthixlm
//
//  A condition that matches based on the action point cost of an ability and/or the
//  actual number of action points spent (including discounts, abilities that consume
//  all remaining points, etc).
//
//  EXAMPLES
//
//  The following examples in Examples.uc use this class:
//
//  HitAndRun
//
//  INSTALLATION
//
//  Install the XModBase core as described in readme.txt. Copy this file, and any files 
//  listed as dependencies, into your mod's Classes/ folder. You may edit this file.
//
//  DEPENDENCIES
//
//  None.
//---------------------------------------------------------------------------------------
class XMBCondition_AbilityCost extends X2Condition;

var bool bRequireMinimumPointsSpent;	// If true, require at least MinimumPointsSpent action points are spent
var int MinimumPointsSpent;				// Minimum number of action points that must have been actually spent

var bool bRequireMaximumPointsSpent;	// If true, require at most MaximumPointsSpent action points are spent
var int MaximumPointsSpent;				// Maximum number of action points that must have been actually spent

var bool bRequireMinimumCost;			// If true, require that the ability normally cost at least MinimumCost action points
var int MinimumCost;					// Minimum number of action points the ability normally costs

var bool bRequireMaximumCost;			// If true, require that the ability normally cost at most MaximumCost action points
var int MaximumCost;					// Maximum number of action points the ability normally costs

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
	local XComGameState GameState;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit SourceUnit, PrevSourceUnit;
	local XComGameStateHistory History;
	local X2AbilityTemplate Ability;
	local X2AbilityCost AbilityCost;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local int PointsSpent, TotalPoints, PrevTotalPoints, Cost;
	local int i, MovementCost, PathIndex, FarthestTile;

	History = `XCOMHISTORY;

	GameState = kAbility.GetParentGameState();

	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	if (AbilityContext == none)
		return 'AA_MissingRequiredContext';  // NOTE: Nonstandard AA code

	SourceUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
	if (SourceUnit != none)
	{
		PrevSourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(SourceUnit.ObjectID,, AbilityContext.AssociatedState.HistoryIndex - 1));

		// Don't trigger if only reserve points were available
		if (PrevSourceUnit.ActionPoints.Length == 0)
			return 'AA_InvalidActionPoints';  // NOTE: Nonstandard AA code

		PrevTotalPoints = PrevSourceUnit.ActionPoints.Length + PrevSourceUnit.ReserveActionPoints.Length;
		TotalPoints = SourceUnit.ActionPoints.Length + SourceUnit.ReserveActionPoints.Length;

		PointsSpent = PrevTotalPoints - TotalPoints;

		Ability = kAbility.GetMyTemplate();

		foreach Ability.AbilityCosts(AbilityCost)
		{
			ActionPointCost = X2AbilityCost_ActionPoints(AbilityCost);
			if (ActionPointCost != none)
			{
				if (ActionPointCost.bAddWeaponTypicalCost && kAbility.GetSourceWeapon() != none)
				{
					Cost = max(Cost, ActionPointCost.iNumPoints + X2WeaponTemplate(kAbility.GetSourceWeapon().GetMyTemplate()).iTypicalActionCost);
				}
				else
				{
					Cost = max(Cost, ActionPointCost.iNumPoints);
				}

				if (ActionPointCost.bMoveCost || ActionPointCost.bConsumeAllPoints)
				{
					Cost = max(Cost, 1);
				}
			}
		}

		// For movement effects, the actual cost depends on the path length.
		if (AbilityContext.InputContext.MovementPaths.Length > 0)
		{
			PathIndex = AbilityContext.GetMovePathIndex(SourceUnit.ObjectID);
			MovementCost = 1;
			
			for(i = AbilityContext.InputContext.MovementPaths[PathIndex].MovementTiles.Length - 1; i >= 0; --i)
			{
				if(AbilityContext.InputContext.MovementPaths[PathIndex].MovementTiles[i] == SourceUnit.TileLocation)
				{
					FarthestTile = i;
					break;
				}
			}
			for (i = 0; i < AbilityContext.InputContext.MovementPaths[PathIndex].CostIncreases.Length; ++i)
			{
				if (AbilityContext.InputContext.MovementPaths[PathIndex].CostIncreases[i] <= FarthestTile)
					MovementCost++;
			}

			Cost = max(Cost, MovementCost);
		}
	}

	`Log(kAbility.GetMyTemplateName() @ "Cost:" @ Cost @ "Spent:" @ PointsSpent);

	if (bRequireMinimumPointsSpent && PointsSpent < MinimumPointsSpent)
		return 'AA_InvalidActionPoints';  // NOTE: Nonstandard AA code
	if (bRequireMaximumPointsSpent && PointsSpent > MaximumPointsSpent)
		return 'AA_InvalidActionPoints';  // NOTE: Nonstandard AA code
	if (bRequireMinimumCost && Cost < MinimumCost)
		return 'AA_InvalidActionPoints';  // NOTE: Nonstandard AA code
	if (bRequireMaximumCost && Cost > MaximumCost)
		return 'AA_InvalidActionPoints';  // NOTE: Nonstandard AA code

	return 'AA_Success';
}