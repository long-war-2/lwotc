// New mission types

class X2MissionSet_LW extends X2MissionSet;

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2MissionTemplate> Templates;

	// Add LW variants of missions for re-definition without obliterating Mission.ini
    Templates.AddItem(AddMissionTemplate('RecoverItem_LW'));
    Templates.AddItem(AddMissionTemplate('RecoverItemADV_LW'));
    Templates.AddItem(AddMissionTemplate('RecoverItemTrain_LW'));
    Templates.AddItem(AddMissionTemplate('RecoverItemVehicle_LW'));
    Templates.AddItem(AddMissionTemplate('RecoverFlightDevice_LW'));
    Templates.AddItem(AddMissionTemplate('HackWorkstation_LW'));
    Templates.AddItem(AddMissionTemplate('HackWorkstationADV_LW'));
    Templates.AddItem(AddMissionTemplate('HackWorkstationTrain_LW'));
    Templates.AddItem(AddMissionTemplate('SupplyLineRaidATT_LW'));
    Templates.AddItem(AddMissionTemplate('SupplyLineRaidTrain_LW'));
    Templates.AddItem(AddMissionTemplate('SupplyLineRaidConvoy_LW'));
    Templates.AddItem(AddMissionTemplate('DestroyRelay_LW'));
    Templates.AddItem(AddMissionTemplate('SabotageTransmitter_LW'));
    Templates.AddItem(AddMissionTemplate('CovertEscape_LW'));
    Templates.AddItem(AddMissionTemplate('CovertEscape_NonPCP_LW'));
    Templates.AddItem(AddMissionTemplate('ProtectDevice_LW'));
    Templates.AddItem(AddMissionTemplate('ExtractVIP_LW'));
    Templates.AddItem(AddMissionTemplate('RescueVIP_LW'));
    Templates.AddItem(AddMissionTemplate('RescueVIPVehicle_LW'));
    Templates.AddItem(AddMissionTemplate('NeutralizeTarget_LW'));
    Templates.AddItem(AddMissionTemplate('NeutralizeTargetVehicle_LW'));
	Templates.AddItem(AddMissionTemplate('SmashNGrab_LW'));
    //Templates.AddItem(AddMissionTemplate('BigSmashNGrab_LW'));
	Templates.AddItem(AddMissionTemplate('SupplyExtraction_LW'));

	Templates.AddItem(AddMissionTemplate('AssaultNetworkTower_LW')); // used in ProtectRegion / Liberation chain
    
	Templates.AddItem(AddMissionTemplate('AdventFacilityBLACKSITE_LW'));
    Templates.AddItem(AddMissionTemplate('AdventFacilityFORGE_LW'));
    Templates.AddItem(AddMissionTemplate('AdventFacilityPSIGATE_LW'));
    Templates.AddItem(AddMissionTemplate('CentralNetworkBroadcast_LW'));
    Templates.AddItem(AddMissionTemplate('AssaultAlienFortress_LW'));
    
	Templates.AddItem(AddMissionTemplate('SecureUFO_LW'));
    Templates.AddItem(AddMissionTemplate('SabotageAlienFacility_LW'));
    Templates.AddItem(AddMissionTemplate('SabotageAdventMonument_LW'));
    Templates.AddItem(AddMissionTemplate('Terror_LW'));
    Templates.AddItem(AddMissionTemplate('AvengerDefense_LW'));

	Templates.AddItem(AddMissionTemplate('TroopManeuvers_LW'));
	Templates.AddItem(AddMissionTemplate('AssaultAlienBase_LW'));
    Templates.AddItem(AddMissionTemplate('Jailbreak_LW'));
	Templates.AddItem(AddMissionTemplate('Invasion_LW'));
    Templates.AddItem(AddMissionTemplate('Rendezvous_LW'));
    Templates.AddItem(AddMissionTemplate('Defend_LW'));
    Templates.AddItem(AddMissionTemplate('IntelRaid_LW'));
	Templates.AddItem(AddMissionTemplate('SupplyConvoy_LW'));
	Templates.AddItem(AddMissionTemplate('RecruitRaid_LW'));

	return Templates;
}
