//---------------------------------------------------------------------------------------
//  FILE:    X2EventListener_AlienCustomization.uc
//  AUTHOR:  Peter Ledbrook
//  PURPOSE: Listeners for managing alien customisation, i.e. the look of units
//           like Rocketeers, Scouts and Sergeants. Copies from LW2's
//           XComGameState_AlienCustomizationManager.
//---------------------------------------------------------------------------------------

class X2EventListener_AlienCustomization extends X2EventListener config(LW_AlienVariations);// dependson(XComGameState_AlienCustomizationManager);

`include(LW_AlienPack_Integrated\LW_AlienPack.uci)

	// ADVENT Soldiers using the Props_SD_FX_Chunks material - 'TintColor', 'MetalColor'
		// AdvTrooper(M1) - 'TintColor' (Detailing)

	// ADVENT soldiers using the AlienUnit_TC parent material - 'TintColor', 'EmissiveColor', 'EmissiveScale'
		// AdvCaptain(all) - 'TintColor' (Armor), 'EmissiveColor', 'EmissiveScale' (Lights)
		// AdvStunLancer(M2/3) - 'EmissiveColor', 'EmissiveScale' (Lights)
		// AdvMEC(M1) - 'TintColor' (Armor)
		// AdvMEC(M2) - 'TintColor' (Armor), 'EmissiveColor', 'EmissiveScale' (Lights)
		// AdvTrooper(M2/3) - 'TintColor' (Detailing), 'EmissiveColor' (Lights)
		// Sectopod - none

	// ADVENT soldiers using the Alien_SD_Cloth - 'EmissiveColor', 'EmissiveColor', 'MetalColor'
		// AdvStunLancer(M1)  - 'EmissiveColor', 'EmissiveScale' (Lights)
		// AdvShieldBearer(all)  - 'EmissiveColor', 'EmissiveScale' (Lights)

	// Alien Units using the Alien_SD_SSS - 'EmissiveColor', 'FresnelColor' (usually nothing)
		// AdvPsiWitch - 'FresnelColor' (minor)
		// Andromedon - none
		// Archon - 'MetalColor' (Body)
		// Berserker - none
		// Chryssalid - none
		// Codex/Cyberus - none
		// Faceless - none
		// Gatekeeper - none
		// Muton - none
		// Sectoid - 'EmissiveColor' (minor)
		// Viper - 'MetalColor' (Armor)

	// Aliens using XCom weapons with the WeaponCustomizable_TC parent material - 'PrimaryColor', 'EmissiveColor', 'Pattern'

	// Aliens using Alien weapons with WeaponCustomizable_TC parent material 
		// Viper - 'MetalColor'
		// Archon - 'MetalColor'

struct LWColorParameter
{
    var name ParameterName;
    var LinearColor ColorValue;
};

struct LWScalarParameter
{
    var name ParameterName;
    var float ScalarValue;
};

struct LWBoolParameter
{
    var name ParameterName;
    var float BoolValue;
};

struct LWTextureParameter
{
    var name ParameterName;
    var string ImagePath;
};

struct LWObjectAppearance
{
    var array<LWColorParameter> ColorParameters;  // instructions on how to color the object
    var array<LWScalarParameter> ScalarParameters; // instructions on any scalar parameters to adjust
    var array<LWBoolParameter> BoolParameters; // instructions on any bool parameters to adjust
    var array<LWTextureParameter> TextureParameters; // instructions on any texture parameters to adjust
};

struct LWUnitVariation
{
    var array<name> CharacterNames;  // character that this can apply to
    var bool Automatic;
    var float Probability; // only one variation per unit
    var float Scale; // multiplicative proportional scaling
    var LWObjectAppearance BodyAppearance;	
    var LWObjectAppearance PrimaryWeaponAppearance;
    var LWObjectAppearance SecondaryWeaponAppearance;
    var array<SoldierClassAbilityType> AbilityUpgrades;
    var array<SoldierClassStatType> StatUpgrades;
    var TAppearance BodyPartContent;
    var array<string> GenericBodyPartArchetypes;
};

var config array<LWUnitVariation> UnitVariations;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateCustomisationListeners());
	Templates.AddItem(CreateCustomisationListeners_Bestiary());

	return Templates;
}

static function CHEventListenerTemplate CreateCustomisationListeners()
{
	local CHEventListenerTemplate Template;

    `CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'AlienCustomisationListeners');
    
    // Don't know how important the priority is. Just be aware that reducing it may affect
    // summoned units and reinforcements in terms of their rendering.
	Template.AddCHEvent('OnUnitBeginPlay', OnUnitBeginPlay, ELD_OnStateSubmitted, 55);

	Template.RegisterInTactical = true;

	return Template;
}

