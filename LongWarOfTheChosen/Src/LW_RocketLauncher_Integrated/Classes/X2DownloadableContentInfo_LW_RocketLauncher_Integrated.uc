class X2DownloadableContentInfo_LW_RocketLauncher_Integrated extends X2DownloadableContentInfo;

var localized string RocketLaunchersWeaponCategory;
var localized string RocketsWeaponCategory;

var localized string NeedsRocketLauncher;
var localized string NeedsRocketLauncherTier;
//	Filled by SPARK / MEC Weapons mod. Also lets this mod know that mod present in the player's system.
var config(RocketLaunchers) array<name> SparkCharacterTemplates;
/*

## Order of opening packages:
1) RocketTextureTest + Beam RL 
2) Rocket Nuke
3) Rocket Launchers
4) MEC Rockets (required OrdnanceLauncher package)


To do:

### DONE
-- Damage preview for Nukes.

### IMMEDIATE
-- Use highlander hook to display an additional warning item over a rocket if it can't be used with the current tier of equipped launcher
-- Untie Nukes from Improved Rockets? -handled, can't skip Experimental Rockets anymore
-- What happens if a soldier with an Armed rocket receives an Armed Nuke? -- it will disarm.
-- Add perk compatibility to steam
-- make the nuke explosion destroy windows in a large area (entire map?).


### LOW PRIORITY
-- Allow carrying only one nuke rocket per soldier.
-- giving an Armed Nuke to soldier who already has Armed Nuke? -- Currently, the Nuke that was armed first will Disarm. Or at least its Nuke Armed effect will get extended in duration. Desired behavior is to have the Given Nuke be disarmed, and the original Nuke Armed effect to not be affected.
-- nuke vs stasis? -- make Apply Epicenter Damage remove certain effects didn't work for some reason.
-- Thermobaric should ignore cover?
-- Copy of the rocket's mesh appears in the middle of the map as soon as firing animation starts.
-- lW2 Javelin Rockets - works for free aim rockets, but not single target / line target
-- Lockon Rocket doesn't Spawn when fired? Only T3? Only on Females?
-- Show "new proving grounds project is available" popup when purchasing rocket launcher upgrade and acquiring nuclear material
-- Better disintegration effect for the Nuke.
-- Sort out Fire Rocket / Arm Rocket icon visibility -- cannot afford action cost to hide errors for fire rocket?
-- Make soldier not put away the rocket (Enter Cover action) when doing self detonation.
-- Disintegrating already bodies in nuke's epicenter?
-- POI for getting some Experimental Rockets -- Somebody beat me to it? Mitzruti?
-- A Proving Grounds Project for bringing up T1 and T2 rockets to T3 numbers. Should also unlock Nuclear Material Covert Action.
-- Thermobaric Rocket should put out environmental flames.
-- blinking red light for armed rockets--Need to tie the effect to a specific socket on the rocket, which is easily done in Arm Rocket animation, but then need to figure out to remove the effect if the rocket is disarmed
-- plasma ejector - environmental damage needs to account for dead units killed by itself
-- Lockon -- get floor tile for coordinates for lockon scatter
-- Make rockets unequippable on SPARK-like units--Figure out a better way of figuring out who's a spark unit
-- Napalm Rocket - make fire spread naturally.
-- Template.IncreaseGrenadeRange make it work for Single Target rockets--Ability targeting range is in the Target Style and it's native for Single Target. Low priority anyway, currently I don't have squadsight capable rockets with single target rockets with range lower than visual range.
-- Arm Rocket -- maybe the rocket should automatically disarm at the end of turn only if the soldier doesn't have a rocket launcher? (for the purposes of giving an armed rocket)
-- Check radius. -- For some reason using my Rocket Targeting Method changes the radius as oppose to using Grenade Targeting Method. Also the tile pattern doesn't stay in a nice group shape.
-- Arm Rocket - skip exit cover -- standard melee calc trick doesn't work for some reason
-- Sabot - try the Multi Target condition for piercing. --didn't work for some reason, to tired of this shit to care
-- Sabot: Make it deal pierce damage after lightly armored targets, or if it misses and hits an environment object.
	-- Increase physx box around discarded sabot so it doesn't sink into the ground. 
	-- Make bleed damage scale with damage dealt?
	-- Make it pin ragdolled enemies to walls?
	-- it should deal more damage to armored units than to organic units, unless it hits a critical shot, in which case it should deal triple damage? and maybe it should stun as well?

### COSMETIC

### FEATURES

-- Attachments
 - Designation Protocol - allows GREMLIN users to Designate enemies, applying Holo Targeting and allowing enemies to be targeted from Squadsight ranges.
 - Suppressor (first rocket fired during the mission is silent or maybe SubSonic rocket to keep RLs relevant on Lost missions, Shrapnel Shot maybe)
 - Heat Vision Scope - direct fire rockets (Sabot) can target enemies even through walls, without direct line of sight.

-- Global Upgrades:
 - Safety Pin - Rockets that have not been Armed can be Given at a distance of several tiles.
 - Rocket Holster - Carrying only one rocket doesn't cause a mobility penalty.
 - Assisted Reload - Giving a rocket that has been Armed this turn doesn't cost an action.
 - Heat Rockets - standard explosive rockets deal +3 damage to robotic units.
 - Danger Something - Tactical Nuke fired when DETONATION IMMINENT has explosive radius increased by 25%
 - Some sort of "Rocket Crew" bonus for Give / Arm rocket if rocketeer and ammo carrier are bonded?
 - Also considering making all (armed) rockets throwable as grenade for 50% throw range and 50% damage.

-- More rocket types:
 - Fox rocket using Blaster Launcher targeting
 - cluster rocket
 - cluster rocket that fragments before reaching the enemy and showers them with mini explosions (or maybe do this for white phosphorous rocket?)
 - flak cannon rocket? i.e. basically firing a shotgun from the launcher. too similar to shredstorm cannon though.
 - wrath cannon-style rocket. designate an area, and it gets destroyed at the end of the enemy turn. make it pierce stasis or go out after stasis is over.
 - salvo rocket
 - Deadlight Rocket -> deals moderate mental damage to all units who can see the explosion. Squadsight not included, for obvious reasons, direct line of sight is required. Affects hunkered down units, but not units that are blinded (nearsighted), or those immune to mental damage.

### CHECKED
-- Reparent environmental damage actions: Impossible, all environmental damage actions within the context of one ability are always visualized at the same time.
-- add "ignore cover for explosion AOE purposes" flag to each individual rocket. -- looks like it's a global flag for Multi Target Style, and its set to be the same as grenades, so whatever.
-- instant build with resistance card / continent bonus? --confirmed working fine by Arkhangel.
-- Check DRL mobility penalty. -- Everything by the numbers.
-- Lockon vs flying units? -- Lockon works fine against Archon after Blazing Pinions.
-- Template.IncreaseGrenadeRange make it work for Plasma Ejector -- doesn't look like the targeting style would make it possible
-- add lens flare to lockon rocket, maybe give it an ejection sound--gave a mostly unnoticeable one.
-- napalm still slightly misaligned--realigned.
-- reposition rocket sockets on the soldier, maybe untie the RL socket from Grenade Launcher Sling bone--tweaked rocket positoion slightly, moving sockets to different bones doesn't look too good.
-- plus/minus icon in scatter text is broken (in japanese locale) --waiting confirmation.

Rocketeer Perks
Giving a rocket to him doesn't cost an action
Reduce movement penalty for carrying a rocket
Laze Target ?
rocket can be given at a distance?

*/

