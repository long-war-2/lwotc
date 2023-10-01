//---------------------------------------------------------------------------------------
//  FILE:    X2MissionNarrative_LWNarrativeSet
//  AUTHOR:  tracktwo / Pavonis Interactive
//
//  PURPOSE: Narrative configuration for new LW Overhaul missions
//--------------------------------------------------------------------------------------- 


class X2MissionNarrative_LWNarrativeSet extends X2MissionNarrative;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2MissionNarrativeTemplate> Templates;

	//recreation of base-game mission narratives for LW-specific variations
	Templates.AddItem(AddDefaultRecoverMissionNarrativeTemplate_LW());
    Templates.AddItem(AddDefaultRecover_ADVMissionNarrativeTemplate_LW());
    Templates.AddItem(AddDefaultRecover_TrainMissionNarrativeTemplate_LW());
    Templates.AddItem(AddDefaultRecover_VehicleMissionNarrativeTemplate_LW());
    Templates.AddItem(AddDefaultRecover_FlightDeviceMissionNarrativeTemplate_LW());
    Templates.AddItem(AddDefaultDestroyRelayMissionNarrativeTemplate_LW());
    Templates.AddItem(AddDefaultSabotageTransmitterMissionNarrativeTemplate_LW());
    Templates.AddItem(AddDefaultCovertEscapeMissionNarrativeTemplate_LW());
    Templates.AddItem(AddDefaultCovertEscapeNonPCPMissionNarrativeTemplate_LW());
    Templates.AddItem(AddDefaultExtractMissionNarrativeTemplate_LW());
    Templates.AddItem(AddDefaultRescue_AdventCellMissionNarrativeTemplate_LW());
    Templates.AddItem(AddDefaultRescue_VehicleMissionNarrativeTemplate_LW());
    Templates.AddItem(AddDefaultSupplyRaidATTMissionNarrativeTemplate_LW());
    Templates.AddItem(AddDefaultSupplyRaidTrainMissionNarrativeTemplate_LW());
    Templates.AddItem(AddDefaultSupplyRaidConvoyMissionNarrativeTemplate_LW());
    Templates.AddItem(AddDefaultHackMissionNarrativeTemplate_LW());
    Templates.AddItem(AddDefaultHack_ADVMissionNarrativeTemplate_LW());
    Templates.AddItem(AddDefaultHack_TrainMissionNarrativeTemplate_LW());
    Templates.AddItem(AddDefaultProtectDeviceMissionNarrativeTemplate_LW());
    Templates.AddItem(AddDefaultNeutralizeTargetMissionNarrativeTemplate_LW());
    Templates.AddItem(AddDefaultNeutralize_VehicleMissionNarrativeTemplate_LW());
    Templates.AddItem(AddDefaultAssaultNetworkTowerMissionNarrativeTemplate_LW());
    Templates.AddItem(AddDefaultAssaultAlienFortressMissionNarrativeTemplate_LW());
    Templates.AddItem(AddDefaultAdventFacilityBlacksiteMissionNarrativeTemplate_LW());
    Templates.AddItem(AddDefaultAdventFacilityForgeMissionNarrativeTemplate_LW());
    Templates.AddItem(AddDefaultAdventFacilityPsiGateMissionNarrativeTemplate_LW());
    Templates.AddItem(AddDefaultCentralNetworkBroadcastMissionNarrativeTemplate_LW());
    Templates.AddItem(AddDefaultSabotageMissionNarrativeTemplate_LW());
    Templates.AddItem(AddDefaultSabotageCCMissionNarrativeTemplate_LW());
    Templates.AddItem(AddDefaultSecureUFOMissionNarrativeTemplate_LW());
    Templates.AddItem(AddDefaultAvengerDefenseMissionNarrativeTemplate_LW());
    Templates.AddItem(AddDefaultTerrorMissionNarrativeTemplate_LW());

	Templates.AddItem(AddInvasionMissionNarrativeTemplate());
	Templates.AddItem(AddTroopManeuversNarrativeTemplate());
    Templates.AddItem(AddAssaultAlienBaseMissionNarrativeTemplate());
    Templates.AddItem(AddJailbreakMissionNarrativeTemplate());
    Templates.AddItem(AddRendezvousMissionNarrativeTemplate());
    Templates.AddItem(AddDefendMissionNarrativeTemplate());
    Templates.AddItem(AddDefaultIntelRaidMissionNarrativeTemplate());
    Templates.AddItem(AddDefaultSupplyConvoyMissionNarrativeTemplate());
    Templates.AddItem(AddDefaultRecruitRaidMissionNarrativeTemplate());
	Templates.AddItem(AddDefaultSmashNGrabMissionNarrativeTemplate());
	Templates.AddItem(AddDefaultBigSmashNGrabMissionNarrativeTemplate());
	Templates.AddItem(AddSupplyExtractionMissionNarrativeTemplate());

    return Templates;
}

static function X2MissionNarrativeTemplate AddInvasionMissionNarrativeTemplate()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultInvasion_LW');

    Template.MissionType="Invasion_LW";
    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.Terror.Terror_AllEnemiesDefeated";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.General.GenTactical_SecureRetreat";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.General.GenTactical_ConsiderRetreat";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.Terror.Terror_AdviseRetreat";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.Terror.Terror_CivilianKilledT1";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.Terror.Terror_CivilianKilledT2";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.Terror.Terror_CivilianKilledT3";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.Terror.Terror_CivilianWipe";
    Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.General.GenTactical_PartialEVAC";
    Template.NarrativeMoments[9]="X2NarrativeMoments.TACTICAL.General.GenTactical_FullEVAC";

    Template.NarrativeMoments[10]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[11]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroFailure";
    Template.NarrativeMoments[12]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroTotalSuccess";
    Template.NarrativeMoments[13]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[14]="X2NarrativeMoments.T_Retaliation_Reminder_Squad_Not_Concealed_C_Central";

    Template.NarrativeMoments[15]="X2NarrativeMoments.TACTICAL.DestroyObject.DestroyObject_ObjectSpotted";
    Template.NarrativeMoments[16]="X2NarrativeMoments.TACTICAL.ProtectDevice.T_Protect_Device_PrDv_ProceedToSweep";

    return Template;
}

static function X2MissionNarrativeTemplate AddAssaultAlienBaseMissionNarrativeTemplate()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultAssaultAlienBase_LW');

    Template.MissionType="AssaultAlienBase_LW";
    Template.NarrativeMoments[0]="LWNarrativeMoments.TACTICAL.AssaultAlienBase.CEN_AssaultAlienBase_TacIntro";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.General.CEN_Gen_AreaSecured_02";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.General.GenTactical_SecureRetreat";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.General.GenTactical_ConsiderRetreat";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.General.GenTactical_PartialEVAC";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.General.GenTactical_FullEVAC";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroFailure";
    Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroTotalSuccess";
    
    return Template;
}

static function X2MissionNarrativeTemplate AddTroopManeuversNarrativeTemplate()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultTroopManeuvers_LW');

    Template.MissionType="TroopManeuvers_LW";
    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.General.CEN_Gen_AreaSecured_02";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.General.GenTactical_SecureRetreat";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.General.GenTactical_ConsiderRetreat";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.General.GenTactical_PartialEVAC";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.General.GenTactical_FullEVAC";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroFailure";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroTotalSuccess";
    
    return Template;
}

static function X2MissionNarrativeTemplate AddRendezvousMissionNarrativeTemplate()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultRendezvous_LW');

    Template.MissionType="Rendezvous_LW";
    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.General.CEN_Gen_AreaSecured_02";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.General.GenTactical_SecureRetreat";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.General.GenTactical_ConsiderRetreat";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.General.GenTactical_PartialEVAC";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.General.GenTactical_FullEVAC";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroFailure";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroTotalSuccess";
    
    return Template;
}

static function X2MissionNarrativeTemplate AddDefendMissionNarrativeTemplate()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultDefend_LW');

    Template.MissionType="Defend_LW";
    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.General.GenTactical_SecureRetreat";

    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.Terror.Terror_CivilianKilledT1";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.Terror.Terror_CivilianKilledT2";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.Terror.Terror_CivilianKilledT3";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.Terror.Terror_CivilianWipe";

    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.General.GenTactical_PartialEVAC";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.General.GenTactical_FullEVAC";

    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroFailure";
    Template.NarrativeMoments[9]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroTotalSuccess";
    Template.NarrativeMoments[10]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[11]="X2NarrativeMoments.T_Retaliation_Reminder_Squad_Not_Concealed_C_Central";
    Template.NarrativeMoments[12]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_EvacDestroyed";

    return Template;
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// START RE-CREATION OF BASE-GAME MISSIONS ////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////

