//--------------------------------------------------------------------------------------- 
//  FILE:    X2Item_LWAlienweapons.uc
//  AUTHOR:	 Amineri / John Lumpkin (Pavonis Interactive)
//  PURPOSE: Defines news weapon for ADVENT/alien forces
//--------------------------------------------------------------------------------------- 
//Extending X2Item_DefaultWeapons to make the config copy pasting easier
class X2Item_LWAlienWeapons extends X2Item_DefaultWeapons config(GameData_WeaponData);

var config WeaponDamageValue MutonM2_LW_GRENADE_BASEDAMAGE;
var config WeaponDamageValue MutonM2_LW_WPN_BASEDAMAGE;
var config WeaponDamageValue MutonM2_LW_MELEEATTACK_BASEDAMAGE;

var config int MutonM2_LW_IDEALRANGE;
var config int MutonM2_LW_GRENADE_iENVIRONMENTDAMAGE;
var config int MutonM2_LW_GRENADE_iRANGE;
var config int MutonM2_LW_GRENADE_iRADIUS;

var config WeaponDamageValue MutonM3_LW_GRENADE_BASEDAMAGE;
var config WeaponDamageValue MutonM3_LW_WPN_BASEDAMAGE;
var config WeaponDamageValue MutonM3_LW_MELEEATTACK_BASEDAMAGE;

var config WeaponDamageValue MutonM4_LW_GRENADE_BASEDAMAGE;
var config WeaponDamageValue MutonM4_LW_WPN_BASEDAMAGE;
var config WeaponDamageValue MutonM4_LW_MELEEATTACK_BASEDAMAGE;

var config WeaponDamageValue MutonM5_LW_GRENADE_BASEDAMAGE;
var config WeaponDamageValue MutonM5_LW_WPN_BASEDAMAGE;
var config WeaponDamageValue MutonM5_LW_MELEEATTACK_BASEDAMAGE;

var config int MutonM3_LW_IDEALRANGE;
var config int MutonM3_LW_WPN_ICLIPSIZE;

var config int MutonM3_LW_GRENADE_iENVIRONMENTDAMAGE;
var config int MutonM3_LW_GRENADE_iRANGE;
var config int MutonM3_LW_GRENADE_iRADIUS;

var config WeaponDamageValue VIPERM2_WPN_BASEDAMAGE;
var config WeaponDamageValue VIPERM3_WPN_BASEDAMAGE;
var config WeaponDamageValue VIPERM4_WPN_BASEDAMAGE;
var config WeaponDamageValue VIPERM5_WPN_BASEDAMAGE;

var config WeaponDamageValue NAJA_WPN_BASEDAMAGE;
var config WeaponDamageValue NAJAM2_WPN_BASEDAMAGE;
var config WeaponDamageValue NAJAM3_WPN_BASEDAMAGE;
var config int NAJA_WPN_ICLIPSIZE;
var config int NAJA_IDEALRANGE;

var config WeaponDamageValue SIDEWINDER_WPN_BASEDAMAGE;
var config WeaponDamageValue SIDEWINDERM2_WPN_BASEDAMAGE;
var config WeaponDamageValue SIDEWINDERM3_WPN_BASEDAMAGE;
var config WeaponDamageValue SIDEWINDERM4_WPN_BASEDAMAGE;
var config WeaponDamageValue SIDEWINDERM5_WPN_BASEDAMAGE;
var config int SIDEWINDER_WPN_ICLIPSIZE;
var config int SIDEWINDER_IDEALRANGE;

var config int ADVSENTRY_IDEALRANGE;
var config WeaponDamageValue AdvSentryM1_WPN_BASEDAMAGE;
var config WeaponDamageValue AdvSentryM2_WPN_BASEDAMAGE;
var config WeaponDamageValue AdvSentryM3_WPN_BASEDAMAGE;
var config WeaponDamageValue AdvSentryM4_WPN_BASEDAMAGE;
var config WeaponDamageValue AdvSentryM5_WPN_BASEDAMAGE;

var config int ADVGRENADIER_FLASHBANGGRENADE_RANGE;
var config int ADVGRENADIER_FLASHBANGGRENADE_RADIUS;
var config int ADVGRENADIER_FLASHBANGGRENADE_IENVIRONMENTDAMAGE;
var config int ADVGRENADIER_FLASHBANGGRENADE_ICLIPSIZE;

var config WeaponDamageValue ADVGRENADIER_FIREGRENADE_BASEDAMAGE;
var config int ADVGRENADIER_FIREGRENADE_RANGE;
var config int ADVGRENADIER_FIREGRENADE_RADIUS;
var config int ADVGRENADIER_FIREGRENADE_COVERAGE;
var config int ADVGRENADIER_FIREGRENADE_ISOUNDRANGE;
var config int ADVGRENADIER_FIREBOMB_IENVIRONMENTDAMAGE;
var config int ADVGRENADIER_FIREBOMB_ICLIPSIZE;

var config WeaponDamageValue ADVGRENADIER_ACIDGRENADE_BASEDAMAGE;
var config int ADVGRENADIER_ACIDGRENADE_RANGE;
var config int ADVGRENADIER_ACIDGRENADE_RADIUS;
var config int ADVGRENADIER_ACIDGRENADE_COVERAGE;
var config int ADVGRENADIER_ACIDGRENADE_ISOUNDRANGE;
var config int ADVGRENADIER_ACIDGRENADE_IENVIRONMENTDAMAGE;
var config int ADVGRENADIER_ACIDGRENADE_ICLIPSIZE;

var config int ADVGRENADIER_IDEALRANGE;

var config WeaponDamageValue ADVROCKETEERM1_ROCKETEERLAUNCHER_BASEDAMAGE;
var config int ADVROCKETEERM1_ROCKETEERLAUNCHER_ISOUNDRANGE;
var config int ADVROCKETEERM1_ROCKETEERLAUNCHER_IENVIRONMENTDAMAGE;
var config int ADVROCKETEERM1_ROCKETEERLAUNCHER_CLIPSIZE;
var config int ADVROCKETEERM1_ROCKETEERLAUNCHER_RANGE;
var config int ADVROCKETEERM1_ROCKETEERLAUNCHER_RADIUS;
var config int ADVROCKETEERM1_IDEALRANGE;

var config WeaponDamageValue ADVGUNNER_WPN_BASEDAMAGE;
var config WeaponDamageValue ADVGUNNERM2_WPN_BASEDAMAGE;
var config WeaponDamageValue ADVGUNNERM3_WPN_BASEDAMAGE;
var config WeaponDamageValue ADVGUNNERM4_WPN_BASEDAMAGE;
var config WeaponDamageValue ADVGUNNERM5_WPN_BASEDAMAGE;
var config int ADVGUNNER_IDEALRANGE;
var config int ADVGUNNER_WPN_CLIPSIZE;

var config int AdvMECArcher_IdealRange;
var config WeaponDamageValue AdvMECArcher_Wpn_BaseDamage;
var config int AdvMECArcher_Wpn_Clipsize;
var config int AdvMECArcher_Wpn_EnvironmentDamage;
var config WeaponDamageValue AdvMECArcher_MicroMissiles_BaseDamage;
var config int AdvMECArcher_MicroMissiles_Clipsize;
var config int AdvMECArcher_MicroMissiles_EnvironmentDamage;
var config int AdvMECArcher_Micromissiles_Range;

var config WeaponDamageValue LWDRONEM1_DRONEWEAPON_BASEDAMAGE;
var config WeaponDamageValue LWDRONEM2_DRONEWEAPON_BASEDAMAGE;
var config WeaponDamageValue LWDRONEM3_DRONEWEAPON_BASEDAMAGE;
var config WeaponDamageValue LWDRONEM4_DRONEWEAPON_BASEDAMAGE;
var config WeaponDamageValue LWDRONEM5_DRONEWEAPON_BASEDAMAGE;

var config int LWDRONE_DRONEWEAPON_ISOUNDRANGE;
var config int LWDRONE_DRONEWEAPON_IENVIRONMENTDAMAGE;
var config int LWDRONE_DRONEWEAPON_RANGE;

var config WeaponDamageValue LWDRONEM1_DRONEREPAIRWEAPON_BASEDAMAGE;
var config WeaponDamageValue LWDRONEM2_DRONEREPAIRWEAPON_BASEDAMAGE;
var config WeaponDamageValue LWDRONEM3_DRONEREPAIRWEAPON_BASEDAMAGE;
var config WeaponDamageValue LWDRONEM4_DRONEREPAIRWEAPON_BASEDAMAGE;
var config WeaponDamageValue LWDRONEM5_DRONEREPAIRWEAPON_BASEDAMAGE;

var config int LWDRONE_DRONEREPAIRWEAPON_ISOUNDRANGE;
var config int LWDRONE_DRONEREPAIRWEAPON_IENVIRONMENTDAMAGE;
var config int LWDRONE_DRONEREPAIRWEAPON_RANGE;

var config int LWDRONE_IDEALRANGE;

var config int ADVVANGUARD_IDEALRANGE;

var config WeaponDamageValue AdvSergeantM1_WPN_BASEDAMAGE;
var config WeaponDamageValue AdvSergeantM2_WPN_BASEDAMAGE;
var config WeaponDamageValue AdvShockTroop_WPN_BASEDAMAGE;
var config WeaponDamageValue AdvCommando_WPN_BASEDAMAGE;
var config WeaponDamageValue AdvVanguard_WPN_BASEDAMAGE;
var config WeaponDamageValue AdvScout_WPN_BASEDAMAGE;
var config WeaponDamageValue AdvGeneralM1_LW_WPN_BASEDAMAGE;
var config WeaponDamageValue AdvGeneralM2_LW_WPN_BASEDAMAGE;

var config WeaponDamageValue ADVTROOPERM4_WPN_BASEDAMAGE;
var config WeaponDamageValue ADVTROOPERM5_WPN_BASEDAMAGE;
var config WeaponDamageValue ADVSHIELDBEARERM4_WPN_BASEDAMAGE;
var config WeaponDamageValue ADVSHIELDBEARERM5_WPN_BASEDAMAGE;

var config array<WeaponDamageValue> SPECTREM3_PSI_ABILITYDAMAGE;
var config array<WeaponDamageValue> SPECTREM4_PSI_ABILITYDAMAGE;
var config WeaponDamageValue SPECTREM3_WPN_BASEDAMAGE;
var config WeaponDamageValue SPECTREM4_WPN_BASEDAMAGE;

