//---------------------------------------------------------------------------------------
//  FILE:   X2Effect_SoulSteal_LW.uc
//  AUTHOR:  Grobobobo/Modified for the bonus to depend on the psi amp tech
//  PURPOSE: Soul steal ablative effect
//---------------------------------------------------------------------------------------
class X2Effect_SoulSteal_LW extends X2Effect_ModifyStats;

var int soulsteal_m1_shield;
var int soulsteal_m2_shield;
var int soulsteal_m3_shield;

// Start Issue #475
//
// Controls whether an effect can be reapplied to a unit that is already
// under the influence of that effect.
var bool bForceReapplyOnRefresh;
// End Issue #475

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local StatChange NewChange;
	local array<StatChange>	m_aStatChanges;
	local XComGameState_Item	SourceItem;

	SourceItem = XComGameState_Item(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));
	if (SourceItem == none)
    {
        SourceItem = XComGameState_Item(class'XComGameStateHistory'.static.GetGameStateHistory().GetGameStateForObjectID(ApplyEffectParameters.ItemStateObjectRef.ObjectID));
	}
	
	if (SourceItem.GetMyTemplateName() == 'PsiAmp_BM')
	{
		NewChange.StatAmount = soulsteal_m3_shield;
	}
	else if (SourceItem.GetMyTemplateName() == 'PsiAmp_MG')
	{
		NewChange.StatAmount = soulsteal_m2_shield;
	}
	else 
	{
		NewChange.StatAmount = soulsteal_m1_shield;
	}

	NewChange.StatType = eStat_ShieldHP;
	NewChange.ModOp = MODOP_Addition;

	m_aStatChanges.AddItem(NewChange);

	NewEffectState.StatChanges = m_aStatChanges;

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}
/*
simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata BuildTrack, name EffectApplyResult)
{
	local XComGameState_Unit OldUnitState, NewUnitState;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local string Msg;

	`LOG ("Soul Steal 2 activated");
	if (EffectApplyResult == 'AA_Success')
	{
		OldUnitState = XComGameState_Unit(BuildTrack.StateObject_OldState);
		NewUnitState = XComGameState_Unit(BuildTrack.StateObject_NewState);
		if (OldUnitState != none && NewUnitState != none)
		{
			SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, VisualizeGameState.GetContext(), false, BuildTrack.LastActionAdded));
			Msg = class'XGLocalizedData'.Default.ShieldedMessage;
			SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Msg, '', eColor_Good);
		}
	}
}
	*/