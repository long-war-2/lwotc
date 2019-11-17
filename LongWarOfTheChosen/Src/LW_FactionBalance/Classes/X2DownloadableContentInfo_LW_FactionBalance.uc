//credit to AngelRane, NotSoLoneWolf, Udaya, and Grobobobo
class X2DownloadableContentInfo_LW_FactionBalance extends X2DownloadableContentInfo config (LW_FactionBalance);

var config int SkirmisherVengeance_COOLDOWN;
var config int Justice_COOLDOWN;
var config int WHIPLASH_COOLDOWN;
var config int INTERRUPT_COOLDOWN;
var config int WHIPLASH_AP;

var config int PILLAR_AP;
var config int STUNSTRIKE_KNOCKBACK_DISTANCE;
var config int STUNSTRIKE_STUN_DURATION;
var config int STUNSTRIKE_STUN_CHANCE;
var config float REAPER_DETECTION_RANGE_REDUCTION;


static event OnPostTemplatesCreated()
{
	IgnoreSuperConcealmentOnAllMissions();
	UpdateWhiplash();
	UpdateInterrupt();
	UpdateJustice();
	UpdateSkirmisherVengeance();
	UpdatePillar();
	UpdateStunStrike();
	UpdateGrapple();
	UpdateParry();
	UpdateDeflect();
	UpdateShadow();
	UpdateRemoteStart();
	AllowTwoSoldiersFromEachFaction();
}

static function IgnoreSuperConcealmentOnAllMissions()
{
	local int i;

	for (i = 0; i < `TACTICALMISSIONMGR.arrMissions.length; i++)
	{
		`TACTICALMISSIONMGR.arrMissions[i].IgnoreSuperConcealmentDetection = true;
	}
}

static function UpdateShadow()
{
	local X2AbilityTemplateManager			AbilityManager;
	local array<X2AbilityTemplate>			TemplateAllDifficulties;
	local X2AbilityTemplate					Template;

	local X2Effect_PersistentStatChange Effect;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityManager.FindAbilityTemplateAllDifficulties('ShadowPassive', TemplateAllDifficulties);

	Effect = new class'X2Effect_PersistentStatChange';
	Effect.AddPersistentStatChange(eStat_DetectionModifier, default.REAPER_DETECTION_RANGE_REDUCTION);
	foreach TemplateAllDifficulties(Template)
	{
		Template.AddTargetEffect(Effect);
	}
}
static function UpdateRemoteStart()
{
	local X2AbilityTemplateManager            AbilityManager;
	local array<X2AbilityTemplate>            TemplateAllDifficulties;
	local X2AbilityTemplate                    Template;
	local X2AbilityCharges                      Charges;
	local X2AbilityCost_Charges                 ChargeCost;

	
	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityManager.FindAbilityTemplateAllDifficulties('RemoteStart', TemplateAllDifficulties);
	
	foreach TemplateAllDifficulties(Template)//
	{
		Charges = new class 'X2AbilityCharges';
		Charges.InitialCharges = 1;
		Template.AbilityCharges = Charges;

		ChargeCost = new class'X2AbilityCost_Charges';
		ChargeCost.NumCharges = 1;
		Template.AbilityCosts.AddItem(ChargeCost);
	}
}

static function UpdateParry()
{
	local X2AbilityTemplateManager			AbilityManager;
	local array<X2AbilityTemplate>			TemplateAllDifficulties;
	local X2AbilityTemplate					Template;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityManager.FindAbilityTemplateAllDifficulties('Parry', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		EditParry(Template);
	}
}

static function UpdateDeflect()
{
	local X2AbilityTemplateManager			AbilityManager;
	local array<X2AbilityTemplate>			TemplateAllDifficulties;
	local X2AbilityTemplate					Template;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityManager.FindAbilityTemplateAllDifficulties('Deflect', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		EditDeflect(Template);
	}
}

static function UpdateWhiplash()
{
	local X2AbilityTemplateManager			AbilityManager;
	local array<X2AbilityTemplate>			TemplateAllDifficulties;
	local X2AbilityTemplate					Template;

	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCooldown					Cooldown;

	// Find the ability template called Whiplash
	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityManager.FindAbilityTemplateAllDifficulties('Whiplash', TemplateAllDifficulties);
	// Edit the template
	foreach TemplateAllDifficulties(Template)
	{
		// Kill the charges and the charge cost
		Template.AbilityCosts.Length = 0;
		Template.AbilityCharges = none;

		// Killing the above results in some collateral damage so we have to re-add the action point costs
		ActionPointCost = new class'X2AbilityCost_ActionPoints';
		ActionPointCost.iNumPoints = default.WHIPLASH_AP;
		ActionPointCost.bFreeCost = true;
		Template.AbilityCosts.AddItem(ActionPointCost);

		// And finally we take the cooldowns from our config file and apply them here
		Cooldown = new class'X2AbilityCooldown';
		Cooldown.iNumTurns = default.WHIPLASH_COOLDOWN;
		Template.AbilityCooldown = Cooldown;
	}
}

