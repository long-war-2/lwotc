class X2Rescard_AdditionalResCards_LW extends X2StrategyElement_XpackResistanceActions config(ResCards);


var config int EFFICIENCY_MANUAL_PCT_DISCOUNT;

var config int SUPERCHARGER_POWER_DRAIN;
var config int XENO_FIELD_RESEARCH_RESEARCH_BONUS;

var config int RADIO_FREE_LILY_COMMS_BONUS;

var config int EXPERIMENTAL_EXPERIMENTATION_WORK_BONUS;
	static function array<X2DataTemplate> CreateTemplates()
	{		
		local array<X2DataTemplate> Techs;
		// for now let's not add the cards that require importing stuff from ilb's mod, because I don't want to put in effort into that yet
		//Techs.AddItem(CreateNeedlepointBuffForSidearmsTemplate());
		 Techs.AddItem(GrantRookiesPermaHp_LW());
		 Techs.AddItem(LiveFireTraining_LW());
		// Techs.AddItem(CreateGrantVipsGrenades());
		 Techs.AddItem(CreateDesperateReserves_LW());
		// Techs.AddItem(CreatePracticalOccultism());
		 Techs.AddItem(CreateEfficiencyManual_LW());
		// Techs.AddItem(CreateBlankResistanceOrder('Rescard_ZealousDeployment_LW'));
		// Techs.AddItem(CreateRemoteSuperchargers_LW());
		// Techs.AddItem(CreateXenobiologicalFieldResearch_LW());
		// Techs.AddItem(CreateRadioFreeLily_LW());

		 Techs.AddItem(CreateBlankResistanceOrder('Rescard_ShadyScavengers_LW'));
		 Techs.AddItem(CreateExperimentalExperimentation_LW());
		 Techs.AddItem(GrantResistanceMecAtCombatStartIfRetaliation());
		 //Techs.AddItem(CreateBasiliskDoctrine_LW());

		return Techs;
    }



static function X2DataTemplate CreateNeedlepointBuffForSidearmsTemplate()
{
    local X2StrategyCardTemplate Template;

    `CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_NeedlepointForSidearms');
    Template.Category = "ResistanceCard";
    Template.GetAbilitiesToGrantFn = GrantNeedlepointBuffIfSidearm;
    return Template; 
}

static function GrantNeedlepointBuffIfSidearm(XComGameState_Unit UnitState, out array<name> AbilitiesToGrant)
{	
    if (UnitState.GetTeam() != eTeam_XCom){
        return;
    }
    if (SoldierHasSidearm(UnitState))
    {
        AbilitiesToGrant.AddItem('SidearmBleedingRounds_LW');
    }
}


	static function bool SoldierHasSidearm(XComGameState_Unit Unit){
		return DoesSoldierHaveItemOfWeaponOrItemClass(Unit, 'pistol') || DoesSoldierHaveItemOfWeaponOrItemClass(Unit, 'sidearm') || DoesSoldierHaveItemOfWeaponOrItemClass(Unit, 'sawedoffshotguns');
	}

	///VALIDATED.
	static function bool DoesSoldierHaveItemOfWeaponOrItemClass(XComGameState_Unit UnitState, name Classification)
	{	
		local XComGameStateHistory History;
		local StateObjectReference ItemRef;
		local XComGameState_Item ItemState;
		local name WeaponCat;
		local name ItemCat;
		`assert(UnitState != none);

		History = `XCOMHISTORY;
		`Log("SEARCHING for item of weapon or item cat: " $ string(Classification));

		foreach UnitState.InventoryItems(ItemRef)
		{
			ItemState = XComGameState_Item(History.GetGameStateForObjectID(ItemRef.ObjectID));
			if(ItemState != none)
			{
				WeaponCat=ItemState.GetWeaponCategory();
				`Log("Soldier has item of weaponcat: " $ WeaponCat);
				// check item's type
				if (WeaponCat == Classification){
					`Log("Soldier DOES have item of DESIRED weaponcat: " $ WeaponCat);
					return true;
				}

				ItemCat = ItemState.GetMyTemplate().ItemCat;
				`Log("Soldier has item of itemcat: " $ ItemCat);
				if (ItemCat == Classification){
					`Log("Soldier DOES have item of DESIRED itemcat: " $ ItemCat);
					return true;
				}
			}
		}
		return false;
	}


