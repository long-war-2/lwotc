class X2Ability_PrimaryNadeLauncher extends X2Ability_Grenades;


static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(PrimaryLightOrdnance('PrimaryLightOrdnance',0,"img:///UILibrary_PerkIcons.UIPerk_equalizer"));
	Templates.AddItem(PrimaryLoadGrenades());
	
	return Templates;
}

static function X2AbilityTemplate PrimaryLightOrdnance(name TemplateName, int Bonus, string ImageIcon) {
	local X2AbilityTemplate									Template;
	local GrimyClassAN_BonusItemCharges						AmmoEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	Template.IconImage = ImageIcon;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	// This will tick once during application at the start of the player's turn and increase ammo of the specified items by the specified amounts
	AmmoEffect = new class'GrimyClassAN_BonusItemCharges';
	AmmoEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin); 
	AmmoEffect.DuplicateResponse = eDupe_Allow;
	AmmoEffect.AmmoCount = Bonus;
	AmmoEffect.bUtilityGrenades = true;
	AmmoEffect.bPocketGrenades = true;
	Template.AddTargetEffect(AmmoEffect);


	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate PrimaryLoadGrenades()
{
	local X2AbilityTemplate									Template;
	local PrimaryMicroLauncher_LoadGrenades					AmmoEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'PrimaryLoadGrenades');

	Template.OverrideAbilities.AddItem('ThrowGrenade');
	
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	//Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_hunter";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Template.bDisplayInUITacticalText = false;

	// This will tick once during application at the start of the player's turn and increase ammo of the specified items by the specified amounts
	AmmoEffect = new class'PrimaryMicroLauncher_LoadGrenades';
	AmmoEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin); 
	AmmoEffect.DuplicateResponse = eDupe_Allow;
	Template.AddTargetEffect(AmmoEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}
