//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_Shell
//  AUTHOR:  Amineri / Pavonis Interactive
//
//  PURPOSE: Early game hook to allow detailed config modifications
//--------------------------------------------------------------------------------------- 

class UIScreenListener_Shell extends UIScreenListener config(AI);

//`include(LongWaroftheChosen\Src\LW_Overhaul.uci)

var config array<name> BehaviorRemovals;
var config array<BehaviorTreeNode> NewBehaviors;

var private bool HasInited;

event OnInit(UIScreen Screen)
{
	local XComOnlineProfileSettings m_kProfileSettings;

	if(UIShell(Screen) == none)  // this captures UIShell and UIFinalShell
		return;

    // We only want to perform this once per game cycle. If the user goes back to the main menu
    // after starting/loading a game, we don't want to perform all the manipulations again.
    if (HasInited)
    {
        return;
    }

    HasInited = true;

	m_kProfileSettings = `XPROFILESETTINGS;
	if (m_kProfileSettings != none)
	{
		m_kProfileSettings.Data.SetControllerIconType(eControllerIconType_Mouse);
	}

    // Apply all AI Jobs, adding new items as needed
	// WOTC TODO: Is this needed?
    //UpdateAIBehaviors();
}

/* WOTC TODO: Is this needed? I'm trying with pure config adjustments as `Behaviors` property is unmodifiable
static function UpdateAIBehaviors()
{
	local X2AIBTBehaviorTree BehaviorTree;
	local name BehaviorName;
	local BehaviorTreeNode NewBehavior;
	local int idx;

	BehaviorTree = `BEHAVIORTREEMGR;

	foreach default.BehaviorRemovals(BehaviorName)
	{
		idx = BehaviorTree.Behaviors.Find('BehaviorName', BehaviorName);
		if (idx >= 0)
		{
			BehaviorTree.Behaviors.Remove(idx, 1);
		}
	}

	foreach default.NewBehaviors(NewBehavior)
	{
		BehaviorTree.Behaviors.AddItem(NewBehavior);
	}

	BehaviorTree.InitBehaviors();
}
*/

defaultProperties
{
    ScreenClass = none
}