static function X2DataTemplate GrantRookiesPermaHp_LW()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_GrantRookiesPermaHp_LW');
	Template.Category = "ResistanceCard";
	Template.GetAbilitiesToGrantFn = GrantRookiesPermaHp;
	return Template; 
}

static function GrantRookiesPermaHp(XComGameState_Unit UnitState, out array<name> AbilitiesToGrant)
{		
	if (UnitState.GetTeam() != eTeam_XCom){
		return;
	}
	if (IsDebutMission(UnitState)) 
	{
		AbilitiesToGrant.AddItem( 'RookieHpBuff_LW' ); 
	}
}

static function bool IsDebutMission(XComGameState_Unit UnitState)
{
	return UnitState.iNumMissions == 0;
}

static function X2DataTemplate LiveFireTraining_LW()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_LiveFireTraining_LW');
	Template.Category = "ResistanceCard";
	Template.GetAbilitiesToGrantFn = GrantRookiesPermaAim;
	return Template; 
}

static function GrantRookiesPermaAim(XComGameState_Unit UnitState, out array<name> AbilitiesToGrant)
{		
	if (UnitState.GetTeam() != eTeam_XCom){
		return;
	}
	if (IsDebutMission(UnitState)) 
	{
		AbilitiesToGrant.AddItem( 'RookieAimBuff_LW' ); 
	}
}
static function X2DataTemplate CreateGrantVipsGrenades()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_VeryIncandescentPersons_LW');
	Template.Category = "ResistanceCard";
	Template.GetAbilitiesToGrantFn = GrantVipsFragGrenades;
	return Template; 
}

static function GrantVipsFragGrenades(XComGameState_Unit UnitState, out array<name> AbilitiesToGrant)
{		
	if (UnitState.GetMyTemplateName() == 'FriendlyVIPCivilian'
		|| UnitState.GetMyTemplateName() == 'Scientist_VIP'
		|| UnitState.GetMyTemplateName() == 'Engineer_VIP')
	{
		AbilitiesToGrant.AddItem( 'ILB_DangerousVips_Frag' ); 
		AbilitiesToGrant.AddItem( 'ILB_DangerousVips_Smoke' ); 
	}
}


static function X2DataTemplate CreateDesperateReserves_LW(){		
	local X2StrategyCardTemplate Template;
	
	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_DesperateReserves_LW');
	Template.Category = "ResistanceCard";
	Template.ModifyTacticalStartStateFn = RunCheckForMecUnitIfFewerThanFive;

	return Template; 
}

static function RunCheckForMecUnitIfFewerThanFive(XComGameState StartState)
{
	local XComGameState_BattleData BattleData;

	foreach StartState.IterateByClassType( class'XComGameState_BattleData', BattleData )
	{
		break;
	}

	if(BattleData.MapData.ActiveMission.MissionFamily == "CovertEscape_LW")
	{
		if (NumSoldiersControlledByPlayer(StartState) < 4)
		{
			GrantResistanceMecAtCombatStart(StartState);
		}
	}
	else if (NumSoldiersControlledByPlayer(StartState) < 5)
	{
		GrantResistanceMecAtCombatStart(StartState);
	}


}


static function GrantResistanceMecAtCombatStart(XComGameState StartState)
{

	if (IsSplitMission( StartState ))
		return;

	XComTeamSoldierSpawnTacticalStartModifier('ResistanceMec', StartState);

}


// static function XComGameState_Unit XComTeamSoldierSpawnTacticalStartModifier(name CharTemplateName, XComGameState StartState)
// {
// 	local X2CharacterTemplate Template;
// 	local XComGameState_Unit SoldierState;
// 	local XGCharacterGenerator CharacterGenerator;
// 	local XComGameState_Player PlayerState;
// 	local TSoldier Soldier;
// 	local XComGameState_HeadquartersXCom XComHQ;

