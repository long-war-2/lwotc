class X2Rocket_Nuke extends X2Item config(Rockets) dependson (X2Condition_RocketArmedCheck);

var config bool CREATE_ROCKET;

var config WeaponDamageValue BaseDamage;
var config array<WeaponDamageValue> EXTRA_DAMAGE;
var config int PRIMARY_ENVIRONMENTAL_DAMAGE;
var config int SECONDARY_ENVIRONMENTAL_DAMAGE;

const DelayTime = 3.0f;

var config int SELF_DETONATION_TIMER_TURNS;
var config float EPICENTER_RELATIVE_RADIUS;

var config int iEnvironmentDamage;
var config int iClipSize;
var config int iSoundRange;
var config int Range;
var config int Radius;
var config int MOBILITY_PENALTY;

var config string Image;
var config string GAME_ARCHETYPE;

var config name WEAPON_TECH;
var config int Tier;
var config array<name> COMPATIBLE_LAUNCHERS;

var config bool REQUIRE_ARMING;
var config int TYPICAL_ACTION_COST;

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

var localized string str_NukeIsArmed;
var localized string str_NukeDetonationImminent;
var localized string str_NukeDetonation;

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
	local X2RocketTemplate 					Template;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;
	local X2Effect_NukeKnockback			KnockbackEffect;
	local ArtifactCost						Resources;
	local X2Effect_ApplyNukeEpicenterDamage	PrimaryDamage;
	local X2Effect_ApplyNukeOuterDamage		SecondaryDamage;
	//local X2Effect_NukeSpecialDeath			KillUnitEffect;
	local int i;
	
	`CREATE_X2TEMPLATE(class'X2RocketTemplate', Template, 'IRI_X2Rocket_Nuke');

	Template.AddAbilityIconOverride('IRI_FireTacticalNuke', "img:///IRI_RocketNuke.UI.Fire_Nuke");
	Template.AddAbilityIconOverride('IRI_FireTacticalNuke_Spark', "img:///IRI_RocketNuke.UI.Fire_Nuke");
	Template.AddAbilityIconOverride('IRI_GiveNuke', "img:///IRI_RocketNuke.UI.Give_Nuke");
	Template.AddAbilityIconOverride('IRI_ArmTacticalNuke', "img:///IRI_RocketNuke.UI.Arm_Nuke");

	Template.strImage = default.IMAGE;
	Template.EquipSound = "StrategyUI_Heavy_Weapon_Equip";
	
	Template.WeaponTech = default.WEAPON_TECH;
	Template.Tier = default.TIER;
	Template.COMPATIBLE_LAUNCHERS = default.COMPATIBLE_LAUNCHERS;
	
	Template.RequireArming = default.REQUIRE_ARMING;
	Template.iTypicalActionCost = default.TYPICAL_ACTION_COST;
	
	Template.GameArchetype = default.GAME_ARCHETYPE;
	Template.ExtraDamage = default.EXTRA_DAMAGE; 
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

	//	This effect will disintegrate dead units caught by the epicenter damage.
	//UnitPropertyCondition = new class'X2Condition_UnitProperty';
	//UnitPropertyCondition.ExcludeDead = false;
	//UnitPropertyCondition.ExcludeFriendlyToSource = false;

	//KillUnitEffect = new class'X2Effect_NukeSpecialDeath';
	//PrimaryDamage.TargetConditions.AddItem(UnitPropertyCondition);
	//Template.ThrownGrenadeEffects.AddItem(KillUnitEffect);

	//	Applies damage to targets far away from the center of the explosion
	//	Uses "IRI_Nuke_Secondary" Damage Tag
	SecondaryDamage = new class'X2Effect_ApplyNukeOuterDamage';
	SecondaryDamage.EnvironmentalDamageAmount = default.SECONDARY_ENVIRONMENTAL_DAMAGE;
	Template.ThrownGrenadeEffects.AddItem(SecondaryDamage);

	//	Applies damage to targets near the center of the explosion
	//	Uses "IRI_Nuke_Primary" Damage Tag
	PrimaryDamage = new class'X2Effect_ApplyNukeEpicenterDamage';
	PrimaryDamage.EnvironmentalDamageAmount = default.PRIMARY_ENVIRONMENTAL_DAMAGE;
	Template.ThrownGrenadeEffects.AddItem(PrimaryDamage);
	
	//	Base Damage is dealt across the whole radius evenly.
	if (default.BASEDAMAGE.Damage > 0)
	{
		Template.BaseDamage = default.BASEDAMAGE;
		Template.iEnvironmentDamage = default.IENVIRONMENTDAMAGE;

		WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
		WeaponDamageEffect.bExplosiveDamage = true;
		Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);
	}

	//Template.OnThrowBarkSoundCue = 'RocketLauncher';
	Template.OnThrowBarkSoundCue = '';
	
	KnockbackEffect = new class'X2Effect_NukeKnockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.ThrownGrenadeEffects.AddItem(KnockbackEffect);
	
	Template.DamageTypeTemplateName = Template.BaseDamage.DamageType;
	
	Template.Abilities.AddItem('GrenadeFuse');
	Template.Abilities.AddItem('IRI_RocketFuse');
	Template.Abilities.AddItem('IRI_FireTacticalNuke');
	//Template.Abilities.AddItem('IRI_RocketMobilityPenalty');
	Template.Abilities.AddItem('IRI_GiveNuke');
	Template.Abilities.AddItem('IRI_AggregateRocketAmmo');
	Template.Abilities.AddItem('IRI_ArmTacticalNuke');
	//Template.Abilities.AddItem('IRI_DisarmRocket');
	
	Template.iPhysicsImpulse = 10;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel,, default.RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel,, default.RADIUS);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel,, default.BASEDAMAGE.Shred);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, Template.MobilityPenalty);

	Template.PairedTemplateName = 'IRI_X2Rocket_Nuke_Pair';

	return Template;
}

static function X2DataTemplate Create_Rocket_Pair()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'IRI_X2Rocket_Nuke_Pair');

	Template.GameArchetype = default.GAME_ARCHETYPE;
	
	Template.ItemCat = 'cosmetic_rocket';
	Template.WeaponCat = 'rocket';

	return Template;
}

//	Adjusted to delay the damage to environmental objects in the Outer Radius of the explosion.
static function FireTacticalNuke_BuildVisualization(XComGameState VisualizeGameState)
{	
	local XComGameStateVisualizationMgr		VisMgr;
	local X2Action							Action;
	//local array<X2Action>					Actions;
	local XComGameStateContext_Ability		AbilityContext;
	local VisualizationActionMetadata		ActionMetadata;
	local X2Action_PlaySoundAndFlyOver		SoundAndFlyOver;
	local X2Action_TimedWait				TimedWait;
	local X2Action_WaitForAbilityEffect		WaitAction;
	local X2Action_SetGlobalTimeDilation	TimeDilation;
	local X2Action_CameraLookAt				CameraAction;
	//local XComGameState_Unit				TargetUnit;		

	class'X2Ability'.static.TypicalAbility_BuildVisualization(VisualizeGameState);

	VisMgr = `XCOMVISUALIZATIONMGR;

	Action = VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_Fire');
	AbilityContext = XComGameStateContext_Ability(Action.StateChangeContext);
	ActionMetaData = Action.Metadata;

	WaitAction = X2Action_WaitForAbilityEffect(class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, AbilityContext, false, Action));

	//	Slow down time once projectile connects
	TimeDilation = X2Action_SetGlobalTimeDilation(class'X2Action_SetGlobalTimeDilation'.static.AddToVisualizationTree(ActionMetadata, AbilityContext, false, WaitAction));
	TimeDilation.TimeDilation = 0.33f;

	//	For this amount of time. The actual duration will be longer due to Time Dilation. Duh.
	TimedWait = X2Action_TimedWait(class'X2Action_TimedWait'.static.AddToVisualizationTree(ActionMetadata, AbilityContext, false, TimeDilation));
	TimedWait.DelayTimeSec = 1.3f;

	//	Then restore normal speed.
	TimeDilation = X2Action_SetGlobalTimeDilation(class'X2Action_SetGlobalTimeDilation'.static.AddToVisualizationTree(ActionMetadata, AbilityContext, false, TimedWait));
	TimeDilation.TimeDilation = 1.0f;

	//	Add "Firing Rocket" speech. Had to remove it from the rocket itself because Nuke Self Detonation makes the soldier say it as well.
	Action = VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_ExitCover');

	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, AbilityContext,  false, Action));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "",  'RocketLauncher',  eColor_Bad);

	//	Wait for five seconds before moving the camera - that's a smidge longer than it takes to load and fire a rocket.
	TimedWait = X2Action_TimedWait(class'X2Action_TimedWait'.static.AddToVisualizationTree(ActionMetadata, AbilityContext, false, Action));
	TimedWait.DelayTimeSec = 5.1f;

	//	Normal targeting camera is a bit schitzofrenic. Just force it to look at the explosion as soon as the rocket is fired.
	CameraAction = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.AddToVisualizationTree(ActionMetadata, AbilityContext, false, TimedWait));
	CameraAction.BlockUntilFinished = true;
	CameraAction.BlockUntilActorOnScreen = true;
	CameraAction.LookAtLocation = AbilityContext.InputContext.TargetLocations[0];
	CameraAction.LookAtDuration = 6.0f;

	// Disintegrate enemies killed by epicenter damage
	/*
	VisMgr.GetNodesOfType(VisMgr.BuildVisTree, class'X2Action_Death', Actions);
	foreach Actions(Action)
	{
		TargetUnit = XComGameState_Unit(Action.Metadata.StateObject_NewState);
		if (TargetUnit != none && TargetUnit.IsDead() && TargetUnit.bSpecialDeathOccured)
		{
			ActionMetadata = Action.Metadata;
			class'X2Action_RemoveUnit'.static.AddToVisualizationTree(ActionMetadata, AbilityContext, true, Action);
		}
	}*/
}

