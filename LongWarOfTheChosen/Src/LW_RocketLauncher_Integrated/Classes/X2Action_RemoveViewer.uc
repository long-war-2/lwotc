class X2Action_RemoveViewer extends X2Action;

//	See X2Effect_IRI_PersistentSquadViewer

var XComGameState_SquadViewer SquadViewer;
	/*
function Init()
{
	super.Init();

	SquadViewer = XComGameState_SquadViewer(`XCOMHISTORY.GetGameStateForObjectID(RemovedEffect.CreatedObjectReference.ObjectID));
}*/

simulated state Executing
{
Begin:
	if (SquadViewer != none)
	{
		SquadViewer.DestroyVisualizer();
	}
	CompleteAction();
}