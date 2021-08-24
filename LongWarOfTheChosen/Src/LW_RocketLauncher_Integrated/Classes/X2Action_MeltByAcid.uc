class X2Action_MeltByAcid extends X2Action_Death;
//unusued

function Init()
{
	super.Init();

	//XComHumanPawn(XGUnit(UnitState.GetVisualizer()).GetPawn()).Mesh.GlobalAnimRateScale = 1 + CurrentMobilityBonus / 10;
	Destination.Z -= 100;

	//`LOG("Init special death action",, 'IRIACID');
}