static function UpdateInterrupt()
{
	local X2AbilityTemplateManager			AbilityManager;
	local array<X2AbilityTemplate>			TemplateAllDifficulties;
	local X2AbilityTemplate					Template;

	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCooldown					Cooldown;

	// Find the ability template called InterruptInput
	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityManager.FindAbilityTemplateAllDifficulties('SkirmisherInterruptInput', TemplateAllDifficulties);
	// Edit the template
	foreach TemplateAllDifficulties(Template)
	{
		// Kill the charges and the charge cost
		Template.AbilityCosts.Length = 0;
		Template.AbilityCharges = none;

		// Killing the above results in some collateral damage so we have to re-add the action point costs
		ActionPointCost = new class'X2AbilityCost_ActionPoints';
		ActionPointCost.bConsumeAllPoints = true;
		ActionPointCost.bFreeCost = true;
		ActionPointCost.DoNotConsumeAllEffects.Length = 0;
		ActionPointCost.DoNotConsumeAllSoldierAbilities.Length = 0;
		ActionPointCost.AllowedTypes.RemoveItem(class'X2CharacterTemplateManager'.default.SkirmisherInterruptActionPoint);
		Template.AbilityCosts.AddItem(ActionPointCost);

		// And finally we take the cooldowns from our config file and apply them here
		Cooldown = new class'X2AbilityCooldown';
		Cooldown.iNumTurns = default.INTERRUPT_COOLDOWN;
		Template.AbilityCooldown = Cooldown;
	}
}

static function UpdateGrapple()
{
	local X2AbilityTemplateManager			AbilityManager;
	local array<X2AbilityTemplate>			TemplateAllDifficulties;
	local X2AbilityTemplate					Template;

	local X2AbilityCooldown_Grapple			Cooldown;

	// Find the ability called SkirmisherGrapple
	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityManager.FindAbilityTemplateAllDifficulties('SkirmisherGrapple', TemplateAllDifficulties);

	// Edit the template
	foreach TemplateAllDifficulties(Template)
	{
		// Kill the default cooldown
		Template.AbilityCooldown = none;

		// Have the ability check our custom X2AbilityCooldown_Grapple file to get its cooldown time
		Cooldown = new class'X2AbilityCooldown_Grapple';
		Template.AbilityCooldown = Cooldown;
	}
}

static function UpdateJustice()
{
	local X2AbilityTemplateManager			AbilityManager;
	local array<X2AbilityTemplate>			TemplateAllDifficulties;
	local X2AbilityTemplate					Template;

	local X2AbilityCooldown					Cooldown;

	// Find the ability template called Whiplash
	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityManager.FindAbilityTemplateAllDifficulties('Justice', TemplateAllDifficulties);
	// Edit the template
	foreach TemplateAllDifficulties(Template)
	{

		// And finally we take the cooldowns from our config file and apply them here
		Cooldown = new class'X2AbilityCooldown';
		Cooldown.iNumTurns = default.Justice_COOLDOWN;
		Template.AbilityCooldown = Cooldown;
	}
}

static function UpdateSkirmisherVengeance()
{
	local X2AbilityTemplateManager			AbilityManager;
	local array<X2AbilityTemplate>			TemplateAllDifficulties;
	local X2AbilityTemplate					Template;

	local X2AbilityCooldown					Cooldown;

	// Find the ability template called Whiplash
	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityManager.FindAbilityTemplateAllDifficulties('SkirmisherVengeance', TemplateAllDifficulties);
	// Edit the template
	foreach TemplateAllDifficulties(Template)
	{

		// And finally we take the cooldowns from our config file and apply them here
		Cooldown = new class'X2AbilityCooldown';
		Cooldown.iNumTurns = default.SkirmisherVengeance_COOLDOWN;
		Template.AbilityCooldown = Cooldown;
	}
}

static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
	local name Type;

	Type = name(InString);
	switch(Type)
	{
		case 'FOCUS4MOBILITY':
			OutString = string(class'X2Ability_TemplarAbilitySet_LW'.default.FOCUS4MOBILITY);
			return true;
		case 'FOCUS4DODGE':
			OutString = string(class'X2Ability_TemplarAbilitySet_LW'.default.FOCUS4DODGE);
			return true;
		case 'FOCUS4RENDDAMAGE':
			OutString = string(class'X2Ability_TemplarAbilitySet_LW'.default.FOCUS4RENDDAMAGE);
			return true;
		case 'STUNSTRIKE_STUN_CHANCE':
			OutString = string(default.STUNSTRIKE_STUN_CHANCE);
			return true;
	}
	return false;
}