static function EventListenerReturn Nuke_SelfDetonation_Listener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_Ability			AbilityState;
	local XComGameStateHistory			History;
	local XComGameState_Unit			UnitState;
	local int							VisualizeIndex;
	local XComGameStateContext			FindContext;
	local array<vector>					TargetLocs;
	local array<StateObjectReference>	NukeRefs;
	local StateObjectReference			Ref;
	local EArmedRocketStatus			RocketStatus;

	History = `XCOMHISTORY;

	////`LOG("Listener activated.",, 'IRIROCK');

	//	Cycle through all Unit States as they were the moment "Player Turn Ended" event has triggered.
	foreach History.IterateByClassType(class'XComGameState_Unit', UnitState,,, GameState.HistoryIndex)
	{
		////`LOG("Player turn ended for unit: " @ UnitState.GetFullName(),, 'IRIROCK');
		NukeRefs.Length = 0;
		GetEquippedNukesRefs(UnitState, GameState, NukeRefs);

		////`LOG("Unit has nukes: " @ NukeRefs.Length,, 'IRIROCK');

		foreach NukeRefs(Ref)
		{
			//	Try to find the ability on the unit.
			AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(UnitState.FindAbility('IRI_RocketFuse', Ref).ObjectID));
		
			if (AbilityState != none)
			{
				////`LOG("It has ability, proceeding with checks.",, 'IRIROCK');
				////`LOG("Rocket armed: " @ class'X2Condition_RocketArmed'.static.IsRocketArmed(AbilityState, true) == 'AA_Success',, 'IRIROCK');
				////`LOG("Unit DOES NOT have the Nuke Armed effect: " @ UnitState.AffectedByEffectNames.Find('IRI_Nuke_Armed_Effect') == INDEX_NONE,, 'IRIROCK'); 

				RocketStatus = class'X2Condition_RocketArmedCheck '.static.GetRocketArmedStatus(UnitState, AbilityState.SourceWeapon.ObjectID);

				if (UnitState.AffectedByEffectNames.Find('IRI_Nuke_Armed_Effect') == INDEX_NONE && 
					RocketStatus > eRocketArmed_DoesNotRequireArming)	//	Check if this rocket requires arming and is armed
				{
					////`LOG("Checks passed, activating.",, 'IRIROCK');

					VisualizeIndex = GameState.HistoryIndex;
					while( FindContext.InterruptionHistoryIndex > -1 )
					{
						FindContext = History.GetGameStateFromHistory(FindContext.InterruptionHistoryIndex).GetContext();
						VisualizeIndex = FindContext.AssociatedState.HistoryIndex;
					}

					TargetLocs.AddItem(`XWORLD.GetPositionFromTileCoordinates(UnitState.TileLocation));
					if (AbilityState.AbilityTriggerAgainstTargetIndex(0, VisualizeIndex, TargetLocs))
						return ELR_InterruptListeners;
				}
			}
		}
	}
	return ELR_NoInterrupt;
}

static function Nuke_SelfDetonation_BuildVisualization(XComGameState VisualizeGameState)
{	
	local XComGameStateVisualizationMgr		VisMgr;
	local X2Action							Action;
	local array<X2Action>					Actions;
	local VisualizationActionMetadata		ActionMetadata;
	local X2Action_PlaySoundAndFlyOver		SoundAndFlyOver;
	local XComGameStateContext_Ability		AbilityContext;

	class'X2Ability'.static.TypicalAbility_BuildVisualization(VisualizeGameState);

	VisMgr = `XCOMVISUALIZATIONMGR;

	//`LOG("========= TREE BEFORE ===============");
	PrintActionRecursive(VisMgr.BuildVisTree, 0);
	//`LOG("-------------------------------------");

	VisMgr.GetNodesOfType(VisMgr.BuildVisTree, class'X2Action_PlaySoundAndFlyOver', Actions);

	foreach Actions(Action)
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(Action);

		if (SoundAndFlyOver.CharSpeech != '')
		{
			//`LOG("Destroying action with speech: " @ SoundAndFlyOver.CharSpeech);
			VisMgr.DestroyAction(SoundAndFlyOver, true);
		}
	}

	//	Insert a PlayAnimation action right before the Fire Action
	//PlayAnimation = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, AbilityContext, true, Action.ParentActions[0]));
	//PlayAnimation.Params.AnimName = 'HL_SelfDetonateNuke';
	//PlayAnimation.Params.BlendTime = 1.0f;

	//Action = VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_ExitCover');
	//VisMgr.DisconnectAction(Action);

	//Action = VisMgr.GetNodesOfType(VisMgr.BuildVisTree, class'X2Action_Fire');
	Action = VisMgr.GetNodeOfType(VisMgr.BuildVisTree, class'X2Action_ExitCover');
	AbilityContext = XComGameStateContext_Ability(Action.StateChangeContext);
	ActionMetaData = Action.Metadata;

	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, AbilityContext,  false, Action));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, class'X2Rocket_Nuke'.default.str_NukeDetonation,  'Inspire',  eColor_Bad, "img:///UILibrary_PerkIcons.UIPerk_fuse"); //'ShredStormCannon'


	//`LOG("========= TREE AFTER ===============");
	PrintActionRecursive(VisMgr.BuildVisTree, 0);
	//`LOG("-------------------------------------");
}