static function OverrideItemImage(out array<string> imagePath, const EInventorySlot Slot, const X2ItemTemplate ItemTemplate, XComGameState_Unit UnitState)
{
	local X2RocketTemplate			RocketTemplate;
	local XComGameState_Item		SecondaryWeapon;
	local X2GrenadeLauncherTemplate	RocketLauncherTemplate;

	RocketTemplate = X2RocketTemplate(ItemTemplate);
	if (RocketTemplate != none)
	{
		SecondaryWeapon = UnitState.GetItemInSlot(eInvSlot_SecondaryWeapon);
		if (SecondaryWeapon == none)
		{
			imagePath.AddItem("img:///RocketTextureTest.UI.incompatible_rocket_warning");		
		}
		else
		{
			RocketLauncherTemplate = X2GrenadeLauncherTemplate(SecondaryWeapon.GetMyTemplate());
			if (class'X2Condition_RocketTechLevel'.static.CheckWeaponForCompatibility(RocketLauncherTemplate, RocketTemplate) != 'AA_Success')
			{
				//imagePath.Length = 0;
				//imagePath.AddItem(ItemTemplate.strImage);
				imagePath.AddItem("img:///RocketTextureTest.UI.incompatible_rocket_warning");		
			}
		}
	}
}

/// <summary>
/// This method is run when the player loads a saved game directly into Strategy while this DLC is installed
/// </summary>
static event OnLoadedSavedGameToStrategy()
{
	local XComGameState_HeadquartersXCom OldXComHQState;	
	local X2ItemTemplateManager ItemMgr;
	local X2StrategyElementTemplateManager	StratMgr;

	OldXComHQState = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	if (!HasItem('IRI_RocketLauncher_CV', ItemMgr, OldXComHQState)) AddWeapon('IRI_RocketLauncher_CV');
	if (!HasItem('IRI_X2Rocket_Standard', ItemMgr, OldXComHQState)) AddWeapon('IRI_X2Rocket_Standard');
	if (!HasItem('IRI_X2Rocket_Shredder', ItemMgr, OldXComHQState)) AddWeapon('IRI_X2Rocket_Shredder');

	StratMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();

	AddProvingGroundsProjectIfItsNotPresent(StratMgr, 'IRI_ExperimentalRocket');

	AddProvingGroundsProjectIfItsNotPresent(StratMgr, 'IRI_PoweredRocket');

	AddProvingGroundsProjectIfItsNotPresent(StratMgr, 'IRI_TacticalNuke_Tech');

	AddProvingGroundsProjectIfItsNotPresent(StratMgr, 'IRI_ImprovedRockets');
}