var config WeaponDamageValue GATEKEEPERM2_WPN_BASEDAMAGE;
var config WeaponDamageValue GATEKEEPERM3_WPN_BASEDAMAGE;

var config WeaponDamageValue SECTOPODM2_WPN_BASEDAMAGE;
var config WeaponDamageValue SECTOPODM3_WPN_BASEDAMAGE;

var config WeaponDamageValue ANDROMEDONM2_WPN_BASEDAMAGE;
var config WeaponDamageValue ANDROMEDONM3_WPN_BASEDAMAGE;

var config WeaponDamageValue ANDROMEDONROBOT_MELEEATTACKM2_BASEDAMAGE;
var config WeaponDamageValue ANDROMEDONROBOT_MELEEATTACKM3_BASEDAMAGE;

var config WeaponDamageValue AdvMEC_M3_MicroMissiles_BaseDamage;
var config WeaponDamageValue AdvMEC_M4_MicroMissiles_BaseDamage;
var config WeaponDamageValue AdvMEC_M5_MicroMissiles_BaseDamage;

var config WeaponDamageValue ADVMEC_M3_WPN_BASEDAMAGE;
var config WeaponDamageValue ADVMEC_M4_WPN_BASEDAMAGE;
var config WeaponDamageValue ADVMEC_M5_WPN_BASEDAMAGE;

var config WeaponDamageValue ARCHON_BLAZINGPINIONSM2_BASEDAMAGE;
var config WeaponDamageValue ARCHON_BLAZINGPINIONSM3_BASEDAMAGE;

var config WeaponDamageValue ARCHONM2_WPN_BASEDAMAGE;
var config WeaponDamageValue ARCHONM3_WPN_BASEDAMAGE;

var config WeaponDamageValue ARCHON_MELEEATTACKM2_BASEDAMAGE;
var config WeaponDamageValue ARCHON_MELEEATTACKM3_BASEDAMAGE;

var config WeaponDamageValue ADVSTUNLANCERM4_STUNLANCE_BASEDAMAGE;
var config WeaponDamageValue ADVSTUNLANCERM5_STUNLANCE_BASEDAMAGE;

var config WeaponDamageValue ADVSTUNLANCERM4_WPN_BASEDAMAGE;
var config WeaponDamageValue ADVSTUNLANCERM5_WPN_BASEDAMAGE;

var config WeaponDamageValue ADVCAPTAINM4_WPN_BASEDAMAGE;
var config WeaponDamageValue ADVCAPTAINM5_WPN_BASEDAMAGE;

var config WeaponDamageValue ANDROMEDONM2_ACIDBLOB_BASEDAMAGE;
var config WeaponDamageValue ANDROMEDONM3_ACIDBLOB_BASEDAMAGE;

var config WeaponDamageValue ADVCAPTAINM3_GRENADE_BASEDAMAGE;
var config WeaponDamageValue ADVCAPTAINM4_GRENADE_BASEDAMAGE;
var config WeaponDamageValue ADVCAPTAINM5_GRENADE_BASEDAMAGE;

var config WeaponDamageValue ADVTROOPERM3_GRENADE_BASEDAMAGE;
var config WeaponDamageValue ADVTROOPERM4_GRENADE_BASEDAMAGE;
var config WeaponDamageValue ADVTROOPERM5_GRENADE_BASEDAMAGE;

var config WeaponDamageValue SECTOIDM2_WPN_BASEDAMAGE;
var config WeaponDamageValue SECTOIDM3_WPN_BASEDAMAGE;
var config WeaponDamageValue SECTOIDM4_WPN_BASEDAMAGE;
var config WeaponDamageValue SECTOIDM5_WPN_BASEDAMAGE;

var config WeaponDamageValue PSIZOMBIE_MELEEATTACKM2_BASEDAMAGE;
var config WeaponDamageValue PSIZOMBIE_MELEEATTACKM3_BASEDAMAGE;
var config WeaponDamageValue PSIZOMBIE_MELEEATTACKM4_BASEDAMAGE;
var config WeaponDamageValue PSIZOMBIE_MELEEATTACKM5_BASEDAMAGE;

var config WeaponDamageValue ADVPRIESTM4_WPN_BASEDAMAGE;
var config WeaponDamageValue ADVPRIESTM5_WPN_BASEDAMAGE;

