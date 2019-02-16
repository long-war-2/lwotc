class X2AbilityCooldown_MindMerge extends X2AbilityCooldown;

var int MIND_MERGE_COOLDOWN;
var int SOUL_MERGE_COOLDOWN_REDUCTION;

simulated function int GetNumTurns(XComGameState_Ability kAbility, XComGameState_BaseObject AffectState, XComGameState_Item AffectWeapon, XComGameState NewGameState)
{
	local StateObjectReference	SoulMergeRef;

	SoulMergeRef = XComGameState_Unit(AffectState).FindAbility('SoulMerge');
	if (SoulMergeRef.ObjectID != 0)
	{
		return MIND_MERGE_COOLDOWN - SOUL_MERGE_COOLDOWN_REDUCTION;
	}
	return MIND_MERGE_COOLDOWN;
}

	//if (XComGameState_Unit(AffectState).HasSoldierAbility('SoulMerge'))