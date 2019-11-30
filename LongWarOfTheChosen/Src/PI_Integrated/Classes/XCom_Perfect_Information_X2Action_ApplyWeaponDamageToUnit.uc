//-----------------------------------------------------------
//	Class:	XCom_Perfect_Information_X2Action_ApplyWeaponDamageToUnit
//	Author: tjnome
//	
//-----------------------------------------------------------

class XCom_Perfect_Information_X2Action_ApplyWeaponDamageToUnit extends X2Action_ApplyWeaponDamageToUnit config(PerfectInformation);

var config int Version;
var config bool SHOW_FLYOVERS_ON_XCOM_TURN;
var config bool SHOW_FLYOVERS_ON_ENEMY_TURN;
var config bool SHOW_FLYOVERS_ONLY_ON_REACTION_SHOT;

var config bool SHOW_AIM_ASSIST_FLYOVERS;

var config bool SHOW_HIT_CHANCE_FLYOVERS;
var config bool SHOW_CRIT_CHANCE_FLYOVERS;
var config bool SHOW_DODGE_CHANCE_FLYOVERS;
var config bool SHOW_MISS_CHANCE_FLYOVERS;

var config bool USE_SHORT_STRING_VERSION;

var config bool SHOW_GUARANTEED_HIT_FLYOVERS;
var config bool SHOW_GUARANTEED_MISS_FLYOVERS;
//var config bool SHOW_GUARANTEED_GRENADE_FLYOVERS;
//var config bool SHOW_GUARANTEED_HEAVY_WEAPON_FLYOVERS;

var config bool SHOW_REPEATER_CHANCE_ON_FREEKILL_FLYOVERS;

var config float DURATION_DAMAGE_FLYOVERS;
var config float DURATION_GUARANTEED_FLYOVERS;

var localized string HIT_CHANCE_MSG;
var localized string CRIT_CHANCE_MSG;
var localized string DODGE_CHANCE_MSG;
var localized string MISS_CHANCE_MSG;

var localized string GUARANTEED_HIT_MSG;
var localized string GUARANTEED_MISS_MSG;

var localized string REPEATER_KILL_MSG;

var string outText;

simulated state Executing
{
	// Add hit and later crit chance to damage output
	simulated function ShowHPDamageMessage(string UIMessage, optional string CritMessage, optional EWidgetColor DisplayColor = eColor_Bad)
	{
		if (USE_SHORT_STRING_VERSION)
			outText = GetVisualText();
		else 
			outText = UIMessage $ CritMessage @ GetVisualText();

		SendMessage(outText, m_iDamage, 0, CritMessage, DamageTypeName == 'Psi'? eWDT_Psi : -1 , UnitPawn.m_eTeamVisibilityFlags);
	}

	// Added in rare cases when all damage is absorbed to shield.
	simulated function ShowShieldedMessage(EWidgetColor DisplayColor)
	{
		// Only show when there is no damage!
		if (m_iDamage == 0) 
		{
			if (USE_SHORT_STRING_VERSION)
				outText = GetVisualText();
			else 
				outText = class'XGLocalizedData'.default.ShieldedMessage @ GetVisualText();

			SendMessage(outText, m_iShielded, 0, "", DamageTypeName == 'Psi'? eWDT_Psi : -1, UnitPawn.m_eTeamVisibilityFlags);
		}
		else
		{
			SendMessage(class'XGLocalizedData'.default.ShieldedMessage, m_iShielded, 0, "", DamageTypeName == 'Psi'? eWDT_Psi : -1, UnitPawn.m_eTeamVisibilityFlags);
		}
	}

	// Add hit and later crit chance to miss output
	simulated function ShowMissMessage(EWidgetColor DisplayColor)
	{
		if (USE_SHORT_STRING_VERSION)
			outText = GetVisualText();
		else 
			outText = class'XLocalizedData'.default.MissedMessage @ GetVisualText();
		
		if (m_iDamage > 0)
		{
			SendMessage(outText, m_iDamage, , ,-1 ,UnitPawn.m_eTeamVisibilityFlags);
		}
		
		else if (!OriginatingEffect.IsA('X2Effect_Persistent')) //Persistent effects that are failing to cause damage are not noteworthy.
		{
			SendMessage(outText);
		}
	}

	// Add GUARANTEED MISS to LightningReflexes output
	simulated function ShowLightningReflexesMessage(EWidgetColor DisplayColor)
	{
		SendMessage(class'XLocalizedData'.default.LightningReflexesMessage @ GetVisualText());
	}

	// Add GUARANTEED MISS to Untouchable output
	simulated function ShowUntouchableMessage(EWidgetColor DisplayColor)
	{
		SendMessage(class'XLocalizedData'.default.UntouchableMessage @ GetVisualText());
	}

	// Add % chance you had to kill target on output
	simulated function ShowFreeKillMessage(name AbilityName, EWidgetColor DisplayColor)
	{	
		if (getSHOW_REPEATER_CHANCE_ON_FREEKILL_FLYOVERS())
			SendMessage(class'XLocalizedData'.default.FreeKillMessage @ REPEATER_KILL_MSG @ FreeKillChance() $ "%", , , , eWDT_Repeater, , true);
		else
			SendMessage(class'XLocalizedData'.default.FreeKillMessage, , , , eWDT_Repeater);
	}
}