var config WeaponDamageValue BERSERKERM2_MELEEATTACK_BASEDAMAGE;
var config WeaponDamageValue BERSERKERM3_MELEEATTACK_BASEDAMAGE;
var config WeaponDamageValue BERSERKERM4_MELEEATTACK_BASEDAMAGE;
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	`LWTrace("  >> X2Item_LWAlienWeapons.CreateTemplates()");
	
	Templates.AddItem(CreateMuton_LWGrenade('MutonM2_LWGrenade', default.MutonM2_LW_GRENADE_BASEDAMAGE));
	Templates.AddItem(CreateMuton_LWGrenade('MutonM3_LWGrenade', default.MutonM3_LW_GRENADE_BASEDAMAGE));
	Templates.AddItem(CreateMuton_LWGrenade('MutonM4_LWGrenade', default.MutonM4_LW_GRENADE_BASEDAMAGE));
	Templates.AddItem(CreateMuton_LWGrenade('MutonM5_LWGrenade', default.MutonM5_LW_GRENADE_BASEDAMAGE));
	Templates.AddItem(CreateTemplate_MutonCenturion_LW_WPN('MutonM2_LW_WPN', default.MutonM2_LW_WPN_BASEDAMAGE));
	Templates.AddItem(CreateTemplate_MutonCenturion_LW_WPN('MutonM3_LW_WPN', default.MutonM3_LW_WPN_BASEDAMAGE));
	Templates.AddItem(CreateTemplate_MutonElite_LW_WPN('MutonM4_LW_WPN',default.MutonM4_LW_WPN_BASEDAMAGE));
	Templates.AddItem(CreateTemplate_MutonElite_LW_WPN('MutonM5_LW_WPN',default.MutonM5_LW_WPN_BASEDAMAGE));

	Templates.AddItem(CreateTemplate_Muton_LW_MeleeAttack('MutonM2_LW_MeleeAttack', default.MutonM2_LW_MELEEATTACK_BASEDAMAGE));
	Templates.AddItem(CreateTemplate_Muton_LW_MeleeAttack('MutonM3_LW_MeleeAttack', default.MutonM3_LW_MELEEATTACK_BASEDAMAGE));
	Templates.AddItem(CreateTemplate_Muton_LW_MeleeAttack('MutonM4_LW_MeleeAttack', default.MutonM4_LW_MELEEATTACK_BASEDAMAGE));
	Templates.AddItem(CreateTemplate_Muton_LW_MeleeAttack('MutonM5_LW_MeleeAttack', default.MutonM5_LW_MELEEATTACK_BASEDAMAGE));

	//Templates.AddItem(CreateMutonM3_LWGrenade());
	
	Templates.AddItem(CreateTemplate_Naja_WPN('NajaM1_WPN'));
	Templates.AddItem(CreateTemplate_Naja_WPN('NajaM2_WPN'));
	Templates.AddItem(CreateTemplate_Naja_WPN('NajaM3_WPN'));

	Templates.AddItem(CreateTemplate_Sidewinder_WPN('SidewinderM1_WPN'));
	Templates.AddItem(CreateTemplate_Sidewinder_WPN('SidewinderM2_WPN'));
	Templates.AddItem(CreateTemplate_Sidewinder_WPN('SidewinderM3_WPN'));

	Templates.AddItem(CreateTemplate_ViperMX_WPN('ViperM2_LW_WPN'));
	Templates.AddItem(CreateTemplate_ViperMX_WPN('ViperM3_LW_WPN'));
	Templates.AddItem(CreateTemplate_ViperMX_WPN('ViperM4_LW_WPN'));
	Templates.AddItem(CreateTemplate_ViperMX_WPN('ViperM5_LW_WPN'));

	Templates.AddItem(CreateTemplate_AdvGunner_WPN('AdvGunnerM1_WPN'));
	Templates.AddItem(CreateTemplate_AdvGunner_WPN('AdvGunnerM2_WPN'));
	Templates.AddItem(CreateTemplate_AdvGunner_WPN('AdvGunnerM3_WPN'));
	
	Templates.AddItem(CreateTemplate_AdvSentry_WPN('AdvSentryM1_WPN'));
	Templates.AddItem(CreateTemplate_AdvSentry_WPN('AdvSentryM2_WPN'));
	Templates.AddItem(CreateTemplate_AdvSentry_WPN('AdvSentryM3_WPN'));
	Templates.AddItem(CreateTemplate_AdvSentry_WPN('AdvSentryM4_WPN'));
	Templates.AddItem(CreateTemplate_AdvSentry_WPN('AdvSentryM5_WPN'));

	Templates.AddItem(CreateTemplate_AdvGrenadier_GrenadeLauncher('AdvGrenadierM1_GrenadeLauncher'));
	Templates.AddItem(CreateTemplate_AdvGrenadier_GrenadeLauncher('AdvGrenadierM2_GrenadeLauncher'));
	Templates.AddItem(CreateTemplate_AdvGrenadier_GrenadeLauncher('AdvGrenadierM3_GrenadeLauncher'));

	Templates.AddItem(CreateTemplate_AdvGrenadier_Flashbang());
	Templates.AddItem(CreateTemplate_AdvGrenadier_FireGrenade());
	Templates.AddItem(CreateTemplate_AdvGrenadier_AcidGrenade());

	Templates.AddItem(CreateHeavyPoweredArmor());
	Templates.AddItem(CreateTemplate_AdvRocketeerM1_RocketLauncher());

	Templates.AddItem(CreateTemplate_AdvMECArcher_WPN());
	Templates.AddItem(CreateTemplate_AdvMECArcher_Shoulder_WPN());

	Templates.AddItem(CreateTemplate_LWDrone_WPN('LWDroneM1_WPN'));
	Templates.AddItem(CreateTemplate_LWDrone_WPN('LWDroneM2_WPN'));
	Templates.AddItem(CreateTemplate_LWDrone_WPN('LWDroneM3_WPN'));
	Templates.AddItem(CreateTemplate_LWDrone_WPN('LWDroneM4_WPN'));
	Templates.AddItem(CreateTemplate_LWDrone_WPN('LWDroneM5_WPN'));
	
	Templates.AddItem(CreateTemplate_LWDroneRepair_WPN('LWDroneRepairM1_WPN'));
	Templates.AddItem(CreateTemplate_LWDroneRepair_WPN('LWDroneRepairM2_WPN'));
	Templates.AddItem(CreateTemplate_LWDroneRepair_WPN('LWDroneRepairM3_WPN'));
	Templates.AddItem(CreateTemplate_LWDroneRepair_WPN('LWDroneRepairM4_WPN'));
	Templates.AddItem(CreateTemplate_LWDroneRepair_WPN('LWDroneRepairM5_WPN'));

	Templates.AddItem(CreateTemplate_AdvElite_WPN('AdvVanguard_WPN'));
	Templates.AddItem(CreateTemplate_AdvElite_WPN('AdvShockTroop_WPN'));
	Templates.AddItem(CreateTemplate_AdvElite_WPN('AdvSergeantM1_WPN'));
	Templates.AddItem(CreateTemplate_AdvElite_WPN('AdvSergeantM2_WPN'));
	Templates.AddItem(CreateTemplate_AdvElite_WPN('AdvScout_WPN'));
	Templates.AddItem(CreateTemplate_AdvElite_WPN('AdvCommando_WPN'));
	Templates.AddItem(CreateTemplate_AdvElite_WPN('AdvGeneralM1_LW_WPN'));
	Templates.AddItem(CreateTemplate_AdvElite_WPN('AdvGeneralM2_LW_WPN'));

	Templates.AddItem(CreateTemplate_AdvElite_WPN('AdvTrooperM4_WPN'));
	Templates.AddItem(CreateTemplate_AdvElite_WPN('AdvTrooperM5_WPN'));

	Templates.AddItem(CreateTemplate_AdvElite_WPN('AdvStunlancerM4_WPN'));
	Templates.AddItem(CreateTemplate_AdvElite_WPN('AdvStunlancerM5_WPN'));


	Templates.AddItem(CreateTemplate_AdvElite_WPN('AdvShieldbearerM4_WPN'));
	Templates.AddItem(CreateTemplate_AdvElite_WPN('AdvShieldbearerM5_WPN'));

	Templates.AddItem(CreateTemplate_AdvElite_WPN('AdvCaptainM4_WPN'));
	Templates.AddItem(CreateTemplate_AdvElite_WPN('AdvCaptainM5_WPN'));

	Templates.AddItem(CreateTemplate_Hunter_Flashbang());	

	Templates.AddItem(CreateTemplate_AdvStunLancer_StunLance_LW('AdvStunLancerM4_StunLance'));
	Templates.AddItem(CreateTemplate_AdvStunLancer_StunLance_LW('AdvStunLancerM5_StunLance'));

	Templates.AddItem(CreateTemplate_PsiZombie_MeleeAttack_LW('PsiZombie_MeleeAttackM2'));
	Templates.AddItem(CreateTemplate_PsiZombie_MeleeAttack_LW('PsiZombie_MeleeAttackM3'));
	Templates.AddItem(CreateTemplate_PsiZombie_MeleeAttack_LW('PsiZombie_MeleeAttackM4'));
	Templates.AddItem(CreateTemplate_PsiZombie_MeleeAttack_LW('PsiZombie_MeleeAttackM5'));

	Templates.AddItem(CreateTemplate_AndromedonRobot_MeleeAttack_LW('AndromedonRobot_MeleeAttackM2'));
	Templates.AddItem(CreateTemplate_AndromedonRobot_MeleeAttack_LW('AndromedonRobot_MeleeAttackM3'));

	Templates.AddItem(CreateTemplate_Archon_MeleeAttack_LW('ArchonStaffM2'));
	Templates.AddItem(CreateTemplate_Archon_MeleeAttack_LW('ArchonStaffM3'));


	Templates.AddItem(CreateTemplate_Archon_LW_WPN('ArchonM2_WPN'));
	Templates.AddItem(CreateTemplate_Archon_LW_WPN('ArchonM3_WPN'));

	Templates.AddItem(CreateTemplate_AdvMEC_LW_WPN('AdvMec_M3_WPN'));
	Templates.AddItem(CreateTemplate_AdvMEC_LW_WPN('AdvMec_M4_WPN'));
	Templates.AddItem(CreateTemplate_AdvMEC_LW_WPN('AdvMec_M5_WPN'));

	Templates.AddItem(CreateTemplate_AdvMEC_Shoulder_LW_WPN('AdvMEC_M3_Shoulder_WPN'));
	Templates.AddItem(CreateTemplate_AdvMEC_Shoulder_LW_WPN('AdvMEC_M4_Shoulder_WPN'));
	Templates.AddItem(CreateTemplate_AdvMEC_Shoulder_LW_WPN('AdvMEC_M5_Shoulder_WPN'));

	Templates.AddItem(CreateTemplate_Andromedon_LW_WPN('AndromedonM2_WPN'));
	Templates.AddItem(CreateTemplate_Andromedon_LW_WPN('AndromedonM3_WPN'));

	Templates.AddItem(CreateTemplate_Spectre_LW_WPN('SpectreM3_WPN', default.SPECTREM3_WPN_BASEDAMAGE));
	Templates.AddItem(CreateTemplate_Spectre_LW_WPN('SpectreM4_WPN', default.SPECTREM4_WPN_BASEDAMAGE));
	Templates.AddItem(CreateTemplate_Spectre_PsiAttack_LW('SpectreM3_PsiAttack', default.SPECTREM3_PSI_ABILITYDAMAGE));
	Templates.AddItem(CreateTemplate_Spectre_PsiAttack_LW('SpectreM4_PsiAttack', default.SPECTREM3_PSI_ABILITYDAMAGE));

	Templates.AddItem(CreateTemplate_Gatekeeper_LW_WPN('GatekeeperM2_WPN', default.GATEKEEPERM2_WPN_BASEDAMAGE));
	Templates.AddItem(CreateTemplate_Gatekeeper_LW_WPN('GatekeeperM3_WPN', default.GATEKEEPERM3_WPN_BASEDAMAGE));

	Templates.AddItem(CreateTemplate_Sectopod_LW_WPN('SectopodM2_WPN', default.SECTOPODM2_WPN_BASEDAMAGE));
	Templates.AddItem(CreateTemplate_Sectopod_LW_WPN('SectopodM3_WPN', default.SECTOPODM3_WPN_BASEDAMAGE));


	Templates.AddItem(CreateAcidBlob_LW('AcidBlobM2', default.ANDROMEDONM2_ACIDBLOB_BASEDAMAGE));
	Templates.AddItem(CreateAcidBlob_LW('AcidBlobM3', default.ANDROMEDONM3_ACIDBLOB_BASEDAMAGE));

	Templates.AddItem(CreateAdventGrenade('AdventTrooperMk3Grenade', default.ADVTROOPERM3_GRENADE_BASEDAMAGE));
	Templates.AddItem(CreateAdventGrenade('AdventTrooperMk4Grenade', default.ADVTROOPERM4_GRENADE_BASEDAMAGE));
	Templates.AddItem(CreateAdventGrenade('AdventTrooperMk5Grenade', default.ADVTROOPERM5_GRENADE_BASEDAMAGE));
	
	Templates.AddItem(CreateAdventGrenade('AdventCaptainMk3Grenade', default.ADVCAPTAINM3_GRENADE_BASEDAMAGE));
	Templates.AddItem(CreateAdventGrenade('AdventCaptainMk4Grenade', default.ADVCAPTAINM4_GRENADE_BASEDAMAGE));
	Templates.AddItem(CreateAdventGrenade('AdventCaptainMk5Grenade', default.ADVCAPTAINM5_GRENADE_BASEDAMAGE));

	Templates.AddItem(CreateTemplate_Archon_Blazing_Pinions_LW_WPN('Archon_Blazing_PinionsM2_WPN'));
	Templates.AddItem(CreateTemplate_Archon_Blazing_Pinions_LW_WPN('Archon_Blazing_PinionsM3_WPN'));

	
	Templates.AddItem(CreateTemplate_Sectoid_LW_WPN('SectoidM2_WPN', default.SECTOIDM2_WPN_BASEDAMAGE));
	Templates.AddItem(CreateTemplate_Sectoid_LW_WPN('SectoidM3_WPN', default.SECTOIDM3_WPN_BASEDAMAGE));
	Templates.AddItem(CreateTemplate_Sectoid_LW_WPN('SectoidM4_WPN', default.SECTOIDM4_WPN_BASEDAMAGE));
	Templates.AddItem(CreateTemplate_Sectoid_LW_WPN('SectoidM5_WPN', default.SECTOIDM5_WPN_BASEDAMAGE));

	Templates.AddItem(CreateTemplate_AdvPriest_WPN('AdvPriestM4_WPN', default.ADVPRIESTM4_WPN_BASEDAMAGE));
	Templates.AddItem(CreateTemplate_AdvPriest_WPN('AdvPriestM5_WPN', default.ADVPRIESTM5_WPN_BASEDAMAGE));

	Templates.AddItem(CreateTemplate_AdvPriest_PsiAmp('AdvPriestM4_PsiAmp'));
	Templates.AddItem(CreateTemplate_AdvPriest_PsiAmp('AdvPriestM5_PsiAmp'));

	Templates.AddItem(CreateTemplate_AndromedonRobot_MeleeAttack_LW('Berserker_MeleeAttack'));
	Templates.AddItem(CreateTemplate_AndromedonRobot_MeleeAttack_LW('Berserker_MeleeAttackM2'));
	Templates.AddItem(CreateTemplate_AndromedonRobot_MeleeAttack_LW('Berserker_MeleeAttackM3'));
	Templates.AddItem(CreateTemplate_AndromedonRobot_MeleeAttack_LW('Berserker_MeleeAttackM4'));

	return Templates;
}


static function X2DataTemplate CreateTemplate_MutonCenturion_LW_WPN(name TemplateName, WeaponDamageValue Damage)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.MutonRifle";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = Damage;
	Template.iClipSize = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.MutonM2_LW_IDEALRANGE;

	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('Suppression');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Execute');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Muton_Rifle.WP_MutonRifle";  // re-use base-game Muton Rifle art assets

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	return Template;
}

static function X2DataTemplate CreateTemplate_Muton_LW_MeleeAttack(name TemplateName, WeaponDamageValue Damage)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);
	
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'baton';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.Sword";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Muton_Bayonet.WP_MutonBayonet"; // re-use base game art assets for melee weapon
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.Aim = class'X2Item_DefaultWeapons'.default.GENERIC_MELEE_ACCURACY;

	Template.iRange = 0;
	Template.iRadius = 1;
	Template.NumUpgradeSlots = 2;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;
	Template.iIdealRange = 1;

	Template.BaseDamage = Damage;
	Template.BaseDamage.DamageType='Melee';
	Template.iSoundRange = 2;
	Template.iEnvironmentDamage = 10;

	//Build Data
	Template.StartingItem = false;
	Template.CanBeBuilt = false;

	Template.Abilities.AddItem('Bayonet');
	//Template.Abilities.AddItem('BayonetCharge');
	Template.Abilities.AddItem('CounterattackBayonet');

	return Template;
}


static function X2DataTemplate CreateMuton_LWGrenade(name TemplateName, WeaponDamageValue Damage)
{
	local X2GrenadeTemplate Template;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;

	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, 'MutonM2_LWGrenade');

	Template.strImage = "img:///UILibrary_StrategyImages.InventoryIcons.Inv_AlienGrenade";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.BaseDamage = Damage;
	Template.iEnvironmentDamage = default.MutonM2_LW_GRENADE_iENVIRONMENTDAMAGE;
	Template.iRange = default.MutonM2_LW_GRENADE_iRANGE;
	Template.iRadius = default.MutonM2_LW_GRENADE_iRADIUS;
	Template.iClipSize = 1;
	Template.iSoundRange = class'X2Item_DefaultGrenades'.default.GRENADE_SOUND_RANGE;
	Template.DamageTypeTemplateName = 'Explosion';
	
	Template.Abilities.AddItem('ThrowGrenade');
	Template.Abilities.AddItem('GrenadeFuse');

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);
	Template.LaunchedGrenadeEffects.AddItem(WeaponDamageEffect);
	
	Template.GameArchetype = "WP_Grenade_Alien.WP_Grenade_Alien";

	Template.iPhysicsImpulse = 10;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 50;

	return Template;
}

// Muton Elite Gear

static function X2DataTemplate CreateTemplate_MutonElite_LW_WPN(name TemplateName, WeaponDamageValue Damage)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'MutonM3_LW_WPN');
	
	Template.WeaponPanelImage = "_BeamCannon";
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'cannon';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///UILibrary_Common.UI_BeamCannon.BeamCannon_Base";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.MutonM3_LW_WPN_BASEDAMAGE;
	Template.iClipSize = default.MutonM3_LW_WPN_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.LMG_BEAM_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.LMG_BEAM_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.MutonM3_LW_IDEALRANGE;

	Template.DamageTypeTemplateName = 'Projectile_BeamXCom';
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('Suppression');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Execute');

	//Template.Abilities.AddItem('LightEmUp');

 	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWMutonM3Rifle.Archetypes.WP_MutonM3Rifle_Base";  // upscaled, recolored beam cannon

	Template.AddDefaultAttachment('Mag', "LWMutonM3Rifle.Meshes.SK_MutonM3Rifle_Mag",, "img:///UILibrary_Common.UI_BeamCannon.BeamCannon_MagA");
    Template.AddDefaultAttachment('Core', "LWMutonM3Rifle.Meshes.SK_MutonM3Rifle_Core",, "img:///UILibrary_Common.UI_BeamCannon.BeamCannon_CoreA");
    Template.AddDefaultAttachment('Core_Center', "LWMutonM3Rifle.Meshes.SK_MutonM3Rifle_Core_Center");
    Template.AddDefaultAttachment('HeatSink', "LWMutonM3Rifle.Meshes.SK_MutonM3Rifle_HeatSink",, "img:///UILibrary_Common.UI_BeamCannon.BeamCannon_HeatsinkA");
    Template.AddDefaultAttachment('Suppressor', "LWMutonM3Rifle.Meshes.SK_MutonM3Rifle_Suppressor",, "img:///UILibrary_Common.UI_BeamCannon.BeamCannon_SupressorA");

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	return Template;
}

static function X2DataTemplate CreateMutonM3_LWGrenade()
{
	local X2GrenadeTemplate Template;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;

	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, 'MutonM3_LWGrenade');

	Template.strImage = "img:///UILibrary_StrategyImages.InventoryIcons.Inv_AlienGrenade";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.BaseDamage = default.MutonM3_LW_GRENADE_BASEDAMAGE;
	Template.iEnvironmentDamage = default.MutonM3_LW_GRENADE_iENVIRONMENTDAMAGE;
	Template.iRange = default.MutonM3_LW_GRENADE_iRANGE;
	Template.iRadius = default.MutonM3_LW_GRENADE_iRADIUS;
	Template.iClipSize = 1;
	Template.iSoundRange = class'X2Item_DefaultGrenades'.default.GRENADE_SOUND_RANGE;
	Template.DamageTypeTemplateName = 'Explosion';
	
	Template.Abilities.AddItem('ThrowGrenade');
	Template.Abilities.AddItem('GrenadeFuse');

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);
	Template.LaunchedGrenadeEffects.AddItem(WeaponDamageEffect);
	
	Template.GameArchetype = "WP_Grenade_Alien.WP_Grenade_Alien";

	Template.iPhysicsImpulse = 10;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 50;

	return Template;
}


static function X2DataTemplate CreateTemplate_Naja_WPN(name TemplateName)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);
	
	Template.WeaponPanelImage = "_ConventionalRifle";                  
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'sniper_rifle';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_Base";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.LONG_BEAM_RANGE;

	if (TemplateName == 'NajaM1_WPN')
		Template.BaseDamage = default.NAJA_WPN_BASEDAMAGE;
	if (TemplateName == 'NajaM2_WPN')
		Template.BaseDamage = default.NAJAM2_WPN_BASEDAMAGE;
	if (TemplateName == 'NajaM3_WPN')
		Template.BaseDamage = default.NAJAM3_WPN_BASEDAMAGE;

	Template.iClipSize = default.NAJA_WPN_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.NAJA_IDEALRANGE;

	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('SniperStandardFire');
	Template.Abilities.AddItem('SniperRifleOverwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	//Issue #162, Naja should not be able to move and shoot so made rifle shot cost 2 AP.
	Template.iTypicalActionCost = 2;

	if (TemplateName == 'NajaM1_WPN' || TemplateName == 'NajaM2_WPN' || TemplateName == 'NajaM3_WPN')
	{
		Template.Abilities.AddItem('DamnGoodGround');
	}
	if (TemplateName == 'NajaM2_WPN' || TemplateName == 'NajaM3_WPN')
	{
		Template.Abilities.AddItem('Executioner_LW'); //weapon perk
		Template.Abilities.AddItem('LongWatch'); // weapon perk
	}
	if (TemplateName == 'NajaM3_WPN')
	{
		//Template.Abilities.AddItem('DeathfromAbove_LW');
	}

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "NajaRifle.WP_NajaRifle"; 

	//Template.AddDefaultAttachment('Optic', "BeamSniper.Meshes.SM_BeamSniper_OpticA", , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_OpticA");
	Template.AddDefaultAttachment('Mag', "NajaRifle.Meshes.SM_BeamSniper_MagB", , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_MagB");
	//Template.AddDefaultAttachment('Suppressor', "BeamSniper.Meshes.SM_BeamSniper_SuppressorA", , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_SupressorA");
	Template.AddDefaultAttachment('Core', "NajaRifle.Meshes.SM_NajaRifle_CoreB", , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_CoreB");
	Template.AddDefaultAttachment('HeatSink', "NajaRifle.Meshes.SM_BeamSniper_HeatSinkA", , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_HeatsinkA");
	Template.AddDefaultAttachment('Autoloader', "NajaRifle.Meshes.SM_BeamSniper_MagC", , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_AutoLoader");

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	return Template;
}

static function X2DataTemplate CreateTemplate_Sidewinder_WPN(name TemplateName)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'smg';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///LWSidewinderSMG.Textures.LWBeamSMG_Common"; 
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = class'X2Item_SMGWeapon'.default.MIDSHORT_CONVENTIONAL_RANGE;
	
	if (TemplateName == 'SidewinderM1_WPN')
		Template.BaseDamage = default.SIDEWINDER_WPN_BASEDAMAGE;
	if (TemplateName == 'SidewinderM2_WPN')
		Template.BaseDamage = default.SIDEWINDERM2_WPN_BASEDAMAGE;
	if (TemplateName == 'SidewinderM3_WPN')
		Template.BaseDamage = default.SIDEWINDERM3_WPN_BASEDAMAGE;

	Template.iClipSize = default.SIDEWINDER_WPN_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.SIDEWINDER_IDEALRANGE;

	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	if (TemplateName == 'SidewinderM1_WPN' || TemplateName == 'SidewinderM2_WPN' || TemplateName == 'SidewinderM3_WPN')
	{
		//future use
	}
	if (TemplateName == 'SidewinderM2_WPN' || TemplateName == 'SidewinderM3_WPN')
	{	
		//future use
	}
	if (TemplateName == 'SidewinderM3_WPN')
	{
		Template.Abilities.AddItem('HuntersInstinct');
	}
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWSidewinderSMG.Archetypes.WP_Sidewinder_SMG";  

	//Template.AddDefaultAttachment('Optic', "BeamSniper.Meshes.SM_BeamSniper_OpticA", , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_OpticA");
	Template.AddDefaultAttachment('Mag', "LWSidewinderSMG.Meshes.SM_BeamAssaultRifle_MagB");
	//Template.AddDefaultAttachment('Suppressor', "BeamSniper.Meshes.SM_BeamSniper_SuppressorA", , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_SupressorA");
	Template.AddDefaultAttachment('Core', "LWSidewinderSMG.Meshes.SK_LWBeamSMG_CoreA");
	//Template.AddDefaultAttachment('HeatSink', "NajaRifle.Meshes.SM_BeamSniper_HeatSinkA", , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_HeatsinkA");
	//Template.AddDefaultAttachment('Autoloader', "NajaRifle.Meshes.SM_BeamSniper_MagC", , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_AutoLoader");

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	return Template;
}

static function X2DataTemplate CreateTemplate_AdvGunner_WPN(name TemplateName)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'cannon';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.UI_MagCannon.MagCannon_Base";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;

	if (TemplateName == 'AdvGunnerM1_WPN')
		Template.BaseDamage = default.ADVGUNNER_WPN_BASEDAMAGE;
	if (TemplateName == 'AdvGunnerM2_WPN')
		Template.BaseDamage = default.ADVGUNNERM2_WPN_BASEDAMAGE;
	if (TemplateName == 'AdvGunnerM3_WPN')
		Template.BaseDamage = default.ADVGUNNERM3_WPN_BASEDAMAGE;
	if (TemplateName == 'AdvGunnerM4_WPN')
		Template.BaseDamage = default.ADVGUNNERM4_WPN_BASEDAMAGE;
	if (TemplateName == 'AdvGunnerM5_WPN')
		Template.BaseDamage = default.ADVGUNNERM5_WPN_BASEDAMAGE;
	Template.iClipSize = default.ADVGUNNER_WPN_CLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.LMG_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.LMG_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.ADVGUNNER_IDEALRANGE;

	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('AreaSuppression');
/*
	if (TemplateName == 'AdvGunnerM2_WPN' || TemplateName == 'AdvGunnerM3_WPN')
	{
		Template.Abilities.AddItem('LockedOn');
	}
	if (TemplateName == 'AdvGunnerM3_WPN')
	{
		Template.Abilities.AddItem('TraverseFire');
		Template.Abilities.AddItem('CoveringFire');
	}
	*/
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWAdvGunner.Archetypes.WP_Cannon_MG";  

	Template.AddDefaultAttachment('Mag', "LWAdvGunner.Meshes.SK_MagCannon_Mag", , "img:///UILibrary_Common.UI_MagCannon.MagCannon_MagA");
	Template.AddDefaultAttachment('Reargrip',   "LWAdvGunner.Meshes.SM_MagCannon_Reargrip");
	Template.AddDefaultAttachment('Foregrip', "LWAdvGunner.Meshes.SM_MagCannon_Stock", , "img:///UILibrary_Common.UI_MagCannon.MagCannon_StockA");

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	return Template;
}


static function X2DataTemplate CreateTemplate_AdvSentry_WPN(name TemplateName)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);

	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventAssaultRifle";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
    Template.iClipSize = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ICLIPSIZE; 

    Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	if (TemplateName == 'AdvSentryM1_WPN')
		Template.BaseDamage = default.AdvSentryM1_WPN_BASEDAMAGE;
	if (TemplateName == 'AdvSentryM2_WPN')
		Template.BaseDamage = default.AdvSentryM2_WPN_BASEDAMAGE;
	if (TemplateName == 'AdvSentryM3_WPN')
		Template.BaseDamage = default.AdvSentryM3_WPN_BASEDAMAGE;
	if (TemplateName == 'AdvSentryM4_WPN')
		Template.BaseDamage = default.AdvSentryM4_WPN_BASEDAMAGE;
	if (TemplateName == 'AdvSentryM5_WPN')
		Template.BaseDamage = default.AdvSentryM4_WPN_BASEDAMAGE;

    Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
    Template.iIdealRange = default.ADVSENTRY_IDEALRANGE; //check this

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
		
	/*
	if (TemplateName == 'AdvSentryM2_WPN')
	{
		Template.Abilities.AddItem('CoolUnderPressure');
		Template.Abilities.AddItem('Sentinel');
		Template.Abilities.AddItem('CoveringFire');
	}

	if (TemplateName == 'AdvSentryM3_WPN')
	{
		Template.Abilities.AddItem('CoolUnderPressure');
		Template.Abilities.AddItem('Sentinel_LW');
		Template.Abilities.AddItem('CoveringFire');
	}
*/
	Template.GameArchetype = "WP_AssaultRifle_MG.WP_AssaultRifle_MG_Advent";
	Template.iPhysicsImpulse = 5;
	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;
	Template.DamageTypeTemplateName = 'Projectile_MagAdvent';

	return Template;
}


static function X2DataTemplate CreateTemplate_AdvGrenadier_GrenadeLauncher(name TemplateName)
{
	local X2GrenadeLauncherTemplate Template;

	`CREATE_X2TEMPLATE(class'X2GrenadeLauncherTemplate', Template, TemplateName);

	Template.strImage = "img:///UILibrary_Common.MagSecondaryWeapons.MagLauncher";
	Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";

	Template.InventorySlot = eInvSlot_SecondaryWeapon;

	Template.iSoundRange = class'X2Item_DefaultGrenades'.default.ADVGRENADELAUNCHER_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultGrenades'.default.ADVGRENADELAUNCHER_IENVIRONMENTDAMAGE;
	Template.TradingPostValue = 18;
	Template.iClipSize = class'X2Item_DefaultGrenades'.default.ADVGRENADELAUNCHER_ICLIPSIZE;
	Template.Tier = 1;
	Template.iIdealRange = default.ADVGRENADIER_IDEALRANGE;

	// REMOVED because this seems to rely on HasSoldierAbility, which doesn't work for advent/aliens
	//if (TemplateName == 'AdvGrenadeLauncherM1')
	//{
		//Template.IncreaseGrenadeRadius = default.ADVGRENADIERM1_GRENADELAUNCHER_RADIUSBONUS;
		//Template.IncreaseGrenadeRange = default.ADVGRENADIERM1_GRENADELAUNCHER_RANGEBONUS;
	//}
	//if (TemplateName == 'AdvGrenadeLauncherM2')
	//{
		//Template.IncreaseGrenadeRadius = default.ADVGRENADIERM2_GRENADELAUNCHER_RADIUSBONUS;
		//Template.IncreaseGrenadeRange = default.ADVGRENADIERM2_GRENADELAUNCHER_RANGEBONUS;
	//}
	//if (TemplateName == 'AdvGrenadeLauncherM3')
	//{
		//Template.IncreaseGrenadeRadius = default.ADVGRENADIERM3_GRENADELAUNCHER_RADIUSBONUS;
		//Template.IncreaseGrenadeRange = default.ADVGRENADIERM3_GRENADELAUNCHER_RANGEBONUS;
	//}

	//Template.Abilities.AddItem('LaunchGrenade');  // remove this to prevent a "null" LaunchGrenade ability which confuses the AI
	Template.Abilities.AddItem('AdventGrenadeLauncher');

	Template.GameArchetype = "AdvGrenadeLauncher.WP_AdvGrenadeLauncher";

	Template.CanBeBuilt = false;

	return Template;
}

