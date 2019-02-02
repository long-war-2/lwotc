//--------------------------------------------------------------------------------------- 
//  FILE:    X2Effect_WarCry.uc
//  AUTHOR:	 John Lumpkin (Pavonis Interactive)
//  PURPOSE: Creates WarCry effect, which provides stat boosts to nearby friendly units
//--------------------------------------------------------------------------------------- 
Class X2Effect_WarCry extends X2Effect_ModifyStats
	config (LW_AlienPack);

var array<StatChange> m_aStatChangesHigh;
var array<StatChange> m_aStatChangesLow;

var array<name> CharacterNamesHigh;
var array<name> CharacterNamesLow;

var localized string strWarCryFriendlyDesc;

/// <summary>
/// Implements War Cry ability 
/// </summary>


simulated function AddPersistentStatChange(ECharStatType StatType, float StatAmount, bool HighStat, optional EStatModOp InModOp=MODOP_Addition)
{
	local StatChange NewChange;
 	NewChange.StatType = StatType;
	NewChange.StatAmount = StatAmount;
	NewChange.ModOp = InModOp;
	if (HighStat)
		m_aStatChangesHigh.AddItem(NewChange);
	else
		m_aStatChangesLow.AddItem(NewChange);
}

simulated function AddCharacterNameHigh(name CharacterName)
{
	CharacterNamesHigh.AddItem(CharacterName);
}

simulated function AddCharacterNameLow(name CharacterName)
{
	CharacterNamesLow.AddItem(CharacterName);
}

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
local XComGameState_Unit	EffectTargetUnit;
local name					TargetUnitName;
local bool					ValidTarget;
local XComGameStateHistory	history;
 
	History = `XCOMHISTORY;
	EffectTargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));

	if (EffectTargetUnit == none)
	{
		ValidTarget = false;
	}
	else
	{
		TargetUnitName = EffectTargetUnit.GetMyTemplateName();
		if (CharacterNamesHigh.Find(TargetUnitName) != -1)
		{
			NewEffectState.StatChanges = m_aStatChangesHigh;
			ValidTarget = true;
		}
		else
		{ 
			if (CharacterNamesLow.Find(TargetUnitName) != -1)
			{
				NewEffectState.StatChanges = m_aStatChangesLow;
				ValidTarget = true;
			}
		}
	}
	if (ValidTarget)
	{
		super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
	}
}

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
    return EffectGameState.StatChanges.Length > 0;
}

defaultproperties
{
    EffectName=WarCry
}

