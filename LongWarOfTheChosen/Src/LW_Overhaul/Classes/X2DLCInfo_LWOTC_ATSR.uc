class X2DLCInfo_LWOTC_ATSR extends X2DownloadableContentInfo config(LW_Overhaul);

static function FinalizeUnitAbilitiesForInit(XComGameState_Unit UnitState, out array<AbilitySetupData> SetupData, optional XComGameState StartState, optional XComGameState_Player PlayerState, optional bool bMultiplayerDisplay)
{
	`LWTrace("X2DLCInfo_LWOTC_ATSR: FinalizeUnitAbilitiesForInit: " $ UnitState.GetMyTemplateName() $ " - " $ UnitState.GetFullName());
	// Fix new Gauntlet Flamethrower abilities
	class'X2Ability_LW_TechnicalAbilitySet2'.static.HandleFinalizeFlamethrowerAbilities(UnitState, SetupData, StartState);

	`LWTrace("X2DLCInfo_LWOTC_ATSR: FinalizeUnitAbilitiesForInit: Complete");
}