static function X2DataTemplate CreateTemplate_AdvGrenadier_Flashbang()
{
	local X2GrenadeTemplate Template;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;

	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, 'AdvGrenadierFlashbangGrenade');

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons..Inv_Flashbang_Grenade";
	Template.AddAbilityIconOverride('ThrowGrenade', "img:///UILibrary_PerkIcons.UIPerk_grenade_flash");
	Template.AddAbilityIconOverride('LaunchGrenade', "img:///UILibrary_PerkIcons.UIPerk_grenade_flash");
	Template.iRange = default.ADVGRENADIER_FLASHBANGGRENADE_RANGE;
	Template.iRadius = default.ADVGRENADIER_FLASHBANGGRENADE_RADIUS;
	
	Template.bFriendlyFire = false;
	Template.bFriendlyFireWarning = false;
	Template.Abilities.AddItem('ThrowGrenade');

	Template.ThrownGrenadeEffects.AddItem(class'X2StatusEffects'.static.CreateDisorientedStatusEffect());

	//We need to have an ApplyWeaponDamage for visualization, even if the grenade does 0 damage (makes the unit flinch, shows overwatch removal)
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);

	Template.LaunchedGrenadeEffects = Template.ThrownGrenadeEffects;
	
	Template.GameArchetype = "WP_Grenade_Flashbang.WP_Grenade_Flashbang";

	Template.iEnvironmentDamage = default.ADVGRENADIER_FLASHBANGGRENADE_IENVIRONMENTDAMAGE;
	Template.iClipSize = default.ADVGRENADIER_FLASHBANGGRENADE_ICLIPSIZE;

	return Template;
}