function SendMessage(string msg, optional int damage, optional int modifier, optional string CritMessage, optional eWeaponDamageType eWDT, optional ETeam eBroadcastToTeams = eTeam_None, optional bool NoDamage, optional EWidgetColor DisplayColor)
{
	local XComPresentationLayerBase kPres;
	kPres = XComPlayerController(class'Engine'.static.GetCurrentWorldInfo().GetALocalPlayerController()).Pres;

	// Something that is done untill firaxis fixes their shit.
	if (CritMessage != "")
	{
		kPres.GetWorldMessenger().Message(msg, m_vHitLocation, Unit.GetVisualizedStateReference(), eColor_Xcom, class'UIWorldMessageMgr'.const.FXS_MSG_BEHAVIOR_FLOAT, class'UIWorldMessageMgr'.default.DAMAGE_DISPLAY_DEFAULT_ID, eBroadcastToTeams, class'UIWorldMessageMgr'.default.DAMAGE_DISPLAY_DEFAULT_USE_SCREEN_LOC_PARAM, class'UIWorldMessageMgr'.default.DAMAGE_DISPLAY_DEFAULT_SCREEN_LOC, getDURATION_DAMAGE_FLYOVERS(), class'XComUIBroadcastWorldMessage_DamageDisplay', , , modifier, , , eWDT);
		
		kPres.GetWorldMessenger().Message("", m_vHitLocation, Unit.GetVisualizedStateReference(), eColor_Bad, class'UIWorldMessageMgr'.const.FXS_MSG_BEHAVIOR_FLOAT, class'UIWorldMessageMgr'.default.DAMAGE_DISPLAY_DEFAULT_ID, eBroadcastToTeams, class'UIWorldMessageMgr'.default.DAMAGE_DISPLAY_DEFAULT_USE_SCREEN_LOC_PARAM, class'UIWorldMessageMgr'.default.DAMAGE_DISPLAY_DEFAULT_SCREEN_LOC, getDURATION_DAMAGE_FLYOVERS(), class'XComUIBroadcastWorldMessage_DamageDisplay', , damage, modifier, CritMessage, , eWDT);
	}
	else
	{
		if (NoDamage) 
			kPres.GetWorldMessenger().Message(msg, m_vHitLocation, Unit.GetVisualizedStateReference(), eColor_Xcom, class'UIWorldMessageMgr'.const.FXS_MSG_BEHAVIOR_FLOAT, class'UIWorldMessageMgr'.default.DAMAGE_DISPLAY_DEFAULT_ID, eBroadcastToTeams, class'UIWorldMessageMgr'.default.DAMAGE_DISPLAY_DEFAULT_USE_SCREEN_LOC_PARAM, class'UIWorldMessageMgr'.default.DAMAGE_DISPLAY_DEFAULT_SCREEN_LOC, getDURATION_DAMAGE_FLYOVERS(), class'XComUIBroadcastWorldMessage_DamageDisplay', , damage, modifier, CritMessage, , eWDT);
		else 
			kPres.GetWorldMessenger().Message(msg, m_vHitLocation, Unit.GetVisualizedStateReference(), eColor_Bad, class'UIWorldMessageMgr'.const.FXS_MSG_BEHAVIOR_FLOAT, class'UIWorldMessageMgr'.default.DAMAGE_DISPLAY_DEFAULT_ID, eBroadcastToTeams, class'UIWorldMessageMgr'.default.DAMAGE_DISPLAY_DEFAULT_USE_SCREEN_LOC_PARAM, class'UIWorldMessageMgr'.default.DAMAGE_DISPLAY_DEFAULT_SCREEN_LOC, getDURATION_DAMAGE_FLYOVERS(), class'XComUIBroadcastWorldMessage_DamageDisplay', , damage, modifier, CritMessage, , eWDT);
	}
}