static function CHEventListenerTemplate CreateCustomisationListeners_Bestiary()
{
	local CHEventListenerTemplate Template;

    `CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'AlienCustomisationListeners_Bestiary');
    
    // Don't know how important the priority is. Just be aware that reducing it may affect
    // summoned units and reinforcements in terms of their rendering.
	Template.AddCHEvent('OnUnitShownInBestiary', OnUnitShownInBestiary, ELD_Immediate, 55);

	Template.RegisterInTactical = false;
	Template.RegisterInStrategy = true;

	return Template;
}

// Loops over alien units and tweaks Customization. Replaces the previous
// fix for issue #117.
static function EventListenerReturn OnUnitBeginPlay(
    Object EventData,
    Object EventSource,
    XComGameState GameState,
    Name EventID,
    Object CallbackData)
{
	local XComGameState NewGameState;
	local XComGameState_Unit_AlienCustomization AlienCustomization;
	local LWUnitVariation UnitVariation;
	local XComGameStateContext_ChangeContainer ChangeContainer;
	local XComGameState_Unit UnitState, UpdatedUnitState;
	local X2EventManager EventManager;
	local Object CustomizationObject;

	EventManager = `XEVENTMGR;

	`APTRACE("Alien Pack Customization Manager : OnUnitBeginPlay triggered.");
	UnitState = XComGameState_Unit(EventData);

	`APTRACE("AlienCustomization: Num Variations =" @ default.UnitVariations.Length);

	if (UnitState != none && (UnitState.IsAlien() || UnitState.IsAdvent()))
	{
		`APTRACE("AlienCustomization: Placing Unit:" @ UnitState.GetFullName());
		AlienCustomization = class'XComGameState_Unit_AlienCustomization'.static.GetCustomizationComponent(UnitState);
		if (AlienCustomization == none || AlienCustomization.bAutomatic) // only add if new or overriding an automatic customization
		{
			foreach default.UnitVariations(UnitVariation)
			{
				`APTRACE("AlienCustomization: Testing Variation for :" @ UnitVariation.CharacterNames[0]);

				if (UnitVariation.CharacterNames.Find(UnitState.GetMyTemplateName()) != -1) 
				{
					`APTRACE("AlienCustomization: Valid template found :" @ UnitVariation.CharacterNames[0]);

					//valid unit type without random variation, so roll the dice
					if (`SYNC_FRAND_STATIC() < UnitVariation.Probability || UnitVariation.Automatic)
					{
						`APTRACE("AlienCustomization: Template passed, applying :" @ UnitVariation.CharacterNames[0]);

						NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Creating Alien Customization Component");
						UpdatedUnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', UnitState.ObjectID));

						AlienCustomization = class'XComGameState_Unit_AlienCustomization'.static.CreateCustomizationComponent(UpdatedUnitState, NewGameState);
						AlienCustomization.GenerateCustomization(UnitVariation, UpdatedUnitState, NewGameState);

						ChangeContainer = XComGameStateContext_ChangeContainer(NewGameState.GetContext());
						ChangeContainer.BuildVisualizationFn = CustomizeAliens_BuildVisualization;
						ChangeContainer.SetAssociatedPlayTiming(SPT_BeforeSequential);
						`GAMERULES.SubmitGameState(NewGameState);

						AlienCustomization.ApplyCustomization();

						CustomizationObject = AlienCustomization;
						EventManager.RegisterForEvent(CustomizationObject, 'OnCreateCinematicPawn', AlienCustomization.OnCinematicPawnCreation, ELD_Immediate, 55, UnitState);  // trigger when unit cinematic pawn is created

						if (!AlienCustomization.bAutomatic)
							return ELR_NoInterrupt;
					}
				}
			}
		}
	}

	return ELR_NoInterrupt;
}