static function X2DataTemplate CreateTemplate_AdvGrenadier_FireGrenade()
{
	local X2GrenadeTemplate Template;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;

	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, 'AdvGrenadierFireGrenade');

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Firebomb";
	Template.AddAbilityIconOverride('ThrowGrenade', "img:///UILibrary_PerkIcons.UIPerk_grenade_firebomb");
	Template.AddAbilityIconOverride('LaunchGrenade', "img:///UILibrary_PerkIcons.UIPerk_grenade_firebomb");

	Template.BaseDamage = default.ADVGRENADIER_FIREGRENADE_BASEDAMAGE;
	Template.iRange = default.ADVGRENADIER_FIREGRENADE_RANGE;
	Template.iRadius = default.ADVGRENADIER_FIREGRENADE_RADIUS;
	Template.fCoverage = default.ADVGRENADIER_FIREGRENADE_COVERAGE;
	Template.iSoundRange = default.ADVGRENADIER_FIREGRENADE_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ADVGRENADIER_FIREBOMB_IENVIRONMENTDAMAGE;
	Template.iClipSize = default.ADVGRENADIER_FIREBOMB_ICLIPSIZE;
	Template.Tier = 1;

	Template.Abilities.AddItem('ThrowGrenade');
	Template.Abilities.AddItem('GrenadeFuse');

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);
	Template.ThrownGrenadeEffects.AddItem(new class'X2Effect_ApplyFireToWorld');
	Template.ThrownGrenadeEffects.AddItem(class'X2StatusEffects'.static.CreateBurningStatusEffect(2, 1));
	Template.LaunchedGrenadeEffects = Template.ThrownGrenadeEffects;
	
	Template.GameArchetype = "WP_Grenade_Fire.WP_Grenade_Fire";

	Template.iPhysicsImpulse = 10;

	return Template;
}

static function X2DataTemplate CreateTemplate_AdvGrenadier_AcidGrenade()
{
	local X2GrenadeTemplate Template;
	local X2Effect_ApplyAcidToWorld WeaponEffect;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;

	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, 'AdvGrenadierAcidGrenade');

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Acid_Bomb";
	Template.AddAbilityIconOverride('ThrowGrenade', "img:///UILibrary_PerkIcons.UIPerk_grenade_acidbomb");
	Template.AddAbilityIconOverride('LaunchGrenade', "img:///UILibrary_PerkIcons.UIPerk_grenade_acidbomb");

	Template.BaseDamage = default.ADVGRENADIER_ACIDGRENADE_BASEDAMAGE;
	Template.iRange = default.ADVGRENADIER_ACIDGRENADE_RANGE;
	Template.iRadius = default.ADVGRENADIER_ACIDGRENADE_RADIUS;
	Template.fCoverage = default.ADVGRENADIER_ACIDGRENADE_COVERAGE;
	Template.iSoundRange = default.ADVGRENADIER_ACIDGRENADE_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ADVGRENADIER_ACIDGRENADE_IENVIRONMENTDAMAGE;
	Template.iClipSize = default.ADVGRENADIER_ACIDGRENADE_ICLIPSIZE;
	Template.Tier = 1;
	
	Template.Abilities.AddItem('ThrowGrenade');
	Template.Abilities.AddItem('GrenadeFuse');
	
	WeaponEffect = new class'X2Effect_ApplyAcidToWorld';	
	Template.ThrownGrenadeEffects.AddItem(WeaponEffect);
	Template.ThrownGrenadeEffects.AddItem(class'X2StatusEffects'.static.CreateAcidBurningStatusEffect(1,0));
	// immediate damage
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);

	Template.LaunchedGrenadeEffects = Template.ThrownGrenadeEffects;
	
	Template.GameArchetype = "WP_Grenade_Acid.WP_Grenade_Acid";

	return Template;
}

