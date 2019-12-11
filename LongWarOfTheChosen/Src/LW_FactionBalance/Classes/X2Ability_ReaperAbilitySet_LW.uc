//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_ReaperAbilitySet_LW
//  AUTHOR:  martox
//  PURPOSE: New Reaper abilities added by LWOTC.
//--------------------------------------------------------------------------------------- 

class X2Ability_ReaperAbilitySet_LW extends X2Ability config(LW_FactionBalance);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(Distraction_LW());
	Templates.AddItem(ClaymoreDisorient());

	return Templates;
}

static function X2AbilityTemplate Distraction_LW()
{
	local X2AbilityTemplate						Template;
	local X2Effect_ClaymoreDistraction			ClaymoreDistractionEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Distraction_LW');	
	
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_distraction";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;
	Template.bCrossClassEligible = false;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.AdditionalAbilities.AddItem('ClaymoreDisorient');

	ClaymoreDistractionEffect = new class'X2Effect_ClaymoreDistraction';
	ClaymoreDistractionEffect.AbilityToTrigger = 'ClaymoreDisorient';
	ClaymoreDistractionEffect.BuildPersistentEffect(1, true, false);
	ClaymoreDistractionEffect.SetDisplayInfo(
		ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription,
		Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddTargetEffect(ClaymoreDistractionEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	// Note: no visualization on purpose!

	return Template;	
}

static function X2AbilityTemplate ClaymoreDisorient()
{
	local X2AbilityTemplate				Template;
	local X2AbilityMultiTarget_Radius	RadiusMultiTarget;
	local X2Condition_UnitProperty		UnitPropertyCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ClaymoreDisorient');
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_standard";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	RadiusMultiTarget.fTargetRadius = class'X2Ability_ReaperAbilitySet'.default.HomingMineRadius;
	RadiusMultiTarget.AddAbilityBonusRadius('Shrapnel', class'X2Ability_ReaperAbilitySet'.default.HomingShrapnelBonusRadius);
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	UnitPropertyCondition.ExcludeOrganic = false;
	UnitPropertyCondition.ExcludeRobotic = true;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	Template.AddMultiTargetEffect(class'X2StatusEffects'.static.CreateDisorientedStatusEffect(, , false));

	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.MergeVisualizationFn = ClaymoreDisorient_MergeVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.GrenadeLostSpawnIncreasePerUse;

	return Template;
}

// Copied and modified from HomingMineDetonation_MergeVisualization
//
// Makes sure the disorient effect and flyover appear after the Claymore explosion.
static function ClaymoreDisorient_MergeVisualization(X2Action BuildTree, out X2Action VisualizationTree)
{
	local XComGameStateVisualizationMgr VisMgr;
	local Array<X2Action> DamageActions;
	local int ScanAction;
	local X2Action_ApplyWeaponDamageToTerrain TestDamage;
	local X2Action_MarkerNamed NamedMarkerAction;
	local X2Action_MarkerNamed PlaceWithAction;
	local X2Action_MarkerTreeInsertBegin MarkerStart;
	local XComGameStateContext_Ability Context;
	local XComGameState_Destructible Destructible;

	VisMgr = `XCOMVISUALIZATIONMGR;

	MarkerStart = X2Action_MarkerTreeInsertBegin(VisMgr.GetNodeOfType(BuildTree, class'X2Action_MarkerTreeInsertBegin'));
	Context = XComGameStateContext_Ability(MarkerStart.StateChangeContext);

	// Jwats: Find the apply weapon damage to unit that caused us to explode and put our visualization with it
	// WaitForFireEvent = X2Action_WaitForAbilityEffect(VisMgr.GetNodeOfType(BuildTree, class'X2Action_AbilityPerkStart'));
	VisMgr.GetNodesOfType(VisualizationTree, class'X2Action_ApplyWeaponDamageToTerrain', DamageActions, , Context.InputContext.PrimaryTarget.ObjectID);
	for (ScanAction = 0; ScanAction < DamageActions.Length; ++ScanAction)
	{
		TestDamage = X2Action_ApplyWeaponDamageToTerrain(DamageActions[ScanAction]);
		Destructible = XComGameState_Destructible(TestDamage.MetaData.StateObject_NewState);
		if (Destructible != none &&
			InStr(Destructible.SpawnedDestructibleArchetype, "ReaperClaymore.Archetypes.ARC_ReaperClaymore") != INDEX_NONE)
		{
			break;
		}
	}

	for (ScanAction = 0; ScanAction < TestDamage.ChildActions.Length; ++ScanAction)
	{
		NamedMarkerAction = X2Action_MarkerNamed(TestDamage.ChildActions[ScanAction]);
		if (NamedMarkerAction.MarkerName == 'Join')
		{
			PlaceWithAction = NamedMarkerAction;
			break;
		}
	}

	if (PlaceWithAction != none)
	{
		VisMgr.DisconnectAction(MarkerStart);
		VisMgr.ConnectAction(MarkerStart, VisualizationTree, false, PlaceWithAction);
	}
	else
	{
		Context.SuperMergeIntoVisualizationTree(BuildTree, VisualizationTree);
	}
}

static function PrintActionRecursive(X2Action Action, int iLayer)
{
    local X2Action ChildAction;

    `LOG("Action layer: " @ iLayer @ ": " @ Action.Class.Name,, 'LWOTC'); 
    foreach Action.ChildActions(ChildAction)
    {
        PrintActionRecursive(ChildAction, iLayer + 1);
    }
}