static function X2MissionNarrativeTemplate AddDefaultRecoverMissionNarrativeTemplate_LW(optional name TemplateName = 'DefaultRecover_LW')
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, TemplateName);

	Template.MissionType = "Recover_LW";
    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.Recover.Recover_TacIntro";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.General.GenTactical_SecureRetreat";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.General.GenTactical_ConsiderRetreat";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.General.GenTactical_AdviseRetreat";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.General.GenTactical_PartialEVAC";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.General.GenTactical_FullEVAC";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.Recover.Recover_STObjSpotted";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.Recover.Recover_STObjReacquired";
    Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.Recover.SKY_RecoGEN_ItemSecured";
    Template.NarrativeMoments[9]="X2NarrativeMoments.TACTICAL.Recover.Recover_STObjDropped";
    Template.NarrativeMoments[10]="X2NarrativeMoments.TACTICAL.Recover.Recover_TimerNagThree";
    Template.NarrativeMoments[11]="X2NarrativeMoments.TACTICAL.Recover.Recover_TimerNagLast";
    Template.NarrativeMoments[12]="X2NarrativeMoments.TACTICAL.Recover.Recover_STObjDestroyedEnemyRemain";
    Template.NarrativeMoments[13]="X2NarrativeMoments.TACTICAL.Recover.Recover_STObjDestroyedMissionOver";
    Template.NarrativeMoments[14]="X2NarrativeMoments.TACTICAL.Recover.Recover_AllEnemiesDefeatedContinue";
    Template.NarrativeMoments[15]="X2NarrativeMoments.TACTICAL.Recover.Recover_ObjAcquiredNoRNF";
    Template.NarrativeMoments[16]="X2NarrativeMoments.TACTICAL.Recover.Recover_ObjAcquiredWithRNF";
    Template.NarrativeMoments[17]="X2NarrativeMoments.TACTICAL.General.CEN_Gen_BurnoutSecured_02";
    Template.NarrativeMoments[18]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[19]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroFailure";
    Template.NarrativeMoments[20]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroPartialSuccess";
    Template.NarrativeMoments[21]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroTotalSuccess";
    Template.NarrativeMoments[22]="X2NarrativeMoments.TACTICAL.General.GenTactical_TacWinOnly";
    Template.NarrativeMoments[23]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";

    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultRecover_ADVMissionNarrativeTemplate_LW(optional name TemplateName = 'DefaultRecover_ADV_LW')
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, TemplateName);

    Template.MissionType = "Recover_ADV_LW";
    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.Recover.Recover_TacIntro";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.General.GenTactical_SecureRetreat";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.General.GenTactical_ConsiderRetreat";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.General.GenTactical_AdviseRetreat";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.General.GenTactical_PartialEVAC";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.General.GenTactical_FullEVAC";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.Recover.Recover_STObjSpotted";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.Recover.Recover_STObjReacquired";
    Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.Recover.SKY_RecoGEN_ItemSecured";
    Template.NarrativeMoments[9]="X2NarrativeMoments.TACTICAL.Recover.Recover_STObjDropped";
    Template.NarrativeMoments[10]="X2NarrativeMoments.TACTICAL.Recover.Recover_TimerNagThree";
    Template.NarrativeMoments[11]="X2NarrativeMoments.TACTICAL.Recover.Recover_TimerNagLast";
    Template.NarrativeMoments[12]="X2NarrativeMoments.TACTICAL.Recover.Recover_STObjDestroyedEnemyRemain";
    Template.NarrativeMoments[13]="X2NarrativeMoments.TACTICAL.Recover.Recover_STObjDestroyedMissionOver";
    Template.NarrativeMoments[14]="X2NarrativeMoments.TACTICAL.Recover.Recover_AllEnemiesDefeatedContinue";
    Template.NarrativeMoments[15]="X2NarrativeMoments.TACTICAL.Recover.Recover_ObjAcquiredNoRNF";
    Template.NarrativeMoments[16]="X2NarrativeMoments.TACTICAL.Recover.Recover_ObjAcquiredWithRNF";
    Template.NarrativeMoments[17]="X2NarrativeMoments.TACTICAL.General.CEN_Gen_BurnoutSecured_02";
    Template.NarrativeMoments[18]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[19]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroFailure";
    Template.NarrativeMoments[20]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroPartialSuccess";
    Template.NarrativeMoments[21]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroTotalSuccess";
    Template.NarrativeMoments[22]="X2NarrativeMoments.TACTICAL.General.GenTactical_TacWinOnly";
    Template.NarrativeMoments[23]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";


    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultRecover_TrainMissionNarrativeTemplate_LW()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultRecover_Train_LW');

	Template.MissionType = "Recover_Train_LW";
    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.Recover.Recover_TacIntro";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.General.GenTactical_SecureRetreat";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.General.GenTactical_ConsiderRetreat";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.General.GenTactical_AdviseRetreat";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.General.GenTactical_PartialEVAC";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.General.GenTactical_FullEVAC";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.Recover.Recover_STObjSpotted";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.Recover.Recover_STObjReacquired";
    Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.Recover.SKY_RecoGEN_ItemSecured";
    Template.NarrativeMoments[9]="X2NarrativeMoments.TACTICAL.Recover.Recover_STObjDropped";
    Template.NarrativeMoments[10]="X2NarrativeMoments.TACTICAL.Recover.Recover_TimerNagThree";
    Template.NarrativeMoments[11]="X2NarrativeMoments.TACTICAL.Recover.Recover_TimerNagLast";
    Template.NarrativeMoments[12]="X2NarrativeMoments.TACTICAL.Recover.Recover_STObjDestroyedEnemyRemain";
    Template.NarrativeMoments[13]="X2NarrativeMoments.TACTICAL.Recover.Recover_STObjDestroyedMissionOver";
    Template.NarrativeMoments[14]="X2NarrativeMoments.TACTICAL.Recover.Recover_AllEnemiesDefeatedContinue";
    Template.NarrativeMoments[15]="X2NarrativeMoments.TACTICAL.Recover.Recover_ObjAcquiredNoRNF";
    Template.NarrativeMoments[16]="X2NarrativeMoments.TACTICAL.Recover.Recover_ObjAcquiredWithRNF";
    Template.NarrativeMoments[17]="X2NarrativeMoments.TACTICAL.General.CEN_Gen_BurnoutSecured_02";
    Template.NarrativeMoments[18]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[19]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroFailure";
    Template.NarrativeMoments[20]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroPartialSuccess";
    Template.NarrativeMoments[21]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroTotalSuccess";
    Template.NarrativeMoments[22]="X2NarrativeMoments.TACTICAL.General.GenTactical_TacWinOnly";
    Template.NarrativeMoments[23]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";


    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultRecover_VehicleMissionNarrativeTemplate_LW()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultRecover_Vehicle_LW');

	Template.MissionType = "Recover_Vehicle_LW";
    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.Recover.Recover_TacIntro";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.General.GenTactical_SecureRetreat";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.General.GenTactical_ConsiderRetreat";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.General.GenTactical_AdviseRetreat";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.General.GenTactical_PartialEVAC";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.General.GenTactical_FullEVAC";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.Recover.Recover_STObjSpotted";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.Recover.Recover_STObjReacquired";
    Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.Recover.SKY_RecoGEN_ItemSecured";
    Template.NarrativeMoments[9]="X2NarrativeMoments.TACTICAL.Recover.Recover_STObjDropped";
    Template.NarrativeMoments[10]="X2NarrativeMoments.TACTICAL.Recover.Recover_TimerNagThree";
    Template.NarrativeMoments[11]="X2NarrativeMoments.TACTICAL.Recover.Recover_TimerNagLast";
    Template.NarrativeMoments[12]="X2NarrativeMoments.TACTICAL.Recover.Recover_STObjDestroyedEnemyRemain";
    Template.NarrativeMoments[13]="X2NarrativeMoments.TACTICAL.Recover.Recover_STObjDestroyedMissionOver";
    Template.NarrativeMoments[14]="X2NarrativeMoments.TACTICAL.Recover.Recover_AllEnemiesDefeatedContinue";
    Template.NarrativeMoments[15]="X2NarrativeMoments.TACTICAL.Recover.Recover_ObjAcquiredNoRNF";
    Template.NarrativeMoments[16]="X2NarrativeMoments.TACTICAL.Recover.Recover_ObjAcquiredWithRNF";
    Template.NarrativeMoments[17]="X2NarrativeMoments.TACTICAL.General.CEN_Gen_BurnoutSecured_02";
    Template.NarrativeMoments[18]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[19]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroFailure";
    Template.NarrativeMoments[20]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroPartialSuccess";
    Template.NarrativeMoments[21]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroTotalSuccess";
    Template.NarrativeMoments[22]="X2NarrativeMoments.TACTICAL.General.GenTactical_TacWinOnly";
    Template.NarrativeMoments[23]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";

    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultRecover_FlightDeviceMissionNarrativeTemplate_LW(optional name TemplateName = 'DefaultRecover_FlightDevice_LW')
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, TemplateName);

    Template.MissionType = "Recover_FlightDevice_LW";
    Template.NarrativeMoments[0]="X2NarrativeMoments.CEN_FlightDevice_Intro";
    Template.NarrativeMoments[1]="X2NarrativeMoments.T_Setup_Phase_Flight_Device_Spotted_Central";
    Template.NarrativeMoments[2]="X2NarrativeMoments.CEN_FlightDevice_TimerNagThree";
    Template.NarrativeMoments[3]="X2NarrativeMoments.CEN_FlightDevice_TimerNagLast";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.Recover.Recover_STObjDestroyedMissionOver";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.Recover.Recover_AllEnemiesDefeatedContinue";
    Template.NarrativeMoments[6]="X2NarrativeMoments.Setup_Phase_Flight_Device_Recovered";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.General.CEN_Gen_BurnoutSecured_02";
    Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[9]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroTotalSuccess";
    Template.NarrativeMoments[10]="X2NarrativeMoments.TACTICAL.SabotageCC.SabotageCC_HeavyLossesIncurred";
    Template.NarrativeMoments[11]="X2NarrativeMoments.CEN_FlightDevice_TimerStarted";
    Template.NarrativeMoments[12]="X2NarrativeMoments.CEN_Setup_Phase_Flight_Device_Recovered_NO_HOSTILES_ALT";

    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultSupplyRaidATTMissionNarrativeTemplate_LW()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultSupplyRaidATT_LW');

    Template.MissionType = "SupplyRaidATT_LW";
    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.SupplyRaid.SupplyRaid_TacIntroATT";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.SupplyRaid.SupplyRaid_ManyCratesDestroyed";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.SupplyRaid.SupplyRaid_FirstCrateDestroyed";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.support.T_Support_Alien_Tech_Crate_Spotted_Central";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.General.CEN_Gen_BurnoutSecured_02";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.SupplyRaid.SupplyRaid_AllCratesDestroyed";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.General.GenTactical_SecureRetreat";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.General.GenTactical_ConsiderRetreat";
    Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.General.GenTactical_PartialEVAC";
    Template.NarrativeMoments[9]="X2NarrativeMoments.TACTICAL.General.GenTactical_FullEVAC";
    Template.NarrativeMoments[10]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[11]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroFailure";
    Template.NarrativeMoments[12]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroPartialSuccess";
    Template.NarrativeMoments[13]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroTotalSuccess";
    Template.NarrativeMoments[14]="X2NarrativeMoments.TACTICAL.General.GenTactical_TacWinOnly";
    Template.NarrativeMoments[15]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";

    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultSupplyRaidTrainMissionNarrativeTemplate_LW()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultSupplyRaidTrain_LW');

    Template.MissionType = "SupplyRaidTrain_LW";
    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.SupplyRaid.SupplyRaid_TacIntroTRN";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.SupplyRaid.SupplyRaid_ManyCratesDestroyed";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.SupplyRaid.SupplyRaid_FirstCrateDestroyed";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.support.T_Support_Alien_Tech_Crate_Spotted_Central";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.General.CEN_Gen_BurnoutSecured_02";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.SupplyRaid.SupplyRaid_AllCratesDestroyed";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.General.GenTactical_SecureRetreat";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.General.GenTactical_ConsiderRetreat";
    Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.General.GenTactical_PartialEVAC";
    Template.NarrativeMoments[9]="X2NarrativeMoments.TACTICAL.General.GenTactical_FullEVAC";
    Template.NarrativeMoments[10]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[11]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroFailure";
    Template.NarrativeMoments[12]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroPartialSuccess";
    Template.NarrativeMoments[13]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroTotalSuccess";
    Template.NarrativeMoments[14]="X2NarrativeMoments.TACTICAL.General.GenTactical_TacWinOnly";
    Template.NarrativeMoments[15]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";


    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultSupplyRaidConvoyMissionNarrativeTemplate_LW()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultSupplyRaidConvoy_LW');

    Template.MissionType = "SupplyRaidConvoy_LW";
    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.SupplyRaid.SupplyRaid_TacIntroCVY";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.SupplyRaid.SupplyRaid_ManyCratesDestroyed";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.SupplyRaid.SupplyRaid_FirstCrateDestroyed";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.support.T_Support_Alien_Tech_Crate_Spotted_Central";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.General.CEN_Gen_BurnoutSecured_02";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.SupplyRaid.SupplyRaid_AllCratesDestroyed";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.General.GenTactical_SecureRetreat";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.General.GenTactical_ConsiderRetreat";
    Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.General.GenTactical_PartialEVAC";
    Template.NarrativeMoments[9]="X2NarrativeMoments.TACTICAL.General.GenTactical_FullEVAC";
    Template.NarrativeMoments[10]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[11]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroFailure";
    Template.NarrativeMoments[12]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroPartialSuccess";
    Template.NarrativeMoments[13]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroTotalSuccess";
    Template.NarrativeMoments[14]="X2NarrativeMoments.TACTICAL.General.GenTactical_TacWinOnly";
    Template.NarrativeMoments[15]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";


    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultDestroyRelayMissionNarrativeTemplate_LW()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultDestroyRelay_LW');

	Template.MissionType = "DestroyRelay_LW";
    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.DestroyObject.DestroyObject_TacIntro";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.DestroyObject.DestroyObject_STObjSpotted";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.DestroyObject.DestroyObject_ObjectDestroyed";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.DestroyObject.DestroyObject_TimerBurnout";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.DestroyObject.DestroyObject_ProceedToSweep";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.DestroyObject.DestroyObject_TimerNagThree";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.DestroyObject.DestroyObject_TimerNagLast";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.General.GenTactical_SecureRetreat";
    Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.General.GenTactical_ConsiderRetreat";
    Template.NarrativeMoments[9]="X2NarrativeMoments.TACTICAL.General.GenTactical_AdviseRetreat";
    Template.NarrativeMoments[10]="X2NarrativeMoments.TACTICAL.General.GenTactical_PartialEVAC";
    Template.NarrativeMoments[11]="X2NarrativeMoments.TACTICAL.General.GenTactical_FullEVAC";
    Template.NarrativeMoments[12]="X2NarrativeMoments.TACTICAL.General.CEN_Gen_BurnoutSecured_02";
    Template.NarrativeMoments[13]="X2NarrativeMoments.TACTICAL.DestroyObject.DestroyObject_AllEnemiesDefeated_Continue";
    Template.NarrativeMoments[14]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[15]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroFailure";
    Template.NarrativeMoments[16]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroPartialSuccess";
    Template.NarrativeMoments[17]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroTotalSuccess";
    Template.NarrativeMoments[18]="X2NarrativeMoments.TACTICAL.General.GenTactical_TacWinOnly";
    Template.NarrativeMoments[19]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";

    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultSabotageTransmitterMissionNarrativeTemplate_LW()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultSabotageTransmitter_LW');

	Template.MissionType = "SabotageTransmitter_LW";
    Template.NarrativeMoments[0]="XPACK_NarrativeMoments.X2_XP_CEN_T_Sabotage_Trans_Transmitter_Not_Destroyed";
    Template.NarrativeMoments[1]="XPACK_NarrativeMoments.X2_XP_CEN_T_Sabotage_Trans_Transmitter_Disconnected";
    Template.NarrativeMoments[2]="XPACK_NarrativeMoments.X2_XP_CEN_T_Sabotage_Trans_Trans_Spotted";
    Template.NarrativeMoments[3]="XPACK_NarrativeMoments.X2_XP_CEN_T_Sabotage_Trans_Squad_Wipe";
    Template.NarrativeMoments[4]="XPACK_NarrativeMoments.X2_XP_CEN_T_Sabotage_Trans_Squad_Heavy_Losses";
    Template.NarrativeMoments[5]="XPACK_NarrativeMoments.X2_XP_CEN_T_Sabotage_Trans_Mission_Intro";
    Template.NarrativeMoments[6]="XPACK_NarrativeMoments.X2_XP_CEN_T_Sabotage_Trans_Mission_Accomplished";
    Template.NarrativeMoments[7]="XPACK_NarrativeMoments.X2_XP_CEN_T_Sabotage_Trans_Mission_Aborted";
    Template.NarrativeMoments[8]="XPACK_NarrativeMoments.X2_XP_CEN_T_Sabotage_Trans_Last_Relay_Destroyed";
    Template.NarrativeMoments[9]="XPACK_NarrativeMoments.X2_XP_CEN_T_Sabotage_Trans_Last_Chance_Transmitter";
    Template.NarrativeMoments[10]="XPACK_NarrativeMoments.X2_XP_CEN_T_Sabotage_Trans_Hostiles_Down_Plant_Charges";
    Template.NarrativeMoments[11]="XPACK_NarrativeMoments.X2_XP_CEN_T_Sabotage_Trans_Eliminate_Enemies_Cutoff";
    Template.NarrativeMoments[12]="XPACK_NarrativeMoments.X2_XP_CEN_T_Sabotage_Trans_Charges_Planted";
    Template.NarrativeMoments[13]="XPACK_NarrativeMoments.X2_XP_CEN_T_Sabotage_Trans_Almost_DC";
    Template.NarrativeMoments[14]="XPACK_NarrativeMoments.X2_XP_TYG_T_Sabotage_Trans_Relay_Spotted";
    Template.NarrativeMoments[15]="XPACK_NarrativeMoments.X2_XP_TYG_T_Sabotage_Trans_Relay_Destroyed";

    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultCovertEscapeMissionNarrativeTemplate_LW()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultCovertEscape_LW');

    Template.MissionType = "CovertEscape_LW";
    Template.NarrativeMoments[0]="XPACK_NarrativeMoments.X2_XP_CEN_T_Covert_Escape_Squad Wipe";
    Template.NarrativeMoments[1]="XPACK_NarrativeMoments.X2_XP_CEN_T_Covert_Escape_Squad Extracted";
    Template.NarrativeMoments[2]="XPACK_NarrativeMoments.X2_XP_CEN_T_Covert_Escape_Partial Squad Recovery";
    Template.NarrativeMoments[3]="XPACK_NarrativeMoments.X2_XP_CEN_T_Covert_Escape_Operative Down";
    Template.NarrativeMoments[4]="XPACK_NarrativeMoments.X2_XP_CEN_T_Covert_Escape_Operative Dead";
    Template.NarrativeMoments[5]="XPACK_NarrativeMoments.X2_XP_CEN_T_Covert_Escape_Objective Indicated";
    Template.NarrativeMoments[6]="XPACK_NarrativeMoments.X2_XP_CEN_T_Covert_Escape_Mission Intro";
    Template.NarrativeMoments[7]="XPACK_NarrativeMoments.X2_XP_CEN_T_Covert_Escape_Many Enemies Reminder";
    Template.NarrativeMoments[8]="XPACK_NarrativeMoments.X2_XP_CEN_T_Covert_Escape_Last Operative";
    Template.NarrativeMoments[9]="XPACK_NarrativeMoments.X2_XP_CEN_T_Covert_Escape_Kill Captain";
    Template.NarrativeMoments[10]="XPACK_NarrativeMoments.X2_XP_CEN_T_Covert_Escape_Captain Dead";

    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultCovertEscapeNonPCPMissionNarrativeTemplate_LW()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultCovertEscape_NonPCP_LW');

    Template.MissionType = "CovertEscape_NonPCP_LW";
    Template.NarrativeMoments[0]="XPACK_NarrativeMoments.X2_XP_CEN_T_Covert_Escape_Squad Wipe";
    Template.NarrativeMoments[1]="XPACK_NarrativeMoments.X2_XP_CEN_T_Covert_Escape_Squad Extracted";
    Template.NarrativeMoments[2]="XPACK_NarrativeMoments.X2_XP_CEN_T_Covert_Escape_Partial Squad Recovery";
    Template.NarrativeMoments[3]="XPACK_NarrativeMoments.X2_XP_CEN_T_Covert_Escape_Operative Down";
    Template.NarrativeMoments[4]="XPACK_NarrativeMoments.X2_XP_CEN_T_Covert_Escape_Operative Dead";
    Template.NarrativeMoments[5]="XPACK_NarrativeMoments.X2_XP_CEN_T_Covert_Escape_Objective Indicated";
    Template.NarrativeMoments[6]="XPACK_NarrativeMoments.X2_XP_CEN_T_Covert_Escape_Mission Intro";
    Template.NarrativeMoments[7]="XPACK_NarrativeMoments.X2_XP_CEN_T_Covert_Escape_Many Enemies Reminder";
    Template.NarrativeMoments[8]="XPACK_NarrativeMoments.X2_XP_CEN_T_Covert_Escape_Last Operative";
    Template.NarrativeMoments[9]="XPACK_NarrativeMoments.X2_XP_CEN_T_Covert_Escape_Kill Captain";
    Template.NarrativeMoments[10]="XPACK_NarrativeMoments.X2_XP_CEN_T_Covert_Escape_Captain Dead";

    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultExtractMissionNarrativeTemplate_LW()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultExtract_LW');

	Template.MissionType = "Extract_LW";
    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.General.SKY_ExtrGEN_STObjSecured";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.General.SKY_ExtrGEN_STObjSecured";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.General.CEN_ExtrGEN_STObjDestroyed";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.Extract.Extract_CEN_VIPKilled_Continue";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.Extract.Central_Extract_VIP_TimerNagThree";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.Extract.Central_Extract_VIP_TimerNagSix";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.Extract.Central_Extract_VIP_TimerNagLast";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.Extract.Central_Extract_VIP_Timer_Expired";
    Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.General.CEN_ExtrGEN_Intro_01";
    Template.NarrativeMoments[9]="X2NarrativeMoments.TACTICAL.Neutralize.Neutralize_SecureRetreat";
    Template.NarrativeMoments[10]="X2NarrativeMoments.TACTICAL.Extract.Central_Extract_VIP_Evac_Destroyed";
    Template.NarrativeMoments[11]="X2NarrativeMoments.TACTICAL.Neutralize.Neutralize_AdviseRetreat";
    Template.NarrativeMoments[12]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[13]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroFailure";
    Template.NarrativeMoments[14]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroPartialSuccess";
    Template.NarrativeMoments[15]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroTotalSuccess";
    Template.NarrativeMoments[16]="X2NarrativeMoments.TACTICAL.General.GenTactical_TacWinOnly";
    Template.NarrativeMoments[17]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[18]="X2NarrativeMoments.T_Extraction_Reminder_Squad_Not_Concealed_A_Central";

    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultRescue_AdventCellMissionNarrativeTemplate_LW()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultRescue_AdventCell_LW');

	Template.MissionType = "Rescue_AdventCell_LW";
    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.RescueVIP.CEN_RescVEH_Intro";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.Neutralize.Neutralize_VIPSpotted";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.RescueVIP.Rescue_CEN_VIPAcquired";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.General.SKY_ExtrGEN_STObjSecured";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.General.SKY_ExtrGEN_STObjSecured";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_TimerExpired";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_TimerNagThree";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_TimerNagSix";
    Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_TimerNagLast";
    Template.NarrativeMoments[9]="X2NarrativeMoments.TACTICAL.Neutralize.CEN_Neut_TargetLost";
    Template.NarrativeMoments[10]="X2NarrativeMoments.TACTICAL.General.CEN_ExtrGEN_STObjDestroyed";
    Template.NarrativeMoments[11]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_RNFInbound";
    Template.NarrativeMoments[12]="X2NarrativeMoments.TACTICAL.Neutralize.Neutralize_AdviseRetreat";
    Template.NarrativeMoments[13]="X2NarrativeMoments.TACTICAL.General.GenTactical_ConsiderRetreat";
    Template.NarrativeMoments[14]="X2NarrativeMoments.TACTICAL.Neutralize.Neutralize_SecureRetreat";
    Template.NarrativeMoments[15]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[16]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroFailure";
    Template.NarrativeMoments[17]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroPartialSuccess";
    Template.NarrativeMoments[18]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroTotalSuccess";
    Template.NarrativeMoments[19]="X2NarrativeMoments.TACTICAL.General.GenTactical_TacWinOnly";
    Template.NarrativeMoments[20]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[21]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_EvacDestroyed";

    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultRescue_VehicleMissionNarrativeTemplate_LW()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultRescue_Vehicle_LW');

	Template.MissionType = "Rescue_Vehicle_LW";
    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.RescueVIP.CEN_RescVEH_Intro";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.Neutralize.Neutralize_VIPSpotted";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.RescueVIP.Rescue_CEN_VIPAcquired";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.General.SKY_ExtrGEN_STObjSecured";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.General.SKY_ExtrGEN_STObjSecured";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_TimerExpired";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_TimerNagThree";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_TimerNagSix";
    Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_TimerNagLast";
    Template.NarrativeMoments[9]="X2NarrativeMoments.TACTICAL.Neutralize.CEN_Neut_TargetLost";
    Template.NarrativeMoments[10]="X2NarrativeMoments.TACTICAL.General.CEN_ExtrGEN_STObjDestroyed";
    Template.NarrativeMoments[11]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_RNFInbound";
    Template.NarrativeMoments[12]="X2NarrativeMoments.TACTICAL.Neutralize.Neutralize_AdviseRetreat";
    Template.NarrativeMoments[13]="X2NarrativeMoments.TACTICAL.General.GenTactical_ConsiderRetreat";
    Template.NarrativeMoments[14]="X2NarrativeMoments.TACTICAL.Neutralize.Neutralize_SecureRetreat";
    Template.NarrativeMoments[15]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[16]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroFailure";
    Template.NarrativeMoments[17]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroPartialSuccess";
    Template.NarrativeMoments[18]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroTotalSuccess";
    Template.NarrativeMoments[19]="X2NarrativeMoments.TACTICAL.General.GenTactical_TacWinOnly";
    Template.NarrativeMoments[20]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[21]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_EvacDestroyed";


    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultHackMissionNarrativeTemplate_LW()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultHack_LW');

	Template.MissionType = "Hack_LW";

    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.Hack.Hack_TacIntro";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.General.GenTactical_SecureRetreat";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.General.GenTactical_ConsiderRetreat";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.General.GenTactical_AdviseRetreat";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.General.GenTactical_PartialEVAC";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.General.GenTactical_FullEVAC";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.Hack.Hack_TerminalSpotted";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.Hack.Hack_TimerNagThree";
    Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.Hack.Hack_TimerNagLast";
    Template.NarrativeMoments[9]="X2NarrativeMoments.TACTICAL.Hack.Hack_TimerBurnout";
    Template.NarrativeMoments[10]="X2NarrativeMoments.TACTICAL.Hack.Hack_TerminalDestroyedEnemyRemain";
    Template.NarrativeMoments[11]="X2NarrativeMoments.TACTICAL.Hack.Hack_TerminalDestroyedMissionOver";
    Template.NarrativeMoments[12]="X2NarrativeMoments.TACTICAL.General.CEN_Gen_AreaSecured_02";
    Template.NarrativeMoments[13]="X2NarrativeMoments.TACTICAL.Hack.Central_Hack_TerminalHackedWithRNF";
    Template.NarrativeMoments[14]="X2NarrativeMoments.TACTICAL.Hack.CEN_Hack_TerminalHacked";
    Template.NarrativeMoments[15]="X2NarrativeMoments.TACTICAL.General.CEN_Gen_BurnoutSecured_02";
    Template.NarrativeMoments[16]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[17]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroFailure";
    Template.NarrativeMoments[18]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroPartialSuccess";
    Template.NarrativeMoments[19]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroTotalSuccess";
    Template.NarrativeMoments[20]="X2NarrativeMoments.TACTICAL.General.GenTactical_TacWinOnly";
    Template.NarrativeMoments[21]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    
    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultHack_ADVMissionNarrativeTemplate_LW()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultHack_ADV_LW');

    Template.MissionType = "Hack_ADV_LW";
    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.Hack.Hack_TacIntro";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.General.GenTactical_SecureRetreat";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.General.GenTactical_ConsiderRetreat";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.General.GenTactical_AdviseRetreat";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.General.GenTactical_PartialEVAC";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.General.GenTactical_FullEVAC";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.Hack.Hack_TerminalSpotted";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.Hack.Hack_TimerNagThree";
    Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.Hack.Hack_TimerNagLast";
    Template.NarrativeMoments[9]="X2NarrativeMoments.TACTICAL.Hack.Hack_TimerBurnout";
    Template.NarrativeMoments[10]="X2NarrativeMoments.TACTICAL.Hack.Hack_TerminalDestroyedEnemyRemain";
    Template.NarrativeMoments[11]="X2NarrativeMoments.TACTICAL.Hack.Hack_TerminalDestroyedMissionOver";
    Template.NarrativeMoments[12]="X2NarrativeMoments.TACTICAL.General.CEN_Gen_AreaSecured_02";
    Template.NarrativeMoments[13]="X2NarrativeMoments.TACTICAL.Hack.Central_Hack_TerminalHackedWithRNF";
    Template.NarrativeMoments[14]="X2NarrativeMoments.TACTICAL.Hack.CEN_Hack_TerminalHacked";
    Template.NarrativeMoments[15]="X2NarrativeMoments.TACTICAL.General.CEN_Gen_BurnoutSecured_02";
    Template.NarrativeMoments[16]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[17]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroFailure";
    Template.NarrativeMoments[18]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroPartialSuccess";
    Template.NarrativeMoments[19]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroTotalSuccess";
    Template.NarrativeMoments[20]="X2NarrativeMoments.TACTICAL.General.GenTactical_TacWinOnly";
    Template.NarrativeMoments[21]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";

    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultHack_TrainMissionNarrativeTemplate_LW()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultHack_Train_LW');

	Template.MissionType = "Hack_Train_LW";
    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.Hack.Hack_TacIntro";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.General.GenTactical_SecureRetreat";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.General.GenTactical_ConsiderRetreat";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.General.GenTactical_AdviseRetreat";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.General.GenTactical_PartialEVAC";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.General.GenTactical_FullEVAC";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.Hack.Hack_TerminalSpotted";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.Hack.Hack_TimerNagThree";
    Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.Hack.Hack_TimerNagLast";
    Template.NarrativeMoments[9]="X2NarrativeMoments.TACTICAL.Hack.Hack_TimerBurnout";
    Template.NarrativeMoments[10]="X2NarrativeMoments.TACTICAL.Hack.Hack_TerminalDestroyedEnemyRemain";
    Template.NarrativeMoments[11]="X2NarrativeMoments.TACTICAL.Hack.Hack_TerminalDestroyedMissionOver";
    Template.NarrativeMoments[12]="X2NarrativeMoments.TACTICAL.General.CEN_Gen_AreaSecured_02";
    Template.NarrativeMoments[13]="X2NarrativeMoments.TACTICAL.Hack.Central_Hack_TerminalHackedWithRNF";
    Template.NarrativeMoments[14]="X2NarrativeMoments.TACTICAL.Hack.CEN_Hack_TerminalHacked";
    Template.NarrativeMoments[15]="X2NarrativeMoments.TACTICAL.General.CEN_Gen_BurnoutSecured_02";
    Template.NarrativeMoments[16]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[17]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroFailure";
    Template.NarrativeMoments[18]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroPartialSuccess";
    Template.NarrativeMoments[19]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroTotalSuccess";
    Template.NarrativeMoments[20]="X2NarrativeMoments.TACTICAL.General.GenTactical_TacWinOnly";
    Template.NarrativeMoments[21]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    
    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultProtectDeviceMissionNarrativeTemplate_LW()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultProtectDevice_LW');

	Template.MissionType = "ProtectDevice_LW";
    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.General.GenTactical_SecureRetreat";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.General.GenTactical_ConsiderRetreat";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.General.GenTactical_PartialEVAC";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.General.GenTactical_FullEVAC";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.ProtectDevice.T_Protect_Device_PrDv_Intro";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.ProtectDevice.T_Protect_Device_PrDv_ProceedToSweep";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.ProtectDevice.T_Protect_Device_PrDv_STObjDestroyed";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.General.CEN_Gen_BurnoutSecured_02";
    Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[9]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroFailure";
    Template.NarrativeMoments[10]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroPartialSuccess";
    Template.NarrativeMoments[11]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroTotalSuccess";
    Template.NarrativeMoments[12]="X2NarrativeMoments.T_Protect_Device_Sighted_Central";

    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultNeutralizeTargetMissionNarrativeTemplate_LW()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultNeutralizeTarget_LW');

	Template.MissionType = "NeutralizeTarget_LW";
    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.Neutralize.Neutralize_TacIntro";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.Neutralize.Neutralize_VIPSpotted";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.General.SKY_ExtrGEN_STObjSecured";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.Neutralize.Neutralize_VIPKilledAfterCapture";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.Neutralize.Neutralize_VIPExecuted";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.Neutralize.CEN_Neut_TargetInCustody";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_TimerNagThree";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_TimerNagSix";
    Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_TimerNagLast";
    Template.NarrativeMoments[9]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_TimerExpired";
    Template.NarrativeMoments[10]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_RNFInbound";
    Template.NarrativeMoments[11]="X2NarrativeMoments.TACTICAL.Neutralize.Neutralize_AdviseRetreat";
    Template.NarrativeMoments[12]="X2NarrativeMoments.TACTICAL.General.GenTactical_ConsiderRetreat";
    Template.NarrativeMoments[13]="X2NarrativeMoments.TACTICAL.Neutralize.Neutralize_SecureRetreat";
    Template.NarrativeMoments[14]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_EvacDestroyed";
    Template.NarrativeMoments[15]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[16]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroFailure";
    Template.NarrativeMoments[17]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroPartialSuccess";
    Template.NarrativeMoments[18]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroTotalSuccess";
    Template.NarrativeMoments[19]="X2NarrativeMoments.TACTICAL.General.GenTactical_TacWinOnly";
    Template.NarrativeMoments[20]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
	Template.NarrativeMoments[21]="X2NarrativeMoments.TACTICAL.support.T_Support_Reminder_Knock_Out_VIP_Central_01";
    
    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultNeutralize_VehicleMissionNarrativeTemplate_LW()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultNeutralize_Vehicle_LW');

	Template.MissionType = "Neutralize_Vehicle_LW";
    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.Neutralize.Neutralize_TacIntro";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.Neutralize.Neutralize_VIPSpotted";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.General.SKY_ExtrGEN_STObjSecured";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.Neutralize.Neutralize_VIPKilledAfterCapture";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.Neutralize.Neutralize_VIPExecuted";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.Neutralize.CEN_Neut_TargetInCustody";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_TimerNagThree";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_TimerNagSix";
    Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_TimerNagLast";
    Template.NarrativeMoments[9]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_TimerExpired";
    Template.NarrativeMoments[10]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_RNFInbound";
    Template.NarrativeMoments[11]="X2NarrativeMoments.TACTICAL.Neutralize.Neutralize_AdviseRetreat";
    Template.NarrativeMoments[12]="X2NarrativeMoments.TACTICAL.General.GenTactical_ConsiderRetreat";
    Template.NarrativeMoments[13]="X2NarrativeMoments.TACTICAL.Neutralize.Neutralize_SecureRetreat";
    Template.NarrativeMoments[14]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_EvacDestroyed";
    Template.NarrativeMoments[15]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[16]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroFailure";
    Template.NarrativeMoments[17]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroPartialSuccess";
    Template.NarrativeMoments[18]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroTotalSuccess";
    Template.NarrativeMoments[19]="X2NarrativeMoments.TACTICAL.General.GenTactical_TacWinOnly";
    Template.NarrativeMoments[20]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
	Template.NarrativeMoments[21]="X2NarrativeMoments.TACTICAL.support.T_Support_Reminder_Knock_Out_VIP_Central_01";

    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultAssaultNetworkTowerMissionNarrativeTemplate_LW()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultAssaultNetworkTower_LW');

    Template.MissionType = "AssaultNetworkTower_LW";
    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.Broadcast.Broadcast_TacIntro";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.Broadcast.Broadcast_ObjSpotted";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.Broadcast.Broadcast_ArrayHacked";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.Broadcast.Broadcast_FailureSquadWipe";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.ProtectDevice.T_Protect_Device_PrDv_ProceedToSweep";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.General.CEN_Gen_AreaSecured_03";
    Template.NarrativeMoments[6]="LWNarrativeMoments_Bink.TACTICAL.CIN_HackNetworkTower_LW";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.General.GenTactical_PartialEVAC";
    Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroFailure";

    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultAssaultAlienFortressMissionNarrativeTemplate_LW()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultAssaultAlienFortress_LW');

    Template.MissionType = "GP_Fortress_LW";
    Template.NarrativeMoments[0]="X2NarrativeMoments.T_Final_Mission_The_Fortress";
    Template.NarrativeMoments[1]="X2NarrativeMoments.T_Final_Mission_XCOM_Avatar_Has_Died";
    Template.NarrativeMoments[2]="X2NarrativeMoments.T_Final_Mission_Final_Showdown_Begins";
    Template.NarrativeMoments[3]="X2NarrativeMoments.T_Final_Mission_Enemy_Avatar_1_Has_Died";
    Template.NarrativeMoments[4]="X2NarrativeMoments.T_Final_Mission_Final_Set_One";
    Template.NarrativeMoments[5]="X2NarrativeMoments.T_Final_Mission_Final_Set_Two";
    Template.NarrativeMoments[6]="X2NarrativeMoments.T_Final_Mission_Final_Set_Three";
    Template.NarrativeMoments[7]="X2NarrativeMoments.T_Final_Mission_Final_Set_Four";
    Template.NarrativeMoments[8]="X2NarrativeMoments.T_Final_Mission_First_Set_One";
    Template.NarrativeMoments[9]="X2NarrativeMoments.T_Final_Mission_First_Set_Two";
    Template.NarrativeMoments[10]="X2NarrativeMoments.T_Final_Mission_First_Set_Three";
    Template.NarrativeMoments[11]="X2NarrativeMoments.T_Final_Mission_First_Set_Four";
    Template.NarrativeMoments[12]="X2NarrativeMoments.T_Final_Mission_First_Set_Five";
    Template.NarrativeMoments[13]="X2NarrativeMoments.T_Final_Mission_First_Set_Six";
    Template.NarrativeMoments[14]="X2NarrativeMoments.T_Final_Mission_Middle_Set_One";
    Template.NarrativeMoments[15]="X2NarrativeMoments.T_Final_Mission_Middle_Set_Two";
    Template.NarrativeMoments[16]="X2NarrativeMoments.T_Final_Mission_Middle_Set_Three";
    Template.NarrativeMoments[17]="X2NarrativeMoments.T_Final_Mission_Middle_Set_Four";

    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultAdventFacilityBlacksiteMissionNarrativeTemplate_LW()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultAdventFacilityBlacksite_LW');

    Template.MissionType = "GP_Blacksite_LW";
    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.Blacksite.Blacksite_SecureRetreat";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.General.GenTactical_ConsiderRetreat";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.General.GenTactical_PartialEVAC";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.General.GenTactical_FullEVAC";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.Blacksite.Blacksite_TacIntro";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.Blacksite.Blacksite_STWin_HL";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.Blacksite.Blacksite_STWin";
    Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.Blacksite.Blacksite_FailureSquadWipe";
    Template.NarrativeMoments[9]="X2NarrativeMoments.TACTICAL.Blacksite.Blacksite_FailureAbortHL";
    Template.NarrativeMoments[10]="X2NarrativeMoments.TACTICAL.Blacksite.Blacksite_FailureAbort";
    Template.NarrativeMoments[11]="X2NarrativeMoments.TACTICAL.Blacksite.CEN_Blacksite_STObjTwoSpotted";
    Template.NarrativeMoments[12]="X2NarrativeMoments.TACTICAL.Blacksite.CEN_Blacksite_Mission_STObjAcquired";
    Template.NarrativeMoments[13]="X2NarrativeMoments.TACTICAL.Blacksite.CEN_Blacksite_Mission_STObjDropped";
    Template.NarrativeMoments[14]="X2NarrativeMoments.TACTICAL.Recover.SKY_RecoGEN_ItemSecured";
    Template.NarrativeMoments[15]="X2NarrativeMoments.TACTICAL.Blacksite.CEN_Blacksite_STObjReacquired";
    Template.NarrativeMoments[16]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_RNFInbound";  
    Template.NarrativeMoments[17]="X2NarrativeMoments.T_Blacksite_Interior_Reveal_ALT";

    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultAdventFacilityForgeMissionNarrativeTemplate_LW()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultAdventFacilityForge_LW');

    Template.MissionType = "GP_Forge_LW";
    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.Forge.Forge_TacIntro";
    Template.NarrativeMoments[1]="X2NarrativeMoments.T_Forge_Interior_Reveal";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.Forge.Forge_MissionSquadWipe";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.Forge.Forge_MissionFailure";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.Forge.CEN_Forge_TacOutro";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.Forge.Forge_SecureRetreat";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.Forge.Forge_AdviseRetreat";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.Forge.Forge_PrototypeDropped";
    Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.Forge.Forge_PrototypeReacquired";
    Template.NarrativeMoments[9]="X2NarrativeMoments.TACTICAL.Neutralize.CEN_Neut_TargetInCustody";
    Template.NarrativeMoments[10]="X2NarrativeMoments.TACTICAL.Neutralize.CEN_Neut_TargetInCustody";
    Template.NarrativeMoments[11]="X2NarrativeMoments.TACTICAL.Forge.Forge_PrototypeSpotted";
    Template.NarrativeMoments[12]="X2NarrativeMoments.TACTICAL.Forge.Forge_PrototypeAcquired";

    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultAdventFacilityPsiGateMissionNarrativeTemplate_LW()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultAdventFacilityPsiGate_LW');

    Template.MissionType = "GP_PsiGate_LW";
    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.PsiGate.PsiGate_TacIntro";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.General.GenTactical_PartialEVAC";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.General.GenTactical_FullEVAC";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.PsiGate.PsiGate_AdviseRetreat";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.PsiGate.PsiGate_AllEnemiesDefeated";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.PsiGate.T_Psi_Gate_Gateway_Spotted_Central_P1";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.PsiGate.PsiGate_MissionFailure";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.PsiGate.CEN_PsiGate_FailureSquadWipe";
    Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.PsiGate.CEN_PsiGate_STWin";

    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultCentralNetworkBroadcastMissionNarrativeTemplate_LW()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultCentralNetworkBroadcast_LW');

    Template.MissionType = "GP_Broadcast_LW";
    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.Broadcast.Broadcast_TacIntro";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.Broadcast.Broadcast_ObjSpotted";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.Broadcast.Broadcast_ArrayHacked";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.Broadcast.Broadcast_FailureSquadWipe";

    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultSabotageMissionNarrativeTemplate_LW()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultSabotage_LW');

	Template.MissionType = "Sabotage_LW";
    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.Sabotage.Sabotage_BombDetonated";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.Sabotage.Sabotage_TacIntro";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.Sabotage.Sabotage_BombSpotted";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.General.GenTactical_PartialEVAC";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.General.GenTactical_FullEVAC";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.Sabotage.Sabotage_ConsiderRetreat";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.Sabotage.Sabotage_BombPlantedNoRNF";
    Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.Sabotage.Sabotage_CompletionNag";
    Template.NarrativeMoments[9]="X2NarrativeMoments.TACTICAL.Sabotage.Sabotage_RNFIncoming";
    Template.NarrativeMoments[10]="X2NarrativeMoments.TACTICAL.Sabotage.Sabotage_SignalJammed";
    Template.NarrativeMoments[11]="X2NarrativeMoments.TACTICAL.Sabotage.Sabotage_AllEnemiesDefeatedContinue";
    Template.NarrativeMoments[12]="X2NarrativeMoments.TACTICAL.Sabotage.Sabotage_AllEnemiesDefeatedObjCompleted";
    Template.NarrativeMoments[13]="X2NarrativeMoments.TACTICAL.Sabotage.Sabotage_SecureRetreat";
    Template.NarrativeMoments[14]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroFailure";

    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultSabotageCCMissionNarrativeTemplate_LW()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultSabotageCC_LW');

    Template.MissionType = "SabotageCC_LW";
    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.SabotageCC.SabotageCC_BombDetonated";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.SabotageCC.SabotageCC_HeavyLossesIncurred";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.SabotageCC.SabotageCC_TacIntro";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.SabotageCC.SabotageCC_BombSpotted";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.SabotageCC.SabotageCC_CompletionNag";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.SabotageCC.SabotageCC_AllEnemiesDefeated";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.SabotageCC.SabotageCC_AreaSecuredMissionEnd";
    Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.SabotageCC.SabotageCC_BombPlantedEnd";
    Template.NarrativeMoments[9]="X2NarrativeMoments.TACTICAL.SabotageCC.SabotageCC_BombPlantedContinue";

    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultSecureUFOMissionNarrativeTemplate_LW()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultSecureUFO_LW');

    Template.MissionType = "SecureUFO_LW";
    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.SecureUFO.SecureUFO_TacIntro";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.SecureUFO.SecureUFO_DistressResponse";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.SecureUFO.SecureUFO_DistressLocated";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.SecureUFO.SecureUFO_DistressInitiated";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.SecureUFO.SecureUFO_DistressDeactivatedEnd";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.SecureUFO.SecureUFO_DistressDeactivatedEnd";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.General.GenTactical_ConsiderRetreat";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroFailure";
    Template.NarrativeMoments[9]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroPartialSuccess";
    Template.NarrativeMoments[10]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroTotalSuccess";
    Template.NarrativeMoments[11]="X2NarrativeMoments.TACTICAL.General.GenTactical_TacWinOnly";
    Template.NarrativeMoments[12]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[13]="X2NarrativeMoments.TACTICAL.General.GenTactical_FullEVAC";
    Template.NarrativeMoments[14]="X2NarrativeMoments.TACTICAL.General.GenTactical_PartialEVAC";

    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultAvengerDefenseMissionNarrativeTemplate_LW()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultAvengerDefense_LW');

	Template.MissionType = "AvengerDefense_LW";
    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.AvengerDefense.AvengerDefense_TacIntro";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.AvengerDefense.AvengerDefense_DisruptorSighted";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.AvengerDefense.AvengerDefense_ClearForTakeoff";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.AvengerDefense.AvengerDefense_ClearForTakeoffHL";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.AvengerDefense.AvengerDefense_DisruptorDestroyed";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.AvengerDefense.AvengerDefense_FailureSquadWipe";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.AvengerDefense.AvengerDefense_FirstBoardingWarning";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.AvengerDefense.AvengerDefense_HeavyLosses";
    Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.AvengerDefense.AvengerDefense_HLOnExtract";
    Template.NarrativeMoments[9]="X2NarrativeMoments.TACTICAL.AvengerDefense.AvengerDefense_HostileInThreatZone";
    Template.NarrativeMoments[10]="X2NarrativeMoments.TACTICAL.AvengerDefense.AvengerDefense_HostileKilledClear";
    Template.NarrativeMoments[11]="X2NarrativeMoments.TACTICAL.AvengerDefense.AvengerDefense_HostileKilledRemaining";
    Template.NarrativeMoments[12]="X2NarrativeMoments.TACTICAL.AvengerDefense.AvengerDefense_MultipleHostilesInThreatZone";
    Template.NarrativeMoments[13]="X2NarrativeMoments.TACTICAL.AvengerDefense.AvengerDefense_OutroSuccess";
    Template.NarrativeMoments[14]="X2NarrativeMoments.TACTICAL.AvengerDefense.AvengerDefense_OutroSuccessHL";
    Template.NarrativeMoments[15]="X2NarrativeMoments.TACTICAL.AvengerDefense.AvengerDefense_ShipBoarded";
    Template.NarrativeMoments[16]="X2NarrativeMoments.TACTICAL.AvengerDefense.AvengerDefense_XCOMReinforced";
    Template.NarrativeMoments[17]="X2NarrativeMoments.TACTICAL.AvengerDefense.AvengerDefense_RNFFirst";
    Template.NarrativeMoments[18]="X2NarrativeMoments.TACTICAL.Sabotage.Sabotage_RNFIncoming";
    Template.NarrativeMoments[19]="X2NarrativeMoments.TACTICAL.AvengerDefense.AvengerDefense_ForcesExhausted";

    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultTerrorMissionNarrativeTemplate_LW()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultTerror_LW');

	Template.MissionType = "Terror_LW";
    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.Terror.Terror_AllEnemiesDefeated";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.General.GenTactical_SecureRetreat";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.General.GenTactical_ConsiderRetreat";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.Terror.Terror_AdviseRetreat";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.General.GenTactical_PartialEVAC";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.General.GenTactical_FullEVAC";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.Terror.Terror_TacIntro";
    Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.Terror.Terror_SaveCompleteT1";
    Template.NarrativeMoments[9]="X2NarrativeMoments.TACTICAL.Terror.Terror_SaveCompleteT2";
    Template.NarrativeMoments[10]="X2NarrativeMoments.TACTICAL.Terror.Terror_SaveCompleteT3";
    Template.NarrativeMoments[11]="X2NarrativeMoments.TACTICAL.Terror.Terror_CivilianKilledT1";
    Template.NarrativeMoments[12]="X2NarrativeMoments.TACTICAL.Terror.Terror_CivilianKilledT2";
    Template.NarrativeMoments[13]="X2NarrativeMoments.TACTICAL.Terror.Terror_CivilianKilledT3";
    Template.NarrativeMoments[14]="X2NarrativeMoments.TACTICAL.Terror.Terror_CivilianWipe";
    Template.NarrativeMoments[15]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[16]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroFailure";
    Template.NarrativeMoments[17]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroPartialSuccess";
    Template.NarrativeMoments[18]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroTotalSuccess";
    Template.NarrativeMoments[19]="X2NarrativeMoments.TACTICAL.General.GenTactical_TacWinOnly";
    Template.NarrativeMoments[20]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[21]="X2NarrativeMoments.T_Retaliation_Reminder_Squad_Not_Concealed_C_Central";

    return Template;
}
static function X2MissionNarrativeTemplate AddJailbreakMissionNarrativeTemplate()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultJailbreak_LW');

    Template.MissionType="Jailbreak_LW";

    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.General.CEN_ExtrGEN_Intro_01";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.Terror.Terror_SaveCompleteT1";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.Neutralize.Neutralize_VIPKilledAfterCapture";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.Extract.Central_Extract_VIP_TimerNagSix";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.Extract.Central_Extract_VIP_TimerNagThree";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.Extract.Central_Extract_VIP_TimerNagLast";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.Extract.Central_Extract_VIP_Timer_Expired";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.General.GenTactical_ConsiderRetreat";
    Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.General.GenTactical_SecureRetreat";
    Template.NarrativeMoments[9]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_EvacDestroyed";
    Template.NarrativeMoments[10]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[11]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroFailure";
    Template.NarrativeMoments[12]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroTotalSuccess";
    Template.NarrativeMoments[13]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";

    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultIntelRaidMissionNarrativeTemplate()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultIntelRaid_LW');

	Template.MissionType = "IntelRaid_LW";

    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.General.GenTactical_SecureRetreat";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.General.GenTactical_ConsiderRetreat";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.General.GenTactical_PartialEVAC";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.General.GenTactical_FullEVAC";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.ProtectDevice.T_Protect_Device_PrDv_Intro";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.ProtectDevice.T_Protect_Device_PrDv_STObjDestroyed";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.ProtectDevice.T_Protect_Device_PrDv_ProceedToSweep";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.General.CEN_Gen_BurnoutSecured_02";
    Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[9]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroFailure";
    Template.NarrativeMoments[10]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroPartialSuccess";
    Template.NarrativeMoments[11]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroTotalSuccess";
    Template.NarrativeMoments[12]="X2NarrativeMoments.T_Protect_Device_Sighted_Central";

    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultSupplyConvoyMissionNarrativeTemplate()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultSupplyConvoy_LW');

	Template.MissionType = "SupplyConvoy_LW";

    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.General.GenTactical_SecureRetreat";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.General.GenTactical_ConsiderRetreat";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.General.GenTactical_PartialEVAC";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.General.GenTactical_FullEVAC";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.General.CEN_Gen_BurnoutSecured_02";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroFailure";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroTotalSuccess";

    return Template;
}

