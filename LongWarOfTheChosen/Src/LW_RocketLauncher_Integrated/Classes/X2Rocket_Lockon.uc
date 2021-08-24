class X2Rocket_Lockon extends X2Item config(Rockets);

var name TemplateName;
var localized string LockonDirectDamageString;

var config bool CREATE_ROCKET;

var config bool CAN_MISS_WITH_HOLOTARGETING;
var config bool CAN_MISS_WITHOUT_HOLOTARGETING;
var config(Lockon) array<int> RANGE_ACCURACY;
var config int AIM_BONUS;

var config int SIZE_SCALING_AIM_BONUS;
var config int SIZE_SCALING_CRIT_BONUS;
var config bool SIZE_SCALING_CRIT_BONUS_IS_INVERTED;

var config WeaponDamageValue BaseDamage;
var config array<WeaponDamageValue> EXTRA_DAMAGE;

var config int iEnvironmentDamage;
var config int iClipSize;
var config int iSoundRange;
var config int Range;
var config int Radius;
var config int MOBILITY_PENALTY;

var config bool REQUIRE_ARMING;
var config int TYPICAL_ACTION_COST;

var config string Image;
var config string GAME_ARCHETYPE;

var config name WEAPON_TECH;
var config int Tier;

var config array<name> COMPATIBLE_LAUNCHERS;

var config bool STARTING_ITEM;
var config bool INFINITE_ITEM;
var config name CREATOR_TEMPLATE_NAME;
var config name HIDE_IF_TECH_RESEARCHED;
var config name HIDE_IF_ITEM_PURCHASED;
var config name BASE_ITEM;
var config bool CAN_BE_BUILT;
var config array<name> REQUIRED_TECHS;
var config array<name> REWARD_DECKS;
var config array<name> RESOURCE_COST_TYPE;
var config array<int> RESOURCE_COST_QUANTITY;
var config int BLACKMARKET_VALUE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	if (default.CREATE_ROCKET)
	{
		Templates.AddItem(Create_Rocket_Main());
		Templates.AddItem(Create_Rocket_Pair());
	}
	return Templates;
}