// Checking if its a persistent damage (burn, poison)
function bool IsPersistent()
{
	if (X2Effect_Persistent(DamageEffect) != none)
		return true;

	if (X2Effect_Persistent(OriginatingEffect) != None)
		return true;

	if (X2Effect_Persistent(AncestorEffect) != None)
		return true;

	return false;
}

//If the damage a Grenade
function bool IsGrenade()
{
	if (X2AbilityToHitCalc_StandardAim(AbilityTemplate.AbilityToHitCalc).bIndirectFire) return true;

	return false;
}

//If the shot is a reactionfire/overwatch shot
function bool isReactionFire()
{
	if (X2AbilityToHitCalc_StandardAim(AbilityTemplate.AbilityToHitCalc).bReactionFire) return true;

	return false;
}

//If the shot/ability has static value that makes it 100%
function bool isGuaranteedHit()
{
	//If ability has 100% chance to hit because of DeadEye
	if (X2AbilityToHitCalc_DeadEye(AbilityTemplate.AbilityToHitCalc) != None) return true;

	if ( X2AbilityToHitCalc_StandardAim(AbilityTemplate.AbilityToHitCalc) != None ) {
		if ( X2AbilityToHitCalc_StandardAim(AbilityTemplate.AbilityToHitCalc).bGuaranteedHit ) {
			return true;
		}
	}

	//Grenade has 100% chance to hit
	if (IsGrenade()) return true;

	//  For falling damage 
	if (FallingContext != none) return true;
	
	// For Area damage
	if (AreaDamageContext != None) return true;

	return false;
}

// Checking if unit shooting is on enemy team.
function bool isEnemyTeam()
{
	if (Unit.GetTeam() != eTeam_Alien) return true;

	return false;
}

function string GetVisualText()
{
	// Store msg local if needed.
	local string msg;

	//If damage is persistent then it's not a effect with hit chances.
	if (IsPersistent()) return "";

	//If XCom soldier shooting and not suppose to show. Hide chances
	if (!isEnemyTeam() && !getSHOW_FLYOVERS_ON_XCOM_TURN()) return "";

	//If Enemy soldier shooting and not suppose to show. Hide chances
	if (isEnemyTeam() && !getSHOW_FLYOVERS_ON_ENEMY_TURN()) return "";

	//If shot is not a reaction shot and if only show reaction shot. Return nothing
	if (!isReactionFire() && getSHOW_FLYOVERS_ONLY_ON_REACTION_SHOT()) return ""; 

	// Return msg text if it's a StaticChance
	if (GetStaticChance(msg))
	{
		return msg; 
	}

	// Returns chance if nothing else return other message.
	msg = GetChance();
	return msg;

}