static function AddProvingGroundsProjectIfItsNotPresent(X2StrategyElementTemplateManager StratMgr, name ProjectName)
{
	local XComGameState		NewGameState;
	local X2TechTemplate	TechTemplate;

	if (!IsResearchInHistory(ProjectName))
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Adding Research Templates");

		TechTemplate = X2TechTemplate(StratMgr.FindStrategyElementTemplate(ProjectName));
		NewGameState.CreateNewStateObject(class'XComGameState_Tech', TechTemplate);

		`XCOMHISTORY.AddGameStateToHistory(NewGameState);
	}
}
static function bool IsResearchInHistory(name ResearchName)
{
	// Check if we've already injected the tech templates
	local XComGameState_Tech	TechState;
	local XComGameStateHistory	History;
	
	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_Tech', TechState)
	{
		if ( TechState.GetMyTemplateName() == ResearchName )
		{
			return true;
		}
	}
	return false;
}

static function string DLCAppendSockets(XComUnitPawn Pawn)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(Pawn.ObjectID));

	if (UnitState != none && UnitState.IsSoldier())
	{
		
		if (default.SparkCharacterTemplates.Find(UnitState.GetMyTemplateName()) != INDEX_NONE)
		{
			return "IRI_MECRockets.Anims.Spark_Sockets";
		}
		else
		{
			if (UnitState.kAppearance.iGender == eGender_Male)
			{
				return "IRI_RocketLaunchers.Meshes.SM_MaleSockets";
			}
			else
			{
				return "IRI_RocketLaunchers.Meshes.SM_FemaleSockets";
			}
		}
	}
	return "";
}

static function bool HasItem(name TemplateName, X2ItemTemplateManager ItemMgr, XComGameState_HeadquartersXCom OldXComHQState)
{
	local X2ItemTemplate ItemTemplate;

	ItemTemplate = ItemMgr.FindItemTemplate(TemplateName);

	return OldXComHQState.HasItem(ItemTemplate);
}

static function AddWeapon(name TemplateName)
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_HeadquartersXCom OldXComHQState;	
	local XComGameState_HeadquartersXCom NewXComHQState;
	local XComGameState_Item ItemState;
	local X2ItemTemplateManager ItemMgr;
	local X2ItemTemplate ItemTemplate;

	//In this method, we demonstrate functionality that will add ExampleWeapon to the player's inventory when loading a saved
	//game. This allows players to enjoy the content of the mod in campaigns that were started without the mod installed.
	ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	History = `XCOMHISTORY;	

	//Create a pending game state change
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Adding Rocket Launchers Objects");

	//Get the previous XCom HQ state - we'll need it's ID to create a new state for it
	OldXComHQState = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	//Make the new XCom HQ state. This starts out as just a copy of the previous state.
	NewXComHQState = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', OldXComHQState.ObjectID));
	
	//Make the changes to the HQ state. Here we add items to the HQ's inventory
	ItemTemplate = ItemMgr.FindItemTemplate(TemplateName);

	if (ItemTemplate != none && ItemTemplate.StartingItem)
	{	
		//Instantiate a new item state object using the template.
		ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
		NewGameState.AddStateObject(ItemState);

		//Add the newly created item to the HQ inventory
		NewXComHQState.AddItemToHQInventory(ItemState);	

		//Commit the new HQ state object to the state change that we built
		NewGameState.AddStateObject(NewXComHQState);

		//Commit the state change into the history.
		History.AddGameStateToHistory(NewGameState);
	}
	else
	{
		History.CleanupPendingGameState(NewGameState);
	}
}