static function PrintActionRecursive(X2Action Action, int iLayer)
{
	local X2Action ChildAction;

	//`LOG("Action layer: " @ iLayer @ ": " @ Action.Class.Name,, 'IRIPISTOLVIZ'); 
	foreach Action.ChildActions(ChildAction)
	{
		PrintActionRecursive(ChildAction, iLayer + 1);
	}
}

static function GetEquippedNukesRefs(const XComGameState_Unit UnitState, XComGameState CheckGameState, out array<StateObjectReference> ReturnArray)
{
	local StateObjectReference	Ref;
	local XComGameState_Item	ItemState;

	foreach UnitState.InventoryItems(Ref)
	{
		ItemState = UnitState.GetItemGameState(Ref, CheckGameState, false);
		if (ItemState != none && ItemState.GetMyTemplateName() == 'IRI_X2Rocket_Nuke')
		{
			ReturnArray.AddItem(Ref);
		}
	}
}

public static function bool IsNuke(const int ObjectID)
{
	local XComGameState_Item RocketState;

	RocketState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(ObjectID));

	if (RocketState != none && RocketState.GetMyTemplateName() == 'IRI_X2Rocket_Nuke')
	{
		return true;
	}
	return false;
}
/*
public static function int SoldierHasArmedNuke(XComGameState_Unit UnitState)
{
	local XComGameState_Item RocketState;

	RocketState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(ObjectID));

	if (RocketState != none && RocketState.GetMyTemplateName() == 'IRI_X2Rocket_Nuke')
	{
		return true;
	}
	return false;
}*/