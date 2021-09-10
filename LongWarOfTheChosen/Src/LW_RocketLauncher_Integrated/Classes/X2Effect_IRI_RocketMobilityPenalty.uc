class X2Effect_IRI_RocketMobilityPenalty extends X2Effect_ModifyStats config(RocketLaunchers);

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local StatChange NewChange;
	local XComGameState_Unit UnitState;
	local XComGameState_Item ItemState;
	local X2RocketTemplate Rocket;
	local float AccMobilityPenalty;
	local StateObjectReference Ref; 
	local XComGameStateHistory History;

	//	Grab the Unit State of the soldier we're applying effect to
	UnitState = XComGameState_Unit(kNewTargetState);
	History = `XCOMHISTORY;

	//	go through all inventory items
	foreach UnitState.InventoryItems(Ref)
	{
		ItemState = XComGameState_Item(History.GetGameStateForObjectID(Ref.ObjectID));
		Rocket = X2RocketTemplate(ItemState.GetMyTemplate());

		//	if the inventory item is a rocket, we take its MobilityPenalty, multiply it by the amount of remaining ammo
		//	and add it to the Accumulated Mobiltiy Penalty for this soldier
		if(Rocket == none) continue;
		else AccMobilityPenalty += ItemState.Ammo * Rocket.MobilityPenalty;
	}

	//	set the mobility penalty
	NewChange.StatType = eStat_Mobility;
	NewChange.StatAmount = AccMobilityPenalty;	//	StatAmount is float too, but somewhere later in game's code the mobility stat gets truncated, 
	NewChange.ModOp = MODOP_Addition;			//	so subtracting 0.25f is the same as subtracting a full 1.
												//	from our perspective, it means a mobility penalty of 1.25f is equal to 2.0, i.e. it's rounded up
	NewEffectState.StatChanges.AddItem(NewChange);

	//	and apply it
	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}