static function X2DataTemplate Create_Rocket_Main()
{
	local X2RocketTemplate 				Template;
	local X2Effect_ApplyWeaponDamage	WeaponDamageEffect;
	local X2Effect_Knockback			KnockbackEffect;
	local ArtifactCost					Resources;
	local int i;
	
	`CREATE_X2TEMPLATE(class'X2RocketTemplate', Template, default.TemplateName);

	Template.strImage = default.IMAGE;
	Template.EquipSound = "StrategyUI_Heavy_Weapon_Equip";

	Template.AddAbilityIconOverride('IRI_GiveRocket', "img:///IRI_RocketLaunchers.UI.Give_Lockon");
	Template.AddAbilityIconOverride('IRI_ArmRocket', "img:///IRI_RocketLaunchers.UI.Arm_Lockon");
	
	Template.WeaponTech = default.WEAPON_TECH;
	Template.Tier = default.TIER;

	Template.RangeAccuracy = default.RANGE_ACCURACY;
	Template.Aim = default.AIM_BONUS;

	Template.COMPATIBLE_LAUNCHERS = default.COMPATIBLE_LAUNCHERS;

	Template.RequireArming = default.REQUIRE_ARMING;
	Template.iTypicalActionCost = default.TYPICAL_ACTION_COST;
	
	Template.GameArchetype = default.GAME_ARCHETYPE;
	Template.BaseDamage = default.BASEDAMAGE;
	Template.ExtraDamage = default.EXTRA_DAMAGE; 
	Template.iEnvironmentDamage = default.IENVIRONMENTDAMAGE;
	Template.iRange = default.RANGE;
	Template.iRadius = default.RADIUS;
	Template.iSoundRange = default.ISOUNDRANGE;
	Template.iClipSize = default.ICLIPSIZE;
	if (Template.iClipSize <= 1) Template.bHideClipSizeStat = true;
	Template.MobilityPenalty = default.MOBILITY_PENALTY;
	
	Template.CanBeBuilt = default.CAN_BE_BUILT;
	Template.bInfiniteItem = default.INFINITE_ITEM;
	Template.StartingItem = default.STARTING_ITEM;
	
	Template.CreatorTemplateName = default.CREATOR_TEMPLATE_NAME;
	Template.BaseItem = default.BASE_ITEM;
	
	Template.RewardDecks = default.REWARD_DECKS;
	Template.HideIfResearched = default.HIDE_IF_TECH_RESEARCHED;
	Template.HideIfPurchased = default.HIDE_IF_ITEM_PURCHASED;

	Template.bCanBeDodged = true;
	
	if (!Template.bInfiniteItem)
	{
		Template.TradingPostValue = default.BLACKMARKET_VALUE;
		
		if (Template.CanBeBuilt)
		{
			Template.Requirements.RequiredTechs = default.REQUIRED_TECHS;
			
			for (i = 0; i < default.RESOURCE_COST_TYPE.Length; i++)
			{
				if (default.RESOURCE_COST_QUANTITY[i] > 0)
				{
					Resources.ItemTemplateName = default.RESOURCE_COST_TYPE[i];
					Resources.Quantity = default.RESOURCE_COST_QUANTITY[i];
					Template.Cost.ResourceCosts.AddItem(Resources);
				}
			}
		}
	}
	
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.ThrownGrenadeEffects.AddItem(KnockbackEffect);

	Template.OnThrowBarkSoundCue = 'RocketLauncher';
	
	Template.DamageTypeTemplateName = Template.BaseDamage.DamageType;

	Template.Abilities.AddItem('GrenadeFuse');
	Template.Abilities.AddItem('IRI_FireLockon');
	Template.Abilities.AddItem('IRI_LockAndFireLockon');
	Template.Abilities.AddItem('IRI_LockAndFireLockon_Holo');
	Template.Abilities.AddItem('IRI_RocketMobilityPenalty');
	//Template.Abilities.AddItem('IRI_GiveRocket');
	Template.Abilities.AddItem('IRI_AggregateRocketAmmo');
	Template.Abilities.AddItem('IRI_ArmRocket');
	Template.Abilities.AddItem('IRI_DisarmRocket');
	Template.Abilities.AddItem('IRI_LockonHitBonus');

	Template.iPhysicsImpulse = 10;
	
	Template.SetUIStatMarkup(default.LockonDirectDamageString,, default.EXTRA_DAMAGE[0].Damage);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel,, default.RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel,, default.RADIUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel,, default.BASEDAMAGE.Shred);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, Template.MobilityPenalty);

	Template.PairedTemplateName = name(default.TemplateName $ "_Pair");

	return Template;
}

static function X2DataTemplate Create_Rocket_Pair()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, name(default.TemplateName $ "_Pair"));

	Template.GameArchetype = default.GAME_ARCHETYPE;
	
	Template.ItemCat = 'cosmetic_rocket';
	Template.WeaponCat = 'rocket';

	return Template;
}

simulated function Lockon_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateVisualizationMgr		VisMgr;
	local X2Action							FoundAction;
	local VisualizationActionMetadata		ActionMetadata;
	local XComGameStateHistory				History;
	local XComGameStateContext_Ability		Context;
	local int								SourceUnitID;
	local X2Action_CameraLookAt				LookAtMissLocationAction, LookAtTargetAction;

	//	Call the typical ability visuailzation. With just that, the ability would look like the soldier firing the rocket upwards, and then enemy getting damage for seemingly no reason.
	class'X2Ability'.static.TypicalAbility_BuildVisualization(VisualizeGameState);

	VisMgr = `XCOMVISUALIZATIONMGR;
	History = `XCOMHISTORY;
	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	SourceUnitID = Context.InputContext.SourceObject.ObjectID;

	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(SourceUnitID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(SourceUnitID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(SourceUnitID);

	//	Find the Fire Action in vis tree configured by Typical Ability Build Viz
	FoundAction = VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_Fire');

	if (FoundAction != none)
	{
		//	Add a camera action as a child to the Fire Action's parent, that lets both Fire Action and Camera Action run in parallel
		//	pan camera towards the shooter for the firing animation
		LookAtTargetAction = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.AddToVisualizationTree(ActionMetadata, Context, false, FoundAction.ParentActions[0]));
		LookAtTargetAction.LookAtActor = ActionMetadata.VisualizeActor;
		LookAtTargetAction.LookAtDuration = 6.25f;
		LookAtTargetAction.BlockUntilActorOnScreen = true;
		LookAtTargetAction.BlockUntilFinished = true;
		//LookAtAction.TargetZoomAfterArrival = -0.5f; zooms in slowly and doesn't stop
		
		//	This action will pause the Vis Tree until the Unit Hit (Notify Target) Anim Notify is reached in the Fire Action's AnimSequence (in the Fire Lockon firing animation)
		class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context, true, FoundAction);

		//	Start setting up the action that will pan the camera towards the location of the primary target
		LookAtTargetAction = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.AddToVisualizationTree(ActionMetadata, Context, true, ActionMetadata.LastActionAdded));
		LookAtTargetAction.LookAtActor = History.GetVisualizer(Context.InputContext.PrimaryTarget.ObjectID);
		LookAtTargetAction.BlockUntilActorOnScreen = true;

		//	make the rocket fall down.
		class'X2Action_FireJavelin'.static.AddToVisualizationTree(ActionMetadata, Context, true, LookAtTargetAction);

		//	if the rocket missed, pan the camera towards its hit location
		if (Context.ResultContext.HitResult == eHit_Miss)
		{
			//	If the rocket misses, we still look at the target for a couple of seconds to fool the player into thinking the rocket might've hit
			LookAtTargetAction.LookAtDuration = 2.0f;
			LookAtTargetAction.BlockUntilFinished = true;

			//	Then we quickly pan the camera towards the miss location, disappointing the player
			LookAtMissLocationAction = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.AddToVisualizationTree(ActionMetadata, Context, false, LookAtTargetAction));
			LookAtMissLocationAction.LookAtLocation = Context.ResultContext.ProjectileHitLocations[0];
			LookAtMissLocationAction.BlockUntilActorOnScreen = true;
			LookAtMissLocationAction.LookAtDuration = 2.0f;
		}
		else
		{
			//	if the ability hit, we keep the camera on primary target slighly longer to make the player enjoy the looks
			LookAtTargetAction.LookAtDuration = 3.0f;
		}
	}
}

defaultproperties
{
	TemplateName = "IRI_X2Rocket_Lockon"
}