static function X2DataTemplate CreateTemplate_AdvRocketeerM1_RocketLauncher()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AdvRocketeerM1_RocketLauncher');
	Template.WeaponCat = 'heavy';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Rocket_Launcher";
	Template.EquipSound = "StrategyUI_Heavy_Weapon_Equip";

	Template.BaseDamage = default.ADVROCKETEERM1_ROCKETEERLAUNCHER_BASEDAMAGE;
	Template.iSoundRange = default.ADVROCKETEERM1_ROCKETEERLAUNCHER_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ADVROCKETEERM1_ROCKETEERLAUNCHER_IENVIRONMENTDAMAGE;
	Template.iClipSize = default.ADVROCKETEERM1_ROCKETEERLAUNCHER_CLIPSIZE;
	Template.iRange = default.ADVROCKETEERM1_ROCKETEERLAUNCHER_RANGE;
	Template.iRadius = default.ADVROCKETEERM1_ROCKETEERLAUNCHER_RADIUS;
	
	Template.InventorySlot = eInvSlot_HeavyWeapon;
	Template.StowedLocation = eSlot_HeavyWeapon;
	Template.GameArchetype = "WP_Heavy_RocketLauncher.WP_Heavy_RocketLauncher";
	//Template.GameArchetype = "WP_Heavy_RocketLauncher.WP_Heavy_RocketLauncher_Powered";
	Template.bMergeAmmo = true;
	Template.DamageTypeTemplateName = 'Explosion';

	Template.Abilities.AddItem('RocketLauncher');
	Template.Abilities.AddItem('RocketFuse');

	Template.CanBeBuilt = false;
		
	return Template;
}