static function X2MissionNarrativeTemplate AddDefaultRecruitRaidMissionNarrativeTemplate()
{
    local X2MissionNarrativeTemplate Template;

    `CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultRecruitRaid_LW');

	Template.MissionType = "RecruitRaid_LW";

    Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.General.GenTactical_SecureRetreat";
    Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.General.GenTactical_ConsiderRetreat";
    Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.General.GenTactical_PartialEVAC";
    Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.General.GenTactical_FullEVAC";
    Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
    Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroFailure";
    Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroTotalSuccess";
    Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_EvacDestroyed";
    return Template;
}


static function X2MissionNarrativeTemplate AddDefaultSmashNGrabMissionNarrativeTemplate()
{
	local X2MissionNarrativeTemplate Template;

	`CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultSmashNGrab_LW');

	Template.MissionType = "SmashNGrab_LW";

	Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.General.GenTactical_SecureRetreat";
	Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.General.GenTactical_ConsiderRetreat";
	Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.General.GenTactical_PartialEVAC";
	Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.General.GenTactical_FullEVAC";
	Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
	Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroFailure";
	Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroTotalSuccess";
	Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.Recover.SKY_RecoGEN_ItemSecured";
	Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_EvacDestroyed";

	return Template;
}

static function X2MissionNarrativeTemplate AddDefaultBigSmashNGrabMissionNarrativeTemplate()
{
	local X2MissionNarrativeTemplate Template;

	`CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'DefaultBigSmashNGrab_LW');

	Template.MissionType = "Ted_BigSmashNGrab_LW";

	Template.NarrativeMoments[0]="X2NarrativeMoments.TACTICAL.General.GenTactical_SecureRetreat";
	Template.NarrativeMoments[1]="X2NarrativeMoments.TACTICAL.General.GenTactical_ConsiderRetreat";
	Template.NarrativeMoments[2]="X2NarrativeMoments.TACTICAL.General.GenTactical_PartialEVAC";
	Template.NarrativeMoments[3]="X2NarrativeMoments.TACTICAL.General.GenTactical_FullEVAC";
	Template.NarrativeMoments[4]="X2NarrativeMoments.TACTICAL.General.GenTactical_SquadWipe";
	Template.NarrativeMoments[5]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroFailure";
	Template.NarrativeMoments[6]="X2NarrativeMoments.TACTICAL.General.GenTactical_MissionExtroTotalSuccess";
	Template.NarrativeMoments[7]="X2NarrativeMoments.TACTICAL.Recover.SKY_RecoGEN_ItemSecured";
	Template.NarrativeMoments[8]="X2NarrativeMoments.TACTICAL.RescueVIP.Central_Rescue_VIP_EvacDestroyed";

	return Template;
}

static function X2MissionNarrativeTemplate AddSupplyExtractionMissionNarrativeTemplate()
{
	local X2MissionNarrativeTemplate Template;

	`CREATE_X2MISSIONNARRATIVE_TEMPLATE(Template, 'SupplyExtraction_LW');

	Template.MissionType = "SupplyExtraction_LW";

	Template.NarrativeMoments[0]="XPACK_NarrativeMoments.X2_XP_CEN_T_Supply_Extract_XCOM_Taking_Losses";
	Template.NarrativeMoments[1]="XPACK_NarrativeMoments.X2_XP_CEN_T_Supply_Extract_XCOM_Marked_First_Crate";
	Template.NarrativeMoments[2]="XPACK_NarrativeMoments.X2_XP_CEN_T_Supply_Extract_XCOM_Marked_ADVENT_crate";
	Template.NarrativeMoments[3]="XPACK_NarrativeMoments.X2_XP_CEN_T_Supply_Extract_Supplies_Recovered_Heavy_Losses";
	Template.NarrativeMoments[4]="XPACK_NarrativeMoments.X2_XP_CEN_T_Supply_Extract_Squad_Wiped";
	Template.NarrativeMoments[5]="XPACK_NarrativeMoments.X2_XP_CEN_T_Supply_Extract_No_Supplies_Recovered";
	Template.NarrativeMoments[6]="XPACK_NarrativeMoments.X2_XP_CEN_T_Supply_Extract_No_Additional_Enemies";
	Template.NarrativeMoments[7]="XPACK_NarrativeMoments.X2_XP_CEN_T_Supply_Extract_Mission_Complete";
	Template.NarrativeMoments[8]="XPACK_NarrativeMoments.X2_XP_CEN_T_Supply_Extract_Mission_Aborted";
	Template.NarrativeMoments[9]="XPACK_NarrativeMoments.X2_XP_CEN_T_Supply_Extract_Late_Crate_Recovered";
	Template.NarrativeMoments[10]="XPACK_NarrativeMoments.X2_XP_CEN_T_Supply_Extract_Intro";
	Template.NarrativeMoments[11]="XPACK_NarrativeMoments.X2_XP_CEN_T_Supply_Extract_First_Crate_Sighted";
	Template.NarrativeMoments[12]="XPACK_NarrativeMoments.X2_XP_CEN_T_Supply_Extract_First_Crate_Recovered";
	Template.NarrativeMoments[13]="XPACK_NarrativeMoments.X2_XP_CEN_T_Supply_Extract_Dont_Destroy_Crates";
	Template.NarrativeMoments[14]="XPACK_NarrativeMoments.X2_XP_CEN_T_Supply_Extract_ADVENT_Marked_More_Crates";
	Template.NarrativeMoments[15]="XPACK_NarrativeMoments.X2_XP_CEN_T_Supply_Extract_ADVENT_Marked_LoS_Crate";
	Template.NarrativeMoments[16]="XPACK_NarrativeMoments.X2_XP_CEN_T_Supply_Extract_ADVENT_Marked_First_Crates";
	Template.NarrativeMoments[17]="XPACK_NarrativeMoments.X2_XP_CEN_T_Supply_Extract_ADVENT_Airlifted_First_Crate";

	return Template;
}