// 	// generate a basic resistance soldier unit
// 	Template = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager().FindCharacterTemplate( CharTemplateName );
// 	`assert(Template != none);

// 	SoldierState = Template.CreateInstanceFromTemplate(StartState);
// 	SoldierState.bMissionProvided = true;

// 	if (Template.bAppearanceDefinesPawn)
// 	{
// 		CharacterGenerator = `XCOMGRI.Spawn(Template.CharacterGeneratorClass);
// 		`assert(CharacterGenerator != none);

// 		Soldier = CharacterGenerator.CreateTSoldier( );
// 		SoldierState.SetTAppearance( Soldier.kAppearance );
// 		SoldierState.SetCharacterName( Soldier.strFirstName, Soldier.strLastName, Soldier.strNickName );
// 		SoldierState.SetCountry( Soldier.nmCountry );
// 	}

// 	// assign the player to him
// 	foreach StartState.IterateByClassType(class'XComGameState_Player', PlayerState)
// 	{
// 		if(PlayerState.GetTeam() == eTeam_XCom)
// 		{
// 			SoldierState.SetControllingPlayer(PlayerState.GetReference());
// 			break;
// 		}
// 	}

// 	// give him a loadout
// 	SoldierState.ApplyInventoryLoadout(StartState);

// 	foreach StartState.IterateByClassType( class'XComGameState_HeadquartersXCom', XComHQ )
// 		break;

// 	XComHQ.Squad.AddItem( SoldierState.GetReference() );
// 	XComHQ.AllSquads[0].SquadMembers.AddItem( SoldierState.GetReference() );

// 	return SoldierState;
// }


static function bool IsSplitMission( XComGameState StartState )
{
	local XComGameState_BattleData BattleData;

	foreach StartState.IterateByClassType( class'XComGameState_BattleData', BattleData )
		break;

	return (BattleData != none) && BattleData.DirectTransferInfo.IsDirectMissionTransfer;
}

static function int NumSoldiersControlledByPlayer(XComGameState StartState)
{
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit UnitState;
	local int idx;
	local int NumSoldiers;
	History = `XCOMHISTORY;
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	NumSoldiers=0;
	for(idx = 0; idx < XComHQ.Squad.Length; idx++)
	{
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(XComHQ.Squad[idx].ObjectID));

		if(UnitState != none)
		{
			if (UnitState.IsPlayerControlled() && UnitState.IsSoldier())
			{
				NumSoldiers++;
			}
		}
	}
	`LOG("Discovered soldiers: " $ NumSoldiers);
	return NumSoldiers;
}

static function X2DataTemplate CreatePracticalOccultism()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_PracticalOccultism_LW');
	Template.Category = "ResistanceCard";
	Template.GetAbilitiesToGrantFn = GrantPracticalOccultism;
	return Template; 
}

static function GrantPracticalOccultism(XComGameState_Unit UnitState, out array<name> AbilitiesToGrant)
{		
	if (UnitState.GetTeam() != eTeam_XCom){
		return;
	}
	if (DoesSoldierHaveArmorOfClass(UnitState, 'reaper'))
	{
		AbilitiesToGrant.AddItem( 'MZBloodTeleport' ); 
		//AbilitiesToGrant.AddItem( 'MZCloakOfShadows' ); 
	}
}

static function bool DoesSoldierHaveArmorOfClass(XComGameState_Unit UnitState, name Classification){

	local XComGameStateHistory History;
	local StateObjectReference ItemRef;
	local XComGameState_Item ItemState;
	local X2ArmorTemplate Armor;
	`assert(UnitState != none);

	History = `XCOMHISTORY;
	foreach UnitState.InventoryItems(ItemRef)
	{
		ItemState = XComGameState_Item(History.GetGameStateForObjectID(ItemRef.ObjectID));
		if(ItemState != none)
		{

			Armor = X2ArmorTemplate(ItemState.GetMyTemplate());
			if (Armor == none){
				continue;
			}
			if (Armor.ArmorClass == Classification){
				`LOG("Found armor of desired class " $ Classification);
				return true;
			}
			if (Armor.ArmorCat == Classification){
				`LOG("Found armor of desired armorcat " $ Classification);
				return true;
			}
			
		}
	}
	return false;
}


