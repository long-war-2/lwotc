//used with permission from NotSoLoneWolf

class X2Effect_ApplyRepairHeal_LW extends X2Effect;

var int PerUseHP;       //  amount of HP to heal for any application of the effect
var localized string HealedMessage;

var name IncreasedHealAbility;    //  Soldier ability that will use IncreasedPerUseHP
var int IncreasedPerUseHP;        //  used instead of PerUseHP if the above project is known

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Ability Ability;
	local XComGameState_Unit TargetUnit, SourceUnit;
	local XComGameState_Item ItemState;
	local X2GremlinTemplate GremlinTemplate;
	local int SourceObjectID, HealAmount, AblativeHealAmount;
	//local XComGameState_HeadquartersXCom XComHQ;  // unused?
	local XComGameStateHistory History;

	History = `XCOMHISTORY;
	Ability = XComGameState_Ability(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
	if (Ability == none)
		Ability = XComGameState_Ability(History.GetGameStateForObjectID(ApplyEffectParameters.AbilityStateObjectRef.ObjectID));
	
	TargetUnit = XComGameState_Unit(kNewTargetState);
	SourceObjectID = ApplyEffectParameters.SourceStateObjectRef.ObjectID;
	SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(SourceObjectID));
	
	if (Ability != none && TargetUnit != none)
	{
		HealAmount = PerUseHP;

		if (IncreasedHealAbility != '')
		{
			if (SourceUnit != none && (SourceUnit.HasAbilityFromAnySource(IncreasedHealAbility)))
			{
				HealAmount = IncreasedPerUseHP;
			}
		}

		ItemState = Ability.GetSourceWeapon();
		if (ItemState != none)
		{
			GremlinTemplate = X2GremlinTemplate(ItemState.GetMyTemplate());
			if (GremlinTemplate != none)
				HealAmount += GremlinTemplate.HealingBonus;
		}

		AblativeHealAmount = TargetUnit.GetMaxStat(eStat_ShieldHP) - TargetUnit.GetCurrentStat(eStat_ShieldHP);

		TargetUnit.ModifyCurrentStat(eStat_HP, HealAmount);
		TargetUnit.ModifyCurrentStat(eStat_ShieldHP, AblativeHealAmount);
		`TRIGGERXP('XpHealDamage', ApplyEffectParameters.SourceStateObjectRef, kNewTargetState.GetReference(), NewGameState);

		if ((SourceObjectID != TargetUnit.ObjectID) && SourceUnit.CanEarnSoldierRelationshipPoints(TargetUnit)) // pmiller - so that you can't have a relationship with yourself
		{
			SourceUnit = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', SourceObjectID));
			SourceUnit.AddToSquadmateScore(TargetUnit.ObjectID, class'X2ExperienceConfig'.default.SquadmateScore_MedikitHeal);
			TargetUnit.AddToSquadmateScore(SourceUnit.ObjectID, class'X2ExperienceConfig'.default.SquadmateScore_MedikitHeal);
		}
	}
}

simulated function AddX2ActionsForVisualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local XComGameState_Unit OldUnit, NewUnit;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local int Healed;
	local string Message;

	OldUnit = XComGameState_Unit(ActionMetadata.StateObject_OldState);
	NewUnit = XComGameState_Unit(ActionMetadata.StateObject_NewState);

	if (OldUnit != none && NewUnit != None)
	{
		Healed = NewUnit.GetCurrentStat(eStat_HP) - OldUnit.GetCurrentStat(eStat_HP);
		
		//if (Healed != 0)
		//{
			SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
			Message = Repl(default.HealedMessage, "<Heal/>", Healed);
			SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Message, '', eColor_Good);
		//}		
	}
}

simulated function AddX2ActionsForVisualization_Tick(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const int TickIndex, XComGameState_Effect EffectState)
{
	AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 'AA_Success');
}
