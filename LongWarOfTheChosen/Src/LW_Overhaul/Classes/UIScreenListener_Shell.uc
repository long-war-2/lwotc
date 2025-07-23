//---------------------------------------------------------------------------------------
//  FILE:    UIScreenListener_Shell
//  AUTHOR:  Amineri / Pavonis Interactive
//
//  PURPOSE: Early game hook to allow detailed config modifications
//--------------------------------------------------------------------------------------- 

class UIScreenListener_Shell extends UIScreenListener config(AI);

struct LWBehaviorTreeNodeReplacement
{
    var BehaviorTreeNode UpdatedBehavior;
	var string ModName;
    var int Priority;

	structdefaultproperties
	{
		Priority=50
	}
};

var config array<name> BehaviorRemovals;
var config array<BehaviorTreeNode> NewBehaviors;

// New Override behaviors array for mod compatibility. If there are entries in here, it WILL override NewBehaviors.
// higher priority number will be used to break ties if multiple entries in OverrideBehaviors go for the same behavior tree.

var config array<LWBehaviorTreeNodeReplacement> OverrideBehaviors;


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
    UpdateAIBehaviors();
}

static function UpdateAIBehaviors()
{
	local X2AIBTBehaviorTree BehaviorTree;
	local LWBehaviorTreeNodeReplacement CurrentReplacementTree;
	local name BehaviorName;
	local BehaviorTreeNode NewBehavior;
	local array<LWBehaviorTreeNodeReplacement> NewOverrideBehaviors;
	local int idx, j;

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

	// New handling for Override Behaviors:

	NewOverrideBehaviors.Length = 0;

	foreach default.OverrideBehaviors (CurrentReplacementTree)
	{
		BehaviorName = CurrentReplacementTree.UpdatedBehavior.BehaviorName;

		// mod installed check:

		if(!class'Helpers_LW'.static.IsModInstalled(CurrentReplacementTree.ModName))
		{
			continue;
		}

		idx = INDEX_NONE;

		idx = BehaviorTree.Behaviors.Find('BehaviorName', BehaviorName);
		if (idx >= 0)
		{
			BehaviorTree.Behaviors.Remove(idx, 1);
			`LWTrace("Removed behavior:" @BehaviorName);
		}
		
		idx = INDEX_NONE;

		for(j = 0; j < NewOverrideBehaviors.Length; j++)
		{
			if(!class'Helpers_LW'.static.IsModInstalled(NewOverrideBehaviors[j].ModName))
			{
				continue;
			}
			
			if(NewOverrideBehaviors[j].UpdatedBehavior.BehaviorName == BehaviorName)
			{
				idx = j;
				break;
			}
		}

		if (idx == INDEX_NONE)
		{
			NewOverrideBehaviors.AddItem(CurrentReplacementTree);
		}
		else if(NewOverrideBehaviors[idx].Priority < CurrentReplacementTree.Priority)
		{
			NewOverrideBehaviors[idx] = CurrentReplacementTree;
		}
	}

	foreach NewOverrideBehaviors (CurrentReplacementTree)
	{
		BehaviorTree.Behaviors.AddItem(CurrentReplacementTree.UpdatedBehavior);
		`LWTrace("Added NewOverrideBehavior" @CurrentReplacementTree.UpdatedBehavior.BehaviorName @ "from mod" @CurrentReplacementTree.ModName);
	}


	BehaviorTree.InitBehaviors();
}

defaultProperties
{
    ScreenClass = none
}