static function X2DataTemplate Secticide_LW()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_Secticide_LW');
	Template.Category = "ResistanceCard";
	Template.GetAbilitiesToGrantFn = GrantSecticide;
	return Template; 
}

static function GrantSecticide(XComGameState_Unit UnitState, out array<name> AbilitiesToGrant)
{		
	if (UnitState.GetTeam() != eTeam_Alien){
		return;
	}

	AbilitiesToGrant.AddItem('Secticide_LW'); 
	
}


static function X2DataTemplate CreateEfficiencyManual_LW(){
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_EfficiencyManual_LW');
	Template.Category = "ResistanceCard";
	//Template.GetAbilitiesToGrantFn = GrantRemoteSuperchargers;
	Template.OnActivatedFn = ActivateEfficiencyManual;
	Template.OnDeactivatedFn = DeactivateEfficiencyManual;
	return Template; 
}

static function ActivateEfficiencyManual(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.ProvingGroundPercentDiscount += default.EFFICIENCY_MANUAL_PCT_DISCOUNT;
}

static function DeActivateEfficiencyManual(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.ProvingGroundPercentDiscount += default.EFFICIENCY_MANUAL_PCT_DISCOUNT;
}


static function XComGameState_HeadquartersXCom GetNewXComHQState(XComGameState NewGameState)
{
	local XComGameState_HeadquartersXCom NewXComHQ;

	foreach NewGameState.IterateByClassType(class'XComGameState_HeadquartersXCom', NewXComHQ)
	{
		break;
	}

	if (NewXComHQ == none)
	{
		NewXComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
		NewXComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', NewXComHQ.ObjectID));
	}

	return NewXComHQ;
}


static function X2DataTemplate CreateBlankResistanceOrder(name OrderName)
{
	local X2StrategyCardTemplate Template;
	
	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, OrderName);
	Template.Category = "ResistanceCard";
	return Template; 
}

static function X2DataTemplate CreateRemoteSuperchargers_LW(){
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_RemoteSuperchargers_LW');
	Template.Category = "ResistanceCard";
	Template.GetAbilitiesToGrantFn = GrantRemoteSuperchargers;
	Template.OnActivatedFn = ActivateSuperchargers;
	Template.OnDeactivatedFn = DeactivateSuperchargers;
	return Template; 
}

//---------------------------------------------------------------------------------------
static function ActivateSuperchargers(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);

	XComHQ.BonusPowerProduced -= default.SUPERCHARGER_POWER_DRAIN;
	XComHQ.HandlePowerOrStaffingChange(NewGameState);
}
//---------------------------------------------------------------------------------------
static function DeactivateSuperchargers(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.BonusPowerProduced += default.SUPERCHARGER_POWER_DRAIN;
	XComHQ.HandlePowerOrStaffingChange(NewGameState);
}