//	Using a hook to remove instances of Launch Grenade ability attached to rockets, since they're not intended to be launchable.
static function FinalizeUnitAbilitiesForInit(XComGameState_Unit UnitState, out array<AbilitySetupData> SetupData, optional XComGameState StartState, optional XComGameState_Player PlayerState, optional bool bMultiplayerDisplay)
{
	local int Index;
	local XComGameState_Item ItemState;
	local XComGameStateHistory History;
	
	if (!UnitState.IsSoldier())	return;

	History = `XCOMHISTORY;

	//	Remove all abilities that use Launched Grenade Effects from rockets.
	for(Index = SetupData.Length - 1; Index >= 0; Index--)
	{
		if (SetupData[Index].Template.bUseLaunchedGrenadeEffects)
		{
			ItemState = XComGameState_Item(History.GetGameStateForObjectID(SetupData[Index].SourceAmmoRef.ObjectID));
			
			////`LOG("Ability uses grenade launch effects: " @ SetupData[Index].Template.DataName,, 'IRIDAR');
			////`LOG("On item: " @ ItemState.GetMyTemplate().DataName,, 'IRIDAR');
			//AbilityState = History.GetGameStateForObjectID(SetupData[Index].SourceWeaponRef.ObjectID);

			if(ItemState != none && X2RocketTemplate(ItemState.GetMyTemplate()) != none) 
			{
				SetupData.Remove(Index, 1);
				////`LOG("Removing ability: " @ ItemState.GetMyTemplate().DataName,, 'IRIDAR');
				////`LOG("On item: " @ ItemState.GetMyTemplate().DataName,, 'IRIDAR');
			}
		}
	}
}

static function bool HasWeaponOfCategory(const XComGameState_Unit UnitState, const name WeaponCat, optional XComGameState CheckGameState)
{
	local array<XComGameState_Item> Items;
	local XComGameState_Item		Item;
	local X2WeaponTemplate			Template;

	Items = UnitState.GetAllInventoryItems(CheckGameState);
	foreach Items(Item)
	{
		Template = X2WeaponTemplate(Item.GetMyTemplate());

		if(Template != none && Template.WeaponCat == WeaponCat)
		{
			return true;
		}
	}
	return false;
}