function bool GetStaticChance(out string msg)
{
	// Must be damage from World Effects (Fire, Poison, Acid)
	if (HitResults.Length == 0 && DamageResults.Length == 0 && bWasHit) 
	{
		msg = "";
		return true;
	}

	if (isGuaranteedHit())
	{
		if (FallingContext != none)
		{
			msg = "";
			return true;
		}

		//Show GUARANTEED HIT or not
		if (getSHOW_GUARANTEED_HIT_FLYOVERS()) 
		{ 
			msg = GUARANTEED_HIT_MSG;
			return true;
		}
	}

	// Untouchable and LightningReflexes will show GUARANTEED MISS
	if ((HitResult == eHit_LightningReflexes || HitResult == eHit_Untouchable) && (getSHOW_GUARANTEED_MISS_FLYOVERS()))
	{ 
		msg = GUARANTEED_MISS_MSG;
		return true;
	}

	return false;
}

// Return with chance string
function string GetChance()
{
	//local XCom_Perfect_Information_ChanceBreakDown_Unit unitBreakDown;
	//local XCom_Perfect_Information_ChanceBreakDown breakdown;
	local XComGameStateHistory History;
	local XComGameState_Ability AbilityState;
	local AvailableTarget Target;
	//local MyShotData shotdata;
	local string returnText;
	local int critChance, dodgeChance;
	local int  calcHitChance;
	local ShotBreakdown TargetBreakdown;

	if (AbilityTemplate.AbilityToHitCalc == None)
	{
		return "";
	}

	History = `XCOMHISTORY;
	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));

	Target.PrimaryTarget = AbilityContext.InputContext.PrimaryTarget;
	AbilityTemplate.AbilityToHitCalc.GetShotBreakdown(AbilityState, Target, TargetBreakdown);
	//calcHitChance = TargetBreakdown.ResultTable[eHit_Success] + TargetBreakdown.ResultTable[eHit_Crit] + TargetBreakdown.ResultTable[eHit_Graze];
	calcHitChance = TargetBreakdown.ResultTable[eHit_Success]+TargetBreakdown.ResultTable[eHit_Crit];

	//VBN
	//calcHitChance = AbilityContext.ResultContext.CalculatedHitChance;
	critChance = TargetBreakdown.ResultTable[eHit_Crit];
	dodgeChance = TargetBreakdown.ResultTable[eHit_Graze];

	//Log uncessary after confirming values. Have them here as backup if needed.
	`log("===== Ability Name: " $ AbilityTemplate.Name $ " =======");
	`log("===== Target Name: " $ UnitState.GetFullName() $ " =======");
	`log("calcHitChance: " $ calcHitChance);
	`log("critChance: " $ critChance);
	`log("dodgeChance: " $ dodgeChance);

	//Add Hit + Aim assist. Edit's CalcHitChance
	// if (getSHOW_AIM_ASSIST_FLYOVERS()) {
	// 	OldHistoryIndex = AbilityContext.AssociatedState.HistoryIndex - 1;
	// 	calcHitChance = GetModifiedHitChance(XComGameState_Player(History.GetGameStateForObjectID(ShooterState.GetAssociatedPlayerID(),,OldHistoryIndex)), calcHitChance);
	// }

	// The hit chance should not exceed 100%
	//if (calcHitChance > 100)
	//	calcHitChance = 100;

	//if (calcHitChance < 0)
	//	calcHitChance = 0;


	// Outputs whatever the value is now (Hit with or without Assist). 
	if (getSHOW_HIT_CHANCE_FLYOVERS() && !getSHOW_MISS_CHANCE_FLYOVERS())
	{
		if (UnitState.GetMyTemplateName() == 'MimicBeacon')
			returnText = (returnText @ HIT_CHANCE_MSG $ "100" $ "% ");
		else
			returnText = (returnText @ HIT_CHANCE_MSG $ calcHitChance $ "% ");
	}

	// Outputs miss chance
	if (getSHOW_MISS_CHANCE_FLYOVERS())
		returnText = (returnText @ MISS_CHANCE_MSG $ (100 - calcHitChance) $ "% ");

	//Add Crit Chance to returnText
	if (getSHOW_CRIT_CHANCE_FLYOVERS()) returnText = (returnText @ CRIT_CHANCE_MSG $ critChance $ "% ");

	//Add Dodge Chance to returnText
	if (getSHOW_DODGE_CHANCE_FLYOVERS()) returnText = (returnText @ DODGE_CHANCE_MSG $ dodgeChance $ "% ");

	// No short version for miss yet!
	if (getUSE_SHORT_STRING_VERSION())
	{
		//Reset text! Beta version!
		if (getSHOW_HIT_CHANCE_FLYOVERS() && getSHOW_CRIT_CHANCE_FLYOVERS() && getSHOW_DODGE_CHANCE_FLYOVERS())
			returnText = "ATK:" @ calcHitChance @ "%" @ "|" $ critChance @ "%" @" - EVA:" @ dodgeChance @ "%";
	}
		
	return returnText;
}