static function UpdatePillar()
{
	local X2AbilityTemplateManager		AbilityManager;
	local array<X2AbilityTemplate>		TemplateAllDifficulties;
	local X2AbilityTemplate				Template;

	local X2AbilityCost_ActionPoints	ActionPointCost;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityManager.FindAbilityTemplateAllDifficulties('Pillar', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		Template.AbilityCosts.Length = 0;

		Template.AbilityCosts.AddItem(new class'X2AbilityCost_Focus');

		ActionPointCost = new class'X2AbilityCost_ActionPoints';
		ActionPointCost.iNumPoints = default.PILLAR_AP;
		ActionPointCost.bFreeCost = true;
		ActionPointCost.AllowedTypes.AddItem('Momentum');
		Template.AbilityCosts.AddItem(ActionPointCost);
	}
}

static function UpdateStunStrike()
{
	local X2AbilityTemplateManager		AbilityManager;
	local array<X2AbilityTemplate>		TemplateAllDifficulties;
	local X2AbilityTemplate				Template;

	local X2Effect_Knockback			KnockbackEffect;
	local X2Effect_Stunned				StunnedEffect;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityManager.FindAbilityTemplateAllDifficulties('StunStrike', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		KnockbackEffect = new class'X2Effect_Knockback';
		KnockbackEffect.KnockbackDistance = default.STUNSTRIKE_KNOCKBACK_DISTANCE;

		StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(default.STUNSTRIKE_STUN_DURATION, default.STUNSTRIKE_STUN_CHANCE, false);
		Template.AddTargetEffect(StunnedEffect);
	}
}

// New Deflect and Parry from AngelRane
static function EditDeflect(X2AbilityTemplate Template)
{
	local X2AbilityTemplate						DeflectTemplate;
	local X2Effect_Persistent                   Effect;
	
	DeflectTemplate = Template;
	DeflectTemplate.AbilityTargetEffects.Length = 0;

	Effect = new class'X2Effect_DeflectNew';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, DeflectTemplate.LocFriendlyName, DeflectTemplate.GetMyHelpText(), DeflectTemplate.IconImage, true, , DeflectTemplate.AbilitySourceName);
	DeflectTemplate.AddTargetEffect(Effect);
}

static function EditParry(X2AbilityTemplate Template)
{
	local X2AbilityTemplate						ParryTemplate;
	local X2Effect_Persistent                   PersistentEffect;

	ParryTemplate = Template;
	ParryTemplate.AbilityTargetEffects.Length = 0;

	PersistentEffect = new class'X2Effect_ParryNew';
	PersistentEffect.BuildPersistentEffect(1, true, false);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, ParryTemplate.LocFriendlyName, ParryTemplate.GetMyHelpText(), ParryTemplate.IconImage, true, , ParryTemplate.AbilitySourceName);
	ParryTemplate.AddTargetEffect(PersistentEffect);
}
//Copy pasted Realitymachina's code
static function AllowTwoSoldiersFromEachFaction()
{
	local X2RewardTemplate RewardTemplate;
	local X2StrategyElementTemplateManager StratMgr;
	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();


	RewardTemplate = X2RewardTemplate(StratMgr.FindStrategyElementTemplate('Reward_ExtraFactionSoldier'));

	if(RewardTemplate != none)
		RewardTemplate.IsRewardAvailableFn = IsExtraSoldierAvailable;
}

static function bool IsExtraSoldierAvailable(optional XComGameState NewGameState, optional StateObjectReference AuxRef)
{
	local XComGameState_ResistanceFaction FactionState;
	local int NumFactionSoldiers;
	local XComGameState_CovertAction ActionState;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;



	FactionState = class'X2StrategyElement_DefaultRewards'.static.GetFactionState(NewGameState, AuxRef);
	if (FactionState != none)
	{


		NumFactionSoldiers = FactionState.GetNumFactionSoldiers(NewGameState);
		foreach History.IterateByClassType(class'XComGameState_CovertAction', ActionState)
		{
			if(ActionState.GetMyTemplateName() == 'CovertAction_RecruitExtraFactionSoldier' && (ActionState.GetFaction().GetReference().ObjectID == FactionState.GetReference().ObjectID) && ActionState.bStarted && !ActionState.bCompleted) //this is dumb but we have to account for this
				NumFactionSoldiers += 1;
		}

		// XCom is only allowed to gain more faction soldiers for the first Faction met,
		// and only if they have less than the max amount and have actually met that Faction
		return (FactionState.bMetXCom && (NumFactionSoldiers > 0) && (NumFactionSoldiers < FactionState.default.MaxHeroesPerFaction));
	}

	return false;
}



/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{}
