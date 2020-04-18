class X2Effect_NoLootAndCorpse extends X2Effect_Persistent;

function bool DoesEffectAllowUnitToBeLooted(XComGameState NewGameState, XComGameState_Unit UnitState) { return false; }
