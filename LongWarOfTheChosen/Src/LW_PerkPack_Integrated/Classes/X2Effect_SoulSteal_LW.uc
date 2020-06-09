//---------------------------------------------------------------------------------------
//  FILE:   X2Effect_SoulSteal_LW.uc
//  AUTHOR:  Grobobobo/Modified for the bonus to depend on the psi amp tech
//  PURPOSE: Soul steal ablative effect
//---------------------------------------------------------------------------------------
class X2Effect_SoulSteal_LW extends X2Effect_ModifyStats;

var int SoulStealM1Shield;
var int SoulStealM2Shield;
var int SoulStealM3Shield;

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
		NewChange.StatAmount = SoulStealM3Shield;
	}
	else if (SourceItem.GetMyTemplateName() == 'PsiAmp_MG')
	{
		NewChange.StatAmount = SoulStealM2Shield;
	}
	else 
	{
		NewChange.StatAmount = SoulStealM1Shield;
	}

	NewChange.StatType = eStat_ShieldHP;
	NewChange.ModOp = MODOP_Addition;

	m_aStatChanges.AddItem(NewChange);

	NewEffectState.StatChanges = m_aStatChanges;

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}