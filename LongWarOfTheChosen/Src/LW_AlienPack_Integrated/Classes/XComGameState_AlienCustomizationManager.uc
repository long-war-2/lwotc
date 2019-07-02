//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_AlienCustomizationManager.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: This singleton object manages alien Customization settings
//---------------------------------------------------------------------------------------
class XComGameState_AlienCustomizationManager extends XComGameState_BaseObject config(LW_AlienVariations);

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

static function XComGameState_AlienCustomizationManager GetAlienCustomizationManager(optional bool AllowNULL = false)
{
	return XComGameState_AlienCustomizationManager(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_AlienCustomizationManager', AllowNULL));
}

static function XComGameState_AlienCustomizationManager CreateAlienCustomizationManager(optional XComGameState StartState)
{
	local XComGameState_AlienCustomizationManager CustomizationMgr;
	local XComGameState NewGameState;

	//first check that there isn't already a singleton instance of the Customization manager
	if(GetAlienCustomizationManager(true) != none)
		return GetAlienCustomizationManager(true);

	if(StartState != none)
	{
		CustomizationMgr = XComGameState_AlienCustomizationManager(StartState.CreateStateObject(class'XComGameState_AlienCustomizationManager'));
		StartState.AddStateObject(CustomizationMgr);
	}
	else
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Creating Alien Customization Manager Singleton");
		CustomizationMgr = XComGameState_AlienCustomizationManager(NewGameState.CreateStateObject(class'XComGameState_AlienCustomizationManager'));
		NewGameState.AddStateObject(CustomizationMgr);
		`XCOMHISTORY.AddGameStateToHistory(NewGameState);
	}
	return CustomizationMgr;
}

simulated function RegisterListeners()
{
	local Object ThisObj;
	local X2EventManager EventManager;

	EventManager = `XEVENTMGR;
	ThisObj = self;
	//EventManager.RegisterForEvent(ThisObj, 'OnTacticalBeginPlay', OnTacticalBeginPlay, ELD_OnStateSubmitted, 80 /* High priority so Customization is tweaked early*/ ,, true);
	EventManager.RegisterForEvent(ThisObj, 'OnUnitBeginPlay', OnUnitBeginPlay, ELD_OnStateSubmitted, 55,, true);  // trigger when a unit normally enters play
	//EventManager.RegisterForEvent(ThisObj, 'OnCreateCinematicPawn', OnCinematicPawnCreation, ELD_Immediate, 55,, true);  // trigger when unit cinematic pawn is created -- moved inside the 'OnUnitBeginPlay' handler
}

// loops over alien units and tweaks Customization
function EventListenerReturn OnUnitBeginPlay(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_Unit_AlienCustomization AlienCustomization;
	local LWUnitVariation UnitVariation;
	local XComGameStateContext_ChangeContainer ChangeContainer;
	local XComGameState_Unit UnitState, UpdatedUnitState;
	local X2EventManager EventManager;
	local Object CustomizationObject;

	History = `XCOMHISTORY;
	EventManager = `XEVENTMGR;

	`APTRACE("Alien Pack Customization Manager : OnUnitBeginPlay triggered.");
	UnitState = XComGameState_Unit(EventData);

	`APTRACE("AlienCustomization: Num Variations =" @ default.UnitVariations.Length);

	if(UnitState != none && (UnitState.IsAlien() || UnitState.IsAdvent()))
	{
		`APTRACE("AlienCustomization: Placing Unit:" @ UnitState.GetFullName());
		AlienCustomization = class'XComGameState_Unit_AlienCustomization'.static.GetCustomizationComponent(UnitState);
		if(AlienCustomization == none || AlienCustomization.bAutomatic) // only add if new or overriding an automatic customization
		{
			foreach default.UnitVariations(UnitVariation)
			{
				`APTRACE("AlienCustomization: Testing Variation for :" @ UnitVariation.CharacterNames[0]);

				if(UnitVariation.CharacterNames.Find(UnitState.GetMyTemplateName()) != -1) 
				{
					`APTRACE("AlienCustomization: Valid template found :" @ UnitVariation.CharacterNames[0]);

					//valid unit type without random variation, so roll the dice
					if(`SYNC_FRAND() < UnitVariation.Probability || UnitVariation.Automatic)
					{
						`APTRACE("AlienCustomization: Template passed, applying :" @ UnitVariation.CharacterNames[0]);

						ChangeContainer = class'XComGameStateContext_ChangeContainer'.static.CreateEmptyChangeContainer("Creating Alien Customization Component");
						NewGameState = History.CreateNewGameState(true, ChangeContainer);
						UpdatedUnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', UnitState.ObjectID));

						AlienCustomization = class'XComGameState_Unit_AlienCustomization'.static.CreateCustomizationComponent(UpdatedUnitState, NewGameState);
						AlienCustomization.GenerateCustomization(UnitVariation, UpdatedUnitState, NewGameState);

						NewGameState.AddStateObject(UpdatedUnitState);
						NewGameState.AddStateObject(AlienCustomization);
						`GAMERULES.SubmitGameState(NewGameState);

						AlienCustomization.ApplyCustomization();

						CustomizationObject = AlienCustomization;
						EventManager.RegisterForEvent(CustomizationObject, 'OnCreateCinematicPawn', AlienCustomization.OnCinematicPawnCreation, ELD_Immediate, 55, UnitState);  // trigger when unit cinematic pawn is created

						if(!AlienCustomization.bAutomatic)
							return ELR_NoInterrupt;
					}
				}
			}
		}
	}

	return ELR_NoInterrupt;
}