static function GrantRemoteSuperchargers(XComGameState_Unit UnitState, out array<name> AbilitiesToGrant)
{		
	if (UnitState.GetTeam() != eTeam_XCom){
		return;
	}

	if (IsNegativePower()){
		`LOG("Negative power output found; not granting supercharger abilities");
		return;
	}

	AbilitiesToGrant.AddItem('ILB_Turbocharged');

	// if (DoesSoldierHaveItemOfWeaponOrItemClass(UnitState, 'arcthrower')){
	// 	AbilitiesToGrant.AddItem( 'MZArcElectrocute' ); 
	// }
	// if (DoesSoldierHaveItemOfWeaponOrItemClass(UnitState, 'gremlin')){
	// 	AbilitiesToGrant.AddItem( 'MZChainingJolt' ); 
	// }
}

static function bool IsNegativePower(){
	local XComGameState NewGameState;
	local XComGameStateHistory CachedHistory;
	local XComGameState_HeadquartersXCom XComHQ;

	CachedHistory = `XCOMHISTORY;
	NewGameState = CachedHistory.GetGameStateFromHistory();
	XComHQ = GetNewXComHQState(NewGameState);
	return XComHQ.GetPowerConsumed() > XComHQ.GetPowerProduced();
}

static function X2DataTemplate CreateXenobiologicalFieldResearch_LW()
{
	local X2StrategyCardTemplate Template;
	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_XenobiologicalFieldResearch_LW');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateXenobiology;
	Template.OnDeactivatedFn = DeactivateXenobiology;
	//Template.GetAbilitiesToGrantFn = GrantXenobiologyChryssalidAndFacelessBuff;
	return Template;
}
//---------------------------------------------------------------------------------------
static function ActivateXenobiology(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);

	// Add a research bonus for each lab already created, then set the flag so it will work for all future labs built
	XComHQ.ResearchEffectivenessPercentIncrease += default.XENO_FIELD_RESEARCH_RESEARCH_BONUS;
	XComHQ.HandlePowerOrStaffingChange(NewGameState);
}

	// static function GrantXenobiologyChryssalidAndFacelessBuff(XComGameState_Unit UnitState, out array<name> AbilitiesToGrant)
	// {				
	// 	local bool IsChryssalid;
	// 	local bool IsFaceless;
	// 	IsChryssalid = InStr(UnitState.GetMyTemplateName(), "Chryssalid") >= 0; 
	// 	IsFaceless = InStr(UnitState.GetMyTemplateName(), "Faceless") >= 0;

	// 	if (IsChryssalid || IsFaceless)
	// 	{
	// 		AbilitiesToGrant.AddItem( 'ILB_FasterSavages' ); 
	// 	}
	// }

//---------------------------------------------------------------------------------------
static function DeactivateXenobiology(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.ResearchEffectivenessPercentIncrease -= default.XENO_FIELD_RESEARCH_RESEARCH_BONUS;
	XComHQ.HandlePowerOrStaffingChange(NewGameState);
}


static function X2DataTemplate CreateRadioFreeLily_LW()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_RadioFreeLily_LW');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateRadioFreeLily;
	Template.OnDeactivatedFn = DeactivateRadioFreeLily;
	Template.CanBeRemovedFn = CanRemoveIncreasedResistanceContactsOrder;

	return Template;
}