// A BuildVisualization function that ensures that alien pack enemies have their
// pawns updated via X2Action_CustomizeAlienPackRNFs.
static function CustomizeAliens_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameState_Unit UnitState;
	local VisualizationActionMetadata EmptyMetadata, ActionMetadata;
	local XComGameState_Unit_AlienCustomization AlienCustomization;

	if (VisualizeGameState.GetNumGameStateObjects() > 0)
	{
		foreach VisualizeGameState.IterateByClassType(class'XComGameState_Unit', UnitState)
		{
			AlienCustomization = class'XComGameState_Unit_AlienCustomization'.static.GetCustomizationComponent(UnitState);
			if (AlienCustomization == none)
			{
				continue;
			}
			
			ActionMetadata = EmptyMetadata;
			ActionMetadata.StateObject_OldState = UnitState;
			ActionMetadata.StateObject_NewState = UnitState;

			ActionMetadata.VisualizeActor = UnitState.GetVisualizer();

			class'X2Action_CustomizeAlienPackRNFs'.static.AddToVisualizationTree(
				ActionMetadata,
				VisualizeGameState.GetContext(),
				false);
		}
	}
}


// Loops over alien units and tweaks Customization in the Bestiary. ONLY CALLED/USED from the UFOPedia/Bestiary mod
static function EventListenerReturn OnUnitShownInBestiary( Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState NewGameState;
	local XComGameState_Unit_AlienCustomization AlienCustomization;
	local XComGameState_Unit UnitState, UpdatedUnitState;
	local LWUnitVariation UnitVariation;
	local XComUnitPawn Pawn;

	UnitState = XComGameState_Unit(EventData);
	Pawn = XComUnitPawn(EventSource);

	`APTRACE("AlienCustomization_Bestiary: Num Variations =" @ default.UnitVariations.Length);

	if (UnitState != none && (UnitState.IsAlien() || UnitState.IsAdvent()))
	{
		`APTRACE("AlienCustomization_Bestiary: Placing Unit:" @ UnitState.GetFullName());
		AlienCustomization = class'XComGameState_Unit_AlienCustomization'.static.GetCustomizationComponent(UnitState);
		if (AlienCustomization == none || AlienCustomization.bAutomatic) // only add if new or overriding an automatic customization
		{
			foreach default.UnitVariations(UnitVariation)
			{
				`APTRACE("AlienCustomization_Bestiary: Testing Variation for :" @ UnitVariation.CharacterNames[0]);

				if (UnitVariation.CharacterNames.Find(UnitState.GetMyTemplateName()) != -1) 
				{
					`APTRACE("AlienCustomization_Bestiary: Valid template found :" @ UnitVariation.CharacterNames[0]);

					//valid unit type without random variation, so roll the dice
					if (`SYNC_FRAND_STATIC() < UnitVariation.Probability || UnitVariation.Automatic)
					{
						`APTRACE("AlienCustomization_Bestiary: Template passed, applying :" @ UnitVariation.CharacterNames[0]);

						NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Creating Alien Customization Component");
						UpdatedUnitState = XComGameState_Unit(NewGameState.ModifyStateObject(class'XComGameState_Unit', UnitState.ObjectID));
						AlienCustomization = class'XComGameState_Unit_AlienCustomization'.static.CreateCustomizationComponent(UpdatedUnitState, NewGameState);
						AlienCustomization.GenerateCustomization(UnitVariation, UpdatedUnitState, NewGameState);
						`GAMERULES.SubmitGameState(NewGameState);

						AlienCustomization.ApplyCustomization(Pawn);

						if (!AlienCustomization.bAutomatic)
						{
							return ELR_NoInterrupt;
						}
					}
				}
			}
		}
	}

	return ELR_NoInterrupt;
}
