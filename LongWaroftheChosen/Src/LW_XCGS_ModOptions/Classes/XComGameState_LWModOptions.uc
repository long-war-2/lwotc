//---------------------------------------------------------------------------------------
//  FILE:    XComGameState_LWModOptions.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: This is the abstract definition of the component extension for CampaignSettings GameStates, containing 
//				additional data used for mod configuration, plus UI control code.
//---------------------------------------------------------------------------------------
class XComGameState_LWModOptions extends XComGameState_BaseObject abstract;

// holds the class type, used to ensure uniqueness of CampaignSettings components
var class ClassType;

//----------------------------------------------
//----------------- PROTOTYPES -----------------

function XComGameState_LWModOptions InitComponent(class NewClassType)
{
	ClassType = NewClassType;
	return self;
}

//Returns the text to be shown in the UIOptionsPCScreen
function string GetTabText();

//allow ModOptions to perform any necessary initialization when starting up Options UI
function InitModOptions();

//sets m_arrMechaItems items to enable user-alterable configuration options for this mod
//returns the number of MechaItems set -- this is the number that will be enabled in the calling UIScreen
function int SetModOptionsEnabled(out array<UIMechaListItem> m_arrMechaItems);

//allow UIOptionsPCScreen to see if any value has been changed
function bool HasAnyValueChanged() { return false; }

//message to ModOptions to apply any cached/pending changes
function ApplyModSettings();

//message to ModOptions to restore any cached/pending changes if user aborts without applying changes
function RestorePreviousModSettings();

function bool CanResetModSettings() { return false; }

//message to ModOptions to reset any settings to "factory default"
function ResetModSettings();

//----------------------------------------------
//---------------- Initializers ----------------

//Creates a new component in CampaignSettings for a new campaign -- call this from X2DownloadableContentInfo to initialize the ModOptions
function static XComGameState_LWModOptions CreateModSettingsState_NewCampaign(class<XComGameState_LWModOptions> NewClassType, XComGameState GameState)
{
	local XComGameState_LWModOptions ModSettingsState;
	local bool bFoundExistingSettings;
	local XComGameState_CampaignSettings CampaignSettingsStateObject;

	foreach GameState.IterateByClassType(class'XComGameState_CampaignSettings', CampaignSettingsStateObject)
	{
		break;
	}
	//check for existing ModOptions game state -- this should never happen here, but keeping the code intact just in case
	if(CampaignSettingsStateObject != none)
	{
		if(CampaignSettingsStateObject.FindComponentObject(NewClassType, false) != none)
			bFoundExistingSettings = true;
	}
	if(CampaignSettingsStateObject == none || bFoundExistingSettings)
	{
	}
	else
	{
		//ClassType = NewClassType;
		`Log("LW Toolbox: Found Campaign Settings, adding component");
		CampaignSettingsStateObject = XComGameState_CampaignSettings(GameState.CreateStateObject(class'XComGameState_CampaignSettings', CampaignSettingsStateObject.ObjectID));

		ModSettingsState = XComGameState_LWModOptions(GameState.CreateStateObject(NewClassType));
		ModSettingsState.InitComponent(NewClassType);
		CampaignSettingsStateObject.AddComponentObject(ModSettingsState);
		GameState.AddStateObject(ModSettingsState);
		GameState.AddStateObject(CampaignSettingsStateObject);

		return ModSettingsState;
	}
	return none;
}

//Creates a new component in CampaignSettings for an existing campaign -- call this from X2DownloadableContentInfo to initialize the ModOptions
function static XComGameState_LWModOptions CreateModSettingsState_ExistingCampaign(class<XComGameState_LWModOptions> NewClassType)
{
	local XComGameState_LWModOptions ModSettingsState;
	local bool bFoundExistingSettings;
	local XComGameStateHistory History;
	local XComGameState_CampaignSettings CampaignSettingsStateObject;
	local XComGameState UpdateState;

	History = `XCOMHISTORY;
	UpdateState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Adding Mod Options Component");
	CampaignSettingsStateObject = XComGameState_CampaignSettings(History.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings'));
	//check for existing ModOptions game state
	if(CampaignSettingsStateObject != none)
	{
		if(CampaignSettingsStateObject.FindComponentObject(NewClassType, false) != none)
			bFoundExistingSettings = true;
	}
	if(CampaignSettingsStateObject == none || bFoundExistingSettings)
	{
		History.CleanupPendingGameState(UpdateState);
	}
	else
	{
		//ClassType = NewClassType;
		`Log("LW Toolbox: Found Campaign Settings, adding component");
		CampaignSettingsStateObject = XComGameState_CampaignSettings(UpdateState.CreateStateObject(class'XComGameState_CampaignSettings', CampaignSettingsStateObject.ObjectID));

		ModSettingsState = XComGameState_LWModOptions(UpdateState.CreateStateObject(NewClassType));
		ModSettingsState.InitComponent(NewClassType);
		CampaignSettingsStateObject.AddComponentObject(ModSettingsState);
		UpdateState.AddStateObject(ModSettingsState);
		UpdateState.AddStateObject(CampaignSettingsStateObject);

		History.AddGameStateToHistory(UpdateState);
		return ModSettingsState;
	}
	return none;
}

defaultProperties
{
	//Override this in your mod child class of ModOptions with your child class type
	//ClassType = class'XComGameState_LWModOptions';
}