//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_Effect_TemporaryItem
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Persistent Effect for managing temp items
//--------------------------------------------------------------------------------------- 

class XComGameState_Effect_TemporaryItem extends XComGameState_BaseObject dependson(X2Effect_TemporaryItem);

var array<StateObjectReference> TemporaryItems; // temporary items granted only for the duration of the tactical mission
//var array<UnequippedItem> UnequippedItems;  // items that are removed only for the duration of the tactical mission

simulated function EventListenerReturn OnTacticalGameEnd(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateHistory		History;
	local XComGameState				NewGameState;
	local StateObjectReference		ItemRef;
	local XComGameState_Item		ItemState;
	local XComGameState_Unit		UnitState;
	
	History = `XCOMHISTORY;
	//XComHQ = `XCOMHQ;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Temporary Item Cleanup");
	foreach TemporaryItems(ItemRef)
	{
		if (ItemRef.ObjectID > 0)
		{
			ItemState = XComGameState_Item(History.GetGameStateForObjectID(ItemRef.ObjectID));
			if (ItemState != none)
			{
				UnitState = XComGameState_Unit(History.GetGameStateForObjectID(ItemState.OwnerStateObject.ObjectID));
				if (UnitState != none)
					UnitState.RemoveItemFromInventory(ItemState); // Remove the item from the unit's inventory
		
				// Remove the temporary item's gamestate object from history
				NewGameState.RemoveStateObject(ItemRef.ObjectID);
			}
		}
	}
	// Remove this gamestate object from history
	NewGameState.RemoveStateObject(ObjectID);

	if( NewGameState.GetNumGameStateObjects() > 0 )
		`GAMERULES.SubmitGameState(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);

	return ELR_NoInterrupt;
}