static function WeaponInitialized(XGWeapon WeaponArchetype, XComWeapon Weapon, optional XComGameState_Item ItemState=none)
{
    Local XComGameState_Item	InternalWeaponState;
	local XComGameState_Unit	UnitState;
	local UnitValue				RocketValue;
	local XComGameState			GameState;

    if (ItemState == none) 
	{	
		InternalWeaponState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(WeaponArchetype.ObjectID));
		`redscreen("Weapon Initialized -> Had to reach into history to get Internal Weapon State.-Iridar");
	}
	else InternalWeaponState = ItemState;

	//	Initialized weapon is a rocket.
	//	We need to assign a default socket for it.
	if (InternalWeaponState != none && InternalWeaponState.GetMyTemplate().ItemCat == 'cosmetic_rocket')
	{
		////`LOG("Initializing a " @ InternalWeaponState.GetMyTemplateName() @ ", destination socket: " @ InternalWeaponState.Nickname,, 'IRIDAR');
		GameState = InternalWeaponState.GetParentGameState();
		if (GameState != none) 
		{
			//	Grab the Unit State for the owner.
			//	We need the freshest State, because we're checking for a Unit Value that could have been applied by Give Rocket effect just a moment ago.
			UnitState = XComGameState_Unit(GameState.GetGameStateForObjectID(InternalWeaponState.OwnerStateObject.ObjectID));

			//	Check the owner for the Unit Value. If the Unit Value is there, it will contain the Object ID that was given to the soldier by Give Rocket effect.
			if (UnitState != none && UnitState.GetUnitValue('IRI_Rocket_Value', RocketValue))
			{
				//`redscreen("initialzing rocket in tactical for" @ UnitState.GetFullName() @ ", InternalWeaponState.ObjectID: " @ InternalWeaponState.ObjectID @ ", Unit Value: " @ int(RocketValue.fValue));
				//	We check if this initialized rocket was the one given to the soldier by comparing its Object ID to the stored Unit Value.
				if (InternalWeaponState.ObjectID == int(RocketValue.fValue))
				{
					//	If there's a match, we move the freshly given rocket to the invisible socket inside the soldier body. 
					//	This is just a temporary measure to let the Take Rocket animation to play out, otherwise the rocket would pop on the soldier the moment Give Rocket ability goes through, and only then 
					//	the soldier would reach out and grab the rocket from another soldier.
					////`LOG("It's a freshly given rocket, moving to socket Rocket Clip 0.",, 'IRIDAR');
					Weapon.DefaultSocket =  'RocketClip0';
					return;
				}
			}
		}
		else
		{
			`redscreen("Weapon Initialized -> No Parent Game State for the rocket.-Iridar");
		}
					
		//	if this rocket was not given to the soldier by another soldier, but rather was equipped on strategic layer, or the rocket is getting initialized for the first time in tactical
		//	then we just takes its default socket from the nickname, which was assigned in the OnEquipFn in X2RocketTemplate.
		switch (InternalWeaponState.Nickname)
		{
			case "RocketClip1":
				Weapon.DefaultSocket =  'RocketClip1';
				break;
			case "RocketClip2":
				Weapon.DefaultSocket =  'RocketClip2';
				break;
			case "RocketClip3":
				Weapon.DefaultSocket =  'RocketClip3';
				break;
			default:
				return;
		}
	}			
}

exec function CleanupNukeResoruces()
{
	local XComGameState NewGameState;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Removing Nuke Items");

	class'X2StrategyElement_RocketSchematics'.static.CleanupNukeRocketResoruces(NewGameState);

	if (NewGameState.GetNumGameStateObjects() > 0)
	{
		`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	}
	else
	{
		`XCOMHISTORY.CleanupPendingGameState(NewGameState);
	}
}

static event OnPostTemplatesCreated()
{
	local X2CharacterTemplateManager	CharMgr;
	local X2CharacterTemplate			CharTemplate;
	local X2DataTemplate				DataTemplate;

	local X2AbilityTemplate				AbilityTemplate;
	local X2AbilityTemplateManager		AbilityManager;
	local X2Effect_ClearUnitValue		Effect1, Effect2;
	local X2Effect_RemoveEffects		DisarmNuke;
	local int i;


	CharMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	foreach CharMgr.IterateTemplates(DataTemplate, none)
	{
		CharTemplate = X2CharacterTemplate(DataTemplate);

		if (!CharTemplate.bIsRobotic && class'X2Rocket_Napalm'.default.CREATE_ROCKET)
		{	
			CharTemplate.Abilities.AddItem('IRI_Napalm_FireTrail');
		}
	
		//	Allows Nukes to disintegrate corpses in epicenter radius
		CharTemplate.AdditionalAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("IRI_RocketNuke.Anims.AS_SpecialDeath")));

		if (CharTemplate.bIsSoldier)
		{	
			if (default.SparkCharacterTemplates.Find(CharTemplate.DataName) != INDEX_NONE)
			{
				CharTemplate.AdditionalAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("IRI_MECRockets.Anims.AS_SPARK_TakeRocket")));
			}
			else
			{
				CharTemplate.AdditionalAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("IRI_RocketLaunchers.Anims.AS_TakeRocket")));
			}
		}
	}

	//	Make abilities that "disable" weapons also disarm rockets
	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	//	prepare effects that disarm rockets by clearing Unit Values that tell the Fire Rocket abilites that the rocket is armed
	Effect1 = new class'X2Effect_ClearUnitValue';
	Effect1.UnitValueName = class'X2Effect_ArmRocket'.default.UnitValueName;//'IRI_Rocket_Armed_Value'; //class'X2Effect_ArmRocket'.default.UnitValueName;

	Effect2 = new class'X2Effect_ClearUnitValue';
	Effect2.UnitValueName = class'X2Effect_ArmRocket'.default.ArmedThisTurnUnitValueName;

	DisarmNuke = new class'X2Effect_RemoveEffects';
	DisarmNuke.EffectNamesToRemove.AddItem(class'X2Effect_ArmedNuke'.default.EffectName);

	//	cycle through ALL abilities in game
	//	(this method is super inefficient, but comprehensive)
	foreach AbilityManager.IterateTemplates(DataTemplate)
	{
		AbilityTemplate = X2AbilityTemplate(DataTemplate);
		if (AbilityTemplate != none)
		{
			////`LOG("Found ability: " @ AbilityTemplate.DataName,, 'IRIROCK');
			// if the ability has a multi target effect that disables weapons
			for (i = 0; i < AbilityTemplate.AbilityMultiTargetEffects.Length; i++)
			{
				if (X2Effect_DisableWeapon(AbilityTemplate.AbilityMultiTargetEffects[i]) != none)
				{
					////`LOG("It has disable weapon multi target effect: " @ AbilityTemplate.DataName,, 'IRIROCK');
					AbilityTemplate.AddMultiTargetEffect(Effect1);				
					AbilityTemplate.AddMultiTargetEffect(Effect2);	
					AbilityTemplate.AddMultiTargetEffect(DisarmNuke);						
					break;	//	exit For cycle
				}
			}
			//	if the ability has a single target effect that disables weapons
			for (i = 0; i < AbilityTemplate.AbilityTargetEffects.Length; i++)
			{
				if (X2Effect_DisableWeapon(AbilityTemplate.AbilityTargetEffects[i]) != none)
				{
					////`LOG("It has disable weapon single target effect: " @ AbilityTemplate.DataName,, 'IRIROCK');
					AbilityTemplate.AddTargetEffect(Effect1);				
					AbilityTemplate.AddTargetEffect(Effect2);	
					AbilityTemplate.AddTargetEffect(DisarmNuke);	
					break;	//	exit For cycle
				}
			}
		}
	}

	//	Patch LW2 Fire Rocket ability so it's available only to Technicals?
}


