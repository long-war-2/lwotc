//---------------------------------------------------------------------------------------
//  FILE:    X2Ability_SitRepGrantedAbilitySet_LW.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Defines abilities that are granted through sit reps, typically at
//           the start of a mission.
//---------------------------------------------------------------------------------------
class X2Ability_SitRepGrantedAbilitySet_LW extends X2Ability config(LW_Overhaul);

var config int LETHARGY_AIM_PENALTY;
var config int LETHARGY_MOBILITY_PENALTY;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(CreateLethargyTemplate());

	return Templates;
}

static function X2AbilityTemplate CreateLethargyTemplate()
{
	local X2AbilityTemplate             Template;
	local X2Effect_PersistentStatChange PersistentStatChangeEffect;
	local X2Condition_UnitProperty		UnitPropertyCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Lethargy');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_advent_marktarget";

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.bIsPassive = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_UnitPostBeginPlay');

    // Makes non-robotic units lethargic    
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.FailOnNonUnits = true;
	UnitPropertyCondition.ExcludeOrganic = false;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, true);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Offense, default.LETHARGY_AIM_PENALTY, MODOP_Addition);
    PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.LETHARGY_MOBILITY_PENALTY, MODOP_Addition);
    PersistentStatChangeEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}
