//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_RedFog_LW.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Provides ability definition for Long War version of Red Fog
//---------------------------------------------------------------------------------------
class X2Ability_RedFog_LW extends X2Ability config(LW_Toolbox);

//`include(LW_Overhaul\Src\LW_Overhaul.uci)

var config string RedFogIconImagePath;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateRedFogAbility());

	return Templates;
}

static function X2AbilityTemplate CreateRedFogAbility()
{
	local X2AbilityTemplate Template;
	local X2AbilityTrigger_UnitPostBeginPlay PostBeginPlayTrigger;
	local X2Effect_RedFog_LW RedFogEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RedFog_LW');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_criticallywounded";  
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;

	PostBeginPlayTrigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	PostBeginPlayTrigger.Priority -= 100;        // Lower priority to guarantee other stat-effecting abilities run first
	Template.AbilityTriggers.AddItem(PostBeginPlayTrigger);

	//Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_PlayerInput');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	//Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	
	RedFogEffect = new class'X2Effect_RedFog_LW';
	RedFogEffect.BuildPersistentEffect(1, true, true, true, eGameRule_PlayerTurnBegin); 
	//RedFogEffect.SetDisplayInfo	(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,, "img:///UILibrary_LWToolbox.Status_RedFog", Template.AbilitySourceName);
	RedFogEffect.SetDisplayInfo	(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,, "", Template.AbilitySourceName);
	RedFogEffect.bCanTickEveryAction = true;
	RedFogEffect.VisualizationFn = RedFogVisualization;
	RedFogEffect.EffectTickedVisualizationFn = RedFogVisualization;
	RedFogEffect.EffectRemovedVisualizationFn = RedFogVisualization;
	//RedFogEffect.EffectHierarchyValue = 1;
	
	Template.AddTargetEffect(RedFogEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildVisualizationFn = none;

	return Template;
}

static function RedFogVisualization (XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
    local XComGameState_Unit UnitState;

	if(!ActionMetadata.StateObject_NewState.IsA('XComGameState_Unit'))
    {
        return;
    }
	UnitState = XComGameState_Unit(ActionMetadata.StateObject_NewState);
	if(UnitState == none || UnitState.IsDead())
    {
        return;
    }
    class'X2StatusEffects'.static.UpdateUnitFlag(ActionMetadata, VisualizeGameState.GetContext());

}



DefaultProperties
{
}