static function X2DataTemplate CreateHeavyPoweredArmor()
{
	local X2ArmorTemplate Template;

	`CREATE_X2TEMPLATE(class'X2ArmorTemplate', Template, 'AdvRocketeer_HeavyPoweredArmor');
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Marauder_Armor";
	Template.ItemCat = 'armor';
	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.TradingPostValue = 120;
	Template.PointsToComplete = 0;
	Template.bHeavyWeapon = true;

	Template.InventorySlot = eInvSlot_Armor;

	//Template.Abilities.AddItem('HeavyPoweredArmorStats');
	//Template.Abilities.AddItem('HighCoverGenerator');
	Template.ArmorTechCat = 'powered';
	Template.Tier = 4;
	Template.AkAudioSoldierArmorSwitch = 'WAR';
	Template.EquipNarrative = "X2NarrativeMoments.Strategy.CIN_ArmorIntro_PoweredHeavy";
	Template.EquipSound = "StrategyUI_Armor_Equip_Powered";

	//Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, class'X2Ability_ItemGrantedAbilitySet'.default.HEAVY_POWERED_HEALTH_BONUS, true);
	//Template.SetUIStatMarkup(class'XLocalizedData'.default.ArmorLabel, eStat_ArmorMitigation, class'X2Ability_ItemGrantedAbilitySet'.default.HEAVY_POWERED_MITIGATION_AMOUNT);
	
	return Template;
}



static function X2DataTemplate CreateTemplate_AdvMECArcher_WPN()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AdvMECArcher_WPN');
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventMecGun";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.ADVMECArcher_WPN_BASEDAMAGE;
	Template.iClipSize = default.AdvMECArcher_Wpn_Clipsize;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.AdvMECArcher_Wpn_EnvironmentDamage;
	Template.iIdealRange = default.ADVMECArcher_IDEALRANGE;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Suppression');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_AdvMec_Gun.WP_AdvMecGun"; 

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	Template.DamageTypeTemplateName = 'Projectile_MagAdvent';

	return Template;
}

static function X2DataTemplate CreateTemplate_AdvMECArcher_Shoulder_WPN()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AdvMECArcher_Shoulder_WPN');
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'shoulder_launcher';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventMecGun";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.AdvMECArcher_MicroMissiles_BaseDamage;
	Template.iClipSize = default.AdvMECArcher_MicroMissiles_Clipsize;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.AdvMECArcher_MicroMissiles_EnvironmentDamage;
	Template.iIdealRange = default.ADVMECArcher_IDEALRANGE;
	
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('MicroMissiles');
	Template.Abilities.AddItem('MicroMissileFuse');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWAdvMecArcher.Archetypes.WP_AdvMecBigLauncher"; 

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;
	Template.iRange = default.AdvMECArcher_Micromissiles_Range;


	// This controls how much arc this projectile may have and how many times it may bounce
	Template.WeaponPrecomputedPathData.InitialPathTime = 1.5;
	Template.WeaponPrecomputedPathData.MaxPathTime = 2.5;
	Template.WeaponPrecomputedPathData.MaxNumberOfBounces = 0;

	Template.DamageTypeTemplateName = 'Explosion';

	return Template;
}


static function X2DataTemplate CreateTemplate_LWDrone_WPN(name TemplateName)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_LWAlienPack.LWAdventDrone_ArcWeapon";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	if(TemplateName == 'LWDroneM1_WPN')
		Template.BaseDamage = default.LWDRONEM1_DRONEWEAPON_BASEDAMAGE;
	if(TemplateName == 'LWDroneM2_WPN')
		Template.BaseDamage = default.LWDRONEM2_DRONEWEAPON_BASEDAMAGE;

	Template.iRange = default.LWDRONE_DRONEWEAPON_RANGE;
	Template.iSoundRange = default.LWDRONE_DRONEWEAPON_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.LWDRONE_DRONEWEAPON_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.LWDRONE_IDEALRANGE;
	Template.RangeAccuracy = class'X2Item_SMGWeapon'.default.MIDSHORT_CONVENTIONAL_RANGE;

	Template.iClipSize = 99;
	Template.InfiniteAmmo = true;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('LWDroneShock');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWDroneWeapon.Archetypes.WP_DroneBeam";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	return Template;
}

static function X2DataTemplate CreateTemplate_LWDroneRepair_WPN(name TemplateName)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.GatekeeperEyeball"; 
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	if(TemplateName == 'LWDroneRepairM1_WPN')
		Template.BaseDamage = default.LWDRONEM1_DRONEREPAIRWEAPON_BASEDAMAGE;
	if(TemplateName == 'LWDroneRepairM2_WPN')
		Template.BaseDamage = default.LWDRONEM2_DRONEREPAIRWEAPON_BASEDAMAGE;

	Template.iRange = default.LWDRONE_DRONEREPAIRWEAPON_RANGE;
	Template.iSoundRange = default.LWDRONE_DRONEREPAIRWEAPON_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.LWDRONE_DRONEREPAIRWEAPON_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.LWDRONE_IDEALRANGE;

	Template.iClipSize = 99;
	Template.InfiniteAmmo = true;
	
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('LWDroneRepair');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWDroneWeapon.Archetypes.WP_DroneRepair";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	return Template;
}

static function X2DataTemplate CreateTemplate_ViperMX_WPN(name TemplateName)
{
    local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);
    Template.WeaponPanelImage = "_ConventionalRifle";
    Template.ItemCat = 'Weapon';
    Template.WeaponCat = 'rifle';
    Template.WeaponTech = 'beam';
    Template.strImage = "img:///UILibrary_Common.AlienWeapons.ViperRifle";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability
    Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	
	if (TemplateName == 'ViperM2_LW_WPN')
		Template.BaseDamage = default.VIPERM2_WPN_BASEDAMAGE;
	if (TemplateName == 'ViperM3_LW_WPN')
		Template.BaseDamage = default.VIPERM3_WPN_BASEDAMAGE;
	if (TemplateName == 'ViperM4_LW_WPN')
		Template.BaseDamage = default.VIPERM4_WPN_BASEDAMAGE;
	if (TemplateName == 'ViperM5_LW_WPN')
		Template.BaseDamage = default.VIPERM5_WPN_BASEDAMAGE;


	Template.iClipSize = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ICLIPSIZE;
    Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
    Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
    Template.iIdealRange = class'X2Item_DefaultWeapons'.default.VIPER_IDEALRANGE;
    Template.DamageTypeTemplateName = 'Heavy';
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
    Template.Abilities.AddItem('StandardShot');
    Template.Abilities.AddItem('overwatch');
    Template.Abilities.AddItem('OverwatchShot');
    Template.Abilities.AddItem('Reload');
    Template.Abilities.AddItem('HotLoadAmmo');
    Template.GameArchetype = "WP_Viper_Rifle.WP_ViperRifle";
    Template.iPhysicsImpulse = 5;
    Template.CanBeBuilt = false;
    Template.TradingPostValue = 30;
    return Template;
}

static function X2DataTemplate CreateTemplate_AdvElite_WPN(name TemplateName)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);

	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventAssaultRifle";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
    Template.iClipSize = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ICLIPSIZE; 

    Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	
	switch (TemplateName)
	{
		case 'AdvSergeantM1_WPN': Template.BaseDamage = default.AdvSergeantM1_WPN_BASEDAMAGE; break;
		case 'AdvSergeantM2_WPN': Template.BaseDamage = default.AdvSergeantM2_WPN_BASEDAMAGE;  break;
		case 'AdvShockTroop_WPN': Template.BaseDamage = default.AdvShockTroop_WPN_BASEDAMAGE;  break;
		case 'AdvCommando_WPN': Template.BaseDamage = default.AdvCommando_WPN_BASEDAMAGE; break;
		case 'AdvVanguard_WPN': Template.BaseDamage = default.AdvVanguard_WPN_BASEDAMAGE; break;
		case 'AdvScout_WPN': Template.BaseDamage = default.AdvScout_WPN_BASEDAMAGE; break;
		case 'AdvGeneralM1_LW_WPN': Template.BaseDamage = default.AdvGeneralM1_LW_WPN_BASEDAMAGE; break;
		case 'AdvGeneralM2_LW_WPN': Template.BaseDamage = default.AdvGeneralM2_LW_WPN_BASEDAMAGE; break;

		case 'AdvTrooperM4_WPN': Template.BaseDamage = default.AdvTrooperM4_WPN_BASEDAMAGE; break;
		case 'AdvTrooperM5_WPN': Template.BaseDamage = default.AdvTrooperM5_WPN_BASEDAMAGE; break;

		case 'AdvShieldbearerM4_WPN': Template.BaseDamage = default.AdvSHIELDBEARERM4_WPN_BASEDAMAGE; break;
		case 'AdvShieldbearerM5_WPN': Template.BaseDamage = default.AdvSHIELDBEARERM5_WPN_BASEDAMAGE; break;

		case 'AdvStunLancerM4_WPN': Template.BaseDamage = default.AdvSTUNLANCERM4_WPN_BASEDAMAGE; break;
		case 'AdvStunLancerM5_WPN': Template.BaseDamage = default.AdvSTUNLANCERM5_WPN_BASEDAMAGE; break;

		case 'AdvCaptainM4_WPN': Template.BaseDamage = default.ADVCAPTAINM4_WPN_BASEDAMAGE; break;
		case 'AdvCaptainM5_WPN': Template.BaseDamage = default.ADVCAPTAINM5_WPN_BASEDAMAGE; break;


		default: break;
	}

    Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
    Template.iIdealRange = default.ADVVANGUARD_IDEALRANGE; 

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	Template.GameArchetype = "WP_AssaultRifle_MG.WP_AssaultRifle_MG_Advent";
	Template.iPhysicsImpulse = 5;
	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;
	Template.DamageTypeTemplateName = 'Projectile_MagAdvent';

	return Template;
}


	static function X2DataTemplate CreateTemplate_Hunter_Flashbang()
{
	local X2GrenadeTemplate Template;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;

	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, 'HunterFlashbang');

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons..Inv_Flashbang_Grenade";
	Template.AddAbilityIconOverride('ThrowGrenade', "img:///UILibrary_PerkIcons.UIPerk_grenade_flash");
	Template.AddAbilityIconOverride('LaunchGrenade', "img:///UILibrary_PerkIcons.UIPerk_grenade_flash");
	Template.iRange = default.ADVGRENADIER_FLASHBANGGRENADE_RANGE;
	Template.iRadius = default.ADVGRENADIER_FLASHBANGGRENADE_RADIUS;
	
	Template.bFriendlyFire = false;
	Template.bFriendlyFireWarning = false;
	Template.Abilities.AddItem('ThrowGrenade');

	Template.ThrownGrenadeEffects.AddItem(class'X2StatusEffects'.static.CreateDisorientedStatusEffect());

	//We need to have an ApplyWeaponDamage for visualization, even if the grenade does 0 damage (makes the unit flinch, shows overwatch removal)
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);

	Template.LaunchedGrenadeEffects = Template.ThrownGrenadeEffects;
	
	Template.GameArchetype = "WP_Grenade_Flashbang.WP_Grenade_Flashbang";

	Template.iEnvironmentDamage = default.ADVGRENADIER_FLASHBANGGRENADE_IENVIRONMENTDAMAGE;
	Template.iClipSize = 50;

	return Template;
}


static function X2DataTemplate CreateTemplate_Archon_LW_WPN(name TemplateName)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.ArchonStaff";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	if(TemplateName == 'ArchonM2_WPN')
	{
		Template.BaseDamage = default.ARCHONM2_WPN_BASEDAMAGE;
	}
	if(TemplateName == 'ArchonM3_WPN')
	{
		Template.BaseDamage = default.ARCHONM3_WPN_BASEDAMAGE;
	}
	Template.RangeAccuracy = default.FLAT_CONVENTIONAL_RANGE;


	Template.iClipSize = default.ASSAULTRIFLE_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.ARCHON_IDEALRANGE;

	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Archon_Rifle.WP_ArchonRifle";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	return Template;
}

static function X2DataTemplate CreateTemplate_Archon_Blazing_Pinions_LW_WPN(name TemplateName)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Archon_Blazing_Pinions_WPN');
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.ArchonStaff";

	Template.RangeAccuracy = default.FLAT_CONVENTIONAL_RANGE;
	Template.iClipSize = 0;
	Template.iSoundRange = 0;
	Template.iEnvironmentDamage = default.ARCHON_BLAZINGPINIONS_ENVDAMAGE;
	Template.iIdealRange = 0;
	Template.iPhysicsImpulse = 5;
	Template.DamageTypeTemplateName = 'BlazingPinions';

	if(TemplateName == 'Archon_Blazing_PinionsM2_WPN')
	{
		Template.BaseDamage = default.ARCHON_BLAZINGPINIONSM2_BASEDAMAGE;
	}
	if(TemplateName == 'Archon_Blazing_PinionsM3_WPN')
	{
		Template.BaseDamage = default.ARCHON_BLAZINGPINIONSM3_BASEDAMAGE;
	}

	Template.InventorySlot = eInvSlot_Utility;
	Template.Abilities.AddItem('BlazingPinionsStage2');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Archon_Blazing_Pinions.WP_Blazing_Pinions_CV";

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 0;

	return Template;
}

	static function X2DataTemplate CreateTemplate_Archon_MeleeAttack_LW(name TemplateName)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'ArchonStaff');

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'baton';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.ArchonStaff";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Archon_Staff.WP_ArchonStaff";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.Aim = default.GENERIC_MELEE_ACCURACY;

	Template.iRange = 0;
	Template.iRadius = 1;
	Template.NumUpgradeSlots = 2;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;
	Template.iIdealRange = 1;

	if(Templatename == 'ArchonStaffM2')
	{
		Template.BaseDamage = default.ARCHON_MELEEATTACKM2_BASEDAMAGE;
	}
	if(Templatename == 'ArchonStaffM3')
	{
		Template.BaseDamage = default.ARCHON_MELEEATTACKM3_BASEDAMAGE;
	}

	Template.BaseDamage.DamageType='Melee';
	Template.iSoundRange = 2;
	Template.iEnvironmentDamage = 10;

	//Build Data
	Template.StartingItem = false;
	Template.CanBeBuilt = false;

	Template.Abilities.AddItem('StandardMelee');
	Template.AddAbilityIconOverride('StandardMelee', "img:///UILibrary_PerkIcons.UIPerk_archon_beatdown");

	return Template;
}

static function X2DataTemplate CreateTemplate_AndromedonRobot_MeleeAttack_LW(name TemplateName)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);
	
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'baton';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_PerkIcons.UIPerk_muton_punch";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Sword_CV.WP_Sword_CV";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.Aim = class'X2Item_DefaultWeapons'.default.GENERIC_MELEE_ACCURACY;

	Template.iRange = 2;
	Template.iRadius = 1;
	Template.NumUpgradeSlots = 2;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;
	Template.iIdealRange = 1;
	if(Templatename == 'AndromedonRobot_MeleeAttackM2')
	{
		Template.BaseDamage = default.ANDROMEDONROBOT_MELEEATTACKM2_BASEDAMAGE;
	}
	if(Templatename == 'AndromedonRobot_MeleeAttackM3')
	{
		Template.BaseDamage = default.ANDROMEDONROBOT_MELEEATTACKM3_BASEDAMAGE;
	}
	if(Templatename == 'Berserker_MeleeAttack')
	{
		Template.BaseDamage = default.BERSERKER_MELEEATTACK_BASEDAMAGE;
	}
	if(Templatename == 'Berserker_MeleeAttackM2')
	{
		Template.BaseDamage = default.BERSERKERM2_MELEEATTACK_BASEDAMAGE;
	}
	if(Templatename == 'Berserker_MeleeAttackM3')
	{
		Template.BaseDamage = default.BERSERKERM3_MELEEATTACK_BASEDAMAGE;
	}
	if(Templatename == 'Berserker_MeleeAttackM4')
	{
		Template.BaseDamage = default.BERSERKERM4_MELEEATTACK_BASEDAMAGE;
	}

	Template.BaseDamage.DamageType='Melee';
	Template.iSoundRange = 2;
	Template.iEnvironmentDamage = 10;

	//Build Data
	Template.StartingItem = false;
	Template.CanBeBuilt = false;

	//Template.Abilities.AddItem('BigDamnPunch');

	return Template;
}


static function X2DataTemplate CreateTemplate_PsiZombie_MeleeAttack_LW(name TemplateName)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);
	
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'melee';
	Template.WeaponTech = 'alien';
	Template.strImage = "img:///UILibrary_PerkIcons.UIPerk_muton_punch";
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.StowedLocation = eSlot_RightHand;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Zombiefist.WP_Zombiefist";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.iRange = 2;
	Template.iRadius = 1;
	Template.NumUpgradeSlots = 2;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;
	Template.iIdealRange = 1;
	if(Templatename == 'PsiZombie_MeleeAttackM2')
	{
		Template.BaseDamage = default.PSIZOMBIE_MELEEATTACKM2_BASEDAMAGE;
	}
	if(Templatename == 'PsiZombie_MeleeAttackM3')
	{
		Template.BaseDamage = default.PSIZOMBIE_MELEEATTACKM3_BASEDAMAGE;
	}
	if(Templatename == 'PsiZombie_MeleeAttackM4')
	{
		Template.BaseDamage = default.PSIZOMBIE_MELEEATTACKM4_BASEDAMAGE;
	}
	if(Templatename == 'PsiZombie_MeleeAttackM5')
	{
		Template.BaseDamage = default.PSIZOMBIE_MELEEATTACKM5_BASEDAMAGE;
	}
	Template.BaseDamage.DamageType='Melee';
	Template.iSoundRange = 2;
	Template.iEnvironmentDamage = 10;

	//Build Data
	Template.StartingItem = false;
	Template.CanBeBuilt = false;

	Template.bDisplayWeaponAndAmmo = false;

	Template.Abilities.AddItem('StandardMelee');

	return Template;
}

// ********************************* Stun Lance
static function X2DataTemplate CreateTemplate_AdvStunLancer_StunLance_LW(name TemplateName)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'baton';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_PerkIcons.UIPerk_muton_punch";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Adv_StunLancer.WP_StunLance";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.Aim = default.GENERIC_MELEE_ACCURACY;
	//Template.Aim = 10;

	Template.iRange = 0;
	Template.iRadius = 1;
	Template.NumUpgradeSlots = 2;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;
	Template.iIdealRange = 1;

	if(TemplateName == 'AdvStunLancerM4_StunLance')
	{
		Template.BaseDamage = default.ADVSTUNLANCERM4_STUNLANCE_BASEDAMAGE;

	}	
	if(TemplateName == 'AdvStunLancerM5_StunLance')
	{
		Template.BaseDamage = default.ADVSTUNLANCERM5_STUNLANCE_BASEDAMAGE;
	}

	Template.BaseDamage.DamageType='Melee';
	Template.iSoundRange = 2;
	Template.iEnvironmentDamage = 0;

	//Build Data
	Template.StartingItem = false;
	Template.CanBeBuilt = false;

	Template.Abilities.AddItem('StunLance');

	return Template;
}

static function X2DataTemplate CreateTemplate_AdvMEC_LW_WPN(name TemplateName)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventMecGun";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = default.FLAT_CONVENTIONAL_RANGE;
	Template.iClipSize = default.ASSAULTRIFLE_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.ADVMEC_M2_IDEALRANGE;
	
	if(TemplateName == 'AdvMEC_M3_WPN')
	{
		Template.BaseDamage = default.ADVMEC_M3_WPN_BASEDAMAGE;
	}	
	if(TemplateName == 'AdvMEC_M4_WPN')
	{
		Template.BaseDamage = default.ADVMEC_M4_WPN_BASEDAMAGE;
	}
	if(TemplateName == 'AdvMEC_M5_WPN')
	{
		Template.BaseDamage = default.ADVMEC_M5_WPN_BASEDAMAGE;
	}	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Suppression');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_AdvMec_Gun.WP_AdvMecGun";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	Template.DamageTypeTemplateName = 'Projectile_MagAdvent';

	return Template;
}

static function X2DataTemplate CreateTemplate_AdvMEC_Shoulder_LW_WPN(name TemplateName)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'shoulder_launcher';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventMecGun";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = default.FLAT_CONVENTIONAL_RANGE;
	Template.iClipSize = 2;
	Template.iSoundRange = default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.ADVMEC_M2_IDEALRANGE;

		if(TemplateName == 'AdvMEC_M3_Shoulder_WPN')
		{
			Template.BaseDamage = default.AdvMEC_M3_MicroMissiles_BaseDamage;
		}	
		if(TemplateName == 'AdvMEC_M4_Shoulder_WPN')
		{
			Template.BaseDamage = default.AdvMEC_M4_MicroMissiles_BaseDamage;
		}
		if(TemplateName == 'AdvMEC_M5_Shoulder_WPN')
		{
			Template.BaseDamage = default.AdvMEC_M5_MicroMissiles_BaseDamage;
		}	

	
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('MicroMissiles');
	Template.Abilities.AddItem('MicroMissileFuse');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_AdvMec_Launcher.WP_AdvMecLauncher";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;
	Template.iRange = 20;


	// This controls how much arc this projectile may have and how many times it may bounce
	Template.WeaponPrecomputedPathData.InitialPathTime = 1.5;
	Template.WeaponPrecomputedPathData.MaxPathTime = 2.5;
	Template.WeaponPrecomputedPathData.MaxNumberOfBounces = 0;

	Template.DamageTypeTemplateName = 'Explosion';

	return Template;
}

	static function X2DataTemplate CreateTemplate_Andromedon_LW_WPN(name TemplateName)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AndromedonRifle";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = default.FLAT_CONVENTIONAL_RANGE;
	Template.iClipSize = default.ASSAULTRIFLE_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.ANDROMEDON_IDEALRANGE;

	if(TemplateName == 'AndromedonM2_WPN')
	{
		Template.BaseDamage = default.ANDROMEDONM2_WPN_BASEDAMAGE;
	}	
	if(TemplateName == 'AndromedonM3_WPN')
	{
		Template.BaseDamage = default.ANDROMEDONM3_WPN_BASEDAMAGE;
	}		
	
	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Andromedon_Cannon.WP_AndromedonCannon";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	return Template;
}

	static function X2DataTemplate CreateTemplate_Spectre_PsiAttack_LW(name TemplateName, array<WeaponDamageValue> Damage)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'psiamp';
	Template.WeaponTech = 'alien';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Psi_Amp";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	// This all the resources; sounds, animations, models, physics, the works.

	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.ExtraDamage = Damage;

	Template.CanBeBuilt = false;

	Template.DamageTypeTemplateName = 'Psi';

	Template.Abilities.AddItem('Horror');

	return Template;
}

static function X2DataTemplate CreateTemplate_Spectre_LW_WPN(name TemplateName, WeaponDamageValue Damage)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);

	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.ViperRifle";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_MAGNETIC_RANGE;
	Template.BaseDamage = Damage;
	Template.iClipSize = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = class'X2Item_XpackWeapons'.default.SPECTREM1_IDEALRANGE;

	Template.DamageTypeTemplateName = 'Heavy';

	Template.InfiniteAmmo = true;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_SpectreRifle.WP_SpectreRifle";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	return Template;
}

static function X2DataTemplate CreateTemplate_Gatekeeper_LW_WPN(name TemplateName, WeaponDamageValue Damage)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Gatekeeper_WPN');
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.GatekeeperEyeball";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.BaseDamage = Damage;
	Template.iClipSize = 1;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Gatekeeper_Anima_Gate.WP_Gatekeeper_Anima_Gate";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	return Template;
}

static function X2DataTemplate CreateTemplate_Sectopod_LW_WPN(name TemplateName, WeaponDamageValue Damage)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);
	
	Template.WeaponPanelImage = "_BeamSniperRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventTurret";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = default.FLAT_BEAM_RANGE;
	Template.BaseDamage = default.SECTOPOD_WPN_BASEDAMAGE;
	Template.iClipSize = default.ASSAULTRIFLE_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.SECTOPOD_IDEALRANGE;

	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('Blaster');
	Template.Abilities.AddItem('BlasterDuringCannon');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Sectopod_Turret.WP_Sectopod_Turret";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	return Template;
}


static function X2DataTemplate CreateAcidBlob_LW(name TemplateName, WeaponDamageValue Damage)
{
	local X2WeaponTemplate Template;

	Template = new class'X2WeaponTemplate';
	
	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'grenade';
	Template.strImage = "img:///UILibrary_StrategyImages.InventoryIcons.Inv_SmokeGrenade";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.GameArchetype = "WP_Andromedon_AcidAttack.WP_Andromedon_AcidAttack";
	Template.CanBeBuilt = false;

	Template.iRange = 14;
	Template.iRadius = 4;
	Template.iClipSize = 1;
	Template.InfiniteAmmo = true;

	Template.iSoundRange = class'X2Item_DefaultGrenades'.default.GRENADE_SOUND_RANGE;
	Template.bSoundOriginatesFromOwnerLocation = false;

	Template.BaseDamage.DamageType = 'Acid';
	Template.BaseDamage = Damage;
	
	Template.InventorySlot = eInvSlot_Utility;
	Template.StowedLocation = eSlot_None;
	Template.Abilities.AddItem('AcidBlob');

	return Template;
}

static function X2DataTemplate CreateAdventGrenade(name TemplateName, WeaponDamageValue Damage)
{
	local X2GrenadeTemplate Template;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;

	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, TemplateName);

	Template.strImage = "img:///UILibrary_StrategyImages.InventoryIcons.Inv_FragGrenade";
	Template.EquipSound = "StrategyUI_Grenade_Equip";

	Template.BaseDamage = Damage;
	Template.iEnvironmentDamage = class'X2Item_DefaultGrenades'.default.FRAGGRENADE_IENVIRONMENTDAMAGE;
	Template.iRange = 10;
	Template.iRadius = 4;
	Template.iClipSize = 1;
	Template.iSoundRange = class'X2Item_DefaultGrenades'.default.GRENADE_SOUND_RANGE;
	Template.DamageTypeTemplateName = 'Explosion';

	Template.Abilities.AddItem('ThrowGrenade');
	Template.Abilities.AddItem('GrenadeFuse');
	
	Template.GameArchetype = "WP_Grenade_Frag.WP_Grenade_Frag";

	Template.iPhysicsImpulse = 10;

	Template.StartingItem = false;
	Template.CanBeBuilt = false;

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);
	Template.LaunchedGrenadeEffects.AddItem(WeaponDamageEffect);

	return Template;
}

static function X2DataTemplate CreateTemplate_Sectoid_LW_WPN(name TemplateName, WeaponDamageValue Damage)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.SectoidPistol";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = Damage;
	Template.iClipSize = default.ASSAULTRIFLE_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.SECTOID_IDEALRANGE;

	Template.DamageTypeTemplateName = 'Heavy';
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Sectoid_ArmPistol.WP_SectoidPistol";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	return Template;
}

static function X2DataTemplate CreateTemplate_AdvPriest_WPN(name TemplateName, WeaponDamageValue Damage)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);

	Template.WeaponPanelImage = "_BeamRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventAssaultRifle";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_MAGNETIC_RANGE;
	Template.BaseDamage = Damage;
	Template.iClipSize = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = class'X2Item_XpackWeapons'.default.ADVPRIESTM1_IDEALRANGE;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	// This all the resources; sounds, animations, models, physics, the works.
//BEGIN AUTOGENERATED CODE: Template Overrides 'AdvPriestM1_WPN'
	Template.GameArchetype = "WP_AdvPriestRifle.WP_AdvPriestRifle";
//END AUTOGENERATED CODE: Template Overrides 'AdvPriestM1_WPN'

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	Template.DamageTypeTemplateName = 'Projectile_BeamAvatar';

	return Template;
}

static function X2DataTemplate CreateTemplate_AdvPriest_PsiAmp(name TemplateName)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);
	Template.WeaponPanelImage = "_PsiAmp";                       // used by the UI. Probably determines iconview of the weapon.
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'psiamp';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Psi_Amp";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.

//BEGIN AUTOGENERATED CODE: Template Overrides 'AdvPriestM2_PsiAmp'
	Template.GameArchetype = "WP_AdvPriestPsiAmp.WP_AdvPriestPsiAmp";
//END AUTOGENERATED CODE: Template Overrides 'AdvPriestM2_PsiAmp'

	Template.Abilities.AddItem('PriestPsiMindControl');
	Template.Abilities.AddItem('PriestStasis');


	if(TemplateName == 'AdvPriestM4_PsiAmp')
	{
		Template.Abilities.AddItem('HolyWarriorM4');
	}
	if(TemplateName == 'AdvPriestM5_PsiAmp')
	{
		Template.Abilities.AddItem('HolyWarriorM5');
	}
	Template.CanBeBuilt = false;

	Template.DamageTypeTemplateName = 'Psi';

	return Template;
}