static function bool CanAddItemToInventory_CH_Improved(out int bCanAddItem, const EInventorySlot Slot, const X2ItemTemplate ItemTemplate, int Quantity, XComGameState_Unit UnitState, optional XComGameState CheckGameState, optional out string DisabledReason, optional XComGameState_Item ItemState)
{
	local X2WeaponTemplate WeaponTemplate, SecondaryWeapon;
	local bool                          OverrideNormalBehavior;
    local bool                          DoNotOverrideNormalBehavior;

	OverrideNormalBehavior = CheckGameState != none;
    DoNotOverrideNormalBehavior = CheckGameState == none;

    WeaponTemplate = X2WeaponTemplate(ItemTemplate);

    if (WeaponTemplate.WeaponCat == 'Rocket')
    {
		SecondaryWeapon = X2WeaponTemplate(UnitState.GetSecondaryWeapon().GetMyTemplate());

		if(SecondaryWeapon.WeaponCat == 'IRI_Rocket_Launcher')
		{
			if(SecondaryWeapon.WeaponTech == WeaponTemplate.WeaponTech)
			{
				bCanAddItem = 1;
				DisabledReason ="";
				return OverrideNormalBehavior;
			}
			else
			{
				bCanAddItem = 0;
				DisabledReason = default.NeedsRocketLauncherTier;
				return OverrideNormalBehavior;
			}
		}
		else
		{
			bCanAddItem = 0;
			DisabledReason = default.NeedsRocketLauncher;
			return OverrideNormalBehavior;
		}
		//`LOG("DLC Check for: " @ ItemTemplate.DataName,, 'IRIROCKET');
    }
		return DoNotOverrideNormalBehavior;
}