static function bool CanRemoveIncreasedResistanceContactsOrder(StateObjectReference InRef, optional StateObjectReference ReplacementRef)
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_StrategyCard CardState, ReplacementCardState;
	local bool bCanBeRemoved;

	History = `XCOMHISTORY;
	CardState = GetCardState(InRef);
	ReplacementCardState = GetCardState(ReplacementRef);
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("DON'T SUBMIT: CARD PREVIEW STATE");
	DeactivateAllCardsNotInPlay(NewGameState);
	CardState = XComGameState_StrategyCard(NewGameState.ModifyStateObject(class'XComGameState_StrategyCard', CardState.ObjectID));

	if(WasCardInPlay(CardState))
	{
		CardState.DeactivateCard(NewGameState);
	}

	if(ReplacementCardState != none)
	{
		ReplacementCardState = XComGameState_StrategyCard(NewGameState.ModifyStateObject(class'XComGameState_StrategyCard', ReplacementCardState.ObjectID));
		ReplacementCardState.ActivateCard(NewGameState);
	}

	XComHQ = GetNewXComHQState(NewGameState);
	bCanBeRemoved = (XComHQ.GetRemainingContactCapacity() >= 0);
	History.CleanupPendingGameState(NewGameState);

	return bCanBeRemoved;
}
//---------------------------------------------------------------------------------------
static function ActivateRadioFreeLily(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.BonusCommCapacity += default.RADIO_FREE_LILY_COMMS_BONUS;
}
//---------------------------------------------------------------------------------------
static function DeactivateRadioFreeLily(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = GetNewXComHQState(NewGameState);
	XComHQ.BonusCommCapacity -= default.RADIO_FREE_LILY_COMMS_BONUS;
}


static function X2DataTemplate CreateExperimentalExperimentation_LW()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_ExperimentalExperimentation_LW');
	Template.Category = "ResistanceCard";
	Template.OnActivatedFn = ActivateExperimentalExperimentation;
	Template.OnDeactivatedFn = DeActivateExperimentalExperimentation;

	return Template;
}

static function ActivateExperimentalExperimentation(XComGameState NewGameState, StateObjectReference InRef, optional bool bReactivate = false)
{
	local XComGameState_HeadquartersXCom NewXComHQ;

	NewXComHQ = GetNewXComHQState(NewGameState);
	NewXComHQ.ProvingGroundRate += default.EXPERIMENTAL_EXPERIMENTATION_WORK_BONUS;
	NewXComHQ.HandlePowerOrStaffingChange(NewGameState);

}

static function DeActivateExperimentalExperimentation(XComGameState NewGameState, StateObjectReference InRef)
{
	local XComGameState_HeadquartersXCom NewXComHQ;

	NewXComHQ = GetNewXComHQState(NewGameState);
	NewXComHQ.ProvingGroundRate -= default.EXPERIMENTAL_EXPERIMENTATION_WORK_BONUS;
	NewXComHQ.HandlePowerOrStaffingChange(NewGameState);

}

static function X2DataTemplate CreateBasiliskDoctrine_LW()
{
	local X2StrategyCardTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_BasiliskDoctrine_LW');
	Template.Category = "ResistanceCard";
	Template.GetAbilitiesToGrantFn = GrantBasiliskDoctrine;
	return Template; 
}

static function GrantBasiliskDoctrine(XComGameState_Unit UnitState, out array<name> AbilitiesToGrant)
{		
	if (UnitState.GetTeam() != eTeam_XCom){
		return;
	}

	if(DoesSoldierHaveArmorOfClass(UnitState, 'skirmisher'))
	{
	//	AbilitiesToGrant.AddItem( 'Shredder' );
		AbilitiesToGrant.AddItem( 'TakeUnder' );
	}
}


static function X2DataTemplate GrantResistanceMecAtCombatStartIfRetaliation(){		
	local X2StrategyCardTemplate Template;
	
	`CREATE_X2TEMPLATE(class'X2StrategyCardTemplate', Template, 'ResCard_ResMecIfRetaliation');
	Template.Category = "ResistanceCard";
	Template.ModifyTacticalStartStateFn = RunCheckForResistanceMecIfRetaliation;

	return Template; 
}



static function RunCheckForResistanceMecIfRetaliation(XComGameState StartState){
`LOG("Mission started; mission type is " $ GetMissionData(StartState).GeneratedMission.Mission.MissionFamily);
if (IsRetaliationMission(StartState)){
	`Log("Retaliation mission detected; granting resistance order");
	GrantResistanceMecAtCombatStart(StartState);
}
}


static function bool IsRetaliationMission(XComGameState StartState){
local GeneratedMissionData Mission;
Mission = GetMissionData(StartState).GeneratedMission;

return Mission.Mission.MissionFamily == "Defend_LW"
		|| Mission.Mission.MissionFamily == "RecruitRaid_LW"
		|| Mission.Mission.MissionFamily == "IntelRaid_LW"
		|| Mission.Mission.MissionFamily == "SupplyConvoy_LW"
		|| Mission.Mission.MissionFamily == "Rendezvous_LW"
		|| Mission.Mission.MissionFamily == "Terror_LW";
}
static function XComGameState_MissionSite GetMissionData(XComGameState StartState)
{
	local XComGameState_MissionSite MissionState;
	MissionState = GetMission(StartState);
	return MissionState;
}

simulated static function XComGameState_MissionSite GetMission(XComGameState StartState)
{
	local XComGameState_HeadquartersXCom XComHQ;
	foreach StartState.IterateByClassType( class'XComGameState_HeadquartersXCom', XComHQ )
		break;
	return XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(XComHQ.MissionRef.ObjectID));
}