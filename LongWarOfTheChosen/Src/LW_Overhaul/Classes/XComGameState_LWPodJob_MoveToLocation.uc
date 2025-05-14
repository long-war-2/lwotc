//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_LWPodJob_MoveToLocation.uc
//  AUTHOR:  tracktwo (Pavonis Interactive)
//  PURPOSE: A pod job to move to a particular location on the map.
//---------------------------------------------------------------------------------------
class XComGameState_LWPodJob_MoveToLocation extends XComGameState_LWPodJob config(LW_PodManager);

var config const int DESTINATION_REACHED_SIZE_SQ;

// The target location
var Vector Location;

// Should we keep this job after we reach the destination?
var bool KeepJobAfterReachingDestination;

function InitJob(LWPodJobTemplate JobTemplate, XComGameState_AIGroup Group, int JobID, EAlertCause Cause, String Tag, XComGameState NewGameState)
{
    super.InitJob(JobTemplate, Group, JobID, Cause, Tag, NewGameState);

    // Tedster - disabling this here so the initial location is set during ProcessTurn which is called in the same gamestate frame as InitJob.
    // Otherwise, if 2 different locations get set, the pod will freeze because SetAlertAtLocation will yeet it from the state.
    // The only other call that might matter is the PodJob_Flank, so I've added it there.

    //Location = SetAlertAtLocation(Location, Group, NewGameState);
    //`LWTrace("Move to location Job Init: Alert location set:" @Location.x @Location.Y @Location.Z);
}

function bool ProcessTurn(XComGameState_LWPodManager PodMgr, XComGameState NewGameState)
{
    local Vector NewDestination;
    local XComGameState_AIGroup Group;
    local LWPodJobTemplate Template;

    if (!ShouldContinueJob(NewGameState))
    {
        return false;
    }
   // `LWTrace("ProcessTurn for job happening");

    Template = GetMyTemplate();

    if (Template.GetNewDestination != none)
    {
        Group = XComGameState_AIGroup(`XCOMHISTORY.GetGameStateForObjectID(GroupRef.ObjectID));
        NewDestination = AdjustLocation(Template.GetNewDestination(self, NewGameState), Group);

        //`LWTrace("New Destination value:" @NewDestination.x @NewDestination.Y @NewDestination.Z);
        //`LWTrace("Existing Location Value:" @Location.X @Location.Y @Location.Z);
        
        if (Location != NewDestination)
        {
            Location = SetAlertAtLocation(NewDestination, Group, NewGameState);
        }
        else
        {
            //`LWTrace("No location update, not updating AI Group");
        }
    }

    return true;
}

function XComGameState_AIGroup GetGroup()
{
    return XComGameState_AIGroup(`XCOMHISTORY.GetGameStateForObjectID(GroupRef.ObjectID));
}

function bool HasReachedDestination()
{
	local XComGameState_AIGroup Group;

	Group = GetGroup();
    return (VSizeSq(Group.GetGroupMidpoint() - Location) < DESTINATION_REACHED_SIZE_SQ);
}

function bool ShouldContinueJob(XComGameState NewGameState)
{
    // Have we reached our destination?
    if (HasReachedDestination())
    {
        // We're here!
        return KeepJobAfterReachingDestination;
    }

    // We haven't yet arrived. Use the standard mechanism to allow job timeouts if they can't get
    // to the destination, even if they would keep the job forever after getting there.
    if (!super.ShouldContinueJob(NewGameState))
    {
        return false;
    }

    return true;
}

function String GetDebugString()
{
    return Super.GetDebugString() $ " @ " $ Location;
}

function DrawDebugLabel(Canvas kCanvas)
{
    local XComGameState_AIGroup Group;
    local Vector CurrentGroupLocation;
    local Vector ScaleVector;
    local SimpleShapeManager ShapeManager;

    Group = XComGameState_AIGroup(`XCOMHISTORY.GetGameStateForObjectID(GroupRef.ObjectID));
    CurrentGroupLocation = Group.GetGroupMidpoint();
    
    ScaleVector = vect(64, 64, 64);
    ShapeManager = `SHAPEMGR;

    ShapeManager.DrawSphere(CurrentGroupLocation, ScaleVector, MakeLinearColor(0, 0.75, 0.75, 1));
    ShapeManager.DrawSphere(Location, ScaleVector, MakeLinearColor(0.75, 0, 0.75, 1));
    ShapeManager.DrawLine(CurrentGroupLocation, Location, 8, MakeLinearColor(0, 0.75, 0.75, 1));
}