/*
static function WeaponInitialized(XGWeapon WeaponArchetype, XComWeapon Weapon, optional XComGameState_Item ItemState=none)
{
    Local XComGameState_Item	InternalWeaponState;
	local XComGameState_Unit	UnitState;
	local UnitValue				RocketValue;
	local XComGameState			GameState;

    if (ItemState == none) 
	{	
		InternalWeaponState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(WeaponArchetype.ObjectID));
		`redscreen("had to reach into history to get Internal Weapon State");
	}
	else InternalWeaponState = ItemState;

	switch (InternalWeaponState.Nickname)
	{
		case "RocketClip1":
			Weapon.DefaultSocket =  'RocketClip1';
			break;
		case "RocketClip2":
			Weapon.DefaultSocket =  'RocketClip2';
			break;
		case "RocketClip3":
			Weapon.DefaultSocket =  'RocketClip3';
			break;
		default:
			return;
	}
	//	we're in tactical and equipping a rocket 
	if (`TACTICALRULES.TacticalGameIsInPlay()) // doesn't seem to work // if (XComPresentationLayer(`PRESBASE) == none)
	{
		GameState = InternalWeaponState.GetParentGameState();
		if (GameState == none) `redscreen("no Game State in weapon initialized");

		UnitState = XComGameState_Unit(GameState.GetGameStateForObjectID(InternalWeaponState.OwnerStateObject.ObjectID));


		if (!UnitState.GetUnitValue('IRI_Rocket_Value', RocketValue)) `redscreen("no unit value on the unit in weapon initialized");
		else
		{
			//`redscreen("initialzing rocket in tactical for" @ UnitState.GetFullName() @ ", InternalWeaponState.ObjectID: " @ InternalWeaponState.ObjectID @ ", Unit Value: " @ int(RocketValue.fValue));
			if (InternalWeaponState.ObjectID == int(RocketValue.fValue))
			{
				Weapon.DefaultSocket =  'RocketClip0';
				//UnitState.ClearUnitValue('IRI_Rocket_Value');
			}
		}				
	}
}*/
/*
static function WeaponInitialized(XGWeapon WeaponArchetype, XComWeapon Weapon, optional XComGameState_Item ItemState=none)
{
    local X2RocketTemplate		WeaponTemplate, OtherRocket;
    local XComGameState_Unit	UnitState;
    Local XComGameState_Item	InternalWeaponState, OtherRocketState;
	local UnitValue				RocketsEquipped;
	local StateObjectReference	Ref; 
	local int					iRockets;
	local XComGameStateHistory	History;
   
    if (ItemState == none) InternalWeaponState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(WeaponArchetype.ObjectID));
	else InternalWeaponState = ItemState;

	//if (InternalWeaponState.bMergedOut) return;	//	if this rocket was merged out to have its Ammo combined with another rocket of the same type, we don't need to do anything

    UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(InternalWeaponState.OwnerStateObject.ObjectID));
	if (!UnitState.IsSoldier()) return;

    WeaponTemplate = X2RocketTemplate(InternalWeaponState.GetMyTemplate());
	if(WeaponTemplate != none)
	{
		////`LOG("Initializing weapon: " @ WeaponTemplate.DataName,, 'IRIDAR');
		////`LOG("Object ID: " @ InternalWeaponState.ObjectID,, 'IRIDAR');

		iRockets = 1;
		History = `XCOMHISTORY;

		//if (Weapon.DefaultSocket == none) ////`LOG("Default socket is none",, 'IRIDAR');
		//if (Weapon.DefaultSocket == '') ////`LOG("Default socket is dobule single quote",, 'IRIDAR');

		foreach UnitState.InventoryItems(Ref)
		{
			OtherRocketState = XComGameState_Item(History.GetGameStateForObjectID(Ref.ObjectID));
			OtherRocket = X2RocketTemplate(OtherRocketState.GetMyTemplate());
			
			if(OtherRocket != none) 
			{
				////`LOG("Found another rocket: " @ OtherRocket.DataName,, 'IRIDAR');
				////`LOG("Object ID: " @ Ref.ObjectID,, 'IRIDAR');

				if (Ref.ObjectID != InternalWeaponState.ObjectID) iRockets++;
			}
		}
		////`LOG("iRockets: " @ iRockets,, 'IRIDAR');
		if (Weapon.DefaultSocket == '')
		{
			if (iRockets == 1) 
			{ 
				//InternalWeaponState.InventorySlot = eInvSlot_SeptenaryWeapon;//InternalWeaponState.InventorySlot = eInvSlot_QuinaryWeapon;
				//InternalWeaponState.ItemLocation = eSlot_LeftBack;
				//WeaponTemplate.ItemCat = 'rocket1';
				//WeaponTemplate.WeaponCat = 'rocket1';
				Weapon.DefaultSocket = 'RocketClip1';
				Weapon.Mesh.SetHidden(false);
			}
			if (iRockets == 2)
			{
				//InternalWeaponState.InventorySlot = eInvSlot_SenaryWeapon;
				//InternalWeaponState.ItemLocation = eSlot_LeftBelt;
				//WeaponTemplate.ItemCat = 'rocket2';
				//WeaponTemplate.WeaponCat = 'rocket2';
				Weapon.DefaultSocket = 'RocketClip2';
				Weapon.Mesh.SetHidden(false);
			}
			if (iRockets == 3)
			{
				//InternalWeaponState.InventorySlot = eInvSlot_SeptenaryWeapon;
				//InternalWeaponState.ItemLocation = eSlot_LeftThigh;
				//WeaponTemplate.ItemCat = 'rocket3';
				//WeaponTemplate.WeaponCat = 'rocket3';
				Weapon.DefaultSocket = 'RocketClip3';
				Weapon.Mesh.SetHidden(false);
			}
		}
	}
}
*/
/*simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local StatChange NewChange;
	local XComGameState_Unit UnitState;
	local XComGameState_Item ItemState;
	local X2RocketTemplate Rocket;
	local float AccMobilityPenalty;
	local StateObjectReference Ref; 
	local XComGameStateHistory History;

	//	Grab the Unit State of the soldier we're applying effect to
	UnitState = XComGameState_Unit(kNewTargetState);
	History = `XCOMHISTORY;

	//	go through all inventory items
	foreach UnitState.InventoryItems(Ref)
	{
		ItemState = XComGameState_Item(History.GetGameStateForObjectID(Ref.ObjectID));
		Rocket = X2RocketTemplate(ItemState.GetMyTemplate());

		//	if the inventory item is a rocket, we take its MobilityPenalty, multiply it by the amount of remaining ammo
		//	and add it to the Accumulated Mobiltiy Penalty for this soldier
		if(Rocket == none) continue;
		else AccMobilityPenalty += ItemState.Ammo * Rocket.MobilityPenalty;
	}
	
	NewChange.StatType = eStat_Mobility;
	//	set the mobility penalty
	NewChange.StatAmount = -AccMobilityPenalty;
	NewChange.ModOp = MODOP_Addition;

	NewEffectState.StatChanges.AddItem(NewChange);

	//	and apply it
	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}*/


