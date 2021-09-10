class X2Condition_NumberOfRockets extends X2Condition;

//	this condition checks how many rockets the target soldier is carrying.
//	it counts specifically inventory items, and not the total rocket ammo.

var int MinRockets;
var int MaxRockets;

event name CallAbilityMeetsCondition(XComGameState_Ability kAbility, XComGameState_BaseObject kTarget)
{
	local XComGameState_Unit UnitState;
	local int CurrentRockets;

	UnitState = XComGameState_Unit(kTarget);

	if (UnitState == none) return 'AA_NotAUnit';

	CurrentRockets = class'X2RocketTemplate'.static.CountRocketsOnSoldier(UnitState);

	if (CurrentRockets >= MinRockets && CurrentRockets <= MaxRockets) return 'AA_Success';

	return 'AA_AmmoAlreadyFull';
}

defaultproperties
{
	MinRockets = 0
	MaxRockets = 0
}