// Returns aim assist score.
function int GetModifiedHitChance(XComGameState_Player Shooter, int BaseHitChance)
{
	return BaseHitChance;
	// local X2AbilityToHitCalc_StandardAim StandardAim;
	// local int ModifiedChance;
	
	// StandardAim = X2AbilityToHitCalc_StandardAim(AbilityTemplate.AbilityToHitCalc);
	
	// if (StandardAim == none)
	// 	return BaseHitChance;
	// else
	// 	ModifiedChance = StandardAim.GetModifiedHitChanceForCurrentDifficulty(Shooter, BaseHitChance);

	// if (Shooter.TeamFlag == eTeam_XCom) {
	// 	if (ModifiedChance < BaseHitChance)
	// 		ModifiedChance = BaseHitChance;
	// }
	// else if (Shooter.TeamFlag == eTeam_Alien) {
	// 	if (ModifiedChance > BaseHitChance)
	// 		ModifiedChance = BaseHitChance;
	// }

	// return ModifiedChance;
}

// Returns with Repeater chance 
function int FreeKillChance()
{
	local StateObjectReference Shooter;
	local XComGameState_Unit ThisUnitState;
	local XComGameState_Item PrimaryWeapon;
	local XComGameStateHistory History;
	local array<X2WeaponUpgradeTemplate> UpgradeTemplates;

	local int i, FreeKillChance;

	History = `XCOMHISTORY;
	Shooter = AbilityContext.InputContext.SourceObject;
	ThisUnitState = XComGameState_Unit(History.GetGameStateForObjectID(Shooter.ObjectID));

	PrimaryWeapon = ThisUnitState.GetItemInSlot(eInvSlot_PrimaryWeapon);
	UpgradeTemplates = PrimaryWeapon.GetMyWeaponUpgradeTemplates();

	for (i = 0; i < UpgradeTemplates.Length; ++i)
	{
		FreeKillChance += UpgradeTemplates[i].FreeKillChance;
	}
	return FreeKillChance;
}

static function X2AbilityTemplate GetAbilityTemplate(name TemplateName)
{
	local X2AbilityTemplateManager				AbilityManager;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	return AbilityManager.FindAbilityTemplate(TemplateName);
}

static function bool GetSHOW_FLYOVERS_ON_XCOM_TURN() {
	if ( class'PI_MCMListener'.default.SETTINGS_CHANGED ) 
		return class'PI_MCMListener'.default.SHOW_FLYOVERS_ON_XCOM_TURN;
	else
		return default.SHOW_FLYOVERS_ON_XCOM_TURN;
}

static function bool GetSHOW_FLYOVERS_ON_ENEMY_TURN() {
	if ( class'PI_MCMListener'.default.SETTINGS_CHANGED ) 
		return class'PI_MCMListener'.default.SHOW_FLYOVERS_ON_ENEMY_TURN;
	else
		return default.SHOW_FLYOVERS_ON_ENEMY_TURN;
}

static function bool GetSHOW_FLYOVERS_ONLY_ON_REACTION_SHOT() {
	if ( class'PI_MCMListener'.default.SETTINGS_CHANGED ) 
		return class'PI_MCMListener'.default.SHOW_FLYOVERS_ONLY_ON_REACTION_SHOT;
	else
		return default.SHOW_FLYOVERS_ONLY_ON_REACTION_SHOT;
}

static function bool GetSHOW_AIM_ASSIST_FLYOVERS() {
	if ( class'PI_MCMListener'.default.SETTINGS_CHANGED ) 
		return class'PI_MCMListener'.default.SHOW_AIM_ASSIST_FLYOVERS;
	else
		return default.SHOW_AIM_ASSIST_FLYOVERS;
}

static function bool GetSHOW_HIT_CHANCE_FLYOVERS() {
	if ( class'PI_MCMListener'.default.SETTINGS_CHANGED ) 
		return class'PI_MCMListener'.default.SHOW_HIT_CHANCE_FLYOVERS;
	else
		return default.SHOW_HIT_CHANCE_FLYOVERS;
}

static function bool GetSHOW_CRIT_CHANCE_FLYOVERS() {
	if ( class'PI_MCMListener'.default.SETTINGS_CHANGED ) 
		return class'PI_MCMListener'.default.SHOW_CRIT_CHANCE_FLYOVERS;
	else
		return default.SHOW_CRIT_CHANCE_FLYOVERS;
}

static function bool GetSHOW_DODGE_CHANCE_FLYOVERS() {
	if ( class'PI_MCMListener'.default.SETTINGS_CHANGED ) 
		return class'PI_MCMListener'.default.SHOW_DODGE_CHANCE_FLYOVERS;
	else
		return default.SHOW_DODGE_CHANCE_FLYOVERS;
}

static function bool GetSHOW_MISS_CHANCE_FLYOVERS() {
	if ( class'PI_MCMListener'.default.SETTINGS_CHANGED ) 
		return class'PI_MCMListener'.default.SHOW_MISS_CHANCE_FLYOVERS;
	else
		return default.SHOW_MISS_CHANCE_FLYOVERS;
}

static function bool GetUSE_SHORT_STRING_VERSION() {
	if ( class'PI_MCMListener'.default.SETTINGS_CHANGED ) 
		return class'PI_MCMListener'.default.USE_SHORT_STRING_VERSION;
	else
		return default.USE_SHORT_STRING_VERSION;
}

static function bool GetSHOW_GUARANTEED_HIT_FLYOVERS() {
	if ( class'PI_MCMListener'.default.SETTINGS_CHANGED ) 
		return class'PI_MCMListener'.default.SHOW_GUARANTEED_HIT_FLYOVERS;
	else
		return default.SHOW_GUARANTEED_HIT_FLYOVERS;
}

static function bool GetSHOW_GUARANTEED_MISS_FLYOVERS() {
	if ( class'PI_MCMListener'.default.SETTINGS_CHANGED ) 
		return class'PI_MCMListener'.default.SHOW_GUARANTEED_MISS_FLYOVERS;
	else
		return default.SHOW_GUARANTEED_MISS_FLYOVERS;
}

static function bool GetSHOW_REPEATER_CHANCE_ON_FREEKILL_FLYOVERS() {
	if ( class'PI_MCMListener'.default.SETTINGS_CHANGED ) 
		return class'PI_MCMListener'.default.SHOW_REPEATER_CHANCE_ON_FREEKILL_FLYOVERS;
	else
		return default.SHOW_REPEATER_CHANCE_ON_FREEKILL_FLYOVERS;
}

static function float GetDURATION_DAMAGE_FLYOVERS() {
	if ( class'PI_MCMListener'.default.DURATION_DAMAGE_FLYOVERS > 0 )
		return class'PI_MCMListener'.default.DURATION_DAMAGE_FLYOVERS;
	else
		return default.DURATION_DAMAGE_FLYOVERS;
}

static function float GetDURATION_GUARANTEED_FLYOVERS() {
	if ( class'PI_MCMListener'.default.DURATION_GUARANTEED_FLYOVERS > 0 )
		return class'PI_MCMListener'.default.DURATION_GUARANTEED_FLYOVERS;
	else
		return default.DURATION_GUARANTEED_FLYOVERS;
}