/*
static event OnPostTemplatesCreated()
{
	ChainAbilityTag();
}

// Handle Expanding Ability Tags in Localization text
static function ChainAbilityTag()
{
	local XComEngine						Engine;
	local X2AbilityTag_IRI_RocketLaunchers	NewAbilityTag;
	local X2AbilityTag						OldAbilityTag;
	local int idx;

	Engine = `XENGINE;

	OldAbilityTag = Engine.AbilityTag;
	
	NewAbilityTag = new(Engine) class'X2AbilityTag_IRI_RocketLaunchers';
	NewAbilityTag.WrappedTag = OldAbilityTag;

	idx = Engine.LocalizeContext.LocalizeTags.Find(Engine.AbilityTag);
	Engine.AbilityTag = NewAbilityTag;
	Engine.LocalizeContext.LocalizeTags[idx] = NewAbilityTag;
}

static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
	////`LOG("AbilityTagExpandHandler: " @ InString,, 'IRIDAR');
	return false;
}*/

/*
static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
	local name Type;

	////`LOG("AbilityTagExpandHandler: " @ InString,, 'IRIDAR');

	 Type = name(InString);

	if (Type == 'IRI_ROCKETSCATTER') 
	{
		////`LOG("IRI_ROCKETSCATTER recognized.",, 'IRIDAR');
		OutString = "blah blah mr Freeman";
		return true;
	}
	return false